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

        // Lấy danh sách địa chỉ đã lưu nếu khách đã đăng nhập
        UserModel user = (UserModel) session.getAttribute("USERMODEL");
        if (user != null) {
            vn.edu.eaut.fruitables.dao.IUserAddressDAO userAddressDAO = new vn.edu.eaut.fruitables.dao.impl.UserAddressDAOImpl();
            request.setAttribute("savedAddresses", userAddressDAO.findByUserId(user.getId()));
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
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String notes = request.getParameter("notes");
        String paymentMethod = request.getParameter("paymentMethod"); // COD, VNPAY, MOMO

        if ((fullName == null || fullName.trim().isEmpty()) && user != null) {
            fullName = user.getFullName();
        }
        if ((email == null || email.trim().isEmpty()) && user != null) {
            email = user.getEmail();
        }

        // Lấy các tham số vận chuyển
        double shippingFee = 0.0;
        double distanceKm = 0.0;
        double shippingDiscount = 0.0;

        try {
            String sFee = request.getParameter("shippingFee");
            if (sFee != null && !sFee.trim().isEmpty()) {
                shippingFee = Double.parseDouble(sFee.trim());
            } else if (session.getAttribute("SHIPPING_RAW_FEE") != null) {
                shippingFee = (Double) session.getAttribute("SHIPPING_RAW_FEE");
            }
        } catch (Exception ignored) {}

        try {
            String sDist = request.getParameter("distanceKm");
            if (sDist != null && !sDist.trim().isEmpty()) {
                distanceKm = Double.parseDouble(sDist.trim());
            } else if (session.getAttribute("SHIPPING_DISTANCE_KM") != null) {
                distanceKm = (Double) session.getAttribute("SHIPPING_DISTANCE_KM");
            }
        } catch (Exception ignored) {}

        try {
            String sDisc = request.getParameter("shippingDiscount");
            if (sDisc != null && !sDisc.trim().isEmpty()) {
                shippingDiscount = Double.parseDouble(sDisc.trim());
            } else if (session.getAttribute("SHIPPING_DISCOUNT") != null) {
                shippingDiscount = (Double) session.getAttribute("SHIPPING_DISCOUNT");
            }
        } catch (Exception ignored) {}

        double finalShippingFee = Math.max(0.0, shippingFee - shippingDiscount);

        // Lưu địa chỉ vào sổ nếu người dùng tick chọn
        String saveAddressParam = request.getParameter("saveAddress");
        if (("1".equals(saveAddressParam) || "true".equalsIgnoreCase(saveAddressParam)) && user != null && address != null && !address.trim().isEmpty()) {
            try {
                vn.edu.eaut.fruitables.dao.IUserAddressDAO userAddressDAO = new vn.edu.eaut.fruitables.dao.impl.UserAddressDAOImpl();
                vn.edu.eaut.fruitables.model.entity.UserAddressModel newAddr = new vn.edu.eaut.fruitables.model.entity.UserAddressModel();
                newAddr.setUserId(user.getId());
                newAddr.setRecipientName(fullName);
                newAddr.setPhone(phone);
                newAddr.setProvince(request.getParameter("provinceName") != null ? request.getParameter("provinceName") : "");
                newAddr.setDistrict(request.getParameter("districtName") != null ? request.getParameter("districtName") : "");
                newAddr.setWard(request.getParameter("wardName") != null ? request.getParameter("wardName") : "");
                newAddr.setStreetAddress(request.getParameter("street") != null ? request.getParameter("street") : address);
                newAddr.setFullAddress(address);
                newAddr.setIsDefault(false);
                userAddressDAO.save(newAddr);
            } catch (Exception ignored) {}
        }

        // 3. Lấy giỏ hàng từ Session
        @SuppressWarnings("unchecked")
        Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");

        if (cart != null && !cart.isEmpty()) {
            // Tính tổng tiền đơn hàng và tổng thuế
            double totalAmount = 0;
            double totalTax = 0;

            for (CartItemDTO item : cart.values()) {
                totalAmount += item.getSubTotal();
                totalTax += item.getTaxAmount(); // Lấy tiền thuế của từng món
            }

            // Cộng thuế vào tổng hóa đơn
            totalAmount += totalTax;

            // XỬ LÝ MÃ GIẢM GIÁ
            String couponType = (String) session.getAttribute("APPLIED_COUPON_TYPE");
            Double discountAmount = (Double) session.getAttribute("DISCOUNT_AMOUNT");

            if ("FREESHIP".equalsIgnoreCase(couponType)) {
                // Mã Freeship đã được trừ vào phí ship (finalShippingFee)
            } else if (discountAmount != null && discountAmount > 0) {
                totalAmount -= discountAmount;
                if (totalAmount < 0) totalAmount = 0;
            }

            // Cộng tiền phí vận chuyển thực tế vào tổng tiền đơn hàng
            totalAmount += finalShippingFee;

            // Sinh mã đơn hàng ảo (VD: FRUIT-A1B2)
            String orderCode = "FRUIT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

            // ĐÓNG GÓI MODEL ĐỂ GỌI SERVICE LƯU DB
            OrderModel newOrder = new OrderModel();
            newOrder.setOrderCode(orderCode);
            newOrder.setUserId(userId);
            newOrder.setRecipientName(fullName);
            newOrder.setCustomerEmail(email);
            newOrder.setOrderNotes(notes);
            newOrder.setTotalAmount(totalAmount);
            newOrder.setShippingFee(shippingFee);
            newOrder.setDistanceKm(distanceKm);
            newOrder.setShippingDiscount(shippingDiscount);
            newOrder.setShippingAddress(address);
            newOrder.setPhone(phone);
            newOrder.setPaymentMethod(paymentMethod);
            newOrder.setStatus("PENDING"); // Đơn hàng mới luôn là PENDING

            // LƯU DB: Gọi tầng service lưu Order và Order_Details
            OrderModel savedOrder = orderService.createOrder(newOrder, cart);

            if (savedOrder != null) {
                if (userId != null) {
                    try {
                        vn.edu.eaut.fruitables.dao.INotificationDAO notificationDAO = new vn.edu.eaut.fruitables.dao.impl.NotificationDAOImpl();
                        notificationDAO.createNotification(
                                userId,
                                savedOrder.getId(),
                                orderCode,
                                "Đặt hàng thành công: " + orderCode,
                                "Đơn hàng của bạn đã được tiếp nhận và đang chờ xác nhận từ Fruitables. Cảm ơn bạn!",
                                "ORDER_PENDING"
                        );
                    } catch (Exception ignored) {}
                }
                // RẼ NHÁNH LOGIC THANH TOÁN SAU KHI LƯU DB THÀNH CÔNG
                if ("COD".equals(paymentMethod)) {

                    // TỰ ĐỘNG TRỪ TỒN KHO TRONG CSDL CHO ĐƠN COD
                    ProductDAOImpl productDAO = new ProductDAOImpl();
                    for (CartItemDTO item : cart.values()) {
                        productDAO.update("UPDATE products SET stock = stock - ? WHERE id = ?", item.getQuantity(), item.getProductId());
                    }

                    // TĂNG SỐ LƯỢT ĐÃ DÙNG CHO VOUCHER
                    String appliedCoupon = (String) session.getAttribute("APPLIED_COUPON_CODE");
                    if (appliedCoupon != null && !appliedCoupon.trim().isEmpty()) {
                        productDAO.update("UPDATE coupons SET used_count = used_count + 1 WHERE code = ?", appliedCoupon.trim());
                    }

                    // Xóa giỏ hàng và dữ liệu mã giảm giá
                    session.removeAttribute("CART");
                    session.removeAttribute("CART_TOTAL_ITEMS");
                    session.removeAttribute("DISCOUNT_AMOUNT");
                    session.removeAttribute("APPLIED_COUPON_CODE");
                    session.removeAttribute("COUPON_MESSAGE");
                    session.removeAttribute("SHIPPING_DISTANCE_KM");
                    session.removeAttribute("SHIPPING_RAW_FEE");
                    session.removeAttribute("SHIPPING_DISCOUNT");
                    session.removeAttribute("SHIPPING_FINAL_FEE");
                    session.removeAttribute("APPLIED_COUPON_TYPE");

                    session.setAttribute("orderSuccess", "Đặt hàng thành công! Mã đơn: " + orderCode + " (Thanh toán khi nhận hàng)");

                    response.sendRedirect(request.getContextPath() + "/home");

                } else if ("MOMO".equals(paymentMethod)) {
                    // Nếu là MOMO -> Chuyển sang trang quét mã QR MoMo
                    session.setAttribute("PENDING_ORDER_CODE", orderCode);
                    session.setAttribute("PENDING_TOTAL_AMOUNT", totalAmount);
                    session.setAttribute("PENDING_METHOD", "MOMO");

                    response.sendRedirect(request.getContextPath() + "/momo-payment");

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