package vn.edu.eaut.fruitables.service.impl;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.service.IGeminiService;
import vn.edu.eaut.fruitables.service.IProductService;
import vn.edu.eaut.fruitables.util.GeminiConfigUtil;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

public class GeminiServiceImpl implements IGeminiService {

    private final HttpClient httpClient;
    private final Gson gson;
    private final IProductService productService;

    // In-Memory Cache lưu câu trả lời cho các câu hỏi tương tự nhau (Tiết kiệm 100% token khi hit cache)
    private static final Map<String, CachedResponse> RESPONSE_CACHE = new ConcurrentHashMap<>();
    private static final long CACHE_TTL_MS = 12 * 60 * 60 * 1000L; // 12 giờ

    // Cache danh mục sản phẩm tóm tắt để không phải query DB liên tục
    private static String cachedCompactCatalog = "";
    private static long catalogLastUpdated = 0;
    private static final long CATALOG_REFRESH_INTERVAL = 15 * 60 * 1000L; // 15 phút

    private static class CachedResponse {
        final String text;
        final long timestamp;

        CachedResponse(String text) {
            this.text = text;
            this.timestamp = System.currentTimeMillis();
        }

        boolean isExpired() {
            return System.currentTimeMillis() - timestamp > CACHE_TTL_MS;
        }
    }

