<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Lịch sử đơn hàng - Fruitables</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-surface-container bg-pattern min-h-screen flex flex-col antialiased">

<!-- NAVBAR -->
<nav class="bg-surface w-full sticky top-0 shadow-sm z-50">
    <div class="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <!-- Brand -->
        <a class="font-display-lg-mobile md:font-display-lg text-display-lg-mobile md:text-display-lg font-extrabold text-primary" href="${pageContext.request.contextPath}/home">
            Fruitables
        </a>

        <!-- Menu Links -->
        <div class="hidden md:flex space-x-8 items-center">
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/shop">Cửa hàng</a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/promotions">Khuyến mãi</a>
        </div>

        <!-- User Actions -->
        <div class="flex items-center space-x-4">
            <a href="${pageContext.request.contextPath}/cart" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors relative">
                <span class="material-symbols-outlined">shopping_cart</span>
                <c:if test="${not empty sessionScope.CART_TOTAL_ITEMS && sessionScope.CART_TOTAL_ITEMS > 0}">
                    <span class="absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center">
                        <c:out value="${sessionScope.CART_TOTAL_ITEMS}"/>
                    </span>
                </c:if>
            </a>

            <c:choose>
                <c:when test="${not empty sessionScope.USERMODEL}">
                    <!-- Đã đăng nhập -->
                    <div class="group relative cursor-pointer py-2">
                        <div class="flex items-center gap-2 text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors">
                            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">account_circle</span>
                            <span class="font-label-bold text-label-bold hidden md:block"><c:out value="${sessionScope.USERMODEL.fullName}"/></span>
                        </div>
                        <!-- Cập nhật thẻ z-index và hover cho thẻ Đăng xuất -->
                        <div class="absolute right-0 top-full mt-1 w-48 bg-surface-container-lowest rounded-md shadow-lg hidden group-hover:block border border-outline-variant z-[100] overflow-hidden">
                            <c:if test="${sessionScope.USERMODEL.roleId == 1 || sessionScope.USERMODEL.roleId == 2}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="block px-4 py-3 text-on-surface hover:bg-surface-container transition-colors">Trang Quản Trị</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/profile" class="block px-4 py-3 text-on-surface hover:bg-surface-container transition-colors">Trang cá nhân</a>
                            <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-3 text-error hover:bg-error-container transition-colors border-t border-surface-variant">Đăng xuất</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Chưa đăng nhập -->
                    <a href="${pageContext.request.contextPath}/login" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors" title="Đăng nhập">
                        <span class="material-symbols-outlined">person</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<!-- MAIN CONTENT -->
