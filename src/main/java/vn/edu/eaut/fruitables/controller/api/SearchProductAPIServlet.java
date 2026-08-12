package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.service.IProductService;
import vn.edu.eaut.fruitables.service.impl.ProductServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(urlPatterns = {"/api/search-products"})
public class SearchProductAPIServlet extends HttpServlet {

    private IProductService productService;

    public SearchProductAPIServlet() {
        this.productService = new ProductServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Cấu hình Header trả về định dạng JSON và hỗ trợ tiếng Việt
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                // Gọi DB tìm sản phẩm
                List<ProductModel> products = productService.searchByName(keyword.trim());

                // Giới hạn chỉ trả về tối đa 5 kết quả cho Autocomplete để UI không bị tràn
                if (products.size() > 5) {
                    products = products.subList(0, 5);
                }

                // Chuyển List Object sang JSON chuỗi
                String jsonResult = gson.toJson(products);
                out.print(jsonResult);
            } else {
                // Nếu keyword rỗng, trả về mảng rỗng
                out.print("[]");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Lỗi server khi tìm kiếm\"}");
            e.printStackTrace();
        } finally {
            out.flush();
            out.close();
        }
    }
}