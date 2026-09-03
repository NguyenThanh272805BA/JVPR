package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/order-history"})
public class OrderHistoryServlet extends HttpServlet {

    private OrderDAOImpl orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 1. Lấy danh sách các đơn hàng của user
        List<OrderModel> orders = orderDAO.findByUserId(user.getId());

        // 2. Duyệt qua từng đơn hàng, lấy chi tiết các món hàng nhét vào trong OrderModel
        for (OrderModel order : orders) {
            order.setDetails(orderDAO.findOrderDetailsByOrderId(order.getId()));
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/web/order-history.jsp").forward(request, response);
    }
}