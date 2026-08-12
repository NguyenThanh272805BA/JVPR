package vn.edu.eaut.fruitables.dao;
import vn.edu.eaut.fruitables.model.entity.CouponModel;
import java.util.List;

public interface ICouponDAO extends GenericDAO<CouponModel> {
    List<CouponModel> findAll();
    Long save(CouponModel couponModel);
}