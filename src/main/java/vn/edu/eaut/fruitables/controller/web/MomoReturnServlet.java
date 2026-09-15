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
        // Chống giả mạo URL GET: Chỉ cho phép xử lý qua form POST từ trang thanh toán
        response.sendRedirect(request.getContextPath() + "/home");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processPayment(request, response);
    }

    private void processPayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();

        String status = request.getParameter("status"); // SUCCESS hoặc CANCEL
        String orderCode = request.getParameter("orderCode");
        String pendingOrderCode = (String) session.getAttribute("PENDING_ORDER_CODE");

        // BẢO MẬT: Bắt buộc orderCode phải khớp chính xác với đơn hàng đang chờ trong phiên đăng nhập hiện tại
        if (orderCode == null || pendingOrderCode == null || !orderCode.trim().equalsIgnoreCase(pendingOrderCode.trim())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Yêu cầu thanh toán không hợp lệ hoặc phiên giao dịch đã hết hạn.");
            return;
        }

        OrderDAOImpl orderDAO = new OrderDAOImpl();
        OrderModel order = orderDAO.findByOrderCode(orderCode);

        if (order != null) {
            if ("SUCCESS".equalsIgnoreCase(status)) {
                // Khách xác nhận đã chuyển khoản qua QR MoMo -> Ghi nhận trạng thái PENDING chờ Admin đối soát
                orderDAO.update("UPDATE orders SET payment_status = 'UNPAID', status = 'PENDING' WHERE order_code = ?", orderCode);

                if (order.getUserId() != null) {
                    try {
                        NotificationDAOImpl notificationDAO = new NotificationDAOImpl();
                        notificationDAO.createNotification(
                                order.getUserId(),
                                order.getId(),
                                orderCode,
                                "Xác nhận chuyển khoản MoMo: " + orderCode,
                                "Fruitables đã tiếp nhận thông tin chuyển khoản của đơn hàng " + orderCode + ". Cửa hàng sẽ đối soát và sớm liên hệ giao hàng!",
                                "ORDER_PENDING"
                        );
                    } catch (Exception ignored) {}
                }

                // Dọn dẹp giỏ hàng trong session
                session.removeAttribute("CART");
                session.removeAttribute("CART_TOTAL_ITEMS");
                session.removeAttribute("DISCOUNT_AMOUNT");
                session.removeAttribute("APPLIED_COUPON_CODE");
                session.removeAttribute("COUPON_MESSAGE");

                session.setAttribute("orderSuccess", "Đã gửi thông tin thanh toán MoMo cho đơn hàng " + orderCode + ". Cửa hàng sẽ liên hệ xác nhận trong thời gian sớm nhất!");
            } else {
                // Khách hàng chủ động bấm Hủy thanh toán hoặc giao dịch thất bại -> Hủy và hoàn trả tồn kho + voucher
                orderDAO.updateStatusAndRestoreStock(order.getId(), "CANCELLED");
                orderDAO.update("UPDATE orders SET payment_status = 'UNPAID' WHERE id = ?", order.getId());
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
