package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IGiftBasketTemplateDAO;
import vn.edu.eaut.fruitables.mapper.GiftBasketTemplateMapper;
import vn.edu.eaut.fruitables.model.entity.GiftBasketTemplateModel;

import java.util.List;

public class GiftBasketTemplateDAOImpl extends AbstractDAO<GiftBasketTemplateModel> implements IGiftBasketTemplateDAO {

    private final GiftBasketTemplateMapper mapper = new GiftBasketTemplateMapper();

    @Override
    public List<GiftBasketTemplateModel> findAllActive() {
        String sql = "SELECT * FROM gift_basket_templates WHERE status = 1 ORDER BY base_price ASC";
        return query(sql, mapper);
    }

    @Override
    public GiftBasketTemplateModel findById(Integer id) {
        String sql = "SELECT * FROM gift_basket_templates WHERE id = ?";
        List<GiftBasketTemplateModel> list = query(sql, mapper, id);
        return (list != null && !list.isEmpty()) ? list.get(0) : null;
    }
}
