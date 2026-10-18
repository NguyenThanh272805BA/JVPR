package vn.edu.eaut.fruitables.model.dto;

public class LuckySpinResult {
    private boolean success;
    private String message;
    private Integer prizeIndex;
    private Integer prizeId;
    private String prizeName;
    private String prizeType;
    private String rewardCode;
    private Double discountValue;
    private Double minOrderValue;
    private Integer remainingSpins;
    private Double targetDegree;

    public LuckySpinResult() {}

    public static LuckySpinResult fail(String message, int remainingSpins) {
        LuckySpinResult r = new LuckySpinResult();
        r.setSuccess(false);
        r.setMessage(message);
        r.setRemainingSpins(remainingSpins);
        return r;
    }

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Integer getPrizeIndex() { return prizeIndex; }
    public void setPrizeIndex(Integer prizeIndex) { this.prizeIndex = prizeIndex; }

    public Integer getPrizeId() { return prizeId; }
    public void setPrizeId(Integer prizeId) { this.prizeId = prizeId; }

    public String getPrizeName() { return prizeName; }
    public void setPrizeName(String prizeName) { this.prizeName = prizeName; }

    public String getPrizeType() { return prizeType; }
    public void setPrizeType(String prizeType) { this.prizeType = prizeType; }

    public String getRewardCode() { return rewardCode; }
    public void setRewardCode(String rewardCode) { this.rewardCode = rewardCode; }

    public Double getDiscountValue() { return discountValue; }
    public void setDiscountValue(Double discountValue) { this.discountValue = discountValue; }

    public Double getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(Double minOrderValue) { this.minOrderValue = minOrderValue; }

    public Integer getRemainingSpins() { return remainingSpins; }
    public void setRemainingSpins(Integer remainingSpins) { this.remainingSpins = remainingSpins; }

    public Double getTargetDegree() { return targetDegree; }
    public void setTargetDegree(Double targetDegree) { this.targetDegree = targetDegree; }
}
