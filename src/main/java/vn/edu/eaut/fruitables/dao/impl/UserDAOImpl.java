package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IUserDAO;
import vn.edu.eaut.fruitables.mapper.UserMapper;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

public class UserDAOImpl extends AbstractDAO<UserModel> implements IUserDAO {

    @Override
    public UserModel findById(Long id) {
        if (id == null) return null;
        String sql = "SELECT * FROM users WHERE id = ?";
        List<UserModel> users = query(sql, new UserMapper(), id);
        return users.isEmpty() ? null : users.get(0);
    }

    @Override
    public UserModel findByUsernameOrPhoneOrEmail(String identifier) {
        String sql = "SELECT * FROM users WHERE username = ? OR phone = ? OR email = ?";
        List<UserModel> users = query(sql, new UserMapper(), identifier, identifier, identifier);
        return users.isEmpty() ? null : users.get(0);
    }

    @Override
    public Long save(UserModel userModel) {
        // Hỗ trợ đăng ký không bắt buộc email. Nếu email trống sẽ insert NULL để không vi phạm ràng buộc UNIQUE.
        String emailToSave = (userModel.getEmail() != null && !userModel.getEmail().trim().isEmpty()) ? userModel.getEmail() : null;

        String sql = "INSERT INTO users (role_id, username, full_name, email, password_hash, phone, status) VALUES (3, ?, ?, ?, ?, ?, 'ACTIVE')";
        return insert(sql, userModel.getUsername(), userModel.getFullName(), emailToSave, userModel.getPasswordHash(), userModel.getPhone());
    }

    public List<UserModel> findAllUsers() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        return query(sql, new UserMapper());
    }

    public boolean updateUserRoleAndStatus(Long userId, Integer roleId, String status) {
        String sql = "UPDATE users SET role_id = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setString(2, status);
            ps.setLong(3, userId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public UserModel findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) return null;
        String sql = "SELECT * FROM users WHERE email = ?";
        List<UserModel> users = query(sql, new UserMapper(), email.trim());
        return users.isEmpty() ? null : users.get(0);
    }

    @Override
    public int countByPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) return 0;
        String sql = "SELECT COUNT(*) FROM users WHERE phone = ?";
        return count(sql, phone.trim());
    }

    @Override
    public boolean existsByUsername(String username) {
        if (username == null || username.trim().isEmpty()) return false;
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        return count(sql, username.trim()) > 0;
    }

    @Override
    public boolean existsByEmail(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        return count(sql, email.trim()) > 0;
    }

    @Override
    public boolean updatePasswordByEmail(String email, String newPasswordHash) {
        if (email == null || email.trim().isEmpty() || newPasswordHash == null) return false;
        String sql = "UPDATE users SET password_hash = ? WHERE email = ?";
        try {
            update(sql, newPasswordHash, email.trim());
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}