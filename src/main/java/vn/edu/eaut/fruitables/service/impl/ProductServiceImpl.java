package vn.edu.eaut.fruitables.service.impl;

import vn.edu.eaut.fruitables.dao.IProductDAO;
import vn.edu.eaut.fruitables.dao.impl.ProductDAOImpl;
import vn.edu.eaut.fruitables.model.entity.ProductModel;
import vn.edu.eaut.fruitables.service.IProductService;
import java.util.List;

public class ProductServiceImpl implements IProductService {

    private IProductDAO productDAO;

    public ProductServiceImpl() {
        this.productDAO = new ProductDAOImpl();
    }

    @Override
    public List<ProductModel> findAll() {
        return productDAO.findAll();
    }

    @Override
    public List<ProductModel> findByCategory(Integer categoryId) {
        return productDAO.findByCategory(categoryId);
    }

    @Override
    public List<ProductModel> searchByName(String keyword) {
        return productDAO.searchByName(keyword);
    }

    @Override
    public ProductModel findById(Long id) {
        return productDAO.findById(id);
    }

    @Override
    public List<ProductModel> findTopProducts(int limit) {
        return productDAO.findTopProducts(limit);
    }
}