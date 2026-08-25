package vn.edu.eaut.fruitables.service.impl;

import vn.edu.eaut.fruitables.dao.ICouponDAO;
import vn.edu.eaut.fruitables.dao.impl.CouponDAOImpl;
import vn.edu.eaut.fruitables.model.entity.CouponModel;
import vn.edu.eaut.fruitables.service.ICouponService;
import java.util.List;

public class CouponServiceImpl implements ICouponService {
    private ICouponDAO couponDAO;

    public CouponServiceImpl() {
        this.couponDAO = new CouponDAOImpl();
    }

    @Override
    public List<CouponModel> findAll() {
        return couponDAO.findAll();
    }

    @Override
    public CouponModel save(CouponModel couponModel) {
        Long newId = couponDAO.save(couponModel);
        if (newId != null) {
            couponModel.setId(newId.intValue());
            return couponModel;
        }
        return null;
    }

    @Override
    public CouponModel findById(Integer id) {
        return couponDAO.findById(id);
    }

    @Override
    public void update(CouponModel coupon) {
        couponDAO.update(coupon);
    }

    @Override
    public void softDelete(Integer id) {
        couponDAO.softDelete(id);
    }

    @Override
    public void restore(Integer id) {
        couponDAO.restore(id);
    }

    @Override
    public void hardDelete(Integer id) {
        couponDAO.hardDelete(id);
    }
}