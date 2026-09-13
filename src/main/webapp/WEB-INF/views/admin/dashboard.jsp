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
                <svg class="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-outline"><use href="#icon-search"/></svg>
                <input class="w-full pl-10 pr-4 py-2 bg-surface-container rounded-md border-transparent focus:border-primary focus:ring-1 focus:ring-primary font-body-md text-body-md transition-shadow text-xs" placeholder="Tìm kiếm nhanh đơn hàng, sản phẩm..." type="text"/>
            </div>
        </div>
        <div class="flex items-center gap-4 flex-shrink-0">
            <div class="flex items-center gap-3 min-w-0">
                <div class="flex flex-col text-right min-w-0">
                    <span class="font-bold text-xs text-on-surface truncate max-w-[160px]">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
                    <span class="text-[10px] text-slate-400">Quản trị viên</span>
                </div>
                <div class="w-9 h-9 rounded-full bg-primary/10 text-primary flex items-center justify-center font-bold flex-shrink-0">
                    <svg class="w-5 h-5"><use href="#icon-customer"/></svg>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-1 text-xs text-error hover:underline font-semibold" title="Đăng xuất">
                <svg class="w-4 h-4"><use href="#icon-logout"/></svg>
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
                    <svg class="w-4 h-4 text-white"><use href="#icon-receipt"/></svg>
                    <span>Xuất Excel</span>
                </a>
            </div>
        </div>

        <!-- THANH BỘ LỌC KHOẢNG NGÀY & PHÍM TẮT NHANH (DATE RANGE FILTER) -->
        <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm space-y-3">
            <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                <div class="flex items-center gap-2">
                    <svg class="w-5 h-5 text-primary"><use href="#icon-calendar"/></svg>
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
                        <svg class="w-3.5 h-3.5"><use href="#icon-filter"/></svg> Áp dụng
                    </button>
                    <button type="button" onclick="resetDashboardFilter()" class="px-2.5 py-1.5 bg-slate-100 hover:bg-slate-200 text-slate-600 font-bold rounded-xl transition-colors" title="Đặt lại về mặc định">
                        <svg class="w-3.5 h-3.5"><use href="#icon-refresh"/></svg>
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
                        <svg class="w-5 h-5"><use href="#icon-money"/></svg>
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
                        <svg class="w-5 h-5"><use href="#icon-inventory"/></svg>
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
                        <svg class="w-5 h-5"><use href="#icon-trend-up"/></svg>
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
                        <svg class="w-5 h-5"><use href="#icon-cart"/></svg>
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
        <!-- FRUITABLES AI BUSINESS INTELLIGENCE ANALYST (EXECUTIVE COPILOT) -->
        <!-- ================================================================ -->
        <div class="bg-gradient-to-br from-slate-900 via-slate-800 to-indigo-950 rounded-2xl p-6 text-white shadow-xl border border-indigo-900/50 relative overflow-hidden">
            <div class="absolute -right-16 -top-16 w-64 h-64 bg-primary/20 rounded-full blur-3xl pointer-events-none"></div>
            <div class="absolute -left-16 -bottom-16 w-64 h-64 bg-indigo-500/20 rounded-full blur-3xl pointer-events-none"></div>

            <div class="relative z-10 space-y-4">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-primary to-emerald-400 p-0.5 shadow-lg shadow-primary/30 flex items-center justify-center">
                            <div class="w-full h-full bg-slate-900/90 rounded-[14px] flex items-center justify-center">
                                <svg class="w-6 h-6 text-emerald-400"><use href="#icon-ai"/></svg>
                            </div>
                        </div>
                        <div>
                            <div class="flex items-center gap-2">
                                <h2 class="text-lg font-black tracking-tight text-white flex items-center gap-2">
                                    Trợ lí AI
                                </h2>
                                <span class="px-2 py-0.5 rounded-full text-[10px] font-extrabold bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 flex items-center gap-1">
                                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span> LLM
                                </span>
                            </div>
                            <p class="text-xs text-slate-300 mt-0.5">Phân tích chuyên sâu doanh thu, biên lợi nhuận, cơ cấu đơn hàng & đề xuất chiến lược phát triển theo thời gian thực</p>
                        </div>
                    </div>

                    <div class="flex items-center gap-2.5 flex-wrap">
                        <button type="button" id="btnGenerateAIReport" onclick="requestAIExecutiveReport(false)" class="px-4 py-2 bg-gradient-to-r from-emerald-500 to-primary hover:from-emerald-600 hover:to-primary-container text-white font-bold text-xs rounded-xl shadow-lg shadow-emerald-900/40 transition-all flex items-center gap-2 active:scale-95">
                            <svg class="w-4 h-4"><use href="#icon-ai"/></svg>
                            <span>Phân tích Doanh số & Chiến lược</span>
                        </button>
                        <button type="button" onclick="requestAIExecutiveReport(true)" class="p-2 bg-slate-800/80 hover:bg-slate-700 text-slate-300 hover:text-white rounded-xl border border-slate-700 transition-colors" title="Bắt buộc làm mới báo cáo">
                            <svg class="w-4 h-4"><use href="#icon-refresh"/></svg>
                        </button>
                    </div>
                </div>

                <!-- Quick Copilot Prompt Chips -->
                <div class="flex items-center gap-2 pt-2 border-t border-slate-700/60 text-xs flex-wrap">
                    <span class="text-slate-400 text-[11px] font-medium flex items-center gap-1">
                        <svg class="w-3.5 h-3.5 text-primary"><use href="#icon-robot"/></svg> Hỏi nhanh Trợ lí AI:
                    </span>
                    <button type="button" onclick="askAICopilot('Đánh giá cơ cấu lợi nhuận gộp và cảnh báo các khoản chi phí giá vốn hiện nay')" class="px-3 py-1 rounded-xl bg-slate-800/80 hover:bg-slate-700 text-slate-200 text-[11px] font-medium border border-slate-700/80 hover:border-emerald-500/50 transition-all">
                        💰 Phân tích biên lợi nhuận & Giá vốn
                    </button>
                    <button type="button" onclick="askAICopilot('Kiểm tra các mặt hàng hoa quả sắp hết kho hoặc ứ đọng và đề xuất kế hoạch nhập xuất hàng')" class="px-3 py-1 rounded-xl bg-slate-800/80 hover:bg-slate-700 text-slate-200 text-[11px] font-medium border border-slate-700/80 hover:border-emerald-500/50 transition-all">
                        ⚠️ Cảnh báo tồn kho hoa quả
                    </button>
                    <button type="button" onclick="askAICopilot('Đề xuất chương trình Flash Sale hoặc gói combo trái cây cuối tuần để tăng doanh thu 20%')" class="px-3 py-1 rounded-xl bg-slate-800/80 hover:bg-slate-700 text-slate-200 text-[11px] font-medium border border-slate-700/80 hover:border-emerald-500/50 transition-all">
                        🚀 Chiến dịch kích cầu cuối tuần
                    </button>
                    <button type="button" onclick="askAICopilot('Đánh giá tỷ lệ giao hàng thành công và cách tối ưu điều phối shipper nội bộ')" class="px-3 py-1 rounded-xl bg-slate-800/80 hover:bg-slate-700 text-slate-200 text-[11px] font-medium border border-slate-700/80 hover:border-emerald-500/50 transition-all">
                        🛵 Tối ưu hiệu suất Shipper
                    </button>
                </div>

                <!-- Custom Admin Query Input -->
                <div class="flex items-center gap-2 pt-1">
                    <div class="relative flex-1">
                        <input type="text" id="adminAICustomQuery" placeholder="Nhập câu hỏi phân tích kinh doanh cụ thể cho Trợ lí AI (VD: Tại sao tỷ lệ hủy đơn cao, nên nhập thêm loại nho nào?...)"
                               class="w-full bg-slate-950/60 border border-slate-700/80 rounded-xl px-4 py-2.5 text-xs text-white placeholder-slate-400 focus:outline-none focus:border-emerald-500 transition-colors"
                               onkeydown="if(event.key==='Enter') submitCustomAIQuery()">
                    </div>
                    <button type="button" onclick="submitCustomAIQuery()" class="px-4 py-2.5 bg-slate-800 hover:bg-slate-700 text-emerald-400 font-bold text-xs rounded-xl border border-slate-700 flex items-center gap-1.5 transition-colors">
                        <svg class="w-3.5 h-3.5"><use href="#icon-send"/></svg> Gửi
                    </button>
                </div>

                <!-- AI Analysis Result Panel -->
                <div id="aiReportCard" class="hidden bg-slate-950/70 rounded-xl p-5 border border-indigo-900/60 space-y-3 transition-all">
                    <div class="flex items-center justify-between pb-2 border-b border-slate-800">
                        <div class="flex items-center gap-2 text-xs">
                            <span class="font-bold text-emerald-400 flex items-center gap-1.5">
                                <svg class="w-4 h-4"><use href="#icon-chart-bar"/></svg>
                                Báo cáo Phân tích Chiến lược Điều hành
                            </span>
                            <span id="aiReportUpdatedTime" class="text-[10px] text-slate-400"></span>
                        </div>
                        <div class="flex items-center gap-2">
                            <button type="button" onclick="copyAIReport()" class="text-slate-400 hover:text-white p-1 rounded-lg hover:bg-slate-800 transition-colors" title="Sao chép báo cáo">
                                <svg class="w-4 h-4"><use href="#icon-receipt"/></svg>
                            </button>
                            <button type="button" onclick="document.getElementById('aiReportCard').classList.add('hidden')" class="text-slate-400 hover:text-white p-1 rounded-lg hover:bg-slate-800 transition-colors" title="Thu gọn">
                                <svg class="w-4 h-4"><use href="#icon-close"/></svg>
                            </button>
                        </div>
                    </div>

                    <!-- Content Area -->
                    <div id="aiReportContent" class="text-xs text-slate-200 leading-relaxed space-y-2 max-h-96 overflow-y-auto pr-2">
                        <!-- Rendered AI Markdown -->
                    </div>
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
                            <svg class="w-4 h-4 text-primary"><use href="#icon-chart-bar"/></svg>
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
                            <svg class="w-3.5 h-3.5"><use href="#icon-search"/></svg> Tra cứu
                        </button>
                        <button type="button" onclick="resetChart1DateRange()" class="p-1 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-lg transition-colors" title="Đặt lại mốc thời gian">
                            <svg class="w-3.5 h-3.5"><use href="#icon-refresh"/></svg>
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
                        <svg class="w-4 h-4 text-amber-500"><use href="#icon-category"/></svg>
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
                        <svg class="w-4 h-4 text-blue-500"><use href="#icon-category"/></svg>
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
                            <svg class="w-4 h-4 text-emerald-600"><use href="#icon-trend-up"/></svg>
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
                            <svg class="w-4 h-4 text-purple-600"><use href="#icon-category"/></svg>
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
                            <svg class="w-3.5 h-3.5"><use href="#icon-eye"/></svg> Xem
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
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-4">
                    <div>
                        <h3 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                            <svg class="w-4 h-4 text-sky-600"><use href="#icon-trend-up"/></svg>
                            Biểu đồ 6: Xu hướng Phát sinh Đơn hàng theo Thời gian
                        </h3>
                        <p class="text-[11px] text-slate-400 mt-0.5">Biểu đồ miền diện tích thể hiện nhịp độ đặt hàng và tỷ lệ giao thành công</p>
                    </div>
                    <div class="flex flex-wrap items-center gap-2">
                        <!-- Bộ lọc Từ ngày - Đến ngày riêng cho Biểu đồ 6 -->
                        <div class="flex items-center gap-1.5 bg-slate-50 px-2 py-1 rounded-lg border border-slate-200 text-xs">
                            <span class="text-[10px] text-slate-400 font-semibold">Từ:</span>
                            <input type="date" id="chart6StartDate" class="bg-transparent text-[11px] text-slate-700 outline-none border-none p-0 focus:ring-0">
                        </div>
                        <div class="flex items-center gap-1.5 bg-slate-50 px-2 py-1 rounded-lg border border-slate-200 text-xs">
                            <span class="text-[10px] text-slate-400 font-semibold">Đến:</span>
                            <input type="date" id="chart6EndDate" class="bg-transparent text-[11px] text-slate-700 outline-none border-none p-0 focus:ring-0">
                        </div>
                        <button type="button" onclick="queryChart6DateRange()" class="px-2.5 py-1 bg-primary hover:bg-primary-container text-white text-xs font-bold rounded-lg shadow-sm transition-colors flex items-center gap-1" title="Tra cứu xu hướng đơn hàng theo khoảng ngày">
                            <svg class="w-3.5 h-3.5"><use href="#icon-search"/></svg> Tra cứu
                        </button>
                        <button type="button" onclick="resetChart6DateRange()" class="p-1 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-lg transition-colors" title="Đặt lại mốc thời gian">
                            <svg class="w-3.5 h-3.5"><use href="#icon-refresh"/></svg>
                        </button>

                        <select id="orderTrendsGroupingFilter" onchange="changeOrderTrendsGrouping(this.value)" class="border border-slate-200 rounded-lg px-2.5 py-1 text-xs text-slate-700 outline-none focus:border-primary bg-slate-50">
                            <option value="day" selected>Theo ngày</option>
                            <option value="week">Theo tuần</option>
                            <option value="month">Theo tháng</option>
                            <option value="quarter">Theo quý</option>
                        </select>
                    </div>
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
                            <svg class="w-4 h-4 text-indigo-600"><use href="#icon-shipper"/></svg>
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
                        <svg class="w-4 h-4 text-teal-600"><use href="#icon-calendar"/></svg>
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
                        <svg class="w-5 h-5 text-primary"><use href="#icon-customer"/></svg>
                        <span>Thống kê Khách hàng & Mức độ Sử dụng Web</span>
                    </h2>
                    <p class="text-xs text-slate-400 mt-0.5">Giám sát lượng khách hàng đăng ký mới, phương thức đăng nhập và tỷ lệ khách hàng mua sắm trên hệ thống</p>
                </div>
                <div class="flex items-center gap-2">
                    <a href="${pageContext.request.contextPath}/admin/customers" class="px-3.5 py-1.5 bg-white border border-slate-200 hover:border-primary hover:text-primary text-slate-700 text-xs font-bold rounded-xl transition-all flex items-center gap-1.5 shadow-sm">
                        <svg class="w-4 h-4 text-primary"><use href="#icon-customer"/></svg>
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
                            <svg class="w-3 h-3 text-emerald-600"><use href="#icon-check"/></svg>
                            <span>Đang hoạt động: <strong id="kpiCustomerActive">${customerEngagement.activeCount != null ? customerEngagement.activeCount : 0}</strong></span>
                        </div>
                    </div>
                    <div class="w-11 h-11 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center flex-shrink-0">
                        <svg class="w-5 h-5"><use href="#icon-customer"/></svg>
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
                            <svg class="w-3 h-3 text-blue-600"><use href="#icon-cart"/></svg>
                            <span>Tỷ lệ mua: <strong id="kpiConversionRate">${customerEngagement.conversionRate != null ? customerEngagement.conversionRate : 0}%</strong></span>
                        </div>
                    </div>
                    <div class="w-11 h-11 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center flex-shrink-0">
                        <svg class="w-5 h-5"><use href="#icon-order"/></svg>
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
                            <svg class="w-3 h-3 text-purple-600"><use href="#icon-refresh"/></svg>
                            <span>Tỷ lệ quay lại: <strong id="kpiRetentionRate">${customerEngagement.retentionRate != null ? customerEngagement.retentionRate : 0}%</strong></span>
                        </div>
                    </div>
                    <div class="w-11 h-11 rounded-2xl bg-purple-50 text-purple-600 flex items-center justify-center flex-shrink-0">
                        <svg class="w-5 h-5"><use href="#icon-coupon"/></svg>
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
                            <svg class="w-3 h-3 text-amber-600"><use href="#icon-claim"/></svg>
                            <span>Đăng ký Google: <strong id="kpiGoogleUsers">${customerEngagement.googleCount != null ? customerEngagement.googleCount : 0}</strong></span>
                        </div>
                    </div>
                    <div class="w-11 h-11 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center flex-shrink-0">
                        <svg class="w-5 h-5"><use href="#icon-ai"/></svg>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ 9: Phân khúc Khách hàng & Mức độ Sử dụng Web (Doughnut Chart) -->
            <div class="chart-card">
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-6 pb-4 border-b border-slate-100">
                    <div>
                        <h3 class="font-bold text-slate-800 text-sm sm:text-base flex items-center gap-2">
                            <svg class="w-5 h-5 text-purple-600"><use href="#icon-category"/></svg>
                            <span>Biểu đồ 9: Phân khúc Khách hàng & Mức độ Sử dụng Web</span>
                        </h3>
                        <p class="text-xs text-slate-400 mt-0.5">Cơ cấu khách trung thành (≥ 2 đơn), khách mua lần đầu, khách tiềm năng và tài khoản tạm khóa</p>
                    </div>
                    <span class="text-xs font-semibold text-purple-700 bg-purple-50 border border-purple-100 px-3 py-1 rounded-full flex items-center gap-1.5 w-fit">
                        <span class="w-2 h-2 rounded-full bg-purple-500 animate-pulse"></span> Phân tích tương tác mua sắm
                    </span>
                </div>
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
                    <div class="lg:col-span-5 relative h-[260px] w-full flex items-center justify-center">
                        <canvas id="customerEngagementChart"></canvas>
                    </div>
                    <div class="lg:col-span-7">
                        <div id="customerEngagementLegend" class="space-y-2.5 text-xs">
                            <!-- Dynamic Legend JS -->
                        </div>
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
                <svg class="w-6 h-6 text-white"><use href="#icon-category"/></svg>
                <div>
                    <h3 id="drilldownCategoryTitle" class="font-bold text-lg leading-tight">Danh sách sản phẩm danh mục</h3>
                    <p id="drilldownCategorySubtitle" class="text-xs text-white/80">Chi tiết các mặt hàng hoa quả hiện có</p>
                </div>
            </div>
            <button type="button" onclick="closeCategoryDrilldown()" class="w-8 h-8 rounded-full bg-white/20 hover:bg-white/30 flex items-center justify-center transition-colors">
                <svg class="w-4 h-4 text-white"><use href="#icon-close"/></svg>
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
    let chart9_engagement = null;

    let currentFilterType = 'month';
    let currentStartDate = '';
    let currentEndDate = '';
    let currentDrilldownProducts = [];

    const currencyFmt = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

    // HÀM TẢI TOÀN BỘ DỮ LIỆU ĐỒNG BỘ 9 BIỂU ĐỒ & CÁC THẺ KPI
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

                // 3. Cập nhật KPI & Vẽ biểu đồ phân khúc khách hàng (Biểu đồ 9)
                updateCustomerKpiCards(data.customerEngagementData);
                renderChart9_CustomerEngagement(data.customerEngagementData);
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
                    renderChart1_RevenueBar(data);
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
    // XỬ LÝ TRUY VẤN TỪ NGÀY - ĐẾN NGÀY & PHÂN NHÓM RIÊNG BIỆT CHO BIỂU ĐỒ 6
    // =========================================================================
    function queryChart6DateRange() {
        const s = document.getElementById('chart6StartDate').value;
        const e = document.getElementById('chart6EndDate').value;
        const grouping = document.getElementById('orderTrendsGroupingFilter').value || 'day';

        if (!s && !e) {
            alert('Vui lòng chọn ngày bắt đầu hoặc ngày kết thúc để tra cứu Xu hướng đơn hàng!');
            return;
        }
        if (s && e && s > e) {
            alert('Ngày bắt đầu không được lớn hơn ngày kết thúc!');
            return;
        }

        const params = new URLSearchParams();
        if (s) params.append('startDate', s);
        if (e) params.append('endDate', e);
        params.append('filter', grouping);

        fetch('${pageContext.request.contextPath}/api/order-trends?' + params.toString())
            .then(res => res.json())
            .then(data => {
                if (data) {
                    renderChart6_OrderTrends(data);
                }
            })
            .catch(err => {
                console.error('Lỗi khi tra cứu Biểu đồ 6:', err);
                alert('Có lỗi xảy ra khi truy vấn dữ liệu Xu hướng đơn hàng!');
            });
    }

    function changeOrderTrendsGrouping(val) {
        const s = document.getElementById('chart6StartDate').value;
        const e = document.getElementById('chart6EndDate').value;

        const params = new URLSearchParams();
        if (s) params.append('startDate', s);
        if (e) params.append('endDate', e);
        params.append('filter', val);

        fetch('${pageContext.request.contextPath}/api/order-trends?' + params.toString())
            .then(res => res.json())
            .then(data => {
                if (data) {
                    renderChart6_OrderTrends(data);
                }
            })
            .catch(err => {
                console.error('Lỗi khi đổi nhóm thời gian Biểu đồ 6:', err);
            });
    }

    function resetChart6DateRange() {
        document.getElementById('chart6StartDate').value = '';
        document.getElementById('chart6EndDate').value = '';
        document.getElementById('orderTrendsGroupingFilter').value = 'day';
        changeOrderTrendsGrouping('day');
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
            const imgHtml = p.imageUrl ? '<img src="' + p.imageUrl + '" class="w-9 h-9 object-cover rounded-lg border">' : '<svg class="w-6 h-6 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>';
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
    // THỐNG KÊ KHÁCH HÀNG & MỨC ĐỘ SỬ DỤNG WEB (BIỂU ĐỒ 9)
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

    // BIỂU ĐỒ 9: PHÂN KHÚC KHÁCH HÀNG & MỨC ĐỘ SỬ DỤNG WEB (DOUGHNUT CHART)
    function renderChart9_CustomerEngagement(data) {
        if (!data) return;
        const canvas = document.getElementById('customerEngagementChart');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');
        if (chart9_engagement) chart9_engagement.destroy();

        const loyal = data.loyalBuyers || 0;
        const firstTime = data.firstTimeBuyers || 0;
        const prospects = data.prospectsNoOrder || 0;
        const locked = data.lockedCount || 0;
        const total = (loyal + firstTime + prospects + locked) || 1;

        const segmentData = [loyal, firstTime, prospects, locked];
        const segmentLabels = ['Khách trung thành (>= 2 đơn)', 'Khách mua lần đầu (1 đơn)', 'Chưa phát sinh đơn hàng', 'Tài khoản tạm khóa'];
        const segmentColors = ['#10b981', '#3b82f6', '#f59e0b', '#ef4444'];

        chart9_engagement = new Chart(ctx, {
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
                html += '<div class="flex items-center justify-between py-2.5 px-3.5 rounded-xl bg-slate-50/80 border border-slate-100 hover:bg-slate-50 transition-colors">' +
                    '<div class="flex items-center gap-2.5">' +
                        '<span class="w-3.5 h-3.5 rounded-full flex-shrink-0 shadow-xs" style="background-color: ' + segmentColors[idx] + '"></span>' +
                        '<span class="text-slate-700 font-semibold text-xs">' + label + '</span>' +
                    '</div>' +
                    '<div class="flex items-center gap-3">' +
                        '<span class="font-black text-slate-800 text-sm">' + count + ' khách</span>' +
                        '<span class="text-xs font-bold text-slate-500 bg-white border border-slate-200 px-2 py-0.5 rounded-lg">' + pct + '%</span>' +
                    '</div>' +
                '</div>';
            });
            legendEl.innerHTML = html;
        }
    }

    // =========================================================================
    // TRỢ LÝ CỐ VẤN KINH DOANH AI (FRUITABLES BI COPILOT)
    // =========================================================================
    let rawLastAIReport = '';

    function renderMarkdownToHtml(md) {
        if (!md) return '';
        let html = md
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/^### (.*$)/gim, '<h4 class="text-emerald-400 font-bold text-sm mt-3 mb-1 flex items-center gap-1.5"><span class="w-1.5 h-1.5 bg-emerald-400 rounded-full"></span>$1</h4>')
            .replace(/^## (.*$)/gim, '<h3 class="text-white font-black text-base mt-4 mb-2 pb-1 border-b border-slate-700/60">$1</h3>')
            .replace(/^# (.*$)/gim, '<h2 class="text-emerald-300 font-black text-lg mt-4 mb-2">$1</h2>')
            .replace(/\*\*(.*?)\*\*/gim, '<strong class="text-white font-bold">$1</strong>')
            .replace(/\*(.*?)\*/gim, '<em class="text-slate-300 italic">$1</em>')
            .replace(/^\s*[-*+]\s+(.*$)/gim, '<li class="ml-4 list-disc text-slate-200 py-0.5">$1</li>')
            .replace(/^\s*(\d+)\.\s+(.*$)/gim, '<li class="ml-4 list-decimal text-slate-200 py-0.5"><span class="font-semibold text-emerald-300">$1.</span> $2</li>')
            .replace(/\n\n+/g, '<div class="h-2"></div>')
            .replace(/\n/g, '<br>');
        return html;
    }

    function requestAIExecutiveReport(forceRefresh) {
        const reportCard = document.getElementById('aiReportCard');
        const reportContent = document.getElementById('aiReportContent');
        const updatedTimeEl = document.getElementById('aiReportUpdatedTime');
        const btn = document.getElementById('btnGenerateAIReport');

        if (!reportCard || !reportContent) return;

        reportCard.classList.remove('hidden');
        reportContent.innerHTML = `
            <div class="py-8 flex flex-col items-center justify-center gap-3 text-emerald-400">
                <svg class="w-8 h-8 animate-spin"><use href="#icon-spinner"/></svg>
                <span class="text-xs font-medium text-slate-300 animate-pulse">Gemini AI đang tổng hợp các chỉ số KPI, đối soát doanh thu & lập báo cáo cố vấn...</span>
            </div>
        `;
        if (btn) btn.disabled = true;

        const url = '${pageContext.request.contextPath}/api/admin/ai-assistant?action=executive_report' + (forceRefresh ? '&refresh=true' : '');

        fetch(url, { method: 'GET' })
            .then(res => res.json())
            .then(data => {
                if (btn) btn.disabled = false;
                if (data.status === 'success' || data.success) {
                    rawLastAIReport = data.report || data.response || '';
                    reportContent.innerHTML = renderMarkdownToHtml(rawLastAIReport);
                    if (updatedTimeEl) {
                        const nowStr = new Date().toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
                        updatedTimeEl.innerText = (data.cached ? 'Bộ nhớ đệm (' : 'Mới nhất lúc (') + nowStr + ')';
                    }
                } else {
                    reportContent.innerHTML = '<div class="p-3 bg-red-950/40 border border-red-800 rounded-xl text-red-400 text-xs">⚠️ Lỗi: ' + (data.message || 'Không thể tạo báo cáo') + '</div>';
                }
            })
            .catch(err => {
                if (btn) btn.disabled = false;
                reportContent.innerHTML = '<div class="p-3 bg-red-950/40 border border-red-800 rounded-xl text-red-400 text-xs">⚠️ Không thể kết nối tới máy chủ AI: ' + err.message + '</div>';
            });
    }

    function askAICopilot(query) {
        const inputEl = document.getElementById('adminAICustomQuery');
        if (inputEl) inputEl.value = query;
        submitCustomAIQuery();
    }

    function submitCustomAIQuery() {
        const inputEl = document.getElementById('adminAICustomQuery');
        if (!inputEl) return;
        const query = inputEl.value.trim();
        if (!query) return;

        const reportCard = document.getElementById('aiReportCard');
        const reportContent = document.getElementById('aiReportContent');
        const updatedTimeEl = document.getElementById('aiReportUpdatedTime');

        if (!reportCard || !reportContent) return;
        reportCard.classList.remove('hidden');
        reportContent.innerHTML = `
            <div class="py-6 flex flex-col items-center justify-center gap-3 text-emerald-400">
                <svg class="w-8 h-8 animate-spin"><use href="#icon-spinner"/></svg>
                <div class="text-center">
                    <p class="text-xs font-bold text-white mb-1">"` + query + `" - Đang phân tích...</p>
                    <span class="text-[11px] text-slate-400">Gemini BI Copilot đang tính toán phương án và đề xuất giải pháp...</span>
                </div>
            </div>
        `;

        fetch('${pageContext.request.contextPath}/api/admin/ai-assistant', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: 'action=admin_copilot&query=' + encodeURIComponent(query)
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success' || data.success) {
                rawLastAIReport = data.response || data.report || '';
                reportContent.innerHTML = `
                    <div class="mb-3 p-2.5 rounded-lg bg-slate-900/90 border border-slate-800 text-xs flex items-start gap-2">
                        <svg class="w-4 h-4 text-emerald-400 flex-shrink-0 mt-0.5"><use href="#icon-robot"/></svg>
                        <div>
                            <span class="text-slate-400 text-[10px] uppercase font-bold tracking-wider">Câu hỏi quản trị:</span>
                            <p class="text-slate-100 font-semibold">` + query + `</p>
                        </div>
                    </div>
                ` + renderMarkdownToHtml(rawLastAIReport);
                if (updatedTimeEl) {
                    updatedTimeEl.innerText = 'Phản hồi lúc ' + new Date().toLocaleTimeString('vi-VN');
                }
            } else {
                reportContent.innerHTML = '<div class="p-3 bg-red-950/40 border border-red-800 rounded-xl text-red-400 text-xs">⚠️ Lỗi: ' + (data.message || 'Không thể xử lý câu hỏi') + '</div>';
            }
        })
        .catch(err => {
            reportContent.innerHTML = '<div class="p-3 bg-red-950/40 border border-red-800 rounded-xl text-red-400 text-xs">⚠️ Lỗi kết nối: ' + err.message + '</div>';
        });
    }

    function copyAIReport() {
        if (!rawLastAIReport) {
            alert('Chưa có nội dung báo cáo để sao chép!');
            return;
        }
        navigator.clipboard.writeText(rawLastAIReport).then(() => {
            alert('Đã sao chép nội dung báo cáo AI vào bộ nhớ tạm!');
        }).catch(() => {
            alert('Không thể sao chép tự động, vui lòng chọn văn bản thủ công.');
        });
    }

    // TẢI BAN ĐẦU KHI VÀO TRANG
    document.addEventListener('DOMContentLoaded', function() {
        loadAllDashboardData('', '', 'month');
    });
</script>

</body>
</html>