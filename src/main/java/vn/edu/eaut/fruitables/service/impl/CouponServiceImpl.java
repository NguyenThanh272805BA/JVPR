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
}