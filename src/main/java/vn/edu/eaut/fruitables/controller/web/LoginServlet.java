package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.IUserService;
import vn.edu.eaut.fruitables.service.impl.UserServiceImpl;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

@WebServlet(urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private IUserService userService;

    public LoginServlet() {
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/web/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy identifier (có thể là username, phone, hoặc email) - Cần đảm bảo JSP cũng dùng name="identifier" ở Giai đoạn 3
        String identifier = request.getParameter("identifier");

        // Backup: Nếu chưa sửa kịp bên JSP thì lấy tạm bằng name "email"
        if (identifier == null || identifier.trim().isEmpty()) {
            identifier = request.getParameter("email");
        }

        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        UserModel user = userService.login(identifier, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("USERMODEL", user);

            if ("on".equals(remember)) {
                Cookie cookieUser = new Cookie("rememberIdentifier", identifier);
                cookieUser.setMaxAge(60 * 60 * 24 * 7);
                response.addCookie(cookieUser);
            }

            @SuppressWarnings("unchecked")
            Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");
            if (cart != null && !cart.isEmpty()) {
                syncCartToDB(user.getId(), cart);
            }

            if (user.getRoleId() == 4) {
                // Shipper -> Vào trực tiếp Cổng Tài Xế
                response.sendRedirect(request.getContextPath() + "/shipper/portal");
            } else if (user.getRoleId() == 1 || user.getRoleId() == 2) {
                // Admin / Sale -> Vào Dashboard Quản trị
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                // Khách hàng -> Về trang chủ
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("message", "Tài khoản hoặc mật khẩu không chính xác.");
            request.getRequestDispatcher("/WEB-INF/views/web/login.jsp").forward(request, response);
        }
    }

    private void syncCartToDB(Long userId, Map<Long, CartItemDTO> sessionCart) {
        String sqlCheck = "SELECT quantity FROM cart_items WHERE user_id = ? AND product_id = ?";
        String sqlUpdate = "UPDATE cart_items SET quantity = quantity + ? WHERE user_id = ? AND product_id = ?";
        String sqlInsert = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";
        try (Connection conn = DBConnectionUtil.getConnection()) {
            for (CartItemDTO item : sessionCart.values()) {
                try (PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
                    psCheck.setLong(1, userId);
                    psCheck.setLong(2, item.getProductId());
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next()) {
                            try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate)) {
                                psUpdate.setInt(1, item.getQuantity());
                                psUpdate.setLong(2, userId);
                                psUpdate.setLong(3, item.getProductId());
                                psUpdate.executeUpdate();
                            }
                        } else {
                            try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert)) {
                                psInsert.setLong(1, userId);
                                psInsert.setLong(2, item.getProductId());
                                psInsert.setInt(3, item.getQuantity());
                                psInsert.executeUpdate();
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}