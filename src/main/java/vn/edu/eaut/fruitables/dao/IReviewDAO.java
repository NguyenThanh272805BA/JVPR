package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.ReviewModel;

import java.util.List;

public interface IReviewDAO {
    List<ReviewModel> findByProductId(Long productId);
    Long getValidOrderIdForReview(Long userId, Long productId);
    boolean hasAlreadyReviewed(Long userId, Long productId);
    boolean hasPurchasedProduct(Long userId, Long productId);
    Long insertReview(ReviewModel review);
    boolean updateAIReply(Long reviewId, String reply, String replyBy, String sentiment, boolean isReported);
    boolean updateAdminReply(Long reviewId, String reply, String replyBy);
    ReviewModel findById(Long reviewId);
    List<ReviewModel> findAllReviews(String sentimentFilter, String keyword, int page, int pageSize);
    int countReviews(String sentimentFilter, String keyword);
}
