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

@WebServlet(urlPatterns = {"/shop"})
public class ShopServlet extends HttpServlet {

    private IProductService productService;

    public ShopServlet() {
        this.productService = new ProductServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Nhận các tham số tìm kiếm, lọc và sắp xếp từ URL
        String keyword = request.getParameter("keyword");
        String categoryParam = request.getParameter("category");
        String sortOption = request.getParameter("sort");

        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryParam);
            } catch (NumberFormatException e) {
                categoryId = null;
            }
        }

        // 2. Gọi DB thông qua bộ lọc động (Lọc đa chiều)
        List<ProductModel> products = productService.filterProducts(keyword, categoryId, sortOption);

        // 3. TÍCH HỢP MOCK DATA: Nếu DB trống, tạo danh sách hiển thị tạm thời
        if (products == null || products.isEmpty()) {
            products = new ArrayList<>();

            // (Sản phẩm 1)
            ProductModel p1 = new ProductModel();
            p1.setId(1L); p1.setName("Táo Gala Hữu Cơ"); p1.setCategoryName("Hoa quả");
            p1.setPrice(115000.0); p1.setImageUrl("https://images.unsplash.com/photo-1560806887-1e4cd0b6fac6?w=500&auto=format&fit=crop");
            products.add(p1);

            // (Sản phẩm 2)
            ProductModel p2 = new ProductModel();
            p2.setId(2L); p2.setName("Rau Bina Hữu Cơ"); p2.setCategoryName("Rau xanh");
            p2.setPrice(25000.0); p2.setImageUrl("https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500&auto=format&fit=crop");
            products.add(p2);

            // (Sản phẩm 3)
            ProductModel p3 = new ProductModel();
            p3.setId(3L); p3.setName("Chanh Vàng Sạch"); p3.setCategoryName("Hoa quả");
            p3.setPrice(18000.0); p3.setImageUrl("https://images.unsplash.com/photo-1590502593747-422e15779c16?w=500&auto=format&fit=crop");
            products.add(p3);

            // (Sản phẩm 4)
            ProductModel p4 = new ProductModel();
            p4.setId(4L); p4.setName("Cà chua Cherry"); p4.setCategoryName("Rau củ");
            p4.setPrice(105000.0); p4.setImageUrl("https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500&auto=format&fit=crop");
            products.add(p4);
        }

        // 4. Đẩy dữ liệu ra view để hiển thị và giữ lại trạng thái bộ lọc trên UI
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedSort", sortOption);

        request.getRequestDispatcher("/WEB-INF/views/web/shop.jsp").forward(request, response);
    }
}