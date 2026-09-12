<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Khuyến mãi & Ưu đãi - Fruitables</title>

  <!-- Google Material Symbols -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>

  <style>
    @keyframes floatOrb {
      0%, 100% { transform: translate(0px, 0px) scale(1); }
      33% { transform: translate(35px, -45px) scale(1.08); }
      66% { transform: translate(-25px, 25px) scale(0.94); }
    }
    .animate-float-slow {
      animation: floatOrb 14s infinite ease-in-out;
    }
    .animate-float-reverse {
      animation: floatOrb 18s infinite ease-in-out reverse;
    }
    .ticket-cutout-left {
      position: absolute;
      left: -10px;
      bottom: 58px;
      width: 20px;
      height: 20px;
      border-radius: 9999px;
      background-color: #f8fafc;
      box-shadow: inset -2px 0 3px rgba(0,0,0,0.04);
    }
    .ticket-cutout-right {
      position: absolute;
      right: -10px;
      bottom: 58px;
      width: 20px;
      height: 20px;
      border-radius: 9999px;
      background-color: #f8fafc;
      box-shadow: inset 2px 0 3px rgba(0,0,0,0.04);
    }
  </style>
</head>

<body class="bg-[#f8fafc] text-[#1e293b] font-body-md min-h-screen flex flex-col antialiased relative selection:bg-primary/20 selection:text-primary">

<!-- HIỆU ỨNG NỀN ĐỘNG AMBIENT GLOW -->
<div class="fixed inset-0 overflow-hidden pointer-events-none -z-10">
  <div class="absolute -top-32 -left-32 w-[34rem] h-[34rem] bg-[#81c408]/15 rounded-full blur-[110px] animate-float-slow"></div>
  <div class="absolute top-1/3 -right-36 w-[30rem] h-[30rem] bg-amber-300/15 rounded-full blur-[120px] animate-float-reverse"></div>
  <div class="absolute -bottom-36 left-1/4 w-[38rem] h-[38rem] bg-emerald-400/15 rounded-full blur-[130px] animate-float-slow"></div>
  <div class="absolute inset-0 bg-[radial-gradient(#cbd5e1_1px,transparent_1px)] [background-size:24px_24px] opacity-35"></div>
</div>

