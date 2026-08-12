package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IProductDAO;
import vn.edu.eaut.fruitables.mapper.ProductMapper;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import java.util.List;
import java.util.ArrayList;

public class ProductDAOImpl extends AbstractDAO<ProductModel> implements IProductDAO {

    // Câu SQL cơ bản: JOIN với bảng categories để lấy category_name hiển thị ra UI
    private final String BASE_SQL = "SELECT p.*, c.name AS category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id";

    @Override
    public List<ProductModel> findAll() {
        String sql = BASE_SQL + " ORDER BY p.id DESC";
        return query(sql, new ProductMapper());
    }
    @Override
    public Long save(ProductModel product) {
        String sql = "INSERT INTO products (category_id, name, slug, description, price, stock, image_url, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        // Hàm insert đã được định nghĩa sẵn trong AbstractDAO
        return insert(sql,
                product.getCategoryId(),
                product.getName(),
                product.getName().toLowerCase().replaceAll("\\s+", "-"), // Tạo slug
                product.getDescription(),
                product.getPrice(),
                product.getStock(),
                product.getImageUrl(),
                product.getStatus());
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

    @Override
    public List<ProductModel> filterProducts(String keyword, Integer categoryId, String sortOption) {
        StringBuilder sql = new StringBuilder("SELECT p.*, c.name AS category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id WHERE p.status = 1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND p.name LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }

        if (categoryId != null) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }

        // Xử lý sắp xếp
        if ("price_asc".equals(sortOption)) {
            sql.append("ORDER BY p.price ASC");
        } else if ("price_desc".equals(sortOption)) {
            sql.append("ORDER BY p.price DESC");
        } else {
            sql.append("ORDER BY p.id DESC");
        }

        return query(sql.toString(), new ProductMapper(), params.toArray());
    }
}