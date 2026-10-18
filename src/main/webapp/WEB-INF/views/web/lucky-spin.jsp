<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vòng Quay May Mắn & Ví Quà Tặng - Fruitables</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/output.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
  <style>
    @keyframes pulse-ring {
      0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(245, 158, 11, 0.7); }
      70% { transform: scale(1); box-shadow: 0 0 0 14px rgba(245, 158, 11, 0); }
      100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(245, 158, 11, 0); }
    }
    .pulse-glow { animation: pulse-ring 2s infinite cubic-bezier(0.45, 0, 0.55, 1); }
    
    @keyframes led-blink {
      0%, 100% { opacity: 1; filter: drop-shadow(0 0 4px #fbbf24); }
      50% { opacity: 0.35; filter: none; }
    }
    .led-light { animation: led-blink 1.2s infinite ease-in-out; }
  </style>
</head>
<body class="bg-surface text-on-surface flex flex-col min-h-screen">

  <jsp:include page="/WEB-INF/views/components/svg-icons.jsp" />
  <jsp:include page="/WEB-INF/views/components/navbar.jsp" />

  <main class="flex-1 pb-16">
    <!-- HERO HEADER -->
    <section class="relative bg-gradient-to-r from-emerald-800 via-teal-900 to-slate-900 text-white py-12 px-4 overflow-hidden border-b border-emerald-500/30">
      <div class="absolute inset-0 bg-[radial-gradient(#10b981_1px,transparent_1px)] [background-size:20px_20px] opacity-15"></div>
      <div class="max-w-6xl mx-auto relative z-10 text-center">
        <div class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-amber-400/20 border border-amber-400/40 text-amber-300 text-xs font-bold mb-3 backdrop-blur-md">
          <svg class="w-4 h-4 text-amber-300 animate-spin" style="animation-duration: 8s;"><use href="#icon-lucky-spin"/></svg>
          <span>MINI GAME MỖI NGÀY - 100% QUAY LÀ TRÚNG</span>
        </div>
        <h1 class="font-headline-lg text-3xl sm:text-4xl md:text-5xl font-black tracking-tight mb-3">
          VÒNG QUAY MAY MẮN <span class="text-amber-400">FRUITABLES</span> 🎡
        </h1>
        <p class="text-emerald-100/90 text-sm md:text-base max-w-2xl mx-auto leading-relaxed">
          Tích lũy lượt quay mỗi ngày để rinh ngay Voucher 50.000₫, mã Freeship hỏa tốc và những giỏ hoa quả tươi sạch thượng hạng!
        </p>

        <!-- THANH TRẠNG THÁI LƯỢT QUAY & ĐIỂM DANH -->
        <div class="mt-8 flex flex-wrap items-center justify-center gap-3.5">
          <div class="bg-white/10 backdrop-blur-md border border-white/20 px-5 py-2.5 rounded-2xl flex items-center gap-3 shadow-lg">
            <div class="w-10 h-10 rounded-xl bg-amber-400 text-slate-900 flex items-center justify-center font-black shadow-md">
              <svg class="w-6 h-6"><use href="#icon-prize-spin"/></svg>
            </div>
            <div class="text-left">
              <span class="text-[10px] text-white/70 uppercase tracking-wider block font-bold">Lượt quay hiện có</span>
              <span id="user-spin-badge" class="font-black text-xl text-amber-300 tracking-tight">
                ${userSpins} <span class="text-xs font-normal text-white">lượt</span>
              </span>
            </div>
          </div>

          <!-- Nút Điểm danh mỗi ngày -->
          <c:choose>
            <c:when test="${not empty sessionScope.USERMODEL}">
              <c:choose>
                <c:when test="${canClaimDaily}">
                  <button type="button" id="claim-daily-btn" onclick="claimDailySpin()"
                          class="px-6 py-3 rounded-2xl bg-gradient-to-r from-amber-400 via-orange-400 to-amber-500 text-slate-900 font-extrabold text-sm shadow-xl hover:shadow-2xl hover:scale-105 active:scale-95 transition-all flex items-center gap-2 cursor-pointer pulse-glow">
                    <svg class="w-5 h-5 text-slate-900"><use href="#icon-prize-gift"/></svg>
                    <span>Điểm Danh Nhận +1 Lượt Hôm Nay</span>
                  </button>
                </c:when>
                <c:otherwise>
                  <button type="button" disabled
                          class="px-5 py-3 rounded-2xl bg-white/15 text-white/70 font-bold text-xs border border-white/20 flex items-center gap-2 cursor-not-allowed">
                    <span class="material-symbols-outlined text-sm text-emerald-400">check_circle</span>
                    <span>Đã nhận lượt quay hôm nay</span>
                  </button>
                </c:otherwise>
              </c:choose>
            </c:when>
            <c:otherwise>
              <a href="${pageContext.request.contextPath}/login"
                 class="px-6 py-3 rounded-2xl bg-gradient-to-r from-amber-400 to-amber-500 text-slate-900 font-extrabold text-sm shadow-xl hover:scale-105 transition-all flex items-center gap-2">
                <span class="material-symbols-outlined text-sm">login</span>
                <span>Đăng nhập để nhận lượt quay miễn phí</span>
              </a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </section>

    <!-- KHU VỰC VÒNG QUAY & VÍ QUÀ TẶNG (2 CỘT) -->
    <div class="max-w-6xl mx-auto px-4 -mt-4">
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        
        <!-- CỘT TRÁI: BÁNH XE VÒNG QUAY (7 CỘT) -->
        <div class="lg:col-span-7 bg-surface-container-lowest p-6 md:p-8 rounded-3xl shadow-xl border border-outline-variant/80 flex flex-col items-center">
          <div class="text-center mb-6">
            <h2 class="font-headline-md text-xl md:text-2xl font-bold text-on-surface flex items-center justify-center gap-2">
              <span>Bánh Xe May Mắn</span>
              <span class="text-xs px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 font-bold border border-emerald-300">8 Ô Phần Thưởng</span>
            </h2>
            <p class="text-xs text-on-surface-variant mt-1">Bấm nút "QUAY NGAY" ở tâm bánh xe để thử vận may của bạn!</p>
          </div>

          <!-- KHUNG CHỨA VÒNG QUAY HTML5 CANVAS -->
          <div class="relative flex items-center justify-center w-full max-w-[390px] sm:max-w-[430px] aspect-square select-none">
            <!-- Vòng hào quang bên ngoài -->
            <div class="absolute inset-0 rounded-full bg-gradient-to-tr from-amber-400/20 via-emerald-400/20 to-teal-400/20 blur-xl pointer-events-none"></div>

            <!-- Viền LED trang trí ngoài cùng -->
            <div class="absolute inset-0 rounded-full border-[10px] border-amber-500 shadow-2xl pointer-events-none flex items-center justify-center">
              <!-- Các bóng đèn LED vẽ bằng CSS -->
              <div class="absolute -top-2 left-1/2 -translate-x-1/2 w-4 h-4 rounded-full bg-amber-300 led-light shadow-md"></div>
              <div class="absolute -bottom-2 left-1/2 -translate-x-1/2 w-4 h-4 rounded-full bg-amber-300 led-light shadow-md" style="animation-delay: 0.3s;"></div>
              <div class="absolute top-1/2 -left-2 -translate-y-1/2 w-4 h-4 rounded-full bg-amber-300 led-light shadow-md" style="animation-delay: 0.6s;"></div>
              <div class="absolute top-1/2 -right-2 -translate-y-1/2 w-4 h-4 rounded-full bg-amber-300 led-light shadow-md" style="animation-delay: 0.9s;"></div>
            </div>

            <!-- Canvas vẽ bánh xe -->
            <canvas id="wheel-canvas" width="420" height="420" class="w-full h-full rounded-full cursor-pointer transition-transform ease-out"></canvas>

            <!-- Kim chỉ (Pointer) ở đỉnh -->
            <div class="absolute top-0 left-1/2 -translate-x-1/2 -translate-y-2 z-20 pointer-events-none drop-shadow-xl">
              <svg width="40" height="50" viewBox="0 0 40 50">
                <polygon points="20,48 5,6 35,6" fill="#DC2626" stroke="#FEF08A" stroke-width="3"/>
                <circle cx="20" cy="14" r="6" fill="#FBBF24"/>
              </svg>
            </div>

            <!-- Nút bấm quay ở trung tâm -->
            <button type="button" id="spin-center-btn" onclick="triggerSpin()"
                    class="absolute z-30 w-20 h-20 sm:w-24 sm:h-24 rounded-full bg-gradient-to-b from-amber-400 via-orange-500 to-amber-600 text-slate-900 font-black shadow-2xl border-4 border-white flex flex-col items-center justify-center hover:scale-105 active:scale-95 transition-all cursor-pointer select-none">
              <svg class="w-5 h-5 text-slate-900 mb-0.5"><use href="#icon-lucky-spin"/></svg>
              <span class="text-xs sm:text-sm font-black tracking-wider uppercase">QUAY</span>
            </button>
          </div>

          <!-- Ghi chú nhanh phía dưới vòng quay -->
          <div class="mt-6 p-3 rounded-2xl bg-surface-container-low border border-outline-variant/60 w-full flex items-center justify-between text-xs text-on-surface-variant">
            <span class="flex items-center gap-1.5 font-medium">
              <span class="material-symbols-outlined text-base text-primary">verified</span>
              Xác suất ngẫu nhiên 100% minh bạch
            </span>
            <span class="font-bold text-amber-600">Đổi quà không giới hạn</span>
          </div>
        </div>

        <!-- CỘT PHẢI: VÍ QUÀ TẶNG & LUẬT CHƠI (5 CỘT) -->
        <div class="lg:col-span-5 space-y-6">
          
          <!-- THẺ 1: VÍ QUÀ TẶNG CỦA TÔI -->
          <div class="bg-surface-container-lowest p-6 rounded-3xl shadow-xl border border-outline-variant/80">
            <div class="flex items-center justify-between pb-3.5 mb-4 border-b border-surface-variant">
              <div class="flex items-center gap-2.5">
                <div class="w-9 h-9 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center">
                  <svg class="w-5 h-5"><use href="#icon-wallet-gift"/></svg>
                </div>
                <div>
                  <h3 class="font-bold text-sm text-on-surface">Ví Quà Tặng Của Bạn</h3>
                  <span class="text-[11px] text-on-surface-variant">Mã ưu đãi đã trúng thưởng</span>
                </div>
              </div>
              <c:if test="${not empty sessionScope.USERMODEL}">
                <a href="${pageContext.request.contextPath}/profile" class="text-xs text-primary font-bold hover:underline flex items-center gap-0.5">
                  Xem hồ sơ <span class="material-symbols-outlined text-xs">arrow_forward</span>
                </a>
              </c:if>
            </div>

            <!-- Danh sách quà trong ví -->
            <div id="reward-wallet-list" class="max-h-[300px] overflow-y-auto space-y-2.5 pr-1">
              <c:choose>
                <c:when test="${not empty userRewards}">
                  <c:forEach var="item" items="${userRewards}">
                    <div class="p-3 rounded-2xl border ${item.isUsed ? 'bg-surface-container-low/60 border-outline-variant/60 opacity-75' : (item.expired ? 'bg-rose-50 border-rose-200' : 'bg-surface-container border-emerald-500/30')} flex items-center justify-between gap-2 transition-all">
                      <div class="min-w-0">
                        <div class="flex items-center gap-1.5 mb-0.5">
                          <span class="font-bold text-xs text-on-surface truncate"><c:out value="${item.prizeName}"/></span>
                          <span class="text-[9px] font-bold px-1.5 py-0.2 rounded-full ${item.isUsed ? 'bg-slate-200 text-slate-700' : (item.expired ? 'bg-rose-100 text-rose-700' : 'bg-emerald-100 text-emerald-800')}">
                            <c:out value="${item.statusBadge}"/>
                          </span>
                        </div>
                        <c:if test="${not empty item.rewardCode}">
                          <div class="flex items-center gap-1 font-mono font-bold text-xs text-primary">
                            <span><c:out value="${item.rewardCode}"/></span>
                            <c:if test="${!item.isUsed && !item.expired}">
                              <button type="button" onclick="navigator.clipboard.writeText('${item.rewardCode}'); alert('Đã sao chép: ${item.rewardCode}');" class="text-on-surface-variant hover:text-primary">
                                <span class="material-symbols-outlined text-xs">content_copy</span>
                              </button>
                            </c:if>
                          </div>
                        </c:if>
                        <span class="text-[10px] text-on-surface-variant block mt-0.5">HSD: <fmt:formatDate value="${item.expiredAt}" pattern="dd/MM/yyyy"/></span>
                      </div>

                      <c:if test="${!item.isUsed && !item.expired}">
                        <a href="${pageContext.request.contextPath}/shop" class="px-3 py-1.5 bg-primary text-white text-[10px] font-bold rounded-xl hover:opacity-90 flex-shrink-0 transition-opacity">
                          Dùng ngay
                        </a>
                      </c:if>
                    </div>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <div class="text-center py-8 text-on-surface-variant text-xs space-y-2">
                    <svg class="w-10 h-10 text-on-surface-variant/40 mx-auto"><use href="#icon-wallet-gift"/></svg>
                    <p>Bạn chưa có mã quà tặng nào. Hãy bấm <strong>QUAY NGAY</strong> để nhận quà nhé!</p>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <!-- THẺ 2: CÁCH NHẬN THÊM LƯỢT QUAY (SPIN ECONOMY) -->
          <div class="bg-surface-container-lowest p-6 rounded-3xl shadow-xl border border-outline-variant/80">
            <h3 class="font-bold text-sm text-on-surface mb-3 flex items-center gap-2">
              <svg class="w-4 h-4 text-emerald-600"><use href="#icon-prize-star"/></svg>
              <span>Cách Nhận Thêm Lượt Quay</span>
            </h3>
            <ul class="space-y-3 text-xs text-on-surface-variant leading-relaxed">
              <li class="flex items-start gap-2.5">
                <span class="w-5 h-5 rounded-full bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold text-[10px] flex-shrink-0 mt-0.5">1</span>
                <div>
                  <strong class="text-on-surface">Điểm danh mỗi ngày:</strong> Mỗi ngày đăng nhập website được nhận miễn phí <strong>+1 lượt quay</strong>.
                </div>
              </li>
              <li class="flex items-start gap-2.5">
                <span class="w-5 h-5 rounded-full bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold text-[10px] flex-shrink-0 mt-0.5">2</span>
                <div>
                  <strong class="text-on-surface">Mua hàng tích lượt:</strong> Đơn hàng hoàn thành giao thành công, cứ mỗi <strong>150.000₫</strong> giá trị đơn được tặng thêm <strong>+1 lượt quay</strong>.
                </div>
              </li>
              <li class="flex items-start gap-2.5">
                <span class="w-5 h-5 rounded-full bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold text-[10px] flex-shrink-0 mt-0.5">3</span>
                <div>
                  <strong class="text-on-surface">Quay trúng ô "+1 Lượt":</strong> Được quay thêm ngay một lượt miễn phí tiếp theo!
                </div>
              </li>
            </ul>
          </div>

        </div>
      </div>
    </div>
  </main>

  <!-- MODAL THÔNG BÁO KẾT QUẢ TRÚNG THƯỞNG -->
  <div id="prize-modal" class="fixed inset-0 z-[200] hidden items-center justify-center bg-slate-950/70 backdrop-blur-sm p-4">
    <div class="bg-white rounded-3xl max-w-sm w-full p-6 text-center shadow-2xl border border-slate-200 relative overflow-hidden transform transition-all scale-95 opacity-0 duration-300" id="prize-modal-content">
      <button type="button" onclick="closePrizeModal()" class="absolute top-3 right-3 text-slate-400 hover:text-slate-600 p-1.5 rounded-full hover:bg-slate-100">
        <span class="material-symbols-outlined text-lg">close</span>
      </button>

      <!-- Canvas Confetti nổ pháo hoa -->
      <canvas id="confetti-canvas" class="absolute inset-0 pointer-events-none w-full h-full z-0"></canvas>

      <div class="relative z-10">
        <div id="prize-modal-icon-box" class="w-16 h-16 mx-auto rounded-3xl bg-amber-100 text-amber-600 flex items-center justify-center mb-3 shadow-lg">
          <svg class="w-9 h-9" id="prize-modal-svg"><use href="#icon-prize-gift"/></svg>
        </div>

        <span class="text-xs uppercase font-extrabold tracking-wider text-amber-600" id="prize-modal-subtitle">XIN CHÚC MỪNG!</span>
        <h3 class="font-headline-sm text-xl font-black text-slate-900 mt-1 mb-2" id="prize-modal-title">Voucher 20.000₫</h3>
        <p class="text-xs text-slate-500 mb-4" id="prize-modal-desc">Mã ưu đãi đã được lưu vào Ví quà tặng của bạn.</p>

        <!-- Khung sao chép mã code -->
        <div id="prize-code-container" class="mb-5 p-3 rounded-2xl bg-amber-50 border border-amber-200 flex items-center justify-between">
          <div class="text-left">
            <span class="text-[9px] uppercase tracking-wider text-amber-800 font-bold block">MÃ KHUYẾN MÃI</span>
            <span id="prize-modal-code" class="font-mono font-black text-base text-slate-900 select-all tracking-wider">SPIN20K-XXXX</span>
          </div>
          <button type="button" onclick="copyPrizeCode()" class="px-3 py-1.5 bg-amber-500 hover:bg-amber-600 text-white rounded-xl text-xs font-bold transition-colors cursor-pointer">
            Sao chép
          </button>
        </div>

        <div class="flex items-center gap-2">
          <button type="button" onclick="closePrizeModal()" class="flex-1 py-2.5 rounded-xl border border-slate-200 text-slate-700 font-bold text-xs hover:bg-slate-50 transition-colors">
            Đóng
          </button>
          <a href="${pageContext.request.contextPath}/shop" class="flex-1 py-2.5 rounded-xl bg-primary text-white font-bold text-xs hover:bg-primary-container transition-colors shadow-sm">
            Dùng ngay 🛒
          </a>
        </div>
      </div>
    </div>
  </div>

  <jsp:include page="/WEB-INF/views/components/footer.jsp" />

  <!-- SCRIPT ĐIỀU KHIỂN BÁNH XE CANVAS & API TRÚNG THƯỞNG -->
  <script>
    (function() {
      const contextPath = '${pageContext.request.contextPath}';
      const isLoggedIn = ${not empty sessionScope.USERMODEL ? 'true' : 'false'};
      let userSpins = ${userSpins};
      let isSpinning = false;
      let currentRotation = 0;

      // Danh sách giải thưởng từ Server
      const rawPrizes = [
        <c:forEach var="p" items="${activePrizes}" varStatus="loop">
          {
            id: ${p.id},
            name: "${p.name}",
            type: "${p.prizeType}",
            discount: ${p.discountValue},
            minOrder: ${p.minOrderValue},
            colorBg: "${p.colorBg}",
            colorText: "${p.colorText}",
            iconType: "${p.iconType}"
          }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
      ];

      // Nếu không có giải thưởng, nạp fallback mặc định
      const prizes = rawPrizes.length >= 4 ? rawPrizes : [
        { id: 1, name: "Voucher 10K", colorBg: "#10B981", colorText: "#FFFFFF", iconType: "voucher" },
        { id: 2, name: "Freeship 100%", colorBg: "#059669", colorText: "#FFFFFF", iconType: "shipping" },
        { id: 3, name: "Voucher 20K", colorBg: "#047857", colorText: "#FFFFFF", iconType: "voucher" },
        { id: 4, name: "Chúc May Mắn", colorBg: "#F59E0B", colorText: "#FFFFFF", iconType: "luck" },
        { id: 5, name: "Giảm 10%", colorBg: "#0D9488", colorText: "#FFFFFF", iconType: "voucher" },
        { id: 6, name: "Voucher VIP 50K", colorBg: "#DC2626", colorText: "#FFFFFF", iconType: "star" },
        { id: 7, name: "Hộp Quà Hoa Quả", colorBg: "#7C3AED", colorText: "#FFFFFF", iconType: "gift" },
        { id: 8, name: "+1 Lượt Quay", colorBg: "#D97706", colorText: "#FFFFFF", iconType: "spin" }
      ];

      const canvas = document.getElementById('wheel-canvas');
      const ctx = canvas.getContext('2d');
      const numSlices = prizes.length;
      const sliceAngle = (2 * Math.PI) / numSlices;
      const centerX = canvas.width / 2;
      const centerY = canvas.height / 2;
      const radius = centerX - 12;

      // ----------------------------------------------------
      // VẼ BÁNH XE BẰNG HTML5 CANVAS (100% CODE VECTOR MATH)
      // ----------------------------------------------------
      function drawWheel(rotationAngle = 0) {
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        ctx.save();
        ctx.translate(centerX, centerY);
        ctx.rotate(rotationAngle);

        for (let i = 0; i < numSlices; i++) {
          const startAngle = i * sliceAngle;
          const endAngle = startAngle + sliceAngle;
          const p = prizes[i];

          // 1. Vẽ góc hình quạt (Slice)
          ctx.beginPath();
          ctx.moveTo(0, 0);
          ctx.arc(0, 0, radius, startAngle, endAngle);
          ctx.closePath();
          ctx.fillStyle = p.colorBg || '#10B981';
          ctx.fill();

          // Đường viền ngăn cách
          ctx.strokeStyle = '#FFFFFF';
          ctx.lineWidth = 2.5;
          ctx.stroke();

          // 2. Vẽ chữ tên phần thưởng quay theo bán kính
          ctx.save();
          const textAngle = startAngle + sliceAngle / 2;
          ctx.rotate(textAngle);
          ctx.textAlign = 'right';
          ctx.textBaseline = 'middle';
          ctx.fillStyle = p.colorText || '#FFFFFF';
          ctx.font = 'bold 13px system-ui, -apple-system, sans-serif';

          // Cắt ngắn nếu tên quá dài
          let displayName = p.name;
          if (displayName.length > 16) displayName = displayName.substring(0, 14) + '...';
          ctx.fillText(displayName, radius - 26, 0);

          // 3. Vẽ Icon Vector bằng Canvas Code
          drawSliceIcon(ctx, p.iconType, radius - 12, 0);

          ctx.restore();
        }

        // Vòng tròn kim loại trang trí ở tâm
        ctx.beginPath();
        ctx.arc(0, 0, 42, 0, 2 * Math.PI);
        ctx.fillStyle = '#FFFFFF';
        ctx.fill();
        ctx.strokeStyle = '#F59E0B';
        ctx.lineWidth = 4;
        ctx.stroke();

        ctx.restore();
      }

      // Hàm vẽ Icon bằng Canvas Path
      function drawSliceIcon(c, iconType, x, y) {
        c.save();
        c.translate(x, y);
        c.fillStyle = '#FEF08A';
        c.strokeStyle = '#FEF08A';
        c.lineWidth = 1.5;

        if (iconType === 'star') {
          // Ngôi sao
          c.beginPath();
          for (let i = 0; i < 5; i++) {
            c.lineTo(Math.cos((18 + i * 72) * Math.PI / 180) * 6, -Math.sin((18 + i * 72) * Math.PI / 180) * 6);
            c.lineTo(Math.cos((54 + i * 72) * Math.PI / 180) * 3, -Math.sin((54 + i * 72) * Math.PI / 180) * 3);
          }
          c.closePath();
          c.fill();
        } else if (iconType === 'gift') {
          // Hộp quà
          c.strokeRect(-5, -4, 10, 8);
          c.beginPath();
          c.moveTo(0, -4); c.lineTo(0, 4);
          c.moveTo(-5, 0); c.lineTo(5, 0);
          c.stroke();
        } else {
          // Chấm tròn điểm sáng
          c.beginPath();
          c.arc(0, 0, 3, 0, 2 * Math.PI);
          c.fill();
        }
        c.restore();
      }

      drawWheel(0);

      // Web Audio API để phát âm thanh tíc-tắc khi quay bánh xe
      function playTickSound() {
        try {
          const AudioContext = window.AudioContext || window.webkitAudioContext;
          if (!AudioContext) return;
          const actx = new AudioContext();
          const osc = actx.createOscillator();
          const gain = actx.createGain();
          osc.type = 'triangle';
          osc.frequency.setValueAtTime(450, actx.currentTime);
          osc.frequency.exponentialRampToValueAtTime(120, actx.currentTime + 0.04);
          gain.gain.setValueAtTime(0.12, actx.currentTime);
          gain.gain.exponentialRampToValueAtTime(0.01, actx.currentTime + 0.04);
          osc.connect(gain);
          gain.connect(actx.destination);
          osc.start();
          osc.stop(actx.currentTime + 0.05);
        } catch (e) {}
      }

      // ----------------------------------------------------
      // XỬ LÝ QUAY BÁNH XE
      // ----------------------------------------------------
      window.triggerSpin = function() {
        if (!isLoggedIn) {
          alert("Vui lòng đăng nhập để tham gia quay thưởng!");
          window.location.href = contextPath + "/login";
          return;
        }

        if (isSpinning) return;

        if (userSpins <= 0) {
          alert("Bạn đã hết lượt quay! Hãy điểm danh hôm nay hoặc đặt đơn hàng để nhận thêm lượt nhé 🍎");
          return;
        }

        isSpinning = true;
        const spinBtn = document.getElementById('spin-center-btn');
        if (spinBtn) spinBtn.disabled = true;

        // Gọi API lên Servlet để nhận kết quả
        fetch(contextPath + '/api/lucky-spin', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
          body: 'action=spin'
        })
        .then(res => res.json())
        .then(data => {
          if (!data.success) {
            isSpinning = false;
            if (spinBtn) spinBtn.disabled = false;
            alert(data.message || 'Lỗi khi quay thưởng');
            return;
          }

          // Cập nhật số lượt quay mới
          userSpins = data.remainingSpins;
          updateSpinBadge(userSpins);

          // Bắt đầu diễn hoạt xoay bánh xe
          animateSpin(data.targetDegree, () => {
            isSpinning = false;
            if (spinBtn) spinBtn.disabled = false;
            showPrizeModal(data);
          });
        })
        .catch(err => {
          console.error(err);
          isSpinning = false;
          if (spinBtn) spinBtn.disabled = false;
          alert('Mạng gián đoạn khi quay thưởng. Vui lòng thử lại!');
        });
      };

      function animateSpin(targetDegree, onComplete) {
        const startRotation = currentRotation;
        const totalDegree = targetDegree;
        const duration = 4800; // 4.8 giây xoay mượt mà
        const startTime = performance.now();
        let lastTickAngle = 0;

        function step(now) {
          const elapsed = now - startTime;
          const progress = Math.min(elapsed / duration, 1);
          // Easing Cubic Out để giảm tốc độ tự nhiên
          const easeProgress = 1 - Math.pow(1 - progress, 3);
          const currentDeg = startRotation + totalDegree * easeProgress;
          currentRotation = currentDeg;

          // Chuyển sang Radian để vẽ
          const rad = (currentDeg * Math.PI) / 180;
          drawWheel(rad);

          // Phát âm thanh khi qua mỗi ô
          if (Math.abs(currentDeg - lastTickAngle) >= (360 / numSlices)) {
            playTickSound();
            lastTickAngle = currentDeg;
          }

          if (progress < 1) {
            requestAnimationFrame(step);
          } else {
            if (onComplete) onComplete();
          }
        }

        requestAnimationFrame(step);
      }

      function updateSpinBadge(count) {
        const badge = document.getElementById('user-spin-badge');
        if (badge) badge.innerHTML = count + ' <span class="text-xs font-normal text-white">lượt</span>';
      }

      // Điểm danh nhận lượt miễn phí
      window.claimDailySpin = function() {
        if (!isLoggedIn) {
          window.location.href = contextPath + '/login';
          return;
        }

        const btn = document.getElementById('claim-daily-btn');
        if (btn) btn.disabled = true;

        fetch(contextPath + '/api/lucky-spin', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
          body: 'action=claim_daily'
        })
        .then(res => res.json())
        .then(data => {
          alert(data.message);
          if (data.success) {
            userSpins = data.remainingSpins;
            updateSpinBadge(userSpins);
            if (btn) {
              btn.outerHTML = `
                <button type="button" disabled class="px-5 py-3 rounded-2xl bg-white/15 text-white/70 font-bold text-xs border border-white/20 flex items-center gap-2 cursor-not-allowed">
                  <span class="material-symbols-outlined text-sm text-emerald-400">check_circle</span>
                  <span>Đã nhận lượt quay hôm nay</span>
                </button>
              `;
            }
          } else if (btn) {
            btn.disabled = false;
          }
        })
        .catch(err => {
          console.error(err);
          if (btn) btn.disabled = false;
        });
      };

      // Modal hiển thị kết quả trúng thưởng
      const modal = document.getElementById('prize-modal');
      const modalContent = document.getElementById('prize-modal-content');
      let currentPrizeCode = '';

      function showPrizeModal(data) {
        if (!modal) return;
        currentPrizeCode = data.rewardCode || '';

        const titleEl = document.getElementById('prize-modal-title');
        const descEl = document.getElementById('prize-modal-desc');
        const codeEl = document.getElementById('prize-modal-code');
        const codeBox = document.getElementById('prize-code-container');
        const subTitle = document.getElementById('prize-modal-subtitle');

        if (titleEl) titleEl.innerText = data.prizeName || 'Phần thưởng';

        if (data.prizeType === 'NO_PRIZE') {
          if (subTitle) subTitle.innerText = 'RẤT TIẾC!';
          if (descEl) descEl.innerText = 'Chúc bạn may mắn hơn ở lần quay tiếp theo nhé 🍀!';
          if (codeBox) codeBox.classList.add('hidden');
        } else if (data.prizeType === 'EXTRA_SPIN') {
          if (subTitle) subTitle.innerText = 'TUYỆT VỜI!';
          if (descEl) descEl.innerText = 'Bạn được cộng thêm 1 lượt quay ngay lập tức!';
          if (codeBox) codeBox.classList.add('hidden');
        } else {
          if (subTitle) subTitle.innerText = 'XIN CHÚC MỪNG!';
          if (descEl) descEl.innerText = 'Mã ưu đãi đã được lưu vào Ví quà tặng của bạn.';
          if (codeBox) codeBox.classList.remove('hidden');
          if (codeEl) codeEl.innerText = currentPrizeCode;
        }

        modal.classList.remove('hidden');
        modal.classList.add('flex');
        setTimeout(() => {
          modalContent.classList.remove('scale-95', 'opacity-0');
          modalContent.classList.add('scale-100', 'opacity-100');
          launchConfetti();
        }, 50);
      }

      window.closePrizeModal = function() {
        if (!modal) return;
        modalContent.classList.remove('scale-100', 'opacity-100');
        modalContent.classList.add('scale-95', 'opacity-0');
        setTimeout(() => {
          modal.classList.remove('flex');
          modal.classList.add('hidden');
        }, 200);
      };

      window.copyPrizeCode = function() {
        if (!currentPrizeCode) return;
        navigator.clipboard.writeText(currentPrizeCode);
        alert('Đã sao chép mã ưu đãi: ' + currentPrizeCode);
      };

      // Hiệu ứng pháo hoa Confetti nhẹ bằng Canvas
      function launchConfetti() {
        const c = document.getElementById('confetti-canvas');
        if (!c) return;
        const cctx = c.getContext('2d');
        c.width = c.offsetWidth;
        c.height = c.offsetHeight;

        const particles = [];
        const colors = ['#10B981', '#F59E0B', '#EF4444', '#3B82F6', '#8B5CF6'];

        for (let i = 0; i < 40; i++) {
          particles.push({
            x: c.width / 2,
            y: c.height / 2,
            vx: (Math.random() - 0.5) * 8,
            vy: (Math.random() - 0.5) * 8 - 2,
            size: Math.random() * 5 + 3,
            color: colors[Math.floor(Math.random() * colors.length)],
            alpha: 1
          });
        }

        let animId;
        function render() {
          cctx.clearRect(0, 0, c.width, c.height);
          let alive = false;
          particles.forEach(p => {
            p.x += p.vx;
            p.y += p.vy;
            p.vy += 0.15; // trọng lực
            p.alpha -= 0.015;
            if (p.alpha > 0) {
              alive = true;
              cctx.save();
              cctx.globalAlpha = p.alpha;
              cctx.fillStyle = p.color;
              cctx.fillRect(p.x, p.y, p.size, p.size);
              cctx.restore();
            }
          });
          if (alive) animId = requestAnimationFrame(render);
        }
        render();
      }

    })();
  </script>
</body>
</html>
