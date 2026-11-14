package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.entity.CouponModel;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.service.ICouponService;
import vn.edu.eaut.fruitables.service.IProductService;
import vn.edu.eaut.fruitables.service.impl.CouponServiceImpl;
import vn.edu.eaut.fruitables.service.impl.ProductServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/promotions"})
public class PromotionServlet extends HttpServlet {

    private ICouponService couponService;
    private IProductService productService;

    public PromotionServlet() {
        this.couponService = new CouponServiceImpl();
        this.productService = new ProductServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy danh sách toàn bộ voucher công khai trong hệ thống (loại bỏ các mã cá nhân từ Lucky Spin / Claim)
        List<CouponModel> allCoupons = couponService.findAll();
        java.util.Set<String> personalCodes = new java.util.HashSet<>();
        try (java.sql.Connection conn = vn.edu.eaut.fruitables.util.DBConnectionUtil.getConnection();
             java.sql.Statement st = conn.createStatement()) {
            try (java.sql.ResultSet rs = st.executeQuery("SELECT reward_code FROM lucky_spin_history WHERE reward_code IS NOT NULL")) {
                while (rs.next()) {
                    String rc = rs.getString("reward_code");
                    if (rc != null) personalCodes.add(rc.trim().toUpperCase());
                }
            } catch (Exception ignored) {}
            try (java.sql.ResultSet rs = st.executeQuery("SELECT compensation_voucher FROM order_claims WHERE compensation_voucher IS NOT NULL")) {
                while (rs.next()) {
                    String cv = rs.getString("compensation_voucher");
                    if (cv != null) personalCodes.add(cv.trim().toUpperCase());
                }
            } catch (Exception ignored) {}
        } catch (Exception ignored) {}

        List<CouponModel> coupons = new java.util.ArrayList<>();
        if (allCoupons != null) {
            for (CouponModel c : allCoupons) {
                String codeUp = c.getCode() != null ? c.getCode().trim().toUpperCase() : "";
                if (!personalCodes.contains(codeUp) && !codeUp.startsWith("CARE-")) {
                    coupons.add(c);
                }
            }
        }

        // 2. Lấy danh sách sản phẩm đang có giá Flash Sale (Giới hạn hiển thị 8 sản phẩm)
        List<ProductModel> flashSaleProducts = productService.findFlashSaleProducts(8);

        // 3. Đẩy dữ liệu ra view
        request.setAttribute("coupons", coupons);
        request.setAttribute("flashSaleProducts", flashSaleProducts);

        request.getRequestDispatcher("/WEB-INF/views/web/real-time-promotions.jsp").forward(request, response);
    }
}