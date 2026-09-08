package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IUserDAO;
import vn.edu.eaut.fruitables.mapper.UserMapper;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

    @Override
    public java.util.Map<String, Object> getUserStats() {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        String sql = "SELECT " +
                "COUNT(*) as total_users, " +
                "SUM(CASE WHEN DATE(created_at) = CURDATE() THEN 1 ELSE 0 END) as new_today, " +
                "SUM(CASE WHEN DATE(created_at) = SUBDATE(CURDATE(), 1) THEN 1 ELSE 0 END) as new_yesterday, " +
                "SUM(CASE WHEN created_at >= NOW() - INTERVAL 7 DAY THEN 1 ELSE 0 END) as new_this_week, " +
                "SUM(CASE WHEN created_at >= NOW() - INTERVAL 14 DAY AND created_at < NOW() - INTERVAL 7 DAY THEN 1 ELSE 0 END) as new_last_week, " +
                "SUM(CASE WHEN login_type = 'GOOGLE' THEN 1 ELSE 0 END) as google_count, " +
                "SUM(CASE WHEN login_type = 'LOCAL' THEN 1 ELSE 0 END) as local_count, " +
                "SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) as active_count, " +
                "SUM(CASE WHEN status = 'LOCKED' THEN 1 ELSE 0 END) as locked_count " +
                "FROM users";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int totalUsers = rs.getInt("total_users");
                int newToday = rs.getInt("new_today");
                int newYesterday = rs.getInt("new_yesterday");
                int newThisWeek = rs.getInt("new_this_week");
                int newLastWeek = rs.getInt("new_last_week");
                int googleCount = rs.getInt("google_count");
                int localCount = rs.getInt("local_count");
                int activeCount = rs.getInt("active_count");
                int lockedCount = rs.getInt("locked_count");

                double todayGrowth = (newYesterday > 0) ? (((double) (newToday - newYesterday)) / newYesterday * 100.0) : (newToday > 0 ? 100.0 : 0.0);
                double weekGrowth = (newLastWeek > 0) ? (((double) (newThisWeek - newLastWeek)) / newLastWeek * 100.0) : (newThisWeek > 0 ? 100.0 : 0.0);

                stats.put("totalUsers", totalUsers);
                stats.put("newToday", newToday);
                stats.put("newYesterday", newYesterday);
                stats.put("newThisWeek", newThisWeek);
                stats.put("newLastWeek", newLastWeek);
                stats.put("todayGrowth", Math.round(todayGrowth * 10.0) / 10.0);
                stats.put("weekGrowth", Math.round(weekGrowth * 10.0) / 10.0);
                stats.put("googleCount", googleCount);
                stats.put("localCount", localCount);
                stats.put("activeCount", activeCount);
                stats.put("lockedCount", lockedCount);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    @Override
    public java.util.Map<String, Object> getUserGrowthChartData(String filter) {
        java.util.Map<String, Object> result = new java.util.LinkedHashMap<>();
        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<Integer> currentData = new java.util.ArrayList<>();
        java.util.List<Integer> previousData = new java.util.ArrayList<>();

        if ("week".equals(filter)) {
            labels = java.util.Arrays.asList("4 tuần trước", "3 tuần trước", "2 tuần trước", "Tuần này");
            for (int i = 3; i >= 0; i--) {
                String sqlCur = "SELECT COUNT(*) FROM users WHERE created_at >= NOW() - INTERVAL " + ((i + 1) * 7) + " DAY AND created_at < NOW() - INTERVAL " + (i * 7) + " DAY";
                String sqlPrev = "SELECT COUNT(*) FROM users WHERE created_at >= NOW() - INTERVAL " + ((i + 5) * 7) + " DAY AND created_at < NOW() - INTERVAL " + ((i + 4) * 7) + " DAY";
                currentData.add(executeCountQuery(sqlCur));
                previousData.add(executeCountQuery(sqlPrev));
            }
        } else if ("month".equals(filter)) {
            labels = java.util.Arrays.asList("T-5 tháng", "T-4 tháng", "T-3 tháng", "T-2 tháng", "T-1 tháng", "Tháng này");
            for (int i = 5; i >= 0; i--) {
                String sqlCur = "SELECT COUNT(*) FROM users WHERE created_at >= NOW() - INTERVAL " + (i + 1) + " MONTH AND created_at < NOW() - INTERVAL " + i + " MONTH";
                String sqlPrev = "SELECT COUNT(*) FROM users WHERE created_at >= NOW() - INTERVAL " + (i + 7) + " MONTH AND created_at < NOW() - INTERVAL " + (i + 6) + " MONTH";
                currentData.add(executeCountQuery(sqlCur));
                previousData.add(executeCountQuery(sqlPrev));
            }
        } else {
            // Mặc định: 7 ngày gần nhất
            for (int i = 6; i >= 0; i--) {
                labels.add("T-" + i + " ngày");
                String sqlCur = "SELECT COUNT(*) FROM users WHERE DATE(created_at) = SUBDATE(CURDATE(), " + i + ")";
                String sqlPrev = "SELECT COUNT(*) FROM users WHERE DATE(created_at) = SUBDATE(CURDATE(), " + (i + 7) + ")";
                currentData.add(executeCountQuery(sqlCur));
                previousData.add(executeCountQuery(sqlPrev));
            }
        }

        int curTotal = 0; for (Integer n : currentData) curTotal += n;
        int prevTotal = 0; for (Integer n : previousData) prevTotal += n;
        double growthRate = (prevTotal > 0) ? Math.round(((double)(curTotal - prevTotal) / prevTotal * 100.0) * 10.0) / 10.0 : (curTotal > 0 ? 100.0 : 0.0);

        result.put("labels", labels);
        result.put("currentData", currentData);
        result.put("previousData", previousData);
        result.put("curTotal", curTotal);
        result.put("prevTotal", prevTotal);
        result.put("growthRate", growthRate);

        return result;
    }

    private int executeCountQuery(String sql) {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public java.util.List<UserModel> searchAndFilterUsers(String keyword, Integer roleId, String status, String loginType) {
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1 ");
        java.util.List<Object> params = new java.util.ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (full_name LIKE ? OR email LIKE ? OR phone LIKE ? OR username LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (roleId != null && roleId > 0) {
            sql.append("AND role_id = ? ");
            params.add(roleId);
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND status = ? ");
            params.add(status.trim());
        }
        if (loginType != null && !loginType.trim().isEmpty() && !"ALL".equalsIgnoreCase(loginType)) {
            sql.append("AND login_type = ? ");
            params.add(loginType.trim());
        }

        sql.append("ORDER BY created_at DESC");
        return query(sql.toString(), new UserMapper(), params.toArray());
    }

    @Override
    public java.util.Map<String, Object> getUserPurchaseSummary(Long userId) {
        java.util.Map<String, Object> summary = new java.util.HashMap<>();
        String sql = "SELECT COUNT(*) as order_count, " +
                "COALESCE(SUM(CASE WHEN payment_status = 'PAID' OR status = 'COMPLETED' THEN total_amount ELSE 0 END), 0) as total_spent, " +
                "MAX(created_at) as last_order_date " +
                "FROM orders WHERE user_id = ?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    summary.put("orderCount", rs.getInt("order_count"));
                    summary.put("totalSpent", rs.getDouble("total_spent"));
                    summary.put("lastOrderDate", rs.getTimestamp("last_order_date"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return summary;
    }
}