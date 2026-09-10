package vn.edu.eaut.fruitables.service.impl;

import vn.edu.eaut.fruitables.dao.ISupplierDAO;
import vn.edu.eaut.fruitables.dao.impl.SupplierDAOImpl;
import vn.edu.eaut.fruitables.model.entity.SupplierModel;
import vn.edu.eaut.fruitables.service.ISupplierService;

import java.util.List;

public class SupplierServiceImpl implements ISupplierService {

    private final ISupplierDAO supplierDAO;

    public SupplierServiceImpl() {
        this.supplierDAO = new SupplierDAOImpl();
    }

    @Override
    public List<SupplierModel> findAll() {
        return supplierDAO.findAll();
    }

    @Override
    public SupplierModel findById(Long id) {
        return supplierDAO.findById(id);
    }

    @Override
    public Long save(SupplierModel supplier) {
        return supplierDAO.save(supplier);
    }

    @Override
    public void update(SupplierModel supplier) {
        supplierDAO.update(supplier);
    }

    @Override
    public void delete(Long id) {
        supplierDAO.delete(id);
    }
}
