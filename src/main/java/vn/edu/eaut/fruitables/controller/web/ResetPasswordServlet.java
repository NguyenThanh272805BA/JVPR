package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.service.IUserService;
import vn.edu.eaut.fruitables.service.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    private IUserService userService;

    public ResetPasswordServlet() {
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("RESET_PWD_EMAIL");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/web/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String email = (String) session.getAttribute("RESET_PWD_EMAIL");
        String sessionOtp = (String) session.getAttribute("RESET_PWD_OTP");
        Long expiryTime = (Long) session.getAttribute("RESET_PWD_EXPIRY");

        if (email == null || sessionOtp == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String userOtp = request.getParameter("otpCode");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 1. Kiểm tra thời hạn OTP (5 phút)
        if (expiryTime != null && System.currentTimeMillis() > expiryTime) {
            request.setAttribute("message", "Mã OTP đã hết hiệu lực (quá 5 phút). Vui lòng yêu cầu mã mới!");
            request.getRequestDispatcher("/WEB-INF/views/web/reset-password.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra tính chính xác của OTP
        if (userOtp == null || !userOtp.trim().equals(sessionOtp.trim())) {
            request.setAttribute("message", "Mã OTP không chính xác. Vui lòng kiểm tra lại trong hòm thư!");
            request.getRequestDispatcher("/WEB-INF/views/web/reset-password.jsp").forward(request, response);
            return;
        }

        // 3. Kiểm tra mật khẩu mới
        if (newPassword == null || newPassword.trim().length() < 6) {
            request.setAttribute("message", "Mật khẩu mới phải có tối thiểu 6 ký tự!");
            request.getRequestDispatcher("/WEB-INF/views/web/reset-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "Mật khẩu xác nhận không trùng khớp!");
            request.getRequestDispatcher("/WEB-INF/views/web/reset-password.jsp").forward(request, response);
            return;
        }

        // 4. Cập nhật mật khẩu mới vào cơ sở dữ liệu
        boolean isSuccess = userService.resetPassword(email, newPassword.trim());

        if (isSuccess) {
            // Xóa session rác
            session.removeAttribute("RESET_PWD_EMAIL");
            session.removeAttribute("RESET_PWD_OTP");
            session.removeAttribute("RESET_PWD_EXPIRY");
            session.removeAttribute("otpSentMsg");

            session.setAttribute("successMsg", "Đặt lại mật khẩu thành công! Bạn có thể đăng nhập bằng mật khẩu mới.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("message", "Đã xảy ra lỗi khi cập nhật mật khẩu. Vui lòng thử lại sau!");
            request.getRequestDispatcher("/WEB-INF/views/web/reset-password.jsp").forward(request, response);
        }
    }
}
