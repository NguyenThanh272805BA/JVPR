package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.dao.ICouponDAO;
import vn.edu.eaut.fruitables.dao.INotificationDAO;
import vn.edu.eaut.fruitables.dao.impl.CouponDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.NotificationDAOImpl;
import vn.edu.eaut.fruitables.model.entity.CouponModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.impl.EmailServiceImpl;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Random;
import java.util.UUID;

@WebServlet(urlPatterns = {"/api/link-email"})
public class LinkEmailAPIServlet extends HttpServlet {

    private final EmailServiceImpl emailService;
    private final ICouponDAO couponDAO;
    private final INotificationDAO notificationDAO;
    private final Gson gson;

    public LinkEmailAPIServlet() {
        this.emailService = new EmailServiceImpl();
        this.couponDAO = new CouponDAOImpl();
        this.notificationDAO = new NotificationDAOImpl();
        this.gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession();
        UserModel currentUser = (UserModel) session.getAttribute("USERMODEL");

        if (currentUser == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Vui lòng đăng nhập để thực hiện tính năng này!");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "send_otp":
                handleSendOtp(request, session, currentUser, jsonResponse);
                break;
            case "verify_otp":
                handleVerifyOtp(request, session, currentUser, jsonResponse);
                break;
            default:
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Hành động không hợp lệ!");
                break;
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

    private void handleSendOtp(HttpServletRequest request, HttpSession session, UserModel currentUser, JsonObject jsonResponse) {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Vui lòng nhập địa chỉ Gmail!");
            return;
        }

        email = email.trim().toLowerCase();

        // 1. Kiểm tra định dạng Email
        if (!email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$")) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Địa chỉ Email không đúng định dạng hợp lệ!");
            return;
        }

        // 2. Kiểm tra tính duy nhất trong database
        String checkSql = "SELECT id FROM users WHERE email = ? AND id != ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
            psCheck.setString(1, email);
            psCheck.setLong(2, currentUser.getId());
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Địa chỉ Gmail này đã được sử dụng bởi một tài khoản khác!");
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi kiểm tra dữ liệu: " + e.getMessage());
            return;
        }

        // 3. Tạo mã OTP ngẫu nhiên 6 chữ số
        String otpCode = String.format("%06d", new Random().nextInt(999999));
        session.setAttribute("LINK_EMAIL_TARGET", email);
        session.setAttribute("LINK_EMAIL_OTP", otpCode);
        session.setAttribute("LINK_EMAIL_EXPIRY", System.currentTimeMillis() + (5 * 60 * 1000)); // 5 phút

        System.out.println("[FRUITABLES LINK GMAIL] User ID " + currentUser.getId() + " - Email: " + email + " - OTP: " + otpCode);

        // 4. Gửi OTP qua email
        boolean isSent = emailService.sendEmailLinkOTP(email, otpCode);
        if (isSent) {
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", "Mã xác minh OTP (6 chữ số) đã được gửi tới " + email + ". Vui lòng kiểm tra hộp thư!");
        } else {
            // Trường hợp môi trường phát triển ngoại tuyến/không kết nối SMTP
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", "Hệ thống đã tạo mã OTP xác minh. (Mã OTP thử nghiệm: " + otpCode + ")");
        }
    }

    private void handleVerifyOtp(HttpServletRequest request, HttpSession session, UserModel currentUser, JsonObject jsonResponse) {
        String userOtp = request.getParameter("otpCode");
        String sessionEmail = (String) session.getAttribute("LINK_EMAIL_TARGET");
        String sessionOtp = (String) session.getAttribute("LINK_EMAIL_OTP");
        Long expiry = (Long) session.getAttribute("LINK_EMAIL_EXPIRY");

        if (sessionEmail == null || sessionOtp == null || expiry == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Phiên xác minh đã hết hạn hoặc chưa yêu cầu gửi mã. Vui lòng bấm 'Gửi mã OTP'!");
            return;
        }

        if (System.currentTimeMillis() > expiry) {
            session.removeAttribute("LINK_EMAIL_OTP");
            session.removeAttribute("LINK_EMAIL_EXPIRY");
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Mã OTP đã hết hiệu lực (quá 5 phút). Vui lòng gửi lại mã mới!");
            return;
        }

        if (userOtp == null || !userOtp.trim().equals(sessionOtp.trim())) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Mã OTP không chính xác. Vui lòng kiểm tra lại!");
            return;
        }

        // OTP CHÍNH XÁC -> Cập nhật email vào database
        String updateSql = "UPDATE users SET email = ? WHERE id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(updateSql)) {
            ps.setString(1, sessionEmail);
            ps.setLong(2, currentUser.getId());

            if (ps.executeUpdate() > 0) {
                boolean isFirstTimeLinking = (currentUser.getEmail() == null || currentUser.getEmail().trim().isEmpty());

                // Cập nhật session user
                currentUser.setEmail(sessionEmail);
                session.setAttribute("USERMODEL", currentUser);

                // Dọn dẹp session OTP
                session.removeAttribute("LINK_EMAIL_TARGET");
                session.removeAttribute("LINK_EMAIL_OTP");
                session.removeAttribute("LINK_EMAIL_EXPIRY");

                String rewardVoucher = null;
                // Thưởng Voucher 50.000đ nếu liên kết lần đầu
                if (isFirstTimeLinking) {
                    try {
                        String voucherCode = "GMAIL50K-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
                        CouponModel giftCoupon = new CouponModel();
                        giftCoupon.setCode(voucherCode);
                        giftCoupon.setDiscountType("FIXED");
                        giftCoupon.setDiscountValue(50000.0);
                        giftCoupon.setMinOrderValue(150000.0);
                        giftCoupon.setStartDate(new Timestamp(System.currentTimeMillis()));
                        giftCoupon.setEndDate(new Timestamp(System.currentTimeMillis() + 30L * 24 * 3600 * 1000));
                        giftCoupon.setUsageLimit(1);
                        giftCoupon.setStatus(true);
                        giftCoupon.setTargetAudience("GMAIL");
                        couponDAO.save(giftCoupon);

                        notificationDAO.createNotification(
                                currentUser.getId(),
                                null,
                                voucherCode,
                                "Tặng bạn Voucher 50.000₫ liên kết Gmail",
                                "Chúc mừng bạn đã liên kết Gmail " + sessionEmail + " thành công! Fruitables tặng bạn Voucher 50.000₫ giảm trực tiếp cho đơn hàng từ 150K. Mã ưu đãi: " + voucherCode,
                                "PROMOTION"
                        );

                        rewardVoucher = voucherCode;
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }

                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Xác minh và liên kết Gmail thành công!");
                jsonResponse.addProperty("email", sessionEmail);
                if (rewardVoucher != null) {
                    jsonResponse.addProperty("rewardCoupon", rewardVoucher);
                }
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể cập nhật email. Vui lòng thử lại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
        }
    }
}
