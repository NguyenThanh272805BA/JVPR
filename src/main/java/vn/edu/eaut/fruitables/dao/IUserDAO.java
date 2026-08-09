package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.UserModel;

public interface IUserDAO extends GenericDAO<UserModel> {
    UserModel findByEmail(String email);
    Long save(UserModel userModel);
}