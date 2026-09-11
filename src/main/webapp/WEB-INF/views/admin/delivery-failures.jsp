<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Quản lý Giao Hàng & Shipper - Fruitables Admin</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</head>
<body class="bg-background text-on-surface font-body-md text-body-md flex h-screen overflow-hidden">

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />

<!-- Main Content Wrapper -->
<div class="flex-1 flex flex-col h-full overflow-hidden">

    <!-- Header -->
    <header class="h-20 bg-surface-container-lowest border-b border-surface-variant flex items-center justify-between px-6 flex-shrink-0 z-10 shadow-[0px_4px_20px_rgba(0,0,0,0.02)]">
        <div class="flex items-center gap-3">
            <span class="material-symbols-outlined text-primary text-3xl">local_shipping</span>
            <div>
                <h1 class="font-bold text-lg text-slate-800 leading-tight">Quản lý Giao hàng & Hiệu suất Shipper</h1>
                <p class="text-xs text-slate-500">Giám sát tiến độ vận chuyển, đơn hàng thất bại, tỷ lệ hoàn và điều phối giao lại hoa quả tươi</p>
            </div>
        </div>
        <div class="flex items-center gap-4 flex-shrink-0">
            <div class="flex items-center gap-3">
                <div class="flex flex-col text-right">
                    <span class="font-bold text-xs text-on-surface truncate max-w-[160px]">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
                    <span class="text-[10px] text-slate-400">Điều phối viên</span>
                </div>
                <span class="material-symbols-outlined text-3xl text-primary">account_circle</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-1 text-xs text-error hover:underline font-semibold">
                <span class="material-symbols-outlined text-base">logout</span> Đăng xuất
            </a>
        </div>
    </header>

    <!-- Main Scrollable Area -->
    <main class="flex-1 overflow-y-auto p-6 bg-[#f8fafc] space-y-6">

        <!-- 4 THẺ KPI GIAO HÀNG THẤT BẠI -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            <!-- Card 1: Tổng đơn thất bại / hoàn -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-sm hover:shadow-md transition-all">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Tổng đơn thất bại</span>
                    <div class="w-10 h-10 rounded-xl bg-rose-50 text-rose-600 flex items-center justify-center">
                        <span class="material-symbols-outlined">cancel</span>
                    </div>
                </div>
                <div class="flex items-baseline gap-2">
                    <span class="text-2xl font-black text-rose-600">${stats.totalFailed != null ? stats.totalFailed : 0}</span>
                    <span class="text-xs text-slate-500">đơn hàng</span>
                </div>
                <div class="mt-2 text-xs text-slate-500 flex items-center gap-1.5">
                    <span class="px-1.5 py-0.5 rounded bg-rose-100 text-rose-700 font-bold text-[11px]">${stats.failRate}%</span>
                    <span>tỷ lệ thất bại trên tổng đơn</span>
                </div>
            </div>

            <!-- Card 2: Tiền COD tồn đọng -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-sm hover:shadow-md transition-all">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Tiền COD chưa thu</span>
                    <div class="w-10 h-10 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
                        <span class="material-symbols-outlined">pending_actions</span>
                    </div>
                </div>
                <div class="text-2xl font-black text-amber-600">
                    <fmt:formatNumber value="${stats.pendingCod != null ? stats.pendingCod : 0}" type="number" groupingUsed="true"/> ₫
                </div>
                <div class="mt-2 text-xs text-slate-500">
                    Cần đối soát & xử lý thu hồi từ các đơn COD
                </div>
            </div>

            <!-- Card 3: Đang chờ giao lại -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-sm hover:shadow-md transition-all">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Chờ hẹn giao lại</span>
                    <div class="w-10 h-10 rounded-xl bg-sky-50 text-sky-600 flex items-center justify-center">
                        <span class="material-symbols-outlined">history</span>
                    </div>
                </div>
                <div class="flex items-baseline gap-2">
                    <span class="text-2xl font-black text-sky-600">${stats.retryCount != null ? stats.retryCount : 0}</span>
                    <span class="text-xs text-slate-500">đơn (thử lại &lt; 3 lần)</span>
                </div>
                <div class="mt-2 text-xs text-sky-700 font-medium">
                    Hoa quả đang bảo quản lạnh chờ dời lịch
                </div>
            </div>

            <!-- Card 4: Đã chuyển hoàn kho -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-sm hover:shadow-md transition-all">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Đã hoàn trả về kho</span>
                    <div class="w-10 h-10 rounded-xl bg-purple-50 text-purple-600 flex items-center justify-center">
                        <span class="material-symbols-outlined">warehouse</span>
                    </div>
                </div>
                <div class="flex items-baseline gap-2">
                    <span class="text-2xl font-black text-purple-600">${stats.returnedCount != null ? stats.returnedCount : 0}</span>
                    <span class="text-xs text-slate-500">đơn hoàn tất kiểm kho</span>
                </div>
                <div class="mt-2 text-xs text-purple-700 font-medium">
                    Đã cộng hoàn trả tồn kho tự động
                </div>
            </div>
        </div>

        <!-- 2 BIỂU ĐỒ CHUYÊN SÂU CHO SHIPPER & ĐƠN THẤT BẠI -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            <!-- Biểu đồ 1: Phân tích Nguyên nhân giao thất bại (Donut Chart) -->
            <div class="lg:col-span-5 bg-white p-5 rounded-2xl border border-slate-200/80 shadow-sm flex flex-col justify-between">
                <div class="flex items-center justify-between mb-4">
                    <div>
                        <h3 class="font-bold text-slate-800 text-sm flex items-center gap-1.5">
                            <span class="material-symbols-outlined text-rose-600 text-base">pie_chart</span>
                            Phân tích Nguyên nhân Thất bại
                        </h3>
                        <p class="text-[11px] text-slate-400 mt-0.5">Tỷ lệ các lý do khách từ chối nhận hoặc không liên lạc được</p>
                    </div>
                </div>
                <div class="relative h-[250px] w-full flex items-center justify-center">
                    <canvas id="failedReasonChart"></canvas>
                </div>
                <div id="failedReasonLegend" class="mt-4 space-y-1.5 text-xs">
                    <!-- Nạp động bằng JavaScript -->
                </div>
            </div>

            <!-- Biểu đồ 2: So sánh Tỷ lệ Thất bại theo Từng Shipper (Bar Chart) -->
            <div class="lg:col-span-7 bg-white p-5 rounded-2xl border border-slate-200/80 shadow-sm flex flex-col justify-between">
                <div class="flex items-center justify-between mb-4">
                    <div>
                        <h3 class="font-bold text-slate-800 text-sm flex items-center gap-1.5">
                            <span class="material-symbols-outlined text-blue-600 text-base">bar_chart</span>
                            Hiệu suất & Tỷ lệ Thất bại theo Shipper
                        </h3>
                        <p class="text-[11px] text-slate-400 mt-0.5">Đối sánh đơn giao thành công vs Thất bại của từng tài xế</p>
                    </div>
                </div>
                <div class="relative h-[280px] w-full">
                    <canvas id="shipperComparisonChart"></canvas>
                </div>
            </div>
        </div>

        <!-- BỘ LỌC VÀ TÌM KIẾM ĐƠN THẤT BẠI -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-sm">
            <form id="filterForm" action="${pageContext.request.contextPath}/admin/delivery-failures" method="GET" class="space-y-4">
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-12 gap-3.5 items-end">
                    <!-- Từ khóa -->
                    <div class="lg:col-span-3">
                        <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider mb-1.5">
                            <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">search</span> Tìm kiếm</span>
                        </label>
                        <div class="relative">
                            <input type="text" name="keyword" value="<c:out value='${keyword}'/>" placeholder="Mã ĐH, mã vận đơn, tên khách, SĐT..."
                                   class="w-full pl-9 pr-3 py-2 text-xs rounded-xl border border-slate-200 bg-slate-50 focus:bg-white focus:border-primary outline-none transition-all">
                            <span class="material-symbols-outlined text-[16px] text-slate-400 absolute left-2.5 top-1/2 -translate-y-1/2">receipt</span>
                        </div>
                    </div>

                    <!-- Lọc theo Shipper -->
                    <div class="lg:col-span-2">
                        <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider mb-1.5">
                            <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">two_wheeler</span> Shipper</span>
                        </label>
                        <select name="shipperId" class="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 bg-slate-50 focus:bg-white focus:border-primary outline-none transition-all">
                            <option value="ALL" ${selectedShipperId == 0 ? 'selected' : ''}>Tất cả tài xế</option>
                            <c:forEach var="s" items="${shippers}">
                                <option value="${s.id}" ${selectedShipperId == s.id ? 'selected' : ''}>${s.fullName} (${s.vehiclePlate})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Lọc theo Nguyên nhân -->
                    <div class="lg:col-span-2">
                        <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider mb-1.5">
                            <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">help</span> Lý do thất bại</span>
                        </label>
                        <select name="reason" class="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 bg-slate-50 focus:bg-white focus:border-primary outline-none transition-all">
                            <option value="ALL" ${selectedReason == 'ALL' ? 'selected' : ''}>Tất cả lý do</option>
                            <option value="nghe máy" ${selectedReason == 'nghe máy' ? 'selected' : ''}>Khách không nghe máy</option>
                            <option value="giao lại" ${selectedReason == 'giao lại' ? 'selected' : ''}>Khách hẹn dời lịch</option>
                            <option value="từ chối" ${selectedReason == 'từ chối' ? 'selected' : ''}>Khách từ chối nhận</option>
                            <option value="dập" ${selectedReason == 'dập' ? 'selected' : ''}>Hoa quả dập hỏng</option>
                            <option value="địa chỉ" ${selectedReason == 'địa chỉ' ? 'selected' : ''}>Sai địa chỉ / tìm nhà</option>
                        </select>
                    </div>

                    <!-- Từ ngày -->
                    <div class="lg:col-span-2">
                        <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider mb-1.5">
                            <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">calendar_today</span> Từ ngày</span>
                        </label>
                        <input type="date" id="filterStartDate" name="startDate" value="${startDate}"
                               class="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 bg-slate-50 focus:bg-white focus:border-primary outline-none transition-all">
                    </div>

                    <!-- Đến ngày -->
                    <div class="lg:col-span-2">
                        <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-wider mb-1.5">
                            <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">event</span> Đến ngày</span>
                        </label>
                        <input type="date" id="filterEndDate" name="endDate" value="${endDate}"
                               class="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 bg-slate-50 focus:bg-white focus:border-primary outline-none transition-all">
                    </div>

                    <!-- Nút lọc -->
                    <div class="lg:col-span-1 flex items-center gap-2">
                        <button type="submit" class="w-full py-2 px-3 bg-primary hover:bg-primary-container text-white text-xs font-bold rounded-xl shadow-sm transition-all flex items-center justify-center gap-1">
                            <span class="material-symbols-outlined text-[16px]">filter_alt</span> Lọc
                        </button>
                    </div>
                </div>

                <!-- Phím tắt ngày nhanh -->
                <div class="flex items-center gap-2 pt-2 border-t border-slate-100 text-xs flex-wrap">
                    <span class="text-slate-400 text-[11px] font-medium">Mốc nhanh:</span>
                    <button type="button" onclick="setQuickDate('today')" class="px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-primary/10 hover:text-primary text-slate-600 font-medium text-[11px] transition-colors">Hôm nay</button>
                    <button type="button" onclick="setQuickDate('7days')" class="px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-primary/10 hover:text-primary text-slate-600 font-medium text-[11px] transition-colors">7 ngày qua</button>
                    <button type="button" onclick="setQuickDate('thisMonth')" class="px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-primary/10 hover:text-primary text-slate-600 font-medium text-[11px] transition-colors">Tháng này</button>
                    <a href="${pageContext.request.contextPath}/admin/delivery-failures" class="px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-500 font-medium text-[11px] transition-colors ml-auto">Đặt lại bộ lọc</a>
                </div>
            </form>
        </div>

        <!-- BẢNG CHI TIẾT DANH SÁCH ĐƠN HÀNG GIAO THẤT BẠI -->
        <div class="bg-white rounded-2xl shadow-sm overflow-hidden border border-slate-200">
            <div class="p-4 border-b border-slate-100 flex items-center justify-between bg-slate-50/50">
                <div class="flex items-center gap-2">
                    <span class="w-2.5 h-2.5 rounded-full bg-rose-500 animate-ping"></span>
                    <h2 class="font-bold text-slate-800 text-sm">Danh sách đơn hàng giao thất bại & hoàn trả</h2>
                    <span class="px-2 py-0.5 bg-rose-100 text-rose-700 font-bold text-xs rounded-full">${orders.size()} đơn</span>
                </div>
                <div class="text-xs text-slate-500">
                    Nhấp vào các nút thao tác để Hẹn giao lại hoặc Hoàn kho hoa quả
                </div>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse text-xs">
                    <thead>
                    <tr class="bg-slate-50 text-slate-600 font-bold border-b border-slate-200 uppercase tracking-wider text-[11px]">
                        <th class="py-3.5 px-4">Mã ĐH & Vận đơn</th>
                        <th class="py-3.5 px-4">Khách hàng & SĐT</th>
                        <th class="py-3.5 px-4">Địa chỉ giao</th>
                        <th class="py-3.5 px-4">Shipper phụ trách</th>
                        <th class="py-3.5 px-4 text-center">Số lần thử</th>
                        <th class="py-3.5 px-4">Lý do & Ghi chú Shipper</th>
                        <th class="py-3.5 px-4">Tiền COD</th>
                        <th class="py-3.5 px-4 text-center">Trạng thái</th>
                        <th class="py-3.5 px-4 text-center">Hành động xử lý</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                    <c:forEach var="o" items="${orders}">
                        <tr id="row-order-${o.id}" class="hover:bg-slate-50/80 transition-colors">
                            <!-- Mã ĐH -->
                            <td class="py-3.5 px-4 whitespace-nowrap">
                                <div class="font-bold text-primary">${o.orderCode}</div>
                                <c:if test="${not empty o.trackingNumber}">
                                    <div class="text-[10px] text-slate-400 flex items-center gap-1 mt-0.5">
                                        <span class="material-symbols-outlined text-[12px]">local_shipping</span> ${o.trackingNumber}
                                    </div>
                                </c:if>
                                <div class="text-[10px] text-slate-400 mt-0.5">
                                    <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </td>

                            <!-- Khách hàng -->
                            <td class="py-3.5 px-4">
                                <div class="font-bold text-slate-800">${o.recipientName != null ? o.recipientName : 'Khách vãng lai'}</div>
                                <a href="tel:${o.phone}" class="text-primary hover:underline font-semibold flex items-center gap-1 mt-0.5 text-[11px]">
                                    <span class="material-symbols-outlined text-[13px]">call</span> ${o.phone}
                                </a>
                            </td>

                            <!-- Địa chỉ -->
                            <td class="py-3.5 px-4 max-w-[200px]">
                                <div class="line-clamp-2 text-slate-600 text-[11px]" title="${o.shippingAddress}">${o.shippingAddress}</div>
                                <c:if test="${o.distanceKm != null && o.distanceKm > 0}">
                                    <span class="text-[10px] text-slate-400">Cách kho: ${o.distanceKm} km</span>
                                </c:if>
                            </td>

                            <!-- Shipper -->
                            <td class="py-3.5 px-4 whitespace-nowrap">
                                <c:choose>
                                    <c:when test="${o.shipper != null}">
                                        <div class="flex items-center gap-2">
                                            <img src="${o.shipper.avatarUrl}" class="w-7 h-7 rounded-full object-cover border border-slate-200" alt="Shipper">
                                            <div>
                                                <div class="font-bold text-slate-800 text-[11px]">${o.shipper.fullName}</div>
                                                <div class="text-[10px] text-slate-500">${o.shipper.phone} - ${o.shipper.vehiclePlate}</div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-2 py-0.5 bg-slate-100 text-slate-500 rounded text-[10px]">Chưa gán</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Số lần thử giao -->
                            <td class="py-3.5 px-4 text-center whitespace-nowrap">
                                <c:choose>
                                    <c:when test="${o.deliveryAttempts >= 3}">
                                        <span class="px-2 py-0.5 bg-red-100 text-red-700 rounded-full font-bold text-[10px]">Lần ${o.deliveryAttempts}/3 (Quá hạn)</span>
                                    </c:when>
                                    <c:when test="${o.deliveryAttempts == 2}">
                                        <span class="px-2 py-0.5 bg-amber-100 text-amber-700 rounded-full font-bold text-[10px]">Lần 2/3</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-2 py-0.5 bg-sky-100 text-sky-700 rounded-full font-bold text-[10px]">Lần 1/3</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Lý do & Ghi chú -->
                            <td class="py-3.5 px-4 max-w-[240px]">
                                <div class="font-bold text-rose-700 text-[11px] flex items-center gap-1">
                                    <span class="material-symbols-outlined text-[13px] text-rose-500">warning</span>
                                    <span>${not empty o.failedReason ? o.failedReason : 'Chưa ghi nhận lý do'}</span>
                                </div>
                                <c:if test="${not empty o.failedNotes}">
                                    <div class="text-[11px] text-slate-500 bg-slate-50 p-1.5 rounded-lg border border-slate-100 mt-1 line-clamp-2" title="${o.failedNotes}">
                                        ${o.failedNotes}
                                    </div>
                                </c:if>
                            </td>

                            <!-- Tiền COD -->
                            <td class="py-3.5 px-4 whitespace-nowrap">
                                <div class="font-bold text-slate-900">
                                    <fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true"/> ₫
                                </div>
                                <div class="text-[10px] text-slate-400 uppercase font-semibold mt-0.5">
                                    ${o.paymentMethod} &bull; ${o.paymentStatus == 'PAID' ? '<span class="text-green-600">Đã TT</span>' : '<span class="text-amber-600">Chưa TT</span>'}
                                </div>
                            </td>

                            <!-- Trạng thái -->
                            <td class="py-3.5 px-4 text-center whitespace-nowrap">
                                <c:choose>
                                    <c:when test="${o.status == 'RETURNED'}">
                                        <span class="px-2.5 py-1 bg-purple-100 text-purple-700 rounded-full font-bold text-[10px] inline-flex items-center gap-1">
                                            <span class="w-1.5 h-1.5 rounded-full bg-purple-600"></span> Đã hoàn kho
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-2.5 py-1 bg-rose-100 text-rose-700 rounded-full font-bold text-[10px] inline-flex items-center gap-1">
                                            <span class="w-1.5 h-1.5 rounded-full bg-rose-600"></span> Giao thất bại
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Hành động -->
                            <td class="py-3.5 px-4 text-center whitespace-nowrap">
                                <div class="flex items-center justify-center gap-1.5">
                                    <!-- Nút Hẹn giao lại -->
                                    <c:if test="${o.status != 'RETURNED'}">
                                        <button type="button" onclick="openRetryModal('${o.id}', '${o.orderCode}', '${o.shipperId}', '${o.recipientName}')"
                                                class="px-2.5 py-1 bg-sky-600 text-white hover:bg-sky-700 rounded-lg text-[11px] font-bold flex items-center gap-1 shadow-sm transition-all" title="Lên lịch hẹn giao lại">
                                            <span class="material-symbols-outlined text-[13px]">event_repeat</span> Giao lại
                                        </button>
                                    </c:if>

                                    <!-- Nút Hoàn kho -->
                                    <c:if test="${o.status != 'RETURNED'}">
                                        <button type="button" onclick="handleReturnToStock('${o.id}', '${o.orderCode}')"
                                                class="px-2.5 py-1 bg-purple-600 text-white hover:bg-purple-700 rounded-lg text-[11px] font-bold flex items-center gap-1 shadow-sm transition-all" title="Hoàn trả về kho & cộng tồn kho">
                                            <span class="material-symbols-outlined text-[13px]">warehouse</span> Hoàn kho
                                        </button>
                                    </c:if>

                                    <!-- Nút Giao thành công -->
                                    <c:if test="${o.status != 'RETURNED'}">
                                        <button type="button" onclick="handleMarkDelivered('${o.id}', '${o.orderCode}')"
                                                class="p-1 bg-emerald-50 text-emerald-700 hover:bg-emerald-600 hover:text-white rounded-lg transition-colors" title="Đánh dấu đã giao thành công">
                                            <span class="material-symbols-outlined text-[15px]">done_all</span>
                                        </button>
                                    </c:if>

                                    <!-- Nút Chỉnh sửa lý do -->
                                    <button type="button" onclick="openEditReasonModal('${o.id}', '${o.orderCode}', '${o.failedReason}', '${o.deliveryAttempts}')"
                                            class="p-1 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-lg transition-colors" title="Cập nhật lý do & ghi chú">
                                        <span class="material-symbols-outlined text-[15px]">edit_note</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="9" class="py-12 text-center text-slate-400">
                                <span class="material-symbols-outlined text-4xl text-slate-300 block mb-2">check_circle</span>
                                Không có đơn hàng giao thất bại nào khớp với bộ lọc hiện tại.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

