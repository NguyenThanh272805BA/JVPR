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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .chart-card {
            background-color: #ffffff;
            border-radius: 1rem;
            border: 1px solid #e2e8f0;
            padding: 1.25rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);
            transition: all 0.2s ease;
        }
        .chart-card:hover {
            box-shadow: 0 4px 12px 0 rgba(0, 0, 0, 0.07);
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
        <div class="flex items-center w-full max-w-md">
            <div class="relative w-full">
                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">search</span>
                <input class="w-full pl-10 pr-4 py-2 bg-surface-container rounded-md border-transparent focus:border-primary focus:ring-1 focus:ring-primary font-body-md text-body-md transition-shadow text-xs" placeholder="Tìm kiếm nhanh đơn hàng, sản phẩm..." type="text"/>
            </div>
        </div>
        <div class="flex items-center gap-4 flex-shrink-0">
            <div class="flex items-center gap-3 min-w-0">
                <div class="flex flex-col text-right min-w-0">
                    <span class="font-bold text-xs text-on-surface truncate max-w-[160px]">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
                    <span class="text-[10px] text-slate-400">Quản trị viên</span>
                </div>
                <span class="material-symbols-outlined text-4xl text-primary flex-shrink-0">account_circle</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-1 text-xs text-error hover:underline font-semibold">
                <span class="material-symbols-outlined text-base">logout</span>
                <span>Đăng xuất</span>
            </a>
        </div>
    </header>

    <!-- Main Scrollable Area -->
    <main class="flex-1 overflow-y-auto p-6 bg-[#f8fafc] space-y-6">

        <!-- TIÊU ĐỀ & CÁC NÚT THAO TÁC XUẤT -->
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
                <h1 class="text-2xl font-black text-slate-800">Tổng quan Hoạt động Kinh doanh</h1>
                <p class="text-xs text-slate-500 mt-1">Giám sát doanh thu, biên lợi nhuận, cấu trúc đơn hàng, sản phẩm bán chạy và hiệu suất shipper</p>
            </div>
            <div class="flex items-center gap-3">
                <a href="${pageContext.request.contextPath}/admin/dashboard/export-excel" class="inline-flex items-center gap-1.5 px-3.5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl font-bold text-xs shadow-sm transition-all">
                    <span class="material-symbols-outlined text-base">download</span>
                    <span>Xuất Excel</span>
                </a>
            </div>
        </div>

        <!-- THANH BỘ LỌC KHOẢNG NGÀY & PHÍM TẮT NHANH (DATE RANGE FILTER) -->
        <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm space-y-3">
            <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-primary text-xl">date_range</span>
                    <span class="font-bold text-xs text-slate-700 uppercase tracking-wider">Thời gian theo dõi:</span>
                    <span id="activeFilterBadge" class="px-2.5 py-0.5 bg-primary/10 text-primary font-bold text-xs rounded-full">
                        Tháng này (Toàn diện)
                    </span>
                </div>

                <!-- Form chọn từ ngày - đến ngày -->
                <div class="flex flex-wrap items-center gap-2.5 text-xs">
                    <div class="flex items-center gap-1.5 bg-slate-50 px-2.5 py-1.5 rounded-xl border border-slate-200">
                        <span class="text-slate-400 font-semibold text-[11px]">Từ:</span>
                        <input type="date" id="dashboardStartDate" class="bg-transparent text-xs text-slate-700 outline-none border-none p-0 focus:ring-0">
                    </div>
                    <div class="flex items-center gap-1.5 bg-slate-50 px-2.5 py-1.5 rounded-xl border border-slate-200">
                        <span class="text-slate-400 font-semibold text-[11px]">Đến:</span>
                        <input type="date" id="dashboardEndDate" class="bg-transparent text-xs text-slate-700 outline-none border-none p-0 focus:ring-0">
                    </div>
                    <button type="button" onclick="applyCustomDateRange()" class="px-3.5 py-1.5 bg-primary hover:bg-primary-container text-white font-bold rounded-xl shadow-sm transition-colors flex items-center gap-1">
                        <span class="material-symbols-outlined text-sm">filter_alt</span> Áp dụng
                    </button>
                    <button type="button" onclick="resetDashboardFilter()" class="px-2.5 py-1.5 bg-slate-100 hover:bg-slate-200 text-slate-600 font-bold rounded-xl transition-colors" title="Đặt lại về mặc định">
                        <span class="material-symbols-outlined text-sm">restart_alt</span>
                    </button>
                </div>
            </div>

            <!-- Các nút phím tắt chọn nhanh -->
            <div class="flex items-center gap-2 pt-2 border-t border-slate-100 text-xs flex-wrap">
                <span class="text-slate-400 text-[11px]">Mốc nhanh:</span>
                <button type="button" onclick="selectQuickPreset('today', 'Hôm nay')" class="preset-btn px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-primary/10 hover:text-primary text-slate-600 font-medium text-[11px] transition-colors">Hôm nay</button>
                <button type="button" onclick="selectQuickPreset('7days', '7 ngày qua')" class="preset-btn px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-primary/10 hover:text-primary text-slate-600 font-medium text-[11px] transition-colors">7 ngày qua</button>
                <button type="button" onclick="selectQuickPreset('30days', '30 ngày qua')" class="preset-btn px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-primary/10 hover:text-primary text-slate-600 font-medium text-[11px] transition-colors">30 ngày qua</button>
                <button type="button" onclick="selectQuickPreset('thisMonth', 'Tháng này')" class="preset-btn px-2.5 py-1 rounded-lg bg-primary text-white font-bold text-[11px] transition-colors">Tháng này</button>
                <button type="button" onclick="selectQuickPreset('quarter', 'Quý này')" class="preset-btn px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-primary/10 hover:text-primary text-slate-600 font-medium text-[11px] transition-colors">Quý này</button>
                <button type="button" onclick="selectQuickPreset('thisYear', 'Năm nay')" class="preset-btn px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-primary/10 hover:text-primary text-slate-600 font-medium text-[11px] transition-colors">Năm nay</button>
                <button type="button" onclick="selectQuickPreset('all', 'Toàn thời gian')" class="preset-btn px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-primary/10 hover:text-primary text-slate-600 font-medium text-[11px] transition-colors">Toàn thời gian</button>
            </div>
        </div>

        <!-- 4 THẺ KPI TÀI CHÍNH & VẬN HÀNH (ĐỒNG BỘ DỮ LIỆU ĐỘNG) -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            <!-- Thẻ 1: Doanh thu thuần -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm hover:shadow-md transition-all">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Doanh thu thuần</span>
                    <div class="w-10 h-10 rounded-xl bg-lime-50 text-primary flex items-center justify-center">
                        <span class="material-symbols-outlined">payments</span>
                    </div>
                </div>
                <div id="kpiTotalRevenue" class="text-2xl font-black text-primary">
                    <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> ₫
                </div>
                <div class="mt-2 text-xs text-slate-500 flex items-center gap-1.5">
                    <span class="px-1.5 py-0.5 rounded bg-green-100 text-green-700 font-bold text-[11px]">Đã thanh toán</span>
                    <span>Đơn hoàn tất & đã trừ hủy</span>
                </div>
            </div>

            <!-- Thẻ 2: Giá vốn COGS -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm hover:shadow-md transition-all">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Giá vốn hàng bán (COGS)</span>
                    <div class="w-10 h-10 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
                        <span class="material-symbols-outlined">inventory_2</span>
                    </div>
                </div>
                <div id="kpiTotalCost" class="text-2xl font-black text-amber-600">
                    <fmt:formatNumber value="${totalCost}" type="number" groupingUsed="true"/> ₫
                </div>
                <div class="mt-2 text-xs text-slate-500">
                    Giá vốn bình quân xuất kho
                </div>
            </div>

            <!-- Thẻ 3: Lợi nhuận gộp -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm hover:shadow-md transition-all">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Lợi nhuận gộp</span>
                    <div class="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
                        <span class="material-symbols-outlined">trending_up</span>
                    </div>
                </div>
                <div id="kpiGrossProfit" class="text-2xl font-black text-emerald-600">
                    <fmt:formatNumber value="${grossProfit}" type="number" groupingUsed="true"/> ₫
                </div>
                <div class="mt-2 text-xs text-slate-500 flex items-center gap-1.5">
                    <span id="kpiProfitMargin" class="px-1.5 py-0.5 rounded bg-emerald-100 text-emerald-800 font-bold text-[11px]">${kpiMetrics.profitMargin}%</span>
                    <span>Biên lợi nhuận gộp</span>
                </div>
            </div>

            <!-- Thẻ 4: Tổng đơn hàng -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm hover:shadow-md transition-all">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Tổng đơn hàng</span>
                    <div class="w-10 h-10 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center">
                        <span class="material-symbols-outlined">shopping_cart</span>
                    </div>
                </div>
                <div id="kpiTotalOrders" class="text-2xl font-black text-slate-800">${totalOrders}</div>
                <div class="mt-2 text-xs text-slate-500 flex items-center gap-1.5">
                    <span id="kpiSuccessRate" class="px-1.5 py-0.5 rounded bg-blue-100 text-blue-700 font-bold text-[11px]">${kpiMetrics.completionRate}%</span>
                    <span>Tỷ lệ giao hàng thành công</span>
                </div>
            </div>
        </div>

        <!-- ================================================================ -->
        <!-- HỆ THỐNG 8 BIỂU ĐỒ CHUYÊN BIỆT (PHÂN LOẠI CỘT, TRÒN, NGANG)    -->
        <!-- ================================================================ -->

        <!-- HÀNG 1: BIỂU ĐỒ CỘT KÉP (DOANH THU & LỢI NHUẬN) + BIỂU ĐỒ TRÒN (CƠ CẤU THANH TOÁN) -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            <!-- Biểu đồ 1: Cột kép Doanh thu & Lợi nhuận gộp (Grouped Bar Chart) -->
            <div class="lg:col-span-8 chart-card flex flex-col justify-between">
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-4">
                    <div>
                        <h3 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary text-base">bar_chart</span>
                            Biểu đồ 1: Doanh thu thuần & Lợi nhuận gộp theo mốc thời gian
                        </h3>
                        <p class="text-[11px] text-slate-400 mt-0.5">Biểu diễn cột song song Doanh thu (Xanh lá) và Lợi nhuận (Xanh ngọc), đường viền COGS</p>
                    </div>
                    <div class="flex flex-wrap items-center gap-2">
                        <!-- Bộ lọc Từ ngày - Đến ngày riêng cho Biểu đồ 1 -->
                        <div class="flex items-center gap-1.5 bg-slate-50 px-2 py-1 rounded-lg border border-slate-200 text-xs">
                            <span class="text-[10px] text-slate-400 font-semibold">Từ:</span>
                            <input type="date" id="chart1StartDate" class="bg-transparent text-[11px] text-slate-700 outline-none border-none p-0 focus:ring-0">
                        </div>
                        <div class="flex items-center gap-1.5 bg-slate-50 px-2 py-1 rounded-lg border border-slate-200 text-xs">
                            <span class="text-[10px] text-slate-400 font-semibold">Đến:</span>
                            <input type="date" id="chart1EndDate" class="bg-transparent text-[11px] text-slate-700 outline-none border-none p-0 focus:ring-0">
                        </div>
                        <button type="button" onclick="queryChart1DateRange()" class="px-2.5 py-1 bg-primary hover:bg-primary-container text-white text-xs font-bold rounded-lg shadow-sm transition-colors flex items-center gap-1" title="Tra cứu doanh thu theo khoảng ngày">
                            <span class="material-symbols-outlined text-[13px]">search</span> Tra cứu
                        </button>
                        <button type="button" onclick="resetChart1DateRange()" class="p-1 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-lg transition-colors" title="Đặt lại mốc thời gian">
                            <span class="material-symbols-outlined text-sm">restart_alt</span>
                        </button>

                        <select id="revenueGroupingFilter" onchange="changeRevenueGrouping(this.value)" class="border border-slate-200 rounded-lg px-2.5 py-1 text-xs text-slate-700 outline-none focus:border-primary bg-slate-50">
                            <option value="day">Theo ngày</option>
                            <option value="week">Theo tuần</option>
                            <option value="month" selected>Theo tháng</option>
                            <option value="quarter">Theo quý</option>
                        </select>
                    </div>
                </div>
                <div class="relative h-[320px] w-full">
                    <canvas id="revenueBarChart"></canvas>
                </div>
            </div>

            <!-- Biểu đồ 2: Cơ cấu Doanh thu theo Phương thức thanh toán (Doughnut Chart) -->
            <div class="lg:col-span-4 chart-card flex flex-col justify-between">
                <div class="mb-4">
                    <h3 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                        <span class="material-symbols-outlined text-amber-500 text-base">pie_chart</span>
                        Biểu đồ 2: Cơ cấu Phương thức Thanh toán
                    </h3>
                    <p class="text-[11px] text-slate-400 mt-0.5">Tỷ trọng doanh thu theo Tiền mặt COD vs VNPay vs Ví MoMo</p>
                </div>
                <div class="relative h-[220px] w-full flex items-center justify-center">
                    <canvas id="paymentMethodChart"></canvas>
                </div>
                <div id="paymentMethodLegend" class="mt-4 space-y-1.5 text-xs">
                    <!-- Dynamic Legend JS -->
                </div>
            </div>
        </div>

        <!-- HÀNG 2: BIỂU ĐỒ TRÒN (TRẠNG THÁI ĐƠN) + BIỂU ĐỒ CỘT NGANG (TOP 5 SẢN PHẨM BÁN CHẠY) -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            <!-- Biểu đồ 3: Phân bổ Trạng thái Đơn hàng (Doughnut Chart) -->
            <div class="lg:col-span-5 chart-card flex flex-col justify-between">
                <div class="mb-4">
                    <h3 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                        <span class="material-symbols-outlined text-blue-500 text-base">donut_large</span>
                        Biểu đồ 3: Phân bổ Trạng thái Đơn hàng
                    </h3>
                    <p class="text-[11px] text-slate-400 mt-0.5">Tỷ lệ đơn thành công, đang giao, chờ xử lý và giao thất bại/hủy</p>
                </div>
                <div class="relative h-[220px] w-full flex items-center justify-center">
                    <canvas id="orderStatusChart"></canvas>
                </div>
                <div id="orderStatusLegend" class="mt-4 space-y-1.5 text-xs">
                    <!-- Dynamic Legend JS -->
                </div>
            </div>

            <!-- Biểu đồ 4: Top 5 Sản phẩm Bán chạy nhất (Horizontal Bar Chart) -->
            <div class="lg:col-span-7 chart-card flex flex-col justify-between">
                <div class="flex items-center justify-between mb-4">
                    <div>
                        <h3 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                            <span class="material-symbols-outlined text-emerald-600 text-base">local_fire_department</span>
                            Biểu đồ 4: Top 5 Sản phẩm Hoa quả Bán chạy nhất
                        </h3>
                        <p class="text-[11px] text-slate-400 mt-0.5">Xếp hạng theo sản lượng đã bán và doanh thu đóng góp</p>
                    </div>
                </div>
                <div class="relative h-[300px] w-full">
                    <canvas id="topProductsChart"></canvas>
                </div>
            </div>
        </div>

        <!-- HÀNG 3: BIỂU ĐỒ CỘT CHỒNG (DANH MỤC & TỒN KHO) + BIỂU ĐỒ DIỆN TÍCH (XU HƯỚNG ĐƠN HÀNG) -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            <!-- Biểu đồ 5: Cơ cấu Danh mục Sản phẩm (Doughnut / Pie Chart) -->
            <div class="lg:col-span-6 chart-card flex flex-col justify-between">
                <div class="flex items-center justify-between mb-4">
                    <div>
                        <h3 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                            <span class="material-symbols-outlined text-purple-600 text-base">pie_chart</span>
                            Biểu đồ 5: Cơ cấu Danh mục Sản phẩm
                        </h3>
                        <p class="text-[11px] text-slate-400 mt-0.5">Mỗi màu biểu thị 1 danh mục hoa quả (Nhấp lát cắt để xem chi tiết)</p>
                    </div>
                    <div class="flex items-center gap-2">
                        <select id="categorySelectFilter" class="border border-slate-200 rounded-lg px-2 py-1 text-xs text-slate-700 outline-none max-w-[130px] truncate bg-slate-50">
                            <c:forEach var="cat" items="${categoryDistribution.categories}">
                                <option value="${cat.id}">${cat.name}</option>
                            </c:forEach>
                        </select>
                        <button type="button" onclick="openCategoryDrilldown()" class="px-2.5 py-1 bg-primary text-white text-xs font-bold rounded-lg hover:bg-primary-container transition-colors flex items-center gap-1 shadow-sm">
                            <span class="material-symbols-outlined text-[13px]">visibility</span> Xem
                        </button>
                    </div>
                </div>
                <div class="grid grid-cols-1 sm:grid-cols-12 gap-3 items-center">
                    <div class="sm:col-span-7 relative h-[250px] w-full flex items-center justify-center">
                        <canvas id="categoryChart"></canvas>
                    </div>
                    <div class="sm:col-span-5 space-y-1.5 max-h-[250px] overflow-y-auto pr-1 text-xs" id="categoryDoughnutLegend">
                        <!-- Legend màu sắc từng danh mục sẽ được tạo tự động bởi JavaScript -->
                    </div>
                </div>
            </div>

            <!-- Biểu đồ 6: Xu hướng Số lượng Đơn hàng theo Thời gian (Area Spline Chart) -->
            <div class="lg:col-span-6 chart-card flex flex-col justify-between">
                <div class="mb-4">
                    <h3 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                        <span class="material-symbols-outlined text-sky-600 text-base">timeline</span>
                        Biểu đồ 6: Xu hướng Phát sinh Đơn hàng theo Thời gian
                    </h3>
                    <p class="text-[11px] text-slate-400 mt-0.5">Biểu đồ miền diện tích thể hiện nhịp độ đặt hàng và tỷ lệ giao thành công</p>
                </div>
                <div class="relative h-[280px] w-full">
                    <canvas id="orderTrendsChart"></canvas>
                </div>
            </div>
        </div>

        <!-- HÀNG 4: BIỂU ĐỒ CỘT (HIỆU SUẤT SHIPPER) + BIỂU ĐỒ TRÒN (KHUNG GIỜ GIAO HÀNG) -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            <!-- Biểu đồ 7: Hiệu suất Vận chuyển của Đội ngũ Shipper (Grouped Bar Chart) -->
            <div class="lg:col-span-7 chart-card flex flex-col justify-between">
                <div class="flex items-center justify-between mb-4">
                    <div>
                        <h3 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                            <span class="material-symbols-outlined text-indigo-600 text-base">two_wheeler</span>
                            Biểu đồ 7: Hiệu suất Giao hàng của Đội ngũ Shipper
                        </h3>
                        <p class="text-[11px] text-slate-400 mt-0.5">Đối sánh đơn hoàn thành thành công vs Đơn giao thất bại của từng tài xế</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/delivery-failures" class="text-xs text-primary hover:underline font-bold flex items-center gap-1">
                        Chi tiết giao hàng &rarr;
                    </a>
                </div>
                <div class="relative h-[280px] w-full">
                    <canvas id="shipperPerformanceChart"></canvas>
                </div>
            </div>

            <!-- Biểu đồ 8: Phân bổ Đơn hàng theo Khung giờ giao (Doughnut / Polar Chart) -->
            <div class="lg:col-span-5 chart-card flex flex-col justify-between">
                <div class="mb-4">
                    <h3 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                        <span class="material-symbols-outlined text-teal-600 text-base">schedule</span>
                        Biểu đồ 8: Tỷ trọng Khung giờ Giao hàng
                    </h3>
                    <p class="text-[11px] text-slate-400 mt-0.5">Thói quen lựa chọn thời gian nhận hàng của khách (Hỏa tốc 1-2h, Sáng, Chiều, Tối)</p>
                </div>
                <div class="relative h-[220px] w-full flex items-center justify-center">
                    <canvas id="deliverySlotChart"></canvas>
                </div>
                <div id="deliverySlotLegend" class="mt-4 space-y-1.5 text-xs">
                    <!-- Dynamic Legend JS -->
                </div>
            </div>
        </div>

        <!-- ================================================================ -->
        <!-- HÀNG 5: THỐNG KÊ KHÁCH HÀNG, ĐĂNG KÝ & TƯƠNG TÁC SỬ DỤNG WEB   -->
        <!-- ================================================================ -->
        <div class="mt-8 pt-6 border-t border-slate-200/80 space-y-6">
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                <div>
                    <h2 class="text-lg font-black text-slate-800 flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary text-xl">group_add</span>
                        <span>Thống kê Khách hàng & Mức độ Sử dụng Web</span>
                    </h2>
                    <p class="text-xs text-slate-400 mt-0.5">Giám sát lượng khách hàng đăng ký mới, phương thức đăng nhập và tỷ lệ khách hàng mua sắm trên hệ thống</p>
                </div>
                <div class="flex items-center gap-2">
                    <a href="${pageContext.request.contextPath}/admin/customers" class="px-3.5 py-1.5 bg-white border border-slate-200 hover:border-primary hover:text-primary text-slate-700 text-xs font-bold rounded-xl transition-all flex items-center gap-1.5 shadow-sm">
                        <span class="material-symbols-outlined text-base text-primary">people</span>
                        <span>Chi tiết Khách hàng &rarr;</span>
                    </a>
                </div>
            </div>

            <!-- 4 Thẻ KPI Khách hàng & Sử dụng web -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                <!-- KPI 1: Tổng khách hàng -->
                <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Tổng khách hàng</span>
                        <div id="kpiCustomerTotal" class="text-2xl font-black text-slate-800 mt-0.5">
                            ${customerEngagement.totalCustomers != null ? customerEngagement.totalCustomers : 0}
                        </div>
                        <div class="text-[11px] text-emerald-600 font-semibold mt-0.5 flex items-center gap-0.5">
                            <span class="material-symbols-outlined text-xs">how_to_reg</span>
                            <span>Đang hoạt động: <strong id="kpiCustomerActive">${customerEngagement.activeCount != null ? customerEngagement.activeCount : 0}</strong></span>
                        </div>
                    </div>
                    <div class="w-11 h-11 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center flex-shrink-0">
                        <span class="material-symbols-outlined text-xl">people</span>
                    </div>
                </div>

                <!-- KPI 2: Khách hàng mua sắm -->
                <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Khách mua hàng</span>
                        <div id="kpiActiveBuyers" class="text-2xl font-black text-blue-600 mt-0.5">
                            ${customerEngagement.totalBuyers != null ? customerEngagement.totalBuyers : 0}
                        </div>
                        <div class="text-[11px] text-blue-600 font-semibold mt-0.5 flex items-center gap-0.5">
                            <span class="material-symbols-outlined text-xs">shopping_bag</span>
                            <span>Tỷ lệ mua: <strong id="kpiConversionRate">${customerEngagement.conversionRate != null ? customerEngagement.conversionRate : 0}%</strong></span>
                        </div>
                    </div>
                    <div class="w-11 h-11 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center flex-shrink-0">
                        <span class="material-symbols-outlined text-xl">shopping_cart_checkout</span>
                    </div>
                </div>

                <!-- KPI 3: Khách hàng thân thiết quay lại -->
                <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Khách mua lại (>= 2 đơn)</span>
                        <div id="kpiLoyalBuyers" class="text-2xl font-black text-purple-600 mt-0.5">
                            ${customerEngagement.loyalBuyers != null ? customerEngagement.loyalBuyers : 0}
                        </div>
                        <div class="text-[11px] text-purple-600 font-semibold mt-0.5 flex items-center gap-0.5">
                            <span class="material-symbols-outlined text-xs">sync</span>
                            <span>Tỷ lệ quay lại: <strong id="kpiRetentionRate">${customerEngagement.retentionRate != null ? customerEngagement.retentionRate : 0}%</strong></span>
                        </div>
                    </div>
                    <div class="w-11 h-11 rounded-2xl bg-purple-50 text-purple-600 flex items-center justify-center flex-shrink-0">
                        <span class="material-symbols-outlined text-xl">loyalty</span>
                    </div>
                </div>

                <!-- KPI 4: Điểm Loyalty VIP -->
                <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Điểm thưởng VIP lưu hành</span>
                        <div id="kpiTotalCustomerPoints" class="text-2xl font-black text-amber-600 mt-0.5">
                            <fmt:formatNumber value="${customerEngagement.totalPoints != null ? customerEngagement.totalPoints : 0}" type="number"/> pts
                        </div>
                        <div class="text-[11px] text-amber-700 font-semibold mt-0.5 flex items-center gap-0.5">
                            <span class="material-symbols-outlined text-xs">workspace_premium</span>
                            <span>Đăng ký Google: <strong id="kpiGoogleUsers">${customerEngagement.googleCount != null ? customerEngagement.googleCount : 0}</strong></span>
                        </div>
                    </div>
                    <div class="w-11 h-11 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center flex-shrink-0">
                        <span class="material-symbols-outlined text-xl">stars</span>
                    </div>
                </div>
            </div>

            <!-- Grid 2 Biểu đồ 9 & 10 -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                <!-- Biểu đồ 9: Tăng trưởng & Kênh đăng ký theo thời gian (Grouped Bar / Spline Chart) -->
                <div class="lg:col-span-7 chart-card flex flex-col justify-between">
                    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-4">
                        <div>
                            <h3 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                                <span class="material-symbols-outlined text-primary text-base">trending_up</span>
                                Biểu đồ 9: Tăng trưởng Khách hàng & Kênh Đăng ký mới
                            </h3>
                            <p class="text-[11px] text-slate-400 mt-0.5">So sánh lượt đăng ký qua Tài khoản thường (Xanh lá) vs Google OAuth (Xanh dương)</p>
                        </div>
                        <div class="flex items-center gap-1.5 bg-slate-50 p-1 rounded-xl border border-slate-200 text-xs">
                            <button type="button" onclick="changeCustomerGrowthFilter('day', this)" class="customer-filter-btn px-2.5 py-1 rounded-lg font-bold bg-white text-primary shadow-xs transition-all">7 ngày</button>
                            <button type="button" onclick="changeCustomerGrowthFilter('30day', this)" class="customer-filter-btn px-2.5 py-1 rounded-lg font-bold text-slate-500 hover:text-slate-800 transition-all">30 ngày</button>
                            <button type="button" onclick="changeCustomerGrowthFilter('month', this)" class="customer-filter-btn px-2.5 py-1 rounded-lg font-bold text-slate-500 hover:text-slate-800 transition-all">Theo tháng</button>
                        </div>
                    </div>
                    <div class="relative h-[300px] w-full">
                        <canvas id="customerGrowthChart"></canvas>
                    </div>
                </div>

                <!-- Biểu đồ 10: Phân khúc Khách hàng & Tương tác Mua sắm (Doughnut Chart) -->
                <div class="lg:col-span-5 chart-card flex flex-col justify-between">
                    <div class="mb-4">
                        <h3 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                            <span class="material-symbols-outlined text-purple-600 text-base">donut_large</span>
                            Biểu đồ 10: Phân khúc Khách hàng & Mức độ Sử dụng Web
                        </h3>
                        <p class="text-[11px] text-slate-400 mt-0.5">Cơ cấu khách trung thành, khách mua lần đầu, khách mới đăng ký và tài khoản tạm khóa</p>
                    </div>
                    <div class="relative h-[220px] w-full flex items-center justify-center">
                        <canvas id="customerEngagementChart"></canvas>
                    </div>
                    <div id="customerEngagementLegend" class="mt-4 space-y-1.5 text-xs">
                        <!-- Dynamic Legend JS -->
                    </div>
                </div>
            </div>
        </div>

    </main>
</div>

<!-- MODAL DRILLDOWN SẢN PHẨM THEO DANH MỤC -->
<div id="categoryDrilldownModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-4xl max-h-[90vh] flex flex-col overflow-hidden border border-slate-200 animate-in fade-in zoom-in-95 duration-200" onclick="event.stopPropagation()">
        <!-- Header -->
        <div class="bg-gradient-to-r from-primary to-primary-container px-6 py-4 flex items-center justify-between text-white flex-shrink-0">
            <div class="flex items-center gap-2.5">
                <span class="material-symbols-outlined text-2xl">category</span>
                <div>
                    <h3 id="drilldownCategoryTitle" class="font-bold text-lg leading-tight">Danh sách sản phẩm danh mục</h3>
                    <p id="drilldownCategorySubtitle" class="text-xs text-white/80">Chi tiết các mặt hàng hoa quả hiện có</p>
                </div>
            </div>
            <button type="button" onclick="closeCategoryDrilldown()" class="w-8 h-8 rounded-full bg-white/20 hover:bg-white/30 flex items-center justify-center transition-colors">
                <span class="material-symbols-outlined text-sm">close</span>
            </button>
        </div>

        <!-- Body Scrollable -->
        <div class="p-6 overflow-y-auto flex-1 space-y-4 text-xs">
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

<script>
    // Khởi tạo các biến chứa instance của 8 Chart
    let chart1_revenue = null;
    let chart2_payment = null;
    let chart3_orderStatus = null;
    let chart4_topProducts = null;
    let chart5_category = null;
    let chart6_orderTrends = null;
    let chart7_shipper = null;
    let chart8_deliverySlot = null;
    let chart9_growth = null;
    let chart10_engagement = null;

    let currentFilterType = 'month';
    let currentStartDate = '';
    let currentEndDate = '';
    let currentDrilldownProducts = [];

    const currencyFmt = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

    // HÀM TẢI TOÀN BỘ DỮ LIỆU ĐỒNG BỘ 10 BIỂU ĐỒ & CÁC THẺ KPI
    function loadAllDashboardData(startDate, endDate, filterType) {
        currentStartDate = startDate || '';
        currentEndDate = endDate || '';
        currentFilterType = filterType || currentFilterType;

        const params = new URLSearchParams();
        if (currentStartDate) params.append('startDate', currentStartDate);
        if (currentEndDate) params.append('endDate', currentEndDate);
        if (currentFilterType) params.append('filter', currentFilterType);

        fetch('${pageContext.request.contextPath}/api/dashboard-overview?' + params.toString())
            .then(res => res.json())
            .then(data => {
                // 1. Cập nhật 4 thẻ KPI kinh doanh
                updateKpiCards(data.kpiMetrics);

                // 2. Vẽ 8 biểu đồ kinh doanh & vận hành
                renderChart1_RevenueBar(data.revenueData);
                renderChart2_PaymentMethod(data.paymentData);
                renderChart3_OrderStatus(data.orderStatusData);
                renderChart4_TopProducts(data.topProductsData);
                renderChart5_Category(data.categoryData);
                renderChart6_OrderTrends(data.orderTrendsData);
                renderChart7_Shipper(data.shipperData);
                renderChart8_DeliverySlots(data.deliverySlotsData);

                // 3. Cập nhật KPI & Vẽ 2 biểu đồ khách hàng và tương tác web (Biểu đồ 9 & 10)
                updateCustomerKpiCards(data.customerEngagementData);
                renderChart9_CustomerGrowth(data.customerGrowthData);
                renderChart10_CustomerEngagement(data.customerEngagementData);
            })
            .catch(err => console.error('Lỗi khi tải dữ liệu Dashboard tổng quan:', err));
    }

    // 1. CẬP NHẬT 4 THẺ KPI
    function updateKpiCards(metrics) {
        if (!metrics) return;
        const revEl = document.getElementById('kpiTotalRevenue');
        const costEl = document.getElementById('kpiTotalCost');
        const profitEl = document.getElementById('kpiGrossProfit');
        const marginEl = document.getElementById('kpiProfitMargin');
        const ordersEl = document.getElementById('kpiTotalOrders');
        const rateEl = document.getElementById('kpiSuccessRate');

        if (revEl && metrics.totalRevenue !== undefined) revEl.innerText = currencyFmt.format(metrics.totalRevenue);
        if (costEl && metrics.totalCost !== undefined) costEl.innerText = currencyFmt.format(metrics.totalCost);
        if (profitEl && metrics.grossProfit !== undefined) profitEl.innerText = currencyFmt.format(metrics.grossProfit);
        if (marginEl && metrics.profitMargin !== undefined) marginEl.innerText = metrics.profitMargin + '%';
        if (ordersEl && metrics.totalOrders !== undefined) ordersEl.innerText = metrics.totalOrders;
        if (rateEl && metrics.completionRate !== undefined) rateEl.innerText = metrics.completionRate + '%';
    }

    // BIỂU ĐỒ 1: CỘT KÉP DOANH THU & LỢI NHUẬN GỘP (GROUPED BAR CHART)
    function renderChart1_RevenueBar(data) {
        if (!data) return;
        const ctx = document.getElementById('revenueBarChart').getContext('2d');
        if (chart1_revenue) chart1_revenue.destroy();

        chart1_revenue = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.labels,
                datasets: [
                    {
                        label: 'Doanh thu thuần',
                        data: data.currentData,
                        backgroundColor: '#84cc16',
                        borderRadius: 6,
                        barPercentage: 0.7
                    },
                    {
                        label: 'Lợi nhuận gộp',
                        data: data.profitData,
                        backgroundColor: '#10b981',
                        borderRadius: 6,
                        barPercentage: 0.7
                    },
                    {
                        label: 'Giá vốn (COGS)',
                        data: data.costData,
                        type: 'line',
                        borderColor: '#f97316',
                        borderWidth: 2,
                        pointBackgroundColor: '#ffffff',
                        pointBorderColor: '#f97316',
                        pointRadius: 4,
                        fill: false,
                        tension: 0.3
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: { mode: 'index', intersect: false },
                plugins: {
                    legend: { position: 'top', labels: { usePointStyle: true, font: { size: 11, weight: '600' } } },
                    tooltip: {
                        callbacks: {
                            label: ctx => ctx.dataset.label + ': ' + currencyFmt.format(ctx.parsed.y)
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
    }

    // BIỂU ĐỒ 2: CƠ CẤU PHƯƠNG THỨC THANH TOÁN (DOUGHNUT CHART)
    function renderChart2_PaymentMethod(data) {
        if (!data) return;
        const ctx = document.getElementById('paymentMethodChart').getContext('2d');
        if (chart2_payment) chart2_payment.destroy();

        const colors = ['#eab308', '#3b82f6', '#ec4899', '#8b5cf6'];

        chart2_payment = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: data.labels,
                datasets: [{
                    data: data.amounts,
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
                                const val = ctx.parsed;
                                const pct = data.percentages ? data.percentages[ctx.dataIndex] : 0;
                                return ctx.label + ': ' + currencyFmt.format(val) + ' (' + pct + '%)';
                            }
                        }
                    }
                }
            }
        });

        // Legend
        const legend = document.getElementById('paymentMethodLegend');
        if (legend && data.labels) {
            let html = '';
            data.labels.forEach((label, idx) => {
                const amt = data.amounts[idx];
                const pct = data.percentages ? data.percentages[idx] : 0;
                html += '<div class="flex items-center justify-between p-1.5 rounded-lg bg-slate-50 border border-slate-100 hover:bg-slate-100 transition-colors">' +
                    '<div class="flex items-center gap-2 truncate">' +
                    '<span class="w-2.5 h-2.5 rounded-full flex-shrink-0" style="background-color:' + colors[idx % colors.length] + '"></span>' +
                    '<span class="font-medium text-slate-700 truncate" title="' + label + '">' + label + '</span>' +
                    '</div>' +
                    '<div class="text-right flex items-center gap-1.5 flex-shrink-0">' +
                    '<span class="font-bold text-slate-900">' + new Intl.NumberFormat('vi-VN', { notation: 'compact' }).format(amt) + '</span>' +
                    '<span class="text-[10px] text-slate-400 font-semibold">' + pct + '%</span>' +
                    '</div>' +
                    '</div>';
            });
            legend.innerHTML = html;
        }
    }

    // BIỂU ĐỒ 3: PHÂN BỔ TRẠNG THÁI ĐƠN HÀNG (DOUGHNUT CHART)
    function renderChart3_OrderStatus(data) {
        if (!data) return;
        const ctx = document.getElementById('orderStatusChart').getContext('2d');
        if (chart3_orderStatus) chart3_orderStatus.destroy();

        const colors = ['#22c55e', '#3b82f6', '#f59e0b', '#ef4444'];

        chart3_orderStatus = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: data.labels,
                datasets: [{
                    data: data.counts,
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
                                const amt = data.amounts ? data.amounts[ctx.dataIndex] : 0;
                                return ctx.label + ': ' + count + ' đơn (' + currencyFmt.format(amt) + ')';
                            }
                        }
                    }
                }
            }
        });

        // Legend
        const legend = document.getElementById('orderStatusLegend');
        if (legend && data.labels) {
            let html = '';
            const total = data.totalOrders || 1;
            data.labels.forEach((label, idx) => {
                const count = data.counts[idx];
                const pct = Math.round((count / total) * 100);
                html += '<div class="flex items-center justify-between p-1.5 rounded-lg bg-slate-50 border border-slate-100 hover:bg-slate-100 transition-colors">' +
                    '<div class="flex items-center gap-2 truncate">' +
                    '<span class="w-2.5 h-2.5 rounded-full flex-shrink-0" style="background-color:' + colors[idx] + '"></span>' +
                    '<span class="font-medium text-slate-700 truncate">' + label + '</span>' +
                    '</div>' +
                    '<div class="text-right flex items-center gap-1.5 flex-shrink-0">' +
                    '<span class="font-bold text-slate-900">' + count + '</span>' +
                    '<span class="text-[10px] text-slate-400 font-semibold">' + pct + '%</span>' +
                    '</div>' +
                    '</div>';
            });
            legend.innerHTML = html;
        }
    }

    // BIỂU ĐỒ 4: TOP 5 SẢN PHẨM BÁN CHẠY NHẤT (HORIZONTAL BAR CHART)
    function renderChart4_TopProducts(data) {
        if (!data) return;
        const ctx = document.getElementById('topProductsChart').getContext('2d');
        if (chart4_topProducts) chart4_topProducts.destroy();

        chart4_topProducts = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.labels,
                datasets: [{
                    label: 'Số lượng bán (Kg / Hộp)',
                    data: data.quantities,
                    backgroundColor: '#10b981',
                    borderRadius: 6
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            afterLabel: function(ctx) {
                                const rev = data.revenues ? data.revenues[ctx.dataIndex] : 0;
                                return 'Doanh thu: ' + currencyFmt.format(rev);
                            }
                        }
                    }
                },
                scales: {
                    x: { beginAtZero: true }
                }
            }
        });
    }

    // BIỂU ĐỒ 5: CƠ CẤU DANH MỤC SẢN PHẨM (DOUGHNUT CHART - MỖI MÀU 1 DANH MỤC)
    function renderChart5_Category(data) {
        if (!data) return;
        const ctx = document.getElementById('categoryChart').getContext('2d');
        if (chart5_category) chart5_category.destroy();

        // Bảng màu riêng biệt hài hòa cho từng danh mục hoa quả
        const catColors = ['#10b981', '#f59e0b', '#84cc16', '#8b5cf6', '#06b6d4', '#ec4899', '#3b82f6', '#f97316', '#14b8a6', '#6366f1'];
        const counts = data.productCounts || data.inStockCounts || [];

        chart5_category = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: data.labels,
                datasets: [{
                    data: counts,
                    backgroundColor: catColors,
                    borderWidth: 2,
                    borderColor: '#ffffff',
                    hoverOffset: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '62%',
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(ctx) {
                                const count = ctx.parsed;
                                const total = counts.reduce((a, b) => a + b, 0) || 1;
                                const pct = Math.round((count / total) * 100);
                                return ctx.label + ': ' + count + ' sản phẩm (' + pct + '%)';
                            }
                        }
                    }
                },
                onClick: (event, elements) => {
                    if (elements.length > 0) {
                        const index = elements[0].index;
                        if (data.categories && data.categories[index]) {
                            selectCategorySlice(data.categories[index].id);
                        } else {
                            const sel = document.getElementById('categorySelectFilter');
                            if (sel && sel.options[index]) {
                                sel.selectedIndex = index;
                                openCategoryDrilldown();
                            }
                        }
                    }
                }
            }
        });

        // Tạo Legend danh mục chi tiết bên phải
        const legendContainer = document.getElementById('categoryDoughnutLegend');
        if (legendContainer && data.labels) {
            let html = '';
            const total = counts.reduce((a, b) => a + b, 0) || 1;
            data.labels.forEach((name, idx) => {
                const count = counts[idx] || 0;
                const pct = Math.round((count / total) * 100);
                const color = catColors[idx % catColors.length];
                const catId = (data.categories && data.categories[idx]) ? data.categories[idx].id : (idx + 1);

                html += '<div onclick="selectCategorySlice(' + catId + ')" class="flex items-center justify-between p-2 rounded-xl bg-slate-50 border border-slate-100 hover:bg-slate-100 hover:border-slate-200 cursor-pointer transition-all" title="Bấm để xem sản phẩm trong danh mục">' +
                    '<div class="flex items-center gap-2 truncate">' +
                    '<span class="w-2.5 h-2.5 rounded-full flex-shrink-0" style="background-color:' + color + '"></span>' +
                    '<span class="font-medium text-slate-700 truncate text-[11px]">' + name + '</span>' +
                    '</div>' +
                    '<div class="text-right flex items-center gap-1.5 flex-shrink-0">' +
                    '<span class="font-bold text-slate-900 text-xs">' + count + ' SKU</span>' +
                    '<span class="text-[10px] text-slate-400 font-semibold">' + pct + '%</span>' +
                    '</div>' +
                    '</div>';
            });
            legendContainer.innerHTML = html;
        }
    }

    function selectCategorySlice(catId) {
        const sel = document.getElementById('categorySelectFilter');
        if (sel) {
            sel.value = catId;
            openCategoryDrilldown();
        }
    }

    // BIỂU ĐỒ 6: XU HƯỚNG ĐƠN HÀNG (AREA SPLINE CHART)
    function renderChart6_OrderTrends(data) {
        if (!data) return;
        const ctx = document.getElementById('orderTrendsChart').getContext('2d');
        if (chart6_orderTrends) chart6_orderTrends.destroy();

        const gradient = ctx.createLinearGradient(0, 0, 0, 250);
        gradient.addColorStop(0, 'rgba(14, 165, 233, 0.35)');
        gradient.addColorStop(1, 'rgba(14, 165, 233, 0.01)');

        chart6_orderTrends = new Chart(ctx, {
            type: 'line',
            data: {
                labels: data.labels,
                datasets: [
                    {
                        label: 'Tổng đơn hàng',
                        data: data.totalOrders,
                        borderColor: '#0284c7',
                        backgroundColor: gradient,
                        fill: true,
                        tension: 0.35,
                        pointRadius: 4
                    },
                    {
                        label: 'Giao thành công',
                        data: data.successOrders,
                        borderColor: '#22c55e',
                        borderDash: [3, 3],
                        pointRadius: 3,
                        fill: false,
                        tension: 0.35
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
                    y: { beginAtZero: true, ticks: { stepSize: 2 } }
                }
            }
        });
    }

    // BIỂU ĐỒ 7: HIỆU SUẤT SHIPPER (GROUPED BAR CHART)
    function renderChart7_Shipper(data) {
        if (!data) return;
        const ctx = document.getElementById('shipperPerformanceChart').getContext('2d');
        if (chart7_shipper) chart7_shipper.destroy();

        chart7_shipper = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.labels,
                datasets: [
                    {
                        label: 'Giao thành công',
                        data: data.deliveredCounts,
                        backgroundColor: '#22c55e',
                        borderRadius: 6
                    },
                    {
                        label: 'Giao thất bại / Hoàn',
                        data: data.failedCounts,
                        backgroundColor: '#f43f5e',
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
                                const rate = data.successRates ? data.successRates[idx] : 100;
                                return 'Tỷ lệ thành công: ' + rate + '%';
                            }
                        }
                    }
                },
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    }

    // BIỂU ĐỒ 8: PHÂN BỔ KHUNG GIỜ GIAO HÀNG (DOUGHNUT / POLAR CHART)
    function renderChart8_DeliverySlots(data) {
        if (!data) return;
        const ctx = document.getElementById('deliverySlotChart').getContext('2d');
        if (chart8_deliverySlot) chart8_deliverySlot.destroy();

        const colors = ['#0d9488', '#0284c7', '#f59e0b', '#6366f1'];

        chart8_deliverySlot = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: data.labels,
                datasets: [{
                    data: data.counts,
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
                                const amt = data.amounts ? data.amounts[ctx.dataIndex] : 0;
                                return ctx.label + ': ' + count + ' đơn (' + currencyFmt.format(amt) + ')';
                            }
                        }
                    }
                }
            }
        });

        // Legend
        const legend = document.getElementById('deliverySlotLegend');
        if (legend && data.labels) {
            let html = '';
            let total = 0;
            data.counts.forEach(c => total += c);
            if (total === 0) total = 1;

            data.labels.forEach((label, idx) => {
                const count = data.counts[idx];
                const pct = Math.round((count / total) * 100);
                html += '<div class="flex items-center justify-between p-1.5 rounded-lg bg-slate-50 border border-slate-100 hover:bg-slate-100 transition-colors">' +
                    '<div class="flex items-center gap-2 truncate">' +
                    '<span class="w-2.5 h-2.5 rounded-full flex-shrink-0" style="background-color:' + colors[idx % colors.length] + '"></span>' +
                    '<span class="font-medium text-slate-700 truncate" title="' + label + '">' + label + '</span>' +
                    '</div>' +
                    '<div class="text-right flex items-center gap-1.5 flex-shrink-0">' +
                    '<span class="font-bold text-slate-900">' + count + '</span>' +
                    '<span class="text-[10px] text-slate-400 font-semibold">' + pct + '%</span>' +
                    '</div>' +
                    '</div>';
            });
            legend.innerHTML = html;
        }
    }

    // =========================================================================
    // XỬ LÝ BỘ LỌC THỜI GIAN & PHÍM TẮT NHANH (DATE PRESETS)
    // =========================================================================
    function selectQuickPreset(preset, label) {
        // Highlight active preset button
        document.querySelectorAll('.preset-btn').forEach(btn => {
            btn.className = 'preset-btn px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-primary/10 hover:text-primary text-slate-600 font-medium text-[11px] transition-colors';
        });
        if (event && event.target) {
            event.target.className = 'preset-btn px-2.5 py-1 rounded-lg bg-primary text-white font-bold text-[11px] transition-colors';
        }

        document.getElementById('activeFilterBadge').innerText = label;

        const today = new Date();
        const formatDate = (d) => {
            const y = d.getFullYear();
            const m = String(d.getMonth() + 1).padStart(2, '0');
            const day = String(d.getDate()).padStart(2, '0');
            return y + '-' + m + '-' + day;
        };

        const startInput = document.getElementById('dashboardStartDate');
        const endInput = document.getElementById('dashboardEndDate');

        let sDate = '';
        let eDate = formatDate(today);

        if (preset === 'today') {
            sDate = eDate;
            currentFilterType = 'day';
        } else if (preset === '7days') {
            const d = new Date();
            d.setDate(d.getDate() - 7);
            sDate = formatDate(d);
            currentFilterType = 'day';
        } else if (preset === '30days') {
            const d = new Date();
            d.setDate(d.getDate() - 30);
            sDate = formatDate(d);
            currentFilterType = 'week';
        } else if (preset === 'thisMonth') {
            const d = new Date(today.getFullYear(), today.getMonth(), 1);
            sDate = formatDate(d);
            currentFilterType = 'month';
        } else if (preset === 'quarter') {
            const currentQuarter = Math.floor(today.getMonth() / 3);
            const d = new Date(today.getFullYear(), currentQuarter * 3, 1);
            sDate = formatDate(d);
            currentFilterType = 'quarter';
        } else if (preset === 'thisYear') {
            const d = new Date(today.getFullYear(), 0, 1);
            sDate = formatDate(d);
            currentFilterType = 'month';
        } else if (preset === 'all') {
            sDate = '';
            eDate = '';
            currentFilterType = 'month';
        }

        startInput.value = sDate;
        endInput.value = eDate;

        loadAllDashboardData(sDate, eDate, currentFilterType);
    }

    function applyCustomDateRange() {
        const s = document.getElementById('dashboardStartDate').value;
        const e = document.getElementById('dashboardEndDate').value;

        if (s && e && s > e) {
            alert('Ngày bắt đầu không được lớn hơn ngày kết thúc!');
            return;
        }

        document.getElementById('activeFilterBadge').innerText = (s && e) ? (s + ' đến ' + e) : 'Tùy chỉnh';
        loadAllDashboardData(s, e, 'day');
    }

    function resetDashboardFilter() {
        document.getElementById('dashboardStartDate').value = '';
        document.getElementById('dashboardEndDate').value = '';
        selectQuickPreset('thisMonth', 'Tháng này (Mặc định)');
    }

    function changeRevenueGrouping(val) {
        currentFilterType = val;
        loadAllDashboardData(currentStartDate, currentEndDate, currentFilterType);
    }

    // =========================================================================
    // XỬ LÝ TRUY VẤN TỪ NGÀY - ĐẾN NGÀY RIÊNG BIỆT CHO BIỂU ĐỒ 1
    // =========================================================================
    function queryChart1DateRange() {
        const s = document.getElementById('chart1StartDate').value;
        const e = document.getElementById('chart1EndDate').value;

        if (!s && !e) {
            alert('Vui lòng chọn ngày bắt đầu hoặc ngày kết thúc để tra cứu Doanh thu!');
            return;
        }
        if (s && e && s > e) {
            alert('Ngày bắt đầu không được lớn hơn ngày kết thúc!');
            return;
        }

        const url = '${pageContext.request.contextPath}/api/chart-data?startDate=' + encodeURIComponent(s) + '&endDate=' + encodeURIComponent(e) + '&filter=day';

        fetch(url)
            .then(res => res.json())
            .then(data => {
                if (data) {
                    renderChart1_Revenue(data);
                }
            })
            .catch(err => {
                console.error('Lỗi khi tra cứu Biểu đồ 1:', err);
                alert('Có lỗi xảy ra khi truy vấn dữ liệu Doanh thu!');
            });
    }

    function resetChart1DateRange() {
        document.getElementById('chart1StartDate').value = '';
        document.getElementById('chart1EndDate').value = '';
        document.getElementById('revenueGroupingFilter').value = 'month';
        changeRevenueGrouping('month');
    }

    // =========================================================================
    // MODAL DRILLDOWN DANH MỤC SẢN PHẨM
    // =========================================================================
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
            const formattedPrice = currencyFmt.format(p.price);
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

    // =========================================================================
    // THỐNG KÊ KHÁCH HÀNG & MỨC ĐỘ SỬ DỤNG WEB (BIỂU ĐỒ 9 & 10)
    // =========================================================================
    function updateCustomerKpiCards(metrics) {
        if (!metrics) return;
        const totEl = document.getElementById('kpiCustomerTotal');
        const actEl = document.getElementById('kpiCustomerActive');
        const buyEl = document.getElementById('kpiActiveBuyers');
        const convEl = document.getElementById('kpiConversionRate');
        const loyEl = document.getElementById('kpiLoyalBuyers');
        const retEl = document.getElementById('kpiRetentionRate');
        const ptsEl = document.getElementById('kpiTotalCustomerPoints');
        const ggEl = document.getElementById('kpiGoogleUsers');

        if (totEl && metrics.totalCustomers !== undefined) totEl.innerText = metrics.totalCustomers;
        if (actEl && metrics.activeCount !== undefined) actEl.innerText = metrics.activeCount;
        if (buyEl && metrics.totalBuyers !== undefined) buyEl.innerText = metrics.totalBuyers;
        if (convEl && metrics.conversionRate !== undefined) convEl.innerText = metrics.conversionRate + '%';
        if (loyEl && metrics.loyalBuyers !== undefined) loyEl.innerText = metrics.loyalBuyers;
        if (retEl && metrics.retentionRate !== undefined) retEl.innerText = metrics.retentionRate + '%';
        if (ptsEl && metrics.totalPoints !== undefined) ptsEl.innerText = new Intl.NumberFormat('vi-VN').format(metrics.totalPoints) + ' pts';
        if (ggEl && metrics.googleCount !== undefined) ggEl.innerText = metrics.googleCount;
    }

    // BIỂU ĐỒ 9: TĂNG TRƯỞNG & ĐĂNG KÝ KHÁCH HÀNG (MULTI-BAR / COMBO CHART)
    function renderChart9_CustomerGrowth(data) {
        if (!data) return;
        const canvas = document.getElementById('customerGrowthChart');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');
        if (chart9_growth) chart9_growth.destroy();

        chart9_growth = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.labels,
                datasets: [
                    {
                        label: 'Tài khoản thường (Local)',
                        data: data.localData,
                        backgroundColor: '#84cc16',
                        borderRadius: 6,
                        barPercentage: 0.6
                    },
                    {
                        label: 'Google OAuth',
                        data: data.googleData,
                        backgroundColor: '#3b82f6',
                        borderRadius: 6,
                        barPercentage: 0.6
                    },
                    {
                        label: 'Tổng đăng ký mới',
                        data: data.totalData,
                        type: 'line',
                        borderColor: '#f59e0b',
                        backgroundColor: 'rgba(245, 158, 11, 0.1)',
                        borderWidth: 2,
                        tension: 0.3,
                        fill: false,
                        pointRadius: 4,
                        pointBackgroundColor: '#f59e0b'
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: { mode: 'index', intersect: false },
                plugins: {
                    legend: { position: 'top', labels: { font: { size: 11, weight: 'bold' } } },
                    tooltip: {
                        callbacks: {
                            label: function(c) {
                                return ' ' + c.dataset.label + ': ' + c.raw + ' người dùng';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { precision: 0, font: { size: 10 } },
                        grid: { color: '#f1f5f9' }
                    },
                    x: {
                        ticks: { font: { size: 10 } },
                        grid: { display: false }
                    }
                }
            }
        });
    }

    // BIỂU ĐỒ 10: PHÂN KHÚC KHÁCH HÀNG & MỨC ĐỘ SỬ DỤNG WEB (DOUGHNUT CHART)
    function renderChart10_CustomerEngagement(data) {
        if (!data) return;
        const canvas = document.getElementById('customerEngagementChart');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');
        if (chart10_engagement) chart10_engagement.destroy();

        const loyal = data.loyalBuyers || 0;
        const firstTime = data.firstTimeBuyers || 0;
        const prospects = data.prospectsNoOrder || 0;
        const locked = data.lockedCount || 0;
        const total = (loyal + firstTime + prospects + locked) || 1;

        const segmentData = [loyal, firstTime, prospects, locked];
        const segmentLabels = ['Khách trung thành (>= 2 đơn)', 'Khách mua lần đầu (1 đơn)', 'Chưa phát sinh đơn hàng', 'Tài khoản tạm khóa'];
        const segmentColors = ['#10b981', '#3b82f6', '#f59e0b', '#ef4444'];

        chart10_engagement = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: segmentLabels,
                datasets: [{
                    data: segmentData,
                    backgroundColor: segmentColors,
                    borderWidth: 2,
                    borderColor: '#ffffff',
                    hoverOffset: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '65%',
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(c) {
                                const val = c.raw || 0;
                                const pct = Math.round((val / total * 100) * 10) / 10;
                                return ' ' + c.label + ': ' + val + ' khách (' + pct + '%)';
                            }
                        }
                    }
                }
            }
        });

        // Dynamic Legend
        const legendEl = document.getElementById('customerEngagementLegend');
        if (legendEl) {
            let html = '';
            segmentLabels.forEach((label, idx) => {
                const count = segmentData[idx];
                const pct = Math.round((count / total * 100) * 10) / 10;
                html += '<div class="flex items-center justify-between py-1 border-b border-slate-100 last:border-0">' +
                    '<div class="flex items-center gap-2">' +
                        '<span class="w-3 h-3 rounded-full flex-shrink-0" style="background-color: ' + segmentColors[idx] + '"></span>' +
                        '<span class="text-slate-600 font-medium">' + label + '</span>' +
                    '</div>' +
                    '<div class="flex items-center gap-2">' +
                        '<span class="font-bold text-slate-800">' + count + '</span>' +
                        '<span class="text-[10px] text-slate-400 bg-slate-100 px-1.5 py-0.2 rounded">' + pct + '%</span>' +
                    '</div>' +
                '</div>';
            });
            legendEl.innerHTML = html;
        }
    }

    // ĐỔI BỘ LỌC THỜI GIAN BIỂU ĐỒ 9 (TĂNG TRƯỞNG KHÁCH HÀNG)
    function changeCustomerGrowthFilter(val, btn) {
        if (btn) {
            document.querySelectorAll('.customer-filter-btn').forEach(b => {
                b.classList.remove('bg-white', 'text-primary', 'shadow-xs');
                b.classList.add('text-slate-500');
            });
            btn.classList.add('bg-white', 'text-primary', 'shadow-xs');
            btn.classList.remove('text-slate-500');
        }

        const params = new URLSearchParams();
        params.append('filter', val);
        if (currentStartDate) params.append('startDate', currentStartDate);
        if (currentEndDate) params.append('endDate', currentEndDate);

        fetch('${pageContext.request.contextPath}/api/customer-growth?' + params.toString())
            .then(res => res.json())
            .then(data => {
                renderChart9_CustomerGrowth(data);
            })
            .catch(err => console.error('Lỗi khi tải biểu đồ tăng trưởng khách hàng:', err));
    }

    // TẢI BAN ĐẦU KHI VÀO TRANG
    document.addEventListener('DOMContentLoaded', function() {
        loadAllDashboardData('', '', 'month');
    });
</script>

</body>
</html>