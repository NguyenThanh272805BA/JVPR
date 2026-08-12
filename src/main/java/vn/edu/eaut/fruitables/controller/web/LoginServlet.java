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
        // Chuyển hướng tới trang JSP hiển thị form
        request.getRequestDispatcher("/WEB-INF/views/web/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember"); // Lấy giá trị checkbox Remember Me

        UserModel user = userService.login(email, password);

        if (user != null) {
            // Đăng nhập thành công, lưu thông tin vào Session
            HttpSession session = request.getSession();
            session.setAttribute("USERMODEL", user);

            // 1. Xử lý Remember Me bằng Cookie (Lưu 7 ngày)
            if ("on".equals(remember)) {
                // Thực tế nên lưu Token mã hóa, ở đây lưu email phục vụ demo
                Cookie cookieEmail = new Cookie("rememberEmail", email);
                cookieEmail.setMaxAge(60 * 60 * 24 * 7); // Thời hạn 7 ngày
                response.addCookie(cookieEmail);
            }

            // 2. Đồng bộ giỏ hàng Session vào Database (Cho khách vãng lai)
            @SuppressWarnings("unchecked")
            Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");

            if (cart != null && !cart.isEmpty()) {
                syncCartToDB(user.getId(), cart);
            }

            // Chuyển hướng về trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            // Thất bại, trả về trang login kèm thông báo lỗi
            request.setAttribute("message", "Email hoặc mật khẩu không chính xác.");
            request.getRequestDispatcher("/WEB-INF/views/web/login.jsp").forward(request, response);
        }
    }

    // Hàm phụ trợ đẩy dữ liệu giỏ hàng vào bảng cart_items
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
                            // Đã có -> Cập nhật cộng dồn số lượng
                            try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate)) {
                                psUpdate.setInt(1, item.getQuantity());
                                psUpdate.setLong(2, userId);
                                psUpdate.setLong(3, item.getProductId());
                                psUpdate.executeUpdate();
                            }
                        } else {
                            // Chưa có -> Thêm mới
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