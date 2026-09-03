package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.UserModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserMapper implements IRowMapper<UserModel> {
    @Override
    public UserModel mapRow(ResultSet rs) {
        try {
            UserModel user = new UserModel();
            user.setId(rs.getLong("id"));
            user.setRoleId(rs.getInt("role_id"));
            user.setFullName(rs.getString("full_name"));
            user.setEmail(rs.getString("email"));
            user.setPasswordHash(rs.getString("password_hash"));
            user.setPhone(rs.getString("phone"));
            user.setAddress(rs.getString("address"));
            user.setStatus(rs.getString("status"));
            user.setCreatedAt(rs.getTimestamp("created_at"));

            try {
                user.setLoginType(rs.getString("login_type"));
            } catch (SQLException e) {}

            try {
                user.setAvatarUrl(rs.getString("avatar_url"));
            } catch (SQLException e) {}

            return user;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}