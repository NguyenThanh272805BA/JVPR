package vn.edu.eaut.fruitables.service;
import vn.edu.eaut.fruitables.model.entity.CouponModel;
import java.util.List;

public interface ICouponService {
    List<CouponModel> findAll();
    CouponModel save(CouponModel couponModel);
}