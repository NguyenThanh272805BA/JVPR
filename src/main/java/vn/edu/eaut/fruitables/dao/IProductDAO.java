package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.ProductModel;
import java.util.List;

public interface IProductDAO extends GenericDAO<ProductModel> {
    List<ProductModel> findAll();
    List<ProductModel> findByCategory(Integer categoryId);
    List<ProductModel> searchByName(String keyword);
    ProductModel findById(Long id);
    List<ProductModel> findTopProducts(int limit);
    List<ProductModel> filterProducts(String keyword, Integer categoryId, String sortOption);
    Long save(ProductModel product);
    void updateProduct(ProductModel product);
}