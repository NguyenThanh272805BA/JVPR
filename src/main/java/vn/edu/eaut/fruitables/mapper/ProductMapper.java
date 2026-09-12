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
            try {
                product.setCostPrice(rs.getDouble("cost_price"));
            } catch (SQLException e) {
                product.setCostPrice(0.0);
            }
            product.setStock(rs.getInt("stock"));
            product.setImageUrl(rs.getString("image_url"));
            product.setStatus(rs.getBoolean("status"));

            // Map dữ liệu mô tả chi tiết & thuế an toàn
            try {
                product.setDetailedDescription(rs.getString("detailed_description"));
            } catch (SQLException e) {
                product.setDetailedDescription(null);
            }
            try {
                product.setTaxRate(rs.getDouble("tax_rate"));
            } catch (SQLException e) {
                product.setTaxRate(0.0);
            }

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

            // Lấy thêm dữ liệu tổng số lượng đã bán (total_sold)
            try {
                product.setTotalSold(rs.getInt("total_sold"));
            } catch (SQLException e) {
                product.setTotalSold(0);
            }

            // Map thông số vận chuyển & bảo quản
            try {
                product.setWeightGram(rs.getObject("weight_gram") != null ? rs.getInt("weight_gram") : 500);
            } catch (SQLException e) {
                product.setWeightGram(500);
            }

            try {
                String storage = rs.getString("storage_type");
                product.setStorageType(storage != null ? storage : "NORMAL");
            } catch (SQLException e) {
                product.setStorageType("NORMAL");
            }

            try {
                product.setIsFreeShipping(rs.getBoolean("is_free_shipping"));
            } catch (SQLException e) {
                product.setIsFreeShipping(false);
            }

            return product;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}