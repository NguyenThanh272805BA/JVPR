package vn.edu.eaut.fruitables.model.entity;

import java.sql.Timestamp;
import java.util.List;

public class InventoryReceiptModel {
    private Long id;
    private String receiptCode;
    private Long supplierId;
    private Long createdBy;
    private Double totalCost;
    private String status; // PENDING, COMPLETED, CANCELLED
    private String note;
    private Timestamp createdAt;

    // Các trường bổ sung hiển thị giao diện
    private String supplierName;
    private String creatorName;
    private Integer totalItems;
    private List<InventoryReceiptDetailModel> details;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getReceiptCode() { return receiptCode; }
    public void setReceiptCode(String receiptCode) { this.receiptCode = receiptCode; }

    public Long getSupplierId() { return supplierId; }
    public void setSupplierId(Long supplierId) { this.supplierId = supplierId; }

    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }

    public Double getTotalCost() { return totalCost; }
    public void setTotalCost(Double totalCost) { this.totalCost = totalCost; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public String getCreatorName() { return creatorName; }
    public void setCreatorName(String creatorName) { this.creatorName = creatorName; }

    public Integer getTotalItems() { return totalItems; }
    public void setTotalItems(Integer totalItems) { this.totalItems = totalItems; }

    public Integer getItemCount() {
        return totalItems != null ? totalItems : (details != null ? details.size() : 0);
    }
    public void setItemCount(Integer itemCount) {
        this.totalItems = itemCount;
    }

    public List<InventoryReceiptDetailModel> getDetails() { return details; }
    public void setDetails(List<InventoryReceiptDetailModel> details) { this.details = details; }
}
