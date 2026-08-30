package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.dao.impl.ReviewDAOImpl;
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
    private ReviewDAOImpl reviewDAO; // Khai báo thêm DAO xử lý Review

    public ProductDetailServlet() {
        this.productService = new ProductServiceImpl();
        this.reviewDAO = new ReviewDAOImpl(); // Khởi tạo
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                Long productId = Long.parseLong(idParam);

                // 1. Lấy thông tin chi tiết của sản phẩm
                ProductModel product = productService.findById(productId);

                if (product != null) {
                    // 2. Lấy danh sách đánh giá (comments + rating) của sản phẩm này
                    request.setAttribute("product", product);
                    request.setAttribute("reviews", reviewDAO.findByProductId(productId));

                    // 3. Đẩy dữ liệu sang trang JSP
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