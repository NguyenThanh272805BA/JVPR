<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Trang chủ - Fruitables</title>

    <!-- Nạp font Material Symbols hỗ trợ trục FILL phục vụ render sao động -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>

    <style>
        /* Hiệu ứng sóng lượn chuyển động mềm mại */
        @keyframes subtleWaveMotion {
            0% { transform: translate3d(0, 0, 0); }
            50% { transform: translate3d(-25%, 8px, 0); }
            100% { transform: translate3d(-50%, 0, 0); }
        }

        @keyframes waveFloatReverse {
            0% { transform: translate3d(-50%, 0, 0); }
            50% { transform: translate3d(-25%, -6px, 0); }
            100% { transform: translate3d(0, 0, 0); }
        }

        @keyframes gentleGlow {
            0%, 100% { opacity: 0.35; transform: scale(1) translateY(0); }
            50% { opacity: 0.6; transform: scale(1.08) translateY(-10px); }
        }

        .wave-flow-slow {
            animation: subtleWaveMotion 22s cubic-bezier(0.4, 0, 0.2, 1) infinite;
            will-change: transform;
        }

        .wave-flow-reverse {
            animation: waveFloatReverse 28s cubic-bezier(0.4, 0, 0.2, 1) infinite;
            will-change: transform;
        }

        .ambient-glow {
            animation: gentleGlow 9s ease-in-out infinite;
        }
    </style>
</head>

<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col antialiased selection:bg-primary selection:text-white">

<!-- NAVBAR DÙNG CHUNG -->
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<!-- THÔNG BÁO ĐẶT HÀNG THÀNH CÔNG TỪ CHECKOUT -->
<c:if test="${not empty sessionScope.orderSuccess}">
    <div class="bg-primary text-white text-center py-3.5 px-4 font-label-bold shadow-md flex justify-center items-center gap-2">
        <span class="material-symbols-outlined text-[20px]">check_circle</span>
        <span><c:out value="${sessionScope.orderSuccess}"/></span>
        <c:remove var="orderSuccess" scope="session"/>
    </div>
</c:if>

