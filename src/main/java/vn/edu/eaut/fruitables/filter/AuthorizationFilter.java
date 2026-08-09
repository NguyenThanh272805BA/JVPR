package vn.edu.eaut.fruitables.filter;

import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Bắt mọi request bắt đầu bằng /admin hoặc /checkout
@WebFilter(urlPatterns = {"/admin/*", "/checkout"})
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String url = req.getRequestURI();
        UserModel user = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;

        if (user != null) {
            // Đã đăng nhập
            if (url.startsWith(req.getContextPath() + "/admin")) {
                // Kiểm tra xem có phải là Admin/Sale không (Ví dụ role_id = 1 (Admin) hoặc 2 (Sale))
                if (user.getRoleId() == 1 || user.getRoleId() == 2) {
                    chain.doFilter(request, response); // Cho phép đi tiếp
                } else {
                    resp.sendRedirect(req.getContextPath() + "/login?message=Forbidden"); // Không có quyền
                }
            } else {
                // Vào các trang bình thường yêu cầu đăng nhập (như /checkout)
                chain.doFilter(request, response);
            }
        } else {
            // Chưa đăng nhập thì đá về trang login
            resp.sendRedirect(req.getContextPath() + "/login?message=Please login first");
        }
    }

    @Override
    public void destroy() {}
}