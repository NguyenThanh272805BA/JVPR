<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Cửa hàng - Fruitables</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>

<body class="bg-surface-container bg-pattern min-h-screen flex flex-col antialiased">
<!-- NAVBAR CHUNG -->
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<!-- SHOP HERO BANNER: 3D ORGANIC MARKET HALL -->
<section class="tilt-3d-stage relative w-full min-h-[380px] md:min-h-[440px] flex items-center overflow-hidden bg-gradient-to-br from-[#062410] via-[#0f3d1b] to-[#041a0b] py-10 md:py-14 perspective-1200 shadow-lg">
    <!-- Nền không gian sâu với Mesh Gradient & Ambient Aura tươi sáng hữu cơ -->
    <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-emerald-700/30 via-[#0a3818]/60 to-[#031c0a] z-0"></div>
    <div class="absolute -top-20 -left-20 w-96 h-96 bg-primary/30 rounded-full blur-[100px] pointer-events-none animate-ambient-aura z-0"></div>
    <div class="absolute -bottom-24 right-10 w-[30rem] h-[30rem] bg-lime-400/25 rounded-full blur-[120px] pointer-events-none animate-ambient-aura z-0" style="animation-delay: -3s;"></div>
    <div class="absolute top-1/2 left-1/3 w-80 h-80 bg-emerald-500/20 rounded-full blur-[90px] pointer-events-none z-0"></div>
    <div class="absolute inset-0 bg-[radial-gradient(#84cc16_1px,transparent_1px)] [background-size:28px_28px] opacity-20 pointer-events-none z-0"></div>

    <div class="relative z-10 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto w-full grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
        <!-- Cột trái: Tiêu đề & Giới thiệu -->
        <div class="lg:col-span-7 text-left space-y-4">
            <div class="inline-flex items-center gap-2 py-1 px-3.5 rounded-full bg-primary/25 text-lime-300 border border-primary/40 font-label-bold text-xs uppercase tracking-wider backdrop-blur-sm shadow-sm">
                <span class="material-symbols-outlined text-[15px] animate-pulse">storefront</span>
                <span>Chợ Nông Sản Trực Tuyến 24/7</span>
            </div>

            <h1 class="text-white font-display-lg text-3xl sm:text-4xl md:text-5xl font-black tracking-tight drop-shadow-lg leading-tight">
                Thiên Đường Trái Cây &<br>
                <span class="bg-gradient-to-r from-lime-300 via-[#a3e635] to-emerald-300 bg-clip-text text-transparent">Nông Sản Sạch VietGAP</span>
            </h1>

            <p class="text-emerald-100/90 font-body-lg text-sm md:text-base max-w-xl leading-relaxed">
                Tất cả hoa quả được thu hoạch mới mỗi sáng, bảo quản bằng công nghệ ướp lạnh tiêu chuẩn quốc tế để giữ trọn vẹn vitamin và độ ngọt tự nhiên.
            </p>

            <!-- Quick category navigation tags -->
            <div class="flex flex-wrap gap-2 pt-2">
                <a href="${pageContext.request.contextPath}/shop?category=1" class="px-4 py-2 rounded-full bg-white/15 hover:bg-primary text-white text-xs font-bold transition-all backdrop-blur-md border border-white/20 flex items-center gap-1.5 hover:-translate-y-0.5 shadow-sm">
                    <span class="material-symbols-outlined text-sm text-lime-300 group-hover:text-white">flight_takeoff</span>
                    Trái cây nhập khẩu
                </a>
                <a href="${pageContext.request.contextPath}/shop?category=2" class="px-4 py-2 rounded-full bg-white/15 hover:bg-primary text-white text-xs font-bold transition-all backdrop-blur-md border border-white/20 flex items-center gap-1.5 hover:-translate-y-0.5 shadow-sm">
                    <span class="material-symbols-outlined text-sm text-lime-300 group-hover:text-white">landscape</span>
                    Trái cây nội địa
                </a>
                <a href="${pageContext.request.contextPath}/shop?category=3" class="px-4 py-2 rounded-full bg-white/15 hover:bg-primary text-white text-xs font-bold transition-all backdrop-blur-md border border-white/20 flex items-center gap-1.5 hover:-translate-y-0.5 shadow-sm">
                    <span class="material-symbols-outlined text-sm text-lime-300 group-hover:text-white">spa</span>
                    Rau củ hữu cơ
                </a>
            </div>
        </div>

        <!-- Cột phải: 3D Interactive Market Showcase Badge -->
        <div class="lg:col-span-5 flex justify-center relative">
            <div data-3d-tilt data-tilt-max="14" data-tilt-scale="1.03"
                 class="preserve-3d relative w-full max-w-[380px] h-[280px] md:h-[300px] rounded-3xl glass-card-3d-dark p-5 flex flex-col justify-between cursor-pointer border border-white/20 shadow-[0_25px_60px_rgba(0,0,0,0.5)]">
                
                <div class="shimmer-layer"></div>

                <div class="translate-z-30 flex items-center justify-between z-20">
                    <span class="px-3 py-1 rounded-full bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 text-[11px] font-bold uppercase tracking-wider flex items-center gap-1">
                        <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-ping"></span> Tươi mới 100%
                    </span>
                    <span class="text-xs text-slate-300 font-semibold flex items-center gap-1 bg-white/10 px-2.5 py-1 rounded-full backdrop-blur-sm">
                        <span class="material-symbols-outlined text-primary text-sm">energy_savings_leaf</span> VietGAP Certified
                    </span>
                </div>

                <div class="translate-z-50 relative flex items-center justify-center my-auto z-10">
                    <div class="absolute w-44 h-44 bg-primary/25 rounded-full blur-2xl pointer-events-none animate-pulse"></div>
                    <img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=600&auto=format&fit=crop" 
                         alt="Fresh Fruit Market 3D" 
                         class="w-64 h-36 object-cover rounded-2xl shadow-xl border border-white/20 transform rotate-1 hover:rotate-0 transition-transform duration-500">
                </div>

                <div class="translate-z-40 bg-white/10 backdrop-blur-md rounded-xl p-3 border border-white/15 z-20 flex items-center justify-between">
                    <span class="text-xs text-slate-200 font-medium flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-base text-primary">local_shipping</span> Giao hỏa tốc 2H
                    </span>
                    <span class="text-xs font-bold text-primary bg-primary/10 px-2.5 py-0.5 rounded-full">Đồng kiểm khi nhận</span>
                </div>

                <!-- Floating badges -->
                <div class="translate-z-60 absolute -top-3 -right-3 bg-gradient-to-r from-primary to-emerald-600 text-white text-[10px] font-bold px-3 py-1 rounded-full shadow-lg border border-white/30 animate-float-3d">
                    🍎 Tươi ngon mỗi ngày
                </div>
            </div>
        </div>
    </div>
</section>

<!-- MAIN SHOP CONTENT -->
<main class="flex-grow py-8 md:py-10">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">

        <!-- XÁC ĐỊNH TÊN DANH MỤC HIỆN TẠI -->
        <c:set var="currentCatName" value="Tất cả sản phẩm" />
        <c:forEach var="c" items="${categories}">
            <c:if test="${selectedCategory == c.id}">
                <c:set var="currentCatName" value="${c.name}" />
            </c:if>
        </c:forEach>

        <!-- THANH LỰA CHỌN DANH MỤC HÀNG NGANG & MENU TRƯỢT XUỐNG -->
        <div class="mb-8 bg-surface-container-lowest p-4 md:p-5 rounded-2xl border border-outline-variant shadow-sm transition-all hover:shadow-md">
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-3 border-b border-surface-variant/70">
                <!-- Tiêu đề & Trạng thái lọc -->
                <div class="flex items-center gap-2.5">
                    <div class="w-9 h-9 rounded-xl bg-primary/10 text-primary flex items-center justify-center flex-shrink-0">
                        <span class="material-symbols-outlined text-xl">category</span>
                    </div>
                    <div>
                        <span class="text-[11px] text-on-surface-variant font-medium block">Danh mục đang chọn:</span>
                        <div class="text-sm md:text-base font-black text-on-surface flex items-center gap-2">
                            <span class="text-primary truncate max-w-[260px] md:max-w-none">${currentCatName}</span>
                            <c:if test="${not empty selectedCategory}">
                                <a href="${pageContext.request.contextPath}/shop<c:if test='${not empty keyword}'>?keyword=${keyword}</c:if><c:if test='${not empty selectedMinPrice}'>&minPrice=${selectedMinPrice}</c:if><c:if test='${not empty selectedMaxPrice}'>&maxPrice=${selectedMaxPrice}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                                   class="text-[11px] font-bold text-rose-500 hover:text-rose-700 bg-rose-50 hover:bg-rose-100 px-2 py-0.5 rounded-full flex items-center gap-0.5 transition-colors" title="Bỏ lọc danh mục">
                                    <span class="material-symbols-outlined text-xs">close</span> Bỏ chọn
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- BỘ CHỌN TRƯỢT XUỐNG (DROPDOWN MENU / SELECT) -->
                <div class="relative flex items-center gap-2" id="categoryDropdownWrapper">
                    <span class="text-xs text-on-surface-variant hidden md:inline">Chọn nhanh:</span>
                    <div class="relative">
                        <button type="button" onclick="toggleCategoryDropdown()" id="btnCategoryDropdown"
                                class="inline-flex items-center justify-between gap-2.5 px-4 py-2 bg-surface-container hover:bg-surface-container-high text-on-surface rounded-xl border border-outline-variant text-xs md:text-sm font-bold shadow-xs transition-all hover:border-primary">
                            <span class="flex items-center gap-1.5 truncate max-w-[180px] sm:max-w-[220px]">
                                <span class="material-symbols-outlined text-primary text-base">filter_list</span>
                                <span class="truncate">${currentCatName}</span>
                            </span>
                            <span class="material-symbols-outlined text-base transition-transform duration-200" id="catDropdownArrow">expand_more</span>
                        </button>

                        <!-- Menu trượt xuống với thanh cuộn (Scrollable Dropdown) -->
                        <div id="categoryDropdownMenu" 
                             class="hidden absolute right-0 mt-2 w-72 max-h-80 overflow-y-auto bg-surface-container-lowest border border-outline-variant rounded-2xl shadow-2xl z-50 p-2 divide-y divide-surface-variant/80 transition-all">
                            <div class="py-1">
                                <a href="${pageContext.request.contextPath}/shop<c:if test='${not empty keyword}'>?keyword=${keyword}</c:if><c:if test='${not empty selectedMinPrice}'>&minPrice=${selectedMinPrice}</c:if><c:if test='${not empty selectedMaxPrice}'>&maxPrice=${selectedMaxPrice}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>" 
                                   class="flex items-center justify-between px-3 py-2.5 rounded-xl text-xs font-semibold hover:bg-primary/10 hover:text-primary transition-colors ${empty selectedCategory ? 'bg-primary text-white font-bold' : 'text-on-surface'}">
                                    <span class="flex items-center gap-2">
                                        <span class="material-symbols-outlined text-base">apps</span>
                                        <span>Tất cả sản phẩm</span>
                                    </span>
                                    <span class="text-[10px] px-2 py-0.5 rounded-full ${empty selectedCategory ? 'bg-white/20 text-white' : 'bg-surface-container text-on-surface-variant'}">${totalProducts}</span>
                                </a>
                            </div>
                            <div class="py-1 space-y-1">
                                <c:forEach var="cat" items="${categories}">
                                    <c:set var="isSel" value="${selectedCategory == cat.id}" />
                                    <a href="${pageContext.request.contextPath}/shop?category=${cat.id}<c:if test='${not empty keyword}'>&keyword=${keyword}</c:if><c:if test='${not empty selectedMinPrice}'>&minPrice=${selectedMinPrice}</c:if><c:if test='${not empty selectedMaxPrice}'>&maxPrice=${selectedMaxPrice}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                                       class="flex items-center justify-between px-3 py-2 rounded-xl text-xs font-semibold hover:bg-primary/10 hover:text-primary transition-colors ${isSel ? 'bg-primary text-white font-bold' : 'text-on-surface'}">
                                        <span class="flex items-center gap-2 truncate">
                                            <span class="material-symbols-outlined text-base ${isSel ? 'text-white' : 'text-primary'}">${isSel ? 'check_circle' : 'subdirectory_arrow_right'}</span>
                                            <span class="truncate">${cat.name}</span>
                                        </span>
                                        <span class="text-[10px] px-2 py-0.5 rounded-full flex-shrink-0 ${isSel ? 'bg-white/20 text-white' : 'bg-surface-container text-on-surface-variant'}">${cat.productCount}</span>
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- THANH TRƯỢT HÀNG NGANG CÁC DANH MỤC (HORIZONTAL PILLS TRACK) -->
            <div class="relative mt-3 flex items-center">
                <!-- Nút cuộn trái -->
                <button type="button" onclick="scrollCategoryPills('left')" 
                        class="hidden md:flex flex-shrink-0 w-8 h-8 rounded-full bg-surface-container hover:bg-primary hover:text-white items-center justify-center text-on-surface shadow-xs transition-all mr-2"
                        title="Cuộn sang trái">
                    <span class="material-symbols-outlined text-sm">chevron_left</span>
                </button>
                
                <!-- Dải nút cuộn hàng ngang -->
                <div id="categoryPillsTrack" class="flex items-center gap-2 overflow-x-auto py-1 scroll-smooth w-full [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
                    <!-- Nút Tất cả -->
                    <a href="${pageContext.request.contextPath}/shop<c:if test='${not empty keyword}'>?keyword=${keyword}</c:if><c:if test='${not empty selectedMinPrice}'>&minPrice=${selectedMinPrice}</c:if><c:if test='${not empty selectedMaxPrice}'>&maxPrice=${selectedMaxPrice}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                       class="flex-shrink-0 px-4 py-2 rounded-full text-xs font-bold transition-all flex items-center gap-1.5 ${empty selectedCategory ? 'bg-primary text-white shadow-md scale-105 active-pill' : 'bg-surface-container hover:bg-surface-container-high text-on-surface-variant hover:text-primary border border-outline-variant/60'}">
                        <span class="material-symbols-outlined text-sm">apps</span>
                        <span>Tất cả</span>
                        <span class="text-[10px] px-1.5 py-0.5 rounded-full ${empty selectedCategory ? 'bg-white/20 text-white' : 'bg-surface-container-lowest text-on-surface-variant'}">${totalProducts}</span>
                    </a>

                    <!-- Danh mục động từ DB -->
                    <c:forEach var="cat" items="${categories}">
                        <c:set var="isCatActive" value="${selectedCategory == cat.id}" />
                        <a href="${pageContext.request.contextPath}/shop?category=${cat.id}<c:if test='${not empty keyword}'>&keyword=${keyword}</c:if><c:if test='${not empty selectedMinPrice}'>&minPrice=${selectedMinPrice}</c:if><c:if test='${not empty selectedMaxPrice}'>&maxPrice=${selectedMaxPrice}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                           class="flex-shrink-0 px-4 py-2 rounded-full text-xs font-bold transition-all flex items-center gap-1.5 ${isCatActive ? 'bg-primary text-white shadow-md scale-105 active-pill' : 'bg-surface-container hover:bg-surface-container-high text-on-surface-variant hover:text-primary border border-outline-variant/60'}">
                            <span>${cat.name}</span>
                            <span class="text-[10px] px-1.5 py-0.5 rounded-full ${isCatActive ? 'bg-white/20 text-white' : 'bg-surface-container-lowest text-on-surface-variant'}">${cat.productCount}</span>
                        </a>
                    </c:forEach>
                </div>

                <!-- Nút cuộn phải -->
                <button type="button" onclick="scrollCategoryPills('right')" 
                        class="hidden md:flex flex-shrink-0 w-8 h-8 rounded-full bg-surface-container hover:bg-primary hover:text-white items-center justify-center text-on-surface shadow-xs transition-all ml-2"
                        title="Cuộn sang phải">
                    <span class="material-symbols-outlined text-sm">chevron_right</span>
                </button>
            </div>
        </div>

        <div class="flex flex-col md:flex-row gap-8">

        <!-- SIDEBAR -->
        <aside class="w-full md:w-1/4 flex flex-col gap-6 relative z-10">
            <!-- Tích hợp AJAX Live Search -->
            <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant shadow-sm">
                <h3 class="font-headline-md text-lg text-on-surface mb-4 border-b border-surface-variant pb-2">Tìm kiếm</h3>
                <div class="relative">
                    <form action="${pageContext.request.contextPath}/shop" method="GET" class="relative">
                        <c:if test="${not empty selectedCategory}"><input type="hidden" name="category" value="${selectedCategory}"></c:if>
                        <c:if test="${not empty selectedMinPrice}"><input type="hidden" name="minPrice" value="${selectedMinPrice}"></c:if>
                        <c:if test="${not empty selectedMaxPrice}"><input type="hidden" name="maxPrice" value="${selectedMaxPrice}"></c:if>
                        <input type="text" id="liveSearchInput" name="keyword" value="${keyword}" placeholder="Nhập tên sản phẩm..."
                                class="w-full pl-4 pr-10 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none font-body-md text-on-surface transition-colors" autocomplete="off">
                        <button type="submit" class="absolute right-2 top-1/2 -translate-y-1/2 text-outline hover:text-primary">
                            <span class="material-symbols-outlined">search</span>
                        </button>
                    </form>

                    <!-- Khung chứa kết quả AJAX -->
                    <ul id="searchDropdown" class="absolute z-50 w-full bg-surface-container-lowest border border-outline-variant rounded-lg shadow-lg hidden mt-1 max-h-80 overflow-y-auto divide-y divide-surface-variant">
                    </ul>
                </div>
            </div>

            <!-- Danh mục trong Sidebar -->
            <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant shadow-sm">
                <h3 class="font-headline-md text-lg text-on-surface mb-4 border-b border-surface-variant pb-2 flex items-center justify-between">
                    <span>Danh mục</span>
                    <span class="text-xs text-primary font-bold font-mono">${categories.size()} mục</span>
                </h3>
                <ul class="space-y-1.5 font-body-md text-on-surface-variant text-xs md:text-sm max-h-96 overflow-y-auto pr-1">
                    <li>
                        <a href="${pageContext.request.contextPath}/shop<c:if test='${not empty keyword}'>?keyword=${keyword}</c:if><c:if test='${not empty selectedMinPrice}'>&minPrice=${selectedMinPrice}</c:if><c:if test='${not empty selectedMaxPrice}'>&maxPrice=${selectedMaxPrice}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>" 
                           class="flex justify-between items-center px-3 py-2 rounded-xl hover:bg-surface-container transition-colors ${empty selectedCategory ? 'bg-primary/10 text-primary font-bold' : ''}">
                            <span class="flex items-center gap-2">
                                <span class="material-symbols-outlined text-base">apps</span>
                                <span>Tất cả sản phẩm</span>
                            </span>
                            <span class="text-[11px] px-2 py-0.5 rounded-full ${empty selectedCategory ? 'bg-primary text-white font-bold' : 'bg-surface-container text-on-surface-variant'}">${totalProducts}</span>
                        </a>
                    </li>
                    <c:forEach var="cat" items="${categories}">
                        <li>
                            <a href="${pageContext.request.contextPath}/shop?category=${cat.id}<c:if test='${not empty keyword}'>&keyword=${keyword}</c:if><c:if test='${not empty selectedMinPrice}'>&minPrice=${selectedMinPrice}</c:if><c:if test='${not empty selectedMaxPrice}'>&maxPrice=${selectedMaxPrice}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>" 
                               class="flex justify-between items-center px-3 py-2 rounded-xl hover:bg-surface-container transition-colors ${selectedCategory == cat.id ? 'bg-primary/10 text-primary font-bold' : ''}">
                                <span class="flex items-center gap-2 truncate">
                                    <span class="material-symbols-outlined text-sm ${selectedCategory == cat.id ? 'text-primary' : 'text-slate-400'}">chevron_right</span>
                                    <span class="truncate">${cat.name}</span>
                                </span>
                                <span class="text-[11px] px-2 py-0.5 rounded-full ml-1 flex-shrink-0 ${selectedCategory == cat.id ? 'bg-primary text-white font-bold' : 'bg-surface-container text-on-surface-variant'}">${cat.productCount}</span>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Bộ lọc khoảng giá (Mới bổ sung) -->
            <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant shadow-sm">
                <div class="flex items-center justify-between mb-4 border-b border-surface-variant pb-2">
                    <h3 class="font-headline-md text-lg text-on-surface">Khoảng giá (VNĐ)</h3>
                    <c:if test="${not empty selectedMinPrice || not empty selectedMaxPrice}">
                        <a href="${pageContext.request.contextPath}/shop<c:if test='${not empty selectedCategory}'>?category=${selectedCategory}</c:if>" 
                           class="text-xs text-rose-500 hover:text-rose-700 font-label-bold flex items-center gap-0.5" title="Xóa bộ lọc giá">
                            <span class="material-symbols-outlined text-[14px]">refresh</span> Đặt lại
                        </a>
                    </c:if>
                </div>

                <!-- Mức giá gợi ý -->
                <ul class="space-y-2 mb-4 text-xs text-on-surface-variant">
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?maxPrice=50000<c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                           class="flex items-center justify-between p-2 rounded-lg hover:bg-surface-container transition-colors ${empty selectedMinPrice && selectedMaxPrice == 50000 ? 'bg-primary/10 text-primary font-bold border border-primary/30' : ''}">
                            <span>Dưới 50.000₫</span>
                            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?minPrice=50000&maxPrice=100000<c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                           class="flex items-center justify-between p-2 rounded-lg hover:bg-surface-container transition-colors ${selectedMinPrice == 50000 && selectedMaxPrice == 100000 ? 'bg-primary/10 text-primary font-bold border border-primary/30' : ''}">
                            <span>50.000₫ - 100.000₫</span>
                            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?minPrice=100000&maxPrice=200000<c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                           class="flex items-center justify-between p-2 rounded-lg hover:bg-surface-container transition-colors ${selectedMinPrice == 100000 && selectedMaxPrice == 200000 ? 'bg-primary/10 text-primary font-bold border border-primary/30' : ''}">
                            <span>100.000₫ - 200.000₫</span>
                            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?minPrice=200000<c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                           class="flex items-center justify-between p-2 rounded-lg hover:bg-surface-container transition-colors ${selectedMinPrice == 200000 && empty selectedMaxPrice ? 'bg-primary/10 text-primary font-bold border border-primary/30' : ''}">
                            <span>Trên 200.000₫</span>
                            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                        </a>
                    </li>
                </ul>

                <!-- Tùy chỉnh khoảng giá -->
                <form action="${pageContext.request.contextPath}/shop" method="GET" class="space-y-3 pt-3 border-t border-surface-variant">
                    <input type="hidden" name="keyword" value="${keyword}">
                    <c:if test="${not empty selectedCategory}">
                        <input type="hidden" name="category" value="${selectedCategory}">
                    </c:if>
                    <c:if test="${not empty selectedSort}">
                        <input type="hidden" name="sort" value="${selectedSort}">
                    </c:if>
                    
                    <div class="text-xs font-label-bold text-on-surface-variant">Tự nhập khoảng giá:</div>
                    <div class="flex items-center gap-2">
                        <input type="number" name="minPrice" placeholder="Từ (₫)" value="${selectedMinPrice != null ? selectedMinPrice.intValue() : ''}" min="0" step="5000"
                               class="w-1/2 px-2.5 py-1.5 text-xs rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface">
                        <span class="text-on-surface-variant text-xs">-</span>
                        <input type="number" name="maxPrice" placeholder="Đến (₫)" value="${selectedMaxPrice != null ? selectedMaxPrice.intValue() : ''}" min="0" step="5000"
                               class="w-1/2 px-2.5 py-1.5 text-xs rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface">
                    </div>
                    <button type="submit" class="w-full py-2 bg-primary hover:bg-primary-container text-white text-xs font-label-bold rounded-lg transition-all shadow-sm flex items-center justify-center gap-1">
                        <span class="material-symbols-outlined text-[16px]">tune</span> Áp dụng khoảng giá
                    </button>
                </form>
            </div>
        </aside>

        <!-- PRODUCT GRID -->
        <div class="w-full md:w-3/4">
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6 pb-4 border-b border-surface-variant">
                <p class="font-body-md text-on-surface-variant text-sm">
                    Hiển thị <span class="font-label-bold text-on-surface"><c:out value="${startItem}"/> - <c:out value="${endItem}"/></span> trên tổng số <span class="font-label-bold text-primary"><c:out value="${totalProducts}"/></span> sản phẩm
                </p>
                <form action="${pageContext.request.contextPath}/shop" method="GET" class="flex items-center gap-2.5 flex-wrap">
                    <input type="hidden" name="keyword" value="<c:out value='${keyword}'/>">
                    <c:if test="${not empty selectedCategory}"><input type="hidden" name="category" value="${selectedCategory}"></c:if>
                    <c:if test="${not empty selectedMinPrice}"><input type="hidden" name="minPrice" value="${selectedMinPrice}"></c:if>
                    <c:if test="${not empty selectedMaxPrice}"><input type="hidden" name="maxPrice" value="${selectedMaxPrice}"></c:if>
                    <input type="hidden" name="page" value="1">

                    <!-- Lựa chọn số lượng hiển thị trên 1 trang -->
                    <div class="flex items-center gap-1.5 bg-surface-container-lowest px-3 py-1.5 rounded-xl border border-outline-variant shadow-sm">
                        <label class="text-xs font-medium text-on-surface-variant flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm text-primary">view_module</span> Hiển thị:
                        </label>
                        <select name="pageSize" onchange="this.form.submit()" class="border-0 bg-transparent text-xs font-bold text-on-surface outline-none cursor-pointer focus:ring-0">
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 / trang</option>
                            <option value="12" ${pageSize == 12 || empty pageSize ? 'selected' : ''}>12 / trang</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 / trang</option>
                            <option value="24" ${pageSize == 24 ? 'selected' : ''}>24 / trang</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 / trang</option>
                        </select>
                    </div>

                    <!-- Sắp xếp -->
                    <div class="flex items-center gap-1.5 bg-surface-container-lowest px-3 py-1.5 rounded-xl border border-outline-variant shadow-sm">
                        <label class="text-xs font-medium text-on-surface-variant flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm text-primary">sort</span> Sắp xếp:
                        </label>
                        <select name="sort" onchange="this.form.submit()" class="border-0 bg-transparent text-xs font-bold text-on-surface outline-none cursor-pointer focus:ring-0">
                            <option value="newest" ${selectedSort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            <option value="price_asc" ${selectedSort == 'price_asc' ? 'selected' : ''}>Giá: Thấp đến Cao</option>
                            <option value="price_desc" ${selectedSort == 'price_desc' ? 'selected' : ''}>Giá: Cao xuống Thấp</option>
                        </select>
                    </div>
                </form>
            </div>

            <!-- Lưới hiển thị sản phẩm -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="item" items="${products}">
                    <c:set var="isOutOfStock" value="${item.stock != null && item.stock <= 0}" />
                    <c:set var="hasDiscount" value="${item.discountPrice != null && item.discountPrice > 0 && item.discountPrice < item.price}" />

                    <div class="bg-surface-container-lowest rounded-2xl shadow-sm hover:shadow-xl transition-all duration-300 border border-outline-variant/80 hover:border-primary/50 overflow-hidden group flex flex-col hover:-translate-y-1 relative">
                        <!-- Product Image Clickable -->
                        <a href="${pageContext.request.contextPath}/product-detail?id=${item.id}" class="relative w-full h-48 bg-surface-container overflow-hidden block">
                            <img src="${not empty item.imageUrl ? item.imageUrl : pageContext.request.contextPath.concat('/assets/uploads/no-image.svg')}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/uploads/no-image.svg';" alt="${item.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500 ${isOutOfStock ? 'grayscale opacity-75' : ''}">
                            <div class="absolute top-3 left-3 bg-primary/95 backdrop-blur-xs text-white text-[11px] font-bold px-2.5 py-1 rounded-full shadow-sm">
                                <c:out value="${item.categoryName}"/>
                            </div>

                            <c:if test="${hasDiscount}">
                                <div class="absolute top-3 right-3 bg-red-500 text-white text-[11px] font-bold px-2 py-0.5 rounded-full shadow-md animate-pulse">
                                    -<fmt:formatNumber value="${(item.price - item.discountPrice) / item.price * 100}" maxFractionDigits="0"/>%
                                </div>
                            </c:if>

                            <c:if test="${isOutOfStock}">
                                <div class="absolute inset-0 bg-black/40 backdrop-blur-[2px] flex items-center justify-center">
                                    <span class="bg-red-600 text-white font-label-bold text-xs uppercase tracking-wider px-3 py-1 rounded-full shadow-lg border border-white/20 flex items-center gap-1">
                                        <span class="material-symbols-outlined text-[15px]">remove_shopping_cart</span> Hết hàng
                                    </span>
                                </div>
                            </c:if>
                        </a>

                        <div class="p-5 flex flex-col flex-grow">
                            <!-- Product Title Clickable -->
                            <a href="${pageContext.request.contextPath}/product-detail?id=${item.id}" class="hover:text-primary transition-colors">
                                <h3 class="font-label-bold text-base text-on-surface mb-2 line-clamp-1" title="${item.name}"><c:out value="${item.name}"/></h3>
                            </a>

                            <!-- Render số sao động từ Database -->
                            <div class="flex items-center gap-1.5 mb-2">
                                <c:set var="rating" value="${item.avgRating != null ? item.avgRating : 5.0}" />
                                <div class="flex text-yellow-500">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${rating >= i}">
                                                <span class="material-symbols-outlined text-[16px]" style="font-variation-settings: 'FILL' 1;">star</span>
                                            </c:when>
                                            <c:when test="${rating >= i - 0.5}">
                                                <span class="material-symbols-outlined text-[16px]" style="font-variation-settings: 'FILL' 1;">star_half</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="material-symbols-outlined text-[16px] text-gray-300">star</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                <span class="text-xs font-bold text-amber-600 bg-amber-50 px-1.5 py-0.5 rounded border border-amber-200">
                                    <fmt:formatNumber value="${rating}" maxFractionDigits="1" minFractionDigits="1"/>
                                </span>
                                <span class="text-xs text-on-surface-variant font-medium">(${item.reviewCount != null ? item.reviewCount : 0})</span>
                            </div>

                            <!-- Số lượt bán -->
                            <div class="flex items-center gap-1.5 mb-3">
                                <span class="inline-flex items-center gap-1 text-[11px] font-semibold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-md border border-emerald-200/80">
                                    <span class="material-symbols-outlined text-[13px]">shopping_bag</span>
                                    Đã bán <span class="font-bold"><c:out value="${item.totalSold != null ? item.totalSold : 0}"/></span>
                                </span>
                            </div>

                            <div class="mt-auto flex items-center justify-between pt-2 border-t border-surface-variant/40">
                                <div>
                                    <c:choose>
                                        <c:when test="${hasDiscount}">
                                            <div class="flex flex-col">
                                                <span class="font-price-tag text-lg text-primary font-bold">
                                                    <fmt:formatNumber value="${item.discountPrice}" type="number" groupingUsed="true"/> ₫
                                                </span>
                                                <span class="text-xs text-on-surface-variant line-through -mt-1">
                                                    <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                                </span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="font-price-tag text-lg text-primary font-bold">
                                                <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <c:choose>
                                    <c:when test="${isOutOfStock}">
                                        <button type="button" onclick="triggerOutOfStockModal('${item.name}')" class="w-10 h-10 rounded-full bg-red-100 hover:bg-red-200 text-red-600 flex items-center justify-center transition-colors shadow-sm" title="Sản phẩm đã hết hàng">
                                            <span class="material-symbols-outlined text-[20px]">production_quantity_limits</span>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/cart" method="POST">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${item.id}">
                                            <button type="submit" class="w-10 h-10 rounded-full bg-surface-container hover:bg-primary hover:text-white text-primary flex items-center justify-center transition-colors shadow-sm active:scale-95" title="Thêm vào giỏ">
                                                <span class="material-symbols-outlined text-[20px]">add_shopping_cart</span>
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Empty state nếu không có sản phẩm -->
            <c:if test="${empty products}">
                <div class="text-center py-16 bg-surface-container-lowest rounded-2xl border border-dashed border-outline-variant my-6">
                    <span class="material-symbols-outlined text-5xl text-outline mb-3">search_off</span>
                    <h3 class="font-headline-md text-lg text-on-surface font-bold">Không tìm thấy sản phẩm phù hợp</h3>
                    <p class="text-sm text-on-surface-variant mt-1">Vui lòng thử điều chỉnh lại từ khóa tìm kiếm hoặc mở rộng khoảng giá.</p>
                    <a href="${pageContext.request.contextPath}/shop" class="inline-block mt-4 px-5 py-2 bg-primary text-white rounded-full text-xs font-bold hover:bg-primary-container transition-colors shadow-sm">
                        Xem tất cả sản phẩm
                    </a>
                </div>
            </c:if>

            <!-- PHÂN TRANG ĐỘNG BẢO TOÀN BỘ LỌC & SỐ LƯỢNG HIỂN THỊ -->
            <c:if test="${totalPages > 1}">
                <c:url var="pageBaseUrl" value="/shop">
                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                    <c:if test="${not empty selectedCategory}"><c:param name="category" value="${selectedCategory}"/></c:if>
                    <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}"/></c:if>
                    <c:if test="${not empty selectedMinPrice}"><c:param name="minPrice" value="${selectedMinPrice}"/></c:if>
                    <c:if test="${not empty selectedMaxPrice}"><c:param name="maxPrice" value="${selectedMaxPrice}"/></c:if>
                    <c:param name="pageSize" value="${pageSize}"/>
                </c:url>

                <div class="mt-12 flex justify-center items-center gap-2 select-none">
                    <!-- Nút Trang trước -->
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a href="${pageBaseUrl}&page=${currentPage - 1}" class="w-10 h-10 rounded-full border border-outline-variant flex items-center justify-center hover:bg-primary hover:text-white hover:border-primary text-on-surface-variant transition-all shadow-sm" title="Trang trước">
                                <span class="material-symbols-outlined text-[18px]">chevron_left</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <span class="w-10 h-10 rounded-full border border-outline-variant/40 flex items-center justify-center text-outline-variant/40 cursor-not-allowed">
                                <span class="material-symbols-outlined text-[18px]">chevron_left</span>
                            </span>
                        </c:otherwise>
                    </c:choose>

                    <!-- Các trang số -->
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <c:choose>
                            <c:when test="${p == currentPage}">
                                <span class="w-10 h-10 rounded-full bg-primary text-white font-label-bold flex items-center justify-center shadow-md scale-105">
                                    ${p}
                                </span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageBaseUrl}&page=${p}" class="w-10 h-10 rounded-full border border-outline-variant flex items-center justify-center hover:bg-surface-container text-on-surface transition-all font-label-bold">
                                    ${p}
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <!-- Nút Trang sau -->
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a href="${pageBaseUrl}&page=${currentPage + 1}" class="w-10 h-10 rounded-full border border-outline-variant flex items-center justify-center hover:bg-primary hover:text-white hover:border-primary text-on-surface-variant transition-all shadow-sm" title="Trang sau">
                                <span class="material-symbols-outlined text-[18px]">chevron_right</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <span class="w-10 h-10 rounded-full border border-outline-variant/40 flex items-center justify-center text-outline-variant/40 cursor-not-allowed">
                                <span class="material-symbols-outlined text-[18px]">chevron_right</span>
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>
    </div>
    </div>