<!-- MODAL HẸN GIAO LẠI -->
<div id="retryModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden border border-slate-200 animate-in fade-in zoom-in-95 duration-200" onclick="event.stopPropagation()">
        <div class="bg-sky-600 px-6 py-4 flex items-center justify-between text-white">
            <h3 class="font-bold text-base flex items-center gap-2">
                <span class="material-symbols-outlined">event_repeat</span> Lên lịch Hẹn Giao Lại
            </h3>
            <button type="button" onclick="closeRetryModal()" class="w-8 h-8 rounded-full bg-white/20 hover:bg-white/30 flex items-center justify-center">
                <span class="material-symbols-outlined text-sm">close</span>
            </button>
        </div>
        <form id="retryForm" onsubmit="submitRetryForm(event)" class="p-6 space-y-4 text-xs">
            <input type="hidden" id="retryOrderId" name="orderId">
            <input type="hidden" name="action" value="scheduleRetry">

            <div>
                <span class="text-slate-500">Mã đơn hàng:</span>
                <span id="retryOrderCode" class="font-bold text-slate-900 ml-1"></span>
            </div>

            <div>
                <label class="block font-bold text-slate-700 mb-1">Gán Shipper phụ trách:</label>
                <select id="retryShipperSelect" name="shipperId" class="w-full px-3 py-2 text-xs rounded-xl border border-slate-300 outline-none focus:border-primary">
                    <c:forEach var="s" items="${shippers}">
                        <option value="${s.id}">${s.fullName} (${s.phone} - ${s.vehiclePlate})</option>
                    </c:forEach>
                </select>
            </div>

            <div>
                <label class="block font-bold text-slate-700 mb-1">Thời gian hẹn giao:</label>
                <input type="text" id="retryDeliveryTime" name="deliveryTime" placeholder="Ví dụ: Sáng mai 8h30 - 9h30, hoặc 14h chiều" required
                       class="w-full px-3 py-2 text-xs rounded-xl border border-slate-300 outline-none focus:border-primary">
            </div>

            <div>
                <label class="block font-bold text-slate-700 mb-1">Ghi chú hẹn của khách / tài xế:</label>
                <textarea id="retryNotes" name="notes" rows="2" placeholder="Ghi chú dặn dò khi đi giao lại..."
                          class="w-full px-3 py-2 text-xs rounded-xl border border-slate-300 outline-none focus:border-primary"></textarea>
            </div>

            <div class="flex justify-end gap-2 pt-3 border-t border-slate-100">
                <button type="button" onclick="closeRetryModal()" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-xl">Đóng</button>
                <button type="submit" class="px-4 py-2 bg-sky-600 hover:bg-sky-700 text-white font-bold rounded-xl shadow-sm">Xác nhận giao lại</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL CẬP NHẬT LÝ DO THẤT BẠI -->
