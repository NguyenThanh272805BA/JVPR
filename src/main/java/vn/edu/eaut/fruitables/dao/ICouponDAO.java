package vn.edu.eaut.fruitables.dao;
import vn.edu.eaut.fruitables.model.entity.CouponModel;
import java.util.List;

public interface ICouponDAO extends GenericDAO<CouponModel> {
    List<CouponModel> findAll();
    Long save(CouponModel couponModel);
    CouponModel findById(Integer id);
    void update(CouponModel coupon);
    void hardDelete(Integer id);
    void softDelete(Integer id);
    void restore(Integer id);
}