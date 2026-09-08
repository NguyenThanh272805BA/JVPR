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
        String sql = "INSERT INTO orders (order_code, user_id, recipient_name, total_amount, shipping_address, phone, customer_email, order_notes, payment_method, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return insert(sql, order.getOrderCode(), order.getUserId(), order.getRecipientName(), order.getTotalAmount(), order.getShippingAddress(), order.getPhone(), order.getCustomerEmail(), order.getOrderNotes(), order.getPaymentMethod(), order.getStatus());
    }

    @Override
    public void saveOrderDetail(Long orderId, Long productId, Double price, Integer quantity, Double subTotal) {
        String sql = "INSERT INTO order_details (order_id, product_id, price, quantity, sub_total) VALUES (?, ?, ?, ?, ?)";
        insert(sql, orderId, productId, price, quantity, subTotal);
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

    @Override
    public List<OrderModel> findByPhoneOrOrderCode(String phone, String orderCode) {
        boolean hasPhone = (phone != null && !phone.trim().isEmpty());
        boolean hasCode = (orderCode != null && !orderCode.trim().isEmpty());

        if (hasPhone && hasCode) {
            String sql = "SELECT * FROM orders WHERE phone = ? AND order_code = ? ORDER BY created_at DESC";
            return query(sql, new OrderMapper(), phone.trim(), orderCode.trim());
        } else if (hasPhone) {
            String sql = "SELECT * FROM orders WHERE phone = ? ORDER BY created_at DESC";
            return query(sql, new OrderMapper(), phone.trim());
        } else if (hasCode) {
            String sql = "SELECT * FROM orders WHERE order_code = ? ORDER BY created_at DESC";
            return query(sql, new OrderMapper(), orderCode.trim());
        }
        return new ArrayList<>();
    }

    @Override
    public void updateOrderStatus(Long orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        update(sql, status, orderId);
    }

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

    @Override
    public boolean cancelOrderAndRestoreStock(Long orderId) {
        Connection conn = null;
        PreparedStatement psCheck = null;
        PreparedStatement psOrder = null;
        PreparedStatement psStock = null;
        ResultSet rsCheck = null;
        try {
            conn = DBConnectionUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Kiểm tra trạng thái đơn hàng có phải PENDING không
            String checkSql = "SELECT status FROM orders WHERE id = ? FOR UPDATE";
            psCheck = conn.prepareStatement(checkSql);
            psCheck.setLong(1, orderId);
            rsCheck = psCheck.executeQuery();
            if (!rsCheck.next()) {
                conn.rollback();
                return false;
            }
            String status = rsCheck.getString("status");
            if (!"PENDING".equalsIgnoreCase(status)) {
                // Đơn hàng không còn ở trạng thái PENDING -> không cho hủy
                conn.rollback();
                return false;
            }

            // 2. Lấy danh sách sản phẩm trong chi tiết đơn hàng
            List<OrderDetailModel> details = findOrderDetailsByOrderId(orderId);

            // 3. Hoàn trả tồn kho cho các sản phẩm
            if (details != null && !details.isEmpty()) {
                String stockSql = "UPDATE products SET stock = stock + ? WHERE id = ?";
                psStock = conn.prepareStatement(stockSql);
                for (OrderDetailModel item : details) {
                    psStock.setInt(1, item.getQuantity());
                    psStock.setLong(2, item.getProductId());
                    psStock.addBatch();
                }
                psStock.executeBatch();
            }

            // 4. Cập nhật trạng thái đơn hàng thành CANCELLED
            String updateOrderSql = "UPDATE orders SET status = 'CANCELLED' WHERE id = ?";
            psOrder = conn.prepareStatement(updateOrderSql);
            psOrder.setLong(1, orderId);
            psOrder.executeUpdate();

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            try { if (rsCheck != null) rsCheck.close(); } catch (Exception e) {}
            try { if (psCheck != null) psCheck.close(); } catch (Exception e) {}
            try { if (psStock != null) psStock.close(); } catch (Exception e) {}
            try { if (psOrder != null) psOrder.close(); } catch (Exception e) {}
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {}
        }
    }

    @Override
    public List<OrderModel> searchAndFilterOrders(String keyword, String status, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT * FROM orders WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (order_code LIKE ? OR recipient_name LIKE ? OR phone LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND status = ? ");
            params.add(status.trim());
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append("AND created_at >= ? ");
            params.add(startDate.trim() + " 00:00:00");
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append("AND created_at <= ? ");
            params.add(endDate.trim() + " 23:59:59");
        }

        sql.append("ORDER BY id DESC");
        return query(sql.toString(), new OrderMapper(), params.toArray());
    }
}