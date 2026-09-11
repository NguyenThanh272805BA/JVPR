package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import vn.edu.eaut.fruitables.dao.IDashboardDAO;
import vn.edu.eaut.fruitables.dao.IShipperDeliveryDAO;
import vn.edu.eaut.fruitables.dao.impl.DashboardDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.ShipperDeliveryDAOImpl;
import vn.edu.eaut.fruitables.model.entity.ProductModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {
        "/api/dashboard-overview",
        "/api/chart-data",
        "/api/order-status-data",
        "/api/category-distribution",
        "/api/category-products",
        "/api/payment-distribution",
        "/api/top-products",
        "/api/order-trends",
        "/api/shipper-performance",
        "/api/delivery-slots",
        "/api/shipper-failure-stats",
        "/api/customer-engagement"
})
public class ChartDataAPIServlet extends HttpServlet {

    private final IDashboardDAO dashboardDAO = new DashboardDAOImpl();
    private final IShipperDeliveryDAO shipperDeliveryDAO = new ShipperDeliveryDAOImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String servletPath = request.getServletPath();
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String filter = request.getParameter("filter");

        if ("/api/dashboard-overview".equals(servletPath)) {
            // Tổng hợp toàn bộ 8 biểu đồ và 4 thẻ KPI chỉ trong 1 lần gọi duy nhất
            Map<String, Object> overview = new HashMap<>();

            // 1. Dữ liệu doanh thu & lợi nhuận
            Map<String, Object> revData = dashboardDAO.getComparativeRevenueChartData(filter != null ? filter : "month", startDate, endDate);
            overview.put("revenueData", revData);

            // 2. Cơ cấu PTTT
            overview.put("paymentData", dashboardDAO.getPaymentMethodDistribution(startDate, endDate));

            // 3. Trạng thái đơn hàng
            overview.put("orderStatusData", dashboardDAO.getOrderStatusDistribution(filter != null ? filter : "all", startDate, endDate));

            // 4. Top sản phẩm bán chạy
            overview.put("topProductsData", dashboardDAO.getTopSellingProducts(5, startDate, endDate));

            // 5. Cơ cấu sản phẩm theo danh mục
            overview.put("categoryData", dashboardDAO.getCategoryProductDistribution());

            // 6. Xu hướng đơn hàng theo ngày / tuần / tháng / quý
            overview.put("orderTrendsData", dashboardDAO.getOrderTrendsChartData(filter != null ? filter : "day", startDate, endDate));

            // 7. Hiệu suất Shipper
            overview.put("shipperData", dashboardDAO.getShipperPerformanceData(startDate, endDate));

            // 8. Khung giờ giao hàng
            overview.put("deliverySlotsData", dashboardDAO.getDeliverySlotDistribution(startDate, endDate));

            // 9. Cơ cấu tương tác khách hàng & sử dụng web (Biểu đồ 9)
            overview.put("customerEngagementData", dashboardDAO.getCustomerEngagementStats(startDate, endDate));

            // Thẻ KPI động
            overview.put("kpiMetrics", dashboardDAO.getDynamicKpiMetrics(startDate, endDate));

            response.getWriter().write(gson.toJson(overview));

        } else if ("/api/payment-distribution".equals(servletPath)) {
            Map<String, Object> data = dashboardDAO.getPaymentMethodDistribution(startDate, endDate);
            response.getWriter().write(gson.toJson(data));

        } else if ("/api/top-products".equals(servletPath)) {
            int limit = 5;
            try {
                String lStr = request.getParameter("limit");
                if (lStr != null) limit = Integer.parseInt(lStr);
            } catch (Exception ignored) {}
            Map<String, Object> data = dashboardDAO.getTopSellingProducts(limit, startDate, endDate);
            response.getWriter().write(gson.toJson(data));

        } else if ("/api/order-trends".equals(servletPath)) {
            Map<String, Object> data = dashboardDAO.getOrderTrendsChartData(filter != null ? filter : "day", startDate, endDate);
            response.getWriter().write(gson.toJson(data));

        } else if ("/api/shipper-performance".equals(servletPath)) {
            Map<String, Object> data = dashboardDAO.getShipperPerformanceData(startDate, endDate);
            response.getWriter().write(gson.toJson(data));

        } else if ("/api/delivery-slots".equals(servletPath)) {
            Map<String, Object> data = dashboardDAO.getDeliverySlotDistribution(startDate, endDate);
            response.getWriter().write(gson.toJson(data));

        } else if ("/api/shipper-failure-stats".equals(servletPath)) {
            Long shipperId = null;
            try {
                String sIdStr = request.getParameter("shipperId");
                if (sIdStr != null && !sIdStr.isEmpty()) shipperId = Long.parseLong(sIdStr);
            } catch (Exception ignored) {}

            Map<String, Object> result = new HashMap<>();
            result.put("stats", shipperDeliveryDAO.getFailedDeliveryStats(shipperId, startDate, endDate));
            result.put("reasons", shipperDeliveryDAO.getFailedReasonsDistribution(shipperId, startDate, endDate));
            result.put("shippers", shipperDeliveryDAO.getShipperFailureComparison(startDate, endDate));

            response.getWriter().write(gson.toJson(result));

        } else if ("/api/order-status-data".equals(servletPath)) {
            if (filter == null || filter.isEmpty()) filter = "all";
            Map<String, Object> orderStatusData = dashboardDAO.getOrderStatusDistribution(filter, startDate, endDate);
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

        } else if ("/api/customer-engagement".equals(servletPath)) {
            Map<String, Object> data = dashboardDAO.getCustomerEngagementStats(startDate, endDate);
            response.getWriter().write(gson.toJson(data));

        } else {
            // Mặc định: /api/chart-data
            if (filter == null || filter.isEmpty()) filter = "month";
            Map<String, Object> comparativeData = dashboardDAO.getComparativeRevenueChartData(filter, startDate, endDate);
            @SuppressWarnings("unchecked")
            List<Double> currentData = (List<Double>) comparativeData.get("currentData");
            comparativeData.put("data", currentData);
            response.getWriter().write(gson.toJson(comparativeData));
        }
    }
}