    public GeminiServiceImpl() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.gson = new Gson();
        this.productService = new ProductServiceImpl();
    }

    @Override
    public String askProductAssistant(String userMessage, List<Map<String, String>> conversationHistory) {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return "Xin chào! Fruitables có thể tư vấn chọn hoa quả, giải đáp cách bảo quản hoặc gợi ý công thức món ngon gì cho bạn hôm nay ạ? 🍎🥑";
        }

        String trimmedQuery = userMessage.trim();
        String normalizedKey = normalizeForCache(trimmedQuery);

        // 1. Kiểm tra In-Memory Cache (Nếu không có context lịch sử riêng biệt)
        boolean hasHistory = (conversationHistory != null && !conversationHistory.isEmpty());
        if (!hasHistory && normalizedKey.length() > 5) {
            CachedResponse cached = RESPONSE_CACHE.get(normalizedKey);
            if (cached != null && !cached.isExpired()) {
                return cached.text;
            }
        }

        // 2. Lấy hoặc làm mới mini-catalog tóm tắt (Compact Context ~120 tokens)
        String compactCatalog = getCompactCatalog();

        // 3. Xây dựng System Instruction siêu súc tích
        String systemInstructionText = """
                Bạn là Trợ lý Tư vấn Sản phẩm & Chuyên gia Dinh dưỡng của cửa hàng hoa quả tươi Fruitables.
                Danh mục hoa quả hiện có tại cửa hàng Fruitables:
                """ + compactCatalog + """

                Nhiệm vụ:
                1. Tư vấn chọn hoa quả theo nhu cầu (sức khỏe, ăn kiêng, tiểu đường, biếu tặng, giải nhiệt...). Ưu tiên gợi ý các sản phẩm trong danh mục trên.
                2. Hướng dẫn cách bảo quản hoa quả tươi lâu (nhiệt độ mát, nhiệt độ phòng, ủ chín, mẹo giữ tươi...).
                3. Gợi ý công thức nước ép, sinh tố detox thanh mát từ các loại quả có sẵn.
                4. Hướng dẫn tra cứu đơn hàng: Nhắc khách nhập Số điện thoại vào chat để hệ thống kiểm tra tiến độ ngay.

                QUY TẮC BẮT BUỘC KHI KHÁCH HÀNG MUỐN MUA HÀNG (ĐẶC BIỆT QUAN TRỌNG):
                - TUYỆT ĐỐI KHÔNG xin thông tin cá nhân của khách (KHÔNG hỏi số điện thoại, KHÔNG hỏi địa chỉ nhận hàng, KHÔNG xin tên hay thông tin giao hàng).
                - Khi khách thể hiện ý định muốn mua (ví dụ: 'có', 'mua', 'muốn mua', 'đặt hàng', 'cho 1kg', 'lấy hộp này', 'ok', 'được', 'mua thế nào', 'tôi muốn lấy',...):
                  Hãy lập tức gửi TRỰC TIẾP liên kết sản phẩm dạng markdown để khách bấm vào đặt mua ngay trên website:
                  Cú pháp: [👉 Đặt mua ngay Tên Sản Phẩm](/product-detail?id=ID)
                  Ví dụ: "Tuyệt vời quá ạ! 🍊 Bạn hãy bấm vào liên kết bên dưới để xem chi tiết và đặt mua ngay trên website nhé:
                  [👉 Đặt mua ngay Cam Sành Hàm Yên Mọng Nước](/product-detail?id=3)
                  Fruitables cam kết trái cây luôn tươi mới và giao nhanh tận nơi ạ! 🌿"
                - Nếu khách muốn tham khảo thêm các loại quả khác:
                  Gửi link: [👉 Khám phá tất cả sản phẩm tại Cửa Hàng](/shop)
                - Bất cứ khi nào nhắc đến một sản phẩm cụ thể có trong danh mục, luôn tạo link dạng [Tên Sản Phẩm](/product-detail?id=ID).

                Quy tắc trả lời chung:
                - Ngắn gọn, súc tích (dưới 120 từ), chia gạch đầu dòng rõ ràng, dễ đọc trên di động.
                - Giọng điệu thân thiện, nhiệt tình, sử dụng biểu tượng cảm xúc hoa quả tươi mát (🍎, 🥑, 🍇, 🍊).
                - Tuyệt đối từ chối lịch sự nếu khách hỏi các chủ đề không liên quan đến hoa quả, thực phẩm hoặc cửa hàng.
                """;

        try {
            JsonObject root = new JsonObject();

            // Thêm System Instruction
            JsonObject sysInstruction = new JsonObject();
            JsonArray sysParts = new JsonArray();
            JsonObject sysPart = new JsonObject();
            sysPart.addProperty("text", systemInstructionText);
            sysParts.add(sysPart);
            sysInstruction.add("parts", sysParts);
            root.add("system_instruction", sysInstruction);

            // Thêm Nội dung trò chuyện (Giới hạn tối đa 2 vòng hội thoại gần nhất để tiết kiệm token)
            JsonArray contents = new JsonArray();
            if (conversationHistory != null) {
                int start = Math.max(0, conversationHistory.size() - 4); // tối đa 2 lượt hỏi-đáp
                for (int i = start; i < conversationHistory.size(); i++) {
                    Map<String, String> item = conversationHistory.get(i);
                    String role = "user".equalsIgnoreCase(item.get("role")) ? "user" : "model";
                    String text = item.get("text");
                    if (text != null && !text.trim().isEmpty()) {
                        JsonObject c = new JsonObject();
                        c.addProperty("role", role);
                        JsonArray parts = new JsonArray();
                        JsonObject p = new JsonObject();
                        p.addProperty("text", text.trim());
                        parts.add(p);
                        c.add("parts", parts);
                        contents.add(c);
                    }
                }
            }

            // Tin nhắn hiện tại của user
            JsonObject currentMsg = new JsonObject();
            currentMsg.addProperty("role", "user");
            JsonArray currentParts = new JsonArray();
            JsonObject currentPart = new JsonObject();
            currentPart.addProperty("text", trimmedQuery);
            currentParts.add(currentPart);
            currentMsg.add("parts", currentParts);
            contents.add(currentMsg);

            root.add("contents", contents);

            // Cấu hình sinh câu trả lời
            JsonObject genConfig = new JsonObject();
            genConfig.addProperty("maxOutputTokens", GeminiConfigUtil.getMaxOutputTokens());
            genConfig.addProperty("temperature", GeminiConfigUtil.getTemperature());
            root.add("generationConfig", genConfig);

            // 4. Gửi HTTP POST tới Gemini REST API
            String requestBody = gson.toJson(root);
            String apiUrl = GeminiConfigUtil.getApiUrl();

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl))
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .timeout(Duration.ofSeconds(15))
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            if (response.statusCode() == 200) {
                String responseBody = response.body();
                String aiText = parseGeminiText(responseBody);
                if (aiText != null && !aiText.trim().isEmpty()) {
                    // Lưu vào cache nếu không có lịch sử hội thoại
                    if (!hasHistory && normalizedKey.length() > 5) {
                        RESPONSE_CACHE.put(normalizedKey, new CachedResponse(aiText));
                    }
                    return aiText;
                }
            } else {
                System.err.println("[GeminiService] API Error: HTTP " + response.statusCode() + " - " + response.body());
            }
        } catch (Exception e) {
            System.err.println("[GeminiService] Call failed: " + e.getMessage());
        }

        // Fallback khi gặp lỗi kết nối hoặc rate limit
        return "Dạ hiện tại em đang bận xử lý nhiều yêu cầu một chút 🍎. Bạn có thể bấm vào các nút gợi ý nhanh ở trên như **Mặt hàng đang giảm giá**, **Sản phẩm bán chạy** hoặc thử gửi lại câu hỏi sau vài giây nhé!";
    }

    private String parseGeminiText(String jsonResponse) {
        try {
            JsonObject obj = gson.fromJson(jsonResponse, JsonObject.class);
            if (obj.has("candidates")) {
                JsonArray candidates = obj.getAsJsonArray("candidates");
                if (candidates.size() > 0) {
                    JsonObject firstCandidate = candidates.get(0).getAsJsonObject();
                    if (firstCandidate.has("content")) {
                        JsonObject content = firstCandidate.getAsJsonObject("content");
                        if (content.has("parts")) {
                            JsonArray parts = content.getAsJsonArray("parts");
                            for (JsonElement p : parts) {
                                JsonObject partObj = p.getAsJsonObject();
                                if (partObj.has("text")) {
                                    return partObj.get("text").getAsString();
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("[GeminiService] Parse error: " + e.getMessage());
        }
        return null;
    }

    private String getCompactCatalog() {
        long now = System.currentTimeMillis();
        if (cachedCompactCatalog != null && !cachedCompactCatalog.isEmpty() && (now - catalogLastUpdated < CATALOG_REFRESH_INTERVAL)) {
            return cachedCompactCatalog;
        }

        try {
            List<ProductModel> products = productService.findTopProducts(20);
            if (products == null || products.isEmpty()) {
                products = productService.findAll();
            }

            if (products != null && !products.isEmpty()) {
                StringBuilder sb = new StringBuilder();
                int count = 0;
                for (ProductModel p : products) {
                    if (p.getStatus() != null && !p.getStatus()) continue;
                    if (count >= 18) break;

                    String name = p.getName();
                    double price = (p.getDiscountPrice() != null && p.getDiscountPrice() > 0) ? p.getDiscountPrice() : (p.getPrice() != null ? p.getPrice() : 0);
                    String priceStr = String.format("%,.0fđ", price);
                    String storage = "COLD_CHAIN".equalsIgnoreCase(p.getStorageType()) ? " (Tủ mát)" : "";

                    sb.append("[ID:").append(p.getId()).append(" - ").append(name).append(": ").append(priceStr).append(storage).append(" -> Link: /product-detail?id=").append(p.getId()).append("] ");
                    count++;
                }
                cachedCompactCatalog = sb.toString().trim();
                catalogLastUpdated = now;
                return cachedCompactCatalog;
            }
        } catch (Exception e) {
            System.err.println("[GeminiService] Failed to load catalog: " + e.getMessage());
        }

        return "[ID:1 - Táo Envy New Zealand Size L: 165,000đ (Tủ mát) -> Link: /product-detail?id=1] [ID:3 - Cam Sành Hàm Yên Mọng Nước: 45,000đ -> Link: /product-detail?id=3] [ID:2 - Nho Đen Không Hạt Mỹ: 199,000đ (Tủ mát) -> Link: /product-detail?id=2]";
    }

    private String normalizeForCache(String query) {
        if (query == null) return "";
        return query.trim().toLowerCase()
                .replaceAll("[?,.!;:\"'()]", "")
                .replaceAll("\\s+", " ");
    }

    @Override
    public String generateExecutiveAnalysis(String systemRole, String contextData, String userQuery) {
        String rolePrompt = (systemRole != null && !systemRole.trim().isEmpty())
                ? systemRole
                : "Bạn là Chuyên gia Cố vấn Kinh doanh & Phân tích Dữ liệu cao cấp (Chief Business Intelligence Analyst) của hệ thống siêu thị hoa quả tươi Fruitables.";

        String systemInstructionText = rolePrompt + """
                
                Nhiệm vụ của bạn:
                - Phân tích số liệu kinh doanh thực tế từ hệ thống (Doanh thu, Chi phí vốn, Lợi nhuận gộp, Tỷ suất lợi nhuận, Đơn hàng, Tồn kho, Phân phối danh mục, Hiệu suất giao hàng).
                - Phát hiện các điểm nghẽn, cảnh báo rủi ro (hoa quả sắp hết hàng, đơn hủy/giao thất bại, mặt hàng ứ đọng...).
                - Đưa ra các khuyến nghị hành động chiến lược cụ thể, thực tế (chiến dịch khuyến mãi, bổ sung nhập kho, tối ưu giá bán, thúc đẩy bán chéo hoa quả tươi...).
                - Trình bày dạng Markdown chuyên nghiệp: dùng tiêu đề rõ ràng (h3, h4), gạch đầu dòng, highlight các con số quan trọng, sử dụng emoji phù hợp (📈, 💰, ⚠️, 🚀, 💡).
                - Phản hồi bằng Tiếng Việt, văn phong súc tích, sắc bén, mang tính quyết định điều hành cao, đi thẳng vào trọng tâm số liệu.
                """;

        String userPrompt = "DỮ LIỆU HOẠT ĐỘNG KINH DOANH HIỆN TẠI TỪ HỆ THỐNG:\n"
                + contextData
                + "\n\nYÊU CẦU PHÂN TÍCH CỦA QUẢN TRỊ VIÊN:\n"
                + (userQuery != null && !userQuery.trim().isEmpty() ? userQuery : "Hãy lập báo cáo tóm tắt tình hình tài chính - kinh doanh toàn diện, chỉ ra các cảnh báo rủi ro về tồn kho/đơn hàng và đề xuất 3-5 giải pháp thúc đẩy doanh số ngay trong tuần này.");

        try {
            JsonObject root = new JsonObject();

            JsonObject sysInstruction = new JsonObject();
            JsonArray sysParts = new JsonArray();
            JsonObject sysPart = new JsonObject();
            sysPart.addProperty("text", systemInstructionText);
            sysParts.add(sysPart);
            sysInstruction.add("parts", sysParts);
            root.add("system_instruction", sysInstruction);

            JsonArray contents = new JsonArray();
            JsonObject currentMsg = new JsonObject();
            currentMsg.addProperty("role", "user");
            JsonArray currentParts = new JsonArray();
            JsonObject currentPart = new JsonObject();
            currentPart.addProperty("text", userPrompt);
            currentParts.add(currentPart);
            currentMsg.add("parts", currentParts);
            contents.add(currentMsg);
            root.add("contents", contents);

            JsonObject genConfig = new JsonObject();
            genConfig.addProperty("maxOutputTokens", 1500);
            genConfig.addProperty("temperature", 0.4);
            root.add("generationConfig", genConfig);

            String requestBody = gson.toJson(root);
            String apiUrl = GeminiConfigUtil.getApiUrl();

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl))
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .timeout(Duration.ofSeconds(30))
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            if (response.statusCode() == 200) {
                String aiText = parseGeminiText(response.body());
                if (aiText != null && !aiText.trim().isEmpty()) {
                    return aiText;
                }
            } else {
                System.err.println("[GeminiService-Executive] API Error: " + response.statusCode() + " - " + response.body());
            }
        } catch (Exception e) {
            System.err.println("[GeminiService-Executive] Exception: " + e.getMessage());
        }

        return "Hiện tại hệ thống phân tích AI đang xử lý lượng dữ liệu lớn. Xin vui lòng thử lại sau giây lát hoặc làm mới kết nối.";
    }

    @Override
    public void clearCache() {
        RESPONSE_CACHE.clear();
        cachedCompactCatalog = "";
        catalogLastUpdated = 0;
    }
}
