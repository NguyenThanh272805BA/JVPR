package vn.edu.eaut.fruitables.model.dto;

public class ReviewAnalysisDTO {
    private String sentiment; // "POSITIVE", "NEGATIVE", "NEUTRAL"
    private String reply;     // Nội dung phản hồi được AI soạn thảo
    private String riskLevel; // "LOW", "MEDIUM", "HIGH"
    private boolean needsSupportFollowup; // true nếu cần nhân viên CSKH chủ động hỗ trợ
    private String reason;    // Lý do phân tích ngắn gọn

    public ReviewAnalysisDTO() {}

    public ReviewAnalysisDTO(String sentiment, String reply, String riskLevel, boolean needsSupportFollowup, String reason) {
        this.sentiment = sentiment;
        this.reply = reply;
        this.riskLevel = riskLevel;
        this.needsSupportFollowup = needsSupportFollowup;
        this.reason = reason;
    }

    public String getSentiment() { return sentiment; }
    public void setSentiment(String sentiment) { this.sentiment = sentiment; }

    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }

    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }

    public boolean isNeedsSupportFollowup() { return needsSupportFollowup; }
    public void setNeedsSupportFollowup(boolean needsSupportFollowup) { this.needsSupportFollowup = needsSupportFollowup; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
}
