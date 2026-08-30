package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.dao.impl.ReviewDAOImpl;
import vn.edu.eaut.fruitables.model.entity.ReviewModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/submit-review"})
public class ReviewServlet extends HttpServlet {

    private ReviewDAOImpl reviewDAO = new ReviewDAOImpl();

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
                ReviewModel review = new ReviewModel();
                review.setUserId(user.getId());
                review.setProductId(productId);
                review.setOrderId(orderId);
                review.setRating(rating);
                review.setComment(comment);

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
}