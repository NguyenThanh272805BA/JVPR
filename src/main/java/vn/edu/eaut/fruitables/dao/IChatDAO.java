package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.ChatMessageModel;
import java.util.List;
import java.util.Map;

public interface IChatDAO extends GenericDAO<ChatMessageModel> {
    List<ChatMessageModel> findByUserId(Long userId);
    List<ChatMessageModel> findByUserId(Long userId, int limit);
    Long saveMessage(ChatMessageModel msg);
    Long sendMessage(Long userId, String senderType, Long adminId, String message);
    List<Map<String, Object>> findActiveConversations();
    List<Map<String, Object>> findActiveChatUsers();
    void markMessagesAsRead(Long userId, String readerType);
    void markAsReadByAdmin(Long userId);
    void markAsReadByUser(Long userId);
    int countUnreadForUser(Long userId);
    int countTotalUnreadForAdmin();
}
