package vn.edu.eaut.fruitables.service.impl;

import vn.edu.eaut.fruitables.dao.IUserDAO;
import vn.edu.eaut.fruitables.dao.impl.UserDAOImpl;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.IUserService;
import vn.edu.eaut.fruitables.util.SecurityUtil;

public class UserServiceImpl implements IUserService {

    private IUserDAO userDAO;

    public UserServiceImpl() {
        this.userDAO = new UserDAOImpl();
    }

    @Override
    public UserModel login(String identifier, String password) {
        UserModel user = userDAO.findByUsernameOrPhoneOrEmail(identifier);
        if (user != null) {
            String hashInput = SecurityUtil.hashPassword(password);
            if (user.getPasswordHash().equals(hashInput)) {
                return user;
            }
        }
        return null;
    }

    @Override
    public UserModel register(UserModel userModel) {
        String hashedPassword = SecurityUtil.hashPassword(userModel.getPasswordHash());
        userModel.setPasswordHash(hashedPassword);

        Long newId = userDAO.save(userModel);
        if(newId != null) {
            userModel.setId(newId);
            return userModel;
        }
        return null;
    }
}