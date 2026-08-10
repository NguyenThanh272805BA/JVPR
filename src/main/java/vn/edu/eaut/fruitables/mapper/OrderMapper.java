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
            order.setCreatedAt(rs.getTimestamp("created_at"));
            return order;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}