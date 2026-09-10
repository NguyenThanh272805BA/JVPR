package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.entity.CategoryModel;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.service.ICategoryService;
import vn.edu.eaut.fruitables.service.IProductService;
import vn.edu.eaut.fruitables.service.impl.CategoryServiceImpl;
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

    private final IProductService productService;
    private final ICategoryService categoryService;

    public ShopServlet() {
        this.productService = new ProductServiceImpl();
        this.categoryService = new CategoryServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Nhận các tham số tìm kiếm, lọc và sắp xếp từ URL
        String keyword = request.getParameter("keyword");
        String categoryParam = request.getParameter("category");
        String sortOption = request.getParameter("sort");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");

        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryParam);
            } catch (NumberFormatException e) {
                categoryId = null;
            }
        }

        Double minPrice = null;
        if (minPriceParam != null && !minPriceParam.trim().isEmpty()) {
            try {
                minPrice = Double.parseDouble(minPriceParam.trim());
            } catch (NumberFormatException e) {
                minPrice = null;
            }
        }

        Double maxPrice = null;
        if (maxPriceParam != null && !maxPriceParam.trim().isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceParam.trim());
            } catch (NumberFormatException e) {
                maxPrice = null;
            }
        }

        // 2. Gọi DB thông qua bộ lọc động (Lọc đa chiều theo từ khóa, danh mục, khoảng giá, sắp xếp)
        List<ProductModel> products = productService.filterProducts(keyword, categoryId, sortOption, minPrice, maxPrice);

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

        // Nhận pageSize (Số lượng sản phẩm hiển thị trên màn hình: 10, 12, 20, 24, 50)
        String pageSizeParam = request.getParameter("pageSize");
        int pageSize = 12; // Mặc định 12 sản phẩm (vừa vặn lưới 3 cột)
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                int ps = Integer.parseInt(pageSizeParam.trim());
                if (ps > 0 && ps <= 100) {
                    pageSize = ps;
                }
            } catch (NumberFormatException ignored) {}
        }

        // Nhận trang hiện tại (page)
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                int p = Integer.parseInt(pageParam.trim());
                if (p > 0) {
                    currentPage = p;
                }
            } catch (NumberFormatException ignored) {}
        }

        // 4. Xử lý phân trang trên danh sách sản phẩm sau lọc
        int totalProducts = products != null ? products.size() : 0;
        int totalPages = totalProducts > 0 ? (int) Math.ceil((double) totalProducts / pageSize) : 1;
        if (currentPage > totalPages) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalProducts);
        List<ProductModel> pageProducts = (products != null && fromIndex < totalProducts)
                ? new ArrayList<>(products.subList(fromIndex, toIndex))
                : new ArrayList<>();

        // 5. Đẩy dữ liệu ra view để hiển thị và giữ lại trạng thái bộ lọc & phân trang trên UI
        List<CategoryModel> categories = categoryService.findAll();
        request.setAttribute("categories", categories);

        request.setAttribute("products", pageProducts);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("startItem", totalProducts > 0 ? fromIndex + 1 : 0);
        request.setAttribute("endItem", toIndex);

        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedSort", sortOption);
        request.setAttribute("selectedMinPrice", minPrice);
        request.setAttribute("selectedMaxPrice", maxPrice);

        request.getRequestDispatcher("/WEB-INF/views/web/shop.jsp").forward(request, response);
    }
}