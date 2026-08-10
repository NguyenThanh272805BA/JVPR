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
        // Lấy danh sách toàn bộ đơn hàng
        List<OrderModel> orders = orderService.findAll();

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/admin/order-list.jsp").forward(request, response);
    }
}