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
     * Sinh đoạn mô tả ngắn gọn, súc tích và hấp dẫn cho sản phẩm
     */
    String generateProductShortDescription(String productName, String categoryName, String toneStyle);

    /**
     * Sinh bài viết giới thiệu sản phẩm chi tiết theo mẫu và phong cách, định dạng HTML chuẩn CKEditor
     */
    String generateProductArticle(String productName, String categoryName, String templateType, String toneStyle);

    /**
     * Sinh phần câu hỏi thường gặp (FAQ) cho sản phẩm, định dạng HTML
     */
    String generateProductFaq(String productName, String categoryName);

    /**
     * Gợi ý thông số vận chuyển và bảo quản (trọng lượng gram, quy cách bảo quản) dạng JSON
     */
    String suggestProductSpecs(String productName, String categoryName);

    /**
     * Phân tích ngữ cảnh đánh giá (Tích cực / Tiêu cực / Thắc mắc) và tự động soạn thảo câu phản hồi chuẩn CSKH Fruitables
     *
     * @param productName Tên sản phẩm được đánh giá
     * @param categoryName Danh mục sản phẩm
     * @param rating Số sao khách chấm (1-5)
     * @param comment Bình luận/nhận xét của khách
     * @param customerName Tên khách hàng
     * @return DTO chứa sentiment, câu phản hồi, rủi ro và cờ cần CSKH can thiệp
     */
    vn.edu.eaut.fruitables.model.dto.ReviewAnalysisDTO analyzeAndReplyReview(String productName, String categoryName, int rating, String comment, String customerName);

    /**
     * Làm mới hoặc xóa bộ nhớ đệm câu trả lời
     */
    void clearCache();
}
