package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.dao.IGiftBasketTemplateDAO;
import vn.edu.eaut.fruitables.dao.IProductDAO;
import vn.edu.eaut.fruitables.dao.impl.GiftBasketTemplateDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.ProductDAOImpl;
import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.entity.GiftBasketTemplateModel;
import vn.edu.eaut.fruitables.model.entity.ProductModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/gift-basket-builder"})
public class GiftBasketServlet extends HttpServlet {

    private final IGiftBasketTemplateDAO templateDAO = new GiftBasketTemplateDAOImpl();
    private final IProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<GiftBasketTemplateModel> templates = templateDAO.findAllActive();
        List<ProductModel> fruits = productDAO.findAll();

        request.setAttribute("templates", templates);
        request.setAttribute("fruits", fruits);
        request.getRequestDispatcher("/WEB-INF/views/web/gift-basket-builder.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            int templateId = Integer.parseInt(request.getParameter("templateId"));
            GiftBasketTemplateModel template = templateDAO.findById(templateId);
            if (template == null) {
                response.sendRedirect(request.getContextPath() + "/gift-basket-builder?error=template_not_found");
                return;
            }

            String cardMessage = request.getParameter("cardMessage");
            String ribbonColor = request.getParameter("ribbonColor");
            if (ribbonColor == null || ribbonColor.trim().isEmpty()) {
                ribbonColor = "Đỏ May Mắn";
            }

            String[] fruitIds = request.getParameterValues("fruitId");
            String[] quantities = request.getParameterValues("quantity");

            double totalBasketPrice = template.getBasePrice();
            int totalWeightGram = 1000; // Trọng lượng vỏ giỏ + phụ kiện
            StringBuilder fruitSummary = new StringBuilder();

            if (fruitIds != null && quantities != null) {
                for (int i = 0; i < fruitIds.length; i++) {
                    try {
                        long pId = Long.parseLong(fruitIds[i]);
                        int qty = Integer.parseInt(quantities[i]);
                        if (qty > 0) {
                            ProductModel p = productDAO.findById(pId);
                            if (p != null) {
                                totalBasketPrice += p.getPrice() * qty;
                                totalWeightGram += (p.getWeightGram() != null ? p.getWeightGram() : 500) * qty;
                                if (fruitSummary.length() > 0) fruitSummary.append(", ");
                                fruitSummary.append(qty).append("x ").append(p.getName());
                            }
                        }
                    } catch (Exception ignored) {}
                }
            }

            String basketName = "Giỏ Quà: " + template.getName() + " (" + ribbonColor + ")";
            if (cardMessage != null && !cardMessage.trim().isEmpty()) {
                basketName += " - Thiệp: " + cardMessage.trim();
            }

            // Đảm bảo sản phẩm Master ID 99 tồn tại trong DB để tránh vi phạm khóa ngoại khi đặt hàng
            ProductModel masterBasket = productDAO.findById(99L);
            if (masterBasket == null) {
                try {
                    ((ProductDAOImpl) productDAO).update("INSERT INTO products (id, category_id, name, slug, description, detailed_description, price, cost_price, weight_gram, storage_type, is_free_shipping, tax_rate, discount_price, stock, image_url, status) VALUES (99, 8, 'Giỏ Quà Trái Cây Thiết Kế Riêng', 'gio-qua-thiet-ke-rieng-master-99', 'Sản phẩm Master cho giỏ quà khách hàng tự chọn', '<p>Master Gift Basket</p>', 0.00, 0.00, 1000, 'FRAGILE_GIFT', 1, 5.00, NULL, 99999, '/assets/uploads/products/gio_qua_thietke.jpg', 1) ON DUPLICATE KEY UPDATE id=id");
                } catch (Exception ignored) {}
            }

            // Đóng gói vào CartItemDTO (sản phẩm Master ID 99)
            CartItemDTO basketItem = new CartItemDTO(
                    99L,
                    basketName,
                    template.getImageUrl(),
                    totalBasketPrice,
                    1,
                    0.0,
                    totalWeightGram,
                    "FRAGILE_GIFT",
                    true
            );

            @SuppressWarnings("unchecked")
            Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");
            if (cart == null) {
                cart = new HashMap<>();
            }

            cart.put(99L, basketItem);
            session.setAttribute("CART", cart);

            session.setAttribute("ORDER_MESSAGE_SUCCESS", "Đã thêm Giỏ quà biếu tặng thiết kế riêng vào giỏ hàng thành công!");
            response.sendRedirect(request.getContextPath() + "/cart");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/gift-basket-builder?error=fail");
        }
    }
}
