package vn.edu.eaut.fruitables.controller.admin;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.model.dto.ClearanceRecommendationDTO;
import vn.edu.eaut.fruitables.service.IInventoryAgentService;
import vn.edu.eaut.fruitables.service.impl.InventoryAgentServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/inventory-agent", "/api/inventory-agent"})
public class AdminInventoryAgentServlet extends HttpServlet {

    private final IInventoryAgentService inventoryAgentService;
    private final Gson gson;

    public AdminInventoryAgentServlet() {
        this.inventoryAgentService = new InventoryAgentServiceImpl();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/api/inventory-agent".equals(path)) {
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();

            List<ClearanceRecommendationDTO> recommendations = inventoryAgentService.analyzeInventoryRisks();
            Map<String, Object> metrics = inventoryAgentService.getAgentMacroMetrics();

            JsonObject json = new JsonObject();
            json.add("metrics", gson.toJsonTree(metrics));
            json.add("recommendations", gson.toJsonTree(recommendations));
            out.print(gson.toJson(json));
            out.flush();
            return;
        }

        // View JSP trang Quản trị Agent Điều phối Xả kho
        List<ClearanceRecommendationDTO> recommendations = inventoryAgentService.analyzeInventoryRisks();
        Map<String, Object> metrics = inventoryAgentService.getAgentMacroMetrics();

        request.setAttribute("recommendations", recommendations);
        request.setAttribute("metrics", metrics);
        request.getRequestDispatcher("/WEB-INF/views/admin/inventory-agent.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        JsonObject res = new JsonObject();

        if ("execute_clearance".equalsIgnoreCase(action)) {
            try {
                Long productId = Long.parseLong(request.getParameter("productId"));
                String couponCode = request.getParameter("couponCode");
                int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
                String actionType = request.getParameter("actionType");

                boolean success = inventoryAgentService.executeClearancePlan(productId, couponCode, discountPercent, actionType);
                if (success) {
                    res.addProperty("success", true);
                    res.addProperty("message", "AI Agent đã kích hoạt thành công chiến dịch xả kho! Mã ưu đãi " + couponCode + " (giảm " + discountPercent + "%) đã được phát hành trên hệ thống.");
                } else {
                    res.addProperty("success", false);
                    res.addProperty("message", "Không thể kích hoạt chiến dịch do lỗi cơ sở dữ liệu.");
                }
            } catch (Exception e) {
                res.addProperty("success", false);
                res.addProperty("message", "Lỗi dữ liệu: " + e.getMessage());
            }
        } else {
            res.addProperty("success", false);
            res.addProperty("message", "Hành động không hợp lệ.");
        }

        out.print(gson.toJson(res));
        out.flush();
    }
}
