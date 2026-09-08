package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import vn.edu.eaut.fruitables.dao.IDashboardDAO;
import vn.edu.eaut.fruitables.dao.impl.DashboardDAOImpl;
import vn.edu.eaut.fruitables.model.entity.ProductModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {
        "/api/chart-data",
        "/api/order-status-data",
        "/api/category-distribution",
        "/api/category-products"
})
public class ChartDataAPIServlet extends HttpServlet {

    private IDashboardDAO dashboardDAO;
    private Gson gson;

    public ChartDataAPIServlet() {
        this.dashboardDAO = new DashboardDAOImpl();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String servletPath = request.getServletPath();

        if ("/api/order-status-data".equals(servletPath)) {
            String filter = request.getParameter("filter");
            if (filter == null || filter.isEmpty()) filter = "all";
            Map<String, Object> orderStatusData = dashboardDAO.getOrderStatusDistribution(filter);
            response.getWriter().write(gson.toJson(orderStatusData));

        } else if ("/api/category-distribution".equals(servletPath)) {
            Map<String, Object> catData = dashboardDAO.getCategoryProductDistribution();
            response.getWriter().write(gson.toJson(catData));

        } else if ("/api/category-products".equals(servletPath)) {
            String catIdStr = request.getParameter("categoryId");
            int catId = 1;
            try {
                if (catIdStr != null) catId = Integer.parseInt(catIdStr);
            } catch (Exception ignored) {}
            List<ProductModel> products = dashboardDAO.getProductsByCategory(catId);
            response.getWriter().write(gson.toJson(products));

        } else {
            // Mặc định: /api/chart-data (Hỗ trợ cả đơn kỳ và đối sánh đa kỳ)
            String filter = request.getParameter("filter");
            if (filter == null || filter.isEmpty()) {
                filter = "month";
            }

            Map<String, Object> comparativeData = dashboardDAO.getComparativeRevenueChartData(filter);

            // Giữ lại key "data" cho code cũ nếu cần
            @SuppressWarnings("unchecked")
            List<Double> currentData = (List<Double>) comparativeData.get("currentData");
            comparativeData.put("data", currentData);

            response.getWriter().write(gson.toJson(comparativeData));
        }
    }
}