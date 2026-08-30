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

    // =================================================================
    // TÍNH NĂNG QUẢN LÝ NGƯỜI DÙNG (ADMIN)
    // =================================================================

    // Lấy danh sách toàn bộ người dùng
    public List<UserModel> findAllUsers() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        return query(sql, new UserMapper());
    }

    // Cập nhật quyền và trạng thái (Block/Active)
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
}