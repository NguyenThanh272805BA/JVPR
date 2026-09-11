package vn.edu.eaut.fruitables.filter;

import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Bảo vệ phân hệ Shipper Portal
@WebFilter(urlPatterns = {"/shipper/*"})
public class ShipperAuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        UserModel user = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;

        if (user != null) {
            // Cho phép: Role 4 (SHIPPER) hoặc Role 1 (SUPER_ADMIN điều phối/giám sát)
            if (user.getRoleId() == 4 || user.getRoleId() == 1) {
                chain.doFilter(request, response);
            } else {
                resp.sendRedirect(req.getContextPath() + "/home?message=AccessDenied");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/login?message=PleaseLoginShipper");
        }
    }

    @Override
    public void destroy() {}
}
