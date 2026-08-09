package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.dto.CartItemDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chỉ đơn giản là chuyển hướng đến trang giao diện giỏ hàng
        request.getRequestDispatcher("/WEB-INF/views/web/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // Lấy giỏ hàng từ Session. Nếu chưa có thì tạo mới một HashMap
        Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");
        if (cart == null) {
            cart = new HashMap<>();
        }

        try {
            Long productId = Long.parseLong(request.getParameter("productId"));

            if ("add".equals(action)) {
                // TÌM SẢN PHẨM: Đáng lẽ gọi DAO (productDAO.findById), nhưng tạm dùng Mock Data
                CartItemDTO item = getMockProductById(productId);

                if (item != null) {
                    if (cart.containsKey(productId)) {
                        // Đã có trong giỏ -> Tăng số lượng
                        CartItemDTO existingItem = cart.get(productId);
                        existingItem.setQuantity(existingItem.getQuantity() + 1);
                    } else {
                        // Chưa có -> Thêm mới với số lượng = 1
                        item.setQuantity(1);
                        cart.put(productId, item);
                    }
                }
            } else if ("update".equals(action)) {
                // Cập nhật số lượng (dùng khi khách bấm nút +/- trong giỏ)
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                if (cart.containsKey(productId)) {
                    if (quantity <= 0) {
                        cart.remove(productId);
                    } else {
                        cart.get(productId).setQuantity(quantity);
                    }
                }
            } else if ("remove".equals(action)) {
                // Xóa hẳn khỏi giỏ
                cart.remove(productId);
            }

            // Lưu lại giỏ hàng vào Session
            session.setAttribute("CART", cart);

            // Tính toán tổng số lượng item để hiển thị trên icon Navbar
            int totalItems = cart.values().stream().mapToInt(CartItemDTO::getQuantity).sum();
            session.setAttribute("CART_TOTAL_ITEMS", totalItems);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Sau khi xử lý POST, dùng sendRedirect để tránh lỗi "Submit lại form" khi F5
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    // HÀM MOCK DATA TẠM THỜI (Sau này sẽ xóa và thay bằng ProductDAO)
    private CartItemDTO getMockProductById(Long id) {
        if (id == 1L) return new CartItemDTO(1L, "Táo Gala Hữu Cơ", "https://images.unsplash.com/photo-1560806887-1e4cd0b6fac6?w=500&auto=format&fit=crop", 115000.0, 0);
        if (id == 2L) return new CartItemDTO(2L, "Rau Bina Hữu Cơ", "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500&auto=format&fit=crop", 25000.0, 0);
        if (id == 3L) return new CartItemDTO(3L, "Chanh Vàng Sạch", "https://images.unsplash.com/photo-1590502593747-422e15779c16?w=500&auto=format&fit=crop", 18000.0, 0);
        if (id == 4L) return new CartItemDTO(4L, "Cà chua Cherry", "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500&auto=format&fit=crop", 105000.0, 0);
        return null;
    }
}