<div id="editReasonModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden border border-slate-200 animate-in fade-in zoom-in-95 duration-200" onclick="event.stopPropagation()">
        <div class="bg-rose-600 px-6 py-4 flex items-center justify-between text-white">
            <h3 class="font-bold text-base flex items-center gap-2">
                <span class="material-symbols-outlined">edit_note</span> Cập nhật Lý do Thất bại
            </h3>
            <button type="button" onclick="closeEditReasonModal()" class="w-8 h-8 rounded-full bg-white/20 hover:bg-white/30 flex items-center justify-center">
                <span class="material-symbols-outlined text-sm">close</span>
            </button>
        </div>
        <form id="editReasonForm" onsubmit="submitEditReasonForm(event)" class="p-6 space-y-4 text-xs">
            <input type="hidden" id="editReasonOrderId" name="orderId">
            <input type="hidden" name="action" value="updateReason">

            <div>
                <span class="text-slate-500">Mã đơn hàng:</span>
                <span id="editReasonOrderCode" class="font-bold text-slate-900 ml-1"></span>
            </div>

            <div>
                <label class="block font-bold text-slate-700 mb-1">Lý do thất bại chính:</label>
                <select id="editReasonSelect" name="reason" class="w-full px-3 py-2 text-xs rounded-xl border border-slate-300 outline-none focus:border-primary">
                    <option value="Khách không nghe máy (đã gọi 3 lần)">Khách không nghe máy (đã gọi 3 lần)</option>
                    <option value="Khách hẹn giao lại vào ngày mai do bận đột xuất">Khách hẹn giao lại vào ngày mai do bận đột xuất</option>
                    <option value="Khách kiểm tra từ chối nhận do đổi ý không còn nhu cầu">Khách kiểm tra từ chối nhận do đổi ý không còn nhu cầu</option>
                    <option value="Hoa quả bị va đập móp hộp trong quá trình vận chuyển">Hoa quả bị va đập móp hộp trong quá trình vận chuyển</option>
                    <option value="Địa chỉ không chính xác, không liên hệ được số nhà trong ngõ">Địa chỉ không chính xác, không liên hệ được số nhà trong ngõ</option>
                    <option value="Khách không đủ tiền mặt thanh toán COD">Khách không đủ tiền mặt thanh toán COD</option>
                </select>
            </div>

            <div>
                <label class="block font-bold text-slate-700 mb-1">Số lần đã giao (Attempts):</label>
                <input type="number" id="editReasonAttempts" name="attempts" min="1" max="5" value="1"
                       class="w-full px-3 py-2 text-xs rounded-xl border border-slate-300 outline-none focus:border-primary">
            </div>

            <div>
                <label class="block font-bold text-slate-700 mb-1">Ghi chú chi tiết của Shipper:</label>
                <textarea id="editReasonNotes" name="notes" rows="3" placeholder="Ghi nhận cụ thể tình huống xảy ra tại điểm giao..."
                          class="w-full px-3 py-2 text-xs rounded-xl border border-slate-300 outline-none focus:border-primary"></textarea>
            </div>

            <div class="flex justify-end gap-2 pt-3 border-t border-slate-100">
                <button type="button" onclick="closeEditReasonModal()" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-xl">Đóng</button>
                <button type="submit" class="px-4 py-2 bg-rose-600 hover:bg-rose-700 text-white font-bold rounded-xl shadow-sm">Lưu cập nhật</button>
            </div>
        </form>
    </div>
