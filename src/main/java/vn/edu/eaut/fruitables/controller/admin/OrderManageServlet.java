package vn.edu.eaut.fruitables.controller.admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/orders"})
public class OrderManageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Đáng lẽ dùng: List<OrderModel> orders = orderDAO.findAll();
        // Set attribute và đẩy ra JSP
        request.getRequestDispatcher("/WEB-INF/views/admin/order-list.jsp").forward(request, response);
    }
}