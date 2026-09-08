package vn.edu.eaut.fruitables.service;
import vn.edu.eaut.fruitables.model.entity.CategoryModel;
import java.util.List;

public interface ICategoryService {
    List<CategoryModel> findAll();
    CategoryModel save(CategoryModel categoryModel);
    CategoryModel findById(Integer id);
    boolean update(CategoryModel categoryModel);
}