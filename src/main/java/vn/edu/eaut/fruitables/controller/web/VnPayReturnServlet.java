package vn.edu.eaut.fruitables.controller.web;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/vnpay-return"})
public class VnPayReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // VNPAY trả về các tham số như vnp_ResponseCode, vnp_TxnRef (mã đơn hàng)
        String responseCode = request.getParameter("vnp_ResponseCode");
        String orderCode = request.getParameter("vnp_TxnRef");

        if ("00".equals(responseCode)) {
            // Thanh toán thành công -> Cập nhật DB: order.setPaymentStatus("PAID")
            request.getSession().setAttribute("orderSuccess", "Thanh toán VNPAY thành công! Đơn hàng: " + orderCode);
        } else {
            // Thanh toán thất bại -> Cập nhật DB: order.setPaymentStatus("FAILED")
            request.getSession().setAttribute("orderSuccess", "Thanh toán bị hủy hoặc thất bại.");
        }

        response.sendRedirect(request.getContextPath() + "/home");
    }
}