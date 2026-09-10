package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.UserAddressModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserAddressMapper implements IRowMapper<UserAddressModel> {
    @Override
    public UserAddressModel mapRow(ResultSet rs) {
        try {
            UserAddressModel addr = new UserAddressModel();
            addr.setId(rs.getLong("id"));
            addr.setUserId(rs.getLong("user_id"));
            addr.setRecipientName(rs.getString("recipient_name"));
            addr.setPhone(rs.getString("phone"));
            addr.setProvince(rs.getString("province"));
            addr.setDistrict(rs.getString("district"));
            addr.setWard(rs.getString("ward"));
            addr.setStreetAddress(rs.getString("street_address"));
            addr.setFullAddress(rs.getString("full_address"));
            addr.setLatitude(rs.getObject("latitude") != null ? rs.getDouble("latitude") : null);
            addr.setLongitude(rs.getObject("longitude") != null ? rs.getDouble("longitude") : null);
            addr.setIsDefault(rs.getBoolean("is_default"));
            addr.setCreatedAt(rs.getTimestamp("created_at"));
            return addr;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
