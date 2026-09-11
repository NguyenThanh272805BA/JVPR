package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.OrderModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class OrderMapper implements IRowMapper<OrderModel> {
    @Override
    public OrderModel mapRow(ResultSet rs) {
        try {
            OrderModel order = new OrderModel();
            order.setId(rs.getLong("id"));
            order.setOrderCode(rs.getString("order_code"));
            order.setUserId(rs.getLong("user_id"));
            order.setTotalAmount(rs.getDouble("total_amount"));
            order.setShippingAddress(rs.getString("shipping_address"));
            order.setPhone(rs.getString("phone"));
            order.setPaymentMethod(rs.getString("payment_method"));
            order.setStatus(rs.getString("status"));
            order.setPaymentStatus(rs.getString("payment_status"));
            order.setCreatedAt(rs.getTimestamp("created_at"));
            try { order.setRecipientName(rs.getString("recipient_name")); } catch (Exception ignored) {}
            try { order.setCustomerEmail(rs.getString("customer_email")); } catch (Exception ignored) {}
            try { order.setOrderNotes(rs.getString("order_notes")); } catch (Exception ignored) {}
            try { order.setShippingFee(rs.getDouble("shipping_fee")); } catch (Exception ignored) {}
            try { order.setDistanceKm(rs.getDouble("distance_km")); } catch (Exception ignored) {}
            try { order.setShippingDiscount(rs.getDouble("shipping_discount")); } catch (Exception ignored) {}
            try { order.setDeliverySlot(rs.getString("delivery_slot")); } catch (Exception ignored) {}
            try { order.setDeliveryDate(rs.getDate("delivery_date")); } catch (Exception ignored) {}
            try {
                long sId = rs.getLong("shipper_id");
                if (!rs.wasNull()) order.setShipperId(sId);
            } catch (Exception ignored) {}
            try { order.setTrackingNumber(rs.getString("tracking_number")); } catch (Exception ignored) {}
            try { order.setEstimatedDeliveryTime(rs.getString("estimated_delivery_time")); } catch (Exception ignored) {}
            try { order.setUsedPoints(rs.getInt("used_points")); } catch (Exception ignored) {}
            try { order.setPointsDiscount(rs.getDouble("points_discount")); } catch (Exception ignored) {}
            try { order.setFailedReason(rs.getString("failed_reason")); } catch (Exception ignored) {}
            try { order.setFailedNotes(rs.getString("failed_notes")); } catch (Exception ignored) {}
            try { order.setFailedAt(rs.getTimestamp("failed_at")); } catch (Exception ignored) {}
            try { order.setDeliveryAttempts(rs.getInt("delivery_attempts")); } catch (Exception ignored) {}
            return order;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}