package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.OrderClaimModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class OrderClaimMapper implements IRowMapper<OrderClaimModel> {
    @Override
    public OrderClaimModel mapRow(ResultSet rs) {
        try {
            OrderClaimModel claim = new OrderClaimModel();
            claim.setId(rs.getLong("id"));
            claim.setOrderId(rs.getLong("order_id"));
            try {
                long uId = rs.getLong("user_id");
                if (!rs.wasNull()) claim.setUserId(uId);
            } catch (Exception ignored) {}
            claim.setProductId(rs.getLong("product_id"));
            claim.setReason(rs.getString("reason"));
            claim.setCustomerNote(rs.getString("customer_note"));
            claim.setProofImageUrl(rs.getString("proof_image_url"));
            claim.setClaimSolution(rs.getString("claim_solution"));
            claim.setStatus(rs.getString("status"));
            claim.setAdminResponse(rs.getString("admin_response"));
            claim.setCompensationVoucher(rs.getString("compensation_voucher"));
            claim.setCreatedAt(rs.getTimestamp("created_at"));
            claim.setUpdatedAt(rs.getTimestamp("updated_at"));

            // Phụ trợ nếu câu query JOIN
            try { claim.setOrderCode(rs.getString("order_code")); } catch (Exception ignored) {}
            try { claim.setProductName(rs.getString("product_name")); } catch (Exception ignored) {}
            try { claim.setProductImageUrl(rs.getString("product_image_url")); } catch (Exception ignored) {}
            try { claim.setCustomerName(rs.getString("customer_name")); } catch (Exception ignored) {}
            try { claim.setCustomerPhone(rs.getString("customer_phone")); } catch (Exception ignored) {}

            return claim;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
