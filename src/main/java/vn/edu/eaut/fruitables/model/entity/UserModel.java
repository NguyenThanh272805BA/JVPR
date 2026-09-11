package vn.edu.eaut.fruitables.model.entity;

import java.sql.Timestamp;

public class UserModel {
    private Long id;
    private Integer roleId;
    private String username;
    private String fullName;
    private String email;
    private String passwordHash;
    private String phone;
    private String address;
    private String status;
    private Timestamp createdAt;
    private String avatarUrl;
    private String loginType;

    public UserModel() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Integer getRoleId() { return roleId; }
    public void setRoleId(Integer roleId) { this.roleId = roleId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getLoginType() { return loginType; }
    public void setLoginType(String loginType) { this.loginType = loginType; }

    // Tích điểm & Hạng VIP
    private Integer points = 0;
    private Integer accumulatedPoints = 0;

    public Integer getPoints() { return points != null ? points : 0; }
    public void setPoints(Integer points) { this.points = points; }

    public Integer getAccumulatedPoints() { return accumulatedPoints != null ? accumulatedPoints : 0; }
    public void setAccumulatedPoints(Integer accumulatedPoints) { this.accumulatedPoints = accumulatedPoints; }

    public String getVipTier() {
        int acc = getAccumulatedPoints();
        if (acc >= 1000) return "KIM CƯƠNG";
        if (acc >= 500) return "VÀNG";
        if (acc >= 100) return "BẠC";
        return "ĐỒNG";
    }

    public String getVipTierColor() {
        int acc = getAccumulatedPoints();
        if (acc >= 1000) return "#00b4d8"; // Cyan Diamond
        if (acc >= 500) return "#e67e22";  // Gold / Orange
        if (acc >= 100) return "#7f8c8d";  // Silver Gray
        return "#b37426";                   // Bronze
    }

    public int getVipDiscountPercent() {
        int acc = getAccumulatedPoints();
        if (acc >= 1000) return 10;
        if (acc >= 500) return 5;
        if (acc >= 100) return 2;
        return 0;
    }

    // Thuộc tính bổ sung phục vụ phân hệ quản lý nhân sự & vai trò
    private String roleName;
    private String vehiclePlate;

    public String getRoleName() {
        if (roleName != null && !roleName.isEmpty()) return roleName;
        if (roleId != null) {
            if (roleId == 1) return "SUPER_ADMIN";
            if (roleId == 2) return "SALE";
            if (roleId == 3) return "USER";
            if (roleId == 4) return "SHIPPER";
        }
        return "USER";
    }

    public void setRoleName(String roleName) { this.roleName = roleName; }

    public String getVehiclePlate() { return vehiclePlate; }
    public void setVehiclePlate(String vehiclePlate) { this.vehiclePlate = vehiclePlate; }
}