</main>

<!-- FOOTER CHUNG -->
<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<!-- SCRIPT: Xử lý gọi AJAX Fetch API cho tính năng Live Search (Giữ nguyên gốc) -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('liveSearchInput');
        const searchDropdown = document.getElementById('searchDropdown');
        let timeoutId;

        searchInput.addEventListener('input', function() {
            clearTimeout(timeoutId);
            const keyword = this.value.trim();

            if (keyword.length < 2) {
                searchDropdown.classList.add('hidden');
                return;
            }

            timeoutId = setTimeout(() => {
                fetch(`${pageContext.request.contextPath}/api/search-products?keyword=` + encodeURIComponent(keyword))
                    .then(response => response.json())
                    .then(data => {
                        searchDropdown.innerHTML = '';

                        if (data.length > 0) {
                            data.forEach(product => {
                                const priceStr = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(product.price);

                                const li = document.createElement('li');
                                li.className = 'px-4 py-3 hover:bg-surface-container cursor-pointer flex items-center gap-3 transition-colors';
                                li.innerHTML = `
                                    <img src="` + product.imageUrl + `" class="w-12 h-12 object-cover rounded-md border border-outline-variant">
                                    <div class="flex-1 overflow-hidden">
                                        <div class="font-label-bold text-sm text-on-surface truncate">` + product.name + `</div>
                                        <div class="text-primary text-xs font-bold mt-1">` + priceStr + `</div>
                                    </div>
                                `;
                                li.addEventListener('click', () => {
                                    window.location.href = `${pageContext.request.contextPath}/product-detail?id=` + product.id;
                                });
                                searchDropdown.appendChild(li);
                            });
                            searchDropdown.classList.remove('hidden');
                        } else {
                            searchDropdown.innerHTML = '<li class="px-4 py-4 text-sm text-on-surface-variant text-center">Không tìm thấy sản phẩm phù hợp.</li>';
                            searchDropdown.classList.remove('hidden');
                        }
                    })
                    .catch(err => console.error('Lỗi khi tải kết quả tìm kiếm:', err));
            }, 300);
        });

        document.addEventListener('click', function(e) {
            if (!searchInput.contains(e.target) && !searchDropdown.contains(e.target)) {
                searchDropdown.classList.add('hidden');
            }
        });
    });
