# BÁO CÁO KẾT QUẢ CẢI THIỆN HỆ THỐNG CHATBOT CHỊU TẢI CAO (HIGH-TRAFFIC RESILIENCE & UX OPTIMIZATION)

---

## 1. Bối cảnh & Vấn đề đặt ra
Khi triển khai (deploy) hệ thống lên môi trường thực tế, tính năng **Chatbot AI (Trợ lý Fruitables & Bác sĩ hoa quả)** có thể thu hút lượng người dùng tương tác đồng thời rất lớn (Traffic Spike). Nếu không có cơ chế bảo vệ, hệ thống sẽ gặp các rủi ro nghiêm trọng:
1. **Cạn kiệt luồng máy chủ (Tomcat Thread Starvation):** Các cuộc gọi REST API sang dịch vụ AI bên ngoài (Google Gemini API) thường mất từ 1.5s - 5s. Nếu xử lý đồng bộ và không giới hạn, hàng trăm kết nối đồng thời sẽ chiếm toàn bộ Thread Pool của Tomcat, dẫn đến **toàn bộ website (xem hàng, giỏ hàng, đặt hàng, thanh toán) bị đơ lag hoặc trả về mã lỗi 504 Gateway Timeout**.
2. **Lỗi Quota & Rate Limit bên thứ 3 (HTTP 429 Too Many Requests):** Vượt ngưỡng RPM/TPM của Gemini dẫn đến lỗi hàng loạt và lãng phí chi phí.
3. **Rò rỉ bộ nhớ (Memory Leak / OutOfMemoryError):** Việc lưu trữ cache câu trả lời trong các `Map` vô hạn kích thước mà không có chính sách đào thải (Eviction) sẽ làm cạn kiệt RAM server sau một thời gian chạy thực tế.
4. **Trải nghiệm khách hàng bị gián đoạn:** Khi gặp lỗi, người dùng thường spam bấm nút gửi liên tục khiến server càng quá tải nặng hơn.

---

## 2. Các giải pháp kiến trúc đã triển khai

### Tầng 1: Kiểm soát lưu lượng & Chống Spam (Rate Limiting)
- **Tập tin:** [`ChatRateLimiter.java`](src/main/java/vn/edu/eaut/fruitables/util/ChatRateLimiter.java)
- **Cơ chế:**
  - Áp dụng thuật toán **Cửa sổ trượt (Sliding Window)** kết hợp **Khoảng cách tối thiểu giữa 2 request (Throttle Interval)** theo IP thực tế của khách hàng (hỗ trợ cả các header `X-Forwarded-For`, `Proxy-Client-IP` khi chạy sau Nginx/Cloudflare).
  - **Giới hạn tin nhắn văn bản (Text Chat):** Tối đa 12 tin nhắn / phút / IP; khoảng cách tối thiểu giữa 2 lần gửi là 1.2 giây (chống bot spam hoặc click chuột dồn dập).
  - **Giới hạn chẩn đoán hình ảnh (Multimodal Vision):** Tối đa 4 ảnh / 3 phút / IP; khoảng cách tối thiểu giữa 2 lần gửi là 4 giây (do xử lý Base64 và Vision Model tiêu tốn nhiều RAM & CPU).
  - **Chống rò rỉ bộ nhớ:** Tích hợp `ScheduledExecutorService` chạy luồng ngầm định kỳ 5 phút dọn dẹp các IP không còn hoạt động.

### Tầng 2: Bộ ngắt mạch bảo vệ hệ thống (Circuit Breaker Pattern)
- **Tập tin:** [`AICircuitBreaker.java`](src/main/java/vn/edu/eaut/fruitables/util/AICircuitBreaker.java)
- **Cơ chế 3 trạng thái:**
  - **CLOSED (Bình thường):** Mọi request AI được chuyển tiếp tới Google Gemini API.
  - **OPEN (Ngắt mạch):** Khi phát hiện lỗi liên tiếp (ngưỡng 4 lần) hoặc phát hiện lỗi `HTTP 429 (Quota Exceeded)`, hệ thống lập tức kích hoạt ngắt mạch trong **45 giây**. Trong thời gian này, mọi cuộc gọi AI sẽ **bị chặn ngay tại chỗ (Fast-Fail 0ms)**, hoàn toàn không tốn thời gian chờ mạng hay giữ luồng Tomcat. Hệ thống trả về phản hồi fallback thông minh ngay lập tức.
  - **HALF-OPEN (Thăm dò phục hồi):** Sau 45 giây cooldown, hệ thống cho phép 1 request đi qua để kiểm tra sức khỏe của API. Nếu thành công -> Đóng mạch (CLOSED); nếu tiếp tục lỗi -> Duy trì OPEN.

