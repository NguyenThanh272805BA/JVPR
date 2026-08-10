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

        // Nhận tham số tìm kiếm hoặc lọc từ URL (Nếu có)
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");

        List<ProductModel> products;

        // 1. Ưu tiên lấy từ Database (có xử lý lọc)
        if (keyword != null && !keyword.trim().isEmpty()) {
            products = productService.searchByName(keyword);
        } else if (category != null && !category.trim().isEmpty()) {
            try {
                Integer categoryId = Integer.parseInt(category);
                products = productService.findByCategory(categoryId);
            } catch (NumberFormatException e) {
                products = productService.findAll();
            }
        } else {
            products = productService.findAll();
        }

        // 2. TÍCH HỢP MOCK DATA: Nếu DB trống, tạo danh sách hiển thị tạm thời
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

        // Đẩy danh sách sản phẩm và tham số tìm kiếm lại view để giữ giá trị trên ô input
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/WEB-INF/views/web/shop.jsp").forward(request, response);
    }
}