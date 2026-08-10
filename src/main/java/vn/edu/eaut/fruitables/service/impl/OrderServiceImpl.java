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
        // 1. Lưu Order vào bảng orders và lấy lại ID tự sinh
        Long orderId = orderDAO.saveOrder(orderModel);

        if (orderId != null) {
            orderModel.setId(orderId);

            // 2. Duyệt qua giỏ hàng và lưu từng sản phẩm vào bảng order_details
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
        return orderDAO.findByOrderCode(orderCode);
    }
}