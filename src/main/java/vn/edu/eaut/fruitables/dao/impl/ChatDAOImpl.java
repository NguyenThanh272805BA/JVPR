package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IChatDAO;
import vn.edu.eaut.fruitables.model.entity.ChatMessageModel;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

public class ChatDAOImpl extends AbstractDAO<ChatMessageModel> implements IChatDAO {

    @Override
    public List<ChatMessageModel> findByUserId(Long userId) {
        String sql = "SELECT cm.*, u.full_name, u.avatar_url " +
                     "FROM chat_messages cm " +
                     "JOIN users u ON cm.user_id = u.id " +
                     "WHERE cm.user_id = ? " +
                     "ORDER BY cm.created_at ASC";

        List<ChatMessageModel> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatMessageModel msg = new ChatMessageModel();
                    msg.setId(rs.getLong("id"));
                    msg.setUserId(rs.getLong("user_id"));
                    msg.setSenderType(rs.getString("sender_type"));
                    msg.setAdminId(rs.getObject("admin_id") != null ? rs.getLong("admin_id") : null);
                    msg.setMessage(rs.getString("message"));
                    msg.setIsRead(rs.getBoolean("is_read"));
                    msg.setCreatedAt(rs.getTimestamp("created_at"));
                    msg.setUserName(rs.getString("full_name"));
                    msg.setUserAvatar(rs.getString("avatar_url"));
                    list.add(msg);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<ChatMessageModel> findByUserId(Long userId, int limit) {
        String sql = "SELECT cm.*, u.full_name, u.avatar_url " +
                     "FROM chat_messages cm " +
                     "JOIN users u ON cm.user_id = u.id " +
                     "WHERE cm.user_id = ? " +
                     "ORDER BY cm.created_at ASC " +
                     "LIMIT ?";

        List<ChatMessageModel> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setInt(2, limit > 0 ? limit : 100);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatMessageModel msg = new ChatMessageModel();
                    msg.setId(rs.getLong("id"));
                    msg.setUserId(rs.getLong("user_id"));
                    msg.setSenderType(rs.getString("sender_type"));
                    msg.setAdminId(rs.getObject("admin_id") != null ? rs.getLong("admin_id") : null);
                    msg.setMessage(rs.getString("message"));
                    msg.setIsRead(rs.getBoolean("is_read"));
                    msg.setCreatedAt(rs.getTimestamp("created_at"));
                    msg.setUserName(rs.getString("full_name"));
                    msg.setUserAvatar(rs.getString("avatar_url"));
                    list.add(msg);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Long saveMessage(ChatMessageModel msg) {
        String sql = "INSERT INTO chat_messages (user_id, sender_type, admin_id, message, is_read) VALUES (?, ?, ?, ?, ?)";
        return insert(sql, msg.getUserId(), msg.getSenderType(), msg.getAdminId(), msg.getMessage(), msg.getIsRead() != null && msg.getIsRead());
    }

    @Override
    public Long sendMessage(Long userId, String senderType, Long adminId, String message) {
        ChatMessageModel msg = new ChatMessageModel();
        msg.setUserId(userId);
        msg.setSenderType(senderType);
        msg.setAdminId(adminId);
        msg.setMessage(message);
        msg.setIsRead(false);
        return saveMessage(msg);
    }

    @Override
    public List<Map<String, Object>> findActiveConversations() {
        String sql = "SELECT u.id AS user_id, u.full_name, u.avatar_url, u.email, u.phone, " +
                     "       m.last_message, m.last_time, m.last_sender, " +
                     "       COALESCE(unread.unread_count, 0) AS unread_count " +
                     "FROM users u " +
                     "JOIN ( " +
                     "    SELECT user_id, message AS last_message, created_at AS last_time, sender_type AS last_sender " +
                     "    FROM chat_messages " +
                     "    WHERE id IN (SELECT MAX(id) FROM chat_messages GROUP BY user_id) " +
                     ") m ON u.id = m.user_id " +
                     "LEFT JOIN ( " +
                     "    SELECT user_id, COUNT(*) AS unread_count " +
                     "    FROM chat_messages " +
                     "    WHERE sender_type = 'USER' AND is_read = 0 " +
                     "    GROUP BY user_id " +
                     ") unread ON u.id = unread.user_id " +
                     "ORDER BY unread_count DESC, m.last_time DESC";

        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("userId", rs.getLong("user_id"));
                map.put("fullName", rs.getString("full_name"));
                map.put("avatarUrl", rs.getString("avatar_url"));
                map.put("email", rs.getString("email"));
                map.put("phone", rs.getString("phone"));
                map.put("lastMessage", rs.getString("last_message"));
                map.put("lastTime", rs.getTimestamp("last_time"));
                map.put("lastSender", rs.getString("last_sender"));
                map.put("unreadCount", rs.getInt("unread_count"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Map<String, Object>> findActiveChatUsers() {
        return findActiveConversations();
    }

    @Override
    public void markMessagesAsRead(Long userId, String readerType) {
        String targetSender = "ADMIN".equalsIgnoreCase(readerType) ? "USER" : "ADMIN";
        String sql = "UPDATE chat_messages SET is_read = 1 WHERE user_id = ? AND sender_type = ? AND is_read = 0";
        update(sql, userId, targetSender);
    }

    @Override
    public void markAsReadByAdmin(Long userId) {
        markMessagesAsRead(userId, "ADMIN");
    }

    @Override
    public void markAsReadByUser(Long userId) {
        markMessagesAsRead(userId, "USER");
    }

    @Override
    public int countUnreadForUser(Long userId) {
        String sql = "SELECT COUNT(*) FROM chat_messages WHERE user_id = ? AND sender_type = 'ADMIN' AND is_read = 0";
        return count(sql, userId);
    }

    @Override
    public int countTotalUnreadForAdmin() {
        String sql = "SELECT COUNT(*) FROM chat_messages WHERE sender_type = 'USER' AND is_read = 0";
        return count(sql);
    }
}
