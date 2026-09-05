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

<!-- HERO SECTION (GIỮ NGUYÊN HOÀN TOÀN) -->
<section class="relative w-full bg-surface-container h-[480px] md:h-[560px] flex items-center overflow-hidden">
    <div class="absolute inset-0 bg-cover bg-center" style="background-image: url('https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1974&auto=format&fit=crop');"></div>
    <div class="absolute inset-0 bg-gradient-to-r from-black/85 via-black/50 to-transparent"></div>

    <div class="relative z-10 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto w-full">
        <span class="inline-block py-1 px-3.5 rounded-full bg-primary/20 text-primary border border-primary/40 font-label-bold text-xs uppercase tracking-wider mb-4 backdrop-blur-sm">
            100% Tự Nhiên & Hữu Cơ
        </span>
        <h1 class="text-white font-display-lg text-[36px] md:text-[54px] font-extrabold max-w-2xl leading-tight mb-4 drop-shadow-md">
            Thực phẩm sạch,<br><span class="text-primary">Sức khỏe</span> vàng cho gia đình
        </h1>
        <p class="text-white/90 font-body-lg text-base md:text-lg mb-8 max-w-lg leading-relaxed">
            Fruitables cam kết cung cấp trái cây tươi ngon và rau củ đạt chứng nhận VietGAP mỗi ngày. Giao siêu tốc tận cửa chỉ trong 2 giờ.
        </p>
        <div class="flex flex-wrap gap-4">
            <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center justify-center bg-primary text-white px-8 py-3.5 rounded-full font-label-bold text-base hover:bg-primary-container transition-all duration-300 shadow-[0_4px_16px_rgba(129,196,8,0.35)] hover:-translate-y-0.5">
                Mua sắm ngay
                <span class="material-symbols-outlined ml-2 text-[20px]">arrow_forward</span>
            </a>
            <a href="${pageContext.request.contextPath}/guest-tracking" class="inline-flex items-center justify-center bg-white/10 hover:bg-white/20 text-white border border-white/30 backdrop-blur-sm px-6 py-3.5 rounded-full font-label-bold text-base transition-all">
                Tra cứu đơn hàng
            </a>
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
                <div class="bg-surface-container-lowest/95 backdrop-blur-sm rounded-2xl shadow-sm hover:shadow-xl transition-all duration-300 border border-outline-variant/80 hover:border-primary/50 overflow-hidden group flex flex-col hover:-translate-y-1">
                    <a href="${pageContext.request.contextPath}/product-detail?id=${item.id}" class="relative w-full h-52 bg-surface-container overflow-hidden block">
                        <img src="${item.imageUrl}" alt="${item.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <div class="absolute top-3 left-3 bg-primary/95 backdrop-blur-xs text-white text-[11px] font-bold px-2.5 py-1 rounded-full shadow-sm">
                            <c:out value="${item.categoryName != null ? item.categoryName : 'Nông sản'}"/>
                        </div>
                    </a>

                    <div class="p-5 flex flex-col flex-grow">
                        <a href="${pageContext.request.contextPath}/product-detail?id=${item.id}" class="hover:text-primary transition-colors">
                            <h3 class="font-label-bold text-base text-on-surface mb-2 line-clamp-1"><c:out value="${item.name}"/></h3>
                        </a>

                        <!-- ĐÃ CẬP NHẬT: Render số sao chính xác (Hỗ trợ sao nguyên, nửa sao, sao rỗng và tổng review thực tế) -->
                        <div class="flex items-center gap-1.5 mb-3">
                            <c:set var="rating" value="${item.avgRating != null ? item.avgRating : 0}" />
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
                            <span class="text-xs text-on-surface-variant font-medium ml-0.5">(${item.reviewCount != null ? item.reviewCount : 0})</span>
                        </div>

                        <div class="mt-auto flex items-center justify-between pt-2">
                            <span class="font-price-tag text-lg text-primary font-bold">
                                <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                            </span>

                            <form action="${pageContext.request.contextPath}/cart" method="POST">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${item.id}">
                                <button type="submit" class="w-10 h-10 rounded-full bg-surface-container hover:bg-primary hover:text-white text-primary flex items-center justify-center transition-colors shadow-sm" title="Thêm vào giỏ">
                                    <span class="material-symbols-outlined text-[20px]">add_shopping_cart</span>
                                </button>
                            </form>
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

<!-- FOOTER DÙNG CHUNG -->
<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<!-- AJAX ADD TO CART & TOAST -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const addCartForms = document.querySelectorAll('form[action$="/cart"]');

        addCartForms.forEach(form => {
            const actionInput = form.querySelector('input[name="action"][value="add"]');
            if (actionInput) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();
                    const formData = new FormData(this);
                    const data = new URLSearchParams(formData);

                    fetch('${pageContext.request.contextPath}/api/add-to-cart', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: data.toString()
                    })
                    .then(res => res.json())
                    .then(res => {
                        if (res.status === 'success') {
                            updateCartBadge(res.totalItems);
                            showToast(res.message, 'success');
                        } else {
                            showToast(res.message, 'error');
                        }
                    })
                    .catch(() => showToast('Có lỗi xảy ra, vui lòng thử lại.', 'error'));
                });
            }
        });

        function updateCartBadge(total) {
            const cartLink = document.querySelector('a[href$="/cart"]');
            if (cartLink) {
                let badge = cartLink.querySelector('span.bg-error');
                if (!badge && total > 0) {
                    badge = document.createElement('span');
                    badge.className = 'absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center';
                    cartLink.appendChild(badge);
                }
                if (badge) badge.textContent = total;
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
</body>
</html>