package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.model.entity.ProductModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/products"})
public class ProductManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // MOCK DATA: Tạo dữ liệu giả để test giao diện trước khi móc nối với DAO
        List<ProductModel> products = new ArrayList<>();

        ProductModel p1 = new ProductModel();
        p1.setId(1L); p1.setName("Táo Gala Hữu Cơ"); p1.setCategoryName("Hoa quả");
        p1.setPrice(115000.0); p1.setStock(150); p1.setImageUrl("https://images.unsplash.com/photo-1560806887-1e4cd0b6fac6?w=500&auto=format&fit=crop");

        ProductModel p2 = new ProductModel();
        p2.setId(2L); p2.setName("Rau Bina Hữu Cơ"); p2.setCategoryName("Rau xanh");
        p2.setPrice(25000.0); p2.setStock(15); p2.setImageUrl("https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500&auto=format&fit=crop");

        ProductModel p3 = new ProductModel();
        p3.setId(3L); p3.setName("Chanh Vàng Sạch"); p3.setCategoryName("Hoa quả");
        p3.setPrice(18000.0); p3.setStock(0); p3.setImageUrl("https://images.unsplash.com/photo-1590502593747-422e15779c16?w=500&auto=format&fit=crop");

        products.add(p1);
        products.add(p2);
        products.add(p3);

        // Gửi danh sách này sang JSP
        request.setAttribute("products", products);

        request.getRequestDispatcher("/WEB-INF/views/admin/product-list.jsp").forward(request, response);
    }
}