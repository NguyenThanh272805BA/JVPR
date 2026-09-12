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
     * Làm mới hoặc xóa bộ nhớ đệm câu trả lời
     */
    void clearCache();
}
