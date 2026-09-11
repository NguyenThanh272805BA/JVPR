<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Bảng điều khiển - Fruitables Admin</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>

    <style>
        .sidebar-item-active {
            background-color: #81c408;
            color: white;
        }
        .sidebar-item-active .material-symbols-outlined {
            color: white;
        }
    </style>
</head>
<body class="bg-background text-on-surface font-body-md text-body-md flex h-screen overflow-hidden">

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />


<!-- Main Content Wrapper -->
<div class="flex-1 flex flex-col h-full overflow-hidden">

    <!-- Header -->
    <header class="h-20 bg-surface-container-lowest border-b border-surface-variant flex items-center justify-between px-margin-desktop flex-shrink-0 z-10 shadow-[0px_4px_20px_rgba(0,0,0,0.02)]">
        <div class="flex items-center w-full max-w-md">
            <div class="relative w-full">
                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">search</span>
                <input class="w-full pl-10 pr-4 py-2 bg-surface-container rounded-md border-transparent focus:border-primary-container focus:ring-1 focus:ring-primary-container font-body-md text-body-md transition-shadow" placeholder="Tìm kiếm nhanh..." type="text"/>
            </div>
        </div>
        <div class="flex items-center gap-4 flex-shrink-0">
            <div class="flex items-center gap-3 min-w-0">
                <div class="flex flex-col text-right min-w-0">
                    <span class="font-label-bold text-label-bold text-on-surface truncate max-w-[160px] whitespace-nowrap" title="${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
                    <span class="text-xs text-on-surface-variant">Quản trị viên</span>
                </div>
                <span class="material-symbols-outlined text-4xl text-primary flex-shrink-0" style="font-variation-settings: 'FILL' 1;">account_circle</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-2 text-error hover:text-on-error-container transition-colors">
                <span class="material-symbols-outlined">logout</span>
                <span class="font-label-bold text-label-bold">Đăng xuất</span>
            </a>
        </div>
    </header>

    <!-- Main Scrollable Area -->
    <main class="flex-1 overflow-y-auto p-margin-desktop bg-background">
        <div class="max-w-container-max-width mx-auto space-y-8">
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 class="font-headline-md text-headline-md text-on-surface">Tổng quan hệ thống</h1>
                    <p class="text-xs text-on-surface-variant mt-1">Giám sát doanh thu thuần, chi phí giá vốn (COGS), biên lợi nhuận và đơn hàng</p>
                </div>
                <div class="flex items-center gap-3">
                    <a href="${pageContext.request.contextPath}/admin/dashboard/export-excel" class="inline-flex items-center gap-2 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl font-label-bold text-xs shadow-sm transition-all hover:shadow-md">
                        <span class="material-symbols-outlined text-base">download</span>
                        <span>Xuất báo cáo Excel (.xlsx)</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/inventory/create" class="inline-flex items-center gap-2 px-4 py-2 bg-primary hover:bg-primary-container text-white rounded-xl font-label-bold text-xs shadow-sm transition-all hover:shadow-md">
                        <span class="material-symbols-outlined text-base">add_box</span>
                        <span>Nhập kho mới</span>
                    </a>
                </div>
            </div>

            <!-- Stats Row: 4 Thẻ KPI Tài Chính & Vận Hành -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-gutter">
                <!-- Thẻ 1: Tổng doanh thu thuần -->
                <div class="relative group">
                    <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-all duration-300 border border-transparent hover:border-primary/40 cursor-pointer">
                        <div class="flex items-center justify-between mb-4">
                            <span class="text-on-surface-variant font-label-bold text-label-bold flex items-center gap-1">
                                Doanh thu thuần
                                <span class="material-symbols-outlined text-[16px] text-primary">info</span>
                            </span>
                            <div class="w-10 h-10 rounded-full bg-primary-container/20 flex items-center justify-center text-primary-container">
                                <span class="material-symbols-outlined">payments</span>
                            </div>
                        </div>
                        <div class="font-price-tag text-price-tag text-primary">
                            <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> ₫
                        </div>
                        <div class="mt-2 text-xs text-on-surface-variant flex items-center gap-1.5">
                            <span class="inline-flex items-center text-xs font-bold ${kpiMetrics.revGrowthToday >= 0 ? 'text-green-600' : 'text-red-500'}">
                                <span class="material-symbols-outlined text-xs">${kpiMetrics.revGrowthToday >= 0 ? 'trending_up' : 'trending_down'}</span>
                                ${kpiMetrics.revGrowthToday}%
                            </span>
                            <span>so với hôm qua</span>
                        </div>
                    </div>

                    <!-- Khung nảy so sánh thông số khi Hover -->
                    <div class="absolute left-0 top-full mt-2 w-80 md:w-96 bg-white/95 backdrop-blur-md rounded-2xl shadow-2xl p-5 border border-slate-200 z-50 opacity-0 pointer-events-none group-hover:opacity-100 group-hover:pointer-events-auto transition-all duration-200 transform translate-y-1 group-hover:translate-y-0">
                        <div class="absolute -top-2 left-8 w-4 h-4 bg-white border-t border-l border-slate-200 transform rotate-45"></div>
                        <div class="flex items-center justify-between border-b pb-2 mb-3">
                            <span class="font-bold text-slate-800 text-sm flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-primary text-base">query_stats</span> Phân tích doanh số
                            </span>
                            <span class="px-2 py-0.5 rounded-full text-[10px] font-bold ${kpiMetrics.revGrowthToday >= 0 ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-600'}">
                                ${kpiMetrics.revGrowthToday >= 0 ? '+' : ''}${kpiMetrics.revGrowthToday}%
                            </span>
                        </div>
                        <div class="space-y-2.5 text-xs text-slate-600">
                            <div class="flex justify-between items-center">
                                <span>Doanh thu hôm nay:</span>
                                <span class="font-bold text-slate-900"><fmt:formatNumber value="${kpiMetrics.revToday}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span>Doanh thu hôm qua:</span>
                                <span class="font-semibold text-slate-500"><fmt:formatNumber value="${kpiMetrics.revYesterday}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                            <div class="flex justify-between items-center pt-1 border-t border-dashed">
                                <span>Giá trị TB/Đơn (AOV):</span>
                                <span class="font-bold text-primary"><fmt:formatNumber value="${kpiMetrics.aov}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thẻ 2: Tổng giá vốn hàng bán (COGS) -->
                <div class="relative group">
                    <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-all duration-300 border border-transparent hover:border-amber-500/40 cursor-pointer">
                        <div class="flex items-center justify-between mb-4">
                            <span class="text-on-surface-variant font-label-bold text-label-bold flex items-center gap-1">
                                Giá vốn (COGS)
                                <span class="material-symbols-outlined text-[16px] text-amber-500">info</span>
                            </span>
                            <div class="w-10 h-10 rounded-full bg-amber-50 flex items-center justify-center text-amber-600">
                                <span class="material-symbols-outlined">inventory</span>
                            </div>
                        </div>
                        <div class="font-price-tag text-price-tag text-amber-700">
                            <fmt:formatNumber value="${totalCost}" type="number" groupingUsed="true"/> ₫
                        </div>
                        <div class="mt-2 text-xs text-on-surface-variant flex items-center gap-1.5">
                            <span class="inline-flex items-center text-xs font-bold text-amber-600">
                                <span class="material-symbols-outlined text-xs">local_shipping</span>
                                Giá vốn bình quân
                            </span>
                            <span>cho hàng xuất bán</span>
                        </div>
                    </div>

                    <!-- Khung nảy so sánh thông số khi Hover -->
                    <div class="absolute left-0 top-full mt-2 w-80 md:w-96 bg-white/95 backdrop-blur-md rounded-2xl shadow-2xl p-5 border border-slate-200 z-50 opacity-0 pointer-events-none group-hover:opacity-100 group-hover:pointer-events-auto transition-all duration-200 transform translate-y-1 group-hover:translate-y-0">
                        <div class="absolute -top-2 left-8 w-4 h-4 bg-white border-t border-l border-slate-200 transform rotate-45"></div>
                        <div class="flex items-center justify-between border-b pb-2 mb-3">
                            <span class="font-bold text-slate-800 text-sm flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-amber-600 text-base">receipt</span> Chi tiết giá vốn
                            </span>
                        </div>
                        <div class="space-y-2.5 text-xs text-slate-600">
                            <div class="flex justify-between items-center">
                                <span>Giá vốn hôm nay:</span>
                                <span class="font-bold text-slate-900"><fmt:formatNumber value="${kpiMetrics.costToday}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span>Giá vốn hôm qua:</span>
                                <span class="font-semibold text-slate-500"><fmt:formatNumber value="${kpiMetrics.costYesterday}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                            <div class="pt-1 border-t border-dashed">
                                <a href="${pageContext.request.contextPath}/admin/inventory" class="text-primary hover:underline font-bold flex items-center gap-1">
                                    Xem lịch sử các phiếu nhập kho &rarr;
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thẻ 3: Lợi nhuận gộp (Lãi / Lỗ) -->
                <div class="relative group">
                    <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-all duration-300 border border-transparent hover:border-emerald-500/40 cursor-pointer">
                        <div class="flex items-center justify-between mb-4">
                            <span class="text-on-surface-variant font-label-bold text-label-bold flex items-center gap-1">
                                Lợi nhuận gộp
                                <span class="material-symbols-outlined text-[16px] text-emerald-600">info</span>
                            </span>
                            <div class="w-10 h-10 rounded-full ${grossProfit >= 0 ? 'bg-emerald-50 text-emerald-600' : 'bg-red-50 text-red-600'} flex items-center justify-center">
                                <span class="material-symbols-outlined">trending_up</span>
                            </div>
                        </div>
                        <div class="font-price-tag text-price-tag ${grossProfit >= 0 ? 'text-emerald-700' : 'text-red-600'}">
                            <fmt:formatNumber value="${grossProfit}" type="number" groupingUsed="true"/> ₫
                        </div>
                        <div class="mt-2 text-xs text-on-surface-variant flex items-center gap-1.5">
                            <span class="inline-flex items-center text-xs font-bold ${grossProfit >= 0 ? 'text-emerald-600' : 'text-red-600'}">
                                ${kpiMetrics.profitMargin}%
                            </span>
                            <span>biên lợi nhuận (Margin)</span>
                        </div>
                    </div>

                    <!-- Khung nảy so sánh thông số khi Hover -->
                    <div class="absolute left-0 top-full mt-2 w-80 md:w-96 bg-white/95 backdrop-blur-md rounded-2xl shadow-2xl p-5 border border-slate-200 z-50 opacity-0 pointer-events-none group-hover:opacity-100 group-hover:pointer-events-auto transition-all duration-200 transform translate-y-1 group-hover:translate-y-0">
                        <div class="absolute -top-2 left-8 w-4 h-4 bg-white border-t border-l border-slate-200 transform rotate-45"></div>
                        <div class="flex items-center justify-between border-b pb-2 mb-3">
                            <span class="font-bold text-slate-800 text-sm flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-emerald-600 text-base">savings</span> Phân tích Lãi / Lỗ
                            </span>
                            <span class="px-2 py-0.5 rounded-full text-[10px] font-bold ${grossProfit >= 0 ? 'bg-emerald-100 text-emerald-800' : 'bg-red-100 text-red-700'}">
                                ${grossProfit >= 0 ? 'Có Lãi' : 'Lỗ Vốn'}
                            </span>
                        </div>
                        <div class="space-y-2.5 text-xs text-slate-600">
                            <div class="flex justify-between items-center">
                                <span>Lợi nhuận hôm nay:</span>
                                <span class="font-bold text-slate-900"><fmt:formatNumber value="${kpiMetrics.profitToday}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span>Lợi nhuận hôm qua:</span>
                                <span class="font-semibold text-slate-500"><fmt:formatNumber value="${kpiMetrics.profitYesterday}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                            <div class="flex justify-between items-center pt-1 border-t border-dashed">
                                <span>Công thức tính:</span>
                                <span class="font-medium text-slate-700">Doanh thu - Giá vốn COGS</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thẻ 4: Tổng đơn hàng -->
                <div class="relative group">
                    <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-all duration-300 border border-transparent hover:border-blue-500/40 cursor-pointer">
                        <div class="flex items-center justify-between mb-4">
                            <span class="text-on-surface-variant font-label-bold text-label-bold flex items-center gap-1">
                                Tổng đơn hàng
                                <span class="material-symbols-outlined text-[16px] text-blue-500">info</span>
                            </span>
                            <div class="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-blue-600">
                                <span class="material-symbols-outlined">shopping_cart</span>
                            </div>
                        </div>
                        <div class="font-price-tag text-price-tag text-on-surface">${totalOrders}</div>
                        <div class="mt-2 text-xs text-on-surface-variant flex items-center gap-1.5">
                            <span class="inline-flex items-center text-xs font-bold text-blue-600">
                                <span class="material-symbols-outlined text-xs">done_all</span>
                                ${kpiMetrics.completionRate}%
                            </span>
                            <span>giao thành công</span>
                        </div>
                    </div>

                    <!-- Khung nảy so sánh thông số khi Hover -->
                    <div class="absolute right-0 top-full mt-2 w-80 md:w-96 bg-white/95 backdrop-blur-md rounded-2xl shadow-2xl p-5 border border-slate-200 z-50 opacity-0 pointer-events-none group-hover:opacity-100 group-hover:pointer-events-auto transition-all duration-200 transform translate-y-1 group-hover:translate-y-0">
                        <div class="absolute -top-2 right-8 w-4 h-4 bg-white border-t border-l border-slate-200 transform rotate-45"></div>
                        <div class="flex items-center justify-between border-b pb-2 mb-3">
                            <span class="font-bold text-slate-800 text-sm flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-blue-600 text-base">bar_chart</span> Hiệu suất đơn hàng
                            </span>
                            <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-blue-100 text-blue-700">
                                ${kpiMetrics.ordersGrowthToday >= 0 ? '+' : ''}${kpiMetrics.ordersGrowthToday}%
                            </span>
                        </div>
                        <div class="space-y-2.5 text-xs text-slate-600">
                            <div class="flex justify-between items-center">
                                <span>Đơn hôm nay:</span>
                                <span class="font-bold text-slate-900">${kpiMetrics.ordersToday} đơn</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span>Đơn hôm qua:</span>
                                <span class="font-semibold text-slate-500">${kpiMetrics.ordersYesterday} đơn</span>
                            </div>
                            <div class="flex justify-between items-center pt-1 border-t border-dashed">
                                <span>Đơn chờ xử lý:</span>
                                <span class="font-bold text-amber-600">${kpiMetrics.pendingOrders} đơn</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ 1: So Sánh Doanh Thu Đa Kỳ (Kỳ này vs Kỳ trước) -->
            <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] flex flex-col mb-8 border border-surface-variant">
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                    <div>
                        <div class="flex items-center gap-3">
                            <h2 class="font-label-bold text-lg text-on-surface">Biểu đồ so sánh doanh thu các mốc thời gian</h2>
                            <span id="revenueGrowthBadge" class="px-2.5 py-0.5 rounded-full text-xs font-bold bg-green-100 text-green-700 flex items-center gap-1">
                                <span class="material-symbols-outlined text-[14px]">trending_up</span> +0%
                            </span>
                        </div>
                        <p class="text-xs text-on-surface-variant mt-1">Đối sánh trực quan giữa kỳ hiện tại (xanh lá) và kỳ trước đó (nét đứt xám)</p>
                    </div>
                    <div class="flex items-center gap-3">
                        <select id="chartFilter" class="border border-outline-variant rounded-lg px-3.5 py-2 font-body-md text-sm text-on-surface focus:border-primary outline-none bg-surface-container-lowest shadow-sm">
                            <option value="day">Theo ngày (7 ngày qua vs 7 ngày trước)</option>
                            <option value="week">Theo tuần (5 tuần qua vs 5 tuần trước)</option>
                            <option value="month" selected>Theo tháng (6 tháng qua vs 6 tháng trước)</option>
                            <option value="quarter">Theo quý (4 quý qua vs 4 quý trước)</option>
                        </select>
                    </div>
                </div>
                <div class="relative h-[380px] w-full">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>

            <!-- Hàng Biểu Đồ 2: Phân bổ Đơn hàng theo trạng thái & Cơ cấu Sản phẩm theo Danh mục -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                <!-- Biểu đồ: Tổng số đơn hàng theo trạng thái (Requirement 7) -->
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] border border-surface-variant flex flex-col justify-between">
                    <div class="flex items-center justify-between mb-4">
                        <div>
                            <h3 class="font-label-bold text-base text-on-surface font-bold">Phân bổ trạng thái đơn hàng</h3>
                            <p class="text-xs text-on-surface-variant mt-0.5">Tỷ lệ đơn thành công, đang giao và thất bại</p>
                        </div>
                        <select id="orderStatusFilter" class="border border-outline-variant rounded-lg px-2.5 py-1.5 text-xs text-on-surface focus:border-primary outline-none bg-surface-container-lowest">
                            <option value="all" selected>Toàn thời gian</option>
                            <option value="month">30 ngày qua</option>
                            <option value="week">7 ngày qua</option>
                            <option value="today">Hôm nay</option>
                        </select>
                    </div>
                    <div class="grid grid-cols-1 sm:grid-cols-2 items-center gap-4 my-2">
                        <div class="relative h-[240px] w-full flex items-center justify-center">
                            <canvas id="orderStatusChart"></canvas>
                        </div>
                        <div id="orderStatusLegend" class="space-y-2 text-xs">
                            <!-- Sẽ được render động bằng JS -->
                            <div class="p-3 bg-gray-50 rounded-xl animate-pulse text-center text-gray-400">Đang tải số liệu...</div>
                        </div>
                    </div>
                </div>

                <!-- Biểu đồ: Tổng số sản phẩm theo Danh mục + Xem Chi Tiết (Requirement 4) -->
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] border border-surface-variant flex flex-col justify-between">
                    <div class="flex items-center justify-between mb-4">
                        <div>
                            <h3 class="font-label-bold text-base text-on-surface font-bold">Cơ cấu sản phẩm theo danh mục</h3>
                            <p class="text-xs text-on-surface-variant mt-0.5">Số lượng SKU và tỷ trọng từng danh mục</p>
                        </div>
                        <div class="flex items-center gap-2">
                            <select id="categorySelectFilter" class="border border-outline-variant rounded-lg px-2.5 py-1.5 text-xs text-on-surface focus:border-primary outline-none bg-surface-container-lowest max-w-[150px] truncate">
                                <c:forEach var="cat" items="${categoryDistribution.categories}">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                            </select>
                            <button type="button" onclick="openCategoryDrilldown()" class="px-2.5 py-1.5 bg-primary text-white text-xs font-bold rounded-lg hover:bg-primary-container transition-colors shadow-sm flex items-center gap-1">
                                <span class="material-symbols-outlined text-[14px]">visibility</span> Chi tiết
                            </button>
                        </div>
                    </div>
                    <div class="relative h-[240px] w-full my-2">
                        <canvas id="categoryChart"></canvas>
                    </div>
                    <div class="pt-3 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500">
                        <span>Nhấp vào danh mục hoặc nút "Chi tiết" để xem toàn bộ danh sách sản phẩm.</span>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- MODAL XEM CHI TIẾT SẢN PHẨM THEO DANH MỤC (Requirement 4) -->
