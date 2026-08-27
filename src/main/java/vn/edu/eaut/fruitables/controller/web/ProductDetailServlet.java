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

@WebServlet(urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {

    private IProductService productService;

    public ProductDetailServlet() {
        this.productService = new ProductServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                Long productId = Long.parseLong(idParam);
                ProductModel product = productService.findById(productId);

                if (product != null) {
                    request.setAttribute("product", product);
                    // (Sẽ tích hợp Query lấy List Reviews ở mục ben duoi')
                    request.getRequestDispatcher("/WEB-INF/views/web/product-detail.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        // Nếu không tìm thấy sản phẩm, quay về trang shop
        response.sendRedirect(request.getContextPath() + "/shop");
    }
}