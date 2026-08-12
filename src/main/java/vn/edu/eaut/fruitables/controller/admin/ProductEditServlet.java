package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.service.IProductService;
import vn.edu.eaut.fruitables.service.impl.ProductServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/products/edit"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class ProductEditServlet extends HttpServlet {

    private IProductService productService;
    private static final String UPLOAD_DIR = "assets/uploads";

    public ProductEditServlet() {
        this.productService = new ProductServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            Long id = Long.parseLong(idStr);
            ProductModel product = productService.findById(id);
            if (product != null) {
                request.setAttribute("product", product);
                // Tái sử dụng lại form của tính năng Thêm
                request.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            String name = request.getParameter("name");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String description = request.getParameter("description");
            boolean status = request.getParameter("status") != null;

            Part filePart = request.getPart("imageFile");
            String fileName = extractFileName(filePart);
            String dbImageUrl = "";

            // Chỉ xử lý lưu file nếu người dùng có chọn file ảnh mới
            if (fileName != null && !fileName.isEmpty()) {
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
                File fileSaveDir = new File(uploadFilePath);
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdirs();
                }
                filePart.write(uploadFilePath + File.separator + fileName);
                dbImageUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + fileName;
            }

            ProductModel product = new ProductModel();
            product.setId(id);
            product.setName(name);
            product.setCategoryId(categoryId);
            product.setPrice(price);
            product.setStock(stock);
            product.setDescription(description);
            product.setStatus(status);
            product.setImageUrl(dbImageUrl);

            productService.updateProduct(product);
            response.sendRedirect(request.getContextPath() + "/admin/products?message=UpdateSuccess");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products?message=Error");
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}