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
    <aside class="w-full md:w-1/4">
      <div class="bg-surface-container-lowest p-6 rounded-2xl border border-outline-variant shadow-sm sticky top-28">
        <div class="flex items-center gap-4 mb-6 pb-6 border-b border-surface-variant">
          <div class="w-16 h-16 rounded-full border-2 border-primary flex items-center justify-center bg-surface-container overflow-hidden shrink-0">
            <c:choose>
                <c:when test="${not empty sessionScope.USERMODEL.avatarUrl}">
                    <img src="${sessionScope.USERMODEL.avatarUrl}" alt="Avatar" class="w-full h-full object-cover">
                </c:when>
                <c:otherwise>
                    <span class="material-symbols-outlined text-primary text-3xl">person</span>
                </c:otherwise>
            </c:choose>
          </div>

          <div class="overflow-hidden">
            <p class="text-xs text-on-surface-variant">Tài khoản</p>
            <p class="font-label-bold text-base text-on-surface truncate">${sessionScope.USERMODEL.fullName}</p>
          </div>
        </div>

        <ul class="space-y-2 font-label-bold text-sm">
          <li>
            <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-3 p-3 rounded-xl text-on-surface-variant hover:bg-surface-container hover:text-on-surface transition-colors">
              <span class="material-symbols-outlined text-[20px]">manage_accounts</span> Thông tin tài khoản
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/order-history" class="flex items-center gap-3 p-3 rounded-xl bg-primary/10 text-primary">
              <span class="material-symbols-outlined text-[20px]">receipt_long</span> Lịch sử đơn hàng
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/guest-tracking" class="flex items-center gap-3 p-3 rounded-xl text-on-surface-variant hover:bg-surface-container hover:text-on-surface transition-colors">
              <span class="material-symbols-outlined text-[20px]">local_shipping</span> Tra cứu đơn hàng
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-3 p-3 rounded-xl text-error hover:bg-error-container transition-colors mt-2 border-t border-surface-variant pt-4">
              <span class="material-symbols-outlined text-[20px]">logout</span> Đăng xuất
            </a>
          </li>
        </ul>
      </div>
    </aside>

    <!-- Danh sách đơn hàng -->
    <div class="w-full lg:w-3/4">
        <h1 class="text-2xl font-headline-md font-bold mb-6 text-on-surface border-b border-surface-variant pb-4 flex items-center justify-between">
            <span>Lịch sử đơn hàng</span>
            <span class="text-xs font-normal text-on-surface-variant">Tổng cộng ${orders.size()} đơn hàng</span>
        </h1>

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
                                        <span class="px-3.5 py-1.5 bg-emerald-100 text-emerald-700 rounded-full text-xs font-bold border border-emerald-300">
                                            Đã giao hàng (Chờ bạn xác nhận)
                                        </span>
                                    </c:when>
                                    <c:when test="${order.status == 'SHIPPING'}">
                                        <span class="px-3.5 py-1.5 bg-sky-100 text-sky-700 rounded-full text-xs font-bold border border-sky-300 animate-pulse">Đang giao hàng hỏa tốc</span>
                                    </c:when>
                                    <c:when test="${order.status == 'PACKING'}">
                                        <span class="px-3.5 py-1.5 bg-indigo-100 text-indigo-700 rounded-full text-xs font-bold border border-indigo-200">Đóng gói & Ướp lạnh</span>
                                    </c:when>
                                    <c:when test="${order.status == 'CONFIRMED'}">
                                        <span class="px-3.5 py-1.5 bg-cyan-100 text-cyan-700 rounded-full text-xs font-bold border border-cyan-200">Đã xác nhận đơn</span>
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

                        <!-- Banner thông báo chi tiết khi GIAO THẤT BẠI hoặc HOÀN HÀNG -->
                        <c:if test="${order.status == 'FAILED'}">
                            <div class="p-4 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 text-xs space-y-2">
                                <div class="flex items-center gap-2 font-bold text-sm text-rose-700">
                                    <span class="material-symbols-outlined text-rose-600 text-xl">error</span>
                                    <span>Giao hàng chưa thành công (Lần ${order.deliveryAttempts > 0 ? order.deliveryAttempts : 1})</span>
                                </div>
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-2 text-[11px] text-rose-900/80 bg-white/70 p-3 rounded-lg border border-rose-100">
                                    <div>
                                        <span class="text-slate-500 block">Lý do ghi nhận từ Shipper:</span>
                                        <strong class="text-rose-800"><c:out value="${not empty order.failedReason ? order.failedReason : 'Chưa liên lạc được với khách hàng'}"/></strong>
                                    </div>
                                    <c:if test="${not empty order.failedNotes}">
                                        <div>
                                            <span class="text-slate-500 block">Ghi chú chi tiết:</span>
                                            <span class="text-slate-700"><c:out value="${order.failedNotes}"/></span>
                                        </div>
                                    </c:if>
                                </div>
                                <p class="text-[11px] text-rose-700 mt-1 flex items-center gap-1">
                                    <span class="material-symbols-outlined text-sm">support_agent</span>
                                    Shipper hoặc CSKH Fruitables sẽ liên hệ lại với bạn qua số điện thoại để hẹn lịch giao lại hoa quả tươi.
                                </p>
                            </div>
                        </c:if>
                        <c:if test="${order.status == 'RETURNED'}">
                            <div class="p-4 rounded-xl bg-purple-50 border border-purple-200 text-purple-800 text-xs flex items-center gap-3">
                                <span class="material-symbols-outlined text-2xl text-purple-600 flex-shrink-0">assignment_return</span>
                                <div>
                                    <div class="font-bold text-sm text-purple-900">Đơn hàng đã hoàn hàng về kho</div>
                                    <p class="text-[11px] text-purple-700 mt-0.5">Hoa quả đã được hoàn trả lại về kho bảo quản lạnh của Fruitables. Số điểm tích lũy (nếu có dùng) đã được hoàn trả đầy đủ vào tài khoản của bạn.</p>
                                </div>
                            </div>
                        </c:if>

                        <!-- Stepper tiến độ đơn hàng -->
                        <c:if test="${order.status != 'CANCELLED' && order.status != 'RETURNED' && order.status != 'FAILED'}">
                            <c:set var="uStep" value="1"/>
                            <c:if test="${order.status == 'CONFIRMED'}"><c:set var="uStep" value="2"/></c:if>
                            <c:if test="${order.status == 'PACKING'}"><c:set var="uStep" value="3"/></c:if>
                            <c:if test="${order.status == 'SHIPPING'}"><c:set var="uStep" value="4"/></c:if>
                            <c:if test="${order.status == 'DELIVERED' || order.status == 'COMPLETED'}"><c:set var="uStep" value="5"/></c:if>

                            <div class="py-3 px-2 bg-surface-container-low/40 rounded-xl border border-surface-variant">
                                <div class="flex items-center justify-between relative">
                                    <div class="absolute left-0 top-1/2 -translate-y-1/2 w-full h-1 bg-surface-variant z-0 rounded-full"></div>
                                    <div class="absolute left-0 top-1/2 -translate-y-1/2 h-1 bg-primary z-0 rounded-full transition-all duration-500"
                                         style="width: ${(uStep - 1) * 25}%;"></div>

                                    <div class="flex flex-col items-center relative z-10">
                                        <div class="w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs shadow-sm ${uStep >= 1 ? 'bg-primary text-white ring-4 ring-primary/20' : 'bg-surface-container text-on-surface-variant'}">
                                            <span class="material-symbols-outlined text-sm">receipt</span>
                                        </div>
                                        <span class="text-[10px] font-label-bold mt-1.5 ${uStep >= 1 ? 'text-primary font-bold' : 'text-on-surface-variant'}">Đặt hàng</span>
                                    </div>

                                    <div class="flex flex-col items-center relative z-10">
                                        <div class="w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs shadow-sm ${uStep >= 2 ? 'bg-primary text-white ring-4 ring-primary/20' : 'bg-surface-container text-on-surface-variant'}">
                                            <span class="material-symbols-outlined text-sm">task_alt</span>
                                        </div>
                                        <span class="text-[10px] font-label-bold mt-1.5 ${uStep >= 2 ? 'text-primary font-bold' : 'text-on-surface-variant'}">Xác nhận</span>
                                    </div>

                                    <div class="flex flex-col items-center relative z-10">
                                        <div class="w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs shadow-sm ${uStep >= 3 ? 'bg-primary text-white ring-4 ring-primary/20' : 'bg-surface-container text-on-surface-variant'}">
                                            <span class="material-symbols-outlined text-sm">inventory_2</span>
                                        </div>
                                        <span class="text-[10px] font-label-bold mt-1.5 ${uStep >= 3 ? 'text-primary font-bold' : 'text-on-surface-variant'}">Đóng gói</span>
                                    </div>

                                    <div class="flex flex-col items-center relative z-10">
                                        <div class="w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs shadow-sm ${uStep == 4 ? 'bg-sky-600 text-white ring-4 ring-sky-200 animate-bounce' : (uStep > 4 ? 'bg-primary text-white ring-4 ring-primary/20' : 'bg-surface-container text-on-surface-variant')}">
                                            <span class="material-symbols-outlined text-sm">local_shipping</span>
                                        </div>
                                        <span class="text-[10px] font-label-bold mt-1.5 ${uStep == 4 ? 'text-sky-700 font-bold' : (uStep > 4 ? 'text-primary font-bold' : 'text-on-surface-variant')}">Đang giao</span>
                                    </div>

                                    <div class="flex flex-col items-center relative z-10">
                                        <div class="w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs shadow-sm ${uStep >= 5 ? 'bg-emerald-600 text-white ring-4 ring-emerald-200' : 'bg-surface-container text-on-surface-variant'}">
                                            <span class="material-symbols-outlined text-sm">verified</span>
                                        </div>
                                        <span class="text-[10px] font-label-bold mt-1.5 ${uStep >= 5 ? 'text-emerald-700 font-bold' : 'text-on-surface-variant'}">Giao xong</span>
                                    </div>
                                </div>

                                <!-- THẺ SHIPPERS NỘI BỘ REAL-TIME ĐANG GIAO HÀNG -->
                                <c:if test="${order.status == 'SHIPPING'}">
                                    <div class="mt-4 p-4 rounded-2xl bg-gradient-to-r from-sky-50 via-teal-50 to-emerald-50 border border-sky-300 shadow-sm space-y-3">
                                        <div class="flex items-center justify-between flex-wrap gap-2">
                                            <div class="flex items-center gap-2">
                                                <span class="w-3 h-3 rounded-full bg-emerald-500 animate-ping"></span>
                                                <span class="font-label-bold text-xs text-sky-900 uppercase tracking-wider">Shipper Fruitables đang trên đường giao hàng</span>
                                            </div>
                                            <span class="px-2.5 py-1 rounded-full bg-sky-600 text-white text-[11px] font-bold shadow-xs">
                                                Mã vận đơn: <c:out value="${not empty order.trackingNumber ? order.trackingNumber : 'FRUIT-EXPRESS'}"/>
                                            </span>
                                        </div>

                                        <div class="flex items-center justify-between flex-wrap gap-4 bg-white/80 backdrop-blur-sm p-3.5 rounded-xl border border-sky-200">
                                            <div class="flex items-center gap-3">
                                                <div class="relative w-12 h-12 rounded-full overflow-hidden border-2 border-emerald-500 shadow-xs flex-shrink-0">
                                                    <img src="${not empty order.shipper ? order.shipper.avatarUrl : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'}"
                                                         alt="Shipper Avatar" class="w-full h-full object-cover">
                                                </div>
                                                <div>
                                                    <div class="font-bold text-sm text-slate-900 flex items-center gap-1.5">
                                                        <span><c:out value="${not empty order.shipper ? order.shipper.fullName : 'Nguyễn Văn Hưng (Đội xe hỏa tốc)'}"/></span>
                                                        <span class="material-symbols-outlined text-base text-emerald-600" title="Tài xế uy tín Fruitables">verified</span>
                                                    </div>
                                                    <div class="text-xs text-slate-500 flex items-center gap-2 mt-0.5">
                                                        <span>Biển số: <strong class="text-slate-700"><c:out value="${not empty order.shipper ? order.shipper.vehiclePlate : '29B1-889.99'}"/></strong></span>
                                                        <span>•</span>
                                                        <span>Thùng giữ nhiệt lạnh: <strong class="text-emerald-700">4°C ❄️</strong></span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="flex items-center gap-2">
                                                <a href="tel:${not empty order.shipper ? order.shipper.phone : '0912345678'}"
                                                   class="inline-flex items-center gap-1.5 px-4 py-2 rounded-full bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold shadow-sm transition-all hover:scale-105">
                                                    <span class="material-symbols-outlined text-sm">call</span>
                                                    Gọi điện (${not empty order.shipper ? order.shipper.phone : '0912345678'})
                                                </a>
                                            </div>
                                        </div>

                                        <div class="flex items-center justify-between text-[11px] text-slate-600 pt-1">
                                            <span class="flex items-center gap-1">
                                                <span class="material-symbols-outlined text-sm text-sky-600">schedule</span>
                                                Dự kiến đến: <strong class="text-sky-900"><c:out value="${not empty order.estimatedDeliveryTime ? order.estimatedDeliveryTime : 'Trong 30 - 45 phút tới'}"/></strong>
                                            </span>
                                            <span class="text-emerald-700 font-medium">Khách hàng được quyền đồng kiểm hoa quả trước khi nhận</span>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- THÔNG TIN KHUNG GIỜ GIAO & TÍCH ĐIỂM -->
                                <div class="mt-3 grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs">
                                    <div class="p-2.5 rounded-xl bg-surface-container/60 border border-outline-variant flex items-center gap-2">
                                        <span class="material-symbols-outlined text-primary text-base">alarm</span>
                                        <div>
                                            <span class="text-on-surface-variant text-[10px] block">Khung giờ nhận:</span>
                                            <span class="font-bold text-on-surface">
                                                <c:choose>
                                                    <c:when test="${order.deliverySlot == 'FAST_1_2H'}">⚡ Hỏa tốc 1 - 2 giờ (Thùng lạnh 4°C)</c:when>
                                                    <c:when test="${order.deliverySlot == 'SLOT_MORNING'}">🌅 Buổi Sáng (08:30 - 11:30)</c:when>
                                                    <c:when test="${order.deliverySlot == 'SLOT_AFTERNOON'}">☀️ Buổi Chiều (14:00 - 17:00)</c:when>
                                                    <c:when test="${order.deliverySlot == 'SLOT_EVENING'}">🌙 Buổi Tối (18:30 - 20:30)</c:when>
                                                    <c:otherwise>Giao tiêu chuẩn</c:otherwise>
                                                </c:choose>
                                                <c:if test="${not empty order.deliveryDate}">
                                                    (<fmt:formatDate value="${order.deliveryDate}" pattern="dd/MM/yyyy"/>)
                                                </c:if>
                                            </span>
                                        </div>
                                    </div>

                                    <c:if test="${order.usedPoints > 0}">
                                        <div class="p-2.5 rounded-xl bg-amber-500/10 border border-amber-500/20 flex items-center gap-2">
                                            <span class="material-symbols-outlined text-amber-600 text-base">stars</span>
                                            <div>
                                                <span class="text-amber-800 text-[10px] block">Ưu đãi thành viên:</span>
                                                <span class="font-bold text-amber-900">
                                                    Đã dùng <strong>${order.usedPoints} điểm</strong> (-<fmt:formatNumber value="${order.pointsDiscount}" type="number" groupingUsed="true"/>₫)
                                                </span>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <c:if test="${order.status == 'DELIVERED'}">
                                    <div class="mt-3 p-2.5 rounded-lg bg-emerald-50 text-emerald-800 text-xs flex items-center gap-2 border border-emerald-200">
                                        <span class="material-symbols-outlined text-emerald-600 text-base flex-shrink-0">task_alt</span>
                                        <span><strong>Đơn hàng đã được giao!</strong> Vui lòng kiểm tra kiện hàng và bấm nút <em>"Đã nhận được hàng"</em> bên dưới để hoàn tất đơn hàng.</span>
                                    </div>
                                </c:if>
                                <c:if test="${order.status == 'COMPLETED'}">
                                    <div class="mt-3 p-2.5 rounded-lg bg-green-50 text-green-800 text-xs flex items-center gap-2 border border-green-200">
                                        <span class="material-symbols-outlined text-green-600 text-base flex-shrink-0">check_circle</span>
                                        <span><strong>Giao dịch hoàn tất!</strong> Cảm ơn bạn đã tin tưởng và ủng hộ sản phẩm hoa quả tươi của Fruitables. Bạn đã được tích điểm thưởng cho đơn hàng này!</span>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>

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
                            <c:if test="${order.shippingFee != null && order.shippingFee > 0}">
                                <p class="text-[11px] text-on-surface-variant mt-1.5 flex items-center gap-1">
                                    <span class="material-symbols-outlined text-[14px] text-primary">local_shipping</span>
                                    Phí ship: <span class="font-semibold text-on-surface"><fmt:formatNumber value="${order.shippingFee}" type="number" groupingUsed="true"/> ₫</span>
                                    <c:if test="${order.distanceKm != null && order.distanceKm > 0}">
                                        (~<fmt:formatNumber value="${order.distanceKm}" maxFractionDigits="1"/> km)
                                    </c:if>
                                    <c:if test="${order.shippingDiscount != null && order.shippingDiscount > 0}">
                                        - <span class="text-emerald-600 font-semibold">Freeship -<fmt:formatNumber value="${order.shippingDiscount}" type="number" groupingUsed="true"/> ₫</span>
                                    </c:if>
                                </p>
                            </c:if>
                        </div>
                        <div class="flex items-center gap-3 flex-wrap">
                            <div class="text-right">
                                <p class="text-xs text-on-surface-variant mb-0.5">Tổng cộng</p>
                                <p class="font-price-tag text-xl text-primary font-bold"><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫</p>
                            </div>

                            <!-- Nút Mua Lại Đơn Này (1-Click Reorder) -->
                            <form action="${pageContext.request.contextPath}/order-history" method="POST" class="inline-block">
                                <input type="hidden" name="action" value="reorder">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <button type="submit" class="px-4 py-2 bg-primary/10 hover:bg-primary text-primary hover:text-white border border-primary/30 rounded-full font-label-bold text-xs shadow-xs transition-all flex items-center gap-1.5 whitespace-nowrap">
                                    <span class="material-symbols-outlined text-[16px]">replay</span> Mua lại đơn
                                </button>
                            </form>

                            <!-- Nút Bảo Hành Hoa Quả 1 Đổi 1 (Chỉ khi COMPLETED hoặc DELIVERED) -->
                            <c:if test="${order.status == 'COMPLETED' || order.status == 'DELIVERED'}">
                                <a href="${pageContext.request.contextPath}/order/claim?orderId=${order.id}" class="px-4 py-2 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border border-emerald-300 rounded-full font-label-bold text-xs shadow-xs transition-all flex items-center gap-1.5 whitespace-nowrap" title="Cam kết bảo hành hoa quả tươi 1 đổi 1">
                                    <span class="material-symbols-outlined text-[16px]">verified_user</span> Đổi trả 1 đổi 1
                                </a>
                            </c:if>

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