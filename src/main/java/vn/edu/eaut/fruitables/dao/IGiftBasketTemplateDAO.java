package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.GiftBasketTemplateModel;
import java.util.List;

public interface IGiftBasketTemplateDAO extends GenericDAO<GiftBasketTemplateModel> {
    List<GiftBasketTemplateModel> findAllActive();
    GiftBasketTemplateModel findById(Integer id);
}
