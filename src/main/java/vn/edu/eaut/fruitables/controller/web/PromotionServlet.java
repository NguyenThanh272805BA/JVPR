package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.entity.CouponModel;
import vn.edu.eaut.fruitables.service.ICouponService;
import vn.edu.eaut.fruitables.service.impl.CouponServiceImpl;

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

    public PromotionServlet() {
        this.couponService = new CouponServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy danh sách toàn bộ voucher đang có trong hệ thống từ database
        List<CouponModel> coupons = couponService.findAll();

        request.setAttribute("coupons", coupons);
        request.getRequestDispatcher("/WEB-INF/views/web/real-time-promotions.jsp").forward(request, response);
    }
}