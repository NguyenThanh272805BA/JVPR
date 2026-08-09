<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Thanh toán - Fruitables</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>

<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col antialiased">

<!-- NAVBAR (Đã tinh gọn) -->
<nav class="bg-surface w-full sticky top-0 shadow-sm z-50">
    <div class="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <a class="font-display-lg-mobile font-extrabold text-primary" href="${pageContext.request.contextPath}/home">Fruitables</a>
        <a href="${pageContext.request.contextPath}/cart" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors flex items-center">
            <span class="material-symbols-outlined mr-2">arrow_back</span>
            <span class="font-label-bold hidden md:inline">Quay lại Giỏ hàng</span>
        </a>
    </div>
</nav>

<!-- MAIN CHECKOUT CONTENT -->
<main class="flex-grow py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <h1 class="font-headline-md text-3xl text-on-surface mb-8 font-bold">Chi tiết thanh toán</h1>

        <form action="${pageContext.request.contextPath}/checkout" method="POST" class="flex flex-col lg:flex-row gap-8">

            <!-- CỘT TRÁI: Form điền thông tin -->
            <div class="w-full lg:w-2/3 space-y-6">
                <div class="bg-surface-container-lowest p-6 md:p-8 rounded-xl shadow-sm border border-outline-variant">
                    <h2 class="font-headline-md text-xl text-on-surface mb-6 border-b border-surface-variant pb-4">Thông tin giao hàng</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <label class="block font-label-bold text-on-surface mb-2">Họ và tên *</label>
                            <input type="text" name="fullName" required value="${sessionScope.USERMODEL.fullName}"
                                   class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface transition-colors">
                        </div>
                        <div>
                            <label class="block font-label-bold text-on-surface mb-2">Số điện thoại *</label>
                            <input type="tel" name="phone" required value="${sessionScope.USERMODEL.phone}"
                                   class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface transition-colors">
                        </div>
                    </div>

                    <div class="mb-6">
                        <label class="block font-label-bold text-on-surface mb-2">Địa chỉ Email</label>
                        <input type="email" readonly value="${sessionScope.USERMODEL.email}"
                               class="w-full px-4 py-3 rounded-lg border border-outline-variant bg-surface-container-low text-on-surface-variant cursor-not-allowed">
                    </div>

                    <div class="mb-6">
                        <label class="block font-label-bold text-on-surface mb-2">Địa chỉ nhận hàng (Chi tiết) *</label>
                        <textarea name="address" required rows="3" placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố..."
                                  class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface transition-colors">${sessionScope.USERMODEL.address}</textarea>
                    </div>
                </div>

                <!-- PHƯƠNG THỨC THANH TOÁN -->
                <div class="bg-surface-container-lowest p-6 md:p-8 rounded-xl shadow-sm border border-outline-variant">
                    <h2 class="font-headline-md text-xl text-on-surface mb-6 border-b border-surface-variant pb-4">Phương thức thanh toán</h2>

                    <div class="space-y-4">
                        <!-- COD -->
                        <label class="flex items-center p-4 border border-outline-variant rounded-lg cursor-pointer hover:bg-surface-container transition-colors">
                            <input type="radio" name="paymentMethod" value="COD" checked class="w-5 h-5 text-primary focus:ring-primary border-outline-variant">
                            <span class="ml-4 font-label-bold text-on-surface flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary">local_shipping</span>
                                    Thanh toán khi nhận hàng (COD)
                                </span>
                        </label>

                        <!-- VNPAY -->
                        <label class="flex items-center p-4 border border-outline-variant rounded-lg cursor-pointer hover:bg-surface-container transition-colors">
                            <input type="radio" name="paymentMethod" value="VNPAY" class="w-5 h-5 text-primary focus:ring-primary border-outline-variant">
                            <span class="ml-4 font-label-bold text-on-surface flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary">qr_code_scanner</span>
                                    Thanh toán qua VNPAY-QR
                                </span>
                        </label>

                        <!-- MoMo -->
                        <label class="flex items-center p-4 border border-outline-variant rounded-lg cursor-pointer hover:bg-surface-container transition-colors">
                            <input type="radio" name="paymentMethod" value="MOMO" class="w-5 h-5 text-primary focus:ring-primary border-outline-variant">
                            <span class="ml-4 font-label-bold text-on-surface flex items-center gap-2">
                                    <span class="material-symbols-outlined text-[#a50064]">account_balance_wallet</span>
                                    Thanh toán qua Ví MoMo
                                </span>
                        </label>
                    </div>
                </div>
            </div>

            <!-- CỘT PHẢI: Box Tóm tắt đơn hàng -->
            <div class="w-full lg:w-1/3">
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-sm border border-outline-variant sticky top-28">
                    <h3 class="font-headline-md text-xl text-on-surface border-b border-surface-variant pb-4 mb-4">Đơn hàng của bạn</h3>

                    <!-- List Sản phẩm -->
                    <div class="space-y-4 mb-6 border-b border-surface-variant pb-6">
                        <c:set var="totalAmount" value="0"/>
                        <c:forEach var="item" items="${sessionScope.CART.values()}">
                            <c:set var="totalAmount" value="${totalAmount + item.subTotal}"/>

                            <div class="flex justify-between items-center">
                                <div class="flex items-center gap-3">
                                    <div class="relative w-12 h-12 rounded-md border border-outline-variant overflow-hidden">
                                        <img src="${item.imageUrl}" class="w-full h-full object-cover">
                                        <span class="absolute -top-1 -right-1 bg-surface-variant text-on-surface-variant text-[10px] w-4 h-4 flex items-center justify-center rounded-full font-bold">
                                                <c:out value="${item.quantity}"/>
                                            </span>
                                    </div>
                                    <span class="font-body-md text-on-surface line-clamp-1"><c:out value="${item.name}"/></span>
                                </div>
                                <span class="font-label-bold text-on-surface">
                                        <fmt:formatNumber value="${item.subTotal}" type="number" groupingUsed="true"/> ₫
                                    </span>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Tính tiền -->
                    <div class="flex justify-between items-center mb-4 text-on-surface-variant font-body-md">
                        <span>Tạm tính</span>
                        <span class="font-medium text-on-surface"><fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true"/> ₫</span>
                    </div>
                    <div class="flex justify-between items-center mb-4 text-on-surface-variant font-body-md border-b border-surface-variant pb-4">
                        <span>Phí giao hàng</span>
                        <span class="font-medium text-on-surface">Miễn phí</span>
                    </div>

                    <div class="flex justify-between items-center mb-8">
                        <span class="font-label-bold text-on-surface text-lg">Tổng thanh toán</span>
                        <span class="font-price-tag text-2xl text-primary">
                                <fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true"/> ₫
                            </span>
                    </div>

                    <button type="submit" class="w-full flex items-center justify-center bg-primary-container text-white py-4 rounded-full font-label-bold hover:bg-primary transition-all duration-300 shadow-md hover:-translate-y-1">
                        Xác nhận đặt hàng
                    </button>
                </div>
            </div>

        </form>
    </div>
</main>
</body>
</html>