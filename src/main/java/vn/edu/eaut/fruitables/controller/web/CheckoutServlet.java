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
import java.util.List;
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

        // Lấy danh sách địa chỉ đã lưu & cập nhật điểm thành viên nếu khách đã đăng nhập
        UserModel user = (UserModel) session.getAttribute("USERMODEL");
        if (user != null) {
            vn.edu.eaut.fruitables.dao.IUserDAO userDAO = new vn.edu.eaut.fruitables.dao.impl.UserDAOImpl();
            UserModel freshUser = userDAO.findById(user.getId());
            if (freshUser != null) {
                session.setAttribute("USERMODEL", freshUser);
                user = freshUser;
            }
            vn.edu.eaut.fruitables.dao.IUserAddressDAO userAddressDAO = new vn.edu.eaut.fruitables.dao.impl.UserAddressDAOImpl();
            List<vn.edu.eaut.fruitables.model.entity.UserAddressModel> addrs = userAddressDAO.findByUserId(user.getId());
            if (addrs == null || addrs.isEmpty()) {
                // Tự động đồng bộ từ lịch sử các đơn hàng trước đây nếu sổ địa chỉ còn trống
                try {
                    vn.edu.eaut.fruitables.dao.IOrderDAO orderDAO = new vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl();
                    List<vn.edu.eaut.fruitables.model.entity.OrderModel> pastOrders = orderDAO.findByUserId(user.getId());
                    if (pastOrders != null && !pastOrders.isEmpty()) {
                        java.util.Set<String> seenAddrs = new java.util.HashSet<>();
                        for (vn.edu.eaut.fruitables.model.entity.OrderModel pastOrder : pastOrders) {
                            String shipAddr = pastOrder.getShippingAddress();
                            if (shipAddr != null && !shipAddr.trim().isEmpty() && seenAddrs.add(shipAddr.trim().toLowerCase())) {
                                vn.edu.eaut.fruitables.model.entity.UserAddressModel autoAddr = new vn.edu.eaut.fruitables.model.entity.UserAddressModel();
                                autoAddr.setUserId(user.getId());
                                autoAddr.setRecipientName(pastOrder.getRecipientName() != null ? pastOrder.getRecipientName() : user.getFullName());
                                autoAddr.setPhone(pastOrder.getPhone() != null ? pastOrder.getPhone() : user.getPhone());
                                autoAddr.setFullAddress(shipAddr.trim());
                                autoAddr.setStreetAddress(shipAddr.trim());
                                autoAddr.setIsDefault(addrs == null || addrs.isEmpty());
                                userAddressDAO.save(autoAddr);
                            }
                        }
                        addrs = userAddressDAO.findByUserId(user.getId());
                    }
                } catch (Exception ignored) {}
            }
            request.setAttribute("savedAddresses", addrs);
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

        // TỰ ĐỘNG LƯU ĐỊA CHỈ VÀO SỔ ĐỊA CHỈ CHO KHÁCH ĐÃ CÓ TÀI KHOẢN
        if (user != null && address != null && !address.trim().isEmpty()) {
            try {
                vn.edu.eaut.fruitables.dao.IUserAddressDAO userAddressDAO = new vn.edu.eaut.fruitables.dao.impl.UserAddressDAOImpl();
                List<vn.edu.eaut.fruitables.model.entity.UserAddressModel> existingAddrs = userAddressDAO.findByUserId(user.getId());
                boolean exists = false;
                if (existingAddrs != null) {
                    for (vn.edu.eaut.fruitables.model.entity.UserAddressModel ea : existingAddrs) {
                        if (ea.getFullAddress() != null && ea.getFullAddress().trim().equalsIgnoreCase(address.trim())) {
                            exists = true;
                            break;
                        }
                    }
                }
                if (!exists) {
                    vn.edu.eaut.fruitables.model.entity.UserAddressModel newAddr = new vn.edu.eaut.fruitables.model.entity.UserAddressModel();
                    newAddr.setUserId(user.getId());
                    newAddr.setRecipientName(fullName != null && !fullName.trim().isEmpty() ? fullName.trim() : user.getFullName());
                    newAddr.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : user.getPhone());
                    newAddr.setProvince(request.getParameter("provinceName") != null ? request.getParameter("provinceName") : "");
                    newAddr.setDistrict(request.getParameter("districtName") != null ? request.getParameter("districtName") : "");
                    newAddr.setWard(request.getParameter("wardName") != null ? request.getParameter("wardName") : "");
                    newAddr.setStreetAddress(request.getParameter("street") != null && !request.getParameter("street").trim().isEmpty() ? request.getParameter("street").trim() : address.trim());
                    newAddr.setFullAddress(address.trim());
                    newAddr.setIsDefault(existingAddrs == null || existingAddrs.isEmpty());
                    userAddressDAO.save(newAddr);
                }
            } catch (Exception ignored) {}
        }

        // 3. Lấy giỏ hàng từ Session
        @SuppressWarnings("unchecked")
        Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");

        if (cart != null && !cart.isEmpty()) {
            // 1. Tính tổng tiền hàng và tổng thuế VAT thực tế từ giỏ
            double subtotalGoods = 0;
            double totalTax = 0;

            for (CartItemDTO item : cart.values()) {
                subtotalGoods += item.getSubTotal();
                totalTax += item.getTaxAmount(); // Tiền thuế của từng món
            }

            double totalAmount = subtotalGoods + totalTax;

            // 2. RE-VALIDATE VOUCHER TỪ CSDL ĐỂ CHỐNG GIAN LẬN GIÁ (Session Bleed Exploit)
            String appliedCoupon = (String) session.getAttribute("APPLIED_COUPON_CODE");
            double discountAmount = 0.0;
            boolean couponValid = false;

            if (appliedCoupon != null && !appliedCoupon.trim().isEmpty()) {
                String checkCouponSql = "SELECT c.*, p.name AS product_name FROM coupons c LEFT JOIN products p ON c.product_id = p.id WHERE c.code = ?";
                try (java.sql.Connection conn = vn.edu.eaut.fruitables.util.DBConnectionUtil.getConnection();
                     java.sql.PreparedStatement ps = conn.prepareStatement(checkCouponSql)) {
                    ps.setString(1, appliedCoupon.trim());
                    try (java.sql.ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            boolean status = rs.getBoolean("status");
                            java.sql.Timestamp startDate = rs.getTimestamp("start_date");
                            java.sql.Timestamp endDate = rs.getTimestamp("end_date");
                            int usageLimit = rs.getInt("usage_limit");
                            int usedCount = rs.getInt("used_count");
                            Long specificProductId = rs.getObject("product_id") != null ? rs.getLong("product_id") : null;
                            double minOrderValue = rs.getDouble("min_order_value");
                            String discountType = rs.getString("discount_type");
                            double discountValue = rs.getDouble("discount_value");
                            java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());

                            boolean isValid = status
                                    && (startDate == null || !now.before(startDate))
                                    && (endDate == null || !now.after(endDate))
                                    && (usageLimit <= 0 || usedCount < usageLimit)
                                    && (subtotalGoods >= minOrderValue);

                            if (isValid && specificProductId != null && !cart.containsKey(specificProductId)) {
                                isValid = false;
                            }

                            if (isValid) {
                                couponValid = true;
                                if ("FREESHIP".equalsIgnoreCase(discountType)) {
                                    discountAmount = 0.0; // Đã trừ vào finalShippingFee
                                } else if (specificProductId != null) {
                                    CartItemDTO targetItem = cart.get(specificProductId);
                                    double itemTotal = targetItem.getSubTotal();
                                    if ("PERCENT".equalsIgnoreCase(discountType)) {
                                        discountAmount = (itemTotal * discountValue) / 100.0;
                                    } else {
                                        discountAmount = Math.min(discountValue, itemTotal);
                                    }
                                } else {
                                    if ("PERCENT".equalsIgnoreCase(discountType)) {
                                        discountAmount = (subtotalGoods * discountValue) / 100.0;
                                    } else {
                                        discountAmount = discountValue;
                                    }
                                }
                                discountAmount = Math.min(discountAmount, subtotalGoods);
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if (discountAmount > 0) {
                totalAmount -= discountAmount;
                if (totalAmount < 0) totalAmount = 0;
            }

            // Cộng tiền phí vận chuyển thực tế vào tổng tiền đơn hàng
            totalAmount += finalShippingFee;

            // Xử lý khung giờ giao hàng & ngày giao mong muốn
            String deliverySlot = request.getParameter("deliverySlot");
            if (deliverySlot == null || deliverySlot.trim().isEmpty()) {
                deliverySlot = "FAST_1_2H";
            }
            java.sql.Date deliveryDate = null;
            try {
                String dDate = request.getParameter("deliveryDate");
                if (dDate != null && !dDate.trim().isEmpty()) {
                    deliveryDate = java.sql.Date.valueOf(dDate.trim());
                }
            } catch (Exception ignored) {}

            // Xử lý Dùng Điểm Tích Lũy (Redeem Points)
            String usePointsParam = request.getParameter("usePoints");
            int usedPoints = 0;
            double pointsDiscount = 0.0;
            if (("1".equals(usePointsParam) || "true".equalsIgnoreCase(usePointsParam)) && user != null) {
                vn.edu.eaut.fruitables.dao.IUserDAO userDAO = new vn.edu.eaut.fruitables.dao.impl.UserDAOImpl();
                UserModel freshUser = userDAO.findById(user.getId());
                int available = (freshUser != null && freshUser.getPoints() != null) ? freshUser.getPoints() : 0;
                if (available > 0) {
                    int maxPointsCanUse = (int) (totalAmount / 100.0);
                    usedPoints = Math.min(available, maxPointsCanUse);
                    if (usedPoints > 0) {
                        pointsDiscount = usedPoints * 100.0;
                        totalAmount -= pointsDiscount;
                        if (totalAmount < 0) totalAmount = 0.0;

                        // Trừ điểm của user
                        try (java.sql.Connection conn = vn.edu.eaut.fruitables.util.DBConnectionUtil.getConnection();
                             java.sql.PreparedStatement ps = conn.prepareStatement("UPDATE users SET points = points - ? WHERE id = ?")) {
                            ps.setInt(1, usedPoints);
                            ps.setLong(2, user.getId());
                            ps.executeUpdate();
                        } catch (Exception ignored) {}
                    }
                }
            }

            // Sinh mã đơn hàng (VD: FRUIT-A1B2)
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
            newOrder.setDeliverySlot(deliverySlot);
            newOrder.setDeliveryDate(deliveryDate);
            newOrder.setUsedPoints(usedPoints);
            newOrder.setPointsDiscount(pointsDiscount);

            // LƯU DB: Gọi tầng service lưu Order và Order_Details
            OrderModel savedOrder = orderService.createOrder(newOrder, cart);

            if (savedOrder != null) {
                // Ghi log giao dịch trừ điểm nếu có
                if (usedPoints > 0 && userId != null) {
                    try (java.sql.Connection conn = vn.edu.eaut.fruitables.util.DBConnectionUtil.getConnection();
                         java.sql.PreparedStatement ps = conn.prepareStatement("INSERT INTO point_transactions (user_id, order_id, points_amount, transaction_type, description) VALUES (?, ?, ?, 'REDEEM', ?)")) {
                        ps.setLong(1, userId);
                        ps.setLong(2, savedOrder.getId());
                        ps.setInt(3, usedPoints);
                        ps.setString(4, "Dùng " + usedPoints + " điểm giảm " + String.format("%,.0f", pointsDiscount) + "đ cho đơn #" + orderCode);
                        ps.executeUpdate();
                    } catch (Exception ignored) {}
                }

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

                // TRỪ TỒN KHO ĐỒNG NHẤT CHO MỌI PHƯƠNG THỨC THANH TOÁN (COD, VNPAY, MOMO)
                // Giữ hàng ngay tại thời điểm tạo đơn, ngăn chặn hoàn toàn tình trạng bán âm kho (Overselling)
                ProductDAOImpl productDAO = new ProductDAOImpl();
                for (CartItemDTO item : cart.values()) {
                    productDAO.update("UPDATE products SET stock = stock - ? WHERE id = ?", item.getQuantity(), item.getProductId());
                }

                // TĂNG SỐ LƯỢT ĐÃ DÙNG CHO VOUCHER (NẾU HỢP LỆ)
                if (couponValid && appliedCoupon != null && !appliedCoupon.trim().isEmpty()) {
                    productDAO.update("UPDATE coupons SET used_count = used_count + 1 WHERE code = ?", appliedCoupon.trim());
                }

                // XÓA GIỎ HÀNG VÀ DỌN DẸP DỮ LIỆU SESSION
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

                // RẼ NHÁNH LOGIC THEO PHƯƠNG THỨC THANH TOÁN
                if ("COD".equals(paymentMethod)) {
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