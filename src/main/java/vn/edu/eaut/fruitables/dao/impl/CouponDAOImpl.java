package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.ICouponDAO;
import vn.edu.eaut.fruitables.mapper.CouponMapper;
import vn.edu.eaut.fruitables.model.entity.CouponModel;
import java.util.List;

public class CouponDAOImpl extends AbstractDAO<CouponModel> implements ICouponDAO {
    @Override
    public List<CouponModel> findAll() {
        String sql = "SELECT * FROM coupons ORDER BY id DESC";
        return query(sql, new CouponMapper());
    }

    @Override
    public Long save(CouponModel coupon) {
        String sql = "INSERT INTO coupons (code, discount_type, discount_value, min_order_value, start_date, end_date, usage_limit, used_count, status) VALUES (?, ?, ?, ?, ?, ?, ?, 0, 1)";
        return insert(sql, coupon.getCode(), coupon.getDiscountType(), coupon.getDiscountValue(), coupon.getMinOrderValue(), coupon.getStartDate(), coupon.getEndDate(), coupon.getUsageLimit());
    }
}