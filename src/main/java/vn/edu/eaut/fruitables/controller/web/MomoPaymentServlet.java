package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.util.MomoConfigUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/momo-payment"})
public class MomoPaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        String orderCode = (String) session.getAttribute("PENDING_ORDER_CODE");
        Double totalAmount = (Double) session.getAttribute("PENDING_TOTAL_AMOUNT");

        // Nếu không có đơn hàng đang chờ trong session, chuyển hướng về trang giỏ hàng
        if (orderCode == null || totalAmount == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        long roundedAmount = Math.round(totalAmount);
        String qrImageUrl = MomoConfigUtil.generateQrImageUrl(orderCode, roundedAmount);
        String momoPayload = MomoConfigUtil.generateMomoPayload(orderCode, roundedAmount);

        request.setAttribute("orderCode", orderCode);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("roundedAmount", roundedAmount);
        request.setAttribute("phoneNumber", MomoConfigUtil.PHONE_NUMBER);
        request.setAttribute("accountName", MomoConfigUtil.ACCOUNT_NAME);
        request.setAttribute("qrImageUrl", qrImageUrl);
        request.setAttribute("momoPayload", momoPayload);

        request.getRequestDispatcher("/WEB-INF/views/web/momo-payment.jsp").forward(request, response);
    }
}
