package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IDashboardDAO;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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