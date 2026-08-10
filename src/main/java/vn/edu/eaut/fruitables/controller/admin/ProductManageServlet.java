package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.service.IProductService;
import vn.edu.eaut.fruitables.service.impl.ProductServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/products"})
public class ProductManageServlet extends HttpServlet {

    private IProductService productService;

    public ProductManageServlet() {
        this.productService = new ProductServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Lấy TOÀN BỘ sản phẩm từ Database
        List<ProductModel> products = productService.findAll();

        // Gửi danh sách này sang JSP
        request.setAttribute("products", products);

        request.getRequestDispatcher("/WEB-INF/views/admin/product-list.jsp").forward(request, response);
    }
}