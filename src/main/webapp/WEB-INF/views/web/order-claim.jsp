<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Bảo Hành 1 Đổi 1 Hoa Quả - Fruitables</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-surface-container bg-pattern min-h-screen flex flex-col antialiased">
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<main class="flex-grow py-8 md:py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-4xl mx-auto">
        <!-- BREADCRUMB -->
        <nav class="flex items-center gap-2 text-xs text-on-surface-variant mb-6 font-medium">
            <a href="${pageContext.request.contextPath}/home" class="hover:text-primary">Trang chủ</a>
            <span>/</span>
            <a href="${pageContext.request.contextPath}/order-history" class="hover:text-primary">Lịch sử đơn hàng</a>
            <span>/</span>
            <span class="text-on-surface font-bold">Chính sách 1 đổi 1</span>
        </nav>

        <!-- BANNER CAM KẾT -->
        <div class="bg-gradient-to-r from-emerald-800 via-teal-900 to-emerald-900 text-white rounded-3xl p-6 md:p-8 shadow-xl mb-8 relative overflow-hidden">
            <div class="relative z-10 space-y-2">
                <div class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-500/20 text-emerald-300 text-xs font-bold border border-emerald-500/30">
                    <span class="material-symbols-outlined text-sm">verified_user</span> Fruitables Care & Guarantee
                </div>
                <h1 class="font-headline-lg text-2xl sm:text-3xl font-extrabold tracking-tight">
                    Cam Kết Chất Lượng Hoa Quả Tươi 1 Đổi 1
                </h1>
                <p class="text-emerald-100 text-xs sm:text-sm max-w-xl leading-relaxed">
                    Nếu hoa quả có bất kỳ dấu hiệu dập nát do vận chuyển, úng hỏng bên trong hoặc không đạt độ ngọt cam kết, Fruitables sẵn sàng đổi quả mới tận cửa hoặc tặng voucher 100% không phiền hà.
                </p>
            </div>
            <span class="material-symbols-outlined absolute -right-6 -bottom-6 text-[180px] text-white/5 pointer-events-none">energy_savings_leaf</span>
        </div>

        <c:if test="${not empty sessionScope.ORDER_MESSAGE_SUCCESS}">
            <div class="mb-6 p-4 rounded-2xl bg-emerald-50 border border-emerald-200 text-emerald-900 flex items-center gap-3 shadow-sm">
                <span class="material-symbols-outlined text-emerald-600 text-2xl">check_circle</span>
                <div class="text-xs font-medium">${sessionScope.ORDER_MESSAGE_SUCCESS}</div>
            </div>
            <c:remove var="ORDER_MESSAGE_SUCCESS" scope="session"/>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
            <!-- CỘT TRÁI: FORM GỬI YÊU CẦU -->
            <div class="lg:col-span-7 space-y-6">
                <div class="bg-surface-container-lowest p-6 md:p-8 rounded-3xl shadow-sm border border-outline-variant">
                    <h2 class="font-headline-md text-base text-on-surface font-bold pb-3 border-b border-surface-variant flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary">add_photo_alternate</span>
                        Gửi Yêu Cầu Bồi Thường / Đổi Quả
                    </h2>

                    <form action="${pageContext.request.contextPath}/order/claim" method="POST" enctype="multipart/form-data" class="mt-5 space-y-4">
                        <input type="hidden" name="orderId" value="${order.id}">

                        <!-- Chọn sản phẩm bị lỗi -->
                        <div>
                            <label class="block text-xs font-bold text-on-surface mb-1.5">Chọn sản phẩm cần đổi/bồi thường: <span class="text-red-500">*</span></label>
                            <select name="productId" required class="w-full px-3 py-2.5 rounded-xl border border-outline-variant bg-surface-container-low text-xs font-medium focus:border-primary outline-none">
                                <c:forEach var="item" items="${order.details}">
                                    <option value="${item.productId}">
                                        ${item.productName} (SL: ${item.quantity} - <fmt:formatNumber value="${item.price}"/>₫)
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Lý do khiếu nại -->
                        <div>
                            <label class="block text-xs font-bold text-on-surface mb-1.5">Tình trạng hoa quả gặp phải: <span class="text-red-500">*</span></label>
                            <select name="reason" required class="w-full px-3 py-2.5 rounded-xl border border-outline-variant bg-surface-container-low text-xs font-medium focus:border-primary outline-none">
                                <option value="Quả bị dập nát, trầy xước do va đập vận chuyển">Quả bị dập nát, trầy xước do va đập vận chuyển</option>
                                <option value="Quả bị úng, thâm đen hoặc thối hỏng bên trong">Quả bị úng, thâm đen hoặc thối hỏng bên trong</option>
                                <option value="Quả bị chua, chát hoặc sượng, không đúng cam kết ngọt">Quả bị chua, chát hoặc sượng, không đúng cam kết</option>
                                <option value="Quả héo, vỏ nhăn nheo, không còn giữ độ giòn tươi">Quả héo, vỏ nhăn nheo, không còn tươi giòn</option>
                                <option value="Giao sai chủng loại hoặc thiếu số lượng quả">Giao sai chủng loại hoặc thiếu số lượng quả</option>
                            </select>
                        </div>

                        <!-- Phương án mong muốn -->
                        <div>
                            <label class="block text-xs font-bold text-on-surface mb-1.5">Phương án bồi thường mong muốn: <span class="text-red-500">*</span></label>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <label class="flex items-center p-3 rounded-xl border border-outline-variant cursor-pointer hover:bg-surface-container transition-colors">
                                    <input type="radio" name="claimSolution" value="REPLACE_PRODUCT" checked class="w-4 h-4 text-primary">
                                    <span class="ml-2.5 text-xs font-semibold text-on-surface">📦 Đổi quả mới hỏa tốc</span>
                                </label>
                                <label class="flex items-center p-3 rounded-xl border border-outline-variant cursor-pointer hover:bg-surface-container transition-colors">
                                    <input type="radio" name="claimSolution" value="REFUND_VOUCHER" class="w-4 h-4 text-primary">
                                    <span class="ml-2.5 text-xs font-semibold text-on-surface">🎟️ Bồi thường Voucher 100%</span>
                                </label>
                            </div>
                        </div>

                        <!-- Upload hình ảnh bằng chứng -->
                        <div>
                            <label class="block text-xs font-bold text-on-surface mb-1.5">Hình ảnh chụp phần quả bị dập/hỏng:</label>
                            <input type="file" name="proofImage" accept="image/*" class="w-full text-xs text-on-surface-variant file:mr-3 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-semibold file:bg-primary/10 file:text-primary hover:file:bg-primary/20 cursor-pointer">
                            <span class="text-[11px] text-on-surface-variant block mt-1">Chụp rõ phần quả bị ảnh hưởng để nhân viên CSKH duyệt đền bù nhanh nhất.</span>
                        </div>

                        <!-- Ghi chú chi tiết -->
                        <div>
                            <label class="block text-xs font-bold text-on-surface mb-1.5">Ghi chú thêm từ bạn:</label>
                            <textarea name="customerNote" rows="3" placeholder="Mô tả cụ thể thời điểm mở hộp quả, mùi vị hoặc số quả bị ảnh hưởng..."
                                      class="w-full px-3 py-2 rounded-xl border border-outline-variant bg-surface-container-low text-xs focus:border-primary outline-none"></textarea>
                        </div>

                        <button type="submit" class="w-full py-3 bg-primary hover:bg-primary-container text-white rounded-full font-bold text-xs shadow-md transition-all flex items-center justify-center gap-2">
                            <span class="material-symbols-outlined text-base">send</span> Gửi yêu cầu giải quyết
                        </button>
                    </form>
                </div>
            </div>

            <!-- CỘT PHẢI: LỊCH SỬ KHIẾU NẠI & ĐƠN HÀNG -->
            <div class="lg:col-span-5 space-y-6">
                <!-- TÓM TẮT ĐƠN HÀNG -->
                <div class="bg-surface-container-lowest p-5 rounded-3xl shadow-sm border border-outline-variant space-y-3">
                    <h3 class="font-headline-md text-sm text-on-surface font-bold pb-2 border-b border-surface-variant flex items-center justify-between">
                        <span>Đơn Hàng #${order.orderCode}</span>
                        <span class="text-[11px] text-emerald-600 font-bold">Hoàn tất</span>
                    </h3>
                    <div class="text-xs space-y-1.5 text-on-surface-variant">
                        <div>Người nhận: <strong class="text-on-surface">${order.recipientName}</strong></div>
                        <div>Số điện thoại: <strong class="text-on-surface">${order.phone}</strong></div>
                        <div>Địa chỉ: <span class="text-on-surface">${order.shippingAddress}</span></div>
                    </div>
                </div>

                <!-- DANH SÁCH YÊU CẦU ĐÃ GỬI -->
                <div class="bg-surface-container-lowest p-5 rounded-3xl shadow-sm border border-outline-variant space-y-4">
                    <h3 class="font-headline-md text-sm text-on-surface font-bold pb-2 border-b border-surface-variant flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-primary">history</span>
                        Lịch Sử Khiếu Nại Của Đơn
                    </h3>

                    <c:choose>
                        <c:when test="${not empty existingClaims}">
                            <div class="space-y-4">
                                <c:forEach var="c" items="${existingClaims}">
                                    <div class="p-4 rounded-2xl bg-surface-container/60 border border-outline-variant space-y-3">
                                        <div class="flex items-center justify-between">
                                            <span class="text-xs font-bold text-on-surface">${c.productName}</span>
                                            <c:choose>
                                                <c:when test="${c.status == 'APPROVED'}">
                                                    <span class="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800">Đã duyệt đền bù</span>
                                                </c:when>
                                                <c:when test="${c.status == 'REJECTED'}">
                                                    <span class="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-rose-100 text-rose-800">Từ chối</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-amber-100 text-amber-800">Đang chờ xử lý</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <p class="text-xs text-on-surface-variant">${c.reason}</p>

                                        <c:if test="${not empty c.proofImageUrl}">
                                            <div class="w-20 h-20 rounded-xl overflow-hidden border border-outline-variant">
                                                <img src="${c.proofImageUrl}" alt="Proof" class="w-full h-full object-cover">
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty c.adminResponse}">
                                            <div class="p-2.5 rounded-xl bg-white text-xs border border-surface-variant text-slate-700">
                                                <strong class="text-primary block mb-0.5">Phản hồi từ CSKH Fruitables:</strong>
                                                ${c.adminResponse}
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty c.compensationVoucher}">
                                            <div class="p-2.5 rounded-xl bg-emerald-50 border border-emerald-300 text-emerald-800 text-xs flex items-center justify-between">
                                                <span>Mã Voucher bồi thường:</span>
                                                <span class="font-mono font-bold px-2 py-0.5 bg-white rounded border border-emerald-400 text-emerald-700 select-all">${c.compensationVoucher}</span>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-xs text-on-surface-variant italic py-2">Đơn hàng này chưa có yêu cầu đổi quả hoặc bồi thường nào.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/components/footer.jsp" />
</body>
</html>