</script>

<!-- JAVASCRIPT AJAX ADD TO CART & TOAST NOTIFICATION (Giữ nguyên gốc) -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const addCartForms = document.querySelectorAll('form[action$="/cart"]');

        addCartForms.forEach(form => {
            const actionInput = form.querySelector('input[name="action"][value="add"]');

            if (actionInput) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();

                    const currentForm = this;
                    const formData = new FormData(currentForm);
                    const data = new URLSearchParams(formData);

                    fetch(`${pageContext.request.contextPath}/api/add-to-cart`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: data.toString()
                    })
                        .then(response => response.json())
                        .then(res => {
                            if (res.status === 'success') {
                                const card = currentForm.closest('.group') || currentForm.closest('.product-card') || currentForm.parentElement;
                                const img = card ? card.querySelector('img') : null;
                                flyToCart(img, () => {
                                    updateCartBadge(res.totalItems);
                                });
                                showToast(res.message, 'success');
                            } else if (res.status === 'out_of_stock') {
                                triggerOutOfStockModal(res.message);
                            } else {
                                showToast(res.message, 'error');
                            }
                        })
                        .catch(err => {
                            console.error('Lỗi API:', err);
                            showToast('Có lỗi xảy ra, vui lòng thử lại.', 'error');
                        });
                });
            }
        });

        function flyToCart(imgElement, callback) {
            const cartBtn = document.getElementById('navbar-cart-btn') || document.querySelector('a[href$="/cart"]');
            const cartIcon = document.getElementById('navbar-cart-icon');
            if (!imgElement || !cartBtn) {
                if (callback) callback();
                triggerCartShake();
                return;
            }

            const imgRect = imgElement.getBoundingClientRect();
            const cartRect = (cartIcon || cartBtn).getBoundingClientRect();

            const clone = document.createElement('img');
            clone.src = imgElement.src;
            clone.className = 'fly-item';
            clone.style.top = imgRect.top + 'px';
            clone.style.left = imgRect.left + 'px';
            clone.style.width = imgRect.width + 'px';
            clone.style.height = imgRect.height + 'px';
            document.body.appendChild(clone);

            void clone.offsetWidth; // Trigger reflow

            const targetX = cartRect.left + (cartRect.width / 2) - 16;
            const targetY = cartRect.top + (cartRect.height / 2) - 16;

            clone.style.top = targetY + 'px';
            clone.style.left = targetX + 'px';
            clone.style.width = '32px';
            clone.style.height = '32px';
            clone.style.opacity = '0.35';
            clone.style.transform = 'scale(0.4) rotate(360deg)';

            setTimeout(() => {
                clone.remove();
                if (callback) callback();
                triggerCartShake();
            }, 720);
        }

        function triggerCartShake() {
            const cartIcon = document.getElementById('navbar-cart-icon') || document.getElementById('navbar-cart-btn');
            if (cartIcon) {
                cartIcon.classList.remove('animate-cart-shake');
                void cartIcon.offsetWidth;
                cartIcon.classList.add('animate-cart-shake');
                setTimeout(() => cartIcon.classList.remove('animate-cart-shake'), 700);
            }
        }

        // Kiểm tra xem trang có được redirect sang do hết hàng không
        const urlParams = new URLSearchParams(window.location.search);
        <c:if test="${not empty sessionScope.OUT_OF_STOCK_PRODUCT_NAME}">
            triggerOutOfStockModal('<c:out value="${sessionScope.OUT_OF_STOCK_PRODUCT_NAME}"/>');
            <c:remove var="OUT_OF_STOCK_PRODUCT_NAME" scope="session"/>
        </c:if>
        if (urlParams.get('outOfStock') === '1') {
            triggerOutOfStockModal('sản phẩm bạn chọn');
        }

        function updateCartBadge(total) {
            const cartLink = document.getElementById('navbar-cart-btn') || document.querySelector('a[href$="/cart"]');
            if (cartLink) {
                let badge = document.getElementById('navbar-cart-badge') || cartLink.querySelector('span.bg-error');
                if (!badge && total > 0) {
                    badge = document.createElement('span');
                    badge.id = 'navbar-cart-badge';
                    badge.className = 'absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center transition-transform';
                    cartLink.appendChild(badge);
                }
                if (badge) {
                    badge.textContent = total;
                    badge.classList.remove('animate-badge-pop');
                    void badge.offsetWidth;
                    badge.classList.add('animate-badge-pop');
                }
            }
        }

        function showToast(message, type) {
            let container = document.getElementById('toast-container');
            if (!container) {
                container = document.createElement('div');
                container.id = 'toast-container';
                container.className = 'fixed bottom-5 right-5 z-50 flex flex-col gap-3 pointer-events-none';
                document.body.appendChild(container);
            }

            const toast = document.createElement('div');
            const bgColor = type === 'success' ? 'bg-primary' : 'bg-error';
            const icon = type === 'success' ? 'check_circle' : 'error';

            toast.className = `px-6 py-3 rounded-lg shadow-lg text-white font-label-bold transition-all duration-300 transform translate-y-10 opacity-0 flex items-center gap-2 ` + bgColor;
            toast.innerHTML = `<span class="material-symbols-outlined">` + icon + `</span> ` + message;

            container.appendChild(toast);

            requestAnimationFrame(() => {
                toast.classList.remove('translate-y-10', 'opacity-0');
                toast.classList.add('translate-y-0', 'opacity-100');
            });

            setTimeout(() => {
                toast.classList.remove('translate-y-0', 'opacity-100');
                toast.classList.add('translate-y-10', 'opacity-0');
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }
    });

    function triggerOutOfStockModal(productName) {
        const modal = document.getElementById('shopOutOfStockModal');
        const box = document.getElementById('shopModalBox');
        const nameEl = document.getElementById('shopModalProductName');

        if (nameEl && productName) {
            nameEl.textContent = productName.startsWith('“') ? productName : '“' + productName + '”';
        }

        modal.classList.remove('opacity-0', 'pointer-events-none');
        modal.classList.add('opacity-100', 'pointer-events-auto');
        box.classList.remove('scale-90');
        box.classList.add('scale-100');
    }

    function closeShopOutOfStockModal() {
        const modal = document.getElementById('shopOutOfStockModal');
        const box = document.getElementById('shopModalBox');

        modal.classList.remove('opacity-100', 'pointer-events-auto');
        modal.classList.add('opacity-0', 'pointer-events-none');
        box.classList.remove('scale-100');
        box.classList.add('scale-90');
    }

    // --- XỬ LÝ THANH LỰA CHỌN DANH MỤC HÀNG NGANG & MENU TRƯỢT XUỐNG ---
    function toggleCategoryDropdown() {
        const menu = document.getElementById('categoryDropdownMenu');
        const arrow = document.getElementById('catDropdownArrow');
        if (menu) {
            const isHidden = menu.classList.contains('hidden');
            if (isHidden) {
                menu.classList.remove('hidden');
                if (arrow) arrow.classList.add('rotate-180');
            } else {
                menu.classList.add('hidden');
                if (arrow) arrow.classList.remove('rotate-180');
            }
        }
    }

    // Đóng dropdown khi click ra ngoài
    document.addEventListener('click', function(e) {
        const wrapper = document.getElementById('categoryDropdownWrapper');
        const menu = document.getElementById('categoryDropdownMenu');
        const arrow = document.getElementById('catDropdownArrow');
        if (wrapper && menu && !wrapper.contains(e.target)) {
            menu.classList.add('hidden');
            if (arrow) arrow.classList.remove('rotate-180');
        }
    });

    // Cuộn danh mục hàng ngang (Pill track)
    function scrollCategoryPills(direction) {
        const track = document.getElementById('categoryPillsTrack');
        if (track) {
            const scrollAmount = 260;
            if (direction === 'left') {
                track.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
            } else {
                track.scrollBy({ left: scrollAmount, behavior: 'smooth' });
            }
        }
    }

    // Tự động cuộn đến danh mục đang chọn trên thanh trượt khi tải trang
    window.addEventListener('DOMContentLoaded', function() {
        const activePill = document.querySelector('#categoryPillsTrack a.active-pill');
        if (activePill) {
            activePill.scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' });
        }
    });
