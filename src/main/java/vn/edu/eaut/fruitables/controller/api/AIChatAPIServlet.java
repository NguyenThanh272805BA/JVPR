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
        res.addProperty("name", "Fruitables AI Assistant");
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
                case "track_order":
                    handleTrackOrder(request, jsonResponse);
                    break;
                case "chat":
                default:
                    handleChat(request, jsonResponse);
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
     * Xử lý tra cứu đơn hàng linh hoạt bằng SĐT + Tên sản phẩm (ZERO-TOKEN)
     */
    private void handleTrackOrder(HttpServletRequest request, JsonObject response) {
        String phone = request.getParameter("phone");
        String keyword = request.getParameter("keyword"); // Tên sản phẩm hoặc ghi chú

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

        // Nếu khách cung cấp tên sản phẩm, tìm đơn hàng khớp
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

        // Nếu không khớp từ khóa nhưng chỉ có 1 đơn hoặc khách chưa nhập keyword -> lấy đơn mới nhất
        if (matchedOrder == null) {
            matchedOrder = recentOrders.get(0);
        }

        // Định dạng trạng thái trực quan
        String rawStatus = matchedOrder.getStatus() != null ? matchedOrder.getStatus().toUpperCase() : "PENDING";
        String statusText;
        String statusDesc;
        int stepProgress = 1; // 1: Tiếp nhận, 2: Đóng gói, 3: Đang giao, 4: Thành công

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

        // Danh sách sản phẩm tóm tắt
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

    /**
     * Xử lý câu hỏi tự do qua Gemini Service
     */
    private void handleChat(HttpServletRequest request, JsonObject response) {
        String message = request.getParameter("message");
        if (message == null || message.trim().isEmpty()) {
            response.addProperty("type", "text");
            response.addProperty("message", "Bạn cần Fruitables tư vấn gì về hoa quả, cách bảo quản hoặc công thức món ngon ạ? 🍎🍇");
            return;
        }

        // Đọc lịch sử trò chuyện (nếu có)
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

        String aiResponse = geminiService.askProductAssistant(message.trim(), historyList);
        response.addProperty("type", "text");
        response.addProperty("message", aiResponse);
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
