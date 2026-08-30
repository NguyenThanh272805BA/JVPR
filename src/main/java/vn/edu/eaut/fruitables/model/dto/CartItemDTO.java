package vn.edu.eaut.fruitables.model.dto;

public class CartItemDTO {
    private Long productId;
    private String name;
    private String imageUrl;
    private Double price;
    private Integer quantity;
    private Double taxRate; // Thuộc tính lưu % thuế của sản phẩm

    public CartItemDTO() {}

    // Cập nhật Constructor thêm tham số taxRate
    public CartItemDTO(Long productId, String name, String imageUrl, Double price, Integer quantity, Double taxRate) {
        this.productId = productId;
        this.name = name;
        this.imageUrl = imageUrl;
        this.price = price;
        this.quantity = quantity;
        this.taxRate = taxRate;
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
}