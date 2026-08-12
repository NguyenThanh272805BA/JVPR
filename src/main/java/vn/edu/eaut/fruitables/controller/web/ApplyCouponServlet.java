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
import java.sql.ResultSet;

@WebServlet(urlPatterns = {"/apply-coupon"})
public class ApplyCouponServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String couponCode = request.getParameter("couponCode");
        HttpSession session = request.getSession();

        if (couponCode == null || couponCode.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Truy vấn dữ liệu coupon từ CSDL
        String sql = "SELECT * FROM coupons WHERE code = ? AND status = 1 AND start_date <= NOW() AND end_date >= NOW() AND used_count < usage_limit";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, couponCode.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String discountType = rs.getString("discount_type");
                    double discountValue = rs.getDouble("discount_value");
                    double minOrderValue = rs.getDouble("min_order_value");

                    // Tính tổng tiền giỏ hàng từ Session
                    @SuppressWarnings("unchecked")
                    java.util.Map<Long, vn.edu.eaut.fruitables.model.dto.CartItemDTO> cart =
                            (java.util.Map<Long, vn.edu.eaut.fruitables.model.dto.CartItemDTO>) session.getAttribute("CART");

                    double cartTotal = 0;
                    if (cart != null) {
                        for (vn.edu.eaut.fruitables.model.dto.CartItemDTO item : cart.values()) {
                            cartTotal += item.getSubTotal();
                        }
                    }

                    if (cartTotal >= minOrderValue) {
                        double discountAmount = 0;
                        if ("PERCENT".equals(discountType)) {
                            discountAmount = (cartTotal * discountValue) / 100;
                        } else if ("FIXED".equals(discountType)) {
                            discountAmount = discountValue;
                        }

                        // Lưu giá trị giảm tiền vào Session
                        session.setAttribute("DISCOUNT_AMOUNT", discountAmount);
                        session.setAttribute("APPLIED_COUPON_CODE", couponCode.trim());
                        session.setAttribute("COUPON_MESSAGE", "Áp dụng mã giảm giá thành công!");
                    } else {
                        session.setAttribute("COUPON_ERROR", "Đơn hàng chưa đạt giá trị tối thiểu " + minOrderValue + " VNĐ!");
                    }
                } else {
                    session.setAttribute("COUPON_ERROR", "Mã giảm giá không hợp lệ hoặc đã hết hạn!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}