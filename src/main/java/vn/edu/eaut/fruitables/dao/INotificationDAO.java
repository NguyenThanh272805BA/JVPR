package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.NotificationModel;
import java.util.List;

public interface INotificationDAO extends GenericDAO<NotificationModel> {
    List<NotificationModel> findByUserId(Long userId);
    List<NotificationModel> findByUserId(Long userId, int limit);
    int countUnreadByUserId(Long userId);
    int countUnread(Long userId);
    Long insertNotification(NotificationModel notif);
    Long createNotification(Long userId, Long orderId, String orderCode, String title, String message, String type);
    void markAsRead(Long id, Long userId);
    void markAllAsRead(Long userId);
}