</div>

<script>
    let failedReasonChart = null;
    let shipperComparisonChart = null;

    function setQuickDate(type) {
        const today = new Date();
        const startInput = document.getElementById('filterStartDate');
        const endInput = document.getElementById('filterEndDate');

        const formatDate = (d) => {
            const y = d.getFullYear();
            const m = String(d.getMonth() + 1).padStart(2, '0');
            const day = String(d.getDate()).padStart(2, '0');
            return y + '-' + m + '-' + day;
        };

        if (type === 'today') {
            const t = formatDate(today);
            startInput.value = t;
            endInput.value = t;
        } else if (type === '7days') {
            const d = new Date();
            d.setDate(d.getDate() - 7);
            startInput.value = formatDate(d);
            endInput.value = formatDate(today);
        } else if (type === 'thisMonth') {
            const d = new Date(today.getFullYear(), today.getMonth(), 1);
            startInput.value = formatDate(d);
            endInput.value = formatDate(today);
        }
        document.getElementById('filterForm').submit();
    }

    function loadShipperFailureCharts() {
        const params = new URLSearchParams(window.location.search);
        fetch('${pageContext.request.contextPath}/api/shipper-failure-stats?' + params.toString())
            .then(res => res.json())
            .then(data => {
                renderFailedReasonChart(data.reasons);
                renderShipperComparisonChart(data.shippers);
            })
            .catch(err => console.error('Lỗi tải biểu đồ shipper:', err));
    }

    function renderFailedReasonChart(reasonData) {
        if (!reasonData) return;
        const ctx = document.getElementById('failedReasonChart').getContext('2d');
        if (failedReasonChart) failedReasonChart.destroy();

        const colors = ['#f43f5e', '#f97316', '#eab308', '#8b5cf6', '#3b82f6', '#64748b'];

        failedReasonChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: reasonData.labels,
                datasets: [{
                    data: reasonData.counts,
                    backgroundColor: colors,
                    borderWidth: 2,
                    borderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '68%',
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(ctx) {
                                const count = ctx.parsed;
                                const amt = reasonData.amounts ? reasonData.amounts[ctx.dataIndex] : 0;
                                return ctx.label + ': ' + count + ' đơn (' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amt) + ')';
                            }
                        }
                    }
                }
            }
        });

        // Render Legend bên dưới
        const legend = document.getElementById('failedReasonLegend');
        if (legend && reasonData.labels) {
            let html = '';
            let total = 0;
            reasonData.counts.forEach(c => total += c);
            if (total === 0) total = 1;

            reasonData.labels.forEach((label, idx) => {
                const count = reasonData.counts[idx];
                const pct = Math.round((count / total) * 100);
                html += '<div class="flex items-center justify-between p-1.5 rounded-lg bg-slate-50 border border-slate-100 hover:bg-slate-100 transition-colors">' +
                    '<div class="flex items-center gap-2 truncate">' +
                    '<span class="w-2.5 h-2.5 rounded-full flex-shrink-0" style="background-color:' + colors[idx % colors.length] + '"></span>' +
                    '<span class="font-medium text-slate-700 truncate" title="' + label + '">' + label + '</span>' +
                    '</div>' +
                    '<div class="text-right flex items-center gap-2 flex-shrink-0">' +
                    '<span class="font-bold text-slate-900">' + count + '</span>' +
                    '<span class="text-[10px] text-slate-400 font-semibold">' + pct + '%</span>' +
                    '</div>' +
                    '</div>';
            });
            legend.innerHTML = html;
        }
    }

    function renderShipperComparisonChart(shipperData) {
        if (!shipperData) return;
        const ctx = document.getElementById('shipperComparisonChart').getContext('2d');
        if (shipperComparisonChart) shipperComparisonChart.destroy();

        shipperComparisonChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: shipperData.labels,
                datasets: [
                    {
                        label: 'Giao thành công',
                        data: shipperData.deliveredCounts,
                        backgroundColor: '#22c55e',
                        borderRadius: 6
                    },
                    {
                        label: 'Giao thất bại',
                        data: shipperData.failedCounts,
                        backgroundColor: '#f43f5e',
                        borderRadius: 6
                    },
                    {
                        label: 'Đã hoàn kho',
                        data: shipperData.returnedCounts,
                        backgroundColor: '#a855f7',
                        borderRadius: 6
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'top', labels: { usePointStyle: true, font: { size: 11 } } },
                    tooltip: {
                        callbacks: {
                            afterBody: function(items) {
                                const idx = items[0].dataIndex;
                                const rate = shipperData.failRates ? shipperData.failRates[idx] : 0;
                                return 'Tỷ lệ thất bại: ' + rate + '%';
                            }
                        }
                    }
                },
                scales: {
                    y: { beginAtZero: true, ticks: { stepSize: 2 } }
                }
            }
        });
    }

    // Handlers Modal & AJAX Actions
    function openRetryModal(orderId, orderCode, shipperId, recipient) {
        document.getElementById('retryOrderId').value = orderId;
        document.getElementById('retryOrderCode').innerText = orderCode + ' (' + recipient + ')';
        if (shipperId && shipperId > 0) {
            document.getElementById('retryShipperSelect').value = shipperId;
        }
        document.getElementById('retryModal').classList.remove('hidden');
    }

    function closeRetryModal() {
        document.getElementById('retryModal').classList.add('hidden');
    }

    function submitRetryForm(e) {
        e.preventDefault();
        const form = document.getElementById('retryForm');
        const formData = new URLSearchParams(new FormData(form));

        fetch('${pageContext.request.contextPath}/admin/delivery-failures', {
            method: 'POST',
            body: formData,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
            .then(res => res.json())
            .then(data => {
                alert(data.message);
                if (data.success) {
                    window.location.reload();
                }
            })
            .catch(err => alert('Lỗi kết nối: ' + err));
    }

    function handleReturnToStock(orderId, orderCode) {
        if (!confirm('Xác nhận hoàn kho hoa quả cho đơn ' + orderCode + '?\nSố lượng sản phẩm trong đơn sẽ tự động được cộng trả lại vào kho.')) {
            return;
        }
        const params = new URLSearchParams();
        params.append('action', 'returnToStock');
        params.append('orderId', orderId);
        params.append('notes', 'Hoàn kho bảo quản theo yêu cầu điều phối');

        fetch('${pageContext.request.contextPath}/admin/delivery-failures', {
            method: 'POST',
            body: params,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
            .then(res => res.json())
            .then(data => {
                alert(data.message);
                if (data.success) window.location.reload();
            })
            .catch(err => alert('Lỗi: ' + err));
    }

    function handleMarkDelivered(orderId, orderCode) {
        if (!confirm('Xác nhận khách đã nhận hàng thành công cho đơn ' + orderCode + '?')) return;
        const params = new URLSearchParams();
        params.append('action', 'markDelivered');
        params.append('orderId', orderId);

        fetch('${pageContext.request.contextPath}/admin/delivery-failures', {
            method: 'POST',
            body: params,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
            .then(res => res.json())
            .then(data => {
                alert(data.message);
                if (data.success) window.location.reload();
            })
            .catch(err => alert('Lỗi: ' + err));
    }

    function openEditReasonModal(orderId, orderCode, reason, attempts) {
        document.getElementById('editReasonOrderId').value = orderId;
        document.getElementById('editReasonOrderCode').innerText = orderCode;
        if (reason) document.getElementById('editReasonSelect').value = reason;
        if (attempts) document.getElementById('editReasonAttempts').value = attempts;
        document.getElementById('editReasonModal').classList.remove('hidden');
    }

    function closeEditReasonModal() {
        document.getElementById('editReasonModal').classList.add('hidden');
    }

    function submitEditReasonForm(e) {
        e.preventDefault();
        const form = document.getElementById('editReasonForm');
        const formData = new URLSearchParams(new FormData(form));

        fetch('${pageContext.request.contextPath}/admin/delivery-failures', {
            method: 'POST',
            body: formData,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
            .then(res => res.json())
            .then(data => {
                alert(data.message);
                if (data.success) window.location.reload();
            })
            .catch(err => alert('Lỗi: ' + err));
    }

    document.addEventListener('DOMContentLoaded', function() {
        loadShipperFailureCharts();
    });
</script>

</body>
</html>
