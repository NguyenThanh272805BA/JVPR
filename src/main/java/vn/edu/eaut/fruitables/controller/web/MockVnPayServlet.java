package vn.edu.eaut.fruitables.controller.web;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/mock-payment"})
public class MockVnPayServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Kiểm tra xem có đơn hàng nào đang chờ thanh toán không
        if (session.getAttribute("PENDING_ORDER_CODE") == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Chuyển hướng sang trang giao diện quét mã QR
        request.getRequestDispatcher("/WEB-INF/views/web/mock-vnpay.jsp").forward(request, response);
    }
}