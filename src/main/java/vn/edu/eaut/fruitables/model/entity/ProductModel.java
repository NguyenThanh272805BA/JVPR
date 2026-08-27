package vn.edu.eaut.fruitables.model.entity;

public class ProductModel {
    private Long id;
    private Integer categoryId;
    private String name;
    private String description;
    private Double price;
    private Integer stock;
    private String imageUrl;
    private Boolean status;
    private String categoryName;
    private Double discountPrice;
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }

    public Double getDiscountPrice() { return discountPrice; }
    public void setDiscountPrice(Double discountPrice) { this.discountPrice = discountPrice; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Boolean getStatus() { return status; }
    public void setStatus(Boolean status) { this.status = status; }

    public String getCategoryName() { return categoryName; }

    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    private String detailedDescription;
    private Double taxRate;

    public String getDetailedDescription() { return detailedDescription; }
    public void setDetailedDescription(String detailedDescription) { this.detailedDescription = detailedDescription; }

    public Double getTaxRate() { return taxRate; }
    public void setTaxRate(Double taxRate) { this.taxRate = taxRate; }
}