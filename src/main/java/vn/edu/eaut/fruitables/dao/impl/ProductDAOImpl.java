package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IProductDAO;
import vn.edu.eaut.fruitables.mapper.ProductMapper;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import java.util.List;
import java.util.ArrayList;

public class ProductDAOImpl extends AbstractDAO<ProductModel> implements IProductDAO {

    private final String BASE_SQL = "SELECT p.*, c.name AS category_name, " +
            "(SELECT COALESCE(AVG(rating), 0) FROM reviews WHERE product_id = p.id) AS avg_rating, " +
            "(SELECT COUNT(*) FROM reviews WHERE product_id = p.id) AS review_count, " +
            "(SELECT COALESCE(SUM(od.quantity), 0) FROM order_details od " +
            " JOIN orders o ON od.order_id = o.id " +
            " WHERE od.product_id = p.id AND o.status NOT IN ('CANCELLED')) AS total_sold " +
            "FROM products p LEFT JOIN categories c ON p.category_id = c.id";

    @Override
    public List<ProductModel> findAll() {
        String sql = BASE_SQL + " ORDER BY p.id DESC";
        return query(sql, new ProductMapper());
    }

    @Override
    public Long save(ProductModel product) {
        String sql = "INSERT INTO products (category_id, name, slug, description, detailed_description, price, tax_rate, discount_price, stock, image_url, status, weight_gram, storage_type, is_free_shipping) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String baseSlug = (product.getName() != null ? product.getName().toLowerCase().trim().replaceAll("[^a-zA-Z0-9\\u00C0-\\u1EF9]+", "-") : "product");
        String slug = baseSlug + "-" + (System.currentTimeMillis() % 1000000);
        return insert(sql,
                product.getCategoryId(), product.getName(), slug,
                product.getDescription(), product.getDetailedDescription(), product.getPrice(), product.getTaxRate(), product.getDiscountPrice(), product.getStock(),
                product.getImageUrl(), product.getStatus(),
                product.getWeightGram() != null ? product.getWeightGram() : 500,
                product.getStorageType() != null ? product.getStorageType() : "NORMAL",
                Boolean.TRUE.equals(product.getIsFreeShipping()) ? 1 : 0);
    }

