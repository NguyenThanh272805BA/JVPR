package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.dao.impl.ReviewDAOImpl;
import vn.edu.eaut.fruitables.model.entity.ReviewModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;

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
import java.nio.file.Paths;

@WebServlet(urlPatterns = {"/submit-review"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 20    // 20MB
)
public class ReviewServlet extends HttpServlet {

    private ReviewDAOImpl reviewDAO = new ReviewDAOImpl();
    private static final String UPLOAD_DIR = "assets/uploads/reviews";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");

        String productIdStr = request.getParameter("productId");

        // Chưa đăng nhập thì chặn lại
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?message=PleaseLoginToReview");
            return;
        }

        try {
            Long productId = Long.parseLong(productIdStr);
            String ratingStr = request.getParameter("rating");
            int rating = 5;
            try {
                rating = Integer.parseInt(ratingStr);
                if (rating < 1) rating = 1;
                if (rating > 5) rating = 5;
            } catch (Exception ignored) {}

            String comment = request.getParameter("comment");
            if (comment == null || comment.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "&review=empty_comment");
                return;
            }

            // Kiểm tra điều kiện: Phải mua hàng và đơn hàng phải ở trạng thái COMPLETED hoặc DELIVERED
            Long orderId = reviewDAO.getValidOrderIdForReview(user.getId(), productId);

            if (orderId != null) {
                // Xử lý upload ảnh nếu có
                String dbImageUrl = null;
                try {
                    Part filePart = request.getPart("reviewImage");
                    if (filePart != null && filePart.getSize() > 0) {
                        String rawFileName = filePart.getSubmittedFileName();
                        if (rawFileName != null && !rawFileName.trim().isEmpty()) {
                            String submittedFileName = Paths.get(rawFileName).getFileName().toString();
                            String applicationPath = request.getServletContext().getRealPath("");
                            if (applicationPath == null) {
                                applicationPath = System.getProperty("catalina.base") + File.separator + "webapps" + request.getContextPath();
                            }
                            File uploadDir = new File(applicationPath, UPLOAD_DIR);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdirs();
                            }

                            // Tạo tên file ngẫu nhiên/timestamp tránh trùng
                            String fileExt = "";
                            int dotIdx = submittedFileName.lastIndexOf('.');
                            if (dotIdx >= 0) {
                                fileExt = submittedFileName.substring(dotIdx).toLowerCase();
                            }
                            String uniqueFileName = "review_" + System.currentTimeMillis() + "_" + (int)(Math.random() * 1000) + fileExt;
                            File targetFile = new File(uploadDir, uniqueFileName);
                            filePart.write(targetFile.getAbsolutePath());

                            // Sao lưu vào thư mục nguồn nếu tồn tại để tránh mất ảnh khi rebuild
                            try {
                                File srcDir = new File("d:/JavaPRJ/Fruitables-Web-App/src/main/webapp/assets/uploads/reviews");
                                if (srcDir.exists()) {
                                    java.nio.file.Files.copy(targetFile.toPath(), new File(srcDir, uniqueFileName).toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                                }
                            } catch (Exception ignored) {}

                            dbImageUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;
                        }
                    }
                } catch (Exception uploadEx) {
                    // Log chi tiết lỗi upload để dễ debug
                    System.err.println("=== LỖI UPLOAD ẢNH ĐÁNH GIÁ ===");
                    System.err.println("User ID: " + user.getId() + ", Product ID: " + productIdStr);
                    uploadEx.printStackTrace();
                }

                ReviewModel review = new ReviewModel();
                review.setUserId(user.getId());
                review.setProductId(productId);
                review.setOrderId(orderId);
                review.setRating(rating);
                review.setComment(comment.trim());
                review.setImageUrl(dbImageUrl);

                reviewDAO.insertReview(review);
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "&review=success");
            } else {
                // Kiểm tra lý do chi tiết để phản hồi chính xác cho người dùng
                if (reviewDAO.hasAlreadyReviewed(user.getId(), productId)) {
                    response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "&review=already_reviewed");
                } else if (reviewDAO.hasPurchasedProduct(user.getId(), productId)) {
                    response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "&review=order_processing");
                } else {
                    response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "&review=not_purchased");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productIdStr + "&review=error");
            } else {
                response.sendRedirect(request.getContextPath() + "/shop");
            }
        }
    }
}