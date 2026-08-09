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

@WebServlet(urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private IUserService userService;

    public LoginServlet() {
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chuyển hướng tới trang JSP hiển thị form
        request.getRequestDispatcher("/WEB-INF/views/web/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserModel user = userService.login(email, password);

        if (user != null) {
            // Đăng nhập thành công, lưu thông tin vào Session
            HttpSession session = request.getSession();
            session.setAttribute("USERMODEL", user);

            // Chuyển hướng về trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            // Thất bại, trả về trang login kèm thông báo lỗi
            request.setAttribute("message", "Email hoặc mật khẩu không chính xác.");
            request.getRequestDispatcher("/WEB-INF/views/web/login.jsp").forward(request, response);
        }
    }
}