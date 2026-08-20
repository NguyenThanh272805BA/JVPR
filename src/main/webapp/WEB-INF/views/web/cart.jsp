<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Giỏ hàng - Fruitables</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>

<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col antialiased">

<!-- NAVBAR Tái sử dụng (Có cập nhật badge giỏ hàng tự động từ Session) -->
<nav class="bg-surface w-full sticky top-0 shadow-sm z-50">
    <div class="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <a class="font-display-lg-mobile md:font-display-lg text-display-lg-mobile md:text-display-lg font-extrabold text-primary" href="${pageContext.request.contextPath}/home">Fruitables</a>
        <div class="hidden md:flex space-x-8 items-center">
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/shop">Cửa hàng</a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/promotions">Khuyến mãi</a>
        </div>
        <div class="flex items-center space-x-4">
            <a href="${pageContext.request.contextPath}/cart" class="text-primary bg-surface-container-highest p-2 rounded-full transition-colors relative">
                <span class="material-symbols-outlined">shopping_cart</span>
                <!-- Hiển thị badge linh động -->
                <c:if test="${not empty sessionScope.CART_TOTAL_ITEMS && sessionScope.CART_TOTAL_ITEMS > 0}">
                        <span class="absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center">
                            <c:out value="${sessionScope.CART_TOTAL_ITEMS}"/>
                        </span>
                </c:if>
            </a>
            <!-- logic User account ở đây... -->
        </div>
    </div>
</nav>

