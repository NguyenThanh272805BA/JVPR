<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // Tự động nạp dữ liệu thống kê và danh mục nếu Servlet chưa nạp (phòng ngừa trường hợp Tomcat chưa reload class Servlet)
    if (request.getAttribute("stats") == null) {
        try {
            vn.edu.eaut.fruitables.service.IProductService prdSvc = new vn.edu.eaut.fruitables.service.impl.ProductServiceImpl();
            request.setAttribute("stats", prdSvc.getProductStats());
        } catch (Throwable t) {
            try (java.sql.Connection conn = vn.edu.eaut.fruitables.util.DBConnectionUtil.getConnection();
                 java.sql.PreparedStatement ps = conn.prepareStatement(
                     "SELECT COUNT(*) as total_count, " +
                     "COALESCE(SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END), 0) as active_count, " +
                     "COALESCE(SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END), 0) as inactive_count, " +
                     "COALESCE(SUM(CASE WHEN stock > 20 THEN 1 ELSE 0 END), 0) as in_stock_count, " +
                     "COALESCE(SUM(CASE WHEN stock > 0 AND stock <= 20 THEN 1 ELSE 0 END), 0) as low_stock_count, " +
                     "COALESCE(SUM(CASE WHEN stock <= 0 THEN 1 ELSE 0 END), 0) as out_of_stock_count, " +
                     "COALESCE(SUM(CASE WHEN storage_type = 'COLD_CHAIN' THEN 1 ELSE 0 END), 0) as cold_chain_count, " +
                     "COALESCE(SUM(CASE WHEN is_free_shipping = 1 THEN 1 ELSE 0 END), 0) as free_shipping_count FROM products");
                 java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    java.util.Map<String, Object> fallbackStats = new java.util.HashMap<>();
                    fallbackStats.put("totalCount", rs.getInt("total_count"));
                    fallbackStats.put("activeCount", rs.getInt("active_count"));
                    fallbackStats.put("inactiveCount", rs.getInt("inactive_count"));
                    fallbackStats.put("inStockCount", rs.getInt("in_stock_count"));
                    fallbackStats.put("lowStockCount", rs.getInt("low_stock_count"));
                    fallbackStats.put("outOfStockCount", rs.getInt("out_of_stock_count"));
                    fallbackStats.put("coldChainCount", rs.getInt("cold_chain_count"));
                    fallbackStats.put("freeShippingCount", rs.getInt("free_shipping_count"));
                    request.setAttribute("stats", fallbackStats);
                }
            } catch (Throwable ignored) {}
        }
    }
    if (request.getAttribute("categories") == null) {
        try {
            vn.edu.eaut.fruitables.service.ICategoryService catSvc = new vn.edu.eaut.fruitables.service.impl.CategoryServiceImpl();
            request.setAttribute("categories", catSvc.findAll());
        } catch (Throwable ignored) {}
    }
%>

<c:set var="totalCount" value="${stats != null && stats.totalCount != null ? stats.totalCount : fn:length(products)}"/>
<c:set var="activeCount" value="${stats != null && stats.activeCount != null ? stats.activeCount : 0}"/>
<c:set var="lowStockCount" value="${stats != null && stats.lowStockCount != null ? stats.lowStockCount : 0}"/>
<c:set var="outOfStockCount" value="${stats != null && stats.outOfStockCount != null ? stats.outOfStockCount : 0}"/>
<c:set var="coldChainCount" value="${stats != null && stats.coldChainCount != null ? stats.coldChainCount : 0}"/>
<c:set var="inactiveCount" value="${stats != null && stats.inactiveCount != null ? stats.inactiveCount : 0}"/>
<c:set var="freeShippingCount" value="${stats != null && stats.freeShippingCount != null ? stats.freeShippingCount : 0}"/>

