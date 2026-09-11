package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.ShipperModel;
import java.util.List;

public interface IShipperDAO extends GenericDAO<ShipperModel> {
    List<ShipperModel> findAll();
    List<ShipperModel> findAvailable();
    ShipperModel findById(Long id);
    ShipperModel findByUserId(Long userId);
    void updateStatus(Long id, String status);
}
