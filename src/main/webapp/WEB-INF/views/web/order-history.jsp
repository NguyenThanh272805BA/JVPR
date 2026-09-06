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

<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<main class="max-w-container-max-width mx-auto py-12 px-margin-mobile md:px-margin-desktop w-full flex-grow flex gap-8 flex-col lg:flex-row">
    <!-- Sidebar Menu Khách hàng -->
    <aside class="w-full lg:w-1/4 bg-surface-container-lowest rounded-xl shadow-soft p-6 h-fit border border-outline-variant">
        <div class="text-center mb-6 border-b border-surface-variant pb-6">
            <div class="relative w-24 h-24 mx-auto mb-4 rounded-full border-4 border-surface-container-high overflow-hidden bg-surface-container flex items-center justify-center">
                <c:choose>
                    <c:when test="${not empty sessionScope.USERMODEL.avatarUrl}">
                        <img src="${sessionScope.USERMODEL.avatarUrl}" class="w-full h-full object-cover">
                    </c:when>
                    <c:otherwise>
                        <span class="material-symbols-outlined text-[48px] text-outline">person</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <h3 class="font-headline-md text-on-surface font-bold text-lg">${sessionScope.USERMODEL.fullName}</h3>
            <p class="text-xs text-on-surface-variant">${sessionScope.USERMODEL.phone != null ? sessionScope.USERMODEL.phone : sessionScope.USERMODEL.email}</p>
        </div>
        <ul class="space-y-2">
            <li><a href="${pageContext.request.contextPath}/profile" class="block py-2.5 px-4 text-on-surface hover:bg-surface-container rounded-lg transition-colors font-label-bold text-sm">Thông tin tài khoản</a></li>
            <li><a href="${pageContext.request.contextPath}/order-history" class="block py-2.5 px-4 bg-primary-container/20 text-primary font-label-bold rounded-lg border border-primary-container/30 text-sm">Lịch sử đơn hàng</a></li>
        </ul>
    </aside>

    <!-- Danh sách đơn hàng -->
    <div class="w-full lg:w-3/4">
        <h1 class="text-2xl font-headline-md font-bold mb-6 text-on-surface border-b border-surface-variant pb-4">Đơn hàng của bạn</h1>

        <!-- Flash messages -->
        <c:if test="${not empty sessionScope.ORDER_MESSAGE_SUCCESS}">
            <div class="mb-6 p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 flex items-center gap-3 shadow-sm">
                <span class="material-symbols-outlined text-emerald-600 text-2xl">check_circle</span>
                <div class="flex-grow font-medium text-sm"><c:out value="${sessionScope.ORDER_MESSAGE_SUCCESS}"/></div>
            </div>
            <c:remove var="ORDER_MESSAGE_SUCCESS" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.ORDER_MESSAGE_ERROR}">
            <div class="mb-6 p-4 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 flex items-center gap-3 shadow-sm">
                <span class="material-symbols-outlined text-rose-600 text-2xl">error</span>
                <div class="flex-grow font-medium text-sm"><c:out value="${sessionScope.ORDER_MESSAGE_ERROR}"/></div>
            </div>
            <c:remove var="ORDER_MESSAGE_ERROR" scope="session"/>
        </c:if>

        <div class="space-y-6">
            <c:forEach var="order" items="${orders}">
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-soft border border-outline-variant space-y-4">
                    <!-- Tiêu đề đơn hàng & Trạng thái đầy đủ -->
                    <div class="flex justify-between items-start border-b border-surface-variant pb-4">
                        <div>
                            <p class="text-sm text-on-surface-variant font-label-bold">Mã đơn hàng: <span class="text-primary">${order.orderCode}</span></p>
                            <p class="text-xs text-on-surface-variant mt-1"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
                        </div>

                        <!-- Badge Trạng thái hiển thị theo cập nhật từ Admin -->
                        <div>
                            <c:choose>
                                <c:when test="${order.status == 'COMPLETED'}">
                                    <span class="px-3.5 py-1.5 bg-green-100 text-green-700 rounded-full text-xs font-bold border border-green-200">Hoàn thành</span>
                                </c:when>
                                <c:when test="${order.status == 'DELIVERED'}">
                                    <span class="px-3.5 py-1.5 bg-emerald-100 text-emerald-700 rounded-full text-xs font-bold border border-emerald-300 animate-pulse">
                                        Đã giao hàng (Chờ bạn xác nhận)
                                    </span>
                                </c:when>
                                <c:when test="${order.status == 'SHIPPING'}">
                                    <span class="px-3.5 py-1.5 bg-blue-100 text-blue-700 rounded-full text-xs font-bold border border-blue-200">Đang giao hàng</span>
                                </c:when>
                                <c:when test="${order.status == 'RETURNED'}">
                                    <span class="px-3.5 py-1.5 bg-purple-100 text-purple-700 rounded-full text-xs font-bold border border-purple-200">Đã hoàn hàng</span>
                                </c:when>
                                <c:when test="${order.status == 'FAILED'}">
                                    <span class="px-3.5 py-1.5 bg-rose-100 text-rose-700 rounded-full text-xs font-bold border border-rose-200">Giao thất bại</span>
                                </c:when>
                                <c:when test="${order.status == 'CANCELLED'}">
                                    <span class="px-3.5 py-1.5 bg-red-100 text-red-700 rounded-full text-xs font-bold border border-red-200">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="px-3.5 py-1.5 bg-amber-100 text-amber-700 rounded-full text-xs font-bold border border-amber-200">Đang xử lý</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Danh sách món hàng -->
                    <div class="space-y-4 border-b border-surface-variant pb-4">
                        <c:forEach var="item" items="${order.details}">
                            <div class="flex items-center gap-4">
                                <div class="w-16 h-16 rounded-xl border border-outline-variant overflow-hidden flex-shrink-0 bg-surface-container">
                                    <img src="${item.productImageUrl}" alt="${item.productName}" class="w-full h-full object-cover">
                                </div>
                                <div class="flex-grow">
                                    <h4 class="font-label-bold text-on-surface text-sm line-clamp-1 hover:text-primary">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${item.productId}">${item.productName}</a>
                                    </h4>
                                    <p class="text-xs text-on-surface-variant mt-1">Số lượng: <span class="font-bold text-on-surface">x${item.quantity}</span></p>
                                </div>
                                <div class="font-price-tag text-base text-on-surface font-semibold">
                                    <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Footer Đơn hàng & Nút Tác vụ -->
                    <div class="flex flex-col sm:flex-row justify-between items-end gap-4 pt-1">
                        <div>
                            <p class="text-xs text-on-surface-variant">Phương thức: <span class="font-semibold text-on-surface">${order.paymentMethod}</span></p>
                            <p class="text-xs text-on-surface-variant mt-1 flex items-center gap-1">
                                Trạng thái:
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'PAID'}">
                                        <span class="text-primary font-bold flex items-center"><span class="material-symbols-outlined text-[14px] mr-1">check_circle</span> Đã thanh toán</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-amber-600 font-bold flex items-center"><span class="material-symbols-outlined text-[14px] mr-1">schedule</span> Chờ thanh toán</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="flex items-center gap-4 flex-wrap">
                            <div class="text-right">
                                <p class="text-xs text-on-surface-variant mb-0.5">Tổng cộng</p>
                                <p class="font-price-tag text-xl text-primary font-bold"><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫</p>
                            </div>

                            <!-- Nút Hủy Đơn Hàng (Chỉ khi status là PENDING) -->
                            <c:if test="${order.status == 'PENDING'}">
                                <button type="button" onclick="openCancelModal('${order.id}', '${order.orderCode}')" class="px-4 py-2 bg-rose-50 hover:bg-rose-100 text-rose-600 hover:text-rose-700 border border-rose-200 rounded-full font-label-bold text-xs shadow-sm transition-all flex items-center gap-1 whitespace-nowrap">
                                    <span class="material-symbols-outlined text-[16px]">cancel</span> Hủy đơn
                                </button>
                            </c:if>

                            <!-- Nút xác nhận hoàn tất đơn hàng khi Admin/Shipper cập nhật trạng thái DELIVERED hoặc SHIPPING -->
                            <c:if test="${order.status == 'DELIVERED' || order.status == 'SHIPPING'}">
                                <form action="${pageContext.request.contextPath}/order-history" method="POST" onsubmit="return confirm('Bạn xác nhận đã nhận đầy đủ hàng và đồng ý hoàn tất đơn hàng này?');">
                                    <input type="hidden" name="action" value="confirm_received">
                                    <input type="hidden" name="orderId" value="${order.id}">
                                    <button type="submit" class="px-5 py-2.5 bg-primary hover:bg-primary-container text-white rounded-full font-label-bold text-sm shadow-md transition-all flex items-center gap-1.5 whitespace-nowrap">
                                        <span class="material-symbols-outlined text-[18px]">verified</span> Đã nhận được hàng
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty orders}">
                <div class="bg-surface-container-lowest p-16 rounded-xl text-center border border-outline-variant shadow-sm flex flex-col items-center justify-center">
                    <div class="w-20 h-20 bg-surface-container rounded-full flex items-center justify-center mb-4 text-outline">
                        <span class="material-symbols-outlined text-[40px]">receipt_long</span>
                    </div>
                    <h3 class="font-headline-md text-lg text-on-surface mb-1 font-bold">Chưa có đơn hàng nào</h3>
                    <p class="text-on-surface-variant text-sm mb-6">Bạn chưa thực hiện bất kỳ giao dịch mua hàng nào.</p>
                    <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center bg-primary text-white font-label-bold py-2.5 px-6 rounded-full hover:bg-primary-container transition-all text-sm shadow-md">
                        Tiếp tục mua sắm <span class="material-symbols-outlined ml-1 text-base">arrow_forward</span>
                    </a>
                </div>
            </c:if>
        </div>
    </div>
