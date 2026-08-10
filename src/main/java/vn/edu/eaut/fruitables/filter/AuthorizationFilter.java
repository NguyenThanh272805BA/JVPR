package vn.edu.eaut.fruitables.filter;

import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Đã gỡ bỏ "/checkout" để cho phép Khách vãng lai mua hàng
// Filter này tạm thời có thể dùng để bảo vệ trang cá nhân của user sau này
@WebFilter(urlPatterns = {"/user/profile"})
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        UserModel user = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;

        if (user != null) {
            // Đã đăng nhập -> cho phép đi tiếp
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập thì đá về trang login
            resp.sendRedirect(req.getContextPath() + "/login?message=Please login first");
        }
    }

    @Override
    public void destroy() {}
}