<!-- MAIN CART CONTENT -->
<main class="flex-grow py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <h1 class="font-headline-md text-3xl text-on-surface mb-8 font-bold">Giỏ hàng của bạn</h1>

        <c:choose>
            <c:when test="${empty sessionScope.CART || sessionScope.CART.size() == 0}">
                <!-- TRẠNG THÁI GIỎ HÀNG TRỐNG -->
                <div class="text-center py-20 bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant">
                    <span class="material-symbols-outlined text-[80px] text-outline-variant mb-4">production_quantity_limits</span>
                    <h2 class="font-headline-md text-xl text-on-surface mb-2">Giỏ hàng đang trống</h2>
                    <p class="font-body-md text-on-surface-variant mb-6">Có vẻ như bạn chưa chọn sản phẩm nào.</p>
                    <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center px-6 py-3 bg-primary-container text-white font-label-bold rounded-full hover:bg-primary transition-colors">
                        Tiếp tục mua sắm
                    </a>
                </div>
            </c:when>

            <c:otherwise>
                <!-- CÓ HÀNG TRONG GIỎ -->
                <div class="flex flex-col lg:flex-row gap-8">

                    <!-- Cột Trái: Danh sách sản phẩm -->
                    <div class="w-full lg:w-2/3 bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant overflow-hidden">
                        <!-- Bảng sản phẩm -->
                        <div class="overflow-x-auto">
                            <table class="w-full text-left">
                                <thead class="bg-surface-container-low border-b border-surface-variant text-on-surface-variant">
                                <tr>
                                    <th class="py-4 px-6 font-label-bold">Sản phẩm</th>
                                    <th class="py-4 px-6 font-label-bold">Đơn giá</th>
                                    <th class="py-4 px-6 font-label-bold text-center">Số lượng</th>
                                    <th class="py-4 px-6 font-label-bold text-right">Tổng</th>
                                    <th class="py-4 px-6 text-center"></th>
                                </tr>
                                </thead>
                                <tbody class="divide-y divide-surface-variant">
                                <!-- Khởi tạo biến để tính tổng tiền giỏ hàng -->
                                <c:set var="cartTotal" value="0"/>

                                <!-- Duyệt qua Map.values() -->
                                <c:forEach var="item" items="${sessionScope.CART.values()}">

                                    <!-- Cộng dồn tổng tiền -->
                                    <c:set var="cartTotal" value="${cartTotal + item.subTotal}"/>

                                    <tr class="hover:bg-surface-bright transition-colors">
                                        <td class="py-4 px-6 flex items-center gap-4">
                                            <img src="${item.imageUrl}" alt="${item.name}" class="w-16 h-16 object-cover rounded-md border border-outline-variant">
                                            <span class="font-label-bold text-on-surface"><c:out value="${item.name}"/></span>
                                        </td>
                                        <td class="py-4 px-6 text-on-surface">
                                            <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td class="py-4 px-6">
                                            <!-- Form Cập nhật số lượng -->
                                            <form action="${pageContext.request.contextPath}/cart" method="POST" class="flex items-center justify-center bg-surface-container rounded-md w-max mx-auto overflow-hidden border border-outline-variant">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="${item.productId}">

                                                <button type="submit" onclick="this.nextElementSibling.value--" class="px-2 py-1 hover:text-primary transition-colors">
                                                    <span class="material-symbols-outlined text-[16px]">remove</span>
                                                </button>

                                                <input type="number" name="quantity" value="${item.quantity}" min="1" class="w-12 text-center bg-transparent border-none outline-none text-sm p-0 font-label-bold" onchange="this.form.submit()">

                                                <button type="submit" onclick="this.previousElementSibling.value++" class="px-2 py-1 hover:text-primary transition-colors">
                                                    <span class="material-symbols-outlined text-[16px]">add</span>
                                                </button>
                                            </form>
                                        </td>
                                        <td class="py-4 px-6 text-right font-price-tag text-primary">
                                            <fmt:formatNumber value="${item.subTotal}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td class="py-4 px-6 text-center">
                                            <!-- Form Xóa khỏi giỏ -->
                                            <form action="${pageContext.request.contextPath}/cart" method="POST">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <button type="submit" class="text-on-surface-variant hover:text-error transition-colors p-2 bg-surface-container rounded-full hover:bg-error-container" title="Xóa">
                                                    <span class="material-symbols-outlined text-[20px]">delete</span>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Cột Phải: Box Tóm tắt -->
                    <div class="w-full lg:w-1/3">
                        <div class="bg-surface-container-lowest p-6 rounded-xl shadow-sm border border-outline-variant sticky top-28">
                            <h3 class="font-headline-md text-xl text-on-surface border-b border-surface-variant pb-4 mb-4">Tổng đơn hàng</h3>

                            <div class="flex justify-between items-center mb-4 text-on-surface-variant font-body-md">
                                <span>Tạm tính</span>
                                <span class="font-medium text-on-surface">
                                        <fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/> ₫
                                    </span>
                            </div>
                            <div class="flex justify-between items-center mb-4 text-on-surface-variant font-body-md border-b border-surface-variant pb-4">
                                <span>Phí giao hàng</span>
                                <span class="font-medium text-on-surface">Miễn phí</span>
                            </div>

                            <div class="flex justify-between items-center mb-8">
                                <span class="font-label-bold text-on-surface">Tổng thanh toán</span>
                                <span class="font-price-tag text-2xl text-primary">
                                        <fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/> ₫
                                    </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/checkout" class="w-full flex items-center justify-center bg-primary-container text-white py-4 rounded-full font-label-bold hover:bg-primary transition-all duration-300 shadow-md hover:-translate-y-1">
                                Tiến hành thanh toán
                            </a>
                            <a href="${pageContext.request.contextPath}/shop" class="w-full text-center block mt-4 text-on-surface-variant hover:text-primary font-body-md transition-colors">
                                Tiếp tục mua sắm
                            </a>
                        </div>
                    </div>

                </div>
                <!-- BỘ KHUNG NHẬP VOUCHER -->
                <div class="mt-6 pt-6 border-t border-surface-variant">
                    <label class="block font-label-bold text-on-surface mb-2">Mã giảm giá / Voucher</label>

                    <c:choose>
                        <%-- TRƯỜNG HỢP CHƯA ĐĂNG NHẬP: Bắt buộc đăng nhập để dùng voucher --%>
                        <c:when test="${empty sessionScope.USERMODEL}">
                            <div class="p-3 bg-surface-container rounded-lg text-sm text-on-surface-variant flex items-center justify-between">
                                <span>Đăng nhập để sử dụng Voucher độc quyền cho thành viên!</span>
                                <a href="${pageContext.request.contextPath}/login" class="text-primary font-label-bold hover:underline whitespace-nowrap ml-2">Đăng nhập</a>
                            </div>
                        </c:when>

                        <%-- TRƯỜNG HỢP ĐÃ ĐĂNG NHẬP: Cho phép nhập mã voucher --%>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/apply-coupon" method="POST" class="flex gap-2">
                                <input type="text" name="couponCode" placeholder="Nhập mã (VD: FRUIT50K)"
                                       class="flex-1 px-3 py-2 rounded-md border border-outline-variant outline-none focus:border-primary text-sm bg-surface-container-lowest">
                                <button type="submit" class="px-4 py-2 bg-primary text-white font-label-bold rounded-md hover:bg-primary-container transition-colors text-sm">
                                    Áp dụng
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<!-- FOOTER -->
<footer class="bg-surface-container py-6 border-t border-outline-variant mt-auto text-center text-on-surface-variant font-body-md">
    <p>© 2026 Fruitables.</p>
</footer>
</body>
</html>