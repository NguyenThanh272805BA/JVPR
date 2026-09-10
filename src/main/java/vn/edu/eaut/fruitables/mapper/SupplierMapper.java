package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.SupplierModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SupplierMapper implements IRowMapper<SupplierModel> {
    @Override
    public SupplierModel mapRow(ResultSet rs) {
        try {
            SupplierModel supplier = new SupplierModel();
            supplier.setId(rs.getLong("id"));
            supplier.setName(rs.getString("name"));
            supplier.setContactName(rs.getString("contact_name"));
            supplier.setPhone(rs.getString("phone"));
            supplier.setEmail(rs.getString("email"));
            supplier.setAddress(rs.getString("address"));
            supplier.setStatus(rs.getBoolean("status"));
            supplier.setCreatedAt(rs.getTimestamp("created_at"));
            return supplier;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
