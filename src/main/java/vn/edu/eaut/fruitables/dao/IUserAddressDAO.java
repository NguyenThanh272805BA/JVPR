package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.UserAddressModel;
import java.util.List;

public interface IUserAddressDAO {
    List<UserAddressModel> findByUserId(Long userId);
    UserAddressModel findById(Long id);
    UserAddressModel findDefaultByUserId(Long userId);
    Long save(UserAddressModel address);
    void update(UserAddressModel address);
    void setDefault(Long userId, Long addressId);
    void delete(Long id, Long userId);
}
