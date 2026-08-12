package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.CategoryModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CategoryMapper implements IRowMapper<CategoryModel> {
    @Override
    public CategoryModel mapRow(ResultSet rs) {
        try {
            CategoryModel category = new CategoryModel();
            category.setId(rs.getInt("id"));
            category.setName(rs.getString("name"));
            category.setTaxRate(rs.getDouble("tax_rate"));
            category.setStatus(rs.getBoolean("status"));
            category.setCreatedAt(rs.getTimestamp("created_at"));
            return category;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}