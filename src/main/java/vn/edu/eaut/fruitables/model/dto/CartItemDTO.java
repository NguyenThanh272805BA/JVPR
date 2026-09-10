package vn.edu.eaut.fruitables.model.dto;

public class CartItemDTO {
    private Long productId;
    private String name;
    private String imageUrl;
    private Double price;
    private Integer quantity;
    private Double taxRate; // Thuộc tính lưu % thuế của sản phẩm
    private Integer weightGram; // Trọng lượng mỗi đơn vị (gram)
    private String storageType; // NORMAL, COLD_CHAIN, FRAGILE_GIFT
    private Boolean isFreeShipping;

    public CartItemDTO() {}

    // Cập nhật Constructor thêm tham số taxRate
    public CartItemDTO(Long productId, String name, String imageUrl, Double price, Integer quantity, Double taxRate) {
        this.productId = productId;
        this.name = name;
        this.imageUrl = imageUrl;
        this.price = price;
        this.quantity = quantity;
        this.taxRate = taxRate;
        this.weightGram = 500;
        this.storageType = "NORMAL";
        this.isFreeShipping = false;
    }

    public CartItemDTO(Long productId, String name, String imageUrl, Double price, Integer quantity, Double taxRate, Integer weightGram, String storageType, Boolean isFreeShipping) {
        this.productId = productId;
        this.name = name;
        this.imageUrl = imageUrl;
        this.price = price;
        this.quantity = quantity;
        this.taxRate = taxRate;
        this.weightGram = weightGram != null ? weightGram : 500;
        this.storageType = storageType != null ? storageType : "NORMAL";
        this.isFreeShipping = isFreeShipping != null ? isFreeShipping : false;
    }

    // Tính tổng tiền của riêng sản phẩm này (Giá x Số lượng) - Chưa bao gồm thuế
    public Double getSubTotal() {
        return this.price * this.quantity;
    }

    // Tính tổng tiền thuế của riêng sản phẩm này
    public Double getTaxAmount() {
        if (this.taxRate == null) return 0.0;
        return (this.price * this.quantity * this.taxRate) / 100;
    }

    // Getters and Setters
    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public Double getTaxRate() { return taxRate; }
    public void setTaxRate(Double taxRate) { this.taxRate = taxRate; }

    public Integer getWeightGram() { return weightGram != null ? weightGram : 500; }
    public void setWeightGram(Integer weightGram) { this.weightGram = weightGram; }

    public String getStorageType() { return storageType != null ? storageType : "NORMAL"; }
    public void setStorageType(String storageType) { this.storageType = storageType; }

    public Boolean getIsFreeShipping() { return isFreeShipping != null ? isFreeShipping : false; }
    public void setIsFreeShipping(Boolean isFreeShipping) { this.isFreeShipping = isFreeShipping; }
}