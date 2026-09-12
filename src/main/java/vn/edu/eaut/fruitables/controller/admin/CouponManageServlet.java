package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.model.entity.CouponModel;
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
import java.sql.Timestamp;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/coupons", "/admin/coupons/add"})
public class CouponManageServlet extends HttpServlet {

    private ICouponService couponService;
    private IProductService productService;

    public CouponManageServlet() {
        this.couponService = new CouponServiceImpl();
        this.productService = new ProductServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kéo toàn bộ danh sách mã giảm giá từ DB
        List<CouponModel> coupons = couponService.findAll();
        request.setAttribute("coupons", coupons);
        request.setAttribute("products", productService.findAll());

        request.getRequestDispatcher("/WEB-INF/views/admin/coupon-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            // Lấy thông số từ Form JSP gửi lên
            String code = request.getParameter("code");
            String discountType = request.getParameter("discountType");
            Double discountValue = Double.parseDouble(request.getParameter("discountValue"));
            Double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            Integer usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
            String productIdStr = request.getParameter("productId");

            // Parse datetime-local string (YYYY-MM-DDTHH:MM) sang SQL Timestamp an toàn
            String sDate = startDateStr.replace("T", " ").trim();
            String eDate = endDateStr.replace("T", " ").trim();
            if (sDate.length() == 16) sDate += ":00";
            if (eDate.length() == 16) eDate += ":00";
            Timestamp startDate = Timestamp.valueOf(sDate);
            Timestamp endDate = Timestamp.valueOf(eDate);

            // Đóng gói Model
            CouponModel coupon = new CouponModel();
            coupon.setCode(code.toUpperCase().trim()); // Ép mã tự động viết hoa
            coupon.setDiscountType(discountType);
            coupon.setDiscountValue(discountValue);
            coupon.setMinOrderValue(minOrderValue);
            coupon.setStartDate(startDate);
            coupon.setEndDate(endDate);
            coupon.setUsageLimit(usageLimit);

            if (productIdStr != null && !productIdStr.trim().isEmpty() && !productIdStr.equals("all")) {
                try {
                    coupon.setProductId(Long.parseLong(productIdStr.trim()));
                } catch (NumberFormatException ignored) {}
            }

            // Lưu Database
            couponService.save(coupon);

            // Xong việc thì Reset về trang danh sách
            response.sendRedirect(request.getContextPath() + "/admin/coupons");
        } catch (Exception e) {
            e.printStackTrace();
            // Báo lỗi (Thực tế nên truyền params error)
            response.sendRedirect(request.getContextPath() + "/admin/coupons");
        }
    }
}