<!-- NHÚNG NAVBAR ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<!-- HERO BANNER: 3D GOLDEN VOUCHER & FLASH SALE VAULT -->
<section class="tilt-3d-stage relative w-full text-white py-12 md:py-18 bg-gradient-to-br from-[#062410] via-[#113819] to-[#041a0b] overflow-hidden perspective-1200 shadow-xl">
  <!-- Nền không gian sâu với quầng hào quang màu hổ phách và xanh ngọc hữu cơ -->
  <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-emerald-800/35 via-[#0d3618]/70 to-[#031c0a] z-0"></div>
  <div class="absolute -top-28 -left-28 w-[34rem] h-[34rem] bg-amber-500/25 rounded-full blur-[120px] pointer-events-none animate-ambient-aura z-0"></div>
  <div class="absolute -bottom-28 right-0 w-[36rem] h-[36rem] bg-primary/30 rounded-full blur-[130px] pointer-events-none animate-ambient-aura z-0" style="animation-delay: -3.5s;"></div>
  <div class="absolute inset-0 bg-[radial-gradient(#84cc16_1px,transparent_1px)] [background-size:30px_30px] opacity-15 pointer-events-none z-0"></div>

  <div class="relative max-w-container-max-width mx-auto px-margin-mobile md:px-margin-desktop z-10 grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
    <!-- Cột trái: Tiêu đề & Thông điệp -->
    <div class="lg:col-span-7 text-left space-y-4">
      <div class="inline-flex items-center gap-2 bg-gradient-to-r from-amber-500 to-orange-600 text-white text-xs font-bold px-4 py-1.5 rounded-full uppercase tracking-wider shadow-lg shadow-orange-500/30 border border-white/20">
        <span class="material-symbols-outlined text-[16px] animate-pulse">local_fire_department</span>
        Săn Voucher & Flash Sale Độc Quyền
      </div>

      <h1 class="font-display-lg text-3xl sm:text-4xl md:text-5xl font-black tracking-tight text-white drop-shadow-lg leading-tight">
        Kho Ưu Đãi Trái Cây &<br>
        <span class="bg-gradient-to-r from-amber-400 via-orange-400 to-rose-400 bg-clip-text text-transparent">Voucher Giảm Đến 50%</span>
      </h1>

      <p class="font-body-lg text-slate-300 text-sm md:text-base max-w-xl leading-relaxed">
        Sưu tầm ngay các mã giảm giá vận chuyển và phiếu quà tặng thành viên để tận hưởng hoa quả sạch, tươi mát mỗi ngày với chi phí tiết kiệm nhất.
      </p>

      <div class="flex flex-wrap gap-4 pt-2 text-xs text-slate-300">
        <div class="flex items-center gap-1.5 bg-white/10 px-3.5 py-2 rounded-xl backdrop-blur-md border border-white/10">
          <span class="material-symbols-outlined text-amber-400 text-base">check_circle</span> Tự động trừ khi thanh toán
        </div>
        <div class="flex items-center gap-1.5 bg-white/10 px-3.5 py-2 rounded-xl backdrop-blur-md border border-white/10">
          <span class="material-symbols-outlined text-primary text-base">local_shipping</span> Freeship đơn từ 300.000₫
        </div>
      </div>
    </div>

    <!-- Cột phải: Thẻ 3D Golden VIP Ticket lơ lửng -->
    <div class="lg:col-span-5 flex justify-center relative">
      <div data-3d-tilt data-tilt-max="14" data-tilt-scale="1.03"
           class="preserve-3d relative w-full max-w-[380px] rounded-3xl p-6 glass-card-3d-dark border border-amber-400/30 shadow-[0_25px_60px_rgba(245,158,11,0.2)] cursor-pointer">
        
        <div class="shimmer-layer"></div>

        <!-- Layer z-30: Header voucher -->
        <div class="translate-z-30 flex items-center justify-between border-b border-amber-400/20 pb-3 mb-4">
          <div class="flex items-center gap-2">
            <div class="w-8 h-8 rounded-full bg-gradient-to-br from-amber-400 to-orange-500 flex items-center justify-center text-slate-950 font-black text-xs shadow-md">
              FP
            </div>
            <div>
              <div class="text-[11px] font-bold text-amber-300 uppercase tracking-wider">FRUITABLES PASS</div>
              <div class="text-[9px] text-slate-400">Phiếu ưu đãi thành viên</div>
            </div>
          </div>
          <span class="px-2.5 py-0.5 rounded-full bg-amber-400/20 text-amber-300 text-[10px] font-bold border border-amber-400/40">VIP PASS</span>
        </div>

        <!-- Layer z-50: Trung tâm giảm giá nổi khối -->
        <div class="translate-z-50 text-center py-4 bg-gradient-to-b from-amber-500/10 to-orange-500/5 rounded-2xl border border-amber-400/20 my-2">
          <div class="text-3xl md:text-4xl font-black font-price-tag bg-gradient-to-r from-amber-300 via-yellow-200 to-amber-400 bg-clip-text text-transparent drop-shadow">
            GIẢM 50.000 ₫
          </div>
          <p class="text-xs text-slate-300 mt-1">Áp dụng cho mọi đơn hoa quả từ 299.000 ₫</p>
          
          <div class="mt-3 inline-flex items-center gap-2 bg-slate-900/80 border border-amber-400/40 px-4 py-1.5 rounded-xl">
            <span class="font-mono text-sm font-bold text-amber-300 tracking-wider">FRUIT50K</span>
            <span class="text-[10px] text-slate-400">(Bấm để lưu mã)</span>
          </div>
        </div>

        <!-- Layer z-40: Footer voucher -->
        <div class="translate-z-40 flex items-center justify-between text-[11px] text-slate-400 pt-3 border-t border-amber-400/20">
          <span class="flex items-center gap-1"><span class="material-symbols-outlined text-xs text-amber-400">schedule</span> HSD: 7 ngày tới</span>
          <span class="text-amber-300 font-bold">Số lượng có hạn</span>
        </div>

        <!-- Huy hiệu 3D nổi hẳn lên trên (translate-z-60) -->
        <div class="translate-z-60 absolute -top-3 -right-3 bg-gradient-to-r from-rose-500 to-amber-500 text-white text-[10px] font-bold px-3 py-1 rounded-full shadow-lg border border-white/30 animate-float-3d">
          🔥 HOT DEAL HÔM NAY
        </div>
      </div>
    </div>
  </div>
</section>

<!-- MAIN CONTENT: DANH SÁCH VOUCHER & FLASH SALE -->
<main class="flex-grow py-12">
  <div class="max-w-container-max-width mx-auto px-margin-mobile md:px-margin-desktop">

    <!-- THÔNG BÁO CHO KHÁCH CHƯA ĐĂNG NHẬP -->
    <c:if test="${empty sessionScope.USERMODEL}">
      <div class="mb-10 p-5 bg-white/80 backdrop-blur-md border border-primary/20 rounded-2xl flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 shadow-[0_8px_30px_rgb(0,0,0,0.04)] hover:border-primary/40 transition-all duration-300">
        <div class="flex items-center gap-4">
          <div class="w-12 h-12 rounded-xl bg-primary/10 text-primary flex items-center justify-center flex-shrink-0">
            <span class="material-symbols-outlined text-2xl">loyalty</span>
          </div>
          <div>
            <h4 class="font-label-bold text-gray-900 text-base">Bạn chưa kích hoạt quyền lợi thành viên?</h4>
            <p class="text-xs sm:text-sm text-gray-600 mt-0.5">Đăng nhập tài khoản để nhận và áp dụng mã giảm giá trực tiếp vào hóa đơn thanh toán.</p>
          </div>
        </div>
        <a href="${pageContext.request.contextPath}/login" class="px-6 py-2.5 bg-gradient-to-r from-primary to-[#6ca305] text-white text-xs sm:text-sm font-label-bold rounded-full hover:shadow-lg hover:shadow-primary/25 hover:-translate-y-0.5 transition-all duration-300 whitespace-nowrap">
          Đăng nhập ngay
        </a>
      </div>
    </c:if>

    <!-- TAB BỘ LỌC CHUYỂN ĐỔI NHANH MỤC KHUYẾN MÃI -->
    <div class="flex items-center justify-center gap-3 mb-10 overflow-x-auto py-1 scrollbar-none" id="promo-tab-container">
      <button type="button" onclick="switchPromoTab('all')" id="tab-btn-all"
              class="promo-tab-btn px-5 py-2.5 rounded-full text-xs sm:text-sm font-bold transition-all duration-300 flex items-center gap-2 shadow-sm bg-primary text-white">
        <span class="material-symbols-outlined text-[18px]">apps</span>
        Tất cả ưu đãi
      </button>
      <button type="button" onclick="switchPromoTab('coupons')" id="tab-btn-coupons"
              class="promo-tab-btn px-5 py-2.5 rounded-full text-xs sm:text-sm font-bold transition-all duration-300 flex items-center gap-2 shadow-sm bg-white text-slate-700 hover:bg-slate-50 border border-slate-200">
        <span class="material-symbols-outlined text-[18px] text-primary">confirmation_number</span>
        Mã khuyến mãi & Voucher
      </button>
      <button type="button" onclick="switchPromoTab('flash-sale')" id="tab-btn-flash-sale"
              class="promo-tab-btn px-5 py-2.5 rounded-full text-xs sm:text-sm font-bold transition-all duration-300 flex items-center gap-2 shadow-sm bg-white text-slate-700 hover:bg-slate-50 border border-slate-200">
        <span class="material-symbols-outlined text-[18px] text-rose-500">local_fire_department</span>
        Sản phẩm Flash Sale
      </button>
    </div>

    <!-- PHẦN 1: DANH SÁCH MÃ GIẢM GIÁ / VOUCHER -->
    <section id="coupons-section" class="scroll-mt-28 transition-all duration-300">
      <!-- TIÊU ĐỀ PHẦN VOUCHER -->
      <div class="flex items-center justify-between mb-8">
        <div>
          <h2 class="font-headline-md text-2xl md:text-3xl font-black text-gray-900 flex items-center gap-2.5">
            <span class="material-symbols-outlined text-primary text-3xl">redeem</span> Mã Giảm Giá Đang Có Sẵn
          </h2>
          <p class="text-xs md:text-sm text-gray-500 mt-1">Lưu hoặc sao chép mã voucher và dán vào bước thanh toán đơn hàng</p>
        </div>
      </div>

    <!-- DANH SÁCH VOUCHER DẠNG TICKET NGHỆ THUẬT -->
    <jsp:useBean id="nowDate" class="java.util.Date" />
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <c:forEach var="coupon" items="${coupons}">
        <c:set var="diffMs" value="${coupon.endDate.time - nowDate.time}" />
        <c:set var="diffHours" value="${diffMs / 3600000}" />
        <c:set var="isExpired" value="${diffMs <= 0}" />
        <c:set var="isExpiringSoon" value="${diffMs > 0 && diffHours <= 48}" />

        <div class="group bg-white/90 backdrop-blur-sm rounded-2xl shadow-[0_4px_20px_rgba(0,0,0,0.03)] border ${isExpired ? 'border-slate-300 opacity-65 grayscale-[25%]' : (isExpiringSoon ? 'border-amber-400 shadow-[0_8px_25px_rgba(245,158,11,0.18)]' : 'border-slate-200/90 hover:border-primary/50 hover:shadow-[0_12px_30px_rgba(129,196,8,0.14)]')} hover:-translate-y-1 transition-all duration-300 flex flex-col relative overflow-hidden">
          <!-- Dải ruy băng góc trái -->
          <div class="absolute left-0 top-0 bottom-0 w-2 ${isExpired ? 'bg-slate-400' : (isExpiringSoon ? 'bg-gradient-to-b from-amber-500 to-orange-500' : 'bg-gradient-to-b from-primary to-[#6ca305]')}"></div>

          <!-- Lỗ khuyết vé coupon -->
          <div class="ticket-cutout-left"></div>
          <div class="ticket-cutout-right"></div>

          <div class="p-6 pl-7 flex flex-col flex-grow">
            <!-- Header vé -->
            <div class="flex justify-between items-start mb-4 gap-2">
              <div class="flex flex-wrap gap-1.5 items-center">
                <span class="text-[11px] font-bold uppercase tracking-wider px-2.5 py-1 bg-slate-100 text-slate-700 rounded-md">
                  <c:choose>
                    <c:when test="${coupon.discountType == 'FIXED'}">Tiền mặt</c:when>
                    <c:otherwise>Theo %</c:otherwise>
                  </c:choose>
                </span>

                <c:choose>
                  <c:when test="${not empty coupon.productName}">
                    <span class="text-[11px] font-bold px-2.5 py-1 bg-purple-50 text-purple-700 rounded-md border border-purple-200 flex items-center gap-1" title="Áp dụng riêng cho ${coupon.productName}">
                      <span class="material-symbols-outlined text-[13px]">inventory_2</span> <c:out value="${coupon.productName}"/>
                    </span>
                  </c:when>
                  <c:otherwise>
                    <c:choose>
                      <c:when test="${coupon.targetAudience == 'GMAIL'}">
                        <span class="text-[11px] font-bold px-2.5 py-1 bg-rose-50 text-rose-600 rounded-md border border-rose-100">Dành riêng Gmail</span>
                      </c:when>
                      <c:when test="${coupon.targetAudience == 'REGULAR'}">
                        <span class="text-[11px] font-bold px-2.5 py-1 bg-blue-50 text-blue-600 rounded-md border border-blue-100">Thành viên thường</span>
                      </c:when>
                      <c:otherwise>
                        <span class="text-[11px] font-bold px-2.5 py-1 bg-emerald-50 text-emerald-700 rounded-md border border-emerald-100">Tất cả khách hàng</span>
                      </c:otherwise>
                    </c:choose>
                  </c:otherwise>
                </c:choose>
              </div>

              <!-- Cảnh báo thời gian / HSD -->
              <div>
                <c:choose>
                  <c:when test="${isExpired}">
                    <span class="text-[11px] font-bold text-red-700 bg-red-100 px-2.5 py-1 rounded-md border border-red-200 inline-flex items-center gap-1">
                      <span class="material-symbols-outlined text-[14px]">event_busy</span> Đã hết hạn
                    </span>
                  </c:when>
                  <c:when test="${isExpiringSoon}">
                    <span class="text-[11px] font-bold text-amber-800 bg-amber-100 px-2.5 py-1 rounded-md border border-amber-300 inline-flex items-center gap-1 animate-pulse">
                      <span class="material-symbols-outlined text-[14px]">alarm</span> Sắp hết hạn (<fmt:formatNumber value="${diffHours}" maxFractionDigits="0"/>h nữa)
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="text-[11px] font-medium text-slate-500 whitespace-nowrap bg-slate-50 px-2.5 py-1 rounded border border-slate-200">
                      HSD: <fmt:formatDate value="${coupon.endDate}" pattern="dd/MM/yyyy"/>
                    </span>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>

            <!-- Giá trị Voucher -->
            <div class="my-1">
              <span class="text-xs text-slate-400 font-medium block mb-0.5">Mức chiết khấu</span>
              <h3 class="font-headline-md text-3xl ${isExpired ? 'text-slate-500' : 'text-primary'} font-black tracking-tight group-hover:scale-[1.02] transition-transform">
                <c:choose>
                  <c:when test="${coupon.discountType == 'FIXED'}">
                    -<fmt:formatNumber value="${coupon.discountValue}" type="number" groupingUsed="true"/> ₫
                  </c:when>
                  <c:otherwise>
                    -<c:out value="${coupon.discountValue}"/>%
                  </c:otherwise>
                </c:choose>
              </h3>
            </div>

            <div class="flex flex-col gap-1 mb-5 text-xs text-slate-500">
              <p>Áp dụng đơn từ: <b class="text-slate-800 font-bold"><fmt:formatNumber value="${coupon.minOrderValue}" type="number" groupingUsed="true"/> ₫</b></p>
              <c:if test="${not empty coupon.productName}">
                <p class="text-purple-600 font-medium flex items-center gap-1">
                  <span class="material-symbols-outlined text-[14px]">check_circle</span> Chỉ áp dụng cho: <strong><c:out value="${coupon.productName}"/></strong>
                </p>
              </c:if>
            </div>

            <!-- Đường cắt đứt khúc vé -->
            <div class="border-t border-dashed border-slate-200 -mx-6 mb-4"></div>

            <!-- Bottom: Mã Code & Thao tác -->
            <div class="mt-auto flex items-center justify-between gap-3">
              <div class="flex items-center gap-1.5 bg-slate-50 border border-dashed ${isExpired ? 'border-slate-300 opacity-60 cursor-not-allowed' : 'border-slate-300 hover:border-primary cursor-pointer'} px-3 py-1.5 rounded-xl transition-colors"
                   <c:if test="${!isExpired}">onclick="copyCode('${coupon.code}', this)" title="Bấm để sao chép mã"</c:if>>
                <span class="font-mono font-extrabold ${isExpired ? 'text-slate-400' : 'text-slate-800'} text-sm tracking-widest uppercase"><c:out value="${coupon.code}"/></span>
                <c:if test="${!isExpired}">
                  <span class="material-symbols-outlined text-slate-400 text-base group-hover:text-primary">content_copy</span>
                </c:if>
              </div>

              <c:choose>
                <c:when test="${isExpired}">
                  <button type="button" disabled class="text-xs bg-slate-200 text-slate-400 px-4 py-2 rounded-full font-label-bold cursor-not-allowed">
                    Đã hết hạn
                  </button>
                </c:when>
                <c:when test="${not empty sessionScope.USERMODEL}">
                  <a href="${pageContext.request.contextPath}/shop" class="text-xs bg-primary hover:bg-[#6ca305] text-white px-4 py-2 rounded-full font-label-bold transition-all shadow-sm hover:shadow hover:-translate-y-0.5">
                    Dùng ngay
                  </a>
                </c:when>
                <c:otherwise>
                  <a href="${pageContext.request.contextPath}/login" class="text-xs bg-slate-100 text-slate-600 px-3.5 py-2 rounded-full font-label-bold hover:bg-primary hover:text-white transition-all">
                    Đăng nhập
                  </a>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
    </section>

    <!-- PHẦN 2: FLASH SALE SECTION -->
    <c:if test="${not empty flashSaleProducts}">
      <section id="flash-sale-section" class="scroll-mt-28 transition-all duration-300 mt-20 border-t border-slate-200/80 pt-12">
        <div class="flex items-center justify-between mb-8">
          <div>
            <div class="inline-flex items-center gap-1.5 text-xs font-extrabold uppercase tracking-wider text-rose-500 mb-1">
              <span class="w-2 h-2 rounded-full bg-rose-500 animate-ping"></span> Giờ vàng giá sốc
            </div>
            <h2 class="font-display-md text-2xl md:text-3xl font-black text-slate-900 flex items-center gap-2">
              <span class="material-symbols-outlined text-rose-500 text-3xl md:text-4xl">local_fire_department</span>
              Sản Phẩm Flash Sale
            </h2>
          </div>
          <a href="${pageContext.request.contextPath}/shop" class="group text-primary font-bold hover:text-[#6ca305] text-sm flex items-center gap-1 transition-colors">
            Xem tất cả <span class="material-symbols-outlined text-sm group-hover:translate-x-1 transition-transform">arrow_forward</span>
          </a>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5 md:gap-6">
          <c:forEach var="product" items="${flashSaleProducts}">
            <div class="group bg-white/90 backdrop-blur-sm rounded-2xl shadow-[0_4px_20px_rgba(0,0,0,0.03)] border border-slate-200/90 overflow-hidden hover:shadow-[0_14px_30px_rgba(244,63,94,0.12)] hover:border-rose-300 hover:-translate-y-1 transition-all duration-300 flex flex-col relative">

              <!-- Badge % Giảm Sốc -->
              <div class="absolute top-3 left-3 bg-gradient-to-r from-rose-500 to-amber-500 text-white text-[11px] font-black px-2.5 py-1 rounded-lg z-10 shadow-md flex items-center gap-0.5">
                <span class="material-symbols-outlined text-[13px]">bolt</span>
                -<fmt:formatNumber value="${(product.price - product.discountPrice) / product.price * 100}" maxFractionDigits="0"/>%
              </div>

              <!-- Product Image -->
              <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}" class="aspect-square bg-slate-50 overflow-hidden block relative">
                <img src="${product.imageUrl}" alt="${product.name}" class="w-full h-full object-cover group-hover:scale-108 transition-transform duration-500">
                <div class="absolute inset-0 bg-black/0 group-hover:bg-black/5 transition-colors"></div>
              </a>

              <!-- Card Body -->
              <div class="p-4 md:p-5 flex flex-col flex-grow">
                <p class="text-[11px] text-slate-400 font-semibold uppercase tracking-wider mb-1"><c:out value="${product.categoryName}"/></p>
                <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}">
                  <h3 class="font-bold text-slate-800 text-sm md:text-base mb-2 truncate group-hover:text-primary transition-colors" title="${product.name}">
                    <c:out value="${product.name}"/>
                  </h3>
                </a>

                <div class="flex flex-wrap items-baseline gap-2 mb-5">
                  <span class="text-rose-600 font-black text-lg"><fmt:formatNumber value="${product.discountPrice}" type="number" groupingUsed="true"/> ₫</span>
                  <span class="text-slate-400 text-xs line-through"><fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> ₫</span>
                </div>

                <form action="${pageContext.request.contextPath}/cart" method="POST" class="mt-auto">
                  <input type="hidden" name="action" value="add">
                  <input type="hidden" name="productId" value="${product.id}">
                  <button type="submit" class="w-full py-2.5 bg-gradient-to-r from-rose-50 to-orange-50 text-rose-600 font-bold rounded-xl border border-rose-200/80 hover:from-rose-500 hover:to-orange-500 hover:text-white hover:border-transparent transition-all duration-300 flex justify-center items-center gap-1.5 text-xs md:text-sm shadow-sm">
                    <span class="material-symbols-outlined text-base">add_shopping_cart</span> Thêm vào giỏ
                  </button>
                </form>
              </div>
            </div>
          </c:forEach>
        </div>
      </section>
    </c:if>

  </div>
