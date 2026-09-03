package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.UserModel;

public interface IUserDAO extends GenericDAO<UserModel> {
    UserModel findByUsernameOrPhoneOrEmail(String identifier);
    Long save(UserModel userModel);
}