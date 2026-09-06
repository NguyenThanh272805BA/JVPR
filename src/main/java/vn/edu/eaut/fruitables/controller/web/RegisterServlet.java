package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.IUserService;
import vn.edu.eaut.fruitables.service.impl.UserServiceImpl;
import vn.edu.eaut.fruitables.service.impl.EmailServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Random;

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
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("message", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/WEB-INF/views/web/register.jsp").forward(request, response);
            return;
        }

        // 1. Kiểm tra trùng tên đăng nhập (Username)
        if (username != null && userService.isUsernameTaken(username.trim())) {
            request.setAttribute("message", "Tên đăng nhập đã tồn tại. Vui lòng chọn tên đăng nhập khác!");
            request.getRequestDispatcher("/WEB-INF/views/web/register.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra giới hạn số điện thoại (Tối đa 3 tài khoản / 1 SĐT để chống spam voucher)
        if (phone != null && !phone.trim().isEmpty()) {
            int phoneAccountCount = userService.countAccountsByPhone(phone.trim());
            if (phoneAccountCount >= 3) {
                request.setAttribute("message", "Số điện thoại này đã liên kết với tối đa 3 tài khoản. Không thể đăng ký thêm nhằm bảo đảm chính sách ưu đãi!");
                request.getRequestDispatcher("/WEB-INF/views/web/register.jsp").forward(request, response);
                return;
            }
        }

        // 3. Kiểm tra trùng Email (nếu người dùng có nhập Email)
        if (email != null && !email.trim().isEmpty()) {
            if (userService.isEmailTaken(email.trim())) {
                request.setAttribute("message", "Email này đã được sử dụng cho một tài khoản khác. Vui lòng sử dụng email khác!");
                request.getRequestDispatcher("/WEB-INF/views/web/register.jsp").forward(request, response);
                return;
            }
        }

        UserModel user = new UserModel();
        user.setUsername(username != null ? username.trim() : null);
        user.setFullName(fullName != null ? fullName.trim() : "");
        user.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
        user.setPhone(phone != null ? phone.trim() : null);
        user.setPasswordHash(password);

        // Nếu không nhập Email -> Lưu luôn và kích hoạt tài khoản
        if (email == null || email.trim().isEmpty()) {
            UserModel registeredUser = userService.register(user);
            if (registeredUser != null) {
                request.getSession().setAttribute("successMsg", "Đăng ký thành công! Vui lòng đăng nhập.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("message", "Đã xảy ra lỗi khi tạo tài khoản. Vui lòng thử lại!");
                request.getRequestDispatcher("/WEB-INF/views/web/register.jsp").forward(request, response);
            }
            return;
        }

        // Nhập email -> Gửi OTP xác thực
        String otpCode = String.format("%06d", new Random().nextInt(999999));
        request.getSession().setAttribute("REGISTER_OTP", otpCode);
        request.getSession().setAttribute("PENDING_USER", user);

        EmailServiceImpl emailService = new EmailServiceImpl();
        boolean isSent = emailService.sendOTP(email, otpCode);

        if (isSent) {
            response.sendRedirect(request.getContextPath() + "/verify-otp");
        } else {
            request.setAttribute("message", "Hệ thống không thể gửi email xác thực. Vui lòng thử lại!");
            request.getRequestDispatcher("/WEB-INF/views/web/register.jsp").forward(request, response);
        }
    }
}