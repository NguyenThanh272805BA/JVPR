package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IOrderDAO;
import vn.edu.eaut.fruitables.mapper.OrderMapper;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.OrderDetailModel;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl extends AbstractDAO<OrderModel> implements IOrderDAO {

    @Override
    public Long saveOrder(OrderModel order) {
        String sql = "INSERT INTO orders (order_code, user_id, recipient_name, total_amount, shipping_fee, distance_km, shipping_discount, shipping_address, phone, customer_email, order_notes, payment_method, status, delivery_slot, delivery_date, used_points, points_discount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return insert(sql, 
                order.getOrderCode(), 
                order.getUserId(), 
                order.getRecipientName(), 
                order.getTotalAmount(), 
                order.getShippingFee() != null ? order.getShippingFee() : 0.0,
                order.getDistanceKm() != null ? order.getDistanceKm() : 0.0,
                order.getShippingDiscount() != null ? order.getShippingDiscount() : 0.0,
                order.getShippingAddress(), 
                order.getPhone(), 
                order.getCustomerEmail(), 
                order.getOrderNotes(), 
                order.getPaymentMethod(), 
                order.getStatus(),
                order.getDeliverySlot() != null ? order.getDeliverySlot() : "FAST_1_2H",
                order.getDeliveryDate(),
                order.getUsedPoints() != null ? order.getUsedPoints() : 0,
                order.getPointsDiscount() != null ? order.getPointsDiscount() : 0.0
        );
    }

    @Override
    public void saveOrderDetail(Long orderId, Long productId, Double price, Integer quantity, Double subTotal) {
        saveOrderDetail(orderId, productId, price, 0.0, quantity, subTotal);
    }

    @Override
    public void saveOrderDetail(Long orderId, Long productId, Double price, Double costPrice, Integer quantity, Double subTotal) {
        String sql = "INSERT INTO order_details (order_id, product_id, price, cost_price, quantity, sub_total) VALUES (?, ?, ?, ?, ?, ?)";
        insert(sql, orderId, productId, price, costPrice != null ? costPrice : 0.0, quantity, subTotal);
    }

    @Override
    public List<OrderModel> findAll() {
        String sql = "SELECT * FROM orders ORDER BY id DESC";
        return query(sql, new OrderMapper());
    }

    @Override
    public void populateShipper(OrderModel order) {
        if (order != null && order.getShipperId() != null) {
            ShipperDAOImpl shipperDAO = new ShipperDAOImpl();
            order.setShipper(shipperDAO.findById(order.getShipperId()));
        }
    }

    @Override
    public OrderModel findById(Long id) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        List<OrderModel> orders = query(sql, new OrderMapper(), id);
        if (orders == null || orders.isEmpty()) return null;
        OrderModel order = orders.get(0);
        populateShipper(order);
        return order;
    }

    @Override
    public OrderModel findByOrderCode(String orderCode) {
        String sql = "SELECT * FROM orders WHERE order_code = ?";
        List<OrderModel> orders = query(sql, new OrderMapper(), orderCode);
        if (orders == null || orders.isEmpty()) return null;
        OrderModel order = orders.get(0);
        populateShipper(order);
        return order;
    }

    @Override
    public List<OrderModel> findByUserId(Long userId) {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        List<OrderModel> orders = query(sql, new OrderMapper(), userId);
        if (orders != null) {
            for (OrderModel o : orders) populateShipper(o);
        }
        return orders;
    }

    @Override
    public List<OrderModel> findByPhoneOrOrderCode(String phone, String orderCode) {
        boolean hasPhone = (phone != null && !phone.trim().isEmpty());
        boolean hasCode = (orderCode != null && !orderCode.trim().isEmpty());

        // BẢO MẬT: Bắt buộc người dùng phải cung cấp ĐỒNG THỜI cả SĐT và Mã đơn hàng
        // Ngăn chặn kẻ xấu chỉ gõ SĐT để xem trộm toàn bộ địa chỉ, lịch sử đơn hàng của người khác
        if (hasPhone && hasCode) {
            String sql = "SELECT * FROM orders WHERE phone = ? AND order_code = ? ORDER BY created_at DESC";
            List<OrderModel> orders = query(sql, new OrderMapper(), phone.trim(), orderCode.trim());
            if (orders != null) {
                for (OrderModel o : orders) populateShipper(o);
            }
            return orders;
        }
        return new ArrayList<>();
    }

    @Override
    public void updateOrderStatus(Long orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        update(sql, status, orderId);
    }

    @Override
    public boolean updateStatusAndRestoreStock(Long orderId, String newStatus) {
        Connection conn = null;
        PreparedStatement psCheck = null;
        PreparedStatement psOrder = null;
        PreparedStatement psStock = null;
        ResultSet rsCheck = null;
        try {
            conn = DBConnectionUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Khóa và kiểm tra trạng thái hiện tại của đơn hàng
            String checkSql = "SELECT status FROM orders WHERE id = ? FOR UPDATE";
            psCheck = conn.prepareStatement(checkSql);
            psCheck.setLong(1, orderId);
            rsCheck = psCheck.executeQuery();
            if (!rsCheck.next()) {
                conn.rollback();
                return false;
            }
            String currentStatus = rsCheck.getString("status");

            // 2. Nếu chuyển sang CANCELLED hoặc RETURNED mà đơn trước đó CHƯA bị hủy/hoàn:
            // -> Hoàn trả tồn kho cho tất cả sản phẩm
            boolean isCancellingOrReturning = "CANCELLED".equalsIgnoreCase(newStatus) || "RETURNED".equalsIgnoreCase(newStatus);
            boolean wasAlreadyCancelledOrReturned = "CANCELLED".equalsIgnoreCase(currentStatus) || "RETURNED".equalsIgnoreCase(currentStatus);

            if (isCancellingOrReturning && !wasAlreadyCancelledOrReturned) {
                List<OrderDetailModel> details = findOrderDetailsByOrderId(orderId);
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
            }

            // 3. Cập nhật trạng thái mới cho đơn hàng
            String updateOrderSql = "UPDATE orders SET status = ? WHERE id = ?";
            psOrder = conn.prepareStatement(updateOrderSql);
            psOrder.setString(1, newStatus);
            psOrder.setLong(2, orderId);
            psOrder.executeUpdate();

            // 4. Nếu đơn hoàn tất/kết thúc giao, giải phóng trạng thái Shipper về AVAILABLE
            if ("DELIVERED".equalsIgnoreCase(newStatus) || "COMPLETED".equalsIgnoreCase(newStatus)
                    || "CANCELLED".equalsIgnoreCase(newStatus) || "RETURNED".equalsIgnoreCase(newStatus)) {
                String releaseShipperSql = "UPDATE shippers SET status = 'AVAILABLE' WHERE id = (SELECT shipper_id FROM orders WHERE id = ?)";
                try (PreparedStatement psRelease = conn.prepareStatement(releaseShipperSql)) {
                    psRelease.setLong(1, orderId);
                    psRelease.executeUpdate();
                } catch (Exception ignored) {}
            }

            // 5. Tự động cộng điểm thưởng cho thành viên khi đơn đạt COMPLETED (10.000đ = 1 điểm)
            if ("COMPLETED".equalsIgnoreCase(newStatus) && !"COMPLETED".equalsIgnoreCase(currentStatus)) {
                String pointSql = "SELECT user_id, total_amount FROM orders WHERE id = ?";
                try (PreparedStatement psP = conn.prepareStatement(pointSql)) {
                    psP.setLong(1, orderId);
                    try (ResultSet rsP = psP.executeQuery()) {
                        if (rsP.next()) {
                            long uId = rsP.getLong("user_id");
                            double total = rsP.getDouble("total_amount");
                            if (!rsP.wasNull() && uId > 0 && total >= 10000) {
                                int earnedPoints = (int) (total / 10000);
                                if (earnedPoints > 0) {
                                    String updatePointsSql = "UPDATE users SET points = points + ?, accumulated_points = accumulated_points + ? WHERE id = ?";
                                    try (PreparedStatement psU = conn.prepareStatement(updatePointsSql)) {
                                        psU.setInt(1, earnedPoints);
                                        psU.setInt(2, earnedPoints);
                                        psU.setLong(3, uId);
                                        psU.executeUpdate();
                                    }
                                    String insertLogSql = "INSERT INTO point_transactions (user_id, order_id, points_amount, transaction_type, description) VALUES (?, ?, ?, 'EARN', ?)";
                                    try (PreparedStatement psLog = conn.prepareStatement(insertLogSql)) {
                                        psLog.setLong(1, uId);
                                        psLog.setLong(2, orderId);
                                        psLog.setInt(3, earnedPoints);
                                        psLog.setString(4, "Tích điểm đơn hàng hoàn tất #" + orderId);
                                        psLog.executeUpdate();
                                    }
                                }
                            }
                        }
                    }
                } catch (Exception ignored) {}
            }

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
                    detail.setCostPrice(rs.getDouble("cost_price"));
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
        return updateStatusAndRestoreStock(orderId, "CANCELLED");
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

    @Override
    public boolean assignShipper(Long orderId, Long shipperId, String trackingNumber, String estimatedDeliveryTime) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psShipper = null;
        try {
            conn = DBConnectionUtil.getConnection();
            conn.setAutoCommit(false);

            String sqlOrder = "UPDATE orders SET shipper_id = ?, tracking_number = ?, estimated_delivery_time = ?, status = 'SHIPPING' WHERE id = ?";
            psOrder = conn.prepareStatement(sqlOrder);
            psOrder.setLong(1, shipperId);
            psOrder.setString(2, trackingNumber);
            psOrder.setString(3, estimatedDeliveryTime);
            psOrder.setLong(4, orderId);
            psOrder.executeUpdate();

            String sqlShipper = "UPDATE shippers SET status = 'BUSY' WHERE id = ?";
            psShipper = conn.prepareStatement(sqlShipper);
            psShipper.setLong(1, shipperId);
            psShipper.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (psOrder != null) psOrder.close();
                if (psShipper != null) psShipper.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException ignored) {}
        }
    }
}