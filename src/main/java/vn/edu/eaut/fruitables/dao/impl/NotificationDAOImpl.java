package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.INotificationDAO;
import vn.edu.eaut.fruitables.model.entity.NotificationModel;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAOImpl extends AbstractDAO<NotificationModel> implements INotificationDAO {

    @Override
    public List<NotificationModel> findByUserId(Long userId) {
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT 20";
        List<NotificationModel> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    NotificationModel notif = new NotificationModel();
                    notif.setId(rs.getLong("id"));
                    notif.setUserId(rs.getLong("user_id"));
                    notif.setOrderId(rs.getObject("order_id") != null ? rs.getLong("order_id") : null);
                    notif.setOrderCode(rs.getString("order_code"));
                    notif.setTitle(rs.getString("title"));
                    notif.setMessage(rs.getString("message"));
                    notif.setType(rs.getString("type"));
                    notif.setIsRead(rs.getBoolean("is_read"));
                    notif.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(notif);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<NotificationModel> findByUserId(Long userId, int limit) {
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
        List<NotificationModel> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setInt(2, limit > 0 ? limit : 20);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    NotificationModel notif = new NotificationModel();
                    notif.setId(rs.getLong("id"));
                    notif.setUserId(rs.getLong("user_id"));
                    notif.setOrderId(rs.getObject("order_id") != null ? rs.getLong("order_id") : null);
                    notif.setOrderCode(rs.getString("order_code"));
                    notif.setTitle(rs.getString("title"));
                    notif.setMessage(rs.getString("message"));
                    notif.setType(rs.getString("type"));
                    notif.setIsRead(rs.getBoolean("is_read"));
                    notif.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(notif);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countUnreadByUserId(Long userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";
        return count(sql, userId);
    }

    @Override
    public int countUnread(Long userId) {
        return countUnreadByUserId(userId);
    }

    @Override
    public Long insertNotification(NotificationModel notif) {
        String sql = "INSERT INTO notifications (user_id, order_id, order_code, title, message, type, is_read) VALUES (?, ?, ?, ?, ?, ?, ?)";
        return insert(sql, notif.getUserId(), notif.getOrderId(), notif.getOrderCode(), notif.getTitle(), notif.getMessage(), notif.getType(), notif.getIsRead() != null && notif.getIsRead());
    }

    @Override
    public Long createNotification(Long userId, Long orderId, String orderCode, String title, String message, String type) {
        NotificationModel notif = new NotificationModel();
        notif.setUserId(userId);
        notif.setOrderId(orderId);
        notif.setOrderCode(orderCode);
        notif.setTitle(title);
        notif.setMessage(message);
        notif.setType(type);
        notif.setIsRead(false);
        return insertNotification(notif);
    }

    @Override
    public void markAsRead(Long id, Long userId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?";
        update(sql, id, userId);
    }

    @Override
    public void markAllAsRead(Long userId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        update(sql, userId);
    }
}
