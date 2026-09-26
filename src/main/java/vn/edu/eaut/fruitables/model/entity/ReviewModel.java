package vn.edu.eaut.fruitables.model.entity;
import java.sql.Timestamp;

public class ReviewModel {
    private Long id;
    private Long userId;
    private Long productId;
    private Long orderId;
    private Integer rating;
    private String comment;
    private Timestamp createdAt;

    private String userName;
    private String avatarUrl;
    private String imageUrl;



    // AI & Store Reply Fields
    private String reply;
    private String replyBy; // 'AI_AGENT' or 'ADMIN'
    private Timestamp replyAt;
    private String sentiment; // 'POSITIVE', 'NEGATIVE', 'NEUTRAL'
    private Boolean isReported;

    // Additional display fields
    private String productName;
    private String productImage;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }

    public String getReplyBy() { return replyBy; }
    public void setReplyBy(String replyBy) { this.replyBy = replyBy; }

    public Timestamp getReplyAt() { return replyAt; }
    public void setReplyAt(Timestamp replyAt) { this.replyAt = replyAt; }

    public String getSentiment() { return sentiment; }
    public void setSentiment(String sentiment) { this.sentiment = sentiment; }

    public Boolean getIsReported() { return isReported; }
    public void setIsReported(Boolean isReported) { this.isReported = isReported; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }
}