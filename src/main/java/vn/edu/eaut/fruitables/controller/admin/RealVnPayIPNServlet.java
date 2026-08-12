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
                        // 1. Cập nhật trạng thái đơn hàng sang PAID
                        orderDAO.update("UPDATE orders SET payment_status = 'PAID', status = 'PACKING' WHERE order_code = ?", orderCode);

                        // 2. TỰ ĐỘNG TRỪ TỒN KHO SẢN PHẨM KHỔI KHO
                        ProductDAOImpl productDAO = new ProductDAOImpl();
                        productDAO.update(
                                "UPDATE products p JOIN order_details od ON p.id = od.product_id " +
                                        "SET p.stock = p.stock - od.quantity " +
                                        "WHERE od.order_id = ?", order.getId()
                        );

                        jsonRes.addProperty("RspCode", "00");
                        jsonRes.addProperty("Message", "Confirm Success");
                    } else {
                        orderDAO.update("UPDATE orders SET payment_status = 'UNPAID', status = 'CANCELLED' WHERE order_code = ?", orderCode);
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