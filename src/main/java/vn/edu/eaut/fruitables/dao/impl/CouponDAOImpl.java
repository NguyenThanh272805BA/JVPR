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

    @Override
    public CouponModel findById(Integer id) {
        String sql = "SELECT * FROM coupons WHERE id = ?";
        List<CouponModel> coupons = query(sql, new CouponMapper(), id);
        return coupons.isEmpty() ? null : coupons.get(0);
    }

    @Override
    public void update(CouponModel coupon) {
        String sql = "UPDATE coupons SET code = ?, discount_type = ?, discount_value = ?, min_order_value = ?, start_date = ?, end_date = ?, usage_limit = ?, status = ? WHERE id = ?";
        update(sql, coupon.getCode(), coupon.getDiscountType(), coupon.getDiscountValue(),
                coupon.getMinOrderValue(), coupon.getStartDate(), coupon.getEndDate(),
                coupon.getUsageLimit(), coupon.getStatus(), coupon.getId());
    }

    // 1. Khóa mềm (Ẩn voucher đi - set status = 0)
    @Override
    public void softDelete(Integer id) {
        String sql = "UPDATE coupons SET status = 0 WHERE id = ?";
        update(sql, id);
    }

    // 2. Khôi phục (Tái sử dụng - set status = 1)
    @Override
    public void restore(Integer id) {
        String sql = "UPDATE coupons SET status = 1 WHERE id = ?";
        update(sql, id);
    }

    // 3. Xóa cứng (Xóa vĩnh viễn khỏi Database)
    @Override
    public void hardDelete(Integer id) {
        String sql = "DELETE FROM coupons WHERE id = ?";
        update(sql, id);
    }
}