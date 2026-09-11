package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.UserModel;

public interface IUserDAO extends GenericDAO<UserModel> {
    UserModel findById(Long id);
    UserModel findByUsernameOrPhoneOrEmail(String identifier);
    UserModel findByEmail(String email);
    Long save(UserModel userModel);
    int countByPhone(String phone);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    boolean updatePasswordByEmail(String email, String newPasswordHash);

    java.util.List<UserModel> findAllUsers();
    boolean updateUserRoleAndStatus(Long userId, Integer roleId, String status);
    java.util.Map<String, Object> getUserStats();
    java.util.Map<String, Object> getUserGrowthChartData(String filter);
    java.util.List<UserModel> searchAndFilterUsers(String keyword, Integer roleId, String status, String loginType);
    java.util.Map<String, Object> getUserPurchaseSummary(Long userId);

    // Phương thức chuyên biệt: Quản lý Khách hàng (Role 3)
    java.util.List<UserModel> findCustomers(String keyword, String status, String loginType);
    java.util.Map<String, Object> getCustomerStats();

    // Phương thức chuyên biệt: Quản lý Nhân sự & Phân quyền Role (Role 1, 2, 4)
    java.util.List<UserModel> findEmployees(String keyword, Integer roleId, String status);
    java.util.Map<String, Object> getEmployeeStats();
    Long createEmployee(UserModel user, String vehiclePlate);
    boolean updateEmployeeRoleAndStatus(Long userId, Integer newRoleId, String status, String vehiclePlate);
}