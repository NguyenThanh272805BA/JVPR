package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IDashboardDAO;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAOImpl implements IDashboardDAO {

    @Override
    public double getTotalRevenue() {
        // Chỉ tính tiền các đơn đã thanh toán (PAID) hoặc đã hoàn thành
        String sql = "SELECT SUM(total_amount) FROM orders WHERE payment_status = 'PAID' OR status = 'COMPLETED'";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        return executeCountQuery(sql);
    }

    @Override
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        return executeCountQuery(sql);
    }

    @Override
    public int getOutOfStockProducts() {
        String sql = "SELECT COUNT(*) FROM products WHERE stock = 0";
        return executeCountQuery(sql);
    }

    @Override
    public Map<String, Double> getRevenueChartData(String filterType) {
        Map<String, Double> data = new LinkedHashMap<>();
        String sql = "";

        // Chỉ tính đơn hàng đã thanh toán (PAID) hoặc hoàn thành (COMPLETED)
        String baseCondition = "WHERE payment_status = 'PAID' OR status = 'COMPLETED' ";
        if ("day".equals(filterType)) {
            sql = "SELECT DATE_FORMAT(MAX(created_at), '%d/%m/%Y') as label, SUM(total_amount) as value " +
                    "FROM orders " + baseCondition +
                    "GROUP BY DATE(created_at) ORDER BY DATE(created_at) DESC LIMIT 7";
        } else if ("week".equals(filterType)) {
            sql = "SELECT CONCAT('Tuần ', WEEK(MAX(created_at))) as label, SUM(total_amount) as value " +
                    "FROM orders " + baseCondition +
                    "GROUP BY YEAR(created_at), WEEK(created_at) ORDER BY YEAR(created_at) DESC, WEEK(created_at) DESC LIMIT 5";
        } else if ("quarter".equals(filterType)) {
            sql = "SELECT CONCAT('Quý ', QUARTER(MAX(created_at)), '/', YEAR(MAX(created_at))) as label, SUM(total_amount) as value " +
                    "FROM orders " + baseCondition +
                    "GROUP BY YEAR(created_at), QUARTER(created_at) ORDER BY YEAR(created_at) DESC, QUARTER(created_at) DESC LIMIT 4";
        } else {
            // Mặc định là theo Tháng
            sql = "SELECT CONCAT('Tháng ', MONTH(MAX(created_at)), '/', YEAR(MAX(created_at))) as label, SUM(total_amount) as value " +
                    "FROM orders " + baseCondition +
                    "GROUP BY YEAR(created_at), MONTH(created_at) ORDER BY YEAR(created_at) DESC, MONTH(created_at) DESC LIMIT 6";
        }

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            // Dùng List tạm để đảo ngược thứ tự (hiển thị từ cũ nhất -> mới nhất trên biểu đồ từ trái sang phải)
            List<String> labels = new ArrayList<>();
            List<Double> values = new ArrayList<>();

            while (rs.next()) {
                labels.add(rs.getString("label"));
                values.add(rs.getDouble("value"));
            }

            for (int i = labels.size() - 1; i >= 0; i--) {
                data.put(labels.get(i), values.get(i));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }

    // Hàm dùng chung cho các câu lệnh COUNT
    private int executeCountQuery(String sql) {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}