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
        List<OrderModel> orders = orderService.findAll();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/admin/order-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Cập nhật trạng thái đơn hàng từ Admin/Shipper
        if ("updateStatus".equals(action)) {
            try {
                Long orderId = Long.parseLong(request.getParameter("orderId"));
                String newStatus = request.getParameter("status"); // DELIVERED, RETURNED, FAILED

                if (newStatus != null && !newStatus.trim().isEmpty()) {
                    orderService.updateOrderStatus(orderId, newStatus);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        // Sau khi xử lý xong, tải lại trang danh sách
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}