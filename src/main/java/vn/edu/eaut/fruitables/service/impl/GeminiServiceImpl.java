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
                Nhiệm vụ:
                1. Tư vấn chọn hoa quả phù hợp nhu cầu (sức khỏe, ăn kiêng, tiểu đường, biếu tặng, giải nhiệt...). Ưu tiên gợi ý sản phẩm hiện có tại Fruitables:
                """ + compactCatalog + """
                2. Hướng dẫn cách bảo quản hoa quả tươi lâu (nhiệt độ mát, nhiệt độ phòng, ủ chín, mẹo giữ tươi...).
                3. Gợi ý công thức nước ép, sinh tố detox, salad hoa quả thanh mát từ các loại quả có sẵn.
                4. Nếu khách hỏi về tiến độ đơn hàng, hướng dẫn khách cung cấp Số điện thoại đặt hàng để hệ thống tự động kiểm tra ngay.
                Quy tắc trả lời:
                - Ngắn gọn, súc tích (dưới 130 từ), chia gạch đầu dòng rõ ràng, dễ đọc trên di động.
                - Giọng điệu thân thiện, nhiệt tình, có biểu tượng cảm xúc hoa quả tươi mát (🍎, 🥑, 🍇, 🍊).
                - Tuyệt đối từ chối lịch sự nếu khách hỏi các chủ đề không liên quan đến hoa quả, thực phẩm hoặc cửa hàng Fruitables.
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

                    sb.append("[").append(name).append(": ").append(priceStr).append(storage).append("] ");
                    count++;
                }
                cachedCompactCatalog = sb.toString().trim();
                catalogLastUpdated = now;
                return cachedCompactCatalog;
            }
        } catch (Exception e) {
            System.err.println("[GeminiService] Failed to load catalog: " + e.getMessage());
        }

        return "[Táo Envy Mỹ: 120,000đ (Tủ mát)] [Bơ Sáp 034: 65,000đ] [Cam Sành: 35,000đ] [Nho Đen Không Hạt: 180,000đ (Tủ mát)] [Bưởi Da Xanh: 55,000đ]";
    }

    private String normalizeForCache(String query) {
        if (query == null) return "";
        return query.trim().toLowerCase()
                .replaceAll("[?,.!;:\"'()]", "")
                .replaceAll("\\s+", " ");
    }

    @Override
    public void clearCache() {
        RESPONSE_CACHE.clear();
        cachedCompactCatalog = "";
        catalogLastUpdated = 0;
    }
}
