package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.ISupplierDAO;
import vn.edu.eaut.fruitables.mapper.SupplierMapper;
import vn.edu.eaut.fruitables.model.entity.SupplierModel;

import java.util.List;

public class SupplierDAOImpl extends AbstractDAO<SupplierModel> implements ISupplierDAO {

    @Override
    public List<SupplierModel> findAll() {
        String sql = "SELECT * FROM suppliers ORDER BY id DESC";
        return query(sql, new SupplierMapper());
    }

    @Override
    public SupplierModel findById(Long id) {
        String sql = "SELECT * FROM suppliers WHERE id = ?";
        List<SupplierModel> list = query(sql, new SupplierMapper(), id);
        return list != null && !list.isEmpty() ? list.get(0) : null;
    }

    @Override
    public Long save(SupplierModel supplier) {
        String sql = "INSERT INTO suppliers (name, contact_name, phone, email, address, status) VALUES (?, ?, ?, ?, ?, ?)";
        return insert(sql, supplier.getName(), supplier.getContactName(), supplier.getPhone(), supplier.getEmail(), supplier.getAddress(), supplier.getStatus() != null ? supplier.getStatus() : true);
    }

    @Override
    public void update(SupplierModel supplier) {
        String sql = "UPDATE suppliers SET name = ?, contact_name = ?, phone = ?, email = ?, address = ?, status = ? WHERE id = ?";
        update(sql, supplier.getName(), supplier.getContactName(), supplier.getPhone(), supplier.getEmail(), supplier.getAddress(), supplier.getStatus(), supplier.getId());
    }

    @Override
    public void delete(Long id) {
        String sql = "DELETE FROM suppliers WHERE id = ?";
        update(sql, id);
    }
}
