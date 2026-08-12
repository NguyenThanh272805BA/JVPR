<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Xác thực OTP - Fruitables</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-surface flex items-center justify-center min-h-screen">
<div class="bg-white p-8 rounded-xl shadow-lg w-full max-w-md text-center border border-gray-100">
    <div class="w-16 h-16 bg-primary-container text-white rounded-full flex items-center justify-center mx-auto mb-6">
        <span class="material-symbols-outlined text-3xl">mark_email_read</span>
    </div>
    <h2 class="text-2xl font-bold text-gray-800 mb-2">Kiểm tra Email của bạn</h2>
    <p class="text-gray-500 mb-6">Chúng tôi vừa gửi mã OTP gồm 6 chữ số đến email bạn đã đăng ký.</p>

    <c:if test="${not empty message}">
        <div class="bg-red-100 text-red-600 p-3 rounded mb-4 text-sm font-semibold">${message}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/verify-otp" method="POST">
        <input type="text" name="otpCode" maxlength="6" required placeholder="Nhập mã 6 số..."
               class="w-full text-center text-2xl tracking-widest font-bold px-4 py-3 border border-gray-300 rounded-lg focus:border-primary outline-none mb-6">

        <button type="submit" class="w-full bg-primary hover:bg-primary-container text-white font-bold py-3 rounded-full transition-colors shadow-md">
            Xác nhận kích hoạt
        </button>
    </form>
</div>
</body>
</html>