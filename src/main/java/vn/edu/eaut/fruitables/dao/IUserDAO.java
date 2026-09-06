package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.UserModel;

public interface IUserDAO extends GenericDAO<UserModel> {
    UserModel findByUsernameOrPhoneOrEmail(String identifier);
    UserModel findByEmail(String email);
    Long save(UserModel userModel);
    int countByPhone(String phone);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    boolean updatePasswordByEmail(String email, String newPasswordHash);
}