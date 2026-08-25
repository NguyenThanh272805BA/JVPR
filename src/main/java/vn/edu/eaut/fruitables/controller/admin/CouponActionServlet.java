package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.service.ICouponService;
import vn.edu.eaut.fruitables.service.impl.CouponServiceImpl;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/coupons/toggle-status", "/admin/coupons/hard-delete"})
public class CouponActionServlet extends HttpServlet {

    private ICouponService couponService = new CouponServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getServletPath();
        String idParam = request.getParameter("id");

        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);

                if ("/admin/coupons/toggle-status".equals(path)) {
                    String action = request.getParameter("action");
                    if ("hide".equals(action)) {
                        couponService.softDelete(id); // Khóa mềm
                    } else if ("restore".equals(action)) {
                        couponService.restore(id); // Khôi phục
                    }
                } else if ("/admin/coupons/hard-delete".equals(path)) {
                    couponService.hardDelete(id); // Xóa cứng
                }

                response.sendRedirect(request.getContextPath() + "/admin/coupons?message=Success");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/coupons?message=Error");
            }
        }
    }
}