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

        UserModel user = new UserModel();
        user.setUsername(username);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPasswordHash(password);

        // Nếu không nhập Email -> Lưu luôn và kích hoạt tài khoản
        if (email == null || email.trim().isEmpty()) {
            UserModel registeredUser = userService.register(user);
            if (registeredUser != null) {
                request.getSession().setAttribute("successMsg", "Đăng ký thành công! Vui lòng đăng nhập.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("message", "Tên đăng nhập hoặc số điện thoại đã tồn tại.");
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