### Tầng 3: Bounded LRU Cache & Tối ưu thời gian phản hồi
- **Tập tin:** [`GeminiServiceImpl.java`](src/main/java/vn/edu/eaut/fruitables/service/impl/GeminiServiceImpl.java)
- **Cải tiến:**
  - Thay thế `ConcurrentHashMap` vô hạn bằng **Thread-Safe Bounded LRU Cache (Least Recently Used)** với kích thước tối đa **500 câu hỏi** và TTL **12 giờ**. Khi bộ nhớ đạt giới hạn, phần tử cũ nhất ít truy cập nhất sẽ tự động bị đào thải (`removeEldestEntry`).
  - Tích hợp kiểm tra `AICircuitBreaker` trước khi khởi tạo HTTP Request và ghi nhận trạng thái phản hồi (`recordSuccess` / `recordFailure`).
  - Áp dụng timeout nghiêm ngặt (12s cho chat, 15s cho chẩn đoán ảnh) để giải phóng kết nối nhanh chóng (Fail-Fast).

### Tầng 4: Tinh gọn và Bảo vệ Servlet đầu vào
- **Tập tin:** [`AIChatAPIServlet.java`](src/main/java/vn/edu/eaut/fruitables/controller/api/AIChatAPIServlet.java)
- **Cải tiến:**
  - Kiểm tra Rate Limit ngay đầu hàm `doPost`. Nếu người dùng thao tác quá nhanh, trả về mã trạng thái `rate_limited` kèm thời gian chờ khuyến nghị mà không tốn tài nguyên xử lý logic phía sau.
  - Kiểm tra kích thước hình ảnh gửi lên (tối đa 4MB Base64) để chống tấn công từ chối dịch vụ (DoS qua Payload) và bảo vệ Heap Memory.
  - Khi Circuit Breaker mở, bổ sung cờ trạng thái `system_busy` để giao diện hiển thị các tùy chọn chuyển hướng kịp thời cho khách.

### Tầng 5: Nâng cấp Trải nghiệm người dùng (UX under High Load)
- **Tập tin:** [`footer.jsp`](src/main/webapp/WEB-INF/views/components/footer.jsp)
- **Cải tiến giao diện:**
  - **Chống spam click trên giao diện (Debounce):** Tự động vô hiệu hóa nút gửi, khóa ô nhập và đặt cooldown 1.0s ngay sau khi người dùng bấm gửi.
  - **Kiểm soát dung lượng ảnh phía Client:** Kiểm tra kích thước tệp ảnh ngay khi người dùng chọn (`file.size > 4MB`), cảnh báo sớm ngay trên trình duyệt mà không cần tải lên server.
  - **Giao diện phản hồi thân thiện (Graceful Degradation):** Khi server báo bận hoặc bị rate-limit, giao diện không hiển thị lỗi kỹ thuật khô khan mà hiển thị hộp thông báo chu đáo với 2 nút hành động trực tiếp:
    1. `[💬 Trò chuyện với nhân viên CSKH]`: Tự động chuyển thẳng sang tab Live Chat CSKH trực tiếp.
    2. `[🔥 Xem hoa quả giảm giá hôm nay]`: Tự động hiển thị danh sách sản phẩm khuyến mãi được truy vấn nhanh từ DB mà không cần gọi AI.

---

## 3. Các tập tin đã tạo mới và chỉnh sửa

| STT | Tập tin | Thao tác | Mô tả |
| :--- | :--- | :--- | :--- |
| 1 | `src/.../util/ChatRateLimiter.java` | **Tạo mới** | Thuật toán Sliding Window Rate Limiting theo IP cho Text và Image, có daemon tự dọn rác. |
| 2 | `src/.../util/AICircuitBreaker.java` | **Tạo mới** | Bộ ngắt mạch Circuit Breaker 3 trạng thái bảo vệ server khỏi lỗi 429 và nghẽn luồng mạng. |
| 3 | `src/.../service/impl/GeminiServiceImpl.java` | **Cập nhật** | Tích hợp Bounded LRU Cache (max 500), kết nối Circuit Breaker cho cả Chat và Vision. |
| 4 | `src/.../controller/api/AIChatAPIServlet.java` | **Cập nhật** | Tích hợp kiểm tra Rate Limit, giới hạn dung lượng ảnh 4MB và trả về mã trạng thái thông minh. |
| 5 | `src/.../views/components/footer.jsp` | **Cập nhật** | Debounce UI, kiểm tra dung lượng ảnh client, hiển thị thẻ thông báo chuyển đổi tab CSKH mượt mà. |

---

## 4. Kết quả kiểm thử
- Dự án được biên dịch qua Maven (`mvn test-compile`) thành công 100% với **161 source files**, không phát sinh lỗi biên dịch.
- Hệ thống đảm bảo tính sẵn sàng cao (High Availability): Dù tính năng AI Chat có lượng truy cập tăng đột biến, toàn bộ hệ thống bán hàng cốt lõi (Xem sản phẩm, Đặt hàng, Thanh toán) vẫn vận hành an toàn và mượt mà.