</main>

<!-- NHÚNG FOOTER ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<script>
  function copyCode(code, el) {
    navigator.clipboard.writeText(code).then(() => {
      const originalHtml = el.innerHTML;
      el.innerHTML = '<span class="text-primary font-bold text-xs">Đã sao chép!</span>';
      setTimeout(() => {
        el.innerHTML = originalHtml;
      }, 1500);
    });
  }

  function switchPromoTab(tab) {
    const couponsSec = document.getElementById('coupons-section');
    const flashSaleSec = document.getElementById('flash-sale-section');
    const btnAll = document.getElementById('tab-btn-all');
    const btnCoupons = document.getElementById('tab-btn-coupons');
    const btnFlash = document.getElementById('tab-btn-flash-sale');

    const activeCls = ['bg-primary', 'text-white', 'shadow-md'];
    const inactiveCls = ['bg-white', 'text-slate-700', 'hover:bg-slate-50', 'border', 'border-slate-200'];

    [btnAll, btnCoupons, btnFlash].forEach(btn => {
      if (!btn) return;
      btn.classList.remove(...activeCls);
      btn.classList.add(...inactiveCls);
    });

    if (tab === 'all') {
      if (couponsSec) couponsSec.classList.remove('hidden');
      if (flashSaleSec) flashSaleSec.classList.remove('hidden');
      btnAll?.classList.add(...activeCls);
      btnAll?.classList.remove(...inactiveCls);
    } else if (tab === 'coupons') {
      if (couponsSec) {
        couponsSec.classList.remove('hidden');
        couponsSec.scrollIntoView({ behavior: 'smooth' });
      }
      if (flashSaleSec) flashSaleSec.classList.add('hidden');
      btnCoupons?.classList.add(...activeCls);
      btnCoupons?.classList.remove(...inactiveCls);
    } else if (tab === 'flash-sale') {
      if (couponsSec) couponsSec.classList.add('hidden');
      if (flashSaleSec) {
        flashSaleSec.classList.remove('hidden');
        flashSaleSec.scrollIntoView({ behavior: 'smooth' });
      }
      btnFlash?.classList.add(...activeCls);
      btnFlash?.classList.remove(...inactiveCls);
    }
  }

  function handleUrlHash() {
    const hash = window.location.hash;
    if (hash === '#coupons-section') {
      switchPromoTab('coupons');
    } else if (hash === '#flash-sale-section') {
      switchPromoTab('flash-sale');
    }
  }

  window.addEventListener('load', handleUrlHash);
  window.addEventListener('hashchange', handleUrlHash);
</script>
<script src="${pageContext.request.contextPath}/assets/web/js/banner-3d.js"></script>
</body>
</html>