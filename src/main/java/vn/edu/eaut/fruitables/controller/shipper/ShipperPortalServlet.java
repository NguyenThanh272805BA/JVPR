package vn.edu.eaut.fruitables.controller.shipper;

import com.google.gson.Gson;
import vn.edu.eaut.fruitables.dao.IShipperDAO;
import vn.edu.eaut.fruitables.dao.IShipperDeliveryDAO;
import vn.edu.eaut.fruitables.dao.impl.ShipperDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.ShipperDeliveryDAOImpl;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.ShipperModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/shipper/portal", "/shipper/my-orders"})
public class ShipperPortalServlet extends HttpServlet {

    private final IShipperDAO shipperDAO = new ShipperDAOImpl();
    private final IShipperDeliveryDAO shipperDeliveryDAO = new ShipperDeliveryDAOImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserModel user = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;

        Long shipperId = null;
        ShipperModel currentShipper = null;

        // 1. Xác định Shipper đang đăng nhập
        if (user != null) {
            currentShipper = shipperDAO.findByUserId(user.getId());
            if (currentShipper != null) {
                shipperId = currentShipper.getId();
            }
        }

        // Cho phép Super Admin hoặc demo chọn xem theo shipperId bất kỳ
        String sIdParam = request.getParameter("shipperId");
        if (sIdParam != null && !sIdParam.trim().isEmpty()) {
            try {
                Long customId = Long.parseLong(sIdParam);
                ShipperModel customShipper = shipperDAO.findById(customId);
                if (customShipper != null) {
                    currentShipper = customShipper;
                    shipperId = customShipper.getId();
                }
            } catch (Exception ignored) {}
        }

        // Fallback nếu chưa có shipper liên kết (ví dụ tài khoản admin mới test)
        if (currentShipper == null) {
            List<ShipperModel> allShippers = shipperDAO.findAll();
            if (!allShippers.isEmpty()) {
                currentShipper = allShippers.get(0);
                shipperId = currentShipper.getId();
            }
        }

        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "SHIPPING"; // Mặc định hiển thị đơn đang giao
        }
        String keyword = request.getParameter("keyword");

        // 2. Lấy danh sách đơn hàng được gán cho Shipper
        List<OrderModel> orders = shipperDeliveryDAO.findOrdersByShipper(shipperId, tab, keyword);

        // 3. Thống kê ca trực
        Map<String, Object> shiftSummary = shipperDeliveryDAO.getShipperShiftSummary(shipperId);

        // 4. Danh sách tất cả tài xế (dùng khi admin kiểm tra hoặc chuyển ca)
        List<ShipperModel> allShippers = shipperDAO.findAll();

        request.setAttribute("currentShipper", currentShipper);
        request.setAttribute("orders", orders);
        request.setAttribute("shiftSummary", shiftSummary);
        request.setAttribute("activeTab", tab);
        request.setAttribute("keyword", keyword);
        request.setAttribute("allShippers", allShippers);

        request.getRequestDispatcher("/WEB-INF/views/shipper/portal.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");
        Long orderId = (orderIdStr != null && !orderIdStr.isEmpty()) ? Long.parseLong(orderIdStr) : null;

        Map<String, Object> result = new HashMap<>();
        boolean success = false;
        String message = "";

        try {
            if ("deliver_success".equals(action)) {
                String notes = request.getParameter("notes");
                success = shipperDeliveryDAO.markDeliveredSuccessfully(orderId, notes);
                message = success ? "Xác nhận giao thành công đơn hàng #" + orderId : "Không thể cập nhật trạng thái đơn hàng!";

            } else if ("report_failure".equals(action)) {
                String reason = request.getParameter("reason");
                String notes = request.getParameter("notes");
                int attempts = 1;
                try {
                    String attStr = request.getParameter("attempts");
                    if (attStr != null) attempts = Integer.parseInt(attStr);
                } catch (Exception ignored) {}

                success = shipperDeliveryDAO.updateFailureReasonAndNotes(orderId, reason, notes, attempts);
                message = success ? "Đã ghi nhận giao thất bại cho đơn #" + orderId : "Lỗi khi cập nhật lý do thất bại!";

            } else if ("reschedule".equals(action)) {
                String deliveryTime = request.getParameter("deliveryTime");
                String notes = request.getParameter("notes");
                String sIdStr = request.getParameter("shipperId");
                Long shipperId = (sIdStr != null && !sIdStr.isEmpty()) ? Long.parseLong(sIdStr) : null;

                success = shipperDeliveryDAO.scheduleRetryDelivery(orderId, shipperId, deliveryTime, notes);
                message = success ? "Đã lên lịch hẹn giao lại cho đơn #" + orderId : "Không thể hẹn lịch giao lại!";

            } else if ("return_stock".equals(action)) {
                String notes = request.getParameter("notes");
                success = shipperDeliveryDAO.markReturnedToStock(orderId, notes);
                message = success ? "Đã hoàn hàng về kho thành công cho đơn #" + orderId : "Không thể hoàn đơn về kho!";

            } else if ("toggle_status".equals(action)) {
                String sIdStr = request.getParameter("shipperId");
                String status = request.getParameter("status");
                if (sIdStr != null && status != null) {
                    shipperDAO.updateStatus(Long.parseLong(sIdStr), status);
                    success = true;
                    message = "Đã cập nhật trạng thái làm việc thành " + status;
                }
            } else {
                message = "Hành động không hợp lệ!";
            }
        } catch (Exception e) {
            e.printStackTrace();
            success = false;
            message = "Lỗi xử lý hệ thống: " + e.getMessage();
        }

        result.put("success", success);
        result.put("message", message);

        String isAjax = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(isAjax) || "true".equalsIgnoreCase(request.getParameter("ajax"))) {
            response.getWriter().write(gson.toJson(result));
        } else {
            String tab = request.getParameter("currentTab");
            if (tab == null || tab.isEmpty()) tab = "SHIPPING";
            response.sendRedirect(request.getContextPath() + "/shipper/portal?tab=" + tab + "&msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
        }
    }
}
