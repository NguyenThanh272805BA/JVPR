package vn.edu.eaut.fruitables.service;

import vn.edu.eaut.fruitables.model.entity.SupplierModel;
import java.util.List;

public interface ISupplierService {
    List<SupplierModel> findAll();
    SupplierModel findById(Long id);
    Long save(SupplierModel supplier);
    void update(SupplierModel supplier);
    void delete(Long id);
}
