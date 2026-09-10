package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl;
import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.entity.OrderDetailModel;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;
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
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/order-history"})
public class OrderHistoryServlet extends HttpServlet {

    private OrderDAOImpl orderDAO = new OrderDAOImpl();
    private IProductService productService = new ProductServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy danh sách các đơn hàng của User
        List<OrderModel> orders = orderDAO.findByUserId(user.getId());

        // Lấy chi tiết món hàng và ảnh cho từng đơn
        for (OrderModel order : orders) {
            order.setDetails(orderDAO.findOrderDetailsByOrderId(order.getId()));
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/web/order-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("confirm_received".equals(action)) {
            try {
                Long orderId = Long.parseLong(request.getParameter("orderId"));
                OrderModel order = orderDAO.findById(orderId);

                // Kiểm tra bảo mật: Đúng đơn hàng của user đăng nhập
                if (order != null && order.getUserId().equals(user.getId())) {
                    orderDAO.updateOrderStatus(orderId, "COMPLETED");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        } else if ("reorder".equals(action)) {
            try {
                Long orderId = Long.parseLong(request.getParameter("orderId"));
                OrderModel order = orderDAO.findById(orderId);

                if (order != null && order.getUserId().equals(user.getId())) {
                    List<OrderDetailModel> details = orderDAO.findOrderDetailsByOrderId(orderId);

                    @SuppressWarnings("unchecked")
                    Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");
                    if (cart == null) {
                        cart = new HashMap<>();
                    }

                    int addedCount = 0;
                    for (OrderDetailModel item : details) {
                        ProductModel product = productService.findById(item.getProductId());
                        if (product != null && product.getStock() != null && product.getStock() > 0) {
                            int qtyToAdd = Math.min(item.getQuantity(), product.getStock());
                            Double actualPrice = (product.getDiscountPrice() != null && product.getDiscountPrice() > 0)
                                    ? product.getDiscountPrice() : product.getPrice();

                            if (cart.containsKey(product.getId())) {
                                CartItemDTO existing = cart.get(product.getId());
                                existing.setQuantity(existing.getQuantity() + qtyToAdd);
                            } else {
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
                                cart.put(product.getId(), newItem);
                            }
                            addedCount++;
                        }
                    }

                    session.setAttribute("CART", cart);
                    int totalItems = cart.values().stream().mapToInt(CartItemDTO::getQuantity).sum();
                    session.setAttribute("CART_TOTAL_ITEMS", totalItems);

                    if (addedCount > 0) {
                        session.setAttribute("COUPON_MESSAGE", "Đã thêm các món từ đơn " + order.getOrderCode() + " vào giỏ hàng!");
                    }
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/order-history");
    }
}