package vn.edu.eaut.fruitables.service;

import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.entity.OrderModel;

import java.util.List;
import java.util.Map;

public interface IOrderService {
    OrderModel createOrder(OrderModel orderModel, Map<Long, CartItemDTO> cart);
    List<OrderModel> findAll();
    OrderModel findByOrderCode(String orderCode);
}