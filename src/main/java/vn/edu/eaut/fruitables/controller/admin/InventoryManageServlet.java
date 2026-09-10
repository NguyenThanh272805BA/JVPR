package vn.edu.eaut.fruitables.controller.admin;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.model.entity.*;
import vn.edu.eaut.fruitables.service.ICategoryService;
import vn.edu.eaut.fruitables.service.IInventoryReceiptService;
import vn.edu.eaut.fruitables.service.IProductService;
import vn.edu.eaut.fruitables.service.ISupplierService;
import vn.edu.eaut.fruitables.service.impl.CategoryServiceImpl;
import vn.edu.eaut.fruitables.service.impl.InventoryReceiptServiceImpl;
import vn.edu.eaut.fruitables.service.impl.ProductServiceImpl;
import vn.edu.eaut.fruitables.service.impl.SupplierServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet(urlPatterns = {"/admin/inventory", "/admin/inventory/create", "/admin/inventory/detail", "/admin/suppliers", "/admin/inventory/quick-product"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class InventoryManageServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "assets/uploads";
    private final IInventoryReceiptService receiptService;
    private final ISupplierService supplierService;
    private final IProductService productService;
    private final ICategoryService categoryService;

    public InventoryManageServlet() {
        this.receiptService = new InventoryReceiptServiceImpl();
        this.supplierService = new SupplierServiceImpl();
        this.productService = new ProductServiceImpl();
        this.categoryService = new CategoryServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/inventory/create".equals(path)) {
            // Trang tạo phiếu nhập kho mới
            List<SupplierModel> suppliers = supplierService.findAll();
            List<ProductModel> products = productService.findAll();
            List<CategoryModel> categories = categoryService.findAll();

            request.setAttribute("suppliers", suppliers);
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/WEB-INF/views/admin/inventory-receipt-create.jsp").forward(request, response);
            return;
        }

        if ("/admin/inventory/detail".equals(path)) {
            // Xem chi tiết phiếu nhập
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                InventoryReceiptModel receipt = receiptService.findById(id);
                if (receipt != null) {
                    request.setAttribute("receipt", receipt);
                    request.getRequestDispatcher("/WEB-INF/views/admin/inventory-receipt-detail.jsp").forward(request, response);
                    return;
                }
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin/inventory");
            return;
        }

        if ("/admin/suppliers".equals(path)) {
            // Danh sách nhà cung cấp
            List<SupplierModel> suppliers = supplierService.findAll();
            request.setAttribute("suppliers", suppliers);
            request.getRequestDispatcher("/WEB-INF/views/admin/supplier-list.jsp").forward(request, response);
            return;
        }

        // Mặc định: /admin/inventory -> Danh sách phiếu nhập kho kèm tổng hợp tồn kho
        List<InventoryReceiptModel> receipts = receiptService.findAll();
        List<ProductModel> products = productService.findAll();
        request.setAttribute("receipts", receipts);
        request.setAttribute("products", products);
        request.getRequestDispatcher("/WEB-INF/views/admin/inventory-receipt-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();

        if ("/admin/inventory/quick-product".equals(path)) {
            response.setContentType("application/json;charset=UTF-8");
            try {
                String name = request.getParameter("name");
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                double price = Double.parseDouble(request.getParameter("price"));
                int weightGram = 500;
                try {
                    weightGram = Integer.parseInt(request.getParameter("weightGram"));
                } catch (Exception ignored) {}
                String storageType = request.getParameter("storageType");
                if (storageType == null || storageType.trim().isEmpty()) {
                    storageType = "NORMAL";
                }
                String description = request.getParameter("description");

                // Xử lý upload file ảnh sản phẩm trực tiếp
                String dbImageUrl = "";
                try {
                    Part filePart = request.getPart("imageFile");
                    String originalName = filePart != null ? extractFileName(filePart) : "";
                    if (originalName != null && !originalName.trim().isEmpty()) {
                        String cleanName = System.currentTimeMillis() + "_" + new File(originalName).getName().replaceAll("[^a-zA-Z0-9._-]", "_");
                        String applicationPath = request.getServletContext().getRealPath("");
                        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
                        File fileSaveDir = new File(uploadFilePath);
                        if (!fileSaveDir.exists()) {
                            fileSaveDir.mkdirs();
                        }
                        filePart.write(uploadFilePath + File.separator + cleanName);
                        dbImageUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + cleanName;
                    }
                } catch (Exception uploadErr) {
                    // Upload file không bắt buộc, nếu lỗi thì fallback link URL
                }

                // Nếu không upload file, kiểm tra xem có dán đường dẫn link ảnh không
                if (dbImageUrl.isEmpty()) {
                    String imageUrl = request.getParameter("imageUrl");
                    if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                        dbImageUrl = imageUrl.trim();
                    } else {
                        dbImageUrl = request.getContextPath() + "/assets/uploads/no-image.svg";
                    }
                }

                ProductModel p = new ProductModel();
                p.setName(name != null ? name.trim() : "Sản phẩm mới");
                p.setCategoryId(categoryId);
                p.setPrice(price);
                p.setCostPrice(0.0);
                p.setStock(0);
                p.setTaxRate(0.0);
                p.setStatus(true);
                p.setWeightGram(weightGram);
                p.setStorageType(storageType);
                p.setIsFreeShipping(false);
                p.setDescription(description != null && !description.trim().isEmpty() ? description.trim() : name);
                p.setDetailedDescription("<p>" + (description != null ? description : name) + "</p>");
                p.setImageUrl(dbImageUrl);

                ProductModel created = productService.save(p);
                Long newId = created != null ? created.getId() : 0L;

                JsonObject res = new JsonObject();
                res.addProperty("success", true);
                res.addProperty("id", newId);
                res.addProperty("name", created.getName());
                res.addProperty("categoryName", created.getCategoryName() != null ? created.getCategoryName() : "");
                res.addProperty("stock", 0);
                res.addProperty("costPrice", 0.0);
                res.addProperty("price", created.getPrice());
                res.addProperty("imageUrl", created.getImageUrl());
                response.getWriter().write(new Gson().toJson(res));
            } catch (Exception e) {
                JsonObject res = new JsonObject();
                res.addProperty("success", false);
                res.addProperty("message", e.getMessage());
                response.getWriter().write(new Gson().toJson(res));
            }
            return;
        }

        if ("/admin/suppliers".equals(path)) {
            // Thêm nhanh nhà cung cấp
            String name = request.getParameter("name");
            String contactName = request.getParameter("contactName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

            if (name != null && !name.trim().isEmpty()) {
                SupplierModel sup = new SupplierModel();
                sup.setName(name.trim());
                sup.setContactName(contactName != null ? contactName.trim() : "");
                sup.setPhone(phone != null ? phone.trim() : "");
                sup.setEmail(email != null ? email.trim() : "");
                sup.setAddress(address != null ? address.trim() : "");
                sup.setStatus(true);
                supplierService.save(sup);
            }
            String redirectUrl = request.getParameter("redirect");
            if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/inventory/create");
            }
            return;
        }

        if ("/admin/inventory/create".equals(path)) {
            try {
                Long supplierId = Long.parseLong(request.getParameter("supplierId"));
                String note = request.getParameter("note");
                String[] productIds = request.getParameterValues("productId[]");
                String[] quantities = request.getParameterValues("quantity[]");
                String[] importPrices = request.getParameterValues("importPrice[]");

                if (productIds != null && quantities != null && importPrices != null && productIds.length > 0) {
                    HttpSession session = request.getSession();
                    UserModel currentUser = (UserModel) session.getAttribute("USERMODEL");
                    Long createdBy = currentUser != null ? currentUser.getId() : 1L;

                    String receiptCode = "PN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

                    InventoryReceiptModel receipt = new InventoryReceiptModel();
                    receipt.setReceiptCode(receiptCode);
                    receipt.setSupplierId(supplierId);
                    receipt.setCreatedBy(createdBy);
                    receipt.setNote(note != null ? note.trim() : "");
                    receipt.setStatus("COMPLETED");

                    List<InventoryReceiptDetailModel> details = new ArrayList<>();
                    for (int i = 0; i < productIds.length; i++) {
                        if (productIds[i] == null || productIds[i].trim().isEmpty()) continue;
                        long pid = Long.parseLong(productIds[i]);
                        int qty = Integer.parseInt(quantities[i]);
                        double price = Double.parseDouble(importPrices[i]);

                        if (qty > 0 && price >= 0) {
                            InventoryReceiptDetailModel detail = new InventoryReceiptDetailModel();
                            detail.setProductId(pid);
                            detail.setQuantity(qty);
                            detail.setImportPrice(price);
                            detail.setSubTotal(qty * price);
                            details.add(detail);
                        }
                    }

                    if (!details.isEmpty()) {
                        boolean ok = receiptService.createReceipt(receipt, details);
                        if (ok) {
                            session.setAttribute("SUCCESS_MSG", "Tạo phiếu nhập kho " + receiptCode + " thành công! Tồn kho và giá vốn bình quân đã được cập nhật.");
                            response.sendRedirect(request.getContextPath() + "/admin/inventory");
                            return;
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/admin/inventory/create?error=true");
        }
    }

    private String extractFileName(Part part) {
        if (part == null) return "";
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return "";
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                String raw = s.substring(s.indexOf("=") + 2, s.length() - 1);
                return new File(raw).getName();
            }
        }
        return "";
    }
}
