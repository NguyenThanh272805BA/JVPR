package vn.edu.eaut.fruitables.service.impl;

import vn.edu.eaut.fruitables.dao.IOrderDAO;
import vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl;
import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.service.IOrderService;

import java.util.List;
import java.util.Map;

public class OrderServiceImpl implements IOrderService {

    private IOrderDAO orderDAO;

    public OrderServiceImpl() {
        this.orderDAO = new OrderDAOImpl();
    }

    @Override
    public OrderModel createOrder(OrderModel orderModel, Map<Long, CartItemDTO> cart) {
        Long orderId = orderDAO.saveOrder(orderModel);

        if (orderId != null) {
            orderModel.setId(orderId);
            for (CartItemDTO item : cart.values()) {
                orderDAO.saveOrderDetail(
                        orderId,
                        item.getProductId(),
                        item.getPrice(),
                        item.getQuantity(),
                        item.getSubTotal()
                );
            }
            return orderModel;
        }
        return null;
    }

    @Override
    public List<OrderModel> findAll() {
        return orderDAO.findAll();
    }

    @Override
    public OrderModel findByOrderCode(String orderCode) {
        OrderModel order = orderDAO.findByOrderCode(orderCode);
        if (order != null) {
            order.setDetails(orderDAO.findOrderDetailsByOrderId(order.getId()));
        }
        return order;
    }

    @Override
    public List<OrderModel> findByPhoneOrOrderCode(String phone, String orderCode) {
        List<OrderModel> orders = orderDAO.findByPhoneOrOrderCode(phone, orderCode);
        if (orders != null) {
            for (OrderModel order : orders) {
                order.setDetails(orderDAO.findOrderDetailsByOrderId(order.getId()));
            }
        }
        return orders;
    }

    @Override
    public void updateOrderStatus(Long orderId, String status) {
        orderDAO.updateOrderStatus(orderId, status);
    }

    @Override
    public boolean cancelOrderAndRestoreStock(Long orderId) {
        return orderDAO.cancelOrderAndRestoreStock(orderId);
    }
}