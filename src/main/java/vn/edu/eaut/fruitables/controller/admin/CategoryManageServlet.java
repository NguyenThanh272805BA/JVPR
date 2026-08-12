package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.model.entity.CategoryModel;
import vn.edu.eaut.fruitables.service.ICategoryService;
import vn.edu.eaut.fruitables.service.impl.CategoryServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/categories", "/admin/categories/add"})
public class CategoryManageServlet extends HttpServlet {

    private ICategoryService categoryService;

    public CategoryManageServlet() {
        this.categoryService = new CategoryServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy toàn bộ danh mục từ Database đưa ra view
        List<CategoryModel> categories = categoryService.findAll();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/WEB-INF/views/admin/category-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String name = request.getParameter("name");
            Double taxRate = Double.parseDouble(request.getParameter("taxRate"));
            Boolean status = request.getParameter("status") != null; // Nếu checkbox được tick thì true, không tick thì false

            CategoryModel category = new CategoryModel();
            category.setName(name);
            category.setTaxRate(taxRate);
            category.setStatus(status);

            categoryService.save(category);

            // Redirect lại trang danh mục để tải lại dữ liệu mới nhất
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/categories?message=Error");
        }
    }
}