package vn.edu.eaut.fruitables.model.dto;

import vn.edu.eaut.fruitables.model.entity.CouponModel;

/**
 * DTO bao gói CouponModel với các trường đánh giá runtime.
 * Dùng để trả về cho API /api/coupon?action=list nhằm phân loại
 * voucher thành 2 nhóm: "Khả dụng" và "Chưa đủ điều kiện" trên giao diện.
 */
public class CouponEvaluationDTO {

    // ─── Thông tin cơ bản của Voucher ───────────────────────────────────────
    private Integer id;
    private String code;
    private String discountType;       // FIXED | PERCENT | FREESHIP
    private Double discountValue;
    private Double minOrderValue;
    private Long productId;
    private String productName;
    private String targetAudience;     // ALL | GMAIL | REGULAR
    private java.sql.Timestamp startDate;
    private java.sql.Timestamp endDate;
    private Integer usageLimit;
    private Integer usedCount;
    private Boolean status;

    // ─── Trường đánh giá Runtime (tính toán theo giỏ hàng hiện tại) ────────
    /** Voucher có thể áp dụng ngay cho đơn hàng hiện tại không */
    private boolean applicable;

    /** Số tiền giảm được dự kiến nếu áp dụng (0 nếu !applicable) */
    private double calculatedDiscount;

    /** Lý do chưa đủ điều kiện (null hoặc rỗng nếu applicable = true) */
    private String reasonNotQualified;

    /** Số tiền cần mua thêm để đạt minOrderValue (0 nếu đã đủ) */
    private double shortfallAmount;

    // ─── Constructor từ CouponModel ─────────────────────────────────────────
    public CouponEvaluationDTO(CouponModel coupon) {
        this.id = coupon.getId();
        this.code = coupon.getCode();
        this.discountType = coupon.getDiscountType();
        this.discountValue = coupon.getDiscountValue();
        this.minOrderValue = coupon.getMinOrderValue();
        this.productId = coupon.getProductId();
        this.productName = coupon.getProductName();
        this.targetAudience = coupon.getTargetAudience();
        this.startDate = coupon.getStartDate();
        this.endDate = coupon.getEndDate();
        this.usageLimit = coupon.getUsageLimit();
        this.usedCount = coupon.getUsedCount();
        this.status = coupon.getStatus();
        // Các trường evaluation mặc định
        this.applicable = false;
        this.calculatedDiscount = 0.0;
        this.reasonNotQualified = null;
        this.shortfallAmount = 0.0;
    }

    // ─── Getters & Setters ───────────────────────────────────────────────────
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public Double getDiscountValue() { return discountValue; }
    public void setDiscountValue(Double discountValue) { this.discountValue = discountValue; }

    public Double getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(Double minOrderValue) { this.minOrderValue = minOrderValue; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getTargetAudience() { return targetAudience; }
    public void setTargetAudience(String targetAudience) { this.targetAudience = targetAudience; }

    public java.sql.Timestamp getStartDate() { return startDate; }
    public void setStartDate(java.sql.Timestamp startDate) { this.startDate = startDate; }

    public java.sql.Timestamp getEndDate() { return endDate; }
    public void setEndDate(java.sql.Timestamp endDate) { this.endDate = endDate; }

    public Integer getUsageLimit() { return usageLimit; }
    public void setUsageLimit(Integer usageLimit) { this.usageLimit = usageLimit; }

    public Integer getUsedCount() { return usedCount; }
    public void setUsedCount(Integer usedCount) { this.usedCount = usedCount; }

    public Boolean getStatus() { return status; }
    public void setStatus(Boolean status) { this.status = status; }

    public boolean isApplicable() { return applicable; }
    public void setApplicable(boolean applicable) { this.applicable = applicable; }

    public double getCalculatedDiscount() { return calculatedDiscount; }
    public void setCalculatedDiscount(double calculatedDiscount) { this.calculatedDiscount = calculatedDiscount; }

    public String getReasonNotQualified() { return reasonNotQualified; }
    public void setReasonNotQualified(String reasonNotQualified) { this.reasonNotQualified = reasonNotQualified; }

    public double getShortfallAmount() { return shortfallAmount; }
    public void setShortfallAmount(double shortfallAmount) { this.shortfallAmount = shortfallAmount; }
}
