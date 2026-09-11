package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.GiftBasketTemplateModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class GiftBasketTemplateMapper implements IRowMapper<GiftBasketTemplateModel> {
    @Override
    public GiftBasketTemplateModel mapRow(ResultSet rs) {
        try {
            GiftBasketTemplateModel t = new GiftBasketTemplateModel();
            t.setId(rs.getInt("id"));
            t.setName(rs.getString("name"));
            t.setMaterial(rs.getString("material"));
            t.setBasePrice(rs.getDouble("base_price"));
            t.setImageUrl(rs.getString("image_url"));
            try { t.setCapacityKg(rs.getDouble("capacity_kg")); } catch (Exception ignored) {}
            try { t.setDescription(rs.getString("description")); } catch (Exception ignored) {}
            try { t.setStatus(rs.getBoolean("status")); } catch (Exception ignored) {}
            return t;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
