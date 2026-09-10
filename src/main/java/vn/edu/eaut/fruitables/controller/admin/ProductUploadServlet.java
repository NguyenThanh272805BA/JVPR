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

@WebServlet(urlPatterns = {"/admin/products/add"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ProductUploadServlet extends HttpServlet {

    private IProductService productService;
    private static final String UPLOAD_DIR = "assets/uploads";

    public ProductUploadServlet() {
        this.productService = new ProductServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Trả về giao diện Form thêm sản phẩm
        request.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String name = request.getParameter("name");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String description = request.getParameter("description");
            boolean status = request.getParameter("status") != null;

            // Xử lý bắt tham số Thuế (Mới)
            double taxRate = 0.0;
            String taxRateStr = request.getParameter("taxRate");
            if (taxRateStr != null && !taxRateStr.trim().isEmpty()) {
                taxRate = Double.parseDouble(taxRateStr);
            }

            // Xử lý bắt tham số Mô tả chi tiết CKEditor (Mới)
            String detailedDescription = request.getParameter("detailedDescription");

            // Xử lý thông số vận chuyển & bảo quản
            int weightGram = 500;
            String weightStr = request.getParameter("weightGram");
            if (weightStr != null && !weightStr.trim().isEmpty()) {
                try { weightGram = Integer.parseInt(weightStr.trim()); } catch (Exception ignored) {}
            }

            String storageType = request.getParameter("storageType");
            if (storageType == null || storageType.trim().isEmpty()) {
                storageType = "NORMAL";
            }

            boolean isFreeShipping = request.getParameter("isFreeShipping") != null;

            // Xử lý File Upload
            Part filePart = request.getPart("imageFile");
            String fileName = extractFileName(filePart);
            String dbImageUrl = "";

            if (fileName != null && !fileName.isEmpty()) {
                // Đường dẫn thực tế trên server (Tomcat)
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

                // Tạo thư mục nếu chưa tồn tại
                File fileSaveDir = new File(uploadFilePath);
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdirs();
                }

                // Ghi file vật lý
                filePart.write(uploadFilePath + File.separator + fileName);

                // Đường dẫn lưu vào Database để hiển thị trên web
                dbImageUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + fileName;
            }

            // Bind dữ liệu vào Model
            ProductModel product = new ProductModel();
            product.setName(name);
            product.setCategoryId(categoryId);
            product.setPrice(price);
            product.setTaxRate(taxRate); // Thêm thuế
            product.setStock(stock);
            product.setDescription(description);
            product.setDetailedDescription(detailedDescription); // Thêm mô tả chi tiết
            product.setStatus(status);
            product.setImageUrl(dbImageUrl);
            product.setWeightGram(weightGram);
            product.setStorageType(storageType);
            product.setIsFreeShipping(isFreeShipping);

            // Lưu Database
            productService.save(product);

            // Xong thì quay lại danh sách sản phẩm
            response.sendRedirect(request.getContextPath() + "/admin/products?message=Success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products/add?message=Error");
        }
    }

    // Hàm phụ trợ trích xuất tên file từ Part Header
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