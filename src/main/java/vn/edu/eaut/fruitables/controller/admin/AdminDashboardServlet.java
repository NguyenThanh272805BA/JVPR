package vn.edu.eaut.fruitables.controller.admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Tạm thời truyền các chỉ số bằng 0 hoặc rỗng theo yêu cầu để render UI
        request.setAttribute("totalRevenue", 0);
        request.setAttribute("totalOrders", 0);
        request.setAttribute("totalProducts", 0);
        request.setAttribute("outOfStock", 0);

        // Chuyển hướng tới giao diện JSP
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}