package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.dao.IOrderDAO;
import vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl;
import vn.edu.eaut.fruitables.model.entity.OrderDetailModel;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.service.IGeminiService;
import vn.edu.eaut.fruitables.service.IProductService;
import vn.edu.eaut.fruitables.service.impl.GeminiServiceImpl;
import vn.edu.eaut.fruitables.service.impl.ProductServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(urlPatterns = {"/api/ai-chat"})
public class AIChatAPIServlet extends HttpServlet {

    private IGeminiService geminiService;
    private IProductService productService;
    private IOrderDAO orderDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        this.geminiService = new GeminiServiceImpl();
        this.productService = new ProductServiceImpl();
        this.orderDAO = new OrderDAOImpl();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        JsonObject res = new JsonObject();
        res.addProperty("status", "ready");
        res.addProperty("name", "Fruitables Smart Assistant");
        out.print(gson.toJson(res));
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        if (action == null) action = "chat";

        JsonObject jsonResponse = new JsonObject();

        try {
            switch (action) {
                case "quick_discount":
                    handleQuickDiscount(jsonResponse);
                    break;
                case "quick_featured":
                    handleQuickFeatured(jsonResponse);
                    break;
                case "quick_preservation":
                    handleQuickPreservation(jsonResponse);
                    break;
                case "quick_recipes":
                    handleQuickRecipes(jsonResponse);
                    break;
                case "track_order":
                    handleTrackOrder(request, jsonResponse);
                    break;
                case "chat":
                default:
                    handleSmartChatRouting(request, jsonResponse);
                    break;
            }
        } catch (Exception e) {
            jsonResponse.addProperty("type", "text");
            jsonResponse.addProperty("message", "Dạ em gặp chút gián đoạn kỹ thuật. Bạn vui lòng thử lại sau giây lát nhé! 🍎");
            System.err.println("[AIChatAPIServlet] Error handling action '" + action + "': " + e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

    /**
     * BỘ ĐIỀU PHỐI THÔNG MINH (SMART INTENT ROUTING):
     * Nếu là câu hỏi về sản phẩm (giảm giá, bán chạy, tra cứu đơn, tìm kiếm) -> Truy vấn trực tiếp DB (0 Token, 0.05s).
     * Chỉ khi là câu hỏi mở rộng (bảo quản chi tiết, công thức, tư vấn sức khỏe) -> Mới gọi LLM.
     */
    private void handleSmartChatRouting(HttpServletRequest request, JsonObject response) {
        String message = request.getParameter("message");
        if (message == null || message.trim().isEmpty()) {
            response.addProperty("type", "text");
            response.addProperty("message", "Bạn cần Fruitables tư vấn gì về hoa quả, cách bảo quản hoặc công thức món ngon ạ? 🍎🍇");
            return;
        }

        String rawQuery = message.trim();
        String lower = rawQuery.toLowerCase();

        // Nạp lịch sử hội thoại trước để phục vụ nhận diện ngữ cảnh mua hàng
        String historyJson = request.getParameter("history");
        List<Map<String, String>> historyList = new ArrayList<>();
        if (historyJson != null && !historyJson.trim().isEmpty()) {
            try {
                JsonArray arr = gson.fromJson(historyJson, JsonArray.class);
                for (JsonElement el : arr) {
                    JsonObject item = el.getAsJsonObject();
                    if (item.has("role") && item.has("text")) {
                        Map<String, String> m = new HashMap<>();
                        m.put("role", item.get("role").getAsString());
                        m.put("text", item.get("text").getAsString());
                        historyList.add(m);
                    }
                }
            } catch (Exception ignored) {}
        }

        // 0. Nhận diện ý định: Khách đồng ý mua sản phẩm vừa được bot giới thiệu (vd: "có", "ok", "mua", "được", "muốn mua")
        boolean isAffirmativeBuy = lower.equals("có") || lower.equals("co") || lower.equals("ok") || lower.equals("oke")
                || lower.equals("được") || lower.equals("duoc") || lower.equals("mua") || lower.equals("muốn mua")
                || lower.equals("muon mua") || lower.equals("mua ngay") || lower.equals("đặt hàng") || lower.equals("dat hang")
                || lower.equals("lấy") || lower.equals("lay") || lower.startsWith("cho 1") || lower.startsWith("cho tôi") || lower.startsWith("cho minh");

        if (isAffirmativeBuy && !historyList.isEmpty()) {
            String lastBotMsg = "";
            for (int i = historyList.size() - 1; i >= 0; i--) {
                if ("model".equalsIgnoreCase(historyList.get(i).get("role"))) {
                    lastBotMsg = historyList.get(i).get("text");
                    break;
                }
            }

            if (lastBotMsg != null && !lastBotMsg.isEmpty()) {
                List<ProductModel> allProducts = productService.findAll();
                if (allProducts != null) {
                    ProductModel matchedProduct = null;
                    for (ProductModel p : allProducts) {
                        if (p.getStatus() != null && !p.getStatus()) continue;
                        if (lastBotMsg.contains(p.getName())) {
                            matchedProduct = p;
                            break;
                        }
                    }
                    if (matchedProduct == null) {
                        for (ProductModel p : allProducts) {
                            if (p.getStatus() != null && !p.getStatus()) continue;
                            String shortName = p.getName().split("[-–(,]")[0].trim();
                            if (shortName.length() >= 4 && lastBotMsg.contains(shortName)) {
                                matchedProduct = p;
                                break;
                            }
                        }
                    }

                    if (matchedProduct != null) {
                        response.addProperty("type", "products");
                        response.addProperty("title", "🎉 Tuyệt vời quá ạ! Bạn bấm vào nút bên dưới để xem chi tiết và đặt mua \"" + matchedProduct.getName() + "\" ngay trên website nhé:");
                        JsonArray items = new JsonArray();
                        JsonObject item = new JsonObject();
                        item.addProperty("id", matchedProduct.getId());
                        item.addProperty("name", matchedProduct.getName());
                        item.addProperty("price", matchedProduct.getPrice());
                        item.addProperty("discountPrice", matchedProduct.getDiscountPrice() != null ? matchedProduct.getDiscountPrice() : matchedProduct.getPrice());
                        item.addProperty("imageUrl", matchedProduct.getImageUrl());
                        item.addProperty("stock", matchedProduct.getStock() != null ? matchedProduct.getStock() : 0);
                        items.add(item);
                        response.add("products", items);
                        return;
                    }
                }
            }
        }

        // 1. Nhận diện ý định: Hàng Giảm Giá / Khuyến Mãi / Sale
        if (matchesAny(lower, "giảm giá", "giam gia", "khuyến mãi", "khuyen mai", "sale", "ưu đãi", "uu dai", "giá sốc", "gia soc", "hàng sale", "đang sale", "rẻ nhất", "re nhat")) {
            handleQuickDiscount(response);
            return;
        }

        // 2. Nhận diện ý định: Hàng Bán Chạy / Nổi Bật / Hot
        if (matchesAny(lower, "bán chạy", "ban chay", "nổi bật", "noi bat", "hot", "bán tốt", "mua nhiều", "mua nhieu", "phổ biến", "pho bien", "top sản phẩm", "sản phẩm hot", "ngon nhất", "ngon nhat")) {
            handleQuickFeatured(response);
            return;
        }

        // 3. Nhận diện ý định: Mẹo bảo quản hoa quả chung
        if (matchesAny(lower, "mẹo bảo quản", "meo bao quan", "cách bảo quản hoa quả", "cach bao quan hoa qua", "bảo quản hoa quả", "bao quan hoa qua", "cách giữ hoa quả tươi", "cach giu hoa qua tuoi")) {
            handleQuickPreservation(response);
            return;
        }

        // 4. Nhận diện ý định: Công thức nước ép / sinh tố chung
        if (matchesAny(lower, "công thức nước ép", "cong thuc nuoc ep", "công thức sinh tố", "cong thuc sinh to", "nước ép detox", "nuoc ep detox", "làm nước ép", "lam nuoc ep")) {
            handleQuickRecipes(response);
            return;
        }

        // 5. Nhận diện ý định: Tra cứu đơn hàng
        if (matchesAny(lower, "đơn hàng", "don hang", "tra cứu", "tra cuu", "kiểm tra đơn", "kiem tra don", "tiến độ đơn", "tien do don", "đơn của tôi", "don cua toi", "tình trạng đơn", "tinh trang don", "vận chuyển", "shipper")) {
            Pattern phonePattern = Pattern.compile("(0[35789][0-9]{8})");
            Matcher matcher = phonePattern.matcher(rawQuery);
            if (matcher.find()) {
                String phoneFound = matcher.group(1);
                executeOrderTrackingByPhone(phoneFound, null, response);
                return;
            } else {
                response.addProperty("type", "prompt_tracking_form");
                response.addProperty("message", "Dạ để tra cứu tiến độ đơn hàng chính xác, bạn vui lòng nhập **Số điện thoại** đặt hàng vào ô bên dưới nhé 📦:");
                return;
            }
        }

        // 6. Nhận diện ý định: Tìm kiếm sản phẩm theo tên / Mua sản phẩm trong shop
        String extractedProductKey = extractProductSearchKeyword(lower);
        if (extractedProductKey != null && extractedProductKey.length() >= 2) {
            List<ProductModel> searchResults = productService.searchByName(extractedProductKey);
            if (searchResults != null && !searchResults.isEmpty()) {
                response.addProperty("type", "products");
                response.addProperty("title", "🍎 Fruitables hiện có các sản phẩm \"" + extractedProductKey + "\" tươi ngon sau:");
                response.addProperty("searchKeyword", extractedProductKey);
                JsonArray items = new JsonArray();
                int count = 0;
                for (ProductModel p : searchResults) {
                    if (p.getStatus() != null && !p.getStatus()) continue;
                    JsonObject item = new JsonObject();
                    item.addProperty("id", p.getId());
                    item.addProperty("name", p.getName());
                    item.addProperty("price", p.getPrice());
                    item.addProperty("discountPrice", p.getDiscountPrice() != null ? p.getDiscountPrice() : p.getPrice());
                    item.addProperty("imageUrl", p.getImageUrl());
                    item.addProperty("stock", p.getStock() != null ? p.getStock() : 0);
                    items.add(item);
                    if (++count >= 4) break;
                }
                response.add("products", items);
                return;
            }
        }

        // 7. CÂU HỎI MỞ RỘNG (Bảo quản, Nấu nướng, Dinh dưỡng, Giảm cân, Sức khỏe...) -> Gọi LLM Gemini
        String aiResponse = geminiService.askProductAssistant(rawQuery, historyList);
        response.addProperty("type", "text");
        response.addProperty("message", aiResponse);
    }

    /**
     * Xử lý gợi ý sản phẩm giảm giá (ZERO-TOKEN: Truy vấn DB trực tiếp)
     */
    private void handleQuickDiscount(JsonObject response) {
        List<ProductModel> flashSales = productService.findFlashSaleProducts(4);
        if (flashSales == null || flashSales.isEmpty()) {
            List<ProductModel> all = productService.findAll();
            flashSales = new ArrayList<>();
            if (all != null) {
                for (ProductModel p : all) {
                    if (p.getDiscountPrice() != null && p.getDiscountPrice() > 0 && p.getDiscountPrice() < p.getPrice()) {
                        flashSales.add(p);
                        if (flashSales.size() >= 4) break;
                    }
                }
            }
        }

        response.addProperty("type", "products");
        response.addProperty("title", "🔥 Các mặt hàng hoa quả đang giảm giá sốc hôm nay:");

        JsonArray items = new JsonArray();
        if (flashSales != null && !flashSales.isEmpty()) {
            for (ProductModel p : flashSales) {
                JsonObject item = new JsonObject();
                item.addProperty("id", p.getId());
                item.addProperty("name", p.getName());
                item.addProperty("price", p.getPrice());
                item.addProperty("discountPrice", p.getDiscountPrice() != null ? p.getDiscountPrice() : p.getPrice());
                item.addProperty("imageUrl", p.getImageUrl());
                item.addProperty("stock", p.getStock() != null ? p.getStock() : 0);
                items.add(item);
            }
        }
        response.add("products", items);
    }

    /**
     * Xử lý gợi ý sản phẩm nổi bật / bán chạy (ZERO-TOKEN: Truy vấn DB trực tiếp)
     */
    private void handleQuickFeatured(JsonObject response) {
        List<ProductModel> topProducts = productService.findTopProducts(4);

        response.addProperty("type", "products");
        response.addProperty("title", "⭐ Top sản phẩm tươi ngon bán chạy nhất Fruitables:");

        JsonArray items = new JsonArray();
        if (topProducts != null && !topProducts.isEmpty()) {
            for (ProductModel p : topProducts) {
                JsonObject item = new JsonObject();
                item.addProperty("id", p.getId());
                item.addProperty("name", p.getName());
                item.addProperty("price", p.getPrice());
                item.addProperty("discountPrice", p.getDiscountPrice() != null ? p.getDiscountPrice() : p.getPrice());
                item.addProperty("imageUrl", p.getImageUrl());
                item.addProperty("stock", p.getStock() != null ? p.getStock() : 0);
                items.add(item);
            }
        }
        response.add("products", items);
    }

    /**
     * Xử lý cẩm nang bảo quản hoa quả nhanh (ZERO-TOKEN + Link sản phẩm)
     */
    private void handleQuickPreservation(JsonObject response) {
        response.addProperty("type", "preservation_guide");
        response.addProperty("title", "🥑 Cẩm Nang Bảo Quản Hoa Quả Tươi Ngon Chuẩn Kho:");
        response.addProperty("message",
                "**1. Trái cây cần bảo quản lạnh (4 - 8°C):** Nho, Dâu tây, Cherry, Kiwi, Việt quất. *Lưu ý: Không rửa trước khi cho vào tủ lạnh, lót giấy hút ẩm để quả không bị úng thủy.*\n\n" +
                "**2. Trái cây giữ nhiệt độ phòng đến khi chín:** Bơ, Chuối, Xoài, Đu đủ. *Mẹo: Cho vào túi giấy để cạnh chuối chín giúp quả chín tự nhiên nhanh hơn.*\n\n" +
                "**3. Trái cây họ Cam/Bưởi:** Để nơi khô ráo, thoáng mát có thể giữ tươi 1 - 2 tuần mà không mất nước.");
    }

    /**
     * Xử lý gợi ý công thức nước ép & Detox thanh mát (ZERO-TOKEN + Link mua nguyên liệu)
     */
    private void handleQuickRecipes(JsonObject response) {
        response.addProperty("type", "recipe_guide");
        response.addProperty("title", "🥤 3 Công Thức Nước Ép Detox Tươi Mát Dễ Làm:");
        response.addProperty("message",
                "**1. Nước ép Xanh Detox (Táo Envy + Cần tây + Dưa leo):** Thanh lọc gan, thanh nhiệt cơ thể và giữ dáng cực tốt. Uống ngon nhất vào buổi sáng.\n\n" +
                "**2. Sinh tố Bơ Chuối Hạnh Nhân:** Giàu chất béo tốt Omega-3 và Kali, cung cấp năng lượng tức thì cho ngày dài năng động.\n\n" +
                "**3. Nước ép Cam Dứa Mật Ong:** Cung cấp hàm lượng Vitamin C dồi dào, tăng sức đề kháng tự nhiên.");
    }

    /**
     * Xử lý tra cứu đơn hàng linh hoạt bằng SĐT + Tên sản phẩm (ZERO-TOKEN)
     */
    private void handleTrackOrder(HttpServletRequest request, JsonObject response) {
        String phone = request.getParameter("phone");
        String keyword = request.getParameter("keyword");
        executeOrderTrackingByPhone(phone, keyword, response);
    }

    private void executeOrderTrackingByPhone(String phone, String keyword, JsonObject response) {
        if (phone == null || phone.trim().length() < 9) {
            response.addProperty("type", "text");
            response.addProperty("message", "Vui lòng nhập số điện thoại hợp lệ (từ 10 chữ số) để em tra cứu đơn hàng giúp bạn nhé! 📱");
            return;
        }

        phone = phone.trim();
        List<OrderModel> recentOrders = orderDAO.findRecentOrdersByPhone(phone, 5);

        if (recentOrders == null || recentOrders.isEmpty()) {
            response.addProperty("type", "text");
            response.addProperty("message", "Fruitables không tìm thấy đơn hàng nào gắn với số điện thoại **" + maskPhone(phone) + "** trong 30 ngày gần đây. Bạn kiểm tra lại số hoặc liên hệ CSKH trực tiếp để được hỗ trợ kiểm tra chuyên sâu nhé! 🍎");
            return;
        }

        OrderModel matchedOrder = null;
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            for (OrderModel o : recentOrders) {
                if (o.getDetails() != null) {
                    for (OrderDetailModel d : o.getDetails()) {
                        if (d.getProductName() != null && d.getProductName().toLowerCase().contains(kw)) {
                            matchedOrder = o;
                            break;
                        }
                    }
                }
                if (matchedOrder != null) break;
            }
        }

        if (matchedOrder == null) {
            matchedOrder = recentOrders.get(0);
        }

        String rawStatus = matchedOrder.getStatus() != null ? matchedOrder.getStatus().toUpperCase() : "PENDING";
        String statusText;
        String statusDesc;
        int stepProgress = 1;

        switch (rawStatus) {
            case "PROCESSING":
                statusText = "Đang đóng gói ướp lạnh";
                statusDesc = "Cửa hàng đang chọn lọc hoa quả tươi ngon nhất và đóng thùng xốp giữ nhiệt 4°C.";
                stepProgress = 2;
                break;
            case "SHIPPING":
                statusText = "Đang giao hàng hỏa tốc";
                statusDesc = "Shipper đang trên đường vận chuyển tới địa chỉ của bạn.";
                stepProgress = 3;
                break;
            case "DELIVERED":
                statusText = "Giao hàng thành công";
                statusDesc = "Đơn hàng đã được giao hoàn tất. Chúc bạn ngon miệng với hoa quả Fruitables!";
                stepProgress = 4;
                break;
            case "CANCELLED":
                statusText = "Đơn hàng đã hủy";
                statusDesc = "Đơn hàng này đã được hủy trên hệ thống.";
                stepProgress = 0;
                break;
            case "PENDING":
            default:
                statusText = "Chờ xác nhận";
                statusDesc = "Hệ thống đã tiếp nhận đơn và nhân viên đang kiểm tra tồn kho.";
                stepProgress = 1;
                break;
        }

        StringBuilder itemsSummary = new StringBuilder();
        if (matchedOrder.getDetails() != null && !matchedOrder.getDetails().isEmpty()) {
            for (OrderDetailModel d : matchedOrder.getDetails()) {
                if (itemsSummary.length() > 0) itemsSummary.append(", ");
                itemsSummary.append(d.getProductName() != null ? d.getProductName() : "Hoa quả tươi")
                            .append(" (x").append(d.getQuantity()).append(")");
            }
        } else {
            itemsSummary.append("Sản phẩm hoa quả tươi");
        }

        String orderDateStr = "";
        if (matchedOrder.getCreatedAt() != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm - dd/MM/yyyy");
            orderDateStr = sdf.format(matchedOrder.getCreatedAt());
        }

        String maskedCode = maskOrderCode(matchedOrder.getOrderCode());

        response.addProperty("type", "order_tracking");
        response.addProperty("orderCode", maskedCode);
        response.addProperty("orderDate", orderDateStr);
        response.addProperty("statusText", statusText);
        response.addProperty("statusDesc", statusDesc);
        response.addProperty("stepProgress", stepProgress);
        response.addProperty("totalAmount", matchedOrder.getTotalAmount() != null ? matchedOrder.getTotalAmount() : 0);
        response.addProperty("itemsSummary", itemsSummary.toString());
        response.addProperty("deliverySlot", matchedOrder.getDeliverySlot() != null ? matchedOrder.getDeliverySlot() : "Giao tiêu chuẩn");
        response.addProperty("trackingUrl", "/guest-tracking");
    }

    private boolean matchesAny(String input, String... keywords) {
        if (input == null) return false;
        for (String kw : keywords) {
            if (input.contains(kw)) return true;
        }
        return false;
    }

    private String extractProductSearchKeyword(String lower) {
        String[] prefixes = {
                "mua ", "đặt mua ", "đặt ", "muốn mua ", "tôi muốn mua ", "cho tôi mua ", 
                "cho mình mua ", "cho em mua ", "lấy ", "mua hộ ", "có bán ", "có ", "tìm ", "giá ", "bán "
        };
        for (String p : prefixes) {
            if (lower.startsWith(p)) {
                String sub = lower.substring(p.length())
                        .replace("không", "").replace("ko", "").replace("nào", "")
                        .replace("ạ", "").replace("vậy", "").replace("bao nhiêu", "")
                        .replace("nhé", "").replace("nha", "").replace("nhá", "")
                        .replace("với", "").trim();
                if (sub.length() >= 2) return sub;
            }
        }
        return null;
    }

    private String maskPhone(String phone) {
        if (phone == null || phone.length() < 7) return phone;
        int len = phone.length();
        return phone.substring(0, 3) + "****" + phone.substring(len - 3);
    }

    private String maskOrderCode(String code) {
        if (code == null || code.length() < 6) return code != null ? code : "FRU***";
        return code.substring(0, 3) + "***" + code.substring(code.length() - 3);
    }
}
