package vn.edu.eaut.fruitables.service;

import vn.edu.eaut.fruitables.model.dto.ClearanceRecommendationDTO;
import java.util.List;
import java.util.Map;

public interface IInventoryAgentService {

    /**
     * AI Agent quét CSDL toàn bộ kho hàng, phân tích tốc độ bán (run-rate), hạn lưu kho (shelf-life)
     * và tự động lập kế hoạch xả kho cứu vốn cho các mặt hàng hoa quả tươi có nguy cơ hư hao.
     */
    List<ClearanceRecommendationDTO> analyzeInventoryRisks();

    /**
     * Quét lại toàn bộ kho hàng, cho phép bỏ qua cache để làm mới phân tích AI ngay lập tức.
     */
    List<ClearanceRecommendationDTO> analyzeInventoryRisks(boolean forceRefresh);

    /**
     * Tổng hợp các chỉ số vĩ mô phục vụ bảng điều khiển Agent (Tổng giá trị nguy cơ, Vốn cứu được, Số mã đã kích hoạt)
     */
    Map<String, Object> getAgentMacroMetrics();

    /**
     * Tính nhanh các chỉ số vĩ mô từ danh sách khuyến nghị đã quét sẵn (tránh truy vấn lặp).
     */
    Map<String, Object> buildMacroMetrics(List<ClearanceRecommendationDTO> list);

    /**
     * Lấy nhật ký hoạt động thực tế của AI Agent từ bảng notifications.
     */
    List<Map<String, String>> getRecentAuditLogs(int limit);

    /**
     * Thực thi hành động tự động (Autonomous Action Execution):
     * Kích hoạt chiến dịch xả kho, tạo mã Coupon thực tế trong DB và cập nhật giá Flash Sale tức thì.
     */
    boolean executeClearancePlan(Long productId, String couponCode, int discountPercent, String actionType);
}
