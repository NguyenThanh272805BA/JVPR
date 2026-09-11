package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.ShipperModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ShipperMapper implements IRowMapper<ShipperModel> {
    @Override
    public ShipperModel mapRow(ResultSet rs) {
        try {
            ShipperModel shipper = new ShipperModel();
            shipper.setId(rs.getLong("id"));
            shipper.setFullName(rs.getString("full_name"));
            shipper.setPhone(rs.getString("phone"));
            shipper.setVehiclePlate(rs.getString("vehicle_plate"));
            shipper.setAvatarUrl(rs.getString("avatar_url"));
            shipper.setStatus(rs.getString("status"));
            try {
                shipper.setCreatedAt(rs.getTimestamp("created_at"));
            } catch (Exception ignored) {}
            return shipper;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
