package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.dao.INotificationDAO;
import vn.edu.eaut.fruitables.dao.IOrderDAO;
import vn.edu.eaut.fruitables.dao.IShipperDAO;
import vn.edu.eaut.fruitables.dao.impl.NotificationDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.ShipperDAOImpl;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.ShipperModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/orders/dispatch"})
public class AdminDispatchServlet extends HttpServlet {

    private final IOrderDAO orderDAO = new OrderDAOImpl();
    private final IShipperDAO shipperDAO = new ShipperDAOImpl();
    private final INotificationDAO notificationDAO = new NotificationDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ShipperModel> shippers = shipperDAO.findAll();
        request.setAttribute("shippers", shippers);
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || "true".equalsIgnoreCase(request.getParameter("ajax"));

        try {
            long orderId = Long.parseLong(request.getParameter("orderId"));
            long shipperId = Long.parseLong(request.getParameter("shipperId"));
            String estimatedTime = request.getParameter("estimatedTime");

            OrderModel order = orderDAO.findById(orderId);
            ShipperModel shipper = shipperDAO.findById(shipperId);

            if (order == null || shipper == null) {
                if (isAjax) {
                    response.getWriter().write("{\"success\":false,\"message\":\"Đơn hàng hoặc Shipper không tồn tại!\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/orders?error=not_found");
                }
                return;
            }

            if (estimatedTime == null || estimatedTime.trim().isEmpty()) {
                estimatedTime = "Giao trong 60 - 90 phút";
            }

            String trackingNumber = "FRUIT-" + (100000 + (int) (Math.random() * 900000));

            boolean ok = orderDAO.assignShipper(orderId, shipperId, trackingNumber, estimatedTime);
            if (ok) {
                // Tạo thông báo cho khách hàng
                if (order.getUserId() != null && order.getUserId() > 0) {
                    try {
                        notificationDAO.createNotification(
                                order.getUserId(),
                                order.getId(),
                                order.getOrderCode(),
                                "Tài xế đang giao đơn hàng #" + order.getOrderCode(),
                                "Tài xế " + shipper.getFullName() + " (" + shipper.getPhone() + ") đã nhận đơn hàng và đang giao hỏa tốc đến bạn với thùng giữ nhiệt 4°C.",
                                "ORDER_SHIPPING"
                        );
                    } catch (Exception ignored) {}
                }

                if (isAjax) {
                    response.getWriter().write(String.format(
                            "{\"success\":true,\"message\":\"Bàn giao tài xế thành công!\",\"trackingNumber\":\"%s\",\"shipperName\":\"%s\",\"phone\":\"%s\",\"vehiclePlate\":\"%s\"}",
                            trackingNumber, shipper.getFullName(), shipper.getPhone(), shipper.getVehiclePlate()
                    ));
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/orders?msg=dispatched");
                }
            } else {
                if (isAjax) {
                    response.getWriter().write("{\"success\":false,\"message\":\"Không thể cập nhật điều phối đơn hàng!\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/orders?error=failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                response.getWriter().write("{\"success\":false,\"message\":\"Lỗi hệ thống: " + e.getMessage() + "\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=exception");
            }
        }
    }
}
