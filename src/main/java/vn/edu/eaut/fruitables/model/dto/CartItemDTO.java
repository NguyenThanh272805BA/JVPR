package vn.edu.eaut.fruitables.model.dto;

public class CartItemDTO {
    private Long productId;
    private String name;
    private String imageUrl;
    private Double price;
    private Integer quantity;

    public CartItemDTO() {}

    public CartItemDTO(Long productId, String name, String imageUrl, Double price, Integer quantity) {
        this.productId = productId;
        this.name = name;
        this.imageUrl = imageUrl;
        this.price = price;
        this.quantity = quantity;
    }

    // Tính tổng tiền của riêng sản phẩm này (Giá x Số lượng)
    public Double getSubTotal() {
        return this.price * this.quantity;
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
}