    @Override
    public void updateProduct(ProductModel product) {
        int weight = product.getWeightGram() != null ? product.getWeightGram() : 500;
        String storage = product.getStorageType() != null ? product.getStorageType() : "NORMAL";
        int freeship = Boolean.TRUE.equals(product.getIsFreeShipping()) ? 1 : 0;

        if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) {
            String sql = "UPDATE products SET category_id = ?, name = ?, slug = ?, description = ?, detailed_description = ?, price = ?, tax_rate = ?, discount_price = ?, stock = ?, image_url = ?, status = ?, weight_gram = ?, storage_type = ?, is_free_shipping = ? WHERE id = ?";
            update(sql, product.getCategoryId(), product.getName(), product.getName().toLowerCase().replaceAll("\\s+", "-"),
                    product.getDescription(), product.getDetailedDescription(), product.getPrice(), product.getTaxRate(), product.getDiscountPrice(), product.getStock(), product.getImageUrl(), product.getStatus(), weight, storage, freeship, product.getId());
        } else {
            String sql = "UPDATE products SET category_id = ?, name = ?, slug = ?, description = ?, detailed_description = ?, price = ?, tax_rate = ?, discount_price = ?, stock = ?, status = ?, weight_gram = ?, storage_type = ?, is_free_shipping = ? WHERE id = ?";
            update(sql, product.getCategoryId(), product.getName(), product.getName().toLowerCase().replaceAll("\\s+", "-"),
                    product.getDescription(), product.getDetailedDescription(), product.getPrice(), product.getTaxRate(), product.getDiscountPrice(), product.getStock(), product.getStatus(), weight, storage, freeship, product.getId());
        }
    }

    @Override
    public List<ProductModel> findByCategory(Integer categoryId) {
        String sql = BASE_SQL + " WHERE p.category_id = ? ORDER BY p.id DESC";
        return query(sql, new ProductMapper(), categoryId);
    }

    @Override
    public List<ProductModel> findFlashSaleProducts(int limit) {
        String sql = BASE_SQL + " WHERE p.discount_price IS NOT NULL AND p.discount_price > 0 AND p.status = 1 ORDER BY p.id DESC LIMIT ?";
        return query(sql, new ProductMapper(), limit);
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
        String sql = "SELECT p.*, c.name AS category_name, " +
                "(SELECT COALESCE(AVG(rating), 0) FROM reviews WHERE product_id = p.id) AS avg_rating, " +
                "(SELECT COUNT(*) FROM reviews WHERE product_id = p.id) AS review_count, " +
                "(SELECT COALESCE(SUM(od.quantity), 0) FROM order_details od " +
                " JOIN orders o ON od.order_id = o.id " +
                " WHERE od.product_id = p.id AND o.status NOT IN ('CANCELLED')) AS total_sold " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "WHERE p.status = 1 " +
                "ORDER BY total_sold DESC, review_count DESC, avg_rating DESC, p.id DESC " +
                "LIMIT ?";
        return query(sql, new ProductMapper(), limit);
    }

    @Override
    public List<ProductModel> filterProducts(String keyword, Integer categoryId, String sortOption) {
        return filterProducts(keyword, categoryId, sortOption, null, null);
    }

    @Override
    public List<ProductModel> filterProducts(String keyword, Integer categoryId, String sortOption, Double minPrice, Double maxPrice) {
        StringBuilder sql = new StringBuilder(BASE_SQL + " WHERE p.status = 1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND p.name LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }

        if (categoryId != null) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }

        if (minPrice != null && minPrice > 0) {
            sql.append("AND (CASE WHEN (p.discount_price IS NOT NULL AND p.discount_price > 0) THEN p.discount_price ELSE p.price END) >= ? ");
            params.add(minPrice);
        }

        if (maxPrice != null && maxPrice > 0) {
            sql.append("AND (CASE WHEN (p.discount_price IS NOT NULL AND p.discount_price > 0) THEN p.discount_price ELSE p.price END) <= ? ");
            params.add(maxPrice);
        }

        if ("price_asc".equals(sortOption)) {
            sql.append("ORDER BY (CASE WHEN (p.discount_price IS NOT NULL AND p.discount_price > 0) THEN p.discount_price ELSE p.price END) ASC");
        } else if ("price_desc".equals(sortOption)) {
            sql.append("ORDER BY (CASE WHEN (p.discount_price IS NOT NULL AND p.discount_price > 0) THEN p.discount_price ELSE p.price END) DESC");
        } else {
            sql.append("ORDER BY p.id DESC");
        }

        return query(sql.toString(), new ProductMapper(), params.toArray());
    }

    @Override
    public List<ProductModel> adminSearchAndFilter(String keyword, Integer categoryId, String status, String stockStatus, String storageType, String sortOption, Double minPrice, Double maxPrice) {
        StringBuilder sql = new StringBuilder(BASE_SQL + " WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        // 1. Tìm kiếm theo từ khóa (Tên sản phẩm hoặc Mã sản phẩm #PRD-...)
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim();
            if (kw.toUpperCase().startsWith("#PRD-")) {
                kw = kw.substring(5);
            }
            try {
                long prdId = Long.parseLong(kw);
                sql.append("AND (p.id = ? OR p.name LIKE ?) ");
                params.add(prdId);
                params.add("%" + keyword.trim() + "%");
            } catch (NumberFormatException e) {
                sql.append("AND p.name LIKE ? ");
                params.add("%" + kw + "%");
            }
        }

        // 2. Lọc theo danh mục
        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }

        // 3. Lọc theo trạng thái mở bán
        if ("ACTIVE".equalsIgnoreCase(status)) {
            sql.append("AND p.status = 1 ");
        } else if ("INACTIVE".equalsIgnoreCase(status)) {
            sql.append("AND p.status = 0 ");
        }

        // 4. Lọc theo mức độ tồn kho
        if ("IN_STOCK".equalsIgnoreCase(stockStatus)) {
            sql.append("AND p.stock > 20 ");
        } else if ("LOW_STOCK".equalsIgnoreCase(stockStatus)) {
            sql.append("AND p.stock > 0 AND p.stock <= 20 ");
        } else if ("OUT_OF_STOCK".equalsIgnoreCase(stockStatus)) {
            sql.append("AND p.stock <= 0 ");
        }

        // 5. Lọc theo quy cách bảo quản & vận chuyển
        if ("COLD_CHAIN".equalsIgnoreCase(storageType)) {
            sql.append("AND p.storage_type = 'COLD_CHAIN' ");
        } else if ("FRAGILE_GIFT".equalsIgnoreCase(storageType)) {
            sql.append("AND p.storage_type = 'FRAGILE_GIFT' ");
        } else if ("FREE_SHIPPING".equalsIgnoreCase(storageType)) {
            sql.append("AND p.is_free_shipping = 1 ");
        } else if ("NORMAL".equalsIgnoreCase(storageType)) {
            sql.append("AND (p.storage_type = 'NORMAL' OR p.storage_type IS NULL) ");
        }

        // 6. Khoảng giá
        if (minPrice != null && minPrice > 0) {
            sql.append("AND (CASE WHEN (p.discount_price IS NOT NULL AND p.discount_price > 0) THEN p.discount_price ELSE p.price END) >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null && maxPrice > 0) {
            sql.append("AND (CASE WHEN (p.discount_price IS NOT NULL AND p.discount_price > 0) THEN p.discount_price ELSE p.price END) <= ? ");
            params.add(maxPrice);
        }

        // 7. Sắp xếp thứ tự
        if ("price_asc".equalsIgnoreCase(sortOption)) {
            sql.append("ORDER BY (CASE WHEN (p.discount_price IS NOT NULL AND p.discount_price > 0) THEN p.discount_price ELSE p.price END) ASC");
        } else if ("price_desc".equalsIgnoreCase(sortOption)) {
            sql.append("ORDER BY (CASE WHEN (p.discount_price IS NOT NULL AND p.discount_price > 0) THEN p.discount_price ELSE p.price END) DESC");
        } else if ("stock_asc".equalsIgnoreCase(sortOption)) {
            sql.append("ORDER BY p.stock ASC");
        } else if ("stock_desc".equalsIgnoreCase(sortOption)) {
            sql.append("ORDER BY p.stock DESC");
        } else if ("name_asc".equalsIgnoreCase(sortOption)) {
            sql.append("ORDER BY p.name ASC");
        } else if ("oldest".equalsIgnoreCase(sortOption)) {
            sql.append("ORDER BY p.id ASC");
        } else {
            sql.append("ORDER BY p.id DESC");
        }

        return query(sql.toString(), new ProductMapper(), params.toArray());
    }

    @Override
    public java.util.Map<String, Object> getProductStats() {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        String sql = "SELECT " +
                "COUNT(*) as total_count, " +
                "COALESCE(SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END), 0) as active_count, " +
                "COALESCE(SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END), 0) as inactive_count, " +
                "COALESCE(SUM(CASE WHEN stock > 20 THEN 1 ELSE 0 END), 0) as in_stock_count, " +
                "COALESCE(SUM(CASE WHEN stock > 0 AND stock <= 20 THEN 1 ELSE 0 END), 0) as low_stock_count, " +
                "COALESCE(SUM(CASE WHEN stock <= 0 THEN 1 ELSE 0 END), 0) as out_of_stock_count, " +
                "COALESCE(SUM(CASE WHEN storage_type = 'COLD_CHAIN' THEN 1 ELSE 0 END), 0) as cold_chain_count, " +
                "COALESCE(SUM(CASE WHEN is_free_shipping = 1 THEN 1 ELSE 0 END), 0) as free_shipping_count " +
                "FROM products";

        try (java.sql.Connection conn = vn.edu.eaut.fruitables.util.DBConnectionUtil.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql);
             java.sql.ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("totalCount", rs.getInt("total_count"));
                stats.put("activeCount", rs.getInt("active_count"));
                stats.put("inactiveCount", rs.getInt("inactive_count"));
                stats.put("inStockCount", rs.getInt("in_stock_count"));
                stats.put("lowStockCount", rs.getInt("low_stock_count"));
                stats.put("outOfStockCount", rs.getInt("out_of_stock_count"));
                stats.put("coldChainCount", rs.getInt("cold_chain_count"));
                stats.put("freeShippingCount", rs.getInt("free_shipping_count"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    @Override
    public boolean deleteProduct(Long id) {
        if (id == null) return false;
        try {
            update("DELETE FROM products WHERE id = ?", id);
            return true;
        } catch (Exception e) {
            // Nếu bị ràng buộc bởi order_details, chuyển sang ngừng bán (soft delete)
            update("UPDATE products SET status = 0 WHERE id = ?", id);
            return true;
        }
    }

    @Override
    public boolean toggleProductStatus(Long id) {
        if (id == null) return false;
        try {
            update("UPDATE products SET status = (CASE WHEN status = 1 THEN 0 ELSE 1 END) WHERE id = ?", id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}