</main>

<!-- Modal Xác nhận Hủy Đơn Hàng -->
<div id="cancelOrderModal" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-center justify-center p-4 transition-opacity">
    <div class="bg-surface-container-lowest rounded-2xl max-w-md w-full p-6 shadow-2xl border border-outline-variant transform transition-transform">
        <div class="flex items-center justify-between pb-3 border-b border-surface-variant">
            <div class="flex items-center gap-2 text-rose-600">
                <span class="material-symbols-outlined text-2xl">warning</span>
                <h3 class="font-headline-md font-bold text-lg text-on-surface">Xác nhận hủy đơn hàng</h3>
            </div>
            <button type="button" onclick="closeCancelModal()" class="text-on-surface-variant hover:text-on-surface p-1 rounded-full hover:bg-surface-container">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/order/cancel" method="POST" class="mt-4 space-y-4">
            <input type="hidden" name="from" value="history">
            <input type="hidden" id="modalCancelOrderId" name="orderId" value="">

            <p class="text-sm text-on-surface-variant">
                Bạn có chắc chắn muốn hủy đơn hàng <strong id="modalCancelOrderCode" class="text-primary"></strong>?
                Sau khi hủy, toàn bộ số lượng sản phẩm trong đơn sẽ được hoàn lại kho.
            </p>

            <div>
                <label class="block text-xs font-label-bold text-on-surface-variant mb-2">Vui lòng chọn lý do hủy đơn:</label>
                <div class="space-y-2 text-sm text-on-surface">
                    <label class="flex items-center gap-2 p-2.5 rounded-lg border border-outline-variant hover:bg-surface-container cursor-pointer">
                        <input type="radio" name="reason" value="Muốn thay đổi địa chỉ hoặc số điện thoại" checked class="text-primary focus:ring-primary">
                        <span>Muốn thay đổi địa chỉ hoặc số điện thoại</span>
                    </label>
                    <label class="flex items-center gap-2 p-2.5 rounded-lg border border-outline-variant hover:bg-surface-container cursor-pointer">
                        <input type="radio" name="reason" value="Muốn đổi hoặc thêm sản phẩm khác" class="text-primary focus:ring-primary">
                        <span>Muốn đổi hoặc thêm sản phẩm khác</span>
                    </label>
                    <label class="flex items-center gap-2 p-2.5 rounded-lg border border-outline-variant hover:bg-surface-container cursor-pointer">
                        <input type="radio" name="reason" value="Tìm thấy giá tốt hơn ở nơi khác" class="text-primary focus:ring-primary">
                        <span>Tìm thấy giá tốt hơn ở nơi khác</span>
                    </label>
                    <label class="flex items-center gap-2 p-2.5 rounded-lg border border-outline-variant hover:bg-surface-container cursor-pointer">
                        <input type="radio" name="reason" value="Đặt nhầm hoặc không còn nhu cầu" class="text-primary focus:ring-primary">
                        <span>Đặt nhầm hoặc không còn nhu cầu</span>
                    </label>
                </div>
            </div>

            <div class="flex items-center justify-end gap-3 pt-3 border-t border-surface-variant">
                <button type="button" onclick="closeCancelModal()" class="px-4 py-2 rounded-full border border-outline-variant text-on-surface hover:bg-surface-container text-sm font-label-bold transition-colors">
                    Đóng
                </button>
                <button type="submit" class="px-5 py-2 rounded-full bg-rose-600 hover:bg-rose-700 text-white text-sm font-label-bold shadow-md transition-all flex items-center gap-1">
                    <span class="material-symbols-outlined text-[18px]">check</span> Đồng ý hủy đơn
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function openCancelModal(orderId, orderCode) {
    document.getElementById('modalCancelOrderId').value = orderId;
    document.getElementById('modalCancelOrderCode').textContent = orderCode;
    document.getElementById('cancelOrderModal').classList.remove('hidden');
}
function closeCancelModal() {
    document.getElementById('cancelOrderModal').classList.add('hidden');
}
</script>

<jsp:include page="/WEB-INF/views/components/footer.jsp" />
</body>
</html>