package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.dao.IDashboardDAO;
import vn.edu.eaut.fruitables.dao.impl.DashboardDAOImpl;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.IGeminiService;
import vn.edu.eaut.fruitables.service.impl.GeminiServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet(urlPatterns = {"/api/admin/ai-assistant"})
public class AdminAIChatAPIServlet extends HttpServlet {

    private IGeminiService geminiService;
    private IDashboardDAO dashboardDAO;
    private Gson gson;

    // Cache báo cáo phân tích tổng quan (TTL: 15 phút)
    private static String cachedExecutiveReport = null;
    private static long reportCacheTime = 0;
    private static final long REPORT_CACHE_TTL = 15 * 60 * 1000L;

    @Override
    public void init() throws ServletException {
        super.init();
        this.geminiService = new GeminiServiceImpl();
        this.dashboardDAO = new DashboardDAOImpl();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 1. Phân quyền: Chỉ cho phép ADMIN hoặc EMPLOYEE đăng nhập
        HttpSession session = request.getSession(false);
        UserModel currentUser = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;
        if (currentUser == null || currentUser.getRoleId() == null
                || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            JsonObject err = new JsonObject();
            err.addProperty("success", false);
            err.addProperty("message", "Từ chối truy cập. Chức năng AI Cố vấn dành riêng cho Ban quản trị Fruitables.");
            out.print(gson.toJson(err));
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "analyze_dashboard";
        }

        boolean forceRefresh = "true".equalsIgnoreCase(request.getParameter("forceRefresh"));
        String userQuery = request.getParameter("query");

        JsonObject jsonResponse = new JsonObject();

        try {
            if ("admin_copilot".equalsIgnoreCase(action)) {
                handleAdminCopilot(userQuery, jsonResponse);
            } else {
                handleDashboardAnalysis(forceRefresh, userQuery, jsonResponse);
            }
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("status", "success");
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Lỗi xử lý AI Cố vấn: " + e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

    private void handleDashboardAnalysis(boolean forceRefresh, String customPrompt, JsonObject jsonResponse) {
        long now = System.currentTimeMillis();

        // Nếu không có câu hỏi tùy biến và chưa hết hạn cache, dùng lại báo cáo đã phân tích
        if (!forceRefresh && (customPrompt == null || customPrompt.trim().isEmpty())) {
            if (cachedExecutiveReport != null && (now - reportCacheTime < REPORT_CACHE_TTL)) {
                jsonResponse.addProperty("report", cachedExecutiveReport);
                jsonResponse.addProperty("cached", true);
                jsonResponse.addProperty("updatedAt", new SimpleDateFormat("HH:mm:ss dd/MM/yyyy").format(new Date(reportCacheTime)));
                return;
            }
        }

        // Tổng hợp số liệu kinh doanh thực tế từ CSDL (Chỉ số liệu tổng hợp, không PII khách hàng)
        String businessContext = buildBusinessDataContext();

        String systemRole = """
                Bạn là Giám đốc Phân tích Kinh doanh & Cố vấn Chiến lược cấp cao (Chief Business Intelligence Analyst) của hệ thống hoa quả tươi Fruitables.
                Nhiệm vụ của bạn là lập BÁO CÁO PHÂN TÍCH ĐIỀU HÀNH DOANH SỐ & TỒN KHO chuyên sâu cho Quản trị viên.
                """;

        String query = (customPrompt != null && !customPrompt.trim().isEmpty())
                ? customPrompt
                : "Hãy phân tích toàn diện hiệu quả tài chính kinh doanh, đánh giá cơ cấu đơn hàng và cảnh báo các rủi ro tồn kho hoa quả, sau đó đưa ra 3-4 chiến lược hành động cụ thể để gia tăng doanh số trong tuần tới.";

        String aiReport = geminiService.generateExecutiveAnalysis(systemRole, businessContext, query);

        if (customPrompt == null || customPrompt.trim().isEmpty()) {
            cachedExecutiveReport = aiReport;
            reportCacheTime = now;
        }

        jsonResponse.addProperty("report", aiReport);
        jsonResponse.addProperty("cached", false);
        jsonResponse.addProperty("updatedAt", new SimpleDateFormat("HH:mm:ss dd/MM/yyyy").format(new Date(now)));
    }

    private void handleAdminCopilot(String userQuery, JsonObject jsonResponse) {
        if (userQuery == null || userQuery.trim().isEmpty()) {
            jsonResponse.addProperty("report", "Vui lòng nhập câu hỏi hoặc yêu cầu phân tích kinh doanh.");
            return;
        }

        String businessContext = buildBusinessDataContext();
        String systemRole = """
                Bạn là Cố vấn Điều hành & Trợ lý Kinh doanh AI (Admin AI Copilot) của Fruitables.
                Hãy trả lời câu hỏi của Quản trị viên dựa trên dữ liệu kinh doanh thực tế của hệ thống.
                Đưa ra phân tích sắc sảo, gợi ý hành động chiến lược và giải pháp khả thi.
                """;

        String aiAnswer = geminiService.generateExecutiveAnalysis(systemRole, businessContext, userQuery);
        jsonResponse.addProperty("report", aiAnswer);
        jsonResponse.addProperty("response", aiAnswer);
        jsonResponse.addProperty("updatedAt", new SimpleDateFormat("HH:mm:ss dd/MM/yyyy").format(new Date()));
    }

    private String buildBusinessDataContext() {
        StringBuilder sb = new StringBuilder();
        NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

        try {
            double totalRev = dashboardDAO.getTotalRevenue();
            double totalCost = dashboardDAO.getTotalCost();
            double grossProfit = dashboardDAO.getGrossProfit();
            double margin = totalRev > 0 ? (grossProfit / totalRev * 100) : 0;
            int totalOrders = dashboardDAO.getTotalOrders();
            int totalProducts = dashboardDAO.getTotalProducts();
            int outOfStock = dashboardDAO.getOutOfStockProducts();

            sb.append("=== CHỈ SỐ TÀI CHÍNH TỔNG QUAN ===\n");
            sb.append("- Tổng doanh thu luỹ kế: ").append(fmt.format(totalRev)).append("\n");
            sb.append("- Tổng chi phí giá vốn: ").append(fmt.format(totalCost)).append("\n");
            sb.append("- Tổng lợi nhuận gộp: ").append(fmt.format(grossProfit)).append("\n");
            sb.append("- Tỷ suất lợi nhuận gộp: ").append(String.format("%.2f%%", margin)).append("\n");
            sb.append("- Tổng số đơn hàng tiếp nhận: ").append(totalOrders).append(" đơn\n");
            sb.append("- Tổng số mặt hàng trong catalog: ").append(totalProducts).append(" sản phẩm\n");
            sb.append("- Số mặt hàng đang hết sạch tồn kho (tồn = 0): ").append(outOfStock).append(" sản phẩm\n\n");

            // Tồn kho thấp
            List<ProductModel> lowStocks = dashboardDAO.getLowStockProducts(10);
            sb.append("=== DANH SÁCH HOA QUẢ TỒN KHO THẤP (<= 10 đơn vị) ===\n");
            if (lowStocks != null && !lowStocks.isEmpty()) {
                for (ProductModel p : lowStocks) {
                    sb.append("  + [SP #").append(p.getId()).append("] ").append(p.getName())
                            .append(" - Tồn kho: ").append(p.getStock())
                            .append(", Giá bán: ").append(fmt.format(p.getPrice() != null ? p.getPrice() : 0))
                            .append("\n");
                }
            } else {
                sb.append("  (Không có sản phẩm nào ở mức tồn kho nguy hiểm)\n");
            }
            sb.append("\n");

            // Cơ cấu trạng thái đơn hàng
            Map<String, Object> orderDist = dashboardDAO.getOrderStatusDistribution("ALL");
            if (orderDist != null) {
                sb.append("=== CƠ CẤU TRẠNG THÁI ĐƠN HÀNG ===\n");
                sb.append(gson.toJson(orderDist)).append("\n\n");
            }

            // Top 5 sản phẩm bán chạy nhất
            Map<String, Object> topSelling = dashboardDAO.getTopSellingProducts(5, null, null);
            if (topSelling != null) {
                sb.append("=== TOP SẢN PHẨM BÁN CHẠY NHẤT ===\n");
                sb.append(gson.toJson(topSelling)).append("\n\n");
            }

            // Cơ cấu danh mục
            Map<String, Object> catDist = dashboardDAO.getCategoryProductDistribution();
            if (catDist != null) {
                sb.append("=== CƠ CẤU SẢN PHẨM THEO DANH MỤC ===\n");
                sb.append(gson.toJson(catDist)).append("\n\n");
            }

        } catch (Exception e) {
            sb.append("Lỗi đọc dữ liệu kinh doanh chi tiết: ").append(e.getMessage());
        }

        return sb.toString();
    }
}
