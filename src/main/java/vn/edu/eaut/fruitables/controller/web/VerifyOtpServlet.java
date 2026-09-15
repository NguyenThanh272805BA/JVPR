package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.IUserService;
import vn.edu.eaut.fruitables.service.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/verify-otp"})
public class VerifyOtpServlet extends HttpServlet {

    private IUserService userService;

    public VerifyOtpServlet() {
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/web/verify-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userOtp = request.getParameter("otpCode");
        HttpSession session = request.getSession();

        String sessionOtp = (String) session.getAttribute("REGISTER_OTP");
        Long otpTime = (Long) session.getAttribute("REGISTER_OTP_TIME");
        UserModel pendingUser = (UserModel) session.getAttribute("PENDING_USER");

        long currentTime = System.currentTimeMillis();

        // KIỂM TRA THỜI HẠN OTP: 5 phút = 300,000 ms
        if (otpTime == null || (currentTime - otpTime) > 5 * 60 * 1000L) {
            session.removeAttribute("REGISTER_OTP");
            session.removeAttribute("REGISTER_OTP_TIME");
            session.removeAttribute("PENDING_USER");
            request.setAttribute("message", "Mã OTP đã hết hạn (chỉ có hiệu lực trong 5 phút). Vui lòng đăng ký lại!");
            request.getRequestDispatcher("/WEB-INF/views/web/verify-otp.jsp").forward(request, response);
            return;
        }

        boolean otpMatches = (sessionOtp != null && userOtp != null && sessionOtp.trim().equalsIgnoreCase(userOtp.trim()));

        if (otpMatches && pendingUser != null) {
            // Khớp mã OTP -> Lưu User vào Database
            UserModel newUser = userService.register(pendingUser);

            if (newUser != null) {
                // Xóa rác trong session
                session.removeAttribute("REGISTER_OTP");
                session.removeAttribute("REGISTER_OTP_TIME");
                session.removeAttribute("PENDING_USER");

                session.setAttribute("successMsg", "Xác thực email thành công! Chào mừng bạn gia nhập.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("message", "Lỗi khi lưu tài khoản vào cơ sở dữ liệu.");
                request.getRequestDispatcher("/WEB-INF/views/web/verify-otp.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("message", "Mã OTP không chính xác!");
            request.getRequestDispatcher("/WEB-INF/views/web/verify-otp.jsp").forward(request, response);
        }
    }
}