package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.IUserService;
import vn.edu.eaut.fruitables.service.impl.EmailServiceImpl;
import vn.edu.eaut.fruitables.service.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

@WebServlet(urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private IUserService userService;
    private EmailServiceImpl emailService;

    public ForgotPasswordServlet() {
        this.userService = new UserServiceImpl();
        this.emailService = new EmailServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/web/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng nhập địa chỉ email đã đăng ký!");
            request.getRequestDispatcher("/WEB-INF/views/web/forgot-password.jsp").forward(request, response);
            return;
        }

        email = email.trim();

        // Kiểm tra xem email có tồn tại trong hệ thống không
        UserModel user = userService.findByEmail(email);
        if (user == null) {
            request.setAttribute("message", "Không tìm thấy tài khoản nào liên kết với email này!");
            request.getRequestDispatcher("/WEB-INF/views/web/forgot-password.jsp").forward(request, response);
            return;
        }

        // Tạo mã OTP 6 số ngẫu nhiên
        String otpCode = String.format("%06d", new Random().nextInt(999999));
        HttpSession session = request.getSession();
        session.setAttribute("RESET_PWD_EMAIL", email);
        session.setAttribute("RESET_PWD_OTP", otpCode);
        session.setAttribute("RESET_PWD_EXPIRY", System.currentTimeMillis() + (5 * 60 * 1000)); // Hết hạn sau 5 phút

        boolean isSent = emailService.sendPasswordResetOTP(email, otpCode);
        if (isSent) {
            session.setAttribute("otpSentMsg", "Mã OTP đã được gửi đến email " + email + ". Vui lòng kiểm tra hộp thư!");
            response.sendRedirect(request.getContextPath() + "/reset-password");
        } else {
            request.setAttribute("message", "Không thể gửi email OTP do lỗi máy chủ email. Vui lòng thử lại sau!");
            request.getRequestDispatcher("/WEB-INF/views/web/forgot-password.jsp").forward(request, response);
        }
    }
}
