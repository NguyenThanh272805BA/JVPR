package vn.edu.eaut.fruitables.service.impl;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.model.dto.ClearanceRecommendationDTO;
import vn.edu.eaut.fruitables.service.IGeminiService;
import vn.edu.eaut.fruitables.service.IInventoryAgentService;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class InventoryAgentServiceImpl implements IInventoryAgentService {

    private static final int SALES_WINDOW_DAYS = 14;
    private static final int MAX_RECOMMENDATIONS = 8;
    private static final long AI_CACHE_TTL_MS = 15 * 60 * 1000L; // 15 phút

    private final IGeminiService geminiService;
    private final Gson gson;

    // Cache phân tích AI theo chữ ký tồn kho để tránh gọi Gemini lặp lại khi reload
    private static String cachedSignature = "";
    private static long cachedAiTimestamp = 0L;
    private static Map<Long, Map<String, String>> cachedAiNarratives = new HashMap<>();
    private static boolean lastUsedAiLlm = false;

    public InventoryAgentServiceImpl() {
        this.geminiService = new GeminiServiceImpl();
        this.gson = new Gson();
    }

    @Override
    public List<ClearanceRecommendationDTO> analyzeInventoryRisks() {
        return analyzeInventoryRisks(false);
    }

    @Override
    public List<ClearanceRecommendationDTO> analyzeInventoryRisks(boolean forceRefresh) {
        List<ClearanceRecommendationDTO> candidates = new ArrayList<>();

        // Quét toàn bộ sản phẩm đang kinh doanh còn tồn kho (loại trừ sản phẩm ảo Giỏ quà Master ID 99)
        String sql = """
            SELECT p.id, p.name, p.price, p.discount_price, p.cost_price, p.stock, p.image_url,
                   COALESCE(p.storage_type, 'NORMAL') AS storage_type,
                   c.name AS cat_name,
                   COALESCE((
                       SELECT SUM(od.quantity)
                       FROM order_details od
                       JOIN orders o ON od.order_id = o.id
                       WHERE od.product_id = p.id
                         AND o.status NOT IN ('CANCELLED', 'RETURNED', 'FAILED')
                         AND o.created_at >= DATE_SUB(NOW(), INTERVAL 14 DAY)
                   ), 0) AS sold_14d,
                   (
                       SELECT DATEDIFF(NOW(), MAX(ir.created_at))
                       FROM inventory_receipt_details ird
                       JOIN inventory_receipts ir ON ird.receipt_id = ir.id
                       WHERE ird.product_id = p.id
                   ) AS days_since_receipt,
                   (
                       SELECT DATEDIFF(NOW(), MAX(o.created_at))
                       FROM order_details od
                       JOIN orders o ON od.order_id = o.id
                       WHERE od.product_id = p.id
                         AND o.status NOT IN ('CANCELLED', 'RETURNED', 'FAILED')
                   ) AS days_since_last_sale
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE p.status = 1 AND p.stock > 0 AND p.id <> 99
            ORDER BY p.stock DESC, p.price DESC
        """;

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ClearanceRecommendationDTO dto = evaluateProductRisk(conn, rs);
                if (dto != null) {
                    candidates.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Sắp xếp theo độ ưu tiên rủi ro (CRITICAL -> HIGH -> MEDIUM) rồi theo giá trị thất thoát dự báo giảm dần
        candidates.sort((a, b) -> {
            int rankDiff = Integer.compare(riskRank(b.getSpoilageRisk()), riskRank(a.getSpoilageRisk()));
            if (rankDiff != 0) return rankDiff;
            return Double.compare(b.getEstimatedWasteLoss(), a.getEstimatedWasteLoss());
        });

        List<ClearanceRecommendationDTO> topList = candidates.size() > MAX_RECOMMENDATIONS
                ? new ArrayList<>(candidates.subList(0, MAX_RECOMMENDATIONS))
                : candidates;

        // Nâng cấp nội dung phân tích bằng Google Gemini LLM (có cache 15 phút + fallback an toàn theo số liệu thật)
        enrichWithGeminiAnalysis(topList, forceRefresh);

        return topList;
    }

    private ClearanceRecommendationDTO evaluateProductRisk(Connection conn, ResultSet rs) throws Exception {
        long id = rs.getLong("id");
        String name = rs.getString("name");
        double price = rs.getDouble("price");
        double costPrice = rs.getDouble("cost_price");
        int stock = rs.getInt("stock");
        String img = rs.getString("image_url");
        String storageType = rs.getString("storage_type");
        String catName = rs.getString("cat_name");
        if (catName == null || catName.trim().isEmpty()) {
            catName = "Nông sản tươi";
        }

        int sold14d = rs.getInt("sold_14d");
        double velocity = Math.round((sold14d / (double) SALES_WINDOW_DAYS) * 10.0) / 10.0;

        Integer daysReceiptObj = rs.getObject("days_since_receipt") != null ? rs.getInt("days_since_receipt") : null;
        Integer daysSaleObj = rs.getObject("days_since_last_sale") != null ? rs.getInt("days_since_last_sale") : null;

        int daysInStock;
        if (daysReceiptObj != null) {
            daysInStock = Math.max(1, daysReceiptObj);
        } else if (daysSaleObj != null) {
            daysInStock = Math.max(2, daysSaleObj);
        } else {
            // Chưa có phiếu nhập kho hoặc đơn bán gần đây -> ước lượng thận trọng theo tồn kho
            daysInStock = stock >= 40 ? 4 : 3;
        }

        // Hạn bảo quản tối ưu theo quy cách bảo quản nông sản
        int shelfLifeDays;
        if ("COLD_CHAIN".equalsIgnoreCase(storageType)) {
            shelfLifeDays = 5;
        } else if ("FRAGILE_GIFT".equalsIgnoreCase(storageType)) {
            shelfLifeDays = 6;
        } else {
            shelfLifeDays = 10;
        }

        // Số ngày dự kiến bán hết theo tốc độ hiện tại
        double daysToSellOut = (velocity >= 0.1) ? Math.round((stock / velocity) * 10.0) / 10.0 : 999.0;
        double shelfRatio = daysInStock / (double) shelfLifeDays;

        // Xác định ngưỡng có rủi ro ứ đọng / hư hao để đưa vào danh sách cần xử lý
        boolean isColdRisk = "COLD_CHAIN".equalsIgnoreCase(storageType) && (stock >= 15 || daysToSellOut > shelfLifeDays);
        boolean isSlowMoving = (daysToSellOut > shelfLifeDays * 1.2 && stock >= 10) || (shelfRatio >= 0.6 && stock >= 5);
        if (!isColdRisk && !isSlowMoving) {
            return null;
        }

        String riskLevel;
        int discountPercent;
        String actionType;

        if (shelfRatio >= 0.8 || ("COLD_CHAIN".equalsIgnoreCase(storageType) && daysToSellOut >= shelfLifeDays * 2.5 && stock >= 30)) {
            riskLevel = "CRITICAL";
            discountPercent = 30;
            actionType = "FLASH_SALE";
        } else if (shelfRatio >= 0.55 || daysToSellOut >= shelfLifeDays * 1.8) {
            riskLevel = "HIGH";
            discountPercent = "FRAGILE_GIFT".equalsIgnoreCase(storageType) ? 20 : 25;
            actionType = "FRAGILE_GIFT".equalsIgnoreCase(storageType) ? "BUNDLE_PROMO" : "FLASH_SALE";
        } else {
            riskLevel = "MEDIUM";
            discountPercent = 15;
            actionType = "VIP_BLAST";
        }

        // Bảo vệ biên an toàn nếu có giá vốn thực tế: đảm bảo không giảm vượt quá ngưỡng hợp lý
        if (costPrice > 0 && price > costPrice) {
            double maxSafeDiscountPct = Math.floor(((price - costPrice * 0.9) / price) * 100.0);
            if (maxSafeDiscountPct >= 10 && discountPercent > maxSafeDiscountPct) {
                discountPercent = (int) Math.max(10, Math.min(30, maxSafeDiscountPct));
            }
        }

        double suggestedPrice = Math.round(price * (100 - discountPercent) / 100.0);
        double unitLossBase = (costPrice > 0) ? costPrice : (price * 0.65);
        double lossFactor = "CRITICAL".equals(riskLevel) ? 0.70 : ("HIGH".equals(riskLevel) ? 0.50 : 0.30);
        double estimatedLoss = Math.round(stock * unitLossBase * lossFactor);
        double recoverableCapital = Math.round(stock * suggestedPrice);

        String couponCode = "CLEAR-P" + id + "-" + discountPercent;

        // Kiểm tra trong CSDL xem mã giảm giá này đã được kích hoạt và còn hiệu lực chưa
        String status = "PENDING";
        String checkSql = "SELECT status, end_date FROM coupons WHERE code = ?";
        try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setString(1, couponCode);
            try (ResultSet checkRs = checkPs.executeQuery()) {
                if (checkRs.next()) {
                    boolean active = checkRs.getBoolean("status");
                    Timestamp endDate = checkRs.getTimestamp("end_date");
                    if (active && (endDate == null || endDate.after(new Timestamp(System.currentTimeMillis())))) {
                        status = "ACTIVATED";
                    }
                }
            }
        } catch (Exception ignored) {}

        // Chẩn đoán động 100% từ số liệu thực tế (làm nền + fallback khi Gemini không khả dụng)
        String storageLabel = "COLD_CHAIN".equalsIgnoreCase(storageType)
                ? "bảo quản lạnh nhạy cảm nhiệt độ (chuẩn tối đa " + shelfLifeDays + " ngày)"
                : ("FRAGILE_GIFT".equalsIgnoreCase(storageType) ? "đóng gói dễ cấn dập (chuẩn " + shelfLifeDays + " ngày)" : "bảo quản thường (chuẩn " + shelfLifeDays + " ngày)");

        String sellOutNote = daysToSellOut >= 999.0
                ? "chưa ghi nhận đơn bán trong 14 ngày qua"
                : ("tốc độ bán thực tế " + velocity + " đơn vị/ngày, dự kiến cần " + daysToSellOut + " ngày mới bán hết");

        String riskDesc = String.format(
                "%s thuộc nhóm %s. Hiện còn tồn %d đơn vị (đã lưu kho ~%d ngày), %s.",
                name, storageLabel, stock, daysInStock, sellOutNote
        );

        String reasoning = String.format(
                "Dựa trên tồn kho %d đơn vị (giá gốc %,.0fđ), đề xuất giảm %d%% còn %,.0fđ qua chiến dịch %s (mã %s) để đẩy nhanh vòng quay trước ngưỡng bảo quản %d ngày và thu hồi ~%,.0fđ vốn.",
                stock, price, discountPercent, suggestedPrice, actionType, couponCode, shelfLifeDays, recoverableCapital
        );

        return new ClearanceRecommendationDTO(
                id, name, img, catName, stock, price, suggestedPrice, discountPercent,
                daysInStock, velocity, riskLevel, riskDesc, couponCode,
                estimatedLoss, recoverableCapital, actionType, reasoning, status
        );
    }

    private void enrichWithGeminiAnalysis(List<ClearanceRecommendationDTO> list, boolean forceRefresh) {
        if (list == null || list.isEmpty()) {
            lastUsedAiLlm = false;
            return;
        }

        // Tạo chữ ký trạng thái kho hiện tại (productId:stock:velocity:risk)
        StringBuilder sigBuilder = new StringBuilder();
        JsonArray payload = new JsonArray();
        for (ClearanceRecommendationDTO dto : list) {
            sigBuilder.append(dto.getProductId()).append(":")
                    .append(dto.getCurrentStock()).append(":")
                    .append(dto.getSalesVelocityPerDay()).append(":")
                    .append(dto.getSpoilageRisk()).append(";");

            JsonObject obj = new JsonObject();
            obj.addProperty("productId", dto.getProductId());
            obj.addProperty("name", dto.getProductName());
            obj.addProperty("category", dto.getCategoryName());
            obj.addProperty("currentStock", dto.getCurrentStock());
            obj.addProperty("daysInStock", dto.getDaysInStock());
            obj.addProperty("salesVelocityPerDay", dto.getSalesVelocityPerDay());
            obj.addProperty("spoilageRisk", dto.getSpoilageRisk());
            obj.addProperty("originalPrice", dto.getOriginalPrice());
            obj.addProperty("discountPercent", dto.getDiscountPercent());
            obj.addProperty("suggestedPrice", dto.getSuggestedDiscountPrice());
            payload.add(obj);
        }
        String currentSig = sigBuilder.toString();
        long now = System.currentTimeMillis();

        Map<Long, Map<String, String>> aiMap;
        if (!forceRefresh && currentSig.equals(cachedSignature)
                && !cachedAiNarratives.isEmpty()
                && (now - cachedAiTimestamp < AI_CACHE_TTL_MS)) {
            aiMap = cachedAiNarratives;
            lastUsedAiLlm = true;
        } else {
            aiMap = geminiService.analyzeInventoryBatch(gson.toJson(payload));
            if (aiMap != null && !aiMap.isEmpty()) {
                cachedSignature = currentSig;
                cachedAiTimestamp = now;
                cachedAiNarratives = aiMap;
                lastUsedAiLlm = true;
            } else {
                lastUsedAiLlm = false;
            }
        }

        if (aiMap != null && !aiMap.isEmpty()) {
            for (ClearanceRecommendationDTO dto : list) {
                Map<String, String> aiText = aiMap.get(dto.getProductId());
                if (aiText != null) {
                    if (aiText.containsKey("riskDescription") && !aiText.get("riskDescription").trim().isEmpty()) {
                        dto.setRiskDescription(aiText.get("riskDescription").trim());
                    }
                    if (aiText.containsKey("agentReasoning") && !aiText.get("agentReasoning").trim().isEmpty()) {
                        dto.setAgentReasoning(aiText.get("agentReasoning").trim());
                    }
                }
            }
        }
    }

    private int riskRank(String risk) {
        if ("CRITICAL".equalsIgnoreCase(risk)) return 3;
        if ("HIGH".equalsIgnoreCase(risk)) return 2;
        return 1;
    }

    @Override
    public Map<String, Object> getAgentMacroMetrics() {
        return buildMacroMetrics(analyzeInventoryRisks(false));
    }

    @Override
    public Map<String, Object> buildMacroMetrics(List<ClearanceRecommendationDTO> list) {
        Map<String, Object> metrics = new HashMap<>();
        if (list == null) list = Collections.emptyList();

        double totalRiskValue = 0;
        double totalRecoverable = 0;
        int criticalCount = 0;
        int activeCount = 0;

        for (ClearanceRecommendationDTO dto : list) {
            totalRiskValue += dto.getEstimatedWasteLoss();
            totalRecoverable += dto.getRecoverableCapital();
            if ("CRITICAL".equalsIgnoreCase(dto.getSpoilageRisk())) {
                criticalCount++;
            }
            if ("ACTIVATED".equalsIgnoreCase(dto.getStatus())) {
                activeCount++;
            }
        }

        int totalActiveCatalog = countActiveProducts();

        metrics.put("totalRiskValue", totalRiskValue);
        metrics.put("totalRecoverable", totalRecoverable);
        metrics.put("criticalCount", criticalCount);
        metrics.put("activeCount", activeCount);
        metrics.put("totalMonitored", list.size());
        metrics.put("totalActiveCatalog", totalActiveCatalog);
        metrics.put("aiPowered", lastUsedAiLlm);
        metrics.put("agentHealth", "ONLINE_ACTIVE");
        metrics.put("lastScanTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));

        return metrics;
    }

    private int countActiveProducts() {
        String sql = "SELECT COUNT(*) FROM products WHERE status = 1 AND stock > 0 AND id <> 99";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception ignored) {}
        return 0;
    }

    @Override
    public List<Map<String, String>> getRecentAuditLogs(int limit) {
        List<Map<String, String>> logs = new ArrayList<>();
        String sql = "SELECT title, message, created_at FROM notifications " +
                     "WHERE type = 'INVENTORY_AGENT' ORDER BY created_at DESC LIMIT ?";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, Math.max(1, limit));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> row = new HashMap<>();
                    row.put("title", rs.getString("title"));
                    row.put("message", rs.getString("message"));
                    Timestamp ts = rs.getTimestamp("created_at");
                    row.put("time", ts != null ? sdf.format(ts) : "Vừa xong");
                    logs.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return logs;
    }

    @Override
    public boolean executeClearancePlan(Long productId, String couponCode, int discountPercent, String actionType) {
        if (couponCode == null || couponCode.trim().isEmpty()) return false;

        try (Connection conn = DBConnectionUtil.getConnection()) {
            conn.setAutoCommit(false);

            try {
                // 1. Kiểm tra hoặc chèn vào bảng coupons
                String checkSql = "SELECT id FROM coupons WHERE code = ?";
                Integer existingCouponId = null;
                try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                    psCheck.setString(1, couponCode);
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next()) {
                            existingCouponId = rs.getInt("id");
                        }
                    }
                }

                if (existingCouponId != null) {
                    // Update kích hoạt lại và gia hạn 3 ngày
                    String updateSql = "UPDATE coupons SET status = 1, start_date = NOW(), end_date = DATE_ADD(NOW(), INTERVAL 3 DAY), discount_value = ? WHERE id = ?";
                    try (PreparedStatement psUp = conn.prepareStatement(updateSql)) {
                        psUp.setDouble(1, discountPercent);
                        psUp.setInt(2, existingCouponId);
                        psUp.executeUpdate();
                    }
                } else {
                    // Chèn coupon mới
                    String insertSql = """
                        INSERT INTO coupons (code, discount_type, discount_value, target_audience, min_order_value, product_id, start_date, end_date, usage_limit, used_count, status)
                        VALUES (?, 'PERCENT', ?, 'ALL', 0, ?, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY), 100, 0, 1)
                    """;
                    try (PreparedStatement psIn = conn.prepareStatement(insertSql)) {
                        psIn.setString(1, couponCode);
                        psIn.setDouble(2, discountPercent);
                        if (productId != null) {
                            psIn.setLong(3, productId);
                        } else {
                            psIn.setNull(3, java.sql.Types.BIGINT);
                        }
                        psIn.executeUpdate();
                    }
                }

                // 2. Cập nhật giá giảm trực tiếp trên sản phẩm để khách thấy trên web
                if (productId != null) {
                    String updateProductSql = "UPDATE products SET discount_price = ROUND(price * (100 - ?) / 100, 0) WHERE id = ?";
                    try (PreparedStatement psProd = conn.prepareStatement(updateProductSql)) {
                        psProd.setInt(1, discountPercent);
                        psProd.setLong(2, productId);
                        psProd.executeUpdate();
                    }
                }

                // 3. Thêm thông báo hệ thống
                String notifSql = """
                    INSERT INTO notifications (user_id, order_id, order_code, title, message, type, is_read, created_at)
                    VALUES (1, NULL, NULL, ?, ?, 'INVENTORY_AGENT', 0, NOW())
                """;
                try (PreparedStatement psNotif = conn.prepareStatement(notifSql)) {
                    psNotif.setString(1, "AI Agent: Kích hoạt xả kho mã " + couponCode);
                    psNotif.setString(2, "Agent vừa tự động kích hoạt mã giảm giá " + couponCode + " (giảm " + discountPercent + "%) cho sản phẩm ID " + productId + " nhằm giải phóng tồn kho.");
                    psNotif.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (Exception ex) {
                conn.rollback();
                ex.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
