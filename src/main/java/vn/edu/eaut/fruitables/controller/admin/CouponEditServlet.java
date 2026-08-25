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

@WebServlet(urlPatterns = {"/admin/coupons/edit"})
public class CouponEditServlet extends HttpServlet {

    private final ICouponService couponService = new CouponServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            CouponModel coupon = couponService.findById(id);

            if (coupon == null) {
                response.sendRedirect(request.getContextPath() + "/admin/coupons?message=NotFound");
                return;
            }

            request.setAttribute("coupon", coupon);
            // Forward dữ liệu sang giao diện JSP
            request.getRequestDispatcher("/WEB-INF/views/admin/coupon-form.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/coupons?message=Error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            CouponModel coupon = new CouponModel();
            coupon.setId(Integer.parseInt(request.getParameter("id")));
            coupon.setCode(request.getParameter("code").toUpperCase().trim());
            coupon.setDiscountType(request.getParameter("discountType"));
            coupon.setDiscountValue(Double.parseDouble(request.getParameter("discountValue")));
            coupon.setMinOrderValue(Double.parseDouble(request.getParameter("minOrderValue")));

            // Xử lý format thời gian từ HTML datetime-local sang Timestamp của SQL
            String startDateStr = request.getParameter("startDate").replace("T", " ");
            String endDateStr = request.getParameter("endDate").replace("T", " ");
            // Thêm giây nếu HTML5 không gửi kèm giây
            if (startDateStr.length() == 16) startDateStr += ":00";
            if (endDateStr.length() == 16) endDateStr += ":00";

            coupon.setStartDate(Timestamp.valueOf(startDateStr));
            coupon.setEndDate(Timestamp.valueOf(endDateStr));

            coupon.setUsageLimit(Integer.parseInt(request.getParameter("usageLimit")));
            coupon.setStatus(request.getParameter("status") != null); // Checkbox

            couponService.update(coupon);
            response.sendRedirect(request.getContextPath() + "/admin/coupons?message=Success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/coupons?message=Error");
        }
    }
}