package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.service.IOrderService;
import vn.edu.eaut.fruitables.service.impl.OrderServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/orders"})
public class OrderManageServlet extends HttpServlet {

    private IOrderService orderService;

    public OrderManageServlet() {
        this.orderService = new OrderServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        List<OrderModel> orders = orderService.searchAndFilterOrders(keyword, status, startDate, endDate);
        vn.edu.eaut.fruitables.dao.IShipperDAO shipperDAO = new vn.edu.eaut.fruitables.dao.impl.ShipperDAOImpl();
        List<vn.edu.eaut.fruitables.model.entity.ShipperModel> shippers = shipperDAO.findAll();
        request.setAttribute("shippers", shippers);
        request.setAttribute("orders", orders);
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("selectedStatus", status != null ? status : "ALL");
        request.setAttribute("startDate", startDate != null ? startDate : "");
        request.setAttribute("endDate", endDate != null ? endDate : "");

        request.getRequestDispatcher("/WEB-INF/views/admin/order-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || "true".equalsIgnoreCase(request.getParameter("ajax"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));

        // Cập nhật trạng thái đơn hàng từ Admin/Shipper
        if ("updateStatus".equals(action)) {
            try {
                Long orderId = Long.parseLong(request.getParameter("orderId"));
                String newStatus = request.getParameter("status"); // CONFIRMED, PACKING, SHIPPING, DELIVERED, COMPLETED, FAILED

                if (newStatus != null && !newStatus.trim().isEmpty()) {
                    orderService.updateOrderStatus(orderId, newStatus);
                    if (isAjax) {
                        response.setContentType("application/json; charset=UTF-8");
                        response.getWriter().write("{\"success\":true,\"orderId\":" + orderId + ",\"status\":\"" + newStatus + "\"}");
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                if (isAjax) {
                    response.setContentType("application/json; charset=UTF-8");
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
                    return;
                }
            }
        }

        // Nếu submit form thông thường, chuyển hướng bảo toàn bộ lọc và vị trí đơn hàng
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("filterStatus");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String orderId = request.getParameter("orderId");

        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin/orders?");
        if (keyword != null && !keyword.trim().isEmpty()) redirectUrl.append("keyword=").append(java.net.URLEncoder.encode(keyword, "UTF-8")).append("&");
        if (status != null && !status.trim().isEmpty()) redirectUrl.append("status=").append(java.net.URLEncoder.encode(status, "UTF-8")).append("&");
        if (startDate != null && !startDate.trim().isEmpty()) redirectUrl.append("startDate=").append(startDate).append("&");
        if (endDate != null && !endDate.trim().isEmpty()) redirectUrl.append("endDate=").append(endDate).append("&");

        if (orderId != null) {
            redirectUrl.append("#order-row-").append(orderId);
        }

        response.sendRedirect(redirectUrl.toString());
    }
}