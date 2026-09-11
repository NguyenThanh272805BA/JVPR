package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.ProductModel;
import java.util.List;
import java.util.Map;

public interface IDashboardDAO {
    double getTotalRevenue();
    int getTotalOrders();
    int getTotalProducts();
    int getOutOfStockProducts();
    Map<String, Double> getRevenueChartData(String filterType);
    List<ProductModel> getLowStockProducts(int threshold);

    // Mở rộng các phương thức nâng cao
    double getTotalCost();
    double getGrossProfit();
    Map<String, Object> getComparativeRevenueChartData(String filterType);
    Map<String, Object> getOrderStatusDistribution(String filterType);
    Map<String, Object> getCategoryProductDistribution();
    List<ProductModel> getProductsByCategory(int categoryId);
    Map<String, Object> getKpiComparativeMetrics();

    // Các phương thức hỗ trợ lọc theo khoảng ngày linh hoạt (startDate, endDate) & 8 biểu đồ chuyên biệt
    Map<String, Object> getComparativeRevenueChartData(String filterType, String startDate, String endDate);
    Map<String, Object> getOrderStatusDistribution(String filterType, String startDate, String endDate);
    Map<String, Object> getPaymentMethodDistribution(String startDate, String endDate);
    Map<String, Object> getTopSellingProducts(int limit, String startDate, String endDate);
    Map<String, Object> getOrderTrendsChartData(String startDate, String endDate);
    Map<String, Object> getOrderTrendsChartData(String filterType, String startDate, String endDate);
    Map<String, Object> getShipperPerformanceData(String startDate, String endDate);
    Map<String, Object> getDeliverySlotDistribution(String startDate, String endDate);
    Map<String, Object> getDynamicKpiMetrics(String startDate, String endDate);

    // Phương thức thống kê khách hàng, đăng ký & tương tác sử dụng web
    Map<String, Object> getCustomerGrowthChartData(String filterType, String startDate, String endDate);
    Map<String, Object> getCustomerEngagementStats(String startDate, String endDate);
}