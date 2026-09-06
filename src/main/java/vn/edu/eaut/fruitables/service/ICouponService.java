package vn.edu.eaut.fruitables.service;
import vn.edu.eaut.fruitables.model.entity.CouponModel;
import java.util.List;

public interface ICouponService {
    List<CouponModel> findAll();
    CouponModel save(CouponModel couponModel);
    CouponModel findById(Integer id);
    CouponModel findByCode(String code);
    void update(CouponModel coupon);
    void hardDelete(Integer id);
    void restore(Integer id);
    void softDelete(Integer id);
}