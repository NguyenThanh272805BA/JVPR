package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IClaimDAO;
import vn.edu.eaut.fruitables.mapper.OrderClaimMapper;
import vn.edu.eaut.fruitables.model.entity.OrderClaimModel;

import java.util.List;

public class ClaimDAOImpl extends AbstractDAO<OrderClaimModel> implements IClaimDAO {

    private final OrderClaimMapper mapper = new OrderClaimMapper();

    private final String BASE_SELECT = "SELECT c.*, o.order_code, p.name AS product_name, p.image_url AS product_image_url, " +
            "COALESCE(o.recipient_name, u.full_name) AS customer_name, " +
            "COALESCE(o.phone, u.phone) AS customer_phone " +
            "FROM order_claims c " +
            "JOIN orders o ON c.order_id = o.id " +
            "JOIN products p ON c.product_id = p.id " +
            "LEFT JOIN users u ON c.user_id = u.id ";

    @Override
    public Long insertClaim(OrderClaimModel claim) {
        String sql = "INSERT INTO order_claims (order_id, user_id, product_id, reason, customer_note, proof_image_url, claim_solution, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        return insert(sql,
                claim.getOrderId(),
                claim.getUserId(),
                claim.getProductId(),
                claim.getReason(),
                claim.getCustomerNote(),
                claim.getProofImageUrl(),
                claim.getClaimSolution() != null ? claim.getClaimSolution() : "REPLACE_PRODUCT",
                claim.getStatus() != null ? claim.getStatus() : "PENDING"
        );
    }

    @Override
    public List<OrderClaimModel> findAll() {
        String sql = BASE_SELECT + "ORDER BY c.id DESC";
        return query(sql, mapper);
    }

    @Override
    public OrderClaimModel findById(Long id) {
        String sql = BASE_SELECT + "WHERE c.id = ?";
        List<OrderClaimModel> list = query(sql, mapper, id);
        return (list != null && !list.isEmpty()) ? list.get(0) : null;
    }

    @Override
    public List<OrderClaimModel> findByOrderId(Long orderId) {
        String sql = BASE_SELECT + "WHERE c.order_id = ? ORDER BY c.id DESC";
        return query(sql, mapper, orderId);
    }

    @Override
    public List<OrderClaimModel> findByUserId(Long userId) {
        String sql = BASE_SELECT + "WHERE c.user_id = ? ORDER BY c.id DESC";
        return query(sql, mapper, userId);
    }

    @Override
    public boolean updateClaimStatus(Long id, String status, String adminResponse, String compensationVoucher) {
        String sql = "UPDATE order_claims SET status = ?, admin_response = ?, compensation_voucher = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try {
            update(sql, status, adminResponse, compensationVoucher, id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