<%-- Nếu stats bị thiếu hoặc rỗng, tự động tính từ danh sách sản phẩm --%>
<c:if test="${(empty stats || stats.totalCount == null || stats.totalCount == 0 || (activeCount == 0 && lowStockCount == 0 && outOfStockCount == 0)) && not empty products}">
    <c:set var="totalCount" value="${fn:length(products)}"/>
    <c:set var="activeCount" value="0"/>
    <c:set var="inactiveCount" value="0"/>
    <c:set var="outOfStockCount" value="0"/>
    <c:set var="lowStockCount" value="0"/>
    <c:set var="coldChainCount" value="0"/>
    <c:set var="freeShippingCount" value="0"/>
    <c:forEach var="p" items="${products}">
        <c:if test="${p.status}"><c:set var="activeCount" value="${activeCount + 1}"/></c:if>
        <c:if test="${!p.status}"><c:set var="inactiveCount" value="${inactiveCount + 1}"/></c:if>
        <c:if test="${p.stock <= 0}"><c:set var="outOfStockCount" value="${outOfStockCount + 1}"/></c:if>
        <c:if test="${p.stock > 0 && p.stock <= 20}"><c:set var="lowStockCount" value="${lowStockCount + 1}"/></c:if>
        <c:if test="${p.storageType == 'COLD_CHAIN'}"><c:set var="coldChainCount" value="${coldChainCount + 1}"/></c:if>
        <c:if test="${p.isFreeShipping}"><c:set var="freeShippingCount" value="${freeShippingCount + 1}"/></c:if>
    </c:forEach>
</c:if>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Fruitables - Quản lý Sản phẩm</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-surface font-body-md text-body-md flex h-screen overflow-hidden">

<!-- Toast Notification Container -->
<div id="toast-container" class="fixed top-5 right-5 z-50 flex flex-col gap-3 pointer-events-none"></div>

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
    </nav>
</aside>

