package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.JsonObject;
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
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = {"/api/add-to-cart"})
public class AddToCartAPIServlet extends HttpServlet {

    private IProductService productService;

    public AddToCartAPIServlet() {
        this.productService = new ProductServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Cấu hình Header trả về JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            Long productId = Long.parseLong(request.getParameter("productId"));
            HttpSession session = request.getSession();

            // Lấy giỏ hàng từ Session
            @SuppressWarnings("unchecked")
            Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");
            if (cart == null) {
                cart = new HashMap<>();
            }

            // Truy vấn sản phẩm
            ProductModel product = productService.findById(productId);
            if (product != null) {
                // Kiểm tra tình trạng tồn kho
                if (product.getStock() != null && product.getStock() <= 0) {
                    jsonResponse.addProperty("status", "out_of_stock");
                    jsonResponse.addProperty("message", "Sản phẩm " + product.getName() + " hiện đã hết hàng!");
                    jsonResponse.addProperty("redirectUrl", request.getContextPath() + "/shop");
                    out.print(jsonResponse.toString());
                    out.flush();
                    return;
                }

                int qtyToAdd = 1;
                String qtyParam = request.getParameter("quantity");
                if (qtyParam != null && !qtyParam.trim().isEmpty()) {
                    try {
                        qtyToAdd = Math.max(1, Integer.parseInt(qtyParam.trim()));
                    } catch (Exception ignored) {}
                }

                // KIỂM TRA GIỚI HẠN TỒN KHO THỰC TẾ TRONG GIỎ HÀNG
                int currentQtyInCart = cart.containsKey(productId) ? cart.get(productId).getQuantity() : 0;
                int maxStock = (product.getStock() != null) ? product.getStock() : 0;

                if (currentQtyInCart + qtyToAdd > maxStock) {
                    jsonResponse.addProperty("status", "limit_reached");
                    jsonResponse.addProperty("message", "Kho chỉ còn " + maxStock + " sản phẩm. Bạn đã có " + currentQtyInCart + " sản phẩm trong giỏ hàng.");
                    out.print(jsonResponse.toString());
                    out.flush();
                    return;
                }

                Double actualPrice = (product.getDiscountPrice() != null && product.getDiscountPrice() > 0)
                        ? product.getDiscountPrice() : product.getPrice();

                if (cart.containsKey(productId)) {
                    // Đã có -> Tăng số lượng
                    CartItemDTO existingItem = cart.get(productId);
                    existingItem.setQuantity(existingItem.getQuantity() + qtyToAdd);
                } else {
                    // Chưa có -> Tạo mới
                    CartItemDTO newItem = new CartItemDTO(
                            product.getId(),
                            product.getName(),
                            product.getImageUrl(),
                            actualPrice,
                            qtyToAdd,
                            product.getTaxRate() != null ? product.getTaxRate() : 0.0,
                            product.getWeightGram() != null ? product.getWeightGram() : 500,
                            product.getStorageType() != null ? product.getStorageType() : "NORMAL",
                            Boolean.TRUE.equals(product.getIsFreeShipping())
                    );
                    cart.put(productId, newItem);
                }

                // CHỐNG GIAN LẬN VOUCHER (Session Bleed): Hủy voucher cũ khi giỏ hàng có thay đổi
                if (session.getAttribute("APPLIED_COUPON_CODE") != null) {
                    session.removeAttribute("DISCOUNT_AMOUNT");
                    session.removeAttribute("APPLIED_COUPON_CODE");
                    session.removeAttribute("APPLIED_COUPON_TYPE");
                    session.removeAttribute("COUPON_MESSAGE");
                    session.removeAttribute("SHIPPING_DISCOUNT");
                }

                // Lưu lại vào Session
                session.setAttribute("CART", cart);
                int totalItems = cart.values().stream().mapToInt(CartItemDTO::getQuantity).sum();
                session.setAttribute("CART_TOTAL_ITEMS", totalItems);

                // ĐỒNG BỘ GIỎ HÀNG VÀO DATABASE CHO USER ĐÃ ĐĂNG NHẬP
                vn.edu.eaut.fruitables.model.entity.UserModel user = (vn.edu.eaut.fruitables.model.entity.UserModel) session.getAttribute("USERMODEL");
                if (user != null) {
                    int finalQty = cart.get(productId).getQuantity();
                    try (java.sql.Connection conn = vn.edu.eaut.fruitables.util.DBConnectionUtil.getConnection()) {
                        String delSql = "DELETE FROM cart_items WHERE user_id = ? AND product_id = ?";
                        try (java.sql.PreparedStatement psD = conn.prepareStatement(delSql)) {
                            psD.setLong(1, user.getId());
                            psD.setLong(2, productId);
                            psD.executeUpdate();
                        }
                        String insSql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";
                        try (java.sql.PreparedStatement psI = conn.prepareStatement(insSql)) {
                            psI.setLong(1, user.getId());
                            psI.setLong(2, productId);
                            psI.setInt(3, finalQty);
                            psI.executeUpdate();
                        }
                    } catch (Exception ignored) {}
                }

                // Trả về JSON thành công
                jsonResponse.addProperty("status", "success");
                jsonResponse.addProperty("message", "Đã thêm " + product.getName() + " vào giỏ!");
                jsonResponse.addProperty("totalItems", totalItems);
            } else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Sản phẩm không tồn tại.");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Lỗi máy chủ.");
            e.printStackTrace();
        } finally {
            out.print(jsonResponse.toString());
            out.flush();
            out.close();
        }
    }
}