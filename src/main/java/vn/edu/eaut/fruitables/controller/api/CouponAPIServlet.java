package vn.edu.eaut.fruitables.controller.api;

import vn.edu.eaut.fruitables.dao.impl.CouponDAOImpl;
import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.dto.CouponEvaluationDTO;
import vn.edu.eaut.fruitables.model.entity.CouponModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

/**
 * API Servlet cung cấp danh sách voucher đã được evaluate theo giỏ hàng.
 *
 * GET /api/coupon?action=list
 *   → Trả về JSON array CouponEvaluationDTO, phân loại applicable/chưa đủ điều kiện.
 *   → Cần đăng nhập. Nếu chưa đăng nhập trả về 401.
 */
@WebServlet(urlPatterns = {"/api/coupon"})
public class CouponAPIServlet extends HttpServlet {

    private static final String DATE_FORMAT = "dd/MM/yyyy";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");

        if (!"list".equals(action)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"action không hợp lệ\"}");
            return;
        }

        HttpSession session = request.getSession(false);

        // 1. Yêu cầu đăng nhập
        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\":\"Cần đăng nhập\",\"requireLogin\":true}");
            return;
        }

        UserModel user = (UserModel) session.getAttribute("USERMODEL");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\":\"Cần đăng nhập\",\"requireLogin\":true}");
            return;
        }

        // 2. Lấy giỏ hàng từ Session
        @SuppressWarnings("unchecked")
        Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");

        // Tính tổng tiền giỏ hàng (chưa thuế)
        double cartTotal = 0;
        if (cart != null) {
            for (CartItemDTO item : cart.values()) {
                cartTotal += item.getSubTotal();
            }
        }

        // 3. Lấy tất cả coupon từ DB
        CouponDAOImpl couponDAO = new CouponDAOImpl();
        List<CouponModel> allCoupons = couponDAO.findAll();

        if (allCoupons == null) {
            out.print("[]");
            return;
        }

        Timestamp now = new Timestamp(System.currentTimeMillis());
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);

        String userLoginType = user.getLoginType() != null ? user.getLoginType() : "LOCAL";
        String userEmail = user.getEmail() != null ? user.getEmail().toLowerCase() : "";

        // 4. Evaluate từng voucher
        List<CouponEvaluationDTO> evaluated = new ArrayList<>();
        for (CouponModel coupon : allCoupons) {

            // Bỏ qua voucher không active
            if (coupon.getStatus() == null || !coupon.getStatus()) continue;

            CouponEvaluationDTO dto = new CouponEvaluationDTO(coupon);

            // Kiểm tra ngày bắt đầu
            if (coupon.getStartDate() != null && now.before(coupon.getStartDate())) {
                dto.setApplicable(false);
                dto.setReasonNotQualified("Chưa đến thời gian áp dụng (Bắt đầu từ "
                        + sdf.format(coupon.getStartDate()) + ")");
                evaluated.add(dto);
                continue;
            }

            // Kiểm tra hết hạn
            if (coupon.getEndDate() != null && now.after(coupon.getEndDate())) {
                dto.setApplicable(false);
                dto.setReasonNotQualified("Đã hết hạn sử dụng ("
                        + sdf.format(coupon.getEndDate()) + ")");
                evaluated.add(dto);
                continue;
            }

            // Kiểm tra giới hạn số lượt
            int usageLimit = coupon.getUsageLimit() != null ? coupon.getUsageLimit() : 0;
            int usedCount = coupon.getUsedCount() != null ? coupon.getUsedCount() : 0;
            if (usageLimit > 0 && usedCount >= usageLimit) {
                dto.setApplicable(false);
                dto.setReasonNotQualified("Đã hết lượt sử dụng (" + usedCount + "/" + usageLimit + ")");
                evaluated.add(dto);
                continue;
            }

            // Kiểm tra đối tượng áp dụng (targetAudience)
            String targetAudience = coupon.getTargetAudience();
            if ("GMAIL".equalsIgnoreCase(targetAudience) || "GOOGLE_ONLY".equalsIgnoreCase(targetAudience)) {
                boolean isGoogleUser = "GOOGLE".equalsIgnoreCase(userLoginType)
                        || userEmail.endsWith("@gmail.com");
                if (!isGoogleUser) {
                    dto.setApplicable(false);
                    dto.setReasonNotQualified("Chỉ dành cho tài khoản Google / Gmail");
                    evaluated.add(dto);
                    continue;
                }
            }

            // Giỏ hàng trống → không thể áp dụng bất kỳ voucher nào
            if (cart == null || cart.isEmpty()) {
                dto.setApplicable(false);
                dto.setReasonNotQualified("Giỏ hàng đang trống");
                evaluated.add(dto);
                continue;
            }

            // Kiểm tra sản phẩm cụ thể (productId)
            Long specificProductId = coupon.getProductId();
            if (specificProductId != null && !cart.containsKey(specificProductId)) {
                String productName = coupon.getProductName() != null
                        ? coupon.getProductName() : "sản phẩm chỉ định";
                dto.setApplicable(false);
                dto.setReasonNotQualified("Chỉ áp dụng khi có \"" + productName + "\" trong giỏ");
                evaluated.add(dto);
                continue;
            }

            // Kiểm tra giá trị đơn hàng tối thiểu
            double minOrderValue = coupon.getMinOrderValue() != null ? coupon.getMinOrderValue() : 0;
            if (cartTotal < minOrderValue) {
                double shortfall = minOrderValue - cartTotal;
                dto.setApplicable(false);
                dto.setShortfallAmount(shortfall);
                dto.setReasonNotQualified("Cần mua thêm "
                        + formatMoney(shortfall) + " ₫ để dùng mã này");
                evaluated.add(dto);
                continue;
            }

            // ─── VOUCHER ĐỦ ĐIỀU KIỆN → Tính discount dự kiến ────────────
            dto.setApplicable(true);
            double discountValue = coupon.getDiscountValue() != null ? coupon.getDiscountValue() : 0;
            String discountType = coupon.getDiscountType();
            double calcDiscount = 0;

            if ("FREESHIP".equalsIgnoreCase(discountType)) {
                calcDiscount = discountValue; // Giảm tối đa X phí ship
            } else if (specificProductId != null) {
                CartItemDTO targetItem = cart.get(specificProductId);
                double itemTotal = targetItem.getSubTotal();
                if ("PERCENT".equalsIgnoreCase(discountType)) {
                    calcDiscount = (itemTotal * discountValue) / 100.0;
                } else {
                    calcDiscount = Math.min(discountValue, itemTotal);
                }
            } else {
                if ("PERCENT".equalsIgnoreCase(discountType)) {
                    calcDiscount = (cartTotal * discountValue) / 100.0;
                } else {
                    calcDiscount = discountValue;
                }
            }
            calcDiscount = Math.min(calcDiscount, cartTotal);
            dto.setCalculatedDiscount(calcDiscount);
            evaluated.add(dto);
        }

        // 5. Sắp xếp: applicable=true lên đầu, trong nhóm sắp xếp theo calculatedDiscount giảm dần
        evaluated.sort(Comparator
                .comparingInt((CouponEvaluationDTO d) -> d.isApplicable() ? 0 : 1)
                .thenComparingDouble(d -> -d.getCalculatedDiscount())
        );

        // 6. Serialize sang JSON (thủ công, không dùng thư viện ngoài)
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < evaluated.size(); i++) {
            if (i > 0) json.append(",");
            json.append(toJson(evaluated.get(i), sdf));
        }
        json.append("]");

        out.print(json.toString());
    }

    // ─── Helper: serialize CouponEvaluationDTO → JSON string ────────────────
    private String toJson(CouponEvaluationDTO d, SimpleDateFormat sdf) {
        return "{" +
                "\"id\":" + d.getId() + "," +
                "\"code\":" + jsonString(d.getCode()) + "," +
                "\"discountType\":" + jsonString(d.getDiscountType()) + "," +
                "\"discountValue\":" + nullOrDouble(d.getDiscountValue()) + "," +
                "\"minOrderValue\":" + nullOrDouble(d.getMinOrderValue()) + "," +
                "\"productId\":" + (d.getProductId() != null ? d.getProductId() : "null") + "," +
                "\"productName\":" + jsonString(d.getProductName()) + "," +
                "\"targetAudience\":" + jsonString(d.getTargetAudience()) + "," +
                "\"endDate\":" + (d.getEndDate() != null ? jsonString(sdf.format(d.getEndDate())) : "null") + "," +
                "\"usageLimit\":" + (d.getUsageLimit() != null ? d.getUsageLimit() : 0) + "," +
                "\"usedCount\":" + (d.getUsedCount() != null ? d.getUsedCount() : 0) + "," +
                "\"applicable\":" + d.isApplicable() + "," +
                "\"calculatedDiscount\":" + d.getCalculatedDiscount() + "," +
                "\"shortfallAmount\":" + d.getShortfallAmount() + "," +
                "\"reasonNotQualified\":" + jsonString(d.getReasonNotQualified()) +
                "}";
    }

    private String jsonString(String s) {
        if (s == null) return "null";
        return "\"" + s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r") + "\"";
    }

    private String nullOrDouble(Double d) {
        return d != null ? String.valueOf(d) : "null";
    }

    private String formatMoney(double amount) {
        long rounded = Math.round(amount);
        // Format với dấu phẩy ngăn cách hàng nghìn
        String s = Long.toString(rounded);
        StringBuilder sb = new StringBuilder();
        int startIndex = s.length() % 3;
        if (startIndex > 0) sb.append(s, 0, startIndex);
        for (int i = startIndex; i < s.length(); i += 3) {
            if (sb.length() > 0) sb.append(".");
            sb.append(s, i, i + 3);
        }
        return sb.toString();
    }
}
