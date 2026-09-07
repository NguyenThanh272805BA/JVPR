package vn.edu.eaut.fruitables.service.impl;

import vn.edu.eaut.fruitables.dao.INotificationDAO;
import vn.edu.eaut.fruitables.dao.IOrderDAO;
import vn.edu.eaut.fruitables.dao.impl.NotificationDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl;
import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.service.IOrderService;
import vn.edu.eaut.fruitables.service.impl.EmailServiceImpl;

import java.util.List;
import java.util.Map;

public class OrderServiceImpl implements IOrderService {

    private IOrderDAO orderDAO;
    private INotificationDAO notificationDAO;
    private EmailServiceImpl emailService;

    public OrderServiceImpl() {
        this.orderDAO = new OrderDAOImpl();
        this.notificationDAO = new NotificationDAOImpl();
        this.emailService = new EmailServiceImpl();
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
    public OrderModel findById(Long id) {
        OrderModel order = orderDAO.findById(id);
        if (order != null) {
            order.setDetails(orderDAO.findOrderDetailsByOrderId(order.getId()));
        }
        return order;
    }

    @Override
    public List<OrderModel> findByUserId(Long userId) {
        List<OrderModel> orders = orderDAO.findByUserId(userId);
        if (orders != null) {
            for (OrderModel order : orders) {
                order.setDetails(orderDAO.findOrderDetailsByOrderId(order.getId()));
            }
        }
        return orders;
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
        OrderModel order = orderDAO.findById(orderId);
        orderDAO.updateOrderStatus(orderId, status);

        if (order != null) {
            // Hoàn kho nếu hủy hoặc hoàn đơn
            if ("CANCELLED".equalsIgnoreCase(status) || "RETURNED".equalsIgnoreCase(status)) {
                orderDAO.cancelOrderAndRestoreStock(orderId);
            }

            // Gửi email & thông báo khi đơn đang giao (SHIPPING)
            if ("SHIPPING".equalsIgnoreCase(status)) {
                String customerEmail = order.getCustomerEmail();
                if (customerEmail != null && !customerEmail.trim().isEmpty()) {
                    String recipient = order.getRecipientName() != null ? order.getRecipientName() : "Quý khách";
                    double total = order.getTotalAmount() != null ? order.getTotalAmount() : 0.0;
                    emailService.sendShippingNotification(
                            customerEmail,
                            order.getOrderCode(),
                            recipient,
                            total,
                            "1 - 2 giờ tới (Hoa quả tươi giữ lạnh)"
                    );
                }

                if (order.getUserId() != null) {
                    notificationDAO.createNotification(
                            order.getUserId(),
                            order.getId(),
                            order.getOrderCode(),
                            "Đơn hàng " + order.getOrderCode() + " đang được giao!",
                            "Đơn hàng trái cây tươi mát của bạn đang trên đường vận chuyển hỏa tốc. Shipper sẽ liên hệ trong 1-2 giờ tới, vui lòng để ý điện thoại nhé!",
                            "ORDER_SHIPPING"
                    );
                }
            } else if ("DELIVERED".equalsIgnoreCase(status) || "COMPLETED".equalsIgnoreCase(status)) {
                if (order.getUserId() != null) {
                    notificationDAO.createNotification(
                            order.getUserId(),
                            order.getId(),
                            order.getOrderCode(),
                            "Đơn hàng " + order.getOrderCode() + " đã giao thành công!",
                            "Đơn hàng đã được giao đến bạn. Cảm ơn bạn đã lựa chọn Fruitables! Chúc bạn và gia đình thưởng thức hoa quả thật ngon miệng.",
                            "ORDER_DELIVERED"
                    );
                }
            } else if ("CONFIRMED".equalsIgnoreCase(status)) {
                if (order.getUserId() != null) {
                    notificationDAO.createNotification(
                            order.getUserId(),
                            order.getId(),
                            order.getOrderCode(),
                            "Đơn hàng " + order.getOrderCode() + " đã được xác nhận!",
                            "Fruitables đã nhận và xác nhận đơn hàng của bạn. Chúng tôi đang tiến hành chọn lọc những trái cây tươi ngon nhất.",
                            "ORDER_CONFIRMED"
                    );
                }
            }
        }
    }

    @Override
    public boolean cancelOrderAndRestoreStock(Long orderId) {
        return orderDAO.cancelOrderAndRestoreStock(orderId);
    }
}