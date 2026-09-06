package vn.edu.eaut.fruitables.service;

import vn.edu.eaut.fruitables.model.entity.UserModel;

public interface IUserService {
    UserModel login(String identifier, String password);
    UserModel register(UserModel userModel);
    int countAccountsByPhone(String phone);
    boolean isUsernameTaken(String username);
    boolean isEmailTaken(String email);
    UserModel findByEmail(String email);
    boolean resetPassword(String email, String rawNewPassword);
}