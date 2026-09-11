package vn.edu.eaut.fruitables.model.entity;

import java.sql.Timestamp;

public class OrderClaimModel {
    private Long id;
    private Long orderId;
    private Long userId;
    private Long productId;
    private String reason;
    private String customerNote;
    private String proofImageUrl;
    private String claimSolution; // REPLACE_PRODUCT, REFUND_VOUCHER
    private String status; // PENDING, APPROVED, REJECTED
    private String adminResponse;
    private String compensationVoucher;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Thuộc tính hiển thị mở rộng (JOIN)
    private String orderCode;
    private String productName;
    private String productImageUrl;
    private String customerName;
    private String customerPhone;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getCustomerNote() { return customerNote; }
    public void setCustomerNote(String customerNote) { this.customerNote = customerNote; }

    public String getProofImageUrl() { return proofImageUrl; }
    public void setProofImageUrl(String proofImageUrl) { this.proofImageUrl = proofImageUrl; }

    public String getClaimSolution() { return claimSolution; }
    public void setClaimSolution(String claimSolution) { this.claimSolution = claimSolution; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAdminResponse() { return adminResponse; }
    public void setAdminResponse(String adminResponse) { this.adminResponse = adminResponse; }

    public String getCompensationVoucher() { return compensationVoucher; }
    public void setCompensationVoucher(String compensationVoucher) { this.compensationVoucher = compensationVoucher; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImageUrl() { return productImageUrl; }
    public void setProductImageUrl(String productImageUrl) { this.productImageUrl = productImageUrl; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
}
