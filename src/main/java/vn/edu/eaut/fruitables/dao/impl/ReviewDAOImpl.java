package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.model.entity.ReviewModel;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAOImpl {

    // Lấy danh sách đánh giá kèm tên khách hàng
    public List<ReviewModel> findByProductId(Long productId) {
        List<ReviewModel> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name FROM reviews r JOIN users u ON r.user_id = u.id WHERE r.product_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewModel rv = new ReviewModel();
                    rv.setId(rs.getLong("id"));
                    rv.setUserId(rs.getLong("user_id"));
                    rv.setProductId(rs.getLong("product_id"));
                    rv.setRating(rs.getInt("rating"));
                    rv.setComment(rs.getString("comment"));
                    rv.setCreatedAt(rs.getTimestamp("created_at"));
                    rv.setUserName(rs.getString("full_name"));
                    list.add(rv);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Kiểm tra xem user có đơn hàng COMPLETED nào chứa sản phẩm này chưa
    public Long getValidOrderIdForReview(Long userId, Long productId) {
        String sql = "SELECT o.id FROM orders o JOIN order_details od ON o.id = od.order_id " +
                "WHERE o.user_id = ? AND od.product_id = ? AND o.status = 'COMPLETED' LIMIT 1";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong("id");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null; // Trả về null nếu chưa mua hoặc đơn chưa hoàn thành
    }

    // Lưu đánh giá mới
    public boolean insertReview(ReviewModel review) {
        String sql = "INSERT INTO reviews (user_id, product_id, order_id, rating, comment) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, review.getUserId());
            ps.setLong(2, review.getProductId());
            ps.setLong(3, review.getOrderId());
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getComment());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}