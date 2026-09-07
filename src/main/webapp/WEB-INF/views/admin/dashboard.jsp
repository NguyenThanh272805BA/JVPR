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
<c:set var="currentURI" value="${requestScope['javax.servlet.forward.request_uri']}" />
<aside class="w-64 bg-surface-container-lowest border-r border-surface-variant flex flex-col h-full flex-shrink-0 z-20 shadow-sm hidden md:flex">
    <div class="h-20 flex items-center px-6 border-b border-surface-variant">
        <a class="group flex items-center gap-2.5" href="${pageContext.request.contextPath}/admin/dashboard">
            <div class="w-8 h-8 rounded-xl bg-gradient-to-br from-[#84cc16] via-[#65a30d] to-[#4d7c0f] flex items-center justify-center text-white shadow-sm flex-shrink-0 group-hover:scale-105 transition-transform">
                <svg class="w-4 h-4 text-white" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2C12 2 12.5 5 10 7C7.5 9 6 12 6 15C6 18.3137 8.68629 21 12 21C15.3137 21 18 18.3137 18 15C18 12 16.5 9 14 7C11.5 5 12 2 12 2Z" fill="currentColor"/>
                    <path d="M12 2C12 2 13.2 4.2 15.5 4.2C17.5 4.2 18.5 2.8 18.5 2.8C18.5 2.8 18 5.2 16 5.8C14 6.4 12.5 5.2 12 2Z" fill="#fef08a"/>
                </svg>
            </div>
            <div class="flex flex-col">
                <span class="text-base font-black tracking-tight leading-none text-slate-900">Fruit<span class="text-primary">ables</span></span>
                <span class="text-[8px] font-bold text-primary tracking-wider uppercase mt-0.5">Admin Portal</span>
            </div>
        </a>
    </div>
    <nav class="flex-1 overflow-y-auto py-6 px-4 space-y-2">
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/dashboard') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="material-symbols-outlined">dashboard</span>
            <span class="font-label-bold">Tổng quan</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/products') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/products">
            <span class="material-symbols-outlined">inventory_2</span>
            <span class="font-label-bold">Sản phẩm</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/categories') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/categories">
            <span class="material-symbols-outlined">category</span>
            <span class="font-label-bold">Danh mục</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/orders') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/orders">
            <span class="material-symbols-outlined">receipt_long</span>
            <span class="font-label-bold">Đơn hàng</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/coupons') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/coupons">
            <span class="material-symbols-outlined">redeem</span>
            <span class="font-label-bold">Mã khuyến mãi</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/chat') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/chat">
            <span class="material-symbols-outlined">support_agent</span>
            <span class="font-label-bold">Live Chat CSKH</span>
        </a>
    </nav>
