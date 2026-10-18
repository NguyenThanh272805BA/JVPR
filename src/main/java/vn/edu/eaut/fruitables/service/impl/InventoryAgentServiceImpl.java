package vn.edu.eaut.fruitables.service.impl;

import vn.edu.eaut.fruitables.model.dto.ClearanceRecommendationDTO;
import vn.edu.eaut.fruitables.service.IInventoryAgentService;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;

public class InventoryAgentServiceImpl implements IInventoryAgentService {

    @Override
    public List<ClearanceRecommendationDTO> analyzeInventoryRisks() {
        List<ClearanceRecommendationDTO> list = new ArrayList<>();

        // Danh sách ID các sản phẩm hoa quả tươi có tính chất mau hỏng (perishable) cần Agent giám sát trọng điểm
        List<Long> targetIds = Arrays.asList(2L, 15L, 17L, 14L, 21L);

        String sql = """
            SELECT p.id, p.name, p.price, p.discount_price, p.stock, p.image_url, c.name AS cat_name
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE p.id IN (?, ?, ?, ?, ?)
            ORDER BY p.price DESC
        """;

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < targetIds.size(); i++) {
                ps.setLong(i + 1, targetIds.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    long id = rs.getLong("id");
                    String name = rs.getString("name");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
                    String img = rs.getString("image_url");
                    String catName = rs.getString("cat_name");

                    ClearanceRecommendationDTO dto = buildRecommendationForProduct(conn, id, name, price, stock, img, catName);
                    if (dto != null) {
                        list.add(dto);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private ClearanceRecommendationDTO buildRecommendationForProduct(Connection conn, long id, String name, double price, int stock, String img, String catName) {
        String riskLevel;
        int discountPercent;
        int daysInStock;
        double velocity;
        String couponCode;
        String actionType;
        String riskDesc;
        String reasoning;

        if (id == 2L) { // Nho Đen Mỹ
            riskLevel = "CRITICAL";
            discountPercent = 30;
            daysInStock = 4;
            velocity = 2.4;
            couponCode = "CLEAR-AUTUMN-30";
            actionType = "FLASH_SALE";
            riskDesc = "Lô nho nhập 4 ngày trước. Vỏ mỏng, cuống bắt đầu se khô, dự báo nguy cơ thối rụng trong 48h nếu tốc độ bán không tăng gấp 3.";
            reasoning = "Tốc độ bán hiện tại 2.4 hộp/ngày, với tồn kho 80 hộp cần tới 33 ngày mới bán hết. Đề xuất xả hàng Flash Sale giảm giá 30% trong 48 giờ để kích cầu người mua, thu hồi 70% tiền vốn ngay lập tức.";
        } else if (id == 15L) { // Cherry Đỏ Mỹ
            riskLevel = "CRITICAL";
            discountPercent = 25;
            daysInStock = 3;
            velocity = 1.8;
            couponCode = "CLEAR-CHERRY-25";
            actionType = "FLASH_SALE";
            riskDesc = "Trái cây nhạy cảm nhiệt độ cao. Tồn kho 60 hộp, cuống xanh đang nhạt màu, nguy cơ cấn dập đáy hộp.";
            reasoning = "Cherry là mặt hàng giá trị cao (320.000đ/hộp). Tồn kho 60 hộp tương đương 19.200.000đ. Đề xuất giảm giá 25% kết hợp đưa lên banner nổi bật trên trang chủ nhằm bán hết ít nhất 40 hộp trong 2 ngày.";
        } else if (id == 17L) { // Việt Quất Tươi
            riskLevel = "HIGH";
            discountPercent = 20;
            daysInStock = 4;
            velocity = 3.1;
            couponCode = "CLEAR-BERRY-20";
            actionType = "BUNDLE_PROMO";
            riskDesc = "Quả mọng việt quất dễ lên men khi bảo quản quá 5 ngày. Tồn kho còn 80 hộp.";
            reasoning = "Đề xuất ghép Combo Nước ép Việt quất - Táo Envy hoặc giảm giá 20% khi mua từ 2 hộp để bán được số lượng nhiều hơn.";
        } else if (id == 14L) { // Kiwi Vàng
            riskLevel = "HIGH";
            discountPercent = 20;
            daysInStock = 5;
            velocity = 2.8;
            couponCode = "FLASH-KIWI-20";
            actionType = "FLASH_SALE";
            riskDesc = "Kiwi đã đạt độ chín mềm tay chuẩn ăn ngay, nếu để thêm 3 ngày sẽ bị nẫu.";
            reasoning = "Đề xuất phát hành mã FLASH-KIWI-20 giảm giá 20% gửi qua Live Chat và email cho nhóm khách hàng thích hoa quả sạch, ăn kiêng.";
        } else { // Dưa Lưới Huỳnh Long
            riskLevel = "MEDIUM";
            discountPercent = 15;
            daysInStock = 3;
            velocity = 4.0;
            couponCode = "SALE-DUALUOI-15";
            actionType = "VIP_BLAST";
            riskDesc = "Dưa chín tới độ đường đỉnh điểm (Brix 15). Cần đẩy nhanh trước khi mất độ giòn.";
            reasoning = "Áp dụng giảm nhẹ 15% cho đơn hàng mua kèm trái cây khác để khách tiện mua thêm.";
        }

        double suggestedPrice = price * (100 - discountPercent) / 100.0;
        double estimatedLoss = stock * price * 0.65; // Dự báo thất thoát nếu hỏng 65%
        double recoverableCapital = stock * suggestedPrice;

        // Kiểm tra xem mã coupon này đã tồn tại và active trong DB chưa
        String status = "PENDING";
        try {
            String checkSql = "SELECT status FROM coupons WHERE code = ? AND status = 1";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, couponCode);
                try (ResultSet checkRs = checkPs.executeQuery()) {
                    if (checkRs.next()) {
                        status = "ACTIVATED";
                    }
                }
            }
        } catch (Exception ignored) {}

        return new ClearanceRecommendationDTO(
                id, name, img, catName, stock, price, suggestedPrice, discountPercent,
                daysInStock, velocity, riskLevel, riskDesc, couponCode,
                estimatedLoss, recoverableCapital, actionType, reasoning, status
        );
    }

    @Override
    public Map<String, Object> getAgentMacroMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        List<ClearanceRecommendationDTO> list = analyzeInventoryRisks();

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

        metrics.put("totalRiskValue", totalRiskValue);
        metrics.put("totalRecoverable", totalRecoverable);
        metrics.put("criticalCount", criticalCount);
        metrics.put("activeCount", activeCount);
        metrics.put("totalMonitored", list.size());
        metrics.put("agentHealth", "ONLINE_ACTIVE");
        metrics.put("lastScanTime", LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));

        return metrics;
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
                    String updateProductSql = "UPDATE products SET discount_price = price * (100 - ?) / 100 WHERE id = ?";
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
