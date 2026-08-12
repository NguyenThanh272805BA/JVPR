package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.model.entity.CouponModel;
import vn.edu.eaut.fruitables.service.ICouponService;
import vn.edu.eaut.fruitables.service.impl.CouponServiceImpl;

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

    public CouponManageServlet() {
        this.couponService = new CouponServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kéo toàn bộ danh sách mã giảm giá từ DB
        List<CouponModel> coupons = couponService.findAll();
        request.setAttribute("coupons", coupons);

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

            // Parse datetime-local string (YYYY-MM-DDTHH:MM) sang SQL Timestamp
            Timestamp startDate = Timestamp.valueOf(startDateStr.replace("T", " ") + ":00");
            Timestamp endDate = Timestamp.valueOf(endDateStr.replace("T", " ") + ":00");

            // Đóng gói Model
            CouponModel coupon = new CouponModel();
            coupon.setCode(code.toUpperCase()); // Ép mã tự động viết hoa
            coupon.setDiscountType(discountType);
            coupon.setDiscountValue(discountValue);
            coupon.setMinOrderValue(minOrderValue);
            coupon.setStartDate(startDate);
            coupon.setEndDate(endDate);
            coupon.setUsageLimit(usageLimit);

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