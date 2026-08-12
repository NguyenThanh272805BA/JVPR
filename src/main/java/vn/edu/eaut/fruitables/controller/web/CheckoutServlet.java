package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.dao.impl.ProductDAOImpl;
import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.IOrderService;
import vn.edu.eaut.fruitables.service.impl.OrderServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import java.util.UUID;

@WebServlet(urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private IOrderService orderService;

    public CheckoutServlet() {
        this.orderService = new OrderServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");

        // Nếu giỏ hàng trống, đá về trang cửa hàng
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        // Nếu hợp lệ, hiển thị trang checkout
        request.getRequestDispatcher("/WEB-INF/views/web/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 1. Lấy thông tin khách hàng hiện tại
        UserModel user = (UserModel) session.getAttribute("USERMODEL");
        Long userId = (user != null) ? user.getId() : null;

        // 2. Lấy thông tin từ form checkout
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod"); // COD, VNPAY, MOMO

        // 3. Lấy giỏ hàng từ Session
        @SuppressWarnings("unchecked")
        Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");

        if (cart != null && !cart.isEmpty()) {
            // Tính tổng tiền đơn hàng
            double totalAmount = 0;
            for (CartItemDTO item : cart.values()) {
                totalAmount += item.getSubTotal();
            }

            // XỬ LÝ MÃ GIẢM GIÁ (Trừ tiền nếu có Voucher trong Session)
            Double discountAmount = (Double) session.getAttribute("DISCOUNT_AMOUNT");
            if (discountAmount != null && discountAmount > 0) {
                totalAmount -= discountAmount;
                if (totalAmount < 0) totalAmount = 0;
            }

            // Sinh mã đơn hàng ảo (VD: FRUIT-A1B2)
            String orderCode = "FRUIT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

            // ĐÓNG GÓI MODEL ĐỂ GỌI SERVICE LƯU DB
            OrderModel newOrder = new OrderModel();
            newOrder.setOrderCode(orderCode);
            newOrder.setUserId(userId);
            newOrder.setTotalAmount(totalAmount);
            newOrder.setShippingAddress(address);
            newOrder.setPhone(phone);
            newOrder.setPaymentMethod(paymentMethod);
            newOrder.setStatus("PENDING"); // Đơn hàng mới luôn là PENDING

            // LƯU DB: Gọi tầng service lưu Order và Order_Details
            OrderModel savedOrder = orderService.createOrder(newOrder, cart);

            if (savedOrder != null) {
                // RẼ NHÁNH LOGIC THANH TOÁN SAU KHI LƯU DB THÀNH CÔNG
                if ("COD".equals(paymentMethod)) {

                    // TỰ ĐỘNG TRỪ TỒN KHO TRONG CSDL CHO ĐƠN COD
                    ProductDAOImpl productDAO = new ProductDAOImpl();
                    for (CartItemDTO item : cart.values()) {
                        productDAO.update("UPDATE products SET stock = stock - ? WHERE id = ?", item.getQuantity(), item.getProductId());
                    }

                    // Xóa giỏ hàng và dữ liệu mã giảm giá
                    session.removeAttribute("CART");
                    session.removeAttribute("CART_TOTAL_ITEMS");
                    session.removeAttribute("DISCOUNT_AMOUNT");
                    session.removeAttribute("APPLIED_COUPON_CODE");
                    session.removeAttribute("COUPON_MESSAGE");

                    session.setAttribute("orderSuccess", "Đặt hàng thành công! Mã đơn: " + orderCode + " (Thanh toán khi nhận hàng)");

                    response.sendRedirect(request.getContextPath() + "/home");

                } else {
                    // Nếu là VNPAY -> Chuyển sang Servlet tạo Link thanh toán thật
                    session.setAttribute("PENDING_ORDER_CODE", orderCode);
                    session.setAttribute("PENDING_TOTAL_AMOUNT", totalAmount);
                    session.setAttribute("PENDING_METHOD", paymentMethod);

                    response.sendRedirect(request.getContextPath() + "/create-vnpay-payment");
                }
            } else {
                // Nếu lưu DB thất bại
                response.sendRedirect(request.getContextPath() + "/cart?message=Error");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}