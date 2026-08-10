package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.service.IProductService;
import vn.edu.eaut.fruitables.service.impl.ProductServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/home", "/trang-chu"})
public class HomeServlet extends HttpServlet {

    private IProductService productService;

    public HomeServlet() {
        this.productService = new ProductServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Ưu tiên lấy danh sách "Sản phẩm nổi bật" từ Database
        List<ProductModel> topProducts = productService.findTopProducts(4);

        // 2. TÍCH HỢP MOCK DATA: Nếu DB trống, dùng code cứng để giao diện trực quan
        if (topProducts == null || topProducts.isEmpty()) {
            topProducts = new ArrayList<>();

            ProductModel p1 = new ProductModel();
            p1.setId(1L); p1.setName("Táo Gala Hữu Cơ"); p1.setCategoryName("Hoa quả");
            p1.setPrice(115000.0); p1.setImageUrl("https://images.unsplash.com/photo-1560806887-1e4cd0b6fac6?w=500&auto=format&fit=crop");

            ProductModel p2 = new ProductModel();
            p2.setId(4L); p2.setName("Cà chua Cherry"); p2.setCategoryName("Rau củ");
            p2.setPrice(105000.0); p2.setImageUrl("https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500&auto=format&fit=crop");

            ProductModel p3 = new ProductModel();
            p3.setId(3L); p3.setName("Bơ Hass Úc"); p3.setCategoryName("Hoa quả");
            p3.setPrice(45000.0); p3.setImageUrl("https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=500&auto=format&fit=crop");

            ProductModel p4 = new ProductModel();
            p4.setId(5L); p4.setName("Cam Vàng Navel"); p4.setCategoryName("Hoa quả");
            p4.setPrice(85000.0); p4.setImageUrl("https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?w=500&auto=format&fit=crop");

            topProducts.add(p1);
            topProducts.add(p2);
            topProducts.add(p3);
            topProducts.add(p4);
        }

        // Đẩy dữ liệu ra View
        request.setAttribute("topProducts", topProducts);

        // Chuyển hướng tới file JSP
        request.getRequestDispatcher("/WEB-INF/views/web/home.jsp").forward(request, response);
    }
}