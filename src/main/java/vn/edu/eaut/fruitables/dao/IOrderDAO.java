package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.OrderDetailModel;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import java.util.List;

public interface IOrderDAO extends GenericDAO<OrderModel> {
    Long saveOrder(OrderModel order);
    void saveOrderDetail(Long orderId, Long productId, Double price, Integer quantity, Double subTotal);
    List<OrderModel> findAll();
    OrderModel findById(Long id);
    OrderModel findByOrderCode(String orderCode);
    List<OrderModel> findByUserId(Long userId);
    List<OrderModel> findByPhoneOrOrderCode(String phone, String orderCode);
    void updateOrderStatus(Long orderId, String status);
    List<OrderDetailModel> findOrderDetailsByOrderId(Long orderId);
    boolean cancelOrderAndRestoreStock(Long orderId);
}