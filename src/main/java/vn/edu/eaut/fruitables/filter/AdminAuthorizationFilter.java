package vn.edu.eaut.fruitables.filter;

import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Chỉ bắt các request có chứa /admin/
@WebFilter(urlPatterns = {"/admin/*"})
public class AdminAuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        UserModel user = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;

        if (user != null) {
            // Kiểm tra: Chỉ Role 1 (Super Admin) hoặc 2 (Sale) mới được vào
            if (user.getRoleId() == 1 || user.getRoleId() == 2) {
                chain.doFilter(request, response); // Hợp lệ, cho qua
            } else {
                // Có đăng nhập nhưng là khách thường -> Đá về trang chủ
                resp.sendRedirect(req.getContextPath() + "/home?message=AccessDenied");
            }
        } else {
            // Chưa đăng nhập -> Đá về trang Login
            resp.sendRedirect(req.getContextPath() + "/login?message=PleaseLoginAdmin");
        }
    }

    @Override
    public void destroy() {}
}