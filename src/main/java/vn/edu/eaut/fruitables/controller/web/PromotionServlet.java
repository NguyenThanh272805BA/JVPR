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
        // 1. Lấy danh sách toàn bộ voucher đang có trong hệ thống
        List<CouponModel> coupons = couponService.findAll();

        // 2. Lấy danh sách sản phẩm đang có giá Flash Sale (Giới hạn hiển thị 8 sản phẩm)
        List<ProductModel> flashSaleProducts = productService.findFlashSaleProducts(8);

        // 3. Đẩy dữ liệu ra view
        request.setAttribute("coupons", coupons);
        request.setAttribute("flashSaleProducts", flashSaleProducts);

        request.getRequestDispatcher("/WEB-INF/views/web/real-time-promotions.jsp").forward(request, response);
    }
}