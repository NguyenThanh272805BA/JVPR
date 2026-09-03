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

<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<main class="flex-grow py-10 md:py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <h1 class="font-headline-md text-2xl md:text-3xl text-on-surface mb-8 font-extrabold flex items-center gap-3">
            <span class="material-symbols-outlined text-primary text-3xl">shopping_cart</span> Giỏ hàng của bạn
        </h1>

        <c:choose>
            <c:when test="${empty sessionScope.CART || sessionScope.CART.size() == 0}">
                <div class="text-center py-20 bg-surface-container-lowest rounded-2xl shadow-sm border border-outline-variant max-w-2xl mx-auto p-6">
                    <div class="w-20 h-20 bg-surface-container rounded-full flex items-center justify-center mx-auto mb-4 text-outline">
                        <span class="material-symbols-outlined text-4xl">production_quantity_limits</span>
                    </div>
                    <h2 class="font-headline-md text-xl text-on-surface mb-2 font-bold">Giỏ hàng đang trống</h2>
                    <p class="font-body-md text-on-surface-variant text-sm mb-6">Bạn chưa có sản phẩm nào trong giỏ hàng. Hãy khám phá ngay các món tươi ngon của chúng tôi!</p>
                    <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center px-6 py-3 bg-primary text-white font-label-bold rounded-full hover:bg-primary-container transition-colors shadow-md text-sm">
                        <span class="material-symbols-outlined mr-2 text-base">storefront</span> Mua sắm ngay
                    </a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="flex flex-col lg:flex-row gap-8 items-start">
                    <!-- Danh sách sản phẩm trong giỏ -->
                    <div class="w-full lg:w-2/3 bg-surface-container-lowest rounded-2xl shadow-sm border border-outline-variant overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left">
                                <thead class="bg-surface-container-low border-b border-surface-variant text-on-surface-variant text-xs uppercase tracking-wider">
                                <tr>
                                    <th class="py-4 px-6 font-label-bold">Sản phẩm</th>
                                    <th class="py-4 px-6 font-label-bold">Đơn giá</th>
                                    <th class="py-4 px-6 font-label-bold text-center">Số lượng</th>
                                    <th class="py-4 px-6 font-label-bold text-right">Tổng</th>
                                    <th class="py-4 px-6 text-center"></th>
                                </tr>
                                </thead>
                                <tbody class="divide-y divide-surface-variant text-sm">
                                <c:set var="cartTotal" value="0"/>

                                <c:forEach var="item" items="${sessionScope.CART.values()}">
                                    <c:set var="cartTotal" value="${cartTotal + item.subTotal}"/>
                                    <tr class="hover:bg-surface-bright transition-colors">
                                        <td class="py-4 px-6 flex items-center gap-3">
                                            <img src="${item.imageUrl}" alt="${item.name}" class="w-16 h-16 object-cover rounded-xl border border-outline-variant flex-shrink-0">
                                            <span class="font-label-bold text-on-surface line-clamp-2"><c:out value="${item.name}"/></span>
                                        </td>
                                        <td class="py-4 px-6 text-on-surface whitespace-nowrap">
                                            <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td class="py-4 px-6">
                                            <form action="${pageContext.request.contextPath}/cart" method="POST" class="flex items-center justify-center bg-surface-container rounded-lg w-max mx-auto overflow-hidden border border-outline-variant">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <button type="submit" onclick="this.nextElementSibling.value--" class="px-2.5 py-1 text-on-surface hover:text-primary transition-colors">
                                                    <span class="material-symbols-outlined text-[16px] block">remove</span>
                                                </button>
                                                <input type="number" name="quantity" value="${item.quantity}" min="1" class="w-10 text-center bg-transparent border-none outline-none text-sm p-0 font-label-bold" onchange="this.form.submit()">
                                                <button type="submit" onclick="this.previousElementSibling.value++" class="px-2.5 py-1 text-on-surface hover:text-primary transition-colors">
                                                    <span class="material-symbols-outlined text-[16px] block">add</span>
                                                </button>
                                            </form>
                                        </td>
                                        <td class="py-4 px-6 text-right font-price-tag text-primary font-bold whitespace-nowrap">
                                            <fmt:formatNumber value="${item.subTotal}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td class="py-4 px-6 text-center">
                                            <form action="${pageContext.request.contextPath}/cart" method="POST">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <button type="submit" class="text-on-surface-variant hover:text-error transition-colors p-1.5 rounded-full hover:bg-error-container" title="Xóa món này">
                                                    <span class="material-symbols-outlined text-[18px] block">delete</span>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Hộp tổng kết thanh toán & Voucher -->
                    <div class="w-full lg:w-1/3 flex flex-col gap-6">
                        <div class="bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-outline-variant sticky top-28">
                            <h3 class="font-headline-md text-lg text-on-surface border-b border-surface-variant pb-3 mb-4 font-bold">Tổng quan đơn hàng</h3>

                            <div class="flex justify-between items-center mb-3 text-on-surface-variant text-sm">
                                <span>Tạm tính</span>
                                <span class="font-semibold text-on-surface">
                                    <fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/> ₫
                                </span>
                            </div>
                            <div class="flex justify-between items-center mb-4 text-on-surface-variant text-sm border-b border-surface-variant pb-3">
                                <span>Phí vận chuyển</span>
                                <span class="font-semibold text-primary">Miễn phí</span>
                            </div>

                            <div class="flex justify-between items-center mb-6">
                                <span class="font-label-bold text-on-surface text-base">Tổng thanh toán</span>
                                <span class="font-price-tag text-2xl text-primary font-extrabold">
                                    <fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/> ₫
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/checkout" class="w-full flex items-center justify-center bg-primary text-white py-3.5 rounded-full font-label-bold text-base hover:bg-primary-container transition-all duration-300 shadow-md hover:-translate-y-0.5">
                                Tiến hành thanh toán
                            </a>
                            <a href="${pageContext.request.contextPath}/shop" class="w-full text-center block mt-3 text-on-surface-variant hover:text-primary font-body-md text-sm transition-colors">
                                Tiếp tục mua sắm
                            </a>

                            <!-- KHUNG NHẬP MÃ GIẢM GIÁ -->
                            <div class="mt-6 pt-5 border-t border-surface-variant">
                                <label class="block font-label-bold text-sm text-on-surface mb-2">Mã giảm giá (Voucher)</label>
                                <c:choose>
                                    <c:when test="${empty sessionScope.USERMODEL}">
                                        <div class="p-3 bg-surface-container rounded-xl text-xs text-on-surface-variant flex items-center justify-between">
                                            <span>Đăng nhập để dùng mã giảm giá độc quyền!</span>
                                            <a href="${pageContext.request.contextPath}/login" class="text-primary font-bold hover:underline ml-2 whitespace-nowrap">Đăng nhập</a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/apply-coupon" method="POST" class="flex gap-2">
                                            <input type="text" name="couponCode" placeholder="Nhập mã (VD: SALE50K)"
                                                   class="flex-1 px-3 py-2 rounded-xl border border-outline-variant outline-none focus:border-primary text-xs uppercase bg-surface-container-lowest">
                                            <button type="submit" class="px-4 py-2 bg-primary text-white font-label-bold rounded-xl hover:bg-primary-container transition-colors text-xs">
                                                Áp dụng
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/components/footer.jsp" />
</body>
</html>