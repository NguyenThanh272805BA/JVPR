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
    List<ProductModel> filterProducts(String keyword, Integer categoryId, String sortOption, Double minPrice, Double maxPrice);
    ProductModel save(ProductModel product);
    void updateProduct(ProductModel product);
    List<ProductModel> findFlashSaleProducts(int limit);
    List<ProductModel> adminSearchAndFilter(String keyword, Integer categoryId, String status, String stockStatus, String storageType, String sortOption, Double minPrice, Double maxPrice);
    java.util.Map<String, Object> getProductStats();
    boolean deleteProduct(Long id);
    boolean toggleProductStatus(Long id);
}