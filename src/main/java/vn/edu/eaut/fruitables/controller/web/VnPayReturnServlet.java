package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet(urlPatterns = {"/vnpay-return"})
public class VnPayReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String responseCode = request.getParameter("vnp_ResponseCode");
        String orderCode = request.getParameter("vnp_TxnRef");
        HttpSession session = request.getSession();

        if (orderCode != null && !orderCode.isEmpty()) {
            if ("00".equals(responseCode)) {
                // Thanh toán thành công -> Cập nhật payment_status = 'PAID'
                updatePaymentStatus(orderCode, "PAID");

                // Xóa giỏ hàng vì đã thanh toán thành công
                session.removeAttribute("CART");
                session.removeAttribute("CART_TOTAL_ITEMS");

                session.setAttribute("orderSuccess", "Thanh toán thành công! Mã đơn: " + orderCode + " đã được ghi nhận.");
            } else {
                // Thanh toán thất bại hoặc hủy
                updatePaymentStatus(orderCode, "UNPAID");
                session.setAttribute("orderSuccess", "Thanh toán bị hủy hoặc thất bại đối với đơn: " + orderCode);
            }
        }

        // Dọn dẹp session rác
        session.removeAttribute("PENDING_ORDER_CODE");
        session.removeAttribute("PENDING_TOTAL_AMOUNT");
        session.removeAttribute("PENDING_METHOD");

        // Quay về trang chủ hiển thị thông báo
        response.sendRedirect(request.getContextPath() + "/home");
    }

    // Hàm private cập nhật nhanh trạng thái vào DB (Thay vì phải sửa qua nhiều file DAO)
    private void updatePaymentStatus(String orderCode, String paymentStatus) {
        String sql = "UPDATE orders SET payment_status = ? WHERE order_code = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setString(2, orderCode);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}