<!-- Main Content -->
<main class="flex-1 flex flex-col h-screen overflow-hidden">

    <!-- Header -->
    <header class="h-20 bg-surface flex items-center justify-between px-margin-desktop shadow-[0px_4px_20px_rgba(0,0,0,0.05)] z-10 flex-shrink-0">
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-primary-container text-primary rounded-xl flex items-center justify-center font-bold">
                <span class="material-symbols-outlined">inventory_2</span>
            </div>
            <div>
                <h2 class="font-headline-md text-lg font-bold text-on-surface">Quản lý Kho Hàng & Sản Phẩm</h2>
                <p class="text-xs text-on-surface-variant">Lọc theo danh mục, giá bán, mức tồn kho và trạng thái mở bán</p>
            </div>
        </div>

        <div class="flex items-center gap-4">
            <span class="font-label-bold text-label-bold mr-2 text-sm">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
            <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full transition-colors flex items-center" title="Đăng xuất">
                <span class="material-symbols-outlined">logout</span>
            </a>
        </div>
    </header>

    <!-- Scrollable Content Area -->
    <div class="flex-1 overflow-y-auto p-margin-mobile md:p-margin-desktop bg-[#f8fafc] space-y-6">

        <!-- THỐNG KÊ NHANH (METRIC CARDS) -->
        <div class="grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-5 gap-4">
            <!-- Thẻ 1: Tổng sản phẩm -->
            <a href="${pageContext.request.contextPath}/admin/products" class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant shadow-xs hover:shadow-md transition-all group">
                <div class="flex items-center justify-between mb-2">
                    <span class="text-xs font-semibold text-on-surface-variant">Tổng sản phẩm</span>
                    <span class="w-8 h-8 rounded-lg bg-primary/10 text-primary flex items-center justify-center group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-[18px]">inventory_2</span>
                    </span>
                </div>
                <div class="font-headline-md text-2xl font-black text-on-surface">
                    <c:out value="${totalCount}"/>
                </div>
                <span class="text-[11px] text-primary font-medium mt-1 inline-block">Toàn bộ kho hàng</span>
            </a>

            <!-- Thẻ 2: Đang mở bán -->
            <a href="${pageContext.request.contextPath}/admin/products?status=ACTIVE" class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant shadow-xs hover:shadow-md transition-all group">
                <div class="flex items-center justify-between mb-2">
                    <span class="text-xs font-semibold text-on-surface-variant">Đang mở bán</span>
                    <span class="w-8 h-8 rounded-lg bg-emerald-100 text-emerald-600 flex items-center justify-center group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-[18px]">check_circle</span>
                    </span>
                </div>
                <div class="font-headline-md text-2xl font-black text-emerald-600">
                    <c:out value="${activeCount}"/>
                </div>
                <span class="text-[11px] text-emerald-600 font-medium mt-1 inline-block">Khách có thể mua</span>
            </a>

            <!-- Thẻ 3: Sắp hết hàng (1-20) -->
            <a href="${pageContext.request.contextPath}/admin/products?stockStatus=LOW_STOCK" class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant shadow-xs hover:shadow-md transition-all group">
                <div class="flex items-center justify-between mb-2">
                    <span class="text-xs font-semibold text-on-surface-variant">Sắp hết hàng</span>
                    <span class="w-8 h-8 rounded-lg bg-amber-100 text-amber-600 flex items-center justify-center group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-[18px]">warning</span>
                    </span>
                </div>
                <div class="font-headline-md text-2xl font-black text-amber-600">
                    <c:out value="${lowStockCount}"/>
                </div>
                <span class="text-[11px] text-amber-600 font-medium mt-1 inline-block">Tồn kho ≤ 20 cái</span>
            </a>

            <!-- Thẻ 4: Hết hàng -->
            <a href="${pageContext.request.contextPath}/admin/products?stockStatus=OUT_OF_STOCK" class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant shadow-xs hover:shadow-md transition-all group">
                <div class="flex items-center justify-between mb-2">
                    <span class="text-xs font-semibold text-on-surface-variant">Đã hết hàng</span>
                    <span class="w-8 h-8 rounded-lg bg-rose-100 text-rose-600 flex items-center justify-center group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-[18px]">remove_shopping_cart</span>
                    </span>
                </div>
                <div class="font-headline-md text-2xl font-black text-rose-600">
                    <c:out value="${outOfStockCount}"/>
                </div>
                <span class="text-[11px] text-rose-600 font-medium mt-1 inline-block">Cần nhập thêm</span>
            </a>

            <!-- Thẻ 5: Vận chuyển đặc thù -->
            <a href="${pageContext.request.contextPath}/admin/products?storageType=COLD_CHAIN" class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant shadow-xs hover:shadow-md transition-all group col-span-2 sm:col-span-2 lg:col-span-1">
                <div class="flex items-center justify-between mb-2">
                    <span class="text-xs font-semibold text-on-surface-variant">Chuỗi lạnh / Ship</span>
                    <span class="w-8 h-8 rounded-lg bg-sky-100 text-sky-600 flex items-center justify-center group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-[18px]">ac_unit</span>
                    </span>
                </div>
                <div class="font-headline-md text-2xl font-black text-sky-600">
                    <c:out value="${coldChainCount}"/>
                </div>
                <span class="text-[11px] text-sky-600 font-medium mt-1 inline-block">Ướp lạnh / Freeship</span>
            </a>
        </div>

        <!-- BỘ LỌC ĐA TIÊU CHÍ (THEO DANH MỤC, THEO GIÁ, THEO TỒN KHO, TRẠNG THÁI) -->
        <div class="bg-surface-container-lowest p-6 rounded-2xl border border-outline-variant shadow-sm space-y-4">
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 pb-3 border-b border-surface-variant">
                <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-primary text-xl">tune</span>
                    <h3 class="font-headline-md font-bold text-base text-on-surface">Bộ lọc & Phân loại sản phẩm</h3>
                    <span class="px-2.5 py-0.5 rounded-full text-xs font-bold bg-primary/10 text-primary">
                        Tìm thấy ${fn:length(products)} kết quả
                    </span>
                </div>

                <a href="${pageContext.request.contextPath}/admin/products/add" class="flex items-center gap-2 bg-primary hover:bg-[#6ba306] text-white px-5 py-2.5 rounded-full font-label-bold text-xs shadow-md transition-all hover:-translate-y-0.5 whitespace-nowrap">
                    <span class="material-symbols-outlined text-[18px]">add</span>
                    Thêm sản phẩm mới
                </a>
            </div>

            <!-- TAB LỌC NHANH TRẠNG THÁI -->
            <div class="flex items-center gap-2 overflow-x-auto pb-1 text-xs font-semibold">
                <a href="${pageContext.request.contextPath}/admin/products"
                   class="px-3.5 py-1.5 rounded-full transition-colors whitespace-nowrap ${empty param.status && empty param.stockStatus && empty param.storageType ? 'bg-primary text-white shadow-xs' : 'bg-surface-container text-on-surface-variant hover:bg-surface-container-high'}">
                    Tất cả (${totalCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/products?status=ACTIVE"
                   class="px-3.5 py-1.5 rounded-full transition-colors whitespace-nowrap ${param.status == 'ACTIVE' ? 'bg-emerald-600 text-white shadow-xs' : 'bg-surface-container text-on-surface-variant hover:bg-surface-container-high'}">
                    Đang mở bán (${activeCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/products?stockStatus=LOW_STOCK"
                   class="px-3.5 py-1.5 rounded-full transition-colors whitespace-nowrap ${param.stockStatus == 'LOW_STOCK' ? 'bg-amber-500 text-white shadow-xs' : 'bg-surface-container text-on-surface-variant hover:bg-surface-container-high'}">
                    Sắp hết hàng (${lowStockCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/products?stockStatus=OUT_OF_STOCK"
                   class="px-3.5 py-1.5 rounded-full transition-colors whitespace-nowrap ${param.stockStatus == 'OUT_OF_STOCK' ? 'bg-rose-600 text-white shadow-xs' : 'bg-surface-container text-on-surface-variant hover:bg-surface-container-high'}">
                    Đã hết hàng (${outOfStockCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/products?status=INACTIVE"
                   class="px-3.5 py-1.5 rounded-full transition-colors whitespace-nowrap ${param.status == 'INACTIVE' ? 'bg-slate-700 text-white shadow-xs' : 'bg-surface-container text-on-surface-variant hover:bg-surface-container-high'}">
                    Tạm ngưng (${inactiveCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/products?storageType=COLD_CHAIN"
                   class="px-3.5 py-1.5 rounded-full transition-colors whitespace-nowrap ${param.storageType == 'COLD_CHAIN' ? 'bg-sky-600 text-white shadow-xs' : 'bg-surface-container text-on-surface-variant hover:bg-surface-container-high'}">
                    ❄️ Chuỗi lạnh (${coldChainCount})
                </a>
                <a href="${pageContext.request.contextPath}/admin/products?storageType=FREE_SHIPPING"
                   class="px-3.5 py-1.5 rounded-full transition-colors whitespace-nowrap ${param.storageType == 'FREE_SHIPPING' ? 'bg-primary text-white shadow-xs' : 'bg-surface-container text-on-surface-variant hover:bg-surface-container-high'}">
                    ⚡ Có Freeship (${freeShippingCount})
                </a>
            </div>

            <!-- FORM BỘ LỌC CHI TIẾT -->
            <form action="${pageContext.request.contextPath}/admin/products" method="GET" class="space-y-4 pt-1">
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3">
                    <!-- 1. Tìm kiếm theo tên / Mã SP -->
                    <div class="lg:col-span-2">
                        <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">
                            Tìm kiếm sản phẩm
                        </label>
                        <div class="relative">
                            <input type="text" name="keyword" value="<c:out value='${keyword}'/>" placeholder="Tên sản phẩm, Mã #PRD-..."
                                   class="w-full pl-9 pr-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
                            <span class="material-symbols-outlined text-[16px] text-on-surface-variant absolute left-2.5 top-1/2 -translate-y-1/2">search</span>
                        </div>
                    </div>

                    <!-- 2. Lọc theo danh mục -->
                    <div>
                        <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">
                            Danh mục
                        </label>
                        <select name="categoryId" class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
                            <option value="ALL">-- Tất cả danh mục --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${selectedCategoryId == cat.id ? 'selected' : ''}>
                                    <c:out value="${cat.name}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- 3. Lọc theo mức độ tồn kho -->
                    <div>
                        <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">
                            Mức tồn kho
                        </label>
                        <select name="stockStatus" class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
                            <option value="ALL" ${selectedStockStatus == 'ALL' || empty selectedStockStatus ? 'selected' : ''}>Tất cả mức tồn kho</option>
                            <option value="IN_STOCK" ${selectedStockStatus == 'IN_STOCK' ? 'selected' : ''}>🟢 Còn hàng dồi dào (>20)</option>
                            <option value="LOW_STOCK" ${selectedStockStatus == 'LOW_STOCK' ? 'selected' : ''}>🟡 Sắp hết hàng (1-20)</option>
                            <option value="OUT_OF_STOCK" ${selectedStockStatus == 'OUT_OF_STOCK' ? 'selected' : ''}>🔴 Đã hết hàng (0)</option>
                        </select>
                    </div>

                    <!-- 4. Lọc theo trạng thái kinh doanh -->
                    <div>
                        <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">
                            Trạng thái bán
                        </label>
                        <select name="status" class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
                            <option value="ALL" ${selectedStatus == 'ALL' || empty selectedStatus ? 'selected' : ''}>Tất cả trạng thái</option>
                            <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>Đang mở bán</option>
                            <option value="INACTIVE" ${selectedStatus == 'INACTIVE' ? 'selected' : ''}>Tạm ngưng bán</option>
                        </select>
                    </div>

                    <!-- 5. Lọc theo quy cách vận chuyển -->
                    <div>
                        <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">
                            Vận chuyển & Bảo quản
                        </label>
                        <select name="storageType" class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
                            <option value="ALL" ${selectedStorageType == 'ALL' || empty selectedStorageType ? 'selected' : ''}>Tất cả quy cách</option>
                            <option value="NORMAL" ${selectedStorageType == 'NORMAL' ? 'selected' : ''}>Nhiệt độ phòng thường</option>
                            <option value="COLD_CHAIN" ${selectedStorageType == 'COLD_CHAIN' ? 'selected' : ''}>❄️ Chuỗi lạnh / Ướp đá</option>
                            <option value="FRAGILE_GIFT" ${selectedStorageType == 'FRAGILE_GIFT' ? 'selected' : ''}>🎁 Dễ vỡ / Hộp quà</option>
                            <option value="FREE_SHIPPING" ${selectedStorageType == 'FREE_SHIPPING' ? 'selected' : ''}>⚡ Có hỗ trợ Freeship</option>
                        </select>
                    </div>
                </div>

                <!-- HÀNG THỨ 2: LỌC THEO GIÁ VÀ SẮP XẾP -->
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 lg:grid-cols-12 gap-3 items-end pt-1">
                    <!-- Khoảng giá nhanh -->
                    <div class="lg:col-span-3">
                        <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">
                            Khoảng giá nhanh
                        </label>
                        <select name="priceRange" class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
                            <option value="">-- Mọi mức giá --</option>
                            <option value="under50k" ${selectedPriceRange == 'under50k' ? 'selected' : ''}>Dưới 50.000 ₫</option>
                            <option value="50k-200k" ${selectedPriceRange == '50k-200k' ? 'selected' : ''}>50.000 ₫ - 200.000 ₫</option>
                            <option value="200k-500k" ${selectedPriceRange == '200k-500k' ? 'selected' : ''}>200.000 ₫ - 500.000 ₫</option>
                            <option value="over500k" ${selectedPriceRange == 'over500k' ? 'selected' : ''}>Trên 500.000 ₫</option>
                        </select>
                    </div>

                    <!-- Giá tối thiểu tùy chỉnh -->
                    <div class="lg:col-span-2">
                        <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">
                            Giá từ (VNĐ)
                        </label>
                        <input type="number" name="minPrice" value="${minPrice}" placeholder="VD: 100000" min="0" step="10000"
                               class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
                    </div>

                    <!-- Giá tối đa tùy chỉnh -->
                    <div class="lg:col-span-2">
                        <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">
                            Đến giá (VNĐ)
                        </label>
                        <input type="number" name="maxPrice" value="${maxPrice}" placeholder="VD: 500000" min="0" step="10000"
                               class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
                    </div>

                    <!-- Sắp xếp theo -->
                    <div class="lg:col-span-3">
                        <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1">
                            Sắp xếp thứ tự
                        </label>
                        <select name="sort" class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
                            <option value="newest" ${selectedSort == 'newest' ? 'selected' : ''}>Mới nhất (Mặc định)</option>
                            <option value="oldest" ${selectedSort == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                            <option value="price_asc" ${selectedSort == 'price_asc' ? 'selected' : ''}>Giá bán: Thấp đến Cao</option>
                            <option value="price_desc" ${selectedSort == 'price_desc' ? 'selected' : ''}>Giá bán: Cao đến Thấp</option>
                            <option value="stock_asc" ${selectedSort == 'stock_asc' ? 'selected' : ''}>Tồn kho: Thấp nhất trước</option>
                            <option value="stock_desc" ${selectedSort == 'stock_desc' ? 'selected' : ''}>Tồn kho: Cao nhất trước</option>
                            <option value="name_asc" ${selectedSort == 'name_asc' ? 'selected' : ''}>Tên sản phẩm: A -> Z</option>
                        </select>
                    </div>

                    <!-- Nút bấm Lọc & Reset -->
                    <div class="lg:col-span-2 flex items-center gap-2">
                        <button type="submit" class="flex-1 py-2 px-3 bg-primary hover:bg-[#6ba306] text-white text-xs font-bold rounded-xl shadow-xs transition-all flex items-center justify-center gap-1">
                            <span class="material-symbols-outlined text-[16px]">filter_alt</span> Lọc
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/products" class="py-2 px-3 bg-surface-container hover:bg-surface-variant text-on-surface text-xs font-bold rounded-xl border border-outline-variant transition-all flex items-center justify-center gap-1" title="Đặt lại bộ lọc">
                            <span class="material-symbols-outlined text-[16px]">restart_alt</span>
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <!-- BẢNG DỮ LIỆU SẢN PHẨM -->
        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-outline-variant overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                    <tr class="border-b border-surface-variant bg-surface-container-low text-on-surface-variant font-label-bold text-xs uppercase tracking-wider">
                        <th class="py-4 px-5">Mã SP</th>
                        <th class="py-4 px-5">Sản phẩm</th>
                        <th class="py-4 px-4">Danh mục</th>
                        <th class="py-4 px-4">Giá bán</th>
                        <th class="py-4 px-4">Mức tồn kho</th>
                        <th class="py-4 px-4">Quy cách ship</th>
                        <th class="py-4 px-4">Trạng thái</th>
                        <th class="py-4 px-5 text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-surface-variant text-sm">
                    <c:forEach var="item" items="${products}">
                        <tr class="hover:bg-surface-container/50 transition-colors">
                            <!-- Mã sản phẩm -->
                            <td class="py-3.5 px-5 font-mono text-xs font-bold text-primary">
                                #PRD-<c:out value="${item.id}"/>
                            </td>

                            <!-- Hình ảnh & Tên sản phẩm -->
                            <td class="py-3.5 px-5">
                                <div class="flex items-center gap-3">
                                    <div class="w-12 h-12 rounded-xl bg-surface-container overflow-hidden border border-outline-variant flex-shrink-0 relative">
                                        <img class="w-full h-full object-cover" src="${item.imageUrl}" alt="${item.name}"/>
                                        <c:if test="${item.isFreeShipping}">
                                            <span class="absolute top-0 right-0 bg-primary text-white text-[8px] px-1 rounded-bl font-bold">Free</span>
                                        </c:if>
                                    </div>
                                    <div class="min-w-0">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${item.id}" target="_blank"
                                           class="font-label-bold text-on-surface hover:text-primary transition-colors line-clamp-1 block text-sm">
                                            <c:out value="${item.name}"/>
                                        </a>
                                        <span class="text-[11px] text-on-surface-variant">
                                            Trọng lượng: <c:out value="${item.weightGram != null ? item.weightGram : 500}"/>g
                                        </span>
                                    </div>
                                </div>
                            </td>

                            <!-- Danh mục -->
                            <td class="py-3.5 px-4">
                                <span class="px-2.5 py-1 rounded-lg text-xs font-medium bg-surface-container text-on-surface-variant whitespace-nowrap">
                                    <c:out value="${item.categoryName != null ? item.categoryName : 'Khác'}"/>
                                </span>
                            </td>

                            <!-- Giá bán & Giá khuyến mãi -->
                            <td class="py-3.5 px-4 whitespace-nowrap">
                                <c:choose>
                                    <c:when test="${item.discountPrice != null && item.discountPrice > 0}">
                                        <div class="font-price-tag font-bold text-primary text-sm">
                                            <fmt:formatNumber value="${item.discountPrice}" type="number" groupingUsed="true"/> ₫
                                        </div>
                                        <div class="line-through text-xs text-on-surface-variant/70">
                                            <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="font-price-tag font-bold text-on-surface text-sm">
                                            <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${item.taxRate != null && item.taxRate > 0}">
                                    <span class="text-[10px] text-error font-medium block">VAT: +${item.taxRate}%</span>
                                </c:if>
                            </td>

                            <!-- Mức tồn kho với Badge trực quan -->
                            <td class="py-3.5 px-4 whitespace-nowrap">
                                <c:choose>
                                    <c:when test="${item.stock > 20}">
                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold bg-emerald-50 text-emerald-700 border border-emerald-200">
                                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
                                            Còn <c:out value="${item.stock}"/> cái
                                        </span>
                                    </c:when>
                                    <c:when test="${item.stock > 0}">
                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold bg-amber-50 text-amber-700 border border-amber-200">
                                            <span class="w-1.5 h-1.5 rounded-full bg-amber-500 animate-pulse"></span>
                                            Chỉ còn <c:out value="${item.stock}"/> cái
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold bg-rose-50 text-rose-700 border border-rose-200">
                                            <span class="w-1.5 h-1.5 rounded-full bg-rose-500"></span>
                                            Hết hàng (0)
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Quy cách bảo quản & vận chuyển -->
                            <td class="py-3.5 px-4 whitespace-nowrap">
                                <c:choose>
                                    <c:when test="${item.storageType == 'COLD_CHAIN'}">
                                        <span class="inline-flex items-center gap-1 text-xs font-semibold text-sky-700 bg-sky-50 px-2 py-0.5 rounded-md border border-sky-200">
                                            ❄️ Chuỗi lạnh
                                        </span>
                                    </c:when>
                                    <c:when test="${item.storageType == 'FRAGILE_GIFT'}">
                                        <span class="inline-flex items-center gap-1 text-xs font-semibold text-purple-700 bg-purple-50 px-2 py-0.5 rounded-md border border-purple-200">
                                            🎁 Hộp quà
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-xs text-on-surface-variant">Bảo quản thường</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Trạng thái kinh doanh & Nút Toggle nhanh -->
                            <td class="py-3.5 px-4 whitespace-nowrap">
                                <a href="${pageContext.request.contextPath}/admin/products/toggle-status?id=${item.id}"
                                   class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold transition-all ${item.status ? 'bg-emerald-100 text-emerald-700 hover:bg-emerald-200' : 'bg-slate-200 text-slate-700 hover:bg-slate-300'}"
                                   title="Bấm để ${item.status ? 'ngừng bán' : 'mở bán lại'}">
                                    <span class="material-symbols-outlined text-[14px]">${item.status ? 'toggle_on' : 'toggle_off'}</span>
                                    <span>${item.status ? 'Đang bán' : 'Ngừng bán'}</span>
                                </a>
                            </td>

                            <!-- Nút thao tác Sửa / Xóa -->
                            <td class="py-3.5 px-5 text-center whitespace-nowrap">
                                <div class="flex items-center justify-center gap-1">
                                    <a href="${pageContext.request.contextPath}/admin/products/edit?id=${item.id}"
                                       class="w-8 h-8 rounded-lg bg-surface-container hover:bg-primary hover:text-white text-on-surface-variant flex items-center justify-center transition-all shadow-xs"
                                       title="Chỉnh sửa">
                                        <span class="material-symbols-outlined text-[18px]">edit</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/products/delete?id=${item.id}"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm \'${item.name}\'?\nNếu sản phẩm đã từng có khách đặt hàng, hệ thống sẽ tự động chuyển sang trạng thái Ngừng bán để bảo toàn dữ liệu.');"
                                       class="w-8 h-8 rounded-lg bg-surface-container hover:bg-error hover:text-white text-on-surface-variant flex items-center justify-center transition-all shadow-xs"
                                       title="Xóa / Ngừng bán">
                                        <span class="material-symbols-outlined text-[18px]">delete</span>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <!-- Khối thông báo nếu không có kết quả lọc -->
                    <c:if test="${empty products}">
                        <tr>
                            <td colspan="8" class="py-16 text-center text-on-surface-variant">
                                <div class="w-16 h-16 bg-surface-container rounded-full flex items-center justify-center mx-auto mb-3 text-outline">
                                    <span class="material-symbols-outlined text-[36px]">filter_list_off</span>
                                </div>
                                <h4 class="font-headline-md text-base font-bold text-on-surface mb-1">Không tìm thấy sản phẩm nào phù hợp</h4>
                                <p class="text-xs text-on-surface-variant mb-4">Vui lòng thử điều chỉnh các tiêu chí tìm kiếm hoặc xóa bộ lọc để xem toàn bộ kho hàng.</p>
                                <a href="${pageContext.request.contextPath}/admin/products" class="inline-flex items-center gap-1.5 px-4 py-2 rounded-full bg-primary text-white text-xs font-bold hover:bg-[#6ba306] transition-colors shadow-xs">
                                    <span class="material-symbols-outlined text-sm">restart_alt</span> Xem tất cả sản phẩm
                                </a>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- Script: Toast Notification (Bắt tham số URL) -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const message = urlParams.get('message');

        if (message) {
            let toastText = '';
            let toastType = 'success';

            if (message === 'Success') toastText = 'Thêm sản phẩm thành công!';
            else if (message === 'UpdateSuccess') toastText = 'Cập nhật sản phẩm thành công!';
            else if (message === 'DeleteSuccess') toastText = 'Đã xử lý xóa/ngừng bán sản phẩm thành công!';
            else if (message === 'Error') {
                toastText = 'Có lỗi xảy ra trong quá trình xử lý!';
                toastType = 'error';
            }

            if (toastText !== '') {
                showToast(toastText, toastType);
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        }

        function showToast(text, type) {
            const container = document.getElementById('toast-container');
            const toast = document.createElement('div');

            const bgColor = type === 'success' ? 'bg-primary' : 'bg-error';
            const icon = type === 'success' ? 'check_circle' : 'error';

            toast.className = `px-6 py-4 rounded-xl shadow-xl text-white font-label-bold transition-all duration-300 transform translate-y-[-100%] opacity-0 flex items-center gap-3 ` + bgColor;
            toast.innerHTML = `<span class="material-symbols-outlined text-[24px]">` + icon + `</span> ` + text;

            container.appendChild(toast);

            requestAnimationFrame(() => {
                toast.classList.remove('translate-y-[-100%]', 'opacity-0');
                toast.classList.add('translate-y-0', 'opacity-100');
            });

            setTimeout(() => {
                toast.classList.remove('translate-y-0', 'opacity-100');
                toast.classList.add('translate-y-[-100%]', 'opacity-0');
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }
    });
</script>
</body>
</html>