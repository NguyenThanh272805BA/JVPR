package vn.edu.eaut.fruitables.model.entity;

import java.sql.Timestamp;

public class ChatMessageModel {
    private Long id;
    private Long userId;
    private String senderType; // 'USER' or 'ADMIN'
    private Long adminId;
    private String message;
    private Boolean isRead;
    private Timestamp createdAt;

    // Thuộc tính bổ sung để hiển thị UI
    private String userName;
    private String userAvatar;

    public ChatMessageModel() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getSenderType() { return senderType; }
    public void setSenderType(String senderType) { this.senderType = senderType; }

    public Long getAdminId() { return adminId; }
    public void setAdminId(Long adminId) { this.adminId = adminId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Boolean getIsRead() { return isRead; }
    public void setIsRead(Boolean isRead) { this.isRead = isRead; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserAvatar() { return userAvatar; }
    public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }
}
