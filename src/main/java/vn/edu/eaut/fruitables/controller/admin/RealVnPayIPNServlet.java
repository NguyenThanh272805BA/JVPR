package vn.edu.eaut.fruitables.controller.admin;

import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.ProductDAOImpl;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.util.VnPayConfigUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebServlet(urlPatterns = {"/vnpay-ipn"})
public class RealVnPayIPNServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        JsonObject jsonRes = new JsonObject();

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

            if (signValue.equalsIgnoreCase(vnp_SecureHash)) {
                String orderCode = request.getParameter("vnp_TxnRef");
                String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");

                OrderDAOImpl orderDAO = new OrderDAOImpl();
                OrderModel order = orderDAO.findByOrderCode(orderCode);

                if (order != null) {
                    if ("00".equals(vnp_ResponseCode)) {
                        // 1. Kiểm tra tính Idempotent: Chỉ cập nhật nếu đơn chưa PAID để tránh xử lý trùng lặp khi VNPay retry
                        if (!"PAID".equalsIgnoreCase(order.getPaymentStatus())) {
                            orderDAO.update("UPDATE orders SET payment_status = 'PAID', status = 'PACKING' WHERE order_code = ?", orderCode);
                        }

                        jsonRes.addProperty("RspCode", "00");
                        jsonRes.addProperty("Message", "Confirm Success");
                    } else {
                        // Giao dịch thất bại: Hủy đơn và hoàn trả tồn kho an toàn (do lúc checkout đã trừ kho)
                        if (!"CANCELLED".equalsIgnoreCase(order.getStatus())) {
                            orderDAO.updateStatusAndRestoreStock(order.getId(), "CANCELLED");
                            orderDAO.update("UPDATE orders SET payment_status = 'UNPAID' WHERE id = ?", order.getId());
                        }
                        jsonRes.addProperty("RspCode", "00");
                        jsonRes.addProperty("Message", "Confirm Success");
                    }
                } else {
                    jsonRes.addProperty("RspCode", "01");
                    jsonRes.addProperty("Message", "Order not Found");
                }
            } else {
                jsonRes.addProperty("RspCode", "97");
                jsonRes.addProperty("Message", "Invalid Checksum");
            }
        } catch (Exception e) {
            jsonRes.addProperty("RspCode", "99");
            jsonRes.addProperty("Message", "Unknown error");
        }

        response.getWriter().print(jsonRes.toString());
    }
}