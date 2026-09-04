<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Xác thực mã OTP - Fruitables</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-surface-container min-h-screen flex flex-col justify-center items-center p-4 antialiased selection:bg-primary selection:text-white relative overflow-hidden">

<!-- Hiệu ứng nền nhẹ trang trí -->
<div class="absolute -top-24 -left-24 w-96 h-96 bg-primary/10 rounded-full blur-3xl pointer-events-none"></div>
<div class="absolute -bottom-24 -right-24 w-96 h-96 bg-primary/15 rounded-full blur-3xl pointer-events-none"></div>

<div class="w-full max-w-md relative z-10">
    <!-- Header Brand nhỏ phía trên -->
    <div class="text-center mb-6">
        <a href="${pageContext.request.contextPath}/home" class="inline-block font-display-lg text-3xl font-extrabold text-primary hover:opacity-90 transition-opacity">
            Fruitables
        </a>
    </div>

    <!-- Hộp nội dung chính -->
    <div class="bg-surface-container-lowest p-8 md:p-10 rounded-3xl shadow-[0_10px_35px_rgba(0,0,0,0.06)] border border-outline-variant">

        <!-- Icon minh họa trạng thái -->
        <div class="relative w-20 h-20 mx-auto mb-6 flex items-center justify-center">
            <div class="absolute inset-0 bg-primary/15 rounded-2xl rotate-6 animate-pulse"></div>
            <div class="relative w-full h-full bg-primary text-white rounded-2xl flex items-center justify-center shadow-md shadow-primary/25">
                <span class="material-symbols-outlined text-4xl">mark_email_read</span>
            </div>
        </div>

        <!-- Tiêu đề & Hướng dẫn -->
        <div class="text-center mb-8">
            <h1 class="font-headline-md text-2xl font-bold text-on-surface mb-2">Xác thực tài khoản</h1>
            <p class="text-sm text-on-surface-variant leading-relaxed">
                Mã xác thực 6 chữ số vừa được gửi đến hòm thư:
            </p>
            <p class="font-label-bold text-sm text-primary mt-1 font-semibold break-all">
                ${not empty sessionScope.PENDING_USER.email ? sessionScope.PENDING_USER.email : 'email của bạn'}
            </p>
        </div>

        <!-- Thông báo lỗi (nếu có) -->
        <c:if test="${not empty message}">
            <div class="bg-error-container/40 border border-error/30 text-error px-4 py-3 rounded-xl mb-6 text-sm flex items-center gap-2">
                <span class="material-symbols-outlined text-base shrink-0">error</span>
                <span>${message}</span>
            </div>
        </c:if>

        <!-- Form nhập OTP -->
        <form action="${pageContext.request.contextPath}/verify-otp" method="POST" class="space-y-6">
            <div>
                <label for="otpCode" class="block text-xs font-bold uppercase tracking-wider text-on-surface-variant mb-2 text-center">
                    Nhập mã 6 chữ số
                </label>
                <div class="relative">
                    <input type="text"
                           id="otpCode"
                           name="otpCode"
                           maxlength="6"
                           pattern="[0-9]{6}"
                           inputmode="numeric"
                           autocomplete="one-time-code"
                           required
                           placeholder="••••••"
                           class="w-full text-center text-3xl font-mono font-extrabold tracking-[0.45em] py-3.5 px-4 rounded-xl border-2 border-outline-variant focus:border-primary focus:ring-4 focus:ring-primary/10 transition-all outline-none bg-background text-on-surface placeholder:text-outline-variant placeholder:font-normal placeholder:tracking-normal"
                           autofocus/>
                </div>
            </div>

            <button type="submit"
                    class="w-full bg-primary hover:bg-primary-container text-white font-label-bold text-base py-3.5 rounded-full transition-all duration-200 shadow-md shadow-primary/20 hover:shadow-lg hover:-translate-y-0.5 active:translate-y-0 flex items-center justify-center gap-2">
                <span>Xác nhận kích hoạt</span>
                <span class="material-symbols-outlined text-lg">arrow_forward</span>
            </button>
        </form>

        <!-- Đếm ngược và gửi lại mã -->
        <div class="mt-8 pt-6 border-t border-surface-variant text-center">
            <p class="text-xs text-on-surface-variant">
                Chưa nhận được mã?
                <span id="countdownText" class="font-semibold text-on-surface">Gửi lại sau <span id="timer" class="text-primary font-bold">60</span>s</span>
                <a href="${pageContext.request.contextPath}/register" id="resendBtn" class="hidden text-primary font-bold hover:underline ml-1">Đăng ký lại</a>
            </p>
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/register" class="inline-flex items-center gap-1 text-xs text-on-surface-variant hover:text-primary transition-colors">
                    <span class="material-symbols-outlined text-sm">arrow_back</span>
                    Quay lại form đăng ký
                </a>
            </div>
        </div>

    </div>
</div>

<script>
    // Chỉ cho phép nhập số vào ô OTP
    const otpInput = document.getElementById('otpCode');
    otpInput.addEventListener('input', function (e) {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    // Đếm ngược 60 giây gửi lại mã
    let timeLeft = 60;
    const timerElement = document.getElementById('timer');
    const countdownText = document.getElementById('countdownText');
    const resendBtn = document.getElementById('resendBtn');

    const countdown = setInterval(() => {
        timeLeft--;
        if (timerElement) timerElement.textContent = timeLeft;
        if (timeLeft <= 0) {
            clearInterval(countdown);
            if (countdownText) countdownText.classList.add('hidden');
            if (resendBtn) resendBtn.classList.remove('hidden');
        }
    }, 1000);
</script>

</body>
</html>