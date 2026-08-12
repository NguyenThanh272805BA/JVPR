package vn.edu.eaut.fruitables.service.impl;

import vn.edu.eaut.fruitables.dao.ICategoryDAO;
import vn.edu.eaut.fruitables.dao.impl.CategoryDAOImpl;
import vn.edu.eaut.fruitables.model.entity.CategoryModel;
import vn.edu.eaut.fruitables.service.ICategoryService;
import java.util.List;

public class CategoryServiceImpl implements ICategoryService {
    private ICategoryDAO categoryDAO;

    public CategoryServiceImpl() {
        this.categoryDAO = new CategoryDAOImpl();
    }

    @Override
    public List<CategoryModel> findAll() {
        return categoryDAO.findAll();
    }

    @Override
    public CategoryModel save(CategoryModel category) {
        Long newId = categoryDAO.save(category);
        if (newId != null) {
            category.setId(newId.intValue());
            return category;
        }
        return null;
    }
}