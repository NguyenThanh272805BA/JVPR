package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IUserAddressDAO;
import vn.edu.eaut.fruitables.mapper.UserAddressMapper;
import vn.edu.eaut.fruitables.model.entity.UserAddressModel;

import java.util.List;

public class UserAddressDAOImpl extends AbstractDAO<UserAddressModel> implements IUserAddressDAO {

    @Override
    public List<UserAddressModel> findByUserId(Long userId) {
        if (userId == null) return java.util.Collections.emptyList();
        String sql = "SELECT * FROM user_addresses WHERE user_id = ? ORDER BY is_default DESC, created_at DESC";
        return query(sql, new UserAddressMapper(), userId);
    }

    @Override
    public UserAddressModel findById(Long id) {
        if (id == null) return null;
        String sql = "SELECT * FROM user_addresses WHERE id = ?";
        List<UserAddressModel> list = query(sql, new UserAddressMapper(), id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public UserAddressModel findDefaultByUserId(Long userId) {
        if (userId == null) return null;
        String sql = "SELECT * FROM user_addresses WHERE user_id = ? AND is_default = 1 LIMIT 1";
        List<UserAddressModel> list = query(sql, new UserAddressMapper(), userId);
        if (list.isEmpty()) {
            // Nếu không có địa chỉ mặc định, lấy địa chỉ mới nhất
            sql = "SELECT * FROM user_addresses WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";
            list = query(sql, new UserAddressMapper(), userId);
        }
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public Long save(UserAddressModel address) {
        if (address == null || address.getUserId() == null) return null;

        // Nếu địa chỉ mới được đánh dấu mặc định, bỏ mặc định các địa chỉ cũ
        if (Boolean.TRUE.equals(address.getIsDefault())) {
            update("UPDATE user_addresses SET is_default = 0 WHERE user_id = ?", address.getUserId());
        } else {
            // Nếu đây là địa chỉ đầu tiên của user, tự động set làm mặc định
            List<UserAddressModel> existing = findByUserId(address.getUserId());
            if (existing.isEmpty()) {
                address.setIsDefault(true);
            }
        }

        String sql = "INSERT INTO user_addresses (user_id, recipient_name, phone, province, district, ward, street_address, full_address, latitude, longitude, is_default) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return insert(sql, 
                address.getUserId(),
                address.getRecipientName(),
                address.getPhone(),
                address.getProvince(),
                address.getDistrict(),
                address.getWard(),
                address.getStreetAddress(),
                address.getFullAddress(),
                address.getLatitude(),
                address.getLongitude(),
                Boolean.TRUE.equals(address.getIsDefault()) ? 1 : 0
        );
    }

    @Override
    public void update(UserAddressModel address) {
        if (address == null || address.getId() == null) return;
        if (Boolean.TRUE.equals(address.getIsDefault())) {
            update("UPDATE user_addresses SET is_default = 0 WHERE user_id = ?", address.getUserId());
        }
        String sql = "UPDATE user_addresses SET recipient_name = ?, phone = ?, province = ?, district = ?, ward = ?, street_address = ?, full_address = ?, latitude = ?, longitude = ?, is_default = ? WHERE id = ? AND user_id = ?";
        update(sql,
                address.getRecipientName(),
                address.getPhone(),
                address.getProvince(),
                address.getDistrict(),
                address.getWard(),
                address.getStreetAddress(),
                address.getFullAddress(),
                address.getLatitude(),
                address.getLongitude(),
                Boolean.TRUE.equals(address.getIsDefault()) ? 1 : 0,
                address.getId(),
                address.getUserId()
        );
    }

    @Override
    public void setDefault(Long userId, Long addressId) {
        if (userId == null || addressId == null) return;
        update("UPDATE user_addresses SET is_default = 0 WHERE user_id = ?", userId);
        update("UPDATE user_addresses SET is_default = 1 WHERE id = ? AND user_id = ?", addressId, userId);
    }

    @Override
    public void delete(Long id, Long userId) {
        if (id == null || userId == null) return;
        update("DELETE FROM user_addresses WHERE id = ? AND user_id = ?", id, userId);
    }
}
