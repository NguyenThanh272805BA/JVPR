package vn.edu.eaut.fruitables.util;

import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;

/**
 * Bộ ngắt mạch bảo vệ hệ thống (Circuit Breaker Pattern) cho các cuộc gọi AI ra dịch vụ bên ngoài (Gemini API).
 * Giúp hệ thống không bị nghẽn thread pool của Tomcat khi API nhà cung cấp bị quá tải hoặc lỗi 429 Too Many Requests.
 */
public class AICircuitBreaker {

    public enum State {
        CLOSED,     // Bình thường: Cho phép tất cả request đi qua
        OPEN,       // Ngắt mạch: Chặn ngay lập tức (Fast-Fail 0ms) để bảo vệ server
        HALF_OPEN   // Thử nghiệm: Cho phép 1 request đi qua để kiểm tra API đã phục hồi chưa
    }

    private static final AICircuitBreaker INSTANCE = new AICircuitBreaker();

    // Ngưỡng kích hoạt ngắt mạch: 4 lỗi liên tiếp
    private static final int FAILURE_THRESHOLD = 4;
    // Thời gian giữ mạch ngắt trước khi thử nghiệm lại: 45 giây
    private static final long COOLDOWN_DURATION_MS = 45 * 1000L;

    private final AtomicReference<State> state = new AtomicReference<>(State.CLOSED);
    private final AtomicInteger consecutiveFailures = new AtomicInteger(0);
    private final AtomicLong lastFailureTimestamp = new AtomicLong(0);
    private final AtomicLong circuitOpenedTimestamp = new AtomicLong(0);

    private AICircuitBreaker() {}

    public static AICircuitBreaker getInstance() {
        return INSTANCE;
    }

    /**
     * Kiểm tra xem có cho phép thực hiện gọi API sang bên thứ 3 hay không
     */
    public boolean allowRequest() {
        State currentState = state.get();

        if (currentState == State.CLOSED) {
            return true;
        }

        long now = System.currentTimeMillis();
        long openedAt = circuitOpenedTimestamp.get();

        if (currentState == State.OPEN) {
            // Đã hết thời gian Cooldown -> Chuyển sang HALF_OPEN để thăm dò
            if (now - openedAt >= COOLDOWN_DURATION_MS) {
                if (state.compareAndSet(State.OPEN, State.HALF_OPEN)) {
                    System.out.println("[AICircuitBreaker] Cooldown kết thúc. Chuyển sang HALF_OPEN để kiểm tra sức khỏe API...");
                    return true;
                }
            }
            return false;
        }

        // HALF_OPEN: Cho phép kiểm tra
        return true;
    }

    /**
     * Ghi nhận một cuộc gọi API thành công
     */
    public void recordSuccess() {
        consecutiveFailures.set(0);
        State prev = state.getAndSet(State.CLOSED);
        if (prev != State.CLOSED) {
            System.out.println("[AICircuitBreaker] API phục hồi thành công! Đóng mạch (CLOSED), hệ thống hoạt động bình thường.");
        }
    }

    /**
     * Ghi nhận lỗi khi gọi API (HTTP lỗi hoặc Timeout/Exception)
     */
    public void recordFailure(int statusCode, String errorMsg) {
        lastFailureTimestamp.set(System.currentTimeMillis());
        int failures = consecutiveFailures.incrementAndGet();

        // Nếu là lỗi 429 Quota Exceeded / Too Many Requests -> Ngắt mạch ngay lập tức không cần đợi 4 lần
        boolean isQuotaExceeded = (statusCode == 429);

        if (isQuotaExceeded || failures >= FAILURE_THRESHOLD) {
            if (state.compareAndSet(State.CLOSED, State.OPEN) || state.compareAndSet(State.HALF_OPEN, State.OPEN)) {
                circuitOpenedTimestamp.set(System.currentTimeMillis());
                System.err.println("[AICircuitBreaker] CẢNH BÁO: Kích hoạt ngắt mạch (OPEN)! Nguyên nhân: "
                        + (isQuotaExceeded ? "HTTP 429 Quota Exceeded" : (failures + " lỗi liên tiếp (" + errorMsg + ")"))
                        + ". Hệ thống sẽ chặn gọi API trong " + (COOLDOWN_DURATION_MS / 1000) + "s để bảo vệ tài nguyên Tomcat.");
            }
        }
    }

    public State getState() {
        return state.get();
    }

    public long getRemainingCooldownSeconds() {
        if (state.get() != State.OPEN) return 0;
        long elapsed = System.currentTimeMillis() - circuitOpenedTimestamp.get();
        return Math.max(0, (COOLDOWN_DURATION_MS - elapsed) / 1000);
    }
}
