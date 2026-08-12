package vn.edu.eaut.fruitables.service;

import vn.edu.eaut.fruitables.model.entity.ProductModel;
import java.util.List;

public interface IProductService {
    List<ProductModel> findAll();
    List<ProductModel> findByCategory(Integer categoryId);
    List<ProductModel> searchByName(String keyword);
    ProductModel findById(Long id);
    List<ProductModel> findTopProducts(int limit);
    List<ProductModel> filterProducts(String keyword, Integer categoryId, String sortOption);
    ProductModel save(ProductModel product);
    void updateProduct(ProductModel product);
}