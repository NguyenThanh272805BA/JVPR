package vn.edu.eaut.fruitables.model.entity;

import java.sql.Timestamp;

public class LuckySpinPrizeModel {
    private Integer id;
    private String name;
    private String prizeType; // DISCOUNT_AMOUNT, DISCOUNT_PERCENT, FREESHIP, GIFT_PRODUCT, EXTRA_SPIN, NO_PRIZE
    private Double discountValue;
    private Double minOrderValue;
    private Long productId;
    private String productName;
    private Double probability;
    private Integer quantityLimit;
    private Integer quantityRemain;
    private String colorBg;
    private String colorText;
    private String iconType; // voucher, shipping, gift, star, spin, luck
    private Boolean status;
    private Integer displayOrder;
    private Timestamp createdAt;

    public LuckySpinPrizeModel() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPrizeType() { return prizeType; }
    public void setPrizeType(String prizeType) { this.prizeType = prizeType; }

    public Double getDiscountValue() { return discountValue != null ? discountValue : 0.0; }
    public void setDiscountValue(Double discountValue) { this.discountValue = discountValue; }

    public Double getMinOrderValue() { return minOrderValue != null ? minOrderValue : 0.0; }
    public void setMinOrderValue(Double minOrderValue) { this.minOrderValue = minOrderValue; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public Double getProbability() { return probability != null ? probability : 0.0; }
    public void setProbability(Double probability) { this.probability = probability; }

    public Integer getQuantityLimit() { return quantityLimit != null ? quantityLimit : -1; }
    public void setQuantityLimit(Integer quantityLimit) { this.quantityLimit = quantityLimit; }

    public Integer getQuantityRemain() { return quantityRemain != null ? quantityRemain : -1; }
    public void setQuantityRemain(Integer quantityRemain) { this.quantityRemain = quantityRemain; }

    public String getColorBg() { return colorBg != null ? colorBg : "#10B981"; }
    public void setColorBg(String colorBg) { this.colorBg = colorBg; }

    public String getColorText() { return colorText != null ? colorText : "#FFFFFF"; }
    public void setColorText(String colorText) { this.colorText = colorText; }

    public String getIconType() { return iconType != null ? iconType : "voucher"; }
    public void setIconType(String iconType) { this.iconType = iconType; }

    public Boolean getStatus() { return status != null ? status : true; }
    public void setStatus(Boolean status) { this.status = status; }

    public Integer getDisplayOrder() { return displayOrder != null ? displayOrder : 0; }
    public void setDisplayOrder(Integer displayOrder) { this.displayOrder = displayOrder; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // Helper text mô tả giải thưởng cho người dùng
    public String getBadgeDescription() {
        if ("FREESHIP".equalsIgnoreCase(prizeType)) return "Miễn phí vận chuyển";
        if ("DISCOUNT_AMOUNT".equalsIgnoreCase(prizeType)) return "Giảm " + String.format("%,.0fđ", discountValue);
        if ("DISCOUNT_PERCENT".equalsIgnoreCase(prizeType)) return "Giảm " + discountValue.intValue() + "%";
        if ("GIFT_PRODUCT".equalsIgnoreCase(prizeType)) return "Tặng quà hiện vật";
        if ("EXTRA_SPIN".equalsIgnoreCase(prizeType)) return "+1 Lượt quay";
        return "Cơ hội nhận quà";
    }
}
