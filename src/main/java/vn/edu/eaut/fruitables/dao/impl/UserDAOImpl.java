package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IUserDAO;
import vn.edu.eaut.fruitables.mapper.UserMapper;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import java.util.List;

public class UserDAOImpl extends AbstractDAO<UserModel> implements IUserDAO {

    @Override
    public UserModel findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        List<UserModel> users = query(sql, new UserMapper(), email);
        return users.isEmpty() ? null : users.get(0);
    }

    @Override
    public Long save(UserModel userModel) {
        // Tạm thời set role_id = 3 (Quyền USER thông thường)
        String sql = "INSERT INTO users (role_id, full_name, email, password_hash, status) VALUES (3, ?, ?, ?, 'ACTIVE')";
        return insert(sql, userModel.getFullName(), userModel.getEmail(), userModel.getPasswordHash());
    }
}