package vn.edu.eaut.fruitables.service;

import vn.edu.eaut.fruitables.model.entity.UserModel;

public interface IUserService {
    UserModel login(String email, String password);
    UserModel register(UserModel userModel);
}