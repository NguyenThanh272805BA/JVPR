package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.dao.impl.NotificationDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.ProductDAOImpl;
import vn.edu.eaut.fruitables.model.entity.OrderModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/momo-return"})
public class MomoReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processPayment(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processPayment(request, response);
    }

    private void processPayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();

        String status = request.getParameter("status"); // SUCCESS hoặc CANCEL
        String orderCode = request.getParameter("orderCode");

        if (orderCode == null || orderCode.trim().isEmpty()) {
            orderCode = (String) session.getAttribute("PENDING_ORDER_CODE");
        }

        if (orderCode != null && !orderCode.trim().isEmpty()) {
            OrderDAOImpl orderDAO = new OrderDAOImpl();
            OrderModel order = orderDAO.findByOrderCode(orderCode);

            if ("SUCCESS".equalsIgnoreCase(status)) {
                // 1. Cập nhật trạng thái đơn hàng sang PAID và ĐANG ĐÓNG GÓI (PACKING)
                orderDAO.update("UPDATE orders SET payment_status = 'PAID', status = 'PACKING' WHERE order_code = ?", orderCode);

                if (order != null) {
                    // 2. Tự động trừ tồn kho sản phẩm khỏi kho hàng
                    ProductDAOImpl productDAO = new ProductDAOImpl();
                    productDAO.update(
                            "UPDATE products p JOIN order_details od ON p.id = od.product_id " +
                                    "SET p.stock = p.stock - od.quantity " +
                                    "WHERE od.order_id = ?", order.getId()
                    );

                    // 3. Tăng lượt dùng voucher nếu có
                    String appliedCoupon = (String) session.getAttribute("APPLIED_COUPON_CODE");
                    if (appliedCoupon != null && !appliedCoupon.trim().isEmpty()) {
                        productDAO.update("UPDATE coupons SET used_count = used_count + 1 WHERE code = ?", appliedCoupon.trim());
                    }

                    // 4. Tạo thông báo cho tài khoản người dùng
                    if (order.getUserId() != null) {
                        try {
                            NotificationDAOImpl notificationDAO = new NotificationDAOImpl();
                            notificationDAO.createNotification(
                                    order.getUserId(),
                                    order.getId(),
                                    orderCode,
                                    "Thanh toán MoMo thành công: " + orderCode,
                                    "Đơn hàng " + orderCode + " đã được thanh toán thành công qua Ví MoMo. Cửa hàng đang chuẩn bị giao đến bạn!",
                                    "ORDER_PAID"
                            );
                        } catch (Exception ignored) {}
                    }
                }

                // 5. Dọn dẹp giỏ hàng trong session
                session.removeAttribute("CART");
                session.removeAttribute("CART_TOTAL_ITEMS");
                session.removeAttribute("DISCOUNT_AMOUNT");
                session.removeAttribute("APPLIED_COUPON_CODE");
                session.removeAttribute("COUPON_MESSAGE");

                session.setAttribute("orderSuccess", "Thanh toán MoMo thành công! Đơn hàng " + orderCode + " đã được ghi nhận.");
            } else {
                // Khách hàng chủ động bấm Hủy thanh toán
                orderDAO.update("UPDATE orders SET payment_status = 'UNPAID', status = 'CANCELLED' WHERE order_code = ?", orderCode);
                session.setAttribute("orderSuccess", "Đã hủy thanh toán đơn hàng " + orderCode + ".");
            }
        }

        // Xóa thông tin đơn hàng chờ trong session
        session.removeAttribute("PENDING_ORDER_CODE");
        session.removeAttribute("PENDING_TOTAL_AMOUNT");
        session.removeAttribute("PENDING_METHOD");

        // Điều hướng về trang chủ
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
