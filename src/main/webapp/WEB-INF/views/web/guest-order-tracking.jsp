<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Tra cứu đơn hàng - Fruitables</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col antialiased">

<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<main class="flex-grow py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <div class="max-w-2xl mx-auto text-center mb-10">
            <h1 class="font-headline-md text-3xl font-extrabold text-on-surface mb-3">Tra cứu tiến độ đơn hàng</h1>
            <p class="text-on-surface-variant text-sm">Dành cho khách hàng chưa có tài khoản hoặc muốn theo dõi trạng thái giao hàng nhanh chóng qua Số điện thoại hoặc Mã đơn.</p>
        </div>

        <!-- Form tra cứu -->
        <div class="max-w-xl mx-auto bg-surface-container-lowest p-6 md:p-8 rounded-2xl shadow-sm border border-outline-variant mb-12">
            <form action="${pageContext.request.contextPath}/guest-tracking" method="POST" class="space-y-4">
                <div>
                    <label class="block font-label-bold text-on-surface mb-1.5">Số điện thoại đặt hàng</label>
                    <input type="tel" name="phone" placeholder="VD: 0988888888" value="${param.phone}"
                           class="w-full px-4 py-3 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface">
                </div>
                <div class="text-center font-label-bold text-xs text-on-surface-variant">--- HOẶC ---</div>
                <div>
                    <label class="block font-label-bold text-on-surface mb-1.5">Mã đơn hàng</label>
                    <input type="text" name="orderCode" placeholder="VD: ORD-1729000000" value="${param.orderCode}"
                           class="w-full px-4 py-3 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface uppercase">
                </div>
                <button type="submit" class="w-full bg-primary hover:bg-primary-container text-white py-3.5 rounded-xl font-label-bold text-base transition-all shadow-md mt-2 flex items-center justify-center gap-2">
                    <span class="material-symbols-outlined">search</span> Tra cứu ngay
                </button>
            </form>
        </div>

        <!-- Kết quả tra cứu -->
        <c:if test="${searched}">
            <div class="max-w-4xl mx-auto">
                <c:choose>
                    <c:when test="${not empty foundOrders}">
                        <h2 class="font-headline-md text-xl text-on-surface mb-6 font-bold flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary">inventory_2</span> Kết quả tìm thấy (${foundOrders.size()} đơn hàng)
                        </h2>
                        <div class="space-y-6">
                            <c:forEach var="order" items="${foundOrders}">
                                <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant shadow-sm space-y-4">
                                    <div class="flex flex-col md:flex-row md:items-center justify-between pb-4 border-b border-surface-variant gap-2">
                                        <div>
                                            <span class="text-xs text-on-surface-variant">Mã đơn hàng:</span>
                                            <span class="font-label-bold text-primary text-lg ml-1">${order.orderCode}</span>
                                            <span class="text-xs text-on-surface-variant block mt-1"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                        </div>
                                        <div>
                                            <c:choose>
                                                <c:when test="${order.status == 'COMPLETED'}"><span class="px-3 py-1 bg-green-100 text-green-700 rounded-full text-xs font-bold">Hoàn tất</span></c:when>
                                                <c:when test="${order.status == 'DELIVERED'}"><span class="px-3 py-1 bg-emerald-100 text-emerald-700 rounded-full text-xs font-bold">Giao thành công</span></c:when>
                                                <c:when test="${order.status == 'SHIPPING'}"><span class="px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-xs font-bold">Đang giao hàng</span></c:when>
                                                <c:when test="${order.status == 'RETURNED'}"><span class="px-3 py-1 bg-purple-100 text-purple-700 rounded-full text-xs font-bold">Đơn hoàn hàng</span></c:when>
                                                <c:when test="${order.status == 'FAILED'}"><span class="px-3 py-1 bg-rose-100 text-rose-700 rounded-full text-xs font-bold">Giao thất bại</span></c:when>
                                                <c:when test="${order.status == 'CANCELLED'}"><span class="px-3 py-1 bg-red-100 text-red-700 rounded-full text-xs font-bold">Đã hủy</span></c:when>
                                                <c:otherwise><span class="px-3 py-1 bg-amber-100 text-amber-700 rounded-full text-xs font-bold">Đang xử lý</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                                        <div>
                                            <p class="text-on-surface-variant">SĐT người nhận:</p>
                                            <p class="font-semibold text-on-surface">${order.phone}</p>
                                        </div>
                                        <div class="md:col-span-2">
                                            <p class="text-on-surface-variant">Địa chỉ giao:</p>
                                            <p class="font-semibold text-on-surface">${order.shippingAddress}</p>
                                        </div>
                                    </div>
                                    <div class="flex justify-between items-center pt-4 border-t border-surface-variant text-sm">
                                        <div>
                                            <span class="text-on-surface-variant">Phương thức:</span>
                                            <span class="font-medium text-on-surface">${order.paymentMethod}</span>
                                            <span class="ml-2 font-bold ${order.paymentStatus == 'PAID' ? 'text-primary' : 'text-error'}">(${order.paymentStatus == 'PAID' ? 'Đã thanh toán' : 'Chưa thanh toán'})</span>
                                        </div>
                                        <div class="text-right">
                                            <span class="text-on-surface-variant mr-1">Tổng tiền:</span>
                                            <span class="font-price-tag text-lg text-primary font-bold"><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-surface-container-lowest p-12 rounded-xl text-center border border-outline-variant shadow-sm">
                            <span class="material-symbols-outlined text-5xl text-outline-variant mb-2">search_off</span>
                            <p class="font-label-bold text-on-surface text-lg">Không tìm thấy đơn hàng nào</p>
                            <p class="text-sm text-on-surface-variant mt-1">Vui lòng kiểm tra lại Số điện thoại hoặc Mã đơn hàng của bạn.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>
</main>

<jsp:include page="/WEB-INF/views/components/footer.jsp" />
</body>
</html>