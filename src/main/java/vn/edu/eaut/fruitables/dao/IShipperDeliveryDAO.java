package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.OrderModel;

import java.util.List;
import java.util.Map;

public interface IShipperDeliveryDAO {
    List<OrderModel> findFailedAndReturnedOrders(Long shipperId, String reason, String status, String startDate, String endDate, String keyword);
    List<OrderModel> findOrdersByShipper(Long shipperId, String statusTab, String keyword);
    Map<String, Object> getShipperShiftSummary(Long shipperId);
    Map<String, Object> getFailedDeliveryStats(Long shipperId, String startDate, String endDate);
    Map<String, Object> getFailedReasonsDistribution(Long shipperId, String startDate, String endDate);
    Map<String, Object> getShipperFailureComparison(String startDate, String endDate);
    boolean scheduleRetryDelivery(Long orderId, Long shipperId, String deliveryTime, String notes);
    boolean markReturnedToStock(Long orderId, String notes);
    boolean markDeliveredSuccessfully(Long orderId, String notes);
    boolean updateFailureReasonAndNotes(Long orderId, String reason, String notes, int attempts);
}
