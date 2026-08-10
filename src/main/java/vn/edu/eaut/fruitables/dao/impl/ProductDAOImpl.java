package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IProductDAO;
import vn.edu.eaut.fruitables.mapper.ProductMapper;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import java.util.List;

public class ProductDAOImpl extends AbstractDAO<ProductModel> implements IProductDAO {

    // Câu SQL cơ bản: JOIN với bảng categories để lấy category_name hiển thị ra UI
    private final String BASE_SQL = "SELECT p.*, c.name AS category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id";

    @Override
    public List<ProductModel> findAll() {
        String sql = BASE_SQL + " ORDER BY p.id DESC";
        return query(sql, new ProductMapper());
    }

    @Override
    public List<ProductModel> findByCategory(Integer categoryId) {
        String sql = BASE_SQL + " WHERE p.category_id = ? ORDER BY p.id DESC";
        return query(sql, new ProductMapper(), categoryId);
    }

    @Override
    public List<ProductModel> searchByName(String keyword) {
        String sql = BASE_SQL + " WHERE p.name LIKE ? ORDER BY p.id DESC";
        return query(sql, new ProductMapper(), "%" + keyword + "%");
    }

    @Override
    public ProductModel findById(Long id) {
        String sql = BASE_SQL + " WHERE p.id = ?";
        List<ProductModel> products = query(sql, new ProductMapper(), id);
        return products.isEmpty() ? null : products.get(0);
    }

    @Override
    public List<ProductModel> findTopProducts(int limit) {
        // Tạm thời lấy các sản phẩm mới nhất làm "Sản phẩm nổi bật"
        String sql = BASE_SQL + " ORDER BY p.id DESC LIMIT ?";
        return query(sql, new ProductMapper(), limit);
    }
}