</aside>

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
        <div class="flex items-center gap-6">
            <div class="flex items-center gap-3">
                <div class="flex flex-col text-right">
                    <span class="font-label-bold text-label-bold text-on-surface">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
                    <span class="text-sm text-on-surface-variant">Quản trị viên</span>
                </div>
                <span class="material-symbols-outlined text-4xl text-primary" style="font-variation-settings: 'FILL' 1;">account_circle</span>
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
            <div>
                <h1 class="font-headline-md text-headline-md text-on-surface">Tổng quan hệ thống</h1>
            </div>

            <!-- Stats Row: Format tiền tệ VNĐ liền mạch -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-gutter">
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-transform duration-300">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-on-surface-variant font-label-bold text-label-bold">Tổng doanh thu</span>
                        <div class="w-10 h-10 rounded-full bg-primary-container/20 flex items-center justify-center text-primary-container">
                            <span class="material-symbols-outlined">payments</span>
                        </div>
                    </div>
                    <div class="font-price-tag text-price-tag text-primary">
                        <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> ₫
                    </div>
                </div>
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-transform duration-300">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-on-surface-variant font-label-bold text-label-bold">Tổng đơn hàng</span>
                        <div class="w-10 h-10 rounded-full bg-primary-container/20 flex items-center justify-center text-primary-container">
                            <span class="material-symbols-outlined">shopping_cart</span>
                        </div>
                    </div>
                    <div class="font-price-tag text-price-tag text-on-surface">${totalOrders}</div>
                </div>
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-transform duration-300">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-on-surface-variant font-label-bold text-label-bold">Tổng sản phẩm</span>
                        <div class="w-10 h-10 rounded-full bg-primary-container/20 flex items-center justify-center text-primary-container">
                            <span class="material-symbols-outlined">inventory_2</span>
                        </div>
                    </div>
                    <div class="font-price-tag text-price-tag text-on-surface">${totalProducts}</div>
                </div>
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-transform duration-300">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-on-surface-variant font-label-bold text-label-bold">Cảnh báo tồn kho</span>
                        <div class="w-10 h-10 rounded-full bg-error-container text-error flex items-center justify-center">
                            <span class="material-symbols-outlined">warning</span>
                        </div>
                    </div>
                    <div class="font-price-tag text-price-tag text-error">${outOfStock}</div>
                </div>
            </div>

            <!-- Chart Section -->
            <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] flex flex-col mb-8">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="font-label-bold text-label-bold text-on-surface">Biểu đồ doanh thu</h2>
                    <select id="chartFilter" class="border border-outline-variant rounded-md px-3 py-1 font-body-md text-on-surface focus:border-primary outline-none">
                        <option value="day">Theo ngày (7 ngày qua)</option>
                        <option value="week">Theo tuần (5 tuần qua)</option>
                        <option value="month" selected>Theo tháng (6 tháng qua)</option>
                        <option value="quarter">Theo quý (4 quý qua)</option>
                    </select>
                </div>
                <div class="relative h-[400px] w-full">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>

            <!-- Cảnh báo tồn kho: Sản phẩm sắp hết hàng (Mới bổ sung) -->
            <div class="bg-surface-container-lowest rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] overflow-hidden mb-8 border border-amber-200/70">
                <div class="p-6 border-b border-surface-variant flex justify-between items-center bg-amber-50/50">
                    <div class="flex items-center gap-2.5">
                        <span class="w-8 h-8 rounded-lg bg-amber-500/20 text-amber-700 flex items-center justify-center">
                            <span class="material-symbols-outlined text-xl">warning</span>
                        </span>
                        <div>
                            <h2 class="font-label-bold text-base text-on-surface font-bold">Cảnh báo: Sản phẩm sắp hết hàng (Tồn kho &le; 5)</h2>
                            <p class="text-xs text-on-surface-variant">Danh sách các sản phẩm cần nhập thêm hàng gấp để không gián đoạn kinh doanh</p>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/products" class="text-primary hover:text-primary-container text-xs font-label-bold flex items-center gap-1 transition-colors">
                        Quản lý toàn bộ kho <span class="material-symbols-outlined text-[16px]">arrow_forward</span>
                    </a>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                        <tr class="bg-surface-container text-on-surface-variant font-label-bold text-xs uppercase tracking-wider">
                            <th class="py-3.5 px-6">Mã SP</th>
                            <th class="py-3.5 px-6">Sản phẩm</th>
                            <th class="py-3.5 px-6">Danh mục</th>
                            <th class="py-3.5 px-6">Giá bán</th>
                            <th class="py-3.5 px-6">Tồn kho hiện tại</th>
                            <th class="py-3.5 px-6 text-right">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-surface-variant text-sm text-on-surface">
                        <c:choose>
                            <c:when test="${not empty lowStockProducts}">
                                <c:forEach var="p" items="${lowStockProducts}">
                                    <tr class="hover:bg-amber-50/40 transition-colors">
                                        <td class="py-3.5 px-6 font-mono text-xs text-on-surface-variant">#PRD-${p.id}</td>
                                        <td class="py-3.5 px-6">
                                            <div class="flex items-center gap-3">
                                                <div class="w-10 h-10 rounded-lg bg-surface-container border border-outline-variant overflow-hidden flex-shrink-0">
                                                    <c:choose>
                                                        <c:when test="${not empty p.imageUrl}">
                                                            <img src="${p.imageUrl}" alt="${p.name}" class="w-full h-full object-cover">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="w-full h-full flex items-center justify-center text-outline">
                                                                <span class="material-symbols-outlined text-sm">image</span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <span class="font-medium text-on-surface line-clamp-1">${p.name}</span>
                                            </div>
                                        </td>
                                        <td class="py-3.5 px-6 text-on-surface-variant text-xs">${not empty p.categoryName ? p.categoryName : 'Chưa phân loại'}</td>
                                        <td class="py-3.5 px-6 font-semibold">
                                            <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td class="py-3.5 px-6">
                                            <c:choose>
                                                <c:when test="${p.stock <= 0}">
                                                    <span class="px-2.5 py-1 bg-red-100 text-red-700 font-bold rounded-full text-xs border border-red-200 inline-flex items-center gap-1 animate-pulse">
                                                        <span class="w-1.5 h-1.5 rounded-full bg-red-600"></span> Hết hàng (0)
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-2.5 py-1 bg-amber-100 text-amber-800 font-bold rounded-full text-xs border border-amber-200 inline-flex items-center gap-1">
                                                        <span class="w-1.5 h-1.5 rounded-full bg-amber-600"></span> Còn ${p.stock} sản phẩm
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="py-3.5 px-6 text-right">
                                            <a href="${pageContext.request.contextPath}/admin/products" class="inline-flex items-center gap-1 px-3 py-1.5 bg-primary/10 hover:bg-primary text-primary hover:text-white rounded-lg text-xs font-bold transition-all shadow-sm">
                                                <span class="material-symbols-outlined text-[16px]">edit_square</span> Nhập thêm
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="py-8 text-center text-on-surface-variant text-sm">
                                        <div class="flex flex-col items-center justify-center gap-1">
                                            <span class="material-symbols-outlined text-emerald-500 text-3xl">check_circle</span>
                                            <span class="font-medium text-emerald-700">Tuyệt vời! Hiện tại không có sản phẩm nào có lượng tồn kho dưới mức cảnh báo.</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Recent Products (Khối đã được giữ lại trọn vẹn) -->
            <div class="bg-surface-container-lowest rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] overflow-hidden">
                <div class="p-6 border-b border-surface-variant flex justify-between items-center">
                    <h2 class="font-label-bold text-label-bold text-on-surface">Sản phẩm mới thêm</h2>
                    <a href="${pageContext.request.contextPath}/admin/products" class="text-primary-container hover:text-primary font-label-bold text-label-bold transition-colors">Xem tất cả</a>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                        <tr class="bg-surface-container text-on-surface-variant font-label-bold text-label-bold text-sm">
                            <th class="py-4 px-6 font-medium">Mã SP</th>
                            <th class="py-4 px-6 font-medium">Hình ảnh</th>
                            <th class="py-4 px-6 font-medium">Tên sản phẩm</th>
                            <th class="py-4 px-6 font-medium">Danh mục</th>
                            <th class="py-4 px-6 font-medium">Giá bán</th>
                            <th class="py-4 px-6 font-medium">Tồn kho</th>
                            <th class="py-4 px-6 font-medium">Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-surface-variant text-body-md text-on-surface">
                        <tr class="hover:bg-surface-bright transition-colors">
                            <td class="py-4 px-6">#PRD-001</td>
                            <td class="py-4 px-6">
                                <div class="w-12 h-12 bg-surface-variant rounded-md flex items-center justify-center text-outline">
                                    <span class="material-symbols-outlined text-sm">image</span>
                                </div>
                            </td>
                            <td class="py-4 px-6 font-medium">Chuối hữu cơ nhập khẩu</td>
                            <td class="py-4 px-6 text-on-surface-variant">Trái cây</td>
                            <td class="py-4 px-6">45,000 ₫</td>
                            <td class="py-4 px-6">120</td>
                            <td class="py-4 px-6">
                                <span class="px-3 py-1 bg-primary-container/20 text-primary-container rounded-full text-xs font-semibold">Đang bán</span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    let revenueChart = null;

    function loadChartData(filter) {
        fetch('${pageContext.request.contextPath}/api/chart-data?filter=' + filter)
            .then(response => response.json())
            .then(chartData => {
                const ctx = document.getElementById('revenueChart').getContext('2d');

                if (revenueChart) {
                    revenueChart.destroy();
                }

                revenueChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: chartData.labels,
                        datasets: [{
                            label: 'Doanh thu (VNĐ)',
                            data: chartData.data,
                            borderColor: '#81c408',
                            backgroundColor: 'rgba(129, 196, 8, 0.2)',
                            borderWidth: 3,
                            pointBackgroundColor: '#ffffff',
                            pointBorderColor: '#81c408',
                            pointBorderWidth: 2,
                            pointRadius: 5,
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { position: 'top' } },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value) {
                                        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                                    }
                                }
                            }
                        }
                    }
                });
            })
            .catch(err => console.error('Lỗi khi vẽ biểu đồ:', err));
    }

    document.addEventListener('DOMContentLoaded', function() {
        loadChartData('month');

        document.getElementById('chartFilter').addEventListener('change', function() {
            loadChartData(this.value);
        });
    });
</script>
</body>
</html>