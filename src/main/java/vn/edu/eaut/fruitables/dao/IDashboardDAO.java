package vn.edu.eaut.fruitables.dao;

public interface IDashboardDAO {
    double getTotalRevenue();
    int getTotalOrders();
    int getTotalProducts();
    int getOutOfStockProducts();
    java.util.Map<String, Double> getRevenueChartData(String filterType);
}