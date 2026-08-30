package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.ProductModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProductMapper implements IRowMapper<ProductModel> {
    @Override
    public ProductModel mapRow(ResultSet rs) {
        try {
            ProductModel product = new ProductModel();
            product.setDiscountPrice(rs.getObject("discount_price") != null ? rs.getDouble("discount_price") : null);
            product.setId(rs.getLong("id"));
            product.setCategoryId(rs.getInt("category_id"));
            product.setName(rs.getString("name"));
            product.setDescription(rs.getString("description"));
            product.setPrice(rs.getDouble("price"));
            product.setStock(rs.getInt("stock"));
            product.setImageUrl(rs.getString("image_url"));
            product.setStatus(rs.getBoolean("status"));

            // Map dữ liệu mô tả chi tiết & thuế
            product.setDetailedDescription(rs.getString("detailed_description"));
            product.setTaxRate(rs.getDouble("tax_rate"));

            // Lấy thêm tên danh mục từ câu lệnh JOIN SQL
            try {
                product.setCategoryName(rs.getString("category_name"));
            } catch (SQLException e) {
                // Bỏ qua nếu câu query không có trường category_name
            }

            // Lấy thêm dữ liệu đánh giá sao và số lượng bình luận
            try {
                product.setAvgRating(rs.getDouble("avg_rating"));
                product.setReviewCount(rs.getInt("review_count"));
            } catch (SQLException e) {
                // Đặt giá trị mặc định nếu câu query chưa select các trường này
                product.setAvgRating(0.0);
                product.setReviewCount(0);
            }

            return product;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}