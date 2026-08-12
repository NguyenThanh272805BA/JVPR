package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.IUserService;
import vn.edu.eaut.fruitables.service.impl.UserServiceImpl;
import vn.edu.eaut.fruitables.service.impl.EmailServiceImpl; // Import thêm EmailService

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Random; // Import Random cho tính năng sinh OTP

@WebServlet(urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private IUserService userService;

    public RegisterServlet() {
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/web/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Xử lý tiếng Việt
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Validate cơ bản
        if (!password.equals(confirmPassword)) {
            request.setAttribute("message", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/WEB-INF/views/web/register.jsp").forward(request, response);
            return;
        }

        // Tạo mã OTP 6 số ngẫu nhiên
        String otpCode = String.format("%06d", new Random().nextInt(999999));

        // Đóng gói thông tin user vào Model (chưa gọi DAO để lưu vội vào Database)
        UserModel user = new UserModel();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(password); // Mật khẩu sẽ được mã hóa khi verify thành công ở bước sau

        // Lưu tạm thông tin đăng ký và mã OTP vào Session để chờ xác thực
        request.getSession().setAttribute("REGISTER_OTP", otpCode);
        request.getSession().setAttribute("PENDING_USER", user);

        // Khởi tạo và gọi Email Service để gửi OTP
        EmailServiceImpl emailService = new EmailServiceImpl();
        boolean isSent = emailService.sendOTP(email, otpCode);

        if (isSent) {
            // Nếu gửi email thành công, chuyển hướng người dùng sang trang nhập mã OTP
            response.sendRedirect(request.getContextPath() + "/verify-otp");
        } else {
            // Nếu gửi thất bại, báo lỗi tại trang đăng ký
            request.setAttribute("message", "Hệ thống không thể gửi email xác thực. Vui lòng thử lại!");
            request.getRequestDispatcher("/WEB-INF/views/web/register.jsp").forward(request, response);
        }
    }
}