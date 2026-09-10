package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.ICategoryDAO;
import vn.edu.eaut.fruitables.mapper.CategoryMapper;
import vn.edu.eaut.fruitables.model.entity.CategoryModel;
import java.util.List;

public class CategoryDAOImpl extends AbstractDAO<CategoryModel> implements ICategoryDAO {
    @Override
    public List<CategoryModel> findAll() {
        String sql = "SELECT c.*, (SELECT COUNT(*) FROM products WHERE category_id = c.id AND status = 1) AS product_count " +
                     "FROM categories c WHERE c.status = 1 ORDER BY c.id ASC";
        return query(sql, new CategoryMapper());
    }

    @Override
    public Long save(CategoryModel category) {
        String sql = "INSERT INTO categories (name, tax_rate, status) VALUES (?, ?, ?)";
        return insert(sql, category.getName(), category.getTaxRate(), category.getStatus());
    }

    @Override
    public CategoryModel findById(Integer id) {
        String sql = "SELECT * FROM categories WHERE id = ?";
        List<CategoryModel> list = query(sql, new CategoryMapper(), id);
        return (list != null && !list.isEmpty()) ? list.get(0) : null;
    }

    @Override
    public boolean update(CategoryModel category) {
        String sql = "UPDATE categories SET name = ?, tax_rate = ?, status = ? WHERE id = ?";
        try {
            update(sql, category.getName(), category.getTaxRate(), category.getStatus(), category.getId());
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}