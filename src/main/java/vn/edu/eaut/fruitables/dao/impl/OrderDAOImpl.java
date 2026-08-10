package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IOrderDAO;
import vn.edu.eaut.fruitables.mapper.OrderMapper;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
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
}