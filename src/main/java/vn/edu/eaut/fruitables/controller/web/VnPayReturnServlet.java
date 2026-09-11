package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.util.DBConnectionUtil;
import vn.edu.eaut.fruitables.util.VnPayConfigUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.*;

@WebServlet(urlPatterns = {"/vnpay-return"})
public class VnPayReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            Map<String, String> fields = new HashMap<>();
            for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = URLEncoder.encode(params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            fields.remove("vnp_SecureHashType");
            fields.remove("vnp_SecureHash");

            List<String> fieldNames = new ArrayList<>(fields.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = fields.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    hashData.append(fieldName).append('=').append(fieldValue);
                    if (itr.hasNext()) {
                        hashData.append('&');
                    }
                }
            }

            String signValue = VnPayConfigUtil.hmacSHA512(VnPayConfigUtil.secretKey, hashData.toString());

            // BẢO MẬT: Bắt buộc xác thực chữ ký điện tử HMAC-SHA512 từ VNPay
            if (signValue != null && signValue.equalsIgnoreCase(vnp_SecureHash)) {
                String responseCode = request.getParameter("vnp_ResponseCode");
                String orderCode = request.getParameter("vnp_TxnRef");

                if (orderCode != null && !orderCode.isEmpty()) {
                    if ("00".equals(responseCode)) {
                        // Thanh toán hợp lệ và thành công -> Cập nhật payment_status = 'PAID', status = 'PACKING'
                        updateOrderPaymentSuccess(orderCode);
                        session.setAttribute("orderSuccess", "Thanh toán thành công qua VNPay! Mã đơn: " + orderCode + " đã được xác nhận.");
                    } else {
                        // Khách hủy hoặc thanh toán không thành công
                        session.setAttribute("orderSuccess", "Giao dịch thanh toán chưa hoàn tất hoặc bị hủy đối với đơn: " + orderCode);
                    }
                }
            } else {
                session.setAttribute("ORDER_MESSAGE_ERROR", "Cảnh báo: Chữ ký số giao dịch VNPay không hợp lệ hoặc dữ liệu bị can thiệp!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("ORDER_MESSAGE_ERROR", "Lỗi xử lý phản hồi từ VNPay: " + e.getMessage());
        }

        // Dọn dẹp session tạm
        session.removeAttribute("PENDING_ORDER_CODE");
        session.removeAttribute("PENDING_TOTAL_AMOUNT");
        session.removeAttribute("PENDING_METHOD");

        // Quay về trang chủ hiển thị thông báo
        response.sendRedirect(request.getContextPath() + "/home");
    }

    private void updateOrderPaymentSuccess(String orderCode) {
        String sql = "UPDATE orders SET payment_status = 'PAID', status = 'PACKING' WHERE order_code = ? AND payment_status != 'PAID'";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}