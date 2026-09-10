package vn.edu.eaut.fruitables.model.entity;

public class InventoryReceiptDetailModel {
    private Long id;
    private Long receiptId;
    private Long productId;
    private Integer quantity;
    private Double importPrice;
    private Double subTotal;

    // Trường bổ sung hiển thị
    private String productName;
    private String productImageUrl;
    private String categoryName;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getReceiptId() { return receiptId; }
    public void setReceiptId(Long receiptId) { this.receiptId = receiptId; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public Double getImportPrice() { return importPrice; }
    public void setImportPrice(Double importPrice) { this.importPrice = importPrice; }

    public Double getSubTotal() { return subTotal; }
    public void setSubTotal(Double subTotal) { this.subTotal = subTotal; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImageUrl() { return productImageUrl; }
    public void setProductImageUrl(String productImageUrl) { this.productImageUrl = productImageUrl; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}
