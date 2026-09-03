package vn.edu.eaut.fruitables.controller.web;

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

@WebServlet(urlPatterns = {"/guest-tracking"})
public class GuestOrderTrackingServlet extends HttpServlet {

    private IOrderService orderService;

    public GuestOrderTrackingServlet() {
        this.orderService = new OrderServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/web/guest-order-tracking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String phone = request.getParameter("phone");
        String orderCode = request.getParameter("orderCode");

        // Gọi DB tìm kiếm
        List<OrderModel> foundOrders = orderService.findByPhoneOrOrderCode(phone, orderCode);

        request.setAttribute("foundOrders", foundOrders);
        request.setAttribute("searched", true);

        request.getRequestDispatcher("/WEB-INF/views/web/guest-order-tracking.jsp").forward(request, response);
    }
}