<div id="categoryDrilldownModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4 transition-all">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-4xl max-h-[90vh] flex flex-col overflow-hidden border border-slate-200 animate-in fade-in zoom-in-95 duration-200" onclick="event.stopPropagation()">
        <!-- Header -->
        <div class="bg-gradient-to-r from-primary to-primary-container px-6 py-4 flex items-center justify-between text-white flex-shrink-0">
            <div class="flex items-center gap-2.5">
                <span class="material-symbols-outlined text-2xl">category</span>
                <div>
                    <h3 id="drilldownCategoryTitle" class="font-bold text-lg leading-tight">Danh sách sản phẩm danh mục</h3>
                    <p id="drilldownCategorySubtitle" class="text-xs text-white/80">Chi tiết các mặt hàng hiện có</p>
                </div>
            </div>
            <button type="button" onclick="closeCategoryDrilldown()" class="w-8 h-8 rounded-full bg-white/20 hover:bg-white/30 flex items-center justify-center transition-colors">
                <span class="material-symbols-outlined text-sm">close</span>
            </button>
        </div>

        <!-- Body Scrollable -->
        <div class="p-6 overflow-y-auto flex-1 space-y-4">
            <div class="flex items-center justify-between">
                <span id="drilldownTotalBadge" class="px-3 py-1 bg-primary/10 text-primary font-bold text-xs rounded-full">0 sản phẩm</span>
                <input type="text" id="drilldownSearchInput" oninput="filterDrilldownProducts(this.value)" placeholder="Lọc nhanh tên sản phẩm..." class="border border-slate-300 rounded-lg px-3 py-1.5 text-xs outline-none focus:border-primary w-60">
            </div>

            <div class="border border-slate-200 rounded-xl overflow-hidden shadow-sm">
                <table class="w-full text-left border-collapse text-xs">
                    <thead class="bg-slate-50 text-slate-600 font-bold border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-4">Mã SP</th>
                        <th class="py-3 px-4">Hình ảnh</th>
                        <th class="py-3 px-4">Tên sản phẩm</th>
                        <th class="py-3 px-4">Giá bán</th>
                        <th class="py-3 px-4 text-center">Tồn kho</th>
                        <th class="py-3 px-4 text-center">Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody id="drilldownProductTbody" class="divide-y divide-slate-100">
                    <!-- Dữ liệu nạp động bằng AJAX -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Footer -->
        <div class="px-6 py-3 bg-slate-50 border-t border-slate-200 flex justify-end flex-shrink-0">
            <button type="button" onclick="closeCategoryDrilldown()" class="px-4 py-2 bg-slate-200 hover:bg-slate-300 text-slate-700 text-xs font-bold rounded-lg transition-colors">
                Đóng lại
            </button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    let revenueChart = null;
    let orderStatusChart = null;
    let categoryChart = null;
    let currentDrilldownProducts = [];

    // 1. Biểu đồ đối sánh doanh thu qua các mốc thời gian
    function loadRevenueChart(filter) {
        fetch('${pageContext.request.contextPath}/api/chart-data?filter=' + filter)
            .then(res => res.json())
            .then(data => {
                const ctx = document.getElementById('revenueChart').getContext('2d');

                // Cập nhật Badge tăng trưởng
                const growthBadge = document.getElementById('revenueGrowthBadge');
                if (growthBadge) {
                    const rate = data.growthRate !== undefined ? data.growthRate : 0;
                    if (rate >= 0) {
                        growthBadge.className = 'px-2.5 py-0.5 rounded-full text-xs font-bold bg-green-100 text-green-700 flex items-center gap-1';
                        growthBadge.innerHTML = '<span class="material-symbols-outlined text-[14px]">trending_up</span> +' + rate + '%';
                    } else {
                        growthBadge.className = 'px-2.5 py-0.5 rounded-full text-xs font-bold bg-red-100 text-red-600 flex items-center gap-1';
                        growthBadge.innerHTML = '<span class="material-symbols-outlined text-[14px]">trending_down</span> ' + rate + '%';
                    }
                }

                if (revenueChart) revenueChart.destroy();

                const gradientCurrent = ctx.createLinearGradient(0, 0, 0, 350);
                gradientCurrent.addColorStop(0, 'rgba(129, 196, 8, 0.35)');
                gradientCurrent.addColorStop(1, 'rgba(129, 196, 8, 0.02)');

                revenueChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: data.labels,
                        datasets: [
                            {
                                label: 'Doanh thu (VNĐ)',
                                data: data.currentData || data.data,
                                borderColor: '#81c408',
                                backgroundColor: gradientCurrent,
                                borderWidth: 3,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#81c408',
                                pointBorderWidth: 2,
                                pointRadius: 5,
                                fill: true,
                                tension: 0.35
                            },
                            {
                                label: 'Giá vốn COGS (VNĐ)',
                                data: data.costData || [],
                                borderColor: '#f97316',
                                backgroundColor: 'transparent',
                                borderWidth: 2.5,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#f97316',
                                pointBorderWidth: 2,
                                pointRadius: 4,
                                fill: false,
                                tension: 0.35
                            },
                            {
                                label: 'Lợi nhuận gộp Lãi/Lỗ (VNĐ)',
                                data: data.profitData || [],
                                borderColor: '#059669',
                                backgroundColor: 'transparent',
                                borderWidth: 2.5,
                                borderDash: [4, 4],
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#059669',
                                pointBorderWidth: 2,
                                pointRadius: 4,
                                fill: false,
                                tension: 0.35
                            },
                            {
                                label: 'Doanh thu kỳ trước (Đối sánh)',
                                data: data.previousData,
                                borderColor: '#94a3b8',
                                backgroundColor: 'transparent',
                                borderWidth: 1.5,
                                borderDash: [6, 6],
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#94a3b8',
                                pointBorderWidth: 1.5,
                                pointRadius: 3,
                                fill: false,
                                tension: 0.35
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        interaction: { mode: 'index', intersect: false },
                        plugins: {
                            legend: {
                                position: 'top',
                                labels: { font: { family: 'Plus Jakarta Sans', weight: '600' }, usePointStyle: true }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return context.dataset.label + ': ' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: val => new Intl.NumberFormat('vi-VN', { notation: 'compact', compactDisplay: 'short' }).format(val) + ' ₫'
                                }
                            }
                        }
                    }
                });
            })
            .catch(err => console.error('Lỗi khi vẽ biểu đồ doanh thu:', err));
    }

    // 2. Biểu đồ trạng thái đơn hàng (Requirement 7)
    function loadOrderStatusChart(filter) {
        fetch('${pageContext.request.contextPath}/api/order-status-data?filter=' + filter)
            .then(res => res.json())
            .then(data => {
                const ctx = document.getElementById('orderStatusChart').getContext('2d');
                if (orderStatusChart) orderStatusChart.destroy();

                const colors = ['#22c55e', '#3b82f6', '#f59e0b', '#ef4444'];
                const hoverColors = ['#16a34a', '#2563eb', '#d97706', '#dc2626'];

                orderStatusChart = new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: data.labels,
                        datasets: [{
                            data: data.counts,
                            backgroundColor: colors,
                            hoverBackgroundColor: hoverColors,
                            borderWidth: 2,
                            borderColor: '#ffffff'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '70%',
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                callbacks: {
                                    label: function(ctx) {
                                        const count = ctx.parsed;
                                        const amount = data.amounts ? data.amounts[ctx.dataIndex] : 0;
                                        return ctx.label + ': ' + count + ' đơn (' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount) + ')';
                                    }
                                }
                            }
                        }
                    }
                });

                // Render custom legend bên cạnh
                const legendContainer = document.getElementById('orderStatusLegend');
                if (legendContainer && data.labels) {
                    let html = '';
                    const total = data.totalOrders || 1;
                    data.labels.forEach((label, idx) => {
                        const count = data.counts[idx];
                        const pct = Math.round((count / total) * 100) || 0;
                        html += '<div class="flex items-center justify-between p-2 rounded-lg bg-slate-50 border border-slate-100 hover:bg-slate-100/80 transition-colors">' +
                            '<div class="flex items-center gap-2">' +
                            '<span class="w-2.5 h-2.5 rounded-full flex-shrink-0" style="background-color:' + colors[idx] + '"></span>' +
                            '<span class="font-medium text-slate-700 truncate max-w-[100px] sm:max-w-[130px]">' + label + '</span>' +
                            '</div>' +
                            '<div class="text-right flex items-center gap-2">' +
                            '<span class="font-bold text-slate-900">' + count + '</span>' +
                            '<span class="text-[11px] text-slate-400 font-semibold">' + pct + '%</span>' +
                            '</div>' +
                            '</div>';
                    });
                    legendContainer.innerHTML = html;
                }
            })
            .catch(err => console.error('Lỗi khi vẽ biểu đồ trạng thái đơn hàng:', err));
    }

    // 3. Biểu đồ cơ cấu sản phẩm theo danh mục (Requirement 4)
    function loadCategoryChart() {
        fetch('${pageContext.request.contextPath}/api/category-distribution')
            .then(res => res.json())
            .then(data => {
                const ctx = document.getElementById('categoryChart').getContext('2d');
                if (categoryChart) categoryChart.destroy();

                categoryChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.labels,
                        datasets: [
                            {
                                label: 'Còn hàng',
                                data: data.inStockCounts,
                                backgroundColor: '#84cc16',
                                borderRadius: 6
                            },
                            {
                                label: 'Hết hàng',
                                data: data.outOfStockCounts,
                                backgroundColor: '#f87171',
                                borderRadius: 6
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'top', labels: { usePointStyle: true, font: { size: 11 } } }
                        },
                        scales: {
                            x: { stacked: true },
                            y: { stacked: true, beginAtZero: true, ticks: { stepSize: 5 } }
                        },
                        onClick: (event, elements) => {
                            if (elements.length > 0) {
                                const index = elements[0].index;
                                if (data.categories && data.categories[index]) {
                                    document.getElementById('categorySelectFilter').value = data.categories[index].id;
                                    openCategoryDrilldown();
                                }
                            }
                        }
                    }
                });
            })
            .catch(err => console.error('Lỗi khi vẽ biểu đồ danh mục:', err));
    }

    // 4. Modal Drilldown danh mục sản phẩm (Requirement 4)
    function openCategoryDrilldown() {
        const select = document.getElementById('categorySelectFilter');
        const catId = select.value;
        const catName = select.options[select.selectedIndex].text;

        document.getElementById('drilldownCategoryTitle').innerText = 'Danh mục: ' + catName;
        document.getElementById('drilldownProductTbody').innerHTML = '<tr><td colspan="6" class="py-8 text-center text-slate-400">Đang tải sản phẩm...</td></tr>';
        document.getElementById('categoryDrilldownModal').classList.remove('hidden');

        fetch('${pageContext.request.contextPath}/api/category-products?categoryId=' + catId)
            .then(res => res.json())
            .then(products => {
                currentDrilldownProducts = products;
                renderDrilldownTable(products);
            })
            .catch(err => {
                console.error(err);
                document.getElementById('drilldownProductTbody').innerHTML = '<tr><td colspan="6" class="py-8 text-center text-red-500">Lỗi khi tải dữ liệu</td></tr>';
            });
    }

    function renderDrilldownTable(products) {
        document.getElementById('drilldownTotalBadge').innerText = products.length + ' sản phẩm';
        const tbody = document.getElementById('drilldownProductTbody');

        if (!products || products.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" class="py-8 text-center text-slate-400">Không có sản phẩm nào trong danh mục này</td></tr>';
            return;
        }

        let html = '';
        products.forEach(p => {
            const formattedPrice = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p.price);
            const imgHtml = p.imageUrl ? '<img src="' + p.imageUrl + '" class="w-9 h-9 object-cover rounded-lg border">' : '<span class="material-symbols-outlined text-gray-300">image</span>';
            const stockBadge = p.stock > 5 ? '<span class="px-2 py-0.5 bg-green-100 text-green-700 rounded-full font-bold">' + p.stock + '</span>' : (p.stock > 0 ? '<span class="px-2 py-0.5 bg-amber-100 text-amber-700 rounded-full font-bold">' + p.stock + ' (Sắp hết)</span>' : '<span class="px-2 py-0.5 bg-red-100 text-red-600 rounded-full font-bold">Hết hàng</span>');
            const statusBadge = p.status ? '<span class="text-green-600 font-bold">Đang bán</span>' : '<span class="text-slate-400">Ẩn</span>';

            html += '<tr class="hover:bg-slate-50 transition-colors">' +
                '<td class="py-2.5 px-4 font-mono text-slate-500">#PRD-' + p.id + '</td>' +
                '<td class="py-2.5 px-4">' + imgHtml + '</td>' +
                '<td class="py-2.5 px-4 font-bold text-slate-800">' + p.name + '</td>' +
                '<td class="py-2.5 px-4 font-bold text-primary">' + formattedPrice + '</td>' +
                '<td class="py-2.5 px-4 text-center">' + stockBadge + '</td>' +
                '<td class="py-2.5 px-4 text-center">' + statusBadge + '</td>' +
                '</tr>';
        });
        tbody.innerHTML = html;
    }

    function filterDrilldownProducts(keyword) {
        if (!keyword) {
            renderDrilldownTable(currentDrilldownProducts);
            return;
        }
        const kw = keyword.toLowerCase();
        const filtered = currentDrilldownProducts.filter(p => p.name.toLowerCase().includes(kw) || String(p.id).includes(kw));
        renderDrilldownTable(filtered);
    }

    function closeCategoryDrilldown() {
        document.getElementById('categoryDrilldownModal').classList.add('hidden');
    }

    document.addEventListener('DOMContentLoaded', function() {
        loadRevenueChart('month');
        loadOrderStatusChart('all');
        loadCategoryChart();

        document.getElementById('chartFilter').addEventListener('change', function() {
            loadRevenueChart(this.value);
        });

        document.getElementById('orderStatusFilter').addEventListener('change', function() {
            loadOrderStatusChart(this.value);
        });
    });
</script>
</body>
</html>