package vn.edu.eaut.fruitables.model.entity;

import java.sql.Timestamp;
import java.util.List;

public class OrderModel {
    private Long id;
    private String orderCode;
    private Long userId;
    private Double totalAmount;
    private String shippingAddress;
    private String phone;
    private String paymentMethod;
    private String status;
    private Timestamp createdAt;
    private String paymentStatus;

    private String recipientName;
    private String customerEmail;
    private String orderNotes;

    // Thuộc tính bổ sung: Vận chuyển & Khoảng cách
    private Double shippingFee;
    private Double distanceKm;
    private Double shippingDiscount;

    // Thuộc tính bổ sung để lưu danh sách sản phẩm của đơn hàng
    private List<OrderDetailModel> details;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getRecipientName() { return recipientName; }
    public void setRecipientName(String recipientName) { this.recipientName = recipientName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getOrderNotes() { return orderNotes; }
    public void setOrderNotes(String orderNotes) { this.orderNotes = orderNotes; }

    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // Getters and Setters cho danh sách chi tiết đơn hàng
    public List<OrderDetailModel> getDetails() { return details; }
    public void setDetails(List<OrderDetailModel> details) { this.details = details; }

    public Double getShippingFee() { return shippingFee; }
    public void setShippingFee(Double shippingFee) { this.shippingFee = shippingFee; }

    public Double getDistanceKm() { return distanceKm; }
    public void setDistanceKm(Double distanceKm) { this.distanceKm = distanceKm; }

    public Double getShippingDiscount() { return shippingDiscount; }
    public void setShippingDiscount(Double shippingDiscount) { this.shippingDiscount = shippingDiscount; }
}