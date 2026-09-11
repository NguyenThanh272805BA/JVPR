package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.dao.IShipperDAO;
import vn.edu.eaut.fruitables.dao.IShipperDeliveryDAO;
import vn.edu.eaut.fruitables.dao.impl.ShipperDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.ShipperDeliveryDAOImpl;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.ShipperModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/delivery-failures", "/shipper/failures"})
public class AdminDeliveryFailuresServlet extends HttpServlet {

    private final IShipperDeliveryDAO shipperDeliveryDAO = new ShipperDeliveryDAOImpl();
    private final IShipperDAO shipperDAO = new ShipperDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String shipperIdStr = request.getParameter("shipperId");
        String reason = request.getParameter("reason");
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String keyword = request.getParameter("keyword");

        Long shipperId = null;
        try {
            if (shipperIdStr != null && !shipperIdStr.trim().isEmpty() && !"ALL".equalsIgnoreCase(shipperIdStr)) {
                shipperId = Long.parseLong(shipperIdStr.trim());
            }
        } catch (Exception ignored) {}

        List<OrderModel> failedOrders = shipperDeliveryDAO.findFailedAndReturnedOrders(
                shipperId, reason, status, startDate, endDate, keyword
        );

        Map<String, Object> stats = shipperDeliveryDAO.getFailedDeliveryStats(shipperId, startDate, endDate);
        List<ShipperModel> shippers = shipperDAO.findAll();

        request.setAttribute("orders", failedOrders);
        request.setAttribute("stats", stats);
        request.setAttribute("shippers", shippers);
        request.setAttribute("selectedShipperId", shipperId != null ? shipperId : 0L);
        request.setAttribute("selectedReason", reason != null ? reason : "ALL");
        request.setAttribute("selectedStatus", status != null ? status : "ALL");
        request.setAttribute("startDate", startDate != null ? startDate : "");
        request.setAttribute("endDate", endDate != null ? endDate : "");
        request.setAttribute("keyword", keyword != null ? keyword : "");

        request.getRequestDispatcher("/WEB-INF/views/admin/delivery-failures.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || "true".equalsIgnoreCase(request.getParameter("ajax"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");

        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            if (isAjax) {
                response.getWriter().write("{\"success\":false,\"message\":\"Thiếu mã đơn hàng!\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/delivery-failures?error=missing_id");
            }
            return;
        }

        try {
            long orderId = Long.parseLong(orderIdStr.trim());
            boolean success = false;
            String message = "Thao tác thành công!";

            if ("scheduleRetry".equalsIgnoreCase(action)) {
                String shipperIdStr = request.getParameter("shipperId");
                Long newShipperId = null;
                try {
                    if (shipperIdStr != null && !shipperIdStr.trim().isEmpty()) {
                        newShipperId = Long.parseLong(shipperIdStr.trim());
                    }
                } catch (Exception ignored) {}
                String deliveryTime = request.getParameter("deliveryTime");
                String notes = request.getParameter("notes");
                success = shipperDeliveryDAO.scheduleRetryDelivery(orderId, newShipperId, deliveryTime, notes);
                message = success ? "Lên lịch hẹn giao lại thành công!" : "Không thể lên lịch giao lại!";

            } else if ("returnToStock".equalsIgnoreCase(action)) {
                String notes = request.getParameter("notes");
                success = shipperDeliveryDAO.markReturnedToStock(orderId, notes);
                message = success ? "Chuyển hoàn kho và hoàn trả tồn kho hoa quả thành công!" : "Lỗi khi hoàn kho!";

            } else if ("markDelivered".equalsIgnoreCase(action)) {
                String notes = request.getParameter("notes");
                success = shipperDeliveryDAO.markDeliveredSuccessfully(orderId, notes);
                message = success ? "Xác nhận giao hàng thành công!" : "Lỗi khi cập nhật trạng thái!";

            } else if ("updateReason".equalsIgnoreCase(action)) {
                String reason = request.getParameter("reason");
                String notes = request.getParameter("notes");
                int attempts = 1;
                try {
                    String aStr = request.getParameter("attempts");
                    if (aStr != null) attempts = Integer.parseInt(aStr);
                } catch (Exception ignored) {}
                success = shipperDeliveryDAO.updateFailureReasonAndNotes(orderId, reason, notes, attempts);
                message = success ? "Cập nhật lý do và ghi chú shipper thành công!" : "Lỗi khi cập nhật!";
            }

            if (isAjax) {
                response.getWriter().write(String.format("{\"success\":%b,\"message\":\"%s\"}", success, message));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/delivery-failures?msg=" + (success ? "success" : "failed"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                response.getWriter().write(String.format("{\"success\":false,\"message\":\"Lỗi hệ thống: %s\"}", e.getMessage()));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/delivery-failures?error=server_error");
            }
        }
    }
}
