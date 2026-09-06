package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.CouponModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CouponMapper implements IRowMapper<CouponModel> {
    @Override
    public CouponModel mapRow(ResultSet rs) {
        try {
            CouponModel coupon = new CouponModel();
            coupon.setId(rs.getInt("id"));
            coupon.setCode(rs.getString("code"));
            coupon.setDiscountType(rs.getString("discount_type"));
            coupon.setDiscountValue(rs.getDouble("discount_value"));
            coupon.setMinOrderValue(rs.getDouble("min_order_value"));
            coupon.setStartDate(rs.getTimestamp("start_date"));
            coupon.setEndDate(rs.getTimestamp("end_date"));
            coupon.setUsageLimit(rs.getInt("usage_limit"));
            coupon.setUsedCount(rs.getInt("used_count"));
            coupon.setStatus(rs.getBoolean("status"));
            coupon.setTargetAudience(rs.getString("target_audience"));

            try {
                coupon.setProductId(rs.getObject("product_id") != null ? rs.getLong("product_id") : null);
            } catch (SQLException ignored) {}

            try {
                coupon.setProductName(rs.getString("product_name"));
            } catch (SQLException ignored) {}

            return coupon;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}