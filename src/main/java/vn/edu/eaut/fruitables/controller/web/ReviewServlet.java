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
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Kiểm tra điều kiện: Phải mua hàng và đơn hàng phải ở trạng thái COMPLETED
            Long orderId = reviewDAO.getValidOrderIdForReview(user.getId(), productId);

            if (orderId != null) {
                // Xử lý upload ảnh nếu có
                String dbImageUrl = null;
                try {
                    Part filePart = request.getPart("reviewImage");
                    if (filePart != null && filePart.getSize() > 0) {
                        String rawFileName = extractFileName(filePart);
                        if (rawFileName != null && !rawFileName.trim().isEmpty()) {
                            String applicationPath = request.getServletContext().getRealPath("");
                            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

                            File fileSaveDir = new File(uploadFilePath);
                            if (!fileSaveDir.exists()) {
                                fileSaveDir.mkdirs();
                            }

                            // Tạo tên file ngẫu nhiên/timestamp tránh trùng
                            String fileExt = "";
                            int dotIdx = rawFileName.lastIndexOf('.');
                            if (dotIdx >= 0) {
                                fileExt = rawFileName.substring(dotIdx);
                            }
                            String uniqueFileName = "review_" + System.currentTimeMillis() + "_" + (int)(Math.random() * 1000) + fileExt;
                            filePart.write(uploadFilePath + File.separator + uniqueFileName);

                            dbImageUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;
                        }
                    }
                } catch (Exception uploadEx) {
                    System.err.println("Lỗi xử lý file upload đánh giá: " + uploadEx.getMessage());
                }

                ReviewModel review = new ReviewModel();
                review.setUserId(user.getId());
                review.setProductId(productId);
                review.setOrderId(orderId);
                review.setRating(rating);
                review.setComment(comment);
                review.setImageUrl(dbImageUrl);

                reviewDAO.insertReview(review);
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "&review=success");
            } else {
                // Đá về kèm thông báo lỗi chưa đủ điều kiện
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "&review=not_purchased");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/shop");
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return null;
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                String name = s.substring(s.indexOf("=") + 2, s.length() - 1);
                // Xử lý trường hợp IE gửi cả đường dẫn đầy đủ
                int slashIdx = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                if (slashIdx >= 0) {
                    name = name.substring(slashIdx + 1);
                }
                return name;
            }
        }
        return null;
    }
}