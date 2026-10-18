package vn.edu.eaut.fruitables.util;

import javax.servlet.http.HttpServletRequest;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Bộ kiểm soát lưu lượng và chống Spam (Rate Limiter) cho tính năng Chatbot AI.
 * Bảo vệ server Tomcat và Gemini API khỏi cạn kiệt tài nguyên (Thread Starvation, Quota Exceeded).
 */
public class ChatRateLimiter {

    private static final ChatRateLimiter INSTANCE = new ChatRateLimiter();

    // Giới hạn Text Chat: Tối đa 12 request/phút, cách nhau tối thiểu 1.2s
    private static final int MAX_TEXT_REQUESTS_PER_MINUTE = 12;
    private static final long MIN_TEXT_INTERVAL_MS = 1200L;
    private static final long TEXT_WINDOW_MS = 60 * 1000L;

    // Giới hạn Multimodal Vision (Ảnh): Tối đa 4 request/3 phút, cách nhau tối thiểu 5s
    private static final int MAX_IMAGE_REQUESTS_PER_WINDOW = 4;
    private static final long MIN_IMAGE_INTERVAL_MS = 4000L;
    private static final long IMAGE_WINDOW_MS = 3 * 60 * 1000L;

    // Lưu trữ trạng thái theo IP
    private final Map<String, ClientTracker> trackers = new ConcurrentHashMap<>();

    private ChatRateLimiter() {
        // Luồng ngầm định kỳ 5 phút dọn dẹp các IP đã lâu không hoạt động -> chống tràn RAM
        ScheduledExecutorService cleaner = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "RateLimiter-Cleaner");
            t.setDaemon(true);
            return t;
        });
        cleaner.scheduleAtFixedRate(this::cleanupExpiredTrackers, 5, 5, TimeUnit.MINUTES);
    }

    public static ChatRateLimiter getInstance() {
        return INSTANCE;
    }

    public static class RateLimitResult {
        private final boolean allowed;
        private final long retryAfterSeconds;
        private final String message;

        public RateLimitResult(boolean allowed, long retryAfterSeconds, String message) {
            this.allowed = allowed;
            this.retryAfterSeconds = retryAfterSeconds;
            this.message = message;
        }

        public boolean isAllowed() {
            return allowed;
        }

        public long getRetryAfterSeconds() {
            return retryAfterSeconds;
        }

        public String getMessage() {
            return message;
        }
    }

    private static class ClientTracker {
        long lastTextRequestTime = 0;
        int textCountInWindow = 0;
        long textWindowStartTime = 0;

        long lastImageRequestTime = 0;
        int imageCountInWindow = 0;
        long imageWindowStartTime = 0;

        long lastAccessTime = System.currentTimeMillis();
    }

    /**
     * Trích xuất địa chỉ IP thực tế của khách hàng (kể cả khi chạy sau Proxy/Nginx/Cloudflare)
     */
    public String resolveClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return (ip != null) ? ip : "127.0.0.1";
    }

    /**
     * Kiểm tra Rate Limit cho tin nhắn văn bản thông thường
     */
    public RateLimitResult checkTextRequest(String clientIp) {
        long now = System.currentTimeMillis();
        ClientTracker tracker = trackers.computeIfAbsent(clientIp, k -> new ClientTracker());

        synchronized (tracker) {
            tracker.lastAccessTime = now;

            // 1. Kiểm tra khoảng cách giữa 2 lần gửi liên tiếp (chống spam click)
            long elapsedSinceLast = now - tracker.lastTextRequestTime;
            if (elapsedSinceLast < MIN_TEXT_INTERVAL_MS) {
                long waitSec = Math.max(1, (MIN_TEXT_INTERVAL_MS - elapsedSinceLast) / 1000 + 1);
                return new RateLimitResult(false, waitSec,
                        "Dạ bạn thao tác hơi nhanh một chút 🍎. Vui lòng nghỉ tay " + waitSec + " giây để Fruitables chuẩn bị phản hồi chu đáo nhất nhé!");
            }

            // 2. Kiểm tra cửa sổ trượt (Sliding Window 60s)
            if (now - tracker.textWindowStartTime > TEXT_WINDOW_MS) {
                tracker.textWindowStartTime = now;
                tracker.textCountInWindow = 0;
            }

            if (tracker.textCountInWindow >= MAX_TEXT_REQUESTS_PER_MINUTE) {
                long waitSec = Math.max(1, (TEXT_WINDOW_MS - (now - tracker.textWindowStartTime)) / 1000);
                return new RateLimitResult(false, waitSec,
                        "Hệ thống đang tiếp nhận nhiều tin nhắn từ bạn 🌿. Vui lòng đợi khoảng " + waitSec + " giây để tiếp tục đặt câu hỏi cho Trợ lý AI nhé!");
            }

            // Hợp lệ -> Cập nhật trạng thái
            tracker.lastTextRequestTime = now;
            tracker.textCountInWindow++;
            return new RateLimitResult(true, 0, null);
        }
    }

    /**
     * Kiểm tra Rate Limit cho tác vụ Giám định hình ảnh (Multimodal Vision nặng về CPU & Token)
     */
    public RateLimitResult checkImageRequest(String clientIp) {
        long now = System.currentTimeMillis();
        ClientTracker tracker = trackers.computeIfAbsent(clientIp, k -> new ClientTracker());

        synchronized (tracker) {
            tracker.lastAccessTime = now;

            // 1. Chống gửi ảnh dồn dập
            long elapsedSinceLast = now - tracker.lastImageRequestTime;
            if (elapsedSinceLast < MIN_IMAGE_INTERVAL_MS) {
                long waitSec = Math.max(1, (MIN_IMAGE_INTERVAL_MS - elapsedSinceLast) / 1000 + 1);
                return new RateLimitResult(false, waitSec,
                        "Trợ lý Fruit Doctor đang giám định ảnh trước đó 🔬. Bạn vui lòng đợi " + waitSec + " giây trước khi gửi tiếp bức ảnh mới nhé!");
            }

            // 2. Kiểm tra số lượng ảnh tối đa trong 3 phút
            if (now - tracker.imageWindowStartTime > IMAGE_WINDOW_MS) {
                tracker.imageWindowStartTime = now;
                tracker.imageCountInWindow = 0;
            }

            if (tracker.imageCountInWindow >= MAX_IMAGE_REQUESTS_PER_WINDOW) {
                long waitSec = Math.max(1, (IMAGE_WINDOW_MS - (now - tracker.imageWindowStartTime)) / 1000);
                return new RateLimitResult(false, waitSec,
                        "Tính năng chẩn đoán ảnh đạt giới hạn cho phiên hiện tại (" + MAX_IMAGE_REQUESTS_PER_WINDOW + " ảnh/3 phút). Vui lòng thử lại sau " + waitSec + " giây!");
            }

            tracker.lastImageRequestTime = now;
            tracker.imageCountInWindow++;
            return new RateLimitResult(true, 0, null);
        }
    }

    private void cleanupExpiredTrackers() {
        long now = System.currentTimeMillis();
        long expireTime = 10 * 60 * 1000L; // 10 phút không có hoạt động
        Iterator<Map.Entry<String, ClientTracker>> it = trackers.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, ClientTracker> entry = it.next();
            if (now - entry.getValue().lastAccessTime > expireTime) {
                it.remove();
            }
        }
    }
}
