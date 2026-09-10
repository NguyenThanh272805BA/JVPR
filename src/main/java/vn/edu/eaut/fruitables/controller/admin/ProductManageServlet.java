package vn.edu.eaut.fruitables.controller.admin;

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
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/products", "/admin/products/delete", "/admin/products/toggle-status"})
public class ProductManageServlet extends HttpServlet {

    private IProductService productService;
    private ICategoryService categoryService;

    public ProductManageServlet() {
        this.productService = new ProductServiceImpl();
        this.categoryService = new CategoryServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        // Xử lý Xóa sản phẩm
        if ("/admin/products/delete".equals(path)) {
            handleDelete(request, response);
            return;
        }

        // Xử lý Bật/Tắt nhanh trạng thái kinh doanh
        if ("/admin/products/toggle-status".equals(path)) {
            handleToggleStatus(request, response);
            return;
        }

        // 1. Nhận các tham số tìm kiếm và bộ lọc từ URL
        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("categoryId");
        String status = request.getParameter("status");             // "ALL", "ACTIVE", "INACTIVE"
        String stockStatus = request.getParameter("stockStatus");   // "ALL", "IN_STOCK", "LOW_STOCK", "OUT_OF_STOCK"
        String storageType = request.getParameter("storageType");   // "ALL", "NORMAL", "COLD_CHAIN", "FRAGILE_GIFT", "FREE_SHIPPING"
        String sortOption = request.getParameter("sort");           // "newest", "oldest", "price_asc", "price_desc", "stock_asc", "stock_desc", "name_asc"
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String priceRange = request.getParameter("priceRange");

        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty() && !"ALL".equalsIgnoreCase(categoryIdStr)) {
            try {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        Double minPrice = null;
        Double maxPrice = null;

        if (priceRange != null && !priceRange.trim().isEmpty()) {
            if ("under50k".equalsIgnoreCase(priceRange)) {
                maxPrice = 50000.0;
            } else if ("50k-200k".equalsIgnoreCase(priceRange)) {
                minPrice = 50000.0;
                maxPrice = 200000.0;
            } else if ("200k-500k".equalsIgnoreCase(priceRange)) {
                minPrice = 200000.0;
                maxPrice = 500000.0;
            } else if ("over500k".equalsIgnoreCase(priceRange)) {
                minPrice = 500000.0;
            }
        }

        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            try {
                minPrice = Double.parseDouble(minPriceStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        if (status == null || status.trim().isEmpty()) status = "ALL";
        if (stockStatus == null || stockStatus.trim().isEmpty()) stockStatus = "ALL";
        if (storageType == null || storageType.trim().isEmpty()) storageType = "ALL";
        if (sortOption == null || sortOption.trim().isEmpty()) sortOption = "newest";

        // 2. Truy vấn dữ liệu sản phẩm theo các tiêu chí lọc
        List<ProductModel> products = productService.adminSearchAndFilter(
                keyword, categoryId, status, stockStatus, storageType, sortOption, minPrice, maxPrice
        );

        // 3. Lấy danh sách danh mục phục vụ Dropdown lọc
        List<CategoryModel> categories = categoryService.findAll();

        // 4. Lấy số liệu thống kê tổng thể cho các thẻ số liệu (Metric Cards)
        Map<String, Object> stats = productService.getProductStats();

        // 5. Gửi dữ liệu và trạng thái bộ lọc sang JSP
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("stats", stats);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedStockStatus", stockStatus);
        request.setAttribute("selectedStorageType", storageType);
        request.setAttribute("selectedSort", sortOption);
        request.setAttribute("selectedPriceRange", priceRange);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);

        request.getRequestDispatcher("/WEB-INF/views/admin/product-list.jsp").forward(request, response);
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                Long id = Long.parseLong(idStr.trim());
                boolean success = productService.deleteProduct(id);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/products?message=DeleteSuccess");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/products?message=Error");
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                Long id = Long.parseLong(idStr.trim());
                productService.toggleProductStatus(id);
                response.sendRedirect(request.getContextPath() + "/admin/products?message=UpdateSuccess");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/products?message=Error");
    }
}