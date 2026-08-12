package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.ICategoryDAO;
import vn.edu.eaut.fruitables.mapper.CategoryMapper;
import vn.edu.eaut.fruitables.model.entity.CategoryModel;
import java.util.List;

public class CategoryDAOImpl extends AbstractDAO<CategoryModel> implements ICategoryDAO {
    @Override
    public List<CategoryModel> findAll() {
        String sql = "SELECT * FROM categories ORDER BY id DESC";
        return query(sql, new CategoryMapper());
    }

    @Override
    public Long save(CategoryModel category) {
        String sql = "INSERT INTO categories (name, tax_rate, status) VALUES (?, ?, ?)";
        return insert(sql, category.getName(), category.getTaxRate(), category.getStatus());
    }
}