</script>

<!-- MODAL HẾT HÀNG CHO TRANG SHOP -->
<div id="shopOutOfStockModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm opacity-0 pointer-events-none transition-opacity duration-300">
    <div id="shopModalBox" class="bg-surface-container-lowest rounded-3xl p-8 max-w-md w-full mx-4 shadow-2xl text-center transform scale-90 transition-transform duration-300 border border-outline-variant/60 relative overflow-hidden">
        <div class="relative w-20 h-20 mx-auto mb-5 rounded-2xl bg-red-50 border border-red-200/80 flex items-center justify-center text-red-500 shadow-inner animate-bounce">
            <span class="material-symbols-outlined text-4xl">remove_shopping_cart</span>
        </div>
        <h3 class="font-headline-md text-2xl font-extrabold text-on-surface mb-2">Sản phẩm đã hết hàng!</h3>
        <p class="text-sm text-on-surface-variant leading-relaxed mb-6">
            Rất tiếc, sản phẩm <span id="shopModalProductName" class="font-bold text-red-600">này</span> tạm thời hết hàng do nhu cầu mua cao. Bạn vui lòng chọn các sản phẩm hoa quả, rau củ tươi ngon khác nhé!
        </p>
        <button type="button" onclick="closeShopOutOfStockModal()" class="w-full bg-primary text-white py-3 px-6 rounded-full font-label-bold text-sm hover:bg-primary-container transition-all shadow-[0_4px_16px_rgba(129,196,8,0.35)]">
            Đã hiểu, tôi sẽ chọn sản phẩm khác
        </button>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/web/js/banner-3d.js"></script>
</body>
</html>