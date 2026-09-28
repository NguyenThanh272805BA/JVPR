package vn.edu.eaut.fruitables.model.dto;

import java.io.Serializable;

public class ClearanceRecommendationDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long productId;
    private String productName;
    private String imageUrl;
    private String categoryName;
    private Integer currentStock;
    private Double originalPrice;
    private Double suggestedDiscountPrice;
    private Integer discountPercent;
    private Integer daysInStock;
    private Double salesVelocityPerDay;
    private String spoilageRisk; // CRITICAL, HIGH, MEDIUM
    private String riskDescription;
    private String suggestedCouponCode;
    private Double estimatedWasteLoss;
    private Double recoverableCapital;
    private String actionType; // FLASH_SALE, BUNDLE_PROMO, VIP_BLAST
    private String agentReasoning;
    private String status; // PENDING, ACTIVATED

    public ClearanceRecommendationDTO() {}

    public ClearanceRecommendationDTO(Long productId, String productName, String imageUrl, String categoryName,
                                      Integer currentStock, Double originalPrice, Double suggestedDiscountPrice,
                                      Integer discountPercent, Integer daysInStock, Double salesVelocityPerDay,
                                      String spoilageRisk, String riskDescription, String suggestedCouponCode,
                                      Double estimatedWasteLoss, Double recoverableCapital, String actionType,
                                      String agentReasoning, String status) {
        this.productId = productId;
        this.productName = productName;
        this.imageUrl = imageUrl;
        this.categoryName = categoryName;
        this.currentStock = currentStock;
        this.originalPrice = originalPrice;
        this.suggestedDiscountPrice = suggestedDiscountPrice;
        this.discountPercent = discountPercent;
        this.daysInStock = daysInStock;
        this.salesVelocityPerDay = salesVelocityPerDay;
        this.spoilageRisk = spoilageRisk;
        this.riskDescription = riskDescription;
        this.suggestedCouponCode = suggestedCouponCode;
        this.estimatedWasteLoss = estimatedWasteLoss;
        this.recoverableCapital = recoverableCapital;
        this.actionType = actionType;
        this.agentReasoning = agentReasoning;
        this.status = status;
    }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public Integer getCurrentStock() { return currentStock; }
    public void setCurrentStock(Integer currentStock) { this.currentStock = currentStock; }

    public Double getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(Double originalPrice) { this.originalPrice = originalPrice; }

    public Double getSuggestedDiscountPrice() { return suggestedDiscountPrice; }
    public void setSuggestedDiscountPrice(Double suggestedDiscountPrice) { this.suggestedDiscountPrice = suggestedDiscountPrice; }

    public Integer getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(Integer discountPercent) { this.discountPercent = discountPercent; }

    public Integer getDaysInStock() { return daysInStock; }
    public void setDaysInStock(Integer daysInStock) { this.daysInStock = daysInStock; }

    public Double getSalesVelocityPerDay() { return salesVelocityPerDay; }
    public void setSalesVelocityPerDay(Double salesVelocityPerDay) { this.salesVelocityPerDay = salesVelocityPerDay; }

    public String getSpoilageRisk() { return spoilageRisk; }
    public void setSpoilageRisk(String spoilageRisk) { this.spoilageRisk = spoilageRisk; }

    public String getRiskDescription() { return riskDescription; }
    public void setRiskDescription(String riskDescription) { this.riskDescription = riskDescription; }

    public String getSuggestedCouponCode() { return suggestedCouponCode; }
    public void setSuggestedCouponCode(String suggestedCouponCode) { this.suggestedCouponCode = suggestedCouponCode; }

    public Double getEstimatedWasteLoss() { return estimatedWasteLoss; }
    public void setEstimatedWasteLoss(Double estimatedWasteLoss) { this.estimatedWasteLoss = estimatedWasteLoss; }

    public Double getRecoverableCapital() { return recoverableCapital; }
    public void setRecoverableCapital(Double recoverableCapital) { this.recoverableCapital = recoverableCapital; }

    public String getActionType() { return actionType; }
    public void setActionType(String actionType) { this.actionType = actionType; }

    public String getAgentReasoning() { return agentReasoning; }
    public void setAgentReasoning(String agentReasoning) { this.agentReasoning = agentReasoning; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
