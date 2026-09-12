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
            vn.edu.eaut.fruitables.dao.IProductDAO productDAO = new vn.edu.eaut.fruitables.dao.impl.ProductDAOImpl();
            for (CartItemDTO item : cart.values()) {
                double currentCostPrice = 0.0;
                double currentTaxRate = 0.0;
                try {
                    vn.edu.eaut.fruitables.model.entity.ProductModel p = productDAO.findById(item.getProductId());
                    if (p != null) {
                        if (p.getCostPrice() != null) {
                            currentCostPrice = p.getCostPrice();
                        }
                        if (p.getTaxRate() != null) {
                            currentTaxRate = p.getTaxRate();
                        }
                    }
                } catch (Exception ignored) {}

                orderDAO.saveOrderDetail(
                        orderId,
                        item.getProductId(),
                        item.getPrice(),
                        currentCostPrice,
                        item.getQuantity(),
                        item.getSubTotal(),
                        currentTaxRate
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
        // Cập nhật trạng thái và tự động hoàn trả tồn kho nếu là CANCELLED hoặc RETURNED trong cùng 1 Transaction
        orderDAO.updateStatusAndRestoreStock(orderId, status);

        if (order != null) {
            // Gửi email & thông báo khi đơn đang giao (SHIPPING)
            if ("SHIPPING".equalsIgnoreCase(status)) {
                if (order.getUserId() != null) {
                    // TRƯỜNG HỢP 1: Khách hàng có tài khoản
                    // Gửi thông báo trực tiếp lên giao diện Web (Notification Center)
                    notificationDAO.createNotification(
                            order.getUserId(),
                            order.getId(),
                            order.getOrderCode(),
                            "Đơn hàng " + order.getOrderCode() + " đang được giao!",
                            "Đơn hàng trái cây tươi mát của bạn đang trên đường vận chuyển hỏa tốc. Shipper sẽ liên hệ trong 1-2 giờ tới, vui lòng để ý điện thoại nhé!",
                            "ORDER_SHIPPING"
                    );

                    // Lấy email từ đơn hàng hoặc fallback từ hồ sơ tài khoản đã đăng ký
                    String targetEmail = order.getCustomerEmail();
                    if (targetEmail == null || targetEmail.trim().isEmpty()) {
                        vn.edu.eaut.fruitables.dao.IUserDAO userDAO = new vn.edu.eaut.fruitables.dao.impl.UserDAOImpl();
                        vn.edu.eaut.fruitables.model.entity.UserModel account = userDAO.findById(order.getUserId());
                        if (account != null && account.getEmail() != null) {
                            targetEmail = account.getEmail();
                        }
                    }

                    if (targetEmail != null && !targetEmail.trim().isEmpty()) {
                        String recipient = order.getRecipientName() != null ? order.getRecipientName() : "Quý khách";
                        double total = order.getTotalAmount() != null ? order.getTotalAmount() : 0.0;
                        emailService.sendShippingNotification(
                                targetEmail,
                                order.getOrderCode(),
                                recipient,
                                total,
                                "1 - 2 giờ tới (Hoa quả tươi giữ lạnh)"
                        );
                    }
                } else {
                    // TRƯỜNG HỢP 2: Khách vãng lai (không có tài khoản)
                    // Khách vãng lai theo dõi đơn hàng bằng SĐT tại trang /guest-tracking.
                    // Chỉ gửi email nếu khách vãng lai chủ động điền email lúc đặt hàng
                    String guestEmail = order.getCustomerEmail();
                    if (guestEmail != null && !guestEmail.trim().isEmpty()) {
                        String recipient = order.getRecipientName() != null ? order.getRecipientName() : "Quý khách";
                        double total = order.getTotalAmount() != null ? order.getTotalAmount() : 0.0;
                        emailService.sendShippingNotification(
                                guestEmail,
                                order.getOrderCode(),
                                recipient,
                                total,
                                "1 - 2 giờ tới (Hoa quả tươi giữ lạnh)"
                        );
                    }
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

    @Override
    public List<OrderModel> searchAndFilterOrders(String keyword, String status, String startDate, String endDate) {
        return orderDAO.searchAndFilterOrders(keyword, status, startDate, endDate);
    }
}