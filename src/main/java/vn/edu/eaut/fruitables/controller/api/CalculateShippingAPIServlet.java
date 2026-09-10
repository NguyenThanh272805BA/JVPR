package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.dao.IUserAddressDAO;
import vn.edu.eaut.fruitables.dao.impl.UserAddressDAOImpl;
import vn.edu.eaut.fruitables.model.dto.CartItemDTO;
import vn.edu.eaut.fruitables.model.entity.UserAddressModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.util.DistanceAndShippingUtil;
import vn.edu.eaut.fruitables.util.DistanceAndShippingUtil.ShippingCalculationResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet(urlPatterns = {"/api/calculate-shipping"})
public class CalculateShippingAPIServlet extends HttpServlet {

    private IUserAddressDAO userAddressDAO = new UserAddressDAOImpl();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject json = new JsonObject();

        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");

        @SuppressWarnings("unchecked")
        Map<Long, CartItemDTO> cart = (Map<Long, CartItemDTO>) session.getAttribute("CART");

        if (cart == null || cart.isEmpty()) {
            json.addProperty("success", false);
            json.addProperty("message", "Giỏ hàng đang trống");
            out.print(gson.toJson(json));
            return;
        }

        String addressIdStr = request.getParameter("addressId");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String street = request.getParameter("street");
        Double lat = null;
        Double lng = null;

        // Nếu truyền addressId của địa chỉ đã lưu
        if (addressIdStr != null && !addressIdStr.trim().isEmpty() && user != null) {
            try {
                Long addrId = Long.parseLong(addressIdStr.trim());
                UserAddressModel savedAddr = userAddressDAO.findById(addrId);
                if (savedAddr != null && savedAddr.getUserId().equals(user.getId())) {
                    province = savedAddr.getProvince();
                    district = savedAddr.getDistrict();
                    ward = savedAddr.getWard();
                    street = savedAddr.getStreetAddress();
                    lat = savedAddr.getLatitude();
                    lng = savedAddr.getLongitude();
                }
            } catch (Exception ignored) {}
        }

        // Nếu cả địa chỉ lẫn quận huyện đều chưa có, mặc định tính khoảng cách nội thành gần (3km)
        double distanceKm = DistanceAndShippingUtil.estimateDistance(province, district, ward, street, lat, lng);

        // Phân tích giỏ hàng
        int totalWeightGram = 0;
        boolean hasColdChain = false;
        boolean hasFragileGift = false;
        boolean hasFreeShippingProduct = false;
        double cartTotal = 0;

        for (CartItemDTO item : cart.values()) {
            cartTotal += item.getSubTotal();
            int itemWeight = (item.getWeightGram() != null && item.getWeightGram() > 0) ? item.getWeightGram() : 500;
            totalWeightGram += itemWeight * item.getQuantity();

            if ("COLD_CHAIN".equalsIgnoreCase(item.getStorageType())) {
                hasColdChain = true;
            }
            if ("FRAGILE_GIFT".equalsIgnoreCase(item.getStorageType())) {
                hasFragileGift = true;
            }
            if (Boolean.TRUE.equals(item.getIsFreeShipping())) {
                hasFreeShippingProduct = true;
            }
        }

        // Kiểm tra Voucher trong Session
        String appliedCouponType = (String) session.getAttribute("APPLIED_COUPON_TYPE");
        Double discountAmount = (Double) session.getAttribute("DISCOUNT_AMOUNT");
        double couponDiscountVal = (discountAmount != null) ? discountAmount : 0.0;

        ShippingCalculationResult result = DistanceAndShippingUtil.calculateShipping(
                distanceKm,
                totalWeightGram,
                hasColdChain,
                hasFragileGift,
                hasFreeShippingProduct,
                cartTotal,
                appliedCouponType,
                couponDiscountVal
        );

        // Lưu vào Session để khi CheckoutServlet submit form có thể đọc
        session.setAttribute("SHIPPING_DISTANCE_KM", result.distanceKm);
        session.setAttribute("SHIPPING_RAW_FEE", result.rawShippingFee);
        session.setAttribute("SHIPPING_DISCOUNT", result.shippingDiscount);
        session.setAttribute("SHIPPING_FINAL_FEE", result.finalShippingFee);

        json.addProperty("success", true);
        json.addProperty("distanceKm", result.distanceKm);
        json.addProperty("baseShippingFee", result.baseShippingFee);
        json.addProperty("weightSurcharge", result.weightSurcharge);
        json.addProperty("storageSurcharge", result.storageSurcharge);
        json.addProperty("rawShippingFee", result.rawShippingFee);
        json.addProperty("shippingDiscount", result.shippingDiscount);
        json.addProperty("finalShippingFee", result.finalShippingFee);
        json.addProperty("totalWeightGram", result.totalWeightGram);
        json.addProperty("isFreeShipping", result.isFreeShipping);
        json.addProperty("note", result.note);

        out.print(gson.toJson(json));
    }
}
