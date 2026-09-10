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

    // Thuộc tính bổ sung: Chi tiết & Thuế
    private String detailedDescription;
    private Double taxRate;

    // Thuộc tính bổ sung: Đánh giá & Số lượng bình luận
    private Double avgRating;
    private Integer reviewCount;

    // Thuộc tính bổ sung: Số lượt mua hàng (đã bán)
    private Integer totalSold;

    // Thuộc tính bổ sung: Vận chuyển & Bảo quản
    private Integer weightGram;
    private String storageType; // NORMAL, COLD_CHAIN, FRAGILE_GIFT
    private Boolean isFreeShipping;

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

    public String getDetailedDescription() { return detailedDescription; }
    public void setDetailedDescription(String detailedDescription) { this.detailedDescription = detailedDescription; }

    public Double getTaxRate() { return taxRate; }
    public void setTaxRate(Double taxRate) { this.taxRate = taxRate; }

    public Double getAvgRating() { return avgRating; }
    public void setAvgRating(Double avgRating) { this.avgRating = avgRating; }

    public Integer getReviewCount() { return reviewCount; }
    public void setReviewCount(Integer reviewCount) { this.reviewCount = reviewCount; }

    public Integer getTotalSold() { return totalSold; }
    public void setTotalSold(Integer totalSold) { this.totalSold = totalSold; }

    public Integer getWeightGram() { return weightGram; }
    public void setWeightGram(Integer weightGram) { this.weightGram = weightGram; }

    public String getStorageType() { return storageType; }
    public void setStorageType(String storageType) { this.storageType = storageType; }

    public Boolean getIsFreeShipping() { return isFreeShipping; }
    public void setIsFreeShipping(Boolean isFreeShipping) { this.isFreeShipping = isFreeShipping; }
}