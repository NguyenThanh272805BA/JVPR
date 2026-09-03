package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.service.IProductService;
import vn.edu.eaut.fruitables.service.impl.ProductServiceImpl;

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

    // Khai báo Service để lấy dữ liệu sản phẩm từ CSDL
    private IProductService productService;

    public CartServlet() {
        this.productService = new ProductServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chuyển hướng đến trang giao diện giỏ hàng
        request.getRequestDispatcher("/WEB-INF/views/web/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // Lấy giỏ hàng từ Session. Nếu chưa có thì tạo mới một HashMap
        @SuppressWarnings("unchecked")
        Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");
        if (cart == null) {
            cart = new HashMap<>();
        }

        try {
            Long productId = Long.parseLong(request.getParameter("productId"));

            if ("add".equals(action)) {
                // SỬ DỤNG DỮ LIỆU THẬT: Truy vấn sản phẩm từ DB
                ProductModel product = productService.findById(productId);

                if (product != null) {
                    if (cart.containsKey(productId)) {
                        // Đã có trong giỏ -> Tăng số lượng
                        CartItemDTO existingItem = cart.get(productId);
                        existingItem.setQuantity(existingItem.getQuantity() + 1);
                    } else {
                        CartItemDTO newItem = new CartItemDTO(
                                product.getId(),
                                product.getName(),
                                product.getImageUrl(),
                                product.getPrice(),
                                1, // Số lượng mặc định ban đầu là 1
                                product.getTaxRate() != null ? product.getTaxRate() : 0.0 // Lấy % thuế từ DB
                        );
                        cart.put(productId, newItem);
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
}