<main class="max-w-container-max-width mx-auto py-12 px-margin-mobile md:px-margin-desktop w-full flex-grow flex gap-8 flex-col lg:flex-row">
    <!-- Sidebar Menu Khách hàng -->
    <aside class="w-full lg:w-1/4 bg-surface-container-lowest rounded-xl shadow-soft p-6 h-fit border border-outline-variant">
        <div class="text-center mb-6 border-b border-surface-variant pb-6">
            <div class="relative w-24 h-24 mx-auto mb-4 rounded-full border-4 border-surface-container-high overflow-hidden bg-surface-container">
                <c:choose>
                    <c:when test="${not empty sessionScope.USERMODEL.avatarUrl}">
                        <img src="${sessionScope.USERMODEL.avatarUrl}" class="w-full h-full object-cover">
                    </c:when>
                    <c:otherwise>
                        <span class="material-symbols-outlined text-[48px] text-outline mt-3">person</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <h3 class="font-headline-md text-on-surface">${sessionScope.USERMODEL.fullName}</h3>
            <p class="text-sm text-on-surface-variant">${sessionScope.USERMODEL.email}</p>
        </div>
        <ul class="space-y-2">
            <li><a href="${pageContext.request.contextPath}/profile" class="block py-3 px-4 text-on-surface hover:bg-surface-container rounded-lg transition-colors font-label-bold">Thông tin tài khoản</a></li>
            <li><a href="${pageContext.request.contextPath}/order-history" class="block py-3 px-4 bg-primary-container/20 text-primary font-label-bold rounded-lg border border-primary-container/30">Lịch sử đơn hàng</a></li>
        </ul>
    </aside>

    <!-- Danh sách đơn hàng -->
    <div class="w-full lg:w-3/4">
        <h1 class="text-3xl font-headline-md mb-8 text-on-surface border-b border-surface-variant pb-4">Đơn hàng của bạn</h1>

        <div class="space-y-6">
            <c:forEach var="order" items="${orders}">
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-soft border border-outline-variant hover-lift transition-all">
                    <!-- Tiêu đề đơn hàng -->
                    <div class="flex justify-between items-start border-b border-surface-variant pb-4 mb-4">
                        <div>
                            <p class="text-sm text-on-surface-variant font-label-bold">Mã đơn hàng: <span class="text-primary">${order.orderCode}</span></p>
                            <p class="text-xs text-on-surface-variant mt-1"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
                        </div>

                        <!-- Badge Trạng thái -->
                        <c:choose>
                            <c:when test="${order.status == 'COMPLETED'}">
                                <span class="px-4 py-1.5 bg-primary-container/20 text-primary rounded-full text-xs font-bold border border-primary-container">Hoàn thành</span>
                            </c:when>
                            <c:when test="${order.status == 'CANCELLED'}">
                                <span class="px-4 py-1.5 bg-error-container text-error rounded-full text-xs font-bold border border-error/20">Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="px-4 py-1.5 bg-secondary-container/30 text-secondary rounded-full text-xs font-bold border border-secondary/20">Đang xử lý</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Danh sách món hàng (Có Ảnh) -->
                    <div class="space-y-4 mb-6 border-b border-surface-variant pb-6">
                        <c:forEach var="item" items="${order.details}">
                            <div class="flex items-center gap-4">
                                <div class="w-20 h-20 rounded-lg border border-outline-variant overflow-hidden flex-shrink-0 bg-surface-container">
                                    <img src="${item.productImageUrl}" alt="${item.productName}" class="w-full h-full object-cover">
                                </div>
                                <div class="flex-grow">
                                    <h4 class="font-label-bold text-on-surface text-base line-clamp-1 hover:text-primary"><a href="${pageContext.request.contextPath}/product-detail?id=${item.productId}">${item.productName}</a></h4>
                                    <p class="text-sm text-on-surface-variant mt-1">Số lượng: <span class="font-bold text-on-surface">x${item.quantity}</span></p>
                                </div>
                                <div class="font-price-tag text-lg text-on-surface">
                                    <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Footer Đơn hàng (Tổng tiền) -->
                    <div class="flex flex-col sm:flex-row justify-between items-end gap-4">
                        <div>
                            <p class="text-sm text-on-surface-variant">Phương thức: <span class="font-label-bold text-on-surface">${order.paymentMethod}</span></p>
                            <p class="text-sm text-on-surface-variant mt-1 flex items-center gap-1">Trạng thái:
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'PAID'}">
                                        <span class="text-primary font-label-bold flex items-center"><span class="material-symbols-outlined text-[16px] mr-1">check_circle</span> Đã thanh toán</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-secondary font-label-bold flex items-center"><span class="material-symbols-outlined text-[16px] mr-1">schedule</span> Chờ thanh toán</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="text-right">
                            <p class="text-sm text-on-surface-variant mb-1">Tổng cộng (Đã bao gồm thuế)</p>
                            <p class="font-price-tag text-2xl text-primary"><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫</p>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty orders}">
                <div class="bg-surface-container-lowest p-16 rounded-xl text-center border border-outline-variant shadow-sm flex flex-col items-center justify-center">
                    <div class="w-24 h-24 bg-surface-container rounded-full flex items-center justify-center mb-6">
                        <span class="material-symbols-outlined text-[48px] text-outline">receipt_long</span>
                    </div>
                    <h3 class="font-headline-md text-xl text-on-surface mb-2">Chưa có đơn hàng nào</h3>
                    <p class="text-on-surface-variant mb-8 max-w-md mx-auto">Có vẻ như bạn chưa thực hiện bất kỳ giao dịch nào. Khám phá ngay các sản phẩm tươi ngon của Fruitables.</p>
                    <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center bg-primary text-white font-label-bold py-3 px-8 rounded-full hover:bg-primary-container transition-all shadow-md hover:-translate-y-1">
                        Tiếp tục mua sắm <span class="material-symbols-outlined ml-2 text-[20px]">arrow_forward</span>
                    </a>
                </div>
            </c:if>
        </div>
    </div>
</main>

<!-- FOOTER -->
<footer class="bg-surface-container py-12 border-t border-outline-variant mt-auto">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto text-center text-on-surface-variant font-body-md">
        <p>© 2026 Fruitables.</p>
    </div>
</footer>

</body>
</html>