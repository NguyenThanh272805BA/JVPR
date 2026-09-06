package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.IOrderService;
import vn.edu.eaut.fruitables.service.impl.OrderServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/order/cancel"})
public class CancelOrderServlet extends HttpServlet {

    private IOrderService orderService = new OrderServiceImpl();
    private OrderDAOImpl orderDAO = new OrderDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String orderIdStr = request.getParameter("orderId");
        String reason = request.getParameter("reason");
        String from = request.getParameter("from"); // "history" or "tracking"
        String phone = request.getParameter("phone");
        String orderCode = request.getParameter("orderCode");

        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        try {
            Long orderId = Long.parseLong(orderIdStr);
            OrderModel order = orderDAO.findById(orderId);

            if (order == null) {
                session.setAttribute("ORDER_MESSAGE_ERROR", "Đơn hàng không tồn tại.");
            } else if (!"PENDING".equalsIgnoreCase(order.getStatus())) {
                session.setAttribute("ORDER_MESSAGE_ERROR", "Chỉ có thể hủy đơn hàng khi đơn đang ở trạng thái 'Đang xử lý' (Chưa giao đi).");
            } else {
                // Kiểm tra quyền hủy đơn: user đăng nhập hoặc mã đơn hàng khớp
                UserModel user = (UserModel) session.getAttribute("USERMODEL");
                boolean authorized = false;

                if (user != null && order.getUserId() != null && order.getUserId().equals(user.getId())) {
                    authorized = true;
                } else if (orderCode != null && orderCode.equalsIgnoreCase(order.getOrderCode())) {
                    authorized = true;
                } else if (phone != null && phone.equals(order.getPhone())) {
                    authorized = true;
                }

                if (authorized) {
                    boolean success = orderService.cancelOrderAndRestoreStock(orderId);
                    if (success) {
                        session.setAttribute("ORDER_MESSAGE_SUCCESS", "Hủy đơn hàng thành công! Số lượng sản phẩm đã được hoàn trả lại vào kho.");
                    } else {
                        session.setAttribute("ORDER_MESSAGE_ERROR", "Không thể hủy đơn hàng hoặc đơn hàng đã được chuyển trạng thái.");
                    }
                } else {
                    session.setAttribute("ORDER_MESSAGE_ERROR", "Bạn không có quyền hủy đơn hàng này.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("ORDER_MESSAGE_ERROR", "Có lỗi xảy ra: " + e.getMessage());
        }

        if ("tracking".equals(from)) {
            response.sendRedirect(request.getContextPath() + "/guest-tracking");
        } else {
            response.sendRedirect(request.getContextPath() + "/order-history");
        }
    }
}
