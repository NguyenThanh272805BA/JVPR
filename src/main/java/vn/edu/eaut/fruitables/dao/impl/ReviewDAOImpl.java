package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IReviewDAO;
import vn.edu.eaut.fruitables.model.entity.ReviewModel;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAOImpl implements IReviewDAO {

    @Override
    public List<ReviewModel> findByProductId(Long productId) {
        List<ReviewModel> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name, u.avatar_url FROM reviews r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.product_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewModel rv = mapReviewFromResultSet(rs);
                    rv.setUserName(rs.getString("full_name"));
                    rv.setAvatarUrl(rs.getString("avatar_url"));
                    list.add(rv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Long getValidOrderIdForReview(Long userId, Long productId) {
        // CHỐNG SPAM: Mỗi lần mua thành công 1 sản phẩm trong đơn hàng DELIVERED/COMPLETED chỉ được đánh giá DUY NHẤT 1 LẦN
        String sql = "SELECT o.id FROM orders o JOIN order_details od ON o.id = od.order_id " +
                "WHERE o.user_id = ? AND od.product_id = ? AND UPPER(TRIM(o.status)) IN ('COMPLETED', 'DELIVERED') " +
                "AND NOT EXISTS (" +
                "    SELECT 1 FROM reviews r WHERE r.user_id = ? AND r.product_id = ? AND r.order_id = o.id" +
                ") LIMIT 1";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, productId);
            ps.setLong(3, userId);
            ps.setLong(4, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong("id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean hasAlreadyReviewed(Long userId, Long productId) {
        String sql = "SELECT 1 FROM reviews WHERE user_id = ? AND product_id = ? LIMIT 1";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean hasPurchasedProduct(Long userId, Long productId) {
        String sql = "SELECT 1 FROM orders o JOIN order_details od ON o.id = od.order_id " +
                "WHERE o.user_id = ? AND od.product_id = ? AND UPPER(TRIM(o.status)) NOT IN ('CANCELLED', 'RETURNED', 'FAILED') LIMIT 1";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Long insertReview(ReviewModel review) {
        String sql = "INSERT INTO reviews (user_id, product_id, order_id, rating, comment, image_url, sentiment, is_reported) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, review.getUserId());
            ps.setLong(2, review.getProductId());
            ps.setLong(3, review.getOrderId());
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getComment());
            ps.setString(6, review.getImageUrl());
            ps.setString(7, review.getSentiment() != null ? review.getSentiment() : "NEUTRAL");
            ps.setBoolean(8, review.getIsReported() != null && review.getIsReported());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        long id = generatedKeys.getLong(1);
                        review.setId(id);
                        return id;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updateAIReply(Long reviewId, String reply, String replyBy, String sentiment, boolean isReported) {
        String sql = "UPDATE reviews SET reply = ?, reply_by = ?, reply_at = NOW(), sentiment = ?, is_reported = ? WHERE id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setString(2, replyBy != null ? replyBy : "AI_AGENT");
            ps.setString(3, sentiment != null ? sentiment : "NEUTRAL");
            ps.setBoolean(4, isReported);
            ps.setLong(5, reviewId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateAdminReply(Long reviewId, String reply, String replyBy) {
        String sql = "UPDATE reviews SET reply = ?, reply_by = ?, reply_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setString(2, replyBy != null ? replyBy : "ADMIN");
            ps.setLong(3, reviewId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public ReviewModel findById(Long reviewId) {
        String sql = "SELECT r.*, u.full_name, u.avatar_url, p.name AS product_name, p.image AS product_image " +
                     "FROM reviews r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN products p ON r.product_id = p.id " +
                     "WHERE r.id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, reviewId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ReviewModel rv = mapReviewFromResultSet(rs);
                    rv.setUserName(rs.getString("full_name"));
                    rv.setAvatarUrl(rs.getString("avatar_url"));
                    rv.setProductName(rs.getString("product_name"));
                    rv.setProductImage(rs.getString("product_image"));
                    return rv;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<ReviewModel> findAllReviews(String sentimentFilter, String keyword, int page, int pageSize) {
        List<ReviewModel> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT r.*, u.full_name, u.avatar_url, p.name AS product_name, p.image AS product_image " +
                "FROM reviews r " +
                "JOIN users u ON r.user_id = u.id " +
                "JOIN products p ON r.product_id = p.id WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (sentimentFilter != null && !sentimentFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(sentimentFilter)) {
            sql.append("AND r.sentiment = ? ");
            params.add(sentimentFilter.toUpperCase());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (p.name LIKE ? OR u.full_name LIKE ? OR r.comment LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        sql.append("ORDER BY r.created_at DESC LIMIT ? OFFSET ?");
        int offset = Math.max(0, (page - 1) * pageSize);
        params.add(pageSize);
        params.add(offset);

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewModel rv = mapReviewFromResultSet(rs);
                    rv.setUserName(rs.getString("full_name"));
                    rv.setAvatarUrl(rs.getString("avatar_url"));
                    rv.setProductName(rs.getString("product_name"));
                    rv.setProductImage(rs.getString("product_image"));
                    list.add(rv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countReviews(String sentimentFilter, String keyword) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM reviews r " +
                "JOIN users u ON r.user_id = u.id " +
                "JOIN products p ON r.product_id = p.id WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (sentimentFilter != null && !sentimentFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(sentimentFilter)) {
            sql.append("AND r.sentiment = ? ");
            params.add(sentimentFilter.toUpperCase());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (p.name LIKE ? OR u.full_name LIKE ? OR r.comment LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private ReviewModel mapReviewFromResultSet(ResultSet rs) throws Exception {
        ReviewModel rv = new ReviewModel();
        rv.setId(rs.getLong("id"));
        rv.setUserId(rs.getLong("user_id"));
        rv.setProductId(rs.getLong("product_id"));
        rv.setOrderId(rs.getLong("order_id"));
        rv.setRating(rs.getInt("rating"));
        rv.setComment(rs.getString("comment"));
        rv.setCreatedAt(rs.getTimestamp("created_at"));
        rv.setImageUrl(rs.getString("image_url"));
        rv.setReply(rs.getString("reply"));
        rv.setReplyBy(rs.getString("reply_by"));
        rv.setReplyAt(rs.getTimestamp("reply_at"));
        rv.setSentiment(rs.getString("sentiment"));
        rv.setIsReported(rs.getBoolean("is_reported"));
        return rv;
    }
}