<!-- HERO SECTION: 3D INTERACTIVE HARVEST SHOWCASE -->
<section class="tilt-3d-stage relative w-full min-h-[580px] md:min-h-[640px] flex items-center overflow-hidden bg-gradient-to-br from-[#062410] via-[#0f3d1b] to-[#041a0b] py-12 md:py-16 perspective-1200 shadow-xl">
    <!-- Nền đa tầng không gian sâu với Mesh Gradient & Ambient Aura tươi sáng hữu cơ -->
    <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-emerald-800/40 via-[#0a3818]/70 to-[#031c0a] z-0"></div>
    <div class="absolute -top-32 -left-32 w-[42rem] h-[42rem] bg-primary/30 rounded-full blur-[130px] pointer-events-none animate-ambient-aura z-0"></div>
    <div class="absolute bottom-0 right-0 w-[36rem] h-[36rem] bg-lime-400/25 rounded-full blur-[140px] pointer-events-none animate-ambient-aura z-0" style="animation-delay: -4s;"></div>
    <div class="absolute top-1/2 left-1/3 w-80 h-80 bg-emerald-500/20 rounded-full blur-[100px] pointer-events-none z-0"></div>
    
    <!-- Lưới họa tiết công nghệ chấm mờ hữu cơ -->
    <div class="absolute inset-0 bg-[radial-gradient(#84cc16_1px,transparent_1px)] [background-size:32px_32px] opacity-20 pointer-events-none z-0"></div>

    <div class="relative z-10 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto w-full grid grid-cols-1 lg:grid-cols-12 gap-10 lg:gap-12 items-center">
        <!-- CỘT TRÁI: Typography & Lời mời gọi hành động -->
        <div class="lg:col-span-7 text-left space-y-6">
            <div class="inline-flex items-center gap-2 py-1.5 px-4 rounded-full bg-primary/25 text-lime-300 border border-primary/40 font-label-bold text-xs uppercase tracking-wider backdrop-blur-md shadow-sm">
                <span class="material-symbols-outlined text-[16px] animate-spin" style="animation-duration: 8s;">eco</span>
                <span>100% Tự Nhiên & Chuẩn VietGAP</span>
                <span class="w-1.5 h-1.5 rounded-full bg-lime-400 animate-ping"></span>
            </div>

            <h1 class="text-white font-display-lg text-[34px] sm:text-[44px] md:text-[56px] font-black leading-[1.12] tracking-tight drop-shadow-md">
                Nông sản thuần khiết,<br>
                <span class="bg-gradient-to-r from-lime-300 via-[#a3e635] to-emerald-300 bg-clip-text text-transparent">Trọn vẹn năng lượng</span><br>
                sống mỗi ngày
            </h1>

            <p class="text-emerald-100/90 font-body-lg text-sm sm:text-base md:text-lg max-w-xl leading-relaxed">
                Fruitables kết nối trực tiếp các nhà vườn hữu cơ đến bàn ăn gia đình bạn. Trái cây thượng hạng, ướp lạnh tươi mát và giao hỏa tốc chỉ trong 2 giờ.
            </p>

            <!-- Nhóm nút bấm hành động -->
            <div class="flex flex-wrap gap-4 pt-2">
                <a href="${pageContext.request.contextPath}/shop" class="relative group inline-flex items-center justify-center bg-gradient-to-r from-primary to-[#6ca305] text-white px-8 py-3.5 rounded-full font-label-bold text-base hover:shadow-[0_8px_25px_rgba(129,196,8,0.45)] hover:-translate-y-0.5 transition-all duration-300 overflow-hidden">
                    <span class="relative z-10 flex items-center gap-2">
                        Mua sắm ngay
                        <span class="material-symbols-outlined text-[20px] group-hover:translate-x-1 transition-transform">arrow_forward</span>
                    </span>
                    <div class="shimmer-layer"></div>
                </a>

                <a href="${pageContext.request.contextPath}/guest-tracking" class="inline-flex items-center justify-center bg-white/10 hover:bg-white/20 text-white border border-white/20 hover:border-white/40 backdrop-blur-md px-6 py-3.5 rounded-full font-label-bold text-base transition-all duration-300 hover:-translate-y-0.5 gap-2">
                    <span class="material-symbols-outlined text-[20px] text-lime-300">local_shipping</span>
                    Tra cứu đơn hàng
                </a>
            </div>

            <!-- Chỉ số tin cậy 3D Quick Stats -->
            <div class="pt-4 border-t border-emerald-700/40 grid grid-cols-3 gap-4 max-w-lg">
                <div class="flex items-center gap-2.5">
                    <div class="w-9 h-9 rounded-xl bg-primary/25 text-lime-300 flex items-center justify-center flex-shrink-0">
                        <span class="material-symbols-outlined text-lg">bolt</span>
                    </div>
                    <div>
                        <div class="text-white font-bold text-xs">Giao 2 Giờ</div>
                        <div class="text-[10px] text-emerald-200/75">Nội thành hỏa tốc</div>
                    </div>
                </div>

                <div class="flex items-center gap-2.5">
                    <div class="w-9 h-9 rounded-xl bg-emerald-500/25 text-emerald-300 flex items-center justify-center flex-shrink-0">
                        <span class="material-symbols-outlined text-lg">verified</span>
                    </div>
                    <div>
                        <div class="text-white font-bold text-xs">Chuẩn VietGAP</div>
                        <div class="text-[10px] text-emerald-200/75">100% hữu cơ sạch</div>
                    </div>
                </div>

                <div class="flex items-center gap-2.5">
                    <div class="w-9 h-9 rounded-xl bg-amber-500/20 text-amber-300 flex items-center justify-center flex-shrink-0">
                        <span class="material-symbols-outlined text-lg">hotel_class</span>
                    </div>
                    <div>
                        <div class="text-white font-bold text-xs">4.9 / 5.0</div>
                        <div class="text-[10px] text-emerald-200/75">50k+ Khách tin yêu</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- CỘT PHẢI: 3D CARD SHOWCASE NỔI KHỐI -->
        <div class="lg:col-span-5 flex justify-center relative">
            <!-- Thẻ 3D nghiêng tương tác theo chuột -->
            <div data-3d-tilt data-tilt-max="14" data-tilt-scale="1.03"
                 class="preserve-3d relative w-full max-w-[420px] h-[460px] rounded-3xl glass-card-3d-dark p-6 flex flex-col justify-between cursor-pointer border border-white/20 shadow-[0_30px_70px_rgba(0,0,0,0.6)]">
                
                <!-- Vệt sáng kim loại phản chiếu -->
                <div class="shimmer-layer"></div>

                <!-- Lớp trên: Header thẻ nổi (translate-z-30) -->
                <div class="translate-z-30 flex items-center justify-between z-20">
                    <span class="px-3 py-1 rounded-full bg-primary/25 border border-primary/40 text-primary text-[11px] font-bold tracking-wider uppercase flex items-center gap-1.5 shadow-sm">
                        <span class="w-2 h-2 rounded-full bg-primary animate-ping"></span> Mới thu hoạch
                    </span>
                    <span class="text-xs text-slate-300 font-semibold flex items-center gap-1 bg-white/10 px-2.5 py-1 rounded-full backdrop-blur-sm">
                        <span class="material-symbols-outlined text-amber-400 text-sm">star</span> 4.9 (5.2k)
                    </span>
                </div>

                <!-- Lớp trung tâm: Hình ảnh Giỏ trái cây 3D siêu nét và sống động (translate-z-50) -->
                <div class="translate-z-50 relative flex items-center justify-center my-auto py-2 z-10">
                    <!-- Hào quang phát sáng sau quả -->
                    <div class="absolute w-56 h-56 bg-primary/30 rounded-full blur-3xl pointer-events-none animate-pulse"></div>
                    <img src="https://images.unsplash.com/photo-1619566636858-adf3ef46400b?q=80&w=800&auto=format&fit=crop" 
                         alt="Fresh Fruits Basket 3D" 
                         class="w-72 h-56 object-cover rounded-2xl shadow-2xl border border-white/20 transform -rotate-2 hover:rotate-0 transition-transform duration-500">
                </div>

                <!-- Lớp dưới: Thông tin tóm tắt sản phẩm & Cam kết (translate-z-40) -->
                <div class="translate-z-40 bg-white/10 backdrop-blur-md rounded-2xl p-4 border border-white/15 z-20 flex items-center justify-between gap-3">
                    <div>
                        <h4 class="text-white font-bold text-sm">Hộp Trái Cây Gia Đình</h4>
                        <p class="text-[11px] text-slate-300 mt-0.5">Táo Envy, Cam Sành, Nho Đỏ, Bơ Sáp</p>
                    </div>
                    <div class="text-right">
                        <span class="text-[10px] text-primary font-bold uppercase tracking-wider block">Ưu đãi tuần</span>
                        <span class="text-white font-bold text-base font-price-tag">289.000 ₫</span>
                    </div>
                </div>

                <!-- Badge vệ tinh 1 lơ lửng bên ngoài (translate-z-60) -->
                <div class="translate-z-60 absolute -top-4 -right-4 bg-gradient-to-r from-amber-500 to-orange-500 text-white text-[11px] font-bold px-3 py-1.5 rounded-2xl shadow-xl flex items-center gap-1.5 border border-white/30 animate-float-3d">
                    <span class="material-symbols-outlined text-sm">verified</span>
                    <span>100% Organic</span>
                </div>

                <!-- Badge vệ tinh 2 lơ lửng góc dưới trái (translate-z-60) -->
                <div class="translate-z-60 absolute -bottom-4 -left-4 bg-gradient-to-r from-emerald-600 to-teal-600 text-white text-[11px] font-bold px-3 py-1.5 rounded-2xl shadow-xl flex items-center gap-1.5 border border-white/30 animate-float-3d-reverse">
                    <span class="material-symbols-outlined text-sm">ac_unit</span>
                    <span>Bảo quản lạnh 4°C</span>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- DẢI CHUYỂN TIẾP SÓNG LƯỢN TỪ BANNER XUỐNG NỘI DUNG -->
<div class="relative w-full overflow-hidden leading-none z-10 -mt-1 pointer-events-none select-none">
    <svg class="relative block w-full h-8 sm:h-12 md:h-16 text-surface" viewBox="0 0 1440 80" preserveAspectRatio="none">
        <path fill="currentColor" d="M0,32L48,42.7C96,53,192,75,288,74.7C384,75,480,53,576,42.7C672,32,768,32,864,42.7C960,53,1056,75,1152,69.3C1248,64,1344,32,1392,16L1440,0L1440,80L1392,80C1344,80,1248,80,1152,80C1056,80,960,80,864,80C768,80,672,80,576,80C480,80,384,80,288,80C192,80,96,80,48,80L0,80Z"></path>
    </svg>
</div>

<!-- FEATURES BANNERS (BACKGROUND LỚP SÓNG CHÌM) -->
<section class="relative py-12 bg-surface overflow-hidden">
    <!-- Nền vệt màu sinh thái lan tỏa nhẹ -->
    <div class="absolute -top-12 -left-20 w-80 h-80 bg-primary/10 rounded-full blur-3xl pointer-events-none ambient-glow"></div>
    <div class="absolute -bottom-16 -right-20 w-96 h-96 bg-primary/10 rounded-full blur-3xl pointer-events-none ambient-glow" style="animation-delay: 3s;"></div>

    <div class="relative z-10 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6">
        <div class="bg-surface-container-lowest/90 backdrop-blur-md p-6 rounded-2xl shadow-sm hover:shadow-md border border-outline-variant/80 hover:border-primary/50 hover:-translate-y-1 transition-all duration-300 flex items-start gap-4">
            <div class="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center text-primary flex-shrink-0">
                <span class="material-symbols-outlined text-2xl">local_shipping</span>
            </div>
            <div>
                <h3 class="font-label-bold text-on-surface mb-1">Miễn phí giao hàng</h3>
                <p class="text-xs text-on-surface-variant leading-relaxed">Áp dụng cho mọi đơn từ 500k</p>
            </div>
        </div>
        <div class="bg-surface-container-lowest/90 backdrop-blur-md p-6 rounded-2xl shadow-sm hover:shadow-md border border-outline-variant/80 hover:border-primary/50 hover:-translate-y-1 transition-all duration-300 flex items-start gap-4">
            <div class="w-12 h-12 rounded-xl bg-secondary-container/50 flex items-center justify-center text-on-secondary-container flex-shrink-0">
                <span class="material-symbols-outlined text-2xl">verified</span>
            </div>
            <div>
                <h3 class="font-label-bold text-on-surface mb-1">100% Hữu cơ</h3>
                <p class="text-xs text-on-surface-variant leading-relaxed">Đạt chuẩn kiểm định VietGAP</p>
            </div>
        </div>
        <div class="bg-surface-container-lowest/90 backdrop-blur-md p-6 rounded-2xl shadow-sm hover:shadow-md border border-outline-variant/80 hover:border-primary/50 hover:-translate-y-1 transition-all duration-300 flex items-start gap-4">
            <div class="w-12 h-12 rounded-xl bg-error-container/40 flex items-center justify-center text-error flex-shrink-0">
                <span class="material-symbols-outlined text-2xl">currency_exchange</span>
            </div>
            <div>
                <h3 class="font-label-bold text-on-surface mb-1">Đổi trả trong 24h</h3>
                <p class="text-xs text-on-surface-variant leading-relaxed">Hoàn 100% nếu quả dập nát</p>
            </div>
        </div>
        <div class="bg-surface-container-lowest/90 backdrop-blur-md p-6 rounded-2xl shadow-sm hover:shadow-md border border-outline-variant/80 hover:border-primary/50 hover:-translate-y-1 transition-all duration-300 flex items-start gap-4">
            <div class="w-12 h-12 rounded-xl bg-tertiary-container/30 flex items-center justify-center text-tertiary flex-shrink-0">
                <span class="material-symbols-outlined text-2xl">support_agent</span>
            </div>
            <div>
                <h3 class="font-label-bold text-on-surface mb-1">Hỗ trợ 24/7</h3>
                <p class="text-xs text-on-surface-variant leading-relaxed">Hotline và tư vấn tận tâm</p>
            </div>
        </div>
    </div>
</section>

<!-- DẢI PHÂN CÁCH SÓNG NỐI SECTION -->
<div class="relative w-full overflow-hidden leading-none bg-surface pointer-events-none select-none">
    <svg class="relative block w-full h-8 sm:h-12 text-[#f7faf3]" viewBox="0 0 1440 60" preserveAspectRatio="none">
        <path fill="currentColor" d="M0,0 C280,45 420,15 720,30 C1020,45 1200,10 1440,25 L1440,60 L0,60 Z"></path>
    </svg>
</div>

<!-- FEATURED PRODUCTS (CÓ HIỆU ỨNG SÓNG NỀN HOẠT HỌA TINH TẾ) -->
<section class="relative py-14 bg-gradient-to-b from-[#f7faf3] via-background to-surface flex-grow overflow-hidden">
    <!-- Layer sóng 1: Đường lượn cong động bán trong suốt -->
    <div class="absolute inset-0 pointer-events-none overflow-hidden opacity-30">
        <div class="wave-flow-slow absolute -top-10 left-0 w-[200%] h-[550px]">
            <svg class="w-full h-full" viewBox="0 0 2880 400" fill="none" preserveAspectRatio="none">
                <path d="M0,160 C360,60 720,260 1080,160 C1440,60 1800,260 2160,160 C2520,60 2880,260 3240,160 L3240,400 L0,400 Z" fill="rgba(129, 196, 8, 0.08)"/>
            </svg>
        </div>
    </div>

    <!-- Layer sóng 2: Đường lượn lồng ngược chiều tạo độ sâu thị giác -->
    <div class="absolute inset-0 pointer-events-none overflow-hidden opacity-25">
        <div class="wave-flow-reverse absolute top-16 left-0 w-[200%] h-[550px]">
            <svg class="w-full h-full" viewBox="0 0 2880 400" fill="none" preserveAspectRatio="none">
                <path d="M0,220 C420,310 780,120 1200,210 C1620,300 1980,110 2400,200 C2820,290 3180,120 3600,210 L3600,400 L0,400 Z" fill="rgba(16, 185, 129, 0.06)"/>
            </svg>
        </div>
    </div>

    <div class="relative z-10 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <div class="flex justify-between items-end mb-8">
            <div>
                <span class="text-primary font-label-bold text-xs uppercase tracking-widest block mb-1">Mùa vụ tươi ngon</span>
                <h2 class="font-headline-md text-2xl md:text-3xl font-extrabold text-on-surface mb-2">Sản phẩm nổi bật</h2>
                <p class="font-body-md text-on-surface-variant text-sm">Những sản phẩm tươi ngon được khách hàng lựa chọn nhiều nhất tuần qua</p>
            </div>
            <a href="${pageContext.request.contextPath}/shop" class="hidden md:inline-flex items-center text-primary font-label-bold text-sm hover:underline group">
                Xem toàn bộ cửa hàng <span class="material-symbols-outlined ml-1 text-base group-hover:translate-x-1 transition-transform">arrow_forward</span>
            </a>
        </div>

        <!-- Products Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <c:forEach var="item" items="${topProducts}">
                <c:set var="isOutOfStock" value="${item.stock != null && item.stock <= 0}" />
                <c:set var="hasDiscount" value="${item.discountPrice != null && item.discountPrice > 0 && item.discountPrice < item.price}" />

                <div class="bg-surface-container-lowest/95 backdrop-blur-sm rounded-2xl shadow-sm hover:shadow-xl transition-all duration-300 border border-outline-variant/80 hover:border-primary/50 overflow-hidden group flex flex-col hover:-translate-y-1 relative">
                    <!-- Ảnh sản phẩm & Huy hiệu -->
                    <a href="${pageContext.request.contextPath}/product-detail?id=${item.id}" class="relative w-full h-52 bg-surface-container overflow-hidden block">
                        <img src="${item.imageUrl}" alt="${item.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500 ${isOutOfStock ? 'grayscale opacity-75' : ''}">

                        <!-- Huy hiệu Danh mục -->
                        <div class="absolute top-3 left-3 bg-primary/95 backdrop-blur-xs text-white text-[11px] font-bold px-2.5 py-1 rounded-full shadow-sm">
                            <c:out value="${item.categoryName != null ? item.categoryName : 'Nông sản'}"/>
                        </div>

                        <!-- Huy hiệu Giảm giá (nếu có) -->
                        <c:if test="${hasDiscount}">
                            <div class="absolute top-3 right-3 bg-red-500 text-white text-[11px] font-bold px-2 py-0.5 rounded-full shadow-md animate-pulse">
                                -<fmt:formatNumber value="${(item.price - item.discountPrice) / item.price * 100}" maxFractionDigits="0"/>%
                            </div>
                        </c:if>

                        <!-- Huy hiệu Hết hàng -->
                        <c:if test="${isOutOfStock}">
                            <div class="absolute inset-0 bg-black/40 backdrop-blur-[2px] flex items-center justify-center">
                                <span class="bg-red-600 text-white font-label-bold text-xs uppercase tracking-wider px-3.5 py-1.5 rounded-full shadow-lg border border-white/20 flex items-center gap-1">
                                    <span class="material-symbols-outlined text-[16px]">remove_shopping_cart</span> Tạm hết hàng
                                </span>
                            </div>
                        </c:if>
                    </a>

                    <div class="p-5 flex flex-col flex-grow">
                        <!-- Tên sản phẩm -->
                        <a href="${pageContext.request.contextPath}/product-detail?id=${item.id}" class="hover:text-primary transition-colors">
                            <h3 class="font-label-bold text-base text-on-surface mb-2 line-clamp-1" title="${item.name}"><c:out value="${item.name}"/></h3>
                        </a>

                        <!-- Đánh giá sao & Số lượt nhận xét -->
                        <div class="flex items-center gap-2 mb-2">
                            <c:set var="rating" value="${item.avgRating != null ? item.avgRating : 5.0}" />
                            <div class="flex items-center text-yellow-500">
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

                        <!-- Số lượt mua hàng (Đã bán) -->
                        <div class="flex items-center gap-1.5 mb-3">
                            <span class="inline-flex items-center gap-1 text-[11px] font-semibold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-md border border-emerald-200/80">
                                <span class="material-symbols-outlined text-[13px]">shopping_bag</span>
                                Đã bán <span class="font-bold"><c:out value="${item.totalSold != null ? item.totalSold : 0}"/></span>
                            </span>
                            <c:if test="${not isOutOfStock && item.stock != null && item.stock <= 10}">
                                <span class="text-[11px] font-medium text-amber-600">Còn ${item.stock}</span>
                            </c:if>
                        </div>

                        <!-- Giá sản phẩm & Nút thêm giỏ / Hết hàng -->
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
                                    <button type="button" onclick="triggerOutOfStockModal('${item.name}')" class="w-10 h-10 rounded-full bg-red-100 hover:bg-red-200 text-red-600 flex items-center justify-center transition-all duration-200 shadow-sm" title="Sản phẩm đã hết hàng">
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

        <div class="mt-8 text-center md:hidden">
            <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center text-primary font-label-bold border border-primary px-6 py-2.5 rounded-full hover:bg-primary hover:text-white transition-colors text-sm">
                Xem toàn bộ cửa hàng
            </a>
        </div>
    </div>
</section>

<!-- MODAL THÔNG BÁO HẾT HÀNG (POPUP NẢY LÊN GIỮA MÀN HÌNH) -->
<div id="outOfStockModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm opacity-0 pointer-events-none transition-opacity duration-300">
    <div id="modalBox" class="bg-surface-container-lowest rounded-3xl p-8 max-w-md w-full mx-4 shadow-2xl text-center transform scale-90 transition-transform duration-300 border border-outline-variant/60 relative overflow-hidden">
        <!-- Đốm trang trí nền -->
        <div class="absolute -top-12 -right-12 w-32 h-32 bg-red-100 rounded-full blur-2xl pointer-events-none"></div>
        <div class="absolute -bottom-12 -left-12 w-32 h-32 bg-amber-100 rounded-full blur-2xl pointer-events-none"></div>

        <!-- Icon nảy động -->
        <div class="relative w-20 h-20 mx-auto mb-5 rounded-2xl bg-red-50 border border-red-200/80 flex items-center justify-center text-red-500 shadow-inner animate-bounce">
            <span class="material-symbols-outlined text-4xl">remove_shopping_cart</span>
        </div>

        <!-- Nội dung thông báo -->
        <h3 class="font-headline-md text-2xl font-extrabold text-on-surface mb-2">Sản phẩm đã hết hàng!</h3>
        <p class="text-sm text-on-surface-variant leading-relaxed mb-6">
            Rất tiếc, sản phẩm <span id="modalProductName" class="font-bold text-red-600">này</span> tạm thời hết hàng do nhu cầu mua cao. Hệ thống sẽ chuyển hướng bạn đến <b class="text-primary">Cửa hàng</b> trong <span id="modalCountdown" class="font-bold text-primary text-base">3</span> giây để chọn các sản phẩm tươi ngon khác!
        </p>

        <!-- Thanh đếm tiến trình -->
        <div class="w-full bg-surface-container rounded-full h-1.5 mb-6 overflow-hidden">
            <div id="modalProgressBar" class="bg-primary h-full w-full transition-all duration-1000 ease-linear"></div>
        </div>

        <!-- Nút hành động -->
        <div class="flex flex-col sm:flex-row gap-3">
            <a href="${pageContext.request.contextPath}/shop" class="flex-1 inline-flex items-center justify-center gap-2 bg-primary text-white py-3 px-5 rounded-full font-label-bold text-sm hover:bg-primary-container transition-all shadow-[0_4px_16px_rgba(129,196,8,0.35)] hover:-translate-y-0.5">
                <span>Đến Cửa hàng ngay</span>
                <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
            </a>
            <button type="button" onclick="closeOutOfStockModal()" class="inline-flex items-center justify-center py-3 px-5 rounded-full font-label-bold text-sm text-on-surface-variant hover:bg-surface-container transition-colors border border-outline-variant/60">
                Ở lại trang này
            </button>
        </div>
    </div>
</div>

<!-- FOOTER DÙNG CHUNG -->
<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<!-- AJAX ADD TO CART & OUT OF STOCK MODAL SCRIPT -->
<script>
    let countdownTimer = null;

    function triggerOutOfStockModal(productName) {
        const modal = document.getElementById('outOfStockModal');
        const box = document.getElementById('modalBox');
        const nameEl = document.getElementById('modalProductName');
        const countdownEl = document.getElementById('modalCountdown');
        const progressBar = document.getElementById('modalProgressBar');

        if (nameEl && productName) {
            nameEl.textContent = '“' + productName + '”';
        }

        modal.classList.remove('opacity-0', 'pointer-events-none');
        modal.classList.add('opacity-100', 'pointer-events-auto');
        box.classList.remove('scale-90');
        box.classList.add('scale-100');

        let secondsLeft = 3;
        if (countdownEl) countdownEl.textContent = secondsLeft;
        if (progressBar) progressBar.style.width = '100%';

        if (countdownTimer) clearInterval(countdownTimer);

        countdownTimer = setInterval(function() {
            secondsLeft--;
            if (countdownEl) countdownEl.textContent = secondsLeft;
            if (progressBar) progressBar.style.width = (secondsLeft / 3 * 100) + '%';

            if (secondsLeft <= 0) {
                clearInterval(countdownTimer);
                window.location.href = '${pageContext.request.contextPath}/shop';
            }
        }, 1000);
    }

    function closeOutOfStockModal() {
        const modal = document.getElementById('outOfStockModal');
        const box = document.getElementById('modalBox');

        if (countdownTimer) clearInterval(countdownTimer);

        modal.classList.remove('opacity-100', 'pointer-events-auto');
        modal.classList.add('opacity-0', 'pointer-events-none');
        box.classList.remove('scale-100');
        box.classList.add('scale-90');
    }

    document.addEventListener('DOMContentLoaded', function() {
        // Tự động bật Modal nếu URL có tham số ?outOfStock=1 hoặc có session báo hết hàng
        const urlParams = new URLSearchParams(window.location.search);
        <c:if test="${not empty sessionScope.OUT_OF_STOCK_PRODUCT_NAME}">
            triggerOutOfStockModal('<c:out value="${sessionScope.OUT_OF_STOCK_PRODUCT_NAME}"/>');
            <c:remove var="OUT_OF_STOCK_PRODUCT_NAME" scope="session"/>
        </c:if>
        if (urlParams.get('outOfStock') === '1') {
            triggerOutOfStockModal('sản phẩm');
        }

        const addCartForms = document.querySelectorAll('form[action$="/cart"]');

        addCartForms.forEach(form => {
            const actionInput = form.querySelector('input[name="action"][value="add"]');
            if (actionInput) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();
                    const currentForm = this;
                    const formData = new FormData(currentForm);
                    const data = new URLSearchParams(formData);

                    fetch('${pageContext.request.contextPath}/api/add-to-cart', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: data.toString()
                    })
                    .then(res => res.json())
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
                    .catch(() => showToast('Có lỗi xảy ra, vui lòng thử lại.', 'error'));
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

            toast.className = 'px-5 py-3 rounded-xl shadow-lg text-white font-label-bold transition-all duration-300 transform translate-y-10 opacity-0 flex items-center gap-2 text-sm ' + bgColor;
            toast.innerHTML = '<span class="material-symbols-outlined text-lg">' + icon + '</span> ' + message;
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
</script>
<script src="${pageContext.request.contextPath}/assets/web/js/banner-3d.js"></script>
</body>
</html>