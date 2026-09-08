package vn.edu.eaut.fruitables.dao;
import vn.edu.eaut.fruitables.model.entity.CategoryModel;
import java.util.List;

public interface ICategoryDAO extends GenericDAO<CategoryModel> {
    List<CategoryModel> findAll();
    Long save(CategoryModel categoryModel);
    CategoryModel findById(Integer id);
    boolean update(CategoryModel categoryModel);
}