package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.entity.UserModel;

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
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

        // 1. Lấy thông tin từ form
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod"); // COD, VNPAY, MOMO

        // 2. Lấy giỏ hàng
        Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");

        if (cart != null && !cart.isEmpty()) {
            // Tính tổng tiền đơn hàng
            double totalAmount = 0;
            for (CartItemDTO item : cart.values()) {
                totalAmount += item.getSubTotal();
            }

            // Sinh mã đơn hàng ảo (VD: FRUIT-A1B2)
            String orderCode = "FRUIT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

            // RẼ NHÁNH LOGIC THANH TOÁN
            if ("COD".equals(paymentMethod)) {
                // TẠI ĐÂY LÀ LOGIC LƯU DATABASE (DAO) cho COD (Trạng thái: PENDING, Chưa thanh toán)

                // Xóa giỏ hàng và báo thành công
                session.removeAttribute("CART");
                session.removeAttribute("CART_TOTAL_ITEMS");
                session.setAttribute("orderSuccess", "Đặt hàng thành công! Mã đơn: " + orderCode + " (Thanh toán khi nhận hàng)");

                response.sendRedirect(request.getContextPath() + "/home");

            } else {
                // TẠI ĐÂY LÀ LOGIC LƯU DATABASE (DAO) cho VNPAY/MOMO (Trạng thái: PENDING, Chưa thanh toán)

                // Nếu là VNPAY hoặc MOMO -> Chuyển sang trang quét mã QR giả lập
                // Lưu tạm thông tin để hiển thị bên trang QR
                session.setAttribute("PENDING_ORDER_CODE", orderCode);
                session.setAttribute("PENDING_TOTAL_AMOUNT", totalAmount);
                session.setAttribute("PENDING_METHOD", paymentMethod);

                response.sendRedirect(request.getContextPath() + "/mock-payment");
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}