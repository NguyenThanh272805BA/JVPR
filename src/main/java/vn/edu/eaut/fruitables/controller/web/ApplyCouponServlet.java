package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.entity.UserModel;
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
import java.util.Map;

@WebServlet(urlPatterns = {"/apply-coupon"})
public class ApplyCouponServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String couponCode = request.getParameter("couponCode");
        HttpSession session = request.getSession();

        // 1. Kiểm tra đăng nhập
        UserModel user = (UserModel) session.getAttribute("USERMODEL");
        if (user == null) {
            session.setAttribute("COUPON_ERROR", "Bạn phải đăng nhập để sử dụng mã giảm giá!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        if (couponCode == null || couponCode.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String sql = "SELECT c.*, p.name AS product_name FROM coupons c LEFT JOIN products p ON c.product_id = p.id WHERE c.code = ?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, couponCode.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String codeUpper = couponCode.trim().toUpperCase();
                    boolean status = rs.getBoolean("status");
                    java.sql.Timestamp startDate = rs.getTimestamp("start_date");
                    java.sql.Timestamp endDate = rs.getTimestamp("end_date");
                    int usageLimit = rs.getInt("usage_limit");
                    int usedCount = rs.getInt("used_count");
                    Long specificProductId = rs.getObject("product_id") != null ? rs.getLong("product_id") : null;
                    String specificProductName = rs.getString("product_name");
                    java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");

                    // 2. Kiểm tra trạng thái kích hoạt của Voucher
                    if (!status) {
                        session.setAttribute("COUPON_ERROR", "Mã giảm giá " + codeUpper + " hiện đang tạm ngưng áp dụng!");
                        session.removeAttribute("DISCOUNT_AMOUNT");
                        session.removeAttribute("APPLIED_COUPON_CODE");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }

                    // 3. Kiểm tra ngày bắt đầu hiệu lực
                    if (startDate != null && now.before(startDate)) {
                        session.setAttribute("COUPON_ERROR", "Mã giảm giá " + codeUpper + " chưa đến thời gian áp dụng (Bắt đầu từ " + sdf.format(startDate) + ")!");
                        session.removeAttribute("DISCOUNT_AMOUNT");
                        session.removeAttribute("APPLIED_COUPON_CODE");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }

                    // 4. KIỂM TRA HẾT HẠN SỬ DỤNG (HSD)
                    if (endDate != null && now.after(endDate)) {
                        session.setAttribute("COUPON_ERROR", "Mã giảm giá " + codeUpper + " không còn hiệu lực do đã hết hạn sử dụng vào ngày " + sdf.format(endDate) + "!");
                        session.removeAttribute("DISCOUNT_AMOUNT");
                        session.removeAttribute("APPLIED_COUPON_CODE");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }

                    // 5. Kiểm tra giới hạn số lượt sử dụng
                    if (usageLimit > 0 && usedCount >= usageLimit) {
                        session.setAttribute("COUPON_ERROR", "Mã giảm giá " + codeUpper + " đã hết số lượt sử dụng (" + usedCount + "/" + usageLimit + " lượt)!");
                        session.removeAttribute("DISCOUNT_AMOUNT");
                        session.removeAttribute("APPLIED_COUPON_CODE");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }

                    // 6. Kiểm tra đối tượng áp dụng Voucher
                    String targetAudience = rs.getString("target_audience");
                    String userLoginType = user.getLoginType() != null ? user.getLoginType() : "LOCAL";
                    String userEmail = user.getEmail() != null ? user.getEmail().toLowerCase() : "";

                    if ("GMAIL".equalsIgnoreCase(targetAudience) || "GOOGLE_ONLY".equalsIgnoreCase(targetAudience)) {
                        boolean isGoogleUser = "GOOGLE".equalsIgnoreCase(userLoginType) || userEmail.endsWith("@gmail.com");
                        if (!isGoogleUser) {
                            session.setAttribute("COUPON_ERROR", "Mã này chỉ dành riêng cho tài khoản Google / Gmail!");
                            session.removeAttribute("DISCOUNT_AMOUNT");
                            session.removeAttribute("APPLIED_COUPON_CODE");
                            response.sendRedirect(request.getContextPath() + "/cart");
                            return;
                        }
                    }

                    // Lấy giỏ hàng từ Session
                    @SuppressWarnings("unchecked")
                    Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");
                    if (cart == null || cart.isEmpty()) {
                        session.setAttribute("COUPON_ERROR", "Giỏ hàng của bạn đang trống!");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }

                    // 7. KIỂM TRA ĐIỀU KIỆN SẢN PHẨM RIÊNG BIỆT (NẾU CÓ)
                    if (specificProductId != null) {
                        if (!cart.containsKey(specificProductId)) {
                            String targetName = specificProductName != null ? specificProductName : "sản phẩm chỉ định";
                            session.setAttribute("COUPON_ERROR", "Mã giảm giá " + codeUpper + " chỉ áp dụng riêng cho sản phẩm '" + targetName + "'. Giỏ hàng của bạn chưa có sản phẩm này!");
                            session.removeAttribute("DISCOUNT_AMOUNT");
                            session.removeAttribute("APPLIED_COUPON_CODE");
                            response.sendRedirect(request.getContextPath() + "/cart");
                            return;
                        }
                    }

                    String discountType = rs.getString("discount_type");
                    double discountValue = rs.getDouble("discount_value");
                    double minOrderValue = rs.getDouble("min_order_value");

                    // Tính tổng tiền giỏ hàng hiện tại
                    double cartTotal = 0;
                    for (CartItemDTO item : cart.values()) {
                        cartTotal += item.getSubTotal();
                    }

                    // 8. Kiểm tra điều kiện đơn hàng tối thiểu
                    if (cartTotal >= minOrderValue) {
                        double discountAmount = 0;

                        if (specificProductId != null) {
                            // Áp dụng chiết khấu riêng cho sản phẩm đó
                            CartItemDTO targetItem = cart.get(specificProductId);
                            double itemTotal = targetItem.getSubTotal();
                            if ("PERCENT".equalsIgnoreCase(discountType)) {
                                discountAmount = (itemTotal * discountValue) / 100.0;
                            } else {
                                discountAmount = Math.min(discountValue, itemTotal);
                            }
                        } else {
                            // Áp dụng chiết khấu toàn đơn
                            if ("PERCENT".equalsIgnoreCase(discountType)) {
                                discountAmount = (cartTotal * discountValue) / 100.0;
                            } else {
                                discountAmount = discountValue;
                            }
                        }

                        // Đảm bảo mức giảm không vượt quá tổng tiền hàng
                        if (discountAmount > cartTotal) {
                            discountAmount = cartTotal;
                        }

                        session.setAttribute("DISCOUNT_AMOUNT", discountAmount);
                        session.setAttribute("APPLIED_COUPON_CODE", codeUpper);
                        session.setAttribute("COUPON_MESSAGE", "Áp dụng mã giảm giá " + codeUpper + " thành công!");
                        session.removeAttribute("COUPON_ERROR");
                    } else {
                        session.setAttribute("COUPON_ERROR", "Đơn hàng phải đạt tối thiểu " + String.format("%,.0f", minOrderValue) + " ₫ để dùng mã này (Hiện tại: " + String.format("%,.0f", cartTotal) + " ₫)!");
                        session.removeAttribute("DISCOUNT_AMOUNT");
                        session.removeAttribute("APPLIED_COUPON_CODE");
                    }
                } else {
                    session.setAttribute("COUPON_ERROR", "Mã giảm giá '" + couponCode.trim().toUpperCase() + "' không tồn tại trong hệ thống. Vui lòng kiểm tra lại!");
                    session.removeAttribute("DISCOUNT_AMOUNT");
                    session.removeAttribute("APPLIED_COUPON_CODE");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("COUPON_ERROR", "Lỗi hệ thống khi xử lý voucher!");
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}