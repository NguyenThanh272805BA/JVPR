package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.SupplierModel;
import java.util.List;

public interface ISupplierDAO extends GenericDAO<SupplierModel> {
    List<SupplierModel> findAll();
    SupplierModel findById(Long id);
    Long save(SupplierModel supplier);
    void update(SupplierModel supplier);
    void delete(Long id);
}
