package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IOrderDAO;
import vn.edu.eaut.fruitables.mapper.OrderMapper;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.OrderDetailModel;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl extends AbstractDAO<OrderModel> implements IOrderDAO {

    @Override
    public Long saveOrder(OrderModel order) {
        String sql = "INSERT INTO orders (order_code, user_id, total_amount, shipping_address, phone, payment_method, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        return insert(sql, order.getOrderCode(), order.getUserId(), order.getTotalAmount(), order.getShippingAddress(), order.getPhone(), order.getPaymentMethod(), order.getStatus());
    }

    @Override
    public void saveOrderDetail(Long orderId, Long productId, Double price, Integer quantity, Double subTotal) {
        String sql = "INSERT INTO order_details (order_id, product_id, price, quantity, sub_total) VALUES (?, ?, ?, ?, ?)";
        insert(sql, orderId, productId, price, quantity, subTotal); // Tái sử dụng hàm insert của AbstractDAO
    }

    @Override
    public List<OrderModel> findAll() {
        String sql = "SELECT * FROM orders ORDER BY id DESC";
        return query(sql, new OrderMapper());
    }

    @Override
    public OrderModel findById(Long id) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        List<OrderModel> orders = query(sql, new OrderMapper(), id);
        return orders.isEmpty() ? null : orders.get(0);
    }

    @Override
    public OrderModel findByOrderCode(String orderCode) {
        String sql = "SELECT * FROM orders WHERE order_code = ?";
        List<OrderModel> orders = query(sql, new OrderMapper(), orderCode);
        return orders.isEmpty() ? null : orders.get(0);
    }

    @Override
    public List<OrderModel> findByUserId(Long userId) {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        return query(sql, new OrderMapper(), userId);
    }

    // BỔ SUNG: Lấy danh sách sản phẩm chi tiết trong 1 đơn hàng cụ thể kèm tên và ảnh
    public List<OrderDetailModel> findOrderDetailsByOrderId(Long orderId) {
        String sql = "SELECT od.*, p.name AS product_name, p.image_url AS product_image " +
                "FROM order_details od " +
                "JOIN products p ON od.product_id = p.id " +
                "WHERE od.order_id = ?";

        List<OrderDetailModel> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetailModel detail = new OrderDetailModel();
                    detail.setId(rs.getLong("id"));
                    detail.setOrderId(rs.getLong("order_id"));
                    detail.setProductId(rs.getLong("product_id"));
                    detail.setPrice(rs.getDouble("price"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setSubTotal(rs.getDouble("sub_total"));

                    // Lấy thêm thông tin tên và ảnh sản phẩm từ bảng products
                    detail.setProductName(rs.getString("product_name"));
                    detail.setProductImageUrl(rs.getString("product_image"));

                    list.add(detail);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}