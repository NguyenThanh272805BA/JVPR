package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IShipperDAO;
import vn.edu.eaut.fruitables.mapper.ShipperMapper;
import vn.edu.eaut.fruitables.model.entity.ShipperModel;

import java.util.List;

public class ShipperDAOImpl extends AbstractDAO<ShipperModel> implements IShipperDAO {

    private final ShipperMapper shipperMapper = new ShipperMapper();

    @Override
    public List<ShipperModel> findAll() {
        String sql = "SELECT * FROM shippers ORDER BY id ASC";
        return query(sql, shipperMapper);
    }

    @Override
    public List<ShipperModel> findAvailable() {
        String sql = "SELECT * FROM shippers WHERE status = 'AVAILABLE' ORDER BY id ASC";
        return query(sql, shipperMapper);
    }

    @Override
    public ShipperModel findById(Long id) {
        String sql = "SELECT * FROM shippers WHERE id = ?";
        List<ShipperModel> list = query(sql, shipperMapper, id);
        return (list != null && !list.isEmpty()) ? list.get(0) : null;
    }

    @Override
    public ShipperModel findByUserId(Long userId) {
        String sql = "SELECT * FROM shippers WHERE user_id = ?";
        List<ShipperModel> list = query(sql, shipperMapper, userId);
        return (list != null && !list.isEmpty()) ? list.get(0) : null;
    }

    @Override
    public void updateStatus(Long id, String status) {
        String sql = "UPDATE shippers SET status = ? WHERE id = ?";
        update(sql, status, id);
    }
}
