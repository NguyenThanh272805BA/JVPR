<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport"/>
    <title>Cổng Tài Xế (Shipper Portal) - Fruitables Fresh</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>

    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .touch-action-btn {
            touch-action: manipulation;
        }
        .order-card-shadow {
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05), 0 2px 6px -1px rgba(0, 0, 0, 0.03);
        }
    </style>
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen flex flex-col font-sans pb-16">

    <!-- TOPBAR DÀNH RIÊNG CHO SHIPPER -->
    <header class="bg-white border-b border-slate-200 sticky top-0 z-30 shadow-sm">
        <div class="max-w-5xl mx-auto px-4 py-3 flex items-center justify-between gap-3">
            <div class="flex items-center gap-3">
                <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-2" title="Về trang chủ Fruitables">
                    <span class="material-symbols-outlined text-primary text-2xl">eco</span>
                    <div class="leading-tight">
                        <span class="font-black text-base text-slate-800 tracking-tight">Fruitables</span>
                        <span class="block text-[10px] font-bold uppercase tracking-wider text-amber-600 bg-amber-50 px-1.5 py-0.2 rounded inline-block">Cổng Tài Xế</span>
                    </div>
                </a>
            </div>

            <!-- Profile Shipper & Trạng thái -->
            <div class="flex items-center gap-3">
                <div class="hidden sm:flex flex-col text-right">
                    <div class="flex items-center justify-end gap-1.5">
                        <span class="font-bold text-sm text-slate-800">${currentShipper.fullName}</span>
                        <span class="inline-block w-2 h-2 rounded-full ${currentShipper.status == 'AVAILABLE' ? 'bg-emerald-500' : 'bg-amber-500'}"></span>
                    </div>
                    <span class="text-xs text-slate-500">${currentShipper.vehiclePlate} • ${currentShipper.phone}</span>
                </div>

                <div class="relative">
                    <img src="${currentShipper.avatarUrl != null ? currentShipper.avatarUrl : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'}"
                         alt="Avatar" class="w-10 h-10 rounded-full object-cover border-2 border-primary shadow-sm">
                </div>

                <div class="flex items-center gap-1.5">
                    <c:if test="${sessionScope.USERMODEL.roleId == 1 || sessionScope.USERMODEL.roleId == 2}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="p-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-600 transition-colors" title="Trở lại Dashboard Quản trị">
                            <span class="material-symbols-outlined text-xl">admin_panel_settings</span>
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/logout" class="p-2 rounded-xl bg-rose-50 hover:bg-rose-100 text-rose-600 transition-colors" title="Đăng xuất">
                        <span class="material-symbols-outlined text-xl">logout</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Bộ chọn Shipper (Chỉ dành cho Admin giám sát hoặc tài xế chuyển góc nhìn) -->
        <c:if test="${sessionScope.USERMODEL.roleId == 1}">
            <div class="bg-amber-50 border-t border-amber-200 px-4 py-1.5 text-xs text-amber-800 flex items-center justify-between">
                <div class="flex items-center gap-2 max-w-5xl mx-auto w-full">
                    <span class="material-symbols-outlined text-sm">visibility</span>
                    <span class="font-semibold">Chế độ Quản trị viên: Đang xem góc nhìn của:</span>
                    <select onchange="location.href='${pageContext.request.contextPath}/shipper/portal?shipperId=' + this.value + '&tab=${activeTab}'"
                            class="bg-white border border-amber-300 text-xs rounded px-2 py-0.5 font-bold text-slate-700 outline-none">
                        <c:forEach var="shp" items="${allShippers}">
                            <option value="${shp.id}" ${shp.id == currentShipper.id ? 'selected' : ''}>${shp.fullName} (${shp.vehiclePlate})</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </c:if>
    </header>

    <!-- CONTAINER CHÍNH -->
    <main class="max-w-5xl mx-auto w-full px-3 sm:px-4 py-4 space-y-4 flex-1">

        <!-- THÔNG BÁO FLASH MESSAGE (NẾU CÓ) -->
        <c:if test="${not empty param.msg}">
            <div id="flashAlert" class="p-3.5 rounded-2xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs font-semibold flex items-center justify-between animate-fade-in">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-emerald-600 text-base">check_circle</span>
                    <span><c:out value="${param.msg}"/></span>
                </div>
                <button type="button" onclick="document.getElementById('flashAlert').remove()" class="text-slate-400 hover:text-slate-600">
                    <span class="material-symbols-outlined text-sm">close</span>
                </button>
            </div>
        </c:if>

        <!-- 4 THẺ THỐNG KÊ CA TRỰC (KPI SHIPPER DASHBOARD) -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-2.5 sm:gap-3.5">
            <!-- Đang giao -->
            <a href="${pageContext.request.contextPath}/shipper/portal?shipperId=${currentShipper.id}&tab=SHIPPING"
               class="p-3.5 rounded-2xl border transition-all ${activeTab == 'SHIPPING' ? 'bg-sky-50 border-sky-300 shadow-sm ring-2 ring-sky-400/30' : 'bg-white border-slate-200 hover:border-sky-300'}">
                <div class="flex items-center justify-between text-sky-600 mb-1">
                    <span class="text-[11px] font-bold uppercase tracking-wider">Đang giao</span>
                    <span class="material-symbols-outlined text-lg">local_shipping</span>
                </div>
                <div class="text-2xl font-black text-sky-700">${shiftSummary.shippingCount != null ? shiftSummary.shippingCount : 0}</div>
                <div class="text-[10px] text-slate-500 mt-0.5">Đơn cần giao ngay</div>
            </a>

            <!-- Giao thành công -->
            <a href="${pageContext.request.contextPath}/shipper/portal?shipperId=${currentShipper.id}&tab=DELIVERED"
               class="p-3.5 rounded-2xl border transition-all ${activeTab == 'DELIVERED' ? 'bg-emerald-50 border-emerald-300 shadow-sm ring-2 ring-emerald-400/30' : 'bg-white border-slate-200 hover:border-emerald-300'}">
                <div class="flex items-center justify-between text-emerald-600 mb-1">
                    <span class="text-[11px] font-bold uppercase tracking-wider">Đã giao</span>
                    <span class="material-symbols-outlined text-lg">check_circle</span>
                </div>
                <div class="text-2xl font-black text-emerald-700">${shiftSummary.deliveredCount != null ? shiftSummary.deliveredCount : 0}</div>
                <div class="text-[10px] text-slate-500 mt-0.5">Hoàn tất hôm nay</div>
            </a>

            <!-- Thất bại / Cần hẹn lại -->
            <a href="${pageContext.request.contextPath}/shipper/portal?shipperId=${currentShipper.id}&tab=FAILED"
               class="p-3.5 rounded-2xl border transition-all ${activeTab == 'FAILED' ? 'bg-rose-50 border-rose-300 shadow-sm ring-2 ring-rose-400/30' : 'bg-white border-slate-200 hover:border-rose-300'}">
                <div class="flex items-center justify-between text-rose-600 mb-1">
                    <span class="text-[11px] font-bold uppercase tracking-wider">Thất bại</span>
                    <span class="material-symbols-outlined text-lg">error</span>
                </div>
                <div class="text-2xl font-black text-rose-700">${shiftSummary.failedCount != null ? shiftSummary.failedCount : 0}</div>
                <div class="text-[10px] text-slate-500 mt-0.5">Cần hẹn lại / Hoàn kho</div>
            </a>

            <!-- Tiền COD cần thu -->
            <div class="p-3.5 rounded-2xl bg-white border border-slate-200">
                <div class="flex items-center justify-between text-amber-600 mb-1">
                    <span class="text-[11px] font-bold uppercase tracking-wider">Tiền COD giữ</span>
                    <span class="material-symbols-outlined text-lg">payments</span>
                </div>
                <div class="text-xl sm:text-2xl font-black text-amber-700 truncate" title="<fmt:formatNumber value='${shiftSummary.codCollected}' type='number'/> ₫">
                    <fmt:formatNumber value="${shiftSummary.codCollected != null ? shiftSummary.codCollected : 0}" type="number" groupingUsed="true"/> ₫
                </div>
                <div class="text-[10px] text-slate-500 mt-0.5">
                    Chờ thu: <fmt:formatNumber value="${shiftSummary.codPending != null ? shiftSummary.codPending : 0}" type="number" groupingUsed="true"/> ₫
                </div>
            </div>
        </div>

        <!-- THANH TÌM KIẾM & TAB BỘ LỌC -->
        <div class="bg-white p-3 rounded-2xl border border-slate-200 shadow-sm space-y-3">
            <!-- Thanh Search -->
            <form action="${pageContext.request.contextPath}/shipper/portal" method="get" class="flex gap-2">
                <input type="hidden" name="shipperId" value="${currentShipper.id}"/>
                <input type="hidden" name="tab" value="${activeTab}"/>
                <div class="relative flex-1">
                    <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-base pointer-events-none">search</span>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Tìm mã đơn, tên khách, SĐT, địa chỉ..."
                           class="w-full pl-9 pr-3 py-2 bg-slate-50 rounded-xl border border-slate-200 text-xs focus:border-primary focus:bg-white outline-none">
                </div>
                <button type="submit" class="px-4 py-2 bg-primary hover:bg-primary-container text-white font-bold text-xs rounded-xl transition-colors flex items-center gap-1 flex-shrink-0">
                    <span>Tìm</span>
                </button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/shipper/portal?shipperId=${currentShipper.id}&tab=${activeTab}" class="px-3 py-2 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-xl text-xs font-semibold flex items-center">
                        <span class="material-symbols-outlined text-sm">close</span>
                    </a>
                </c:if>
            </form>

            <!-- Tab Trạng Thái -->
            <div class="flex items-center gap-1.5 overflow-x-auto pb-1 text-xs no-scrollbar">
                <a href="${pageContext.request.contextPath}/shipper/portal?shipperId=${currentShipper.id}&tab=SHIPPING"
                   class="px-3.5 py-1.5 rounded-xl font-bold whitespace-nowrap transition-colors flex items-center gap-1.5 ${activeTab == 'SHIPPING' ? 'bg-primary text-white shadow-sm' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'}">
                    <span class="material-symbols-outlined text-sm">local_shipping</span>
                    <span>Đang giao (${shiftSummary.shippingCount != null ? shiftSummary.shippingCount : 0})</span>
                </a>
                <a href="${pageContext.request.contextPath}/shipper/portal?shipperId=${currentShipper.id}&tab=FAILED"
                   class="px-3.5 py-1.5 rounded-xl font-bold whitespace-nowrap transition-colors flex items-center gap-1.5 ${activeTab == 'FAILED' ? 'bg-rose-600 text-white shadow-sm' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'}">
                    <span class="material-symbols-outlined text-sm">cancel</span>
                    <span>Thất bại (${shiftSummary.failedCount != null ? shiftSummary.failedCount : 0})</span>
                </a>
                <a href="${pageContext.request.contextPath}/shipper/portal?shipperId=${currentShipper.id}&tab=DELIVERED"
                   class="px-3.5 py-1.5 rounded-xl font-bold whitespace-nowrap transition-colors flex items-center gap-1.5 ${activeTab == 'DELIVERED' ? 'bg-emerald-600 text-white shadow-sm' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'}">
                    <span class="material-symbols-outlined text-sm">check_circle</span>
                    <span>Đã giao (${shiftSummary.deliveredCount != null ? shiftSummary.deliveredCount : 0})</span>
                </a>
                <a href="${pageContext.request.contextPath}/shipper/portal?shipperId=${currentShipper.id}&tab=ALL"
                   class="px-3.5 py-1.5 rounded-xl font-bold whitespace-nowrap transition-colors flex items-center gap-1.5 ${activeTab == 'ALL' ? 'bg-slate-800 text-white shadow-sm' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'}">
                    <span class="material-symbols-outlined text-sm">list_alt</span>
                    <span>Tất cả đơn</span>
                </a>
            </div>
        </div>

        <!-- DANH SÁCH CÁC CARD ĐƠN HÀNG CỦA SHIPPER -->
        <div class="space-y-3.5">
            <c:choose>
                <c:when test="${not empty orders}">
                    <c:forEach var="order" items="${orders}">
                        <div class="bg-white rounded-2xl border border-slate-200 p-4 order-card-shadow transition-all hover:border-slate-300 relative">

                            <!-- Header của thẻ đơn: Mã đơn, Thời gian hẹn, Tag Trạng thái -->
                            <div class="flex items-start justify-between gap-3 border-b border-slate-100 pb-3">
                                <div>
                                    <div class="flex items-center gap-2 flex-wrap">
                                        <span class="font-black text-sm text-slate-900 font-mono tracking-tight">${order.orderCode}</span>
                                        <c:choose>
                                            <c:when test="${order.status == 'SHIPPING'}">
                                                <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-sky-100 text-sky-700 flex items-center gap-1">
                                                    <span class="w-1.5 h-1.5 rounded-full bg-sky-500 animate-ping"></span> ĐANG GIAO
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status == 'FAILED'}">
                                                <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-rose-100 text-rose-700">GIAO THẤT BẠI</span>
                                            </c:when>
                                            <c:when test="${order.status == 'DELIVERED' || order.status == 'COMPLETED'}">
                                                <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-700">ĐÃ GIAO THÀNH CÔNG</span>
                                            </c:when>
                                            <c:when test="${order.status == 'RETURNED'}">
                                                <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-slate-100 text-slate-700">ĐÃ HOÀN VỀ KHO</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-slate-100 text-slate-600">${order.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="flex items-center gap-2 mt-1 text-[11px] text-slate-500">
                                        <span class="flex items-center gap-1">
                                            <span class="material-symbols-outlined text-[13px] text-slate-400">schedule</span>
                                            <span>${order.estimatedDeliveryTime != null ? order.estimatedDeliveryTime : 'Khung giờ tiêu chuẩn'}</span>
                                        </span>
                                        <span>•</span>
                                        <span class="text-primary font-semibold">${order.deliverySlot != null ? order.deliverySlot : 'FAST_1_2H'}</span>
                                    </div>
                                </div>

                                <!-- Tiền thu / Trạng thái thanh toán -->
                                <div class="text-right flex-shrink-0">
                                    <div class="text-base sm:text-lg font-black ${order.paymentMethod == 'COD' ? 'text-amber-600' : 'text-emerald-600'}">
                                        <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫
                                    </div>
                                    <div class="text-[10px] font-bold">
                                        <c:choose>
                                            <c:when test="${order.paymentMethod == 'COD'}">
                                                <c:choose>
                                                    <c:when test="${order.paymentStatus == 'PAID'}">
                                                        <span class="text-emerald-600 bg-emerald-50 px-1.5 py-0.5 rounded">ĐÃ THU COD</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-amber-700 bg-amber-50 px-1.5 py-0.5 rounded border border-amber-200">CẦN THU TIỀN MẶT</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-emerald-700 bg-emerald-50 px-1.5 py-0.5 rounded">ĐÃ TRẢ ONLINE (${order.paymentMethod})</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <!-- Thân thẻ: Thông tin khách hàng & Địa chỉ -->
                            <div class="py-3 space-y-2 text-xs">
                                <div class="flex items-start justify-between gap-3">
                                    <div class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-slate-400 text-base">person</span>
                                        <span class="font-bold text-slate-800 text-sm">${order.recipientName}</span>
                                    </div>
                                    <a href="tel:${order.phone}" class="inline-flex items-center gap-1 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl font-bold text-xs shadow-sm transition-all flex-shrink-0">
                                        <span class="material-symbols-outlined text-sm">call</span>
                                        <span>Gọi: ${order.phone}</span>
                                    </a>
                                </div>

                                <div class="flex items-start justify-between gap-2 bg-slate-50 p-2.5 rounded-xl border border-slate-100">
                                    <div class="flex items-start gap-2 text-slate-600">
                                        <span class="material-symbols-outlined text-rose-500 text-base flex-shrink-0 mt-0.5">location_on</span>
                                        <span class="leading-relaxed">${order.shippingAddress}</span>
                                    </div>
                                    <a href="https://www.google.com/maps/search/?api=1&query=${order.shippingAddress}" target="_blank"
                                       class="px-2 py-1 bg-white border border-slate-200 rounded-lg text-primary hover:bg-slate-50 font-bold text-[11px] flex items-center gap-1 flex-shrink-0" title="Mở bản đồ">
                                        <span class="material-symbols-outlined text-xs">directions</span>
                                        <span class="hidden sm:inline">Chỉ đường</span>
                                    </a>
                                </div>

                                <!-- Nếu là đơn thất bại: hiển thị lý do tiếng Việt và số lần thử -->
                                <c:if test="${order.status == 'FAILED' || not empty order.failedReason}">
                                    <div class="p-2.5 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 space-y-1">
                                        <div class="flex items-center justify-between font-bold text-[11px]">
                                            <span class="flex items-center gap-1">
                                                <span class="material-symbols-outlined text-rose-600 text-sm">warning</span>
                                                <span>Lý do thất bại: ${order.failedReason}</span>
                                            </span>
                                            <span>Số lần giao: ${order.deliveryAttempts != null ? order.deliveryAttempts : 1}/3</span>
                                        </div>
                                        <c:if test="${not empty order.failedNotes}">
                                            <p class="text-[11px] text-rose-700/90 whitespace-pre-line font-normal italic pl-4">"${order.failedNotes}"</p>
                                        </c:if>
                                    </div>
                                </c:if>

                                <!-- Tóm tắt sản phẩm hoa quả trong kiện hàng -->
                                <c:if test="${not empty order.orderDetails}">
                                    <div class="pt-1">
                                        <span class="text-[11px] font-bold text-slate-500 uppercase tracking-wider block mb-1">Kiện hàng gồm:</span>
                                        <div class="flex flex-wrap gap-1.5">
                                            <c:forEach var="item" items="${order.orderDetails}">
                                                <span class="px-2 py-1 bg-slate-100 border border-slate-200 rounded-lg text-[11px] text-slate-700">
                                                    <strong>${item.quantity}x</strong> ${item.productName != null ? item.productName : ('Sản phẩm #' + item.productId)}
                                                </span>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Footer nút hành động: Giao thành công, Báo thất bại, Hẹn giao lại -->
                            <div class="pt-3 border-t border-slate-100 flex flex-wrap items-center justify-end gap-2">
                                <c:if test="${order.status == 'SHIPPING' || order.status == 'FAILED'}">
                                    <!-- Nút Báo Giao Thất Bại -->
                                    <button type="button" onclick="openFailureModal(${order.id}, '${order.orderCode}', '${order.recipientName}')"
                                            class="px-3 py-2 rounded-xl bg-rose-50 hover:bg-rose-100 text-rose-700 font-bold text-xs transition-colors flex items-center gap-1 border border-rose-200 touch-action-btn">
                                        <span class="material-symbols-outlined text-base">cancel</span>
                                        <span>Báo thất bại</span>
                                    </button>

                                    <!-- Nút Hẹn Giao Lại -->
                                    <button type="button" onclick="openRescheduleModal(${order.id}, '${order.orderCode}')"
                                            class="px-3 py-2 rounded-xl bg-amber-50 hover:bg-amber-100 text-amber-700 font-bold text-xs transition-colors flex items-center gap-1 border border-amber-200 touch-action-btn">
                                        <span class="material-symbols-outlined text-base">event_repeat</span>
                                        <span>Hẹn giao lại</span>
                                    </button>

                                    <!-- Nút Giao Thành Công -->
                                    <button type="button" onclick="confirmDeliverySuccess(${order.id}, '${order.orderCode}', ${order.paymentMethod == 'COD' ? order.totalAmount : 0})"
                                            class="px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs transition-colors flex items-center gap-1.5 shadow-sm touch-action-btn">
                                        <span class="material-symbols-outlined text-base">task_alt</span>
                                        <span>Giao thành công</span>
                                    </button>
                                </c:if>

                                <c:if test="${order.status == 'FAILED'}">
                                    <!-- Nút Hoàn về kho -->
                                    <button type="button" onclick="confirmReturnStock(${order.id}, '${order.orderCode}')"
                                            class="px-3 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs transition-colors flex items-center gap-1 border border-slate-200 touch-action-btn">
                                        <span class="material-symbols-outlined text-base">inventory_2</span>
                                        <span>Hoàn về kho</span>
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Không có đơn hàng nào -->
                    <div class="bg-white rounded-2xl border border-slate-200 p-8 text-center space-y-3">
                        <div class="w-16 h-16 rounded-full bg-slate-100 text-slate-400 flex items-center justify-center mx-auto">
                            <span class="material-symbols-outlined text-3xl">inbox</span>
                        </div>
                        <h4 class="font-bold text-base text-slate-700">Không có đơn hàng nào trong mục này</h4>
                        <p class="text-xs text-slate-500 max-w-sm mx-auto">
                            Hiện tại không có đơn hàng nào phù hợp với bộ lọc hoặc từ khóa tìm kiếm. Bạn có thể kiểm tra các tab khác!
                        </p>
                        <a href="${pageContext.request.contextPath}/shipper/portal?shipperId=${currentShipper.id}&tab=ALL"
                           class="inline-flex items-center gap-1 px-4 py-2 bg-primary text-white text-xs font-bold rounded-xl shadow-sm hover:bg-primary-container">
                            <span>Xem tất cả đơn</span>
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- ========================================================================= -->
    <!-- MODAL 1: BÁO GIAO THẤT BẠI (CHỌN LÝ DO TIẾNG VIỆT)                         -->
    <!-- ========================================================================= -->
    <div id="failureModal" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end sm:items-center justify-center p-0 sm:p-4 animate-fade-in">
        <div class="bg-white w-full sm:max-w-lg rounded-t-3xl sm:rounded-3xl shadow-2xl border border-slate-100 overflow-hidden max-h-[90vh] flex flex-col">
            <div class="p-4 bg-rose-50 border-b border-rose-100 flex items-center justify-between">
                <div class="flex items-center gap-2 text-rose-700 font-bold text-sm">
                    <span class="material-symbols-outlined text-lg">report_problem</span>
                    <span>Báo giao thất bại: <span id="failModalOrderCode" class="font-mono"></span></span>
                </div>
                <button type="button" onclick="closeFailureModal()" class="text-slate-400 hover:text-slate-600">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <form id="failureForm" onsubmit="submitFailureReport(event)" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
                <input type="hidden" id="failOrderId" name="orderId">
                <input type="hidden" name="action" value="report_failure">

                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-2">Lý do giao thất bại (Bắt buộc) <span class="text-rose-500">*</span></label>
                    <div class="space-y-2">
                        <label class="flex items-center gap-2.5 p-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 cursor-pointer text-xs">
                            <input type="radio" name="reason" value="Khách không nghe máy (đã gọi 3 lần)" checked class="text-primary focus:ring-primary">
                            <span>Khách không nghe máy (đã gọi 3 lần)</span>
                        </label>
                        <label class="flex items-center gap-2.5 p-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 cursor-pointer text-xs">
                            <input type="radio" name="reason" value="Khách hẹn giao lại vào thời gian khác" class="text-primary focus:ring-primary">
                            <span>Khách hẹn giao lại vào thời gian khác</span>
                        </label>
                        <label class="flex items-center gap-2.5 p-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 cursor-pointer text-xs">
                            <input type="radio" name="reason" value="Khách từ chối nhận hàng (đổi ý)" class="text-primary focus:ring-primary">
                            <span>Khách từ chối nhận hàng (đổi ý)</span>
                        </label>
                        <label class="flex items-center gap-2.5 p-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 cursor-pointer text-xs">
                            <input type="radio" name="reason" value="Sai địa chỉ / Không liên hệ được người nhận" class="text-primary focus:ring-primary">
                            <span>Sai địa chỉ / Không liên hệ được người nhận</span>
                        </label>
                        <label class="flex items-center gap-2.5 p-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 cursor-pointer text-xs">
                            <input type="radio" name="reason" value="Hàng hóa bị dập nát / hư hại khi vận chuyển" class="text-primary focus:ring-primary">
                            <span>Hàng hóa bị dập nát / hư hại khi vận chuyển</span>
                        </label>
                        <label class="flex items-center gap-2.5 p-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 cursor-pointer text-xs">
                            <input type="radio" name="reason" value="Khách không có đủ tiền mặt thanh toán" class="text-primary focus:ring-primary">
                            <span>Khách không có đủ tiền mặt thanh toán</span>
                        </label>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="block text-xs font-bold text-slate-700 mb-1">Số lần giao / gọi</label>
                        <select name="attempts" id="failAttempts" class="w-full text-xs rounded-xl border-slate-200 bg-slate-50 p-2 focus:border-primary">
                            <option value="1">Lần 1</option>
                            <option value="2">Lần 2</option>
                            <option value="3">Lần 3 (Khuyến nghị hoàn kho)</option>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1">Ghi chú chi tiết cho điều phối</label>
                    <textarea name="notes" id="failNotes" rows="2" placeholder="Ví dụ: Đã gọi lúc 14:05, 14:15 và 14:30 đều thuê bao không liên lạc được..."
                              class="w-full text-xs rounded-xl border-slate-200 bg-slate-50 p-2.5 focus:border-primary focus:bg-white outline-none"></textarea>
                </div>

                <div class="pt-3 border-t border-slate-100 flex items-center justify-end gap-2">
                    <button type="button" onclick="closeFailureModal()" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold transition-colors">
                        Đóng
                    </button>
                    <button type="submit" class="px-5 py-2 bg-rose-600 hover:bg-rose-700 text-white rounded-xl text-xs font-bold transition-colors shadow-sm flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-sm">send</span>
                        <span>Xác nhận báo thất bại</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- MODAL 2: HẸN GIAO LẠI (RESCHEDULE MODAL)                                   -->
    <!-- ========================================================================= -->
    <div id="rescheduleModal" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end sm:items-center justify-center p-0 sm:p-4 animate-fade-in">
        <div class="bg-white w-full sm:max-w-md rounded-t-3xl sm:rounded-3xl shadow-2xl border border-slate-100 overflow-hidden flex flex-col">
            <div class="p-4 bg-amber-50 border-b border-amber-100 flex items-center justify-between">
                <div class="flex items-center gap-2 text-amber-800 font-bold text-sm">
                    <span class="material-symbols-outlined text-lg">schedule</span>
                    <span>Hẹn giao lại: <span id="rescheduleOrderCode" class="font-mono"></span></span>
                </div>
                <button type="button" onclick="closeRescheduleModal()" class="text-slate-400 hover:text-slate-600">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <form id="rescheduleForm" onsubmit="submitReschedule(event)" class="p-4 sm:p-6 space-y-4">
                <input type="hidden" id="rescheduleOrderId" name="orderId">
                <input type="hidden" name="shipperId" value="${currentShipper.id}">
                <input type="hidden" name="action" value="reschedule">

                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1">Thời gian khách hẹn giao lại</label>
                    <input type="text" name="deliveryTime" id="rescheduleTime" placeholder="Ví dụ: Sáng mai 09:00 - 11:00 hoặc Chiều 16:30"
                           class="w-full text-xs rounded-xl border-slate-200 bg-slate-50 p-2.5 focus:border-primary focus:bg-white outline-none" required>
                </div>

                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1">Ghi chú hẹn giao</label>
                    <textarea name="notes" id="rescheduleNotes" rows="2" placeholder="Ví dụ: Khách đang đi công tác, nhờ giao sáng mai cho người nhà..."
                              class="w-full text-xs rounded-xl border-slate-200 bg-slate-50 p-2.5 focus:border-primary focus:bg-white outline-none"></textarea>
                </div>

                <div class="pt-3 border-t border-slate-100 flex items-center justify-end gap-2">
                    <button type="button" onclick="closeRescheduleModal()" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold transition-colors">
                        Hủy
                    </button>
                    <button type="submit" class="px-5 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-xl text-xs font-bold transition-colors shadow-sm flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-sm">event</span>
                        <span>Lưu lịch hẹn</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- JAVASCRIPT XỬ LÝ SỰ KIỆN GIAO HÀNG VÀ AJAX -->
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const currentTab = '${activeTab}';
        const currentShipperId = '${currentShipper.id}';

        // 1. Xác nhận giao thành công
        function confirmDeliverySuccess(orderId, orderCode, codAmount) {
            let msg = 'Bạn có chắc chắn muốn xác nhận đã giao thành công đơn hàng #' + orderCode + '?';
            if (codAmount > 0) {
                const formatted = new Intl.NumberFormat('vi-VN').format(codAmount) + ' ₫';
                msg = 'Đơn hàng #' + orderCode + ' có tiền mặt COD cần thu là: ' + formatted + '.\n\nBạn đã nhận đủ số tiền này từ khách hàng chưa?';
            }

            if (!confirm(msg)) return;

            fetch(contextPath + '/shipper/portal', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                body: 'action=deliver_success&orderId=' + orderId + '&notes=' + encodeURIComponent('Giao hàng thành công bởi tài xế')
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert('Thành công: ' + data.message);
                    location.href = contextPath + '/shipper/portal?shipperId=' + currentShipperId + '&tab=' + currentTab + '&msg=' + encodeURIComponent(data.message);
                } else {
                    alert('Lỗi: ' + data.message);
                }
            })
            .catch(err => {
                console.error(err);
                alert('Có lỗi xảy ra khi kết nối máy chủ!');
            });
        }

        // 2. Modal Báo Giao Thất Bại
        function openFailureModal(orderId, orderCode, recipientName) {
            document.getElementById('failOrderId').value = orderId;
            document.getElementById('failModalOrderCode').innerText = orderCode + ' (' + recipientName + ')';
            document.getElementById('failureModal').classList.remove('hidden');
        }

        function closeFailureModal() {
            document.getElementById('failureModal').classList.add('hidden');
        }

        function submitFailureReport(e) {
            e.preventDefault();
            const form = document.getElementById('failureForm');
            const formData = new FormData(form);
            const params = new URLSearchParams(formData).toString();

            fetch(contextPath + '/shipper/portal', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                body: params
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    closeFailureModal();
                    alert(data.message);
                    location.href = contextPath + '/shipper/portal?shipperId=' + currentShipperId + '&tab=FAILED&msg=' + encodeURIComponent(data.message);
                } else {
                    alert('Lỗi: ' + data.message);
                }
            })
            .catch(err => {
                console.error(err);
                alert('Có lỗi xảy ra khi gửi báo cáo!');
            });
        }

        // 3. Modal Hẹn Giao Lại
        function openRescheduleModal(orderId, orderCode) {
            document.getElementById('rescheduleOrderId').value = orderId;
            document.getElementById('rescheduleOrderCode').innerText = orderCode;
            document.getElementById('rescheduleModal').classList.remove('hidden');
        }

        function closeRescheduleModal() {
            document.getElementById('rescheduleModal').classList.add('hidden');
        }

        function submitReschedule(e) {
            e.preventDefault();
            const form = document.getElementById('rescheduleForm');
            const formData = new FormData(form);
            const params = new URLSearchParams(formData).toString();

            fetch(contextPath + '/shipper/portal', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                body: params
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    closeRescheduleModal();
                    alert(data.message);
                    location.href = contextPath + '/shipper/portal?shipperId=' + currentShipperId + '&tab=SHIPPING&msg=' + encodeURIComponent(data.message);
                } else {
                    alert('Lỗi: ' + data.message);
                }
            })
            .catch(err => {
                console.error(err);
                alert('Có lỗi xảy ra khi hẹn lại!');
            });
        }

        // 4. Hoàn về kho
        function confirmReturnStock(orderId, orderCode) {
            const reason = prompt('Xác nhận hoàn hàng về kho cho đơn #' + orderCode + '?\nVui lòng nhập ghi chú hoàn kho:', 'Khách từ chối nhận sau 3 lần giao');
            if (reason === null) return;

            fetch(contextPath + '/shipper/portal', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                body: 'action=return_stock&orderId=' + orderId + '&notes=' + encodeURIComponent(reason)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    location.href = contextPath + '/shipper/portal?shipperId=' + currentShipperId + '&tab=FAILED&msg=' + encodeURIComponent(data.message);
                } else {
                    alert('Lỗi: ' + data.message);
                }
            })
            .catch(err => {
                console.error(err);
                alert('Có lỗi xảy ra!');
            });
        }
    </script>
</body>
</html>
