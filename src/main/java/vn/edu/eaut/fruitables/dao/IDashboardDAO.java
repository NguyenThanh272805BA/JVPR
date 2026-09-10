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
}