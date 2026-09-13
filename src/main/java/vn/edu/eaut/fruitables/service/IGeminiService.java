package vn.edu.eaut.fruitables.service;

import java.util.List;
import java.util.Map;

public interface IGeminiService {

    /**
     * Tư vấn sản phẩm, giải đáp cách bảo quản hoa quả, hướng dẫn chế biến món ăn / nước ép detox
     *
     * @param userMessage         Câu hỏi của khách hàng
     * @param conversationHistory Danh sách tin nhắn gần nhất dạng [{"role": "user/model", "text": "..."}]
     * @return Câu trả lời từ AI súc tích, định dạng markdown/emoji
     */
    String askProductAssistant(String userMessage, List<Map<String, String>> conversationHistory);

    /**
     * Phân tích số liệu kinh doanh, doanh số, tồn kho, đơn hàng dành cho Quản trị viên (Admin Executive BI)
     *
     * @param systemRole    Vai trò AI (Giám đốc Phân tích Kinh doanh & Chiến lược Fruitables)
     * @param contextData   Dữ liệu kinh doanh dạng JSON/Text tổng hợp
     * @param userQuery     Yêu cầu phân tích cụ thể từ Admin
     * @return Báo cáo phân tích kinh doanh, dự báo xu hướng và đề xuất hành động cụ thể
     */
    String generateExecutiveAnalysis(String systemRole, String contextData, String userQuery);

    /**
     * Làm mới hoặc xóa bộ nhớ đệm câu trả lời
     */
    void clearCache();
}
