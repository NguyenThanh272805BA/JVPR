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

@WebServlet(urlPatterns = {"/admin/categories", "/admin/categories/add", "/admin/categories/edit"})
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

        String servletPath = request.getServletPath();
        String idStr = request.getParameter("id");

        try {
            String name = request.getParameter("name");
            Double taxRate = Double.parseDouble(request.getParameter("taxRate"));
            Boolean status = request.getParameter("status") != null;

            if ("/admin/categories/edit".equals(servletPath) || (idStr != null && !idStr.trim().isEmpty())) {
                // Chế độ sửa danh mục
                int id = Integer.parseInt(idStr);
                CategoryModel category = new CategoryModel();
                category.setId(id);
                category.setName(name);
                category.setTaxRate(taxRate);
                category.setStatus(status);

                boolean updated = categoryService.update(category);
                if (updated) {
                    response.sendRedirect(request.getContextPath() + "/admin/categories?message=UpdateSuccess");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/categories?message=Error");
                }
            } else {
                // Chế độ thêm danh mục mới
                CategoryModel category = new CategoryModel();
                category.setName(name);
                category.setTaxRate(taxRate);
                category.setStatus(status);

                categoryService.save(category);
                response.sendRedirect(request.getContextPath() + "/admin/categories?message=AddSuccess");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/categories?message=Error");
        }
    }
}