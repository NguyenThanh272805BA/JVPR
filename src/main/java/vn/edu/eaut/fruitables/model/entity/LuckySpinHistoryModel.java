package vn.edu.eaut.fruitables.model.entity;

import java.sql.Timestamp;

public class LuckySpinHistoryModel {
    private Long id;
    private Long userId;
    private String userName;
    private String userPhone;
    private Integer prizeId;
    private String prizeName;
    private String prizeType;
    private String rewardCode;
    private Double discountValue;
    private Boolean isUsed;
    private Timestamp usedAt;
    private Timestamp expiredAt;
    private Timestamp createdAt;

    public LuckySpinHistoryModel() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserPhone() { return userPhone; }
    public void setUserPhone(String userPhone) { this.userPhone = userPhone; }

    public Integer getPrizeId() { return prizeId; }
    public void setPrizeId(Integer prizeId) { this.prizeId = prizeId; }

    public String getPrizeName() { return prizeName; }
    public void setPrizeName(String prizeName) { this.prizeName = prizeName; }

    public String getPrizeType() { return prizeType; }
    public void setPrizeType(String prizeType) { this.prizeType = prizeType; }

    public String getRewardCode() { return rewardCode; }
    public void setRewardCode(String rewardCode) { this.rewardCode = rewardCode; }

    public Double getDiscountValue() { return discountValue != null ? discountValue : 0.0; }
    public void setDiscountValue(Double discountValue) { this.discountValue = discountValue; }

    public Boolean getIsUsed() { return isUsed != null ? isUsed : false; }
    public void setIsUsed(Boolean isUsed) { this.isUsed = isUsed; }

    public Timestamp getUsedAt() { return usedAt; }
    public void setUsedAt(Timestamp usedAt) { this.usedAt = usedAt; }

    public Timestamp getExpiredAt() { return expiredAt; }
    public void setExpiredAt(Timestamp expiredAt) { this.expiredAt = expiredAt; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isExpired() {
        if (expiredAt == null) return false;
        return System.currentTimeMillis() > expiredAt.getTime();
    }

    public String getStatusBadge() {
        if (Boolean.TRUE.equals(isUsed)) {
            return "ĐÃ DÙNG";
        }
        if (isExpired()) {
            return "HẾT HẠN";
        }
        return "CHƯA DÙNG";
    }
}
