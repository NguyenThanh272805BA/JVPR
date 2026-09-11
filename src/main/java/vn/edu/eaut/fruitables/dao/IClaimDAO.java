package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.OrderClaimModel;
import java.util.List;

public interface IClaimDAO extends GenericDAO<OrderClaimModel> {
    Long insertClaim(OrderClaimModel claim);
    List<OrderClaimModel> findAll();
    OrderClaimModel findById(Long id);
    List<OrderClaimModel> findByOrderId(Long orderId);
    List<OrderClaimModel> findByUserId(Long userId);
    boolean updateClaimStatus(Long id, String status, String adminResponse, String compensationVoucher);
}
