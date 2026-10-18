<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Vòng Quay May Mắn & Ví Quà Tặng - Fruitables</title>

    <!-- Font Material Symbols hỗ trợ biến thể Google Icons -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    
    <!-- CSS & Tailwind Config đồng bộ toàn hệ thống Fruitables -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>

    <style>
        @keyframes pulse-ring {
            0% { transform: scale(0.96); box-shadow: 0 0 0 0 rgba(245, 158, 11, 0.7); }
            70% { transform: scale(1); box-shadow: 0 0 0 16px rgba(245, 158, 11, 0); }
            100% { transform: scale(0.96); box-shadow: 0 0 0 0 rgba(245, 158, 11, 0); }
        }
        .pulse-glow-amber { animation: pulse-ring 2s infinite cubic-bezier(0.45, 0, 0.55, 1); }

        @keyframes rotate-sunburst {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .animate-sunburst { animation: rotate-sunburst 24s linear infinite; }
    </style>
</head>

<body class="bg-surface-container bg-pattern min-h-screen flex flex-col antialiased">
    <!-- SVG ICONS SPRITE -->
    <jsp:include page="/WEB-INF/views/components/svg-icons.jsp" />

    <!-- NAVBAR CHUNG CỦA HỆ THỐNG -->
    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />

    <main class="flex-1 pb-16">
        <!-- ============================================================== -->
        <!-- HERO BANNER: 3D ORGANIC STAGE ĐỒNG BỘ PHONG CÁCH FRUITABLES   -->
        <!-- ============================================================== -->
        <section class="tilt-3d-stage relative w-full min-h-[340px] md:min-h-[380px] flex items-center overflow-hidden bg-gradient-to-br from-[#062410] via-[#0f3d1b] to-[#041a0b] py-10 md:py-14 perspective-1200 shadow-lg">
            <!-- Nền không gian sâu với Mesh Gradient & Ambient Aura tươi sáng hữu cơ -->
            <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-emerald-700/30 via-[#0a3818]/60 to-[#031c0a] z-0"></div>
            <div class="absolute -top-20 -left-20 w-96 h-96 bg-primary/30 rounded-full blur-[100px] pointer-events-none animate-ambient-aura z-0"></div>
            <div class="absolute -bottom-24 right-10 w-[30rem] h-[30rem] bg-amber-400/20 rounded-full blur-[120px] pointer-events-none animate-ambient-aura z-0" style="animation-delay: -3s;"></div>
            <div class="absolute top-1/2 left-1/3 w-80 h-80 bg-emerald-500/20 rounded-full blur-[90px] pointer-events-none z-0"></div>
            <div class="absolute inset-0 bg-[radial-gradient(#84cc16_1px,transparent_1px)] [background-size:28px_28px] opacity-20 pointer-events-none z-0"></div>

            <div class="relative z-10 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto w-full text-center">
                <!-- Badge Gamification -->
                <div class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/10 border border-white/20 text-amber-300 text-xs font-bold mb-4 backdrop-blur-md shadow-inner">
                    <svg class="w-4 h-4 animate-[spin_8s_linear_infinite]" viewBox="0 0 32 32"><use href="#icon-lucky-spin-color"/></svg>
                    <span class="tracking-wider uppercase">MINI GAME MỖI NGÀY • 100% QUAY LÀ CÓ QUÀ</span>
                </div>

                <!-- Tiêu đề lớn -->
                <h1 class="font-headline-lg text-3xl sm:text-4xl md:text-5xl font-black text-white tracking-tight mb-3">
                    VÒNG QUAY MAY MẮN <span class="bg-gradient-to-r from-amber-300 via-yellow-400 to-amber-500 bg-clip-text text-transparent">FRUITABLES</span> 🎡
                </h1>
                <p class="text-emerald-100/85 text-xs sm:text-sm md:text-base max-w-2xl mx-auto leading-relaxed">
                    Tích lũy lượt quay mỗi ngày để rinh ngay Voucher 50.000₫, mã Freeship toàn quốc và những phần quà trái cây tươi sạch thơm ngon!
                </p>

                <!-- Thanh chỉ số lượt quay & Nút điểm danh -->
                <div class="mt-8 flex flex-wrap items-center justify-center gap-3.5">
                    <!-- Thẻ số lượt khả dụng -->
                    <div class="bg-white/10 backdrop-blur-md border border-white/20 px-5 py-2.5 rounded-2xl flex items-center gap-3 shadow-lg">
                        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-400 to-orange-500 text-slate-900 flex items-center justify-center font-black shadow-md">
                            <svg class="w-5 h-5"><use href="#icon-prize-spin"/></svg>
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
                                            class="px-6 py-3 rounded-2xl bg-gradient-to-r from-amber-400 via-orange-400 to-amber-500 text-slate-950 font-black text-xs sm:text-sm shadow-xl hover:shadow-2xl hover:scale-105 active:scale-95 transition-all flex items-center gap-2 cursor-pointer pulse-glow-amber">
                                        <svg class="w-5 h-5 text-slate-950"><use href="#icon-prize-gift"/></svg>
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
                               class="px-6 py-3 rounded-2xl bg-gradient-to-r from-amber-400 to-amber-500 text-slate-950 font-black text-xs sm:text-sm shadow-xl hover:scale-105 transition-all flex items-center gap-2">
                                <span class="material-symbols-outlined text-sm">login</span>
                                <span>Đăng nhập để nhận lượt quay miễn phí</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>

        <!-- ============================================================== -->
        <!-- KHU VỰC CHƠI GAME & VÍ QUÀ TẶNG (2 CỘT CHUẨN CONTAINER)        -->
        <!-- ============================================================== -->
        <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto -mt-6 relative z-20">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                
                <!-- CỘT TRÁI: KHUNG VÒNG QUAY CARNIVAL (7 CỘT) -->
                <div class="lg:col-span-7 bg-surface-container-lowest p-6 md:p-8 rounded-3xl shadow-xl border border-outline-variant flex flex-col items-center relative overflow-hidden">
                    <div class="text-center mb-6">
                        <h2 class="font-headline-md text-xl md:text-2xl font-bold text-on-surface flex items-center justify-center gap-2">
                            <span>Vòng Quay Vận May</span>
                            <span class="text-xs px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 font-bold border border-emerald-300">8 Giải Thưởng</span>
                        </h2>
                        <p class="text-xs text-on-surface-variant mt-1">Bấm nút "QUAY" ở tâm bánh xe để bắt đầu thử vận may của bạn!</p>
                    </div>

                    <!-- KHUNG CHỨA VÒNG QUAY HTML5 CANVAS & ĐÈN CARNIVAL -->
                    <div class="relative flex items-center justify-center w-full max-w-[390px] sm:max-w-[430px] aspect-square select-none my-2">
                        <!-- Vòng hào quang phát sáng phía sau -->
                        <div class="absolute inset-0 rounded-full bg-gradient-to-tr from-amber-400/30 via-rose-500/20 to-teal-400/30 blur-2xl pointer-events-none animate-pulse"></div>

                        <!-- Viền LED trang trí kiểu lễ hội / Carnival (16 bóng LED đuổi nhau) -->
                        <div id="wheel-rim-frame" class="absolute inset-0 rounded-full border-[12px] border-amber-500 shadow-[0_12px_35px_rgba(245,158,11,0.45)] pointer-events-none flex items-center justify-center">
                            <!-- Container cho 16 bóng LED đèn chạy do JavaScript tạo tự động -->
                            <div id="led-lights-container" class="absolute inset-0 pointer-events-none"></div>
                        </div>

                        <!-- Canvas vẽ bánh xe -->
                        <canvas id="wheel-canvas" width="420" height="420" class="w-full h-full rounded-full cursor-pointer transition-transform ease-out"></canvas>

                        <!-- Kim chỉ (Pointer) ở đỉnh với hiệu ứng 3D & dao động cơ học khi quay -->
                        <div id="wheel-pointer" class="absolute top-0 left-1/2 -translate-x-1/2 -translate-y-2 z-20 pointer-events-none drop-shadow-2xl transition-transform duration-75 origin-[21px_6px]">
                            <svg width="42" height="52" viewBox="0 0 42 52">
                                <defs>
                                    <linearGradient id="pointer-body-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                                        <stop offset="0%" stop-color="#EF4444"/>
                                        <stop offset="50%" stop-color="#DC2626"/>
                                        <stop offset="100%" stop-color="#991B1B"/>
                                    </linearGradient>
                                    <linearGradient id="pointer-pin-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                                        <stop offset="0%" stop-color="#FEF08A"/>
                                        <stop offset="100%" stop-color="#F59E0B"/>
                                    </linearGradient>
                                </defs>
                                <!-- Thân mũi tên đỏ ánh kim -->
                                <polygon points="21,50 6,8 36,8" fill="url(#pointer-body-grad)" stroke="#FEF08A" stroke-width="2.5" stroke-linejoin="round"/>
                                <!-- Chốt định vị kim loại tròn -->
                                <circle cx="21" cy="14" r="7.5" fill="url(#pointer-pin-grad)" stroke="#FFFFFF" stroke-width="2"/>
                                <circle cx="21" cy="14" r="3" fill="#B45309"/>
                            </svg>
                        </div>

                        <!-- Nút bấm quay ở trung tâm với vòng hào quang xoay liên tục -->
                        <button type="button" id="spin-center-btn" onclick="triggerSpin()"
                                class="group/btn absolute z-30 w-22 h-22 sm:w-26 sm:h-26 rounded-full bg-gradient-to-b from-amber-300 via-amber-500 to-amber-600 text-slate-950 font-black shadow-[0_10px_25px_rgba(245,158,11,0.6)] border-4 border-white flex flex-col items-center justify-center hover:scale-108 active:scale-95 transition-all duration-300 cursor-pointer select-none">
                            <div class="absolute -inset-2 rounded-full border-2 border-dashed border-amber-300/80 animate-[spin_10s_linear_infinite] pointer-events-none"></div>
                            <svg class="w-6 h-6 text-slate-950 mb-0.5 group-hover/btn:rotate-180 transition-transform duration-500"><use href="#icon-lucky-spin"/></svg>
                            <span class="text-xs sm:text-sm font-black tracking-widest uppercase">QUAY</span>
                        </button>
                    </div>

                    <!-- Cam kết minh bạch & xác suất công bằng -->
                    <div class="mt-6 p-3.5 rounded-2xl bg-surface-container border border-outline-variant w-full flex flex-col sm:flex-row items-center justify-between text-xs text-on-surface-variant gap-2">
                        <span class="flex items-center gap-1.5 font-medium">
                            <span class="material-symbols-outlined text-base text-primary">verified</span>
                            Thuật toán ngẫu nhiên máy chủ (Server RNG) 100% minh bạch
                        </span>
                        <span class="font-bold text-amber-700 bg-amber-50 px-2 py-0.5 rounded-lg border border-amber-200">Không giới hạn giải thưởng</span>
                    </div>
                </div>

                <!-- CỘT PHẢI: VÍ QUÀ TẶNG & LUẬT CHƠI (5 CỘT) -->
                <div class="lg:col-span-5 space-y-6">
                    
                    <!-- THẺ 1: VÍ QUÀ TẶNG CỦA TÔI -->
                    <div class="bg-surface-container-lowest p-6 rounded-3xl shadow-xl border border-outline-variant">
                        <div class="flex items-center justify-between pb-3.5 mb-4 border-b border-surface-variant">
                            <div class="flex items-center gap-2.5">
                                <div class="w-9 h-9 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center flex-shrink-0">
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
                                        <div class="p-3.5 rounded-2xl border ${item.isUsed ? 'bg-surface-container-low/60 border-outline-variant/60 opacity-75' : (item.expired ? 'bg-rose-50 border-rose-200' : 'bg-surface-container border-emerald-500/30')} flex items-center justify-between gap-2 transition-all">
                                            <div class="min-w-0">
                                                <div class="flex items-center gap-1.5 mb-1">
                                                    <span class="font-bold text-xs text-on-surface truncate"><c:out value="${item.prizeName}"/></span>
                                                    <span class="text-[9px] font-bold px-1.5 py-0.2 rounded-full ${item.isUsed ? 'bg-slate-200 text-slate-700' : (item.expired ? 'bg-rose-100 text-rose-700' : 'bg-emerald-100 text-emerald-800')}">
                                                        <c:out value="${item.statusBadge}"/>
                                                    </span>
                                                </div>
                                                <c:if test="${not empty item.rewardCode}">
                                                    <div class="flex items-center gap-1.5 font-mono font-bold text-xs text-primary">
                                                        <span><c:out value="${item.rewardCode}"/></span>
                                                        <c:if test="${!item.isUsed && !item.expired}">
                                                            <button type="button" onclick="navigator.clipboard.writeText('${item.rewardCode}'); alert('Đã sao chép mã ưu đãi: ${item.rewardCode}');" class="text-on-surface-variant hover:text-primary cursor-pointer p-0.5" title="Sao chép">
                                                                <span class="material-symbols-outlined text-xs">content_copy</span>
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                </c:if>
                                                <span class="text-[10px] text-on-surface-variant block mt-0.5">HSD: <fmt:formatDate value="${item.expiredAt}" pattern="dd/MM/yyyy"/></span>
                                            </div>

                                            <c:if test="${!item.isUsed && !item.expired}">
                                                <a href="${pageContext.request.contextPath}/shop" class="px-3 py-1.5 bg-primary text-white text-[10px] font-bold rounded-xl hover:opacity-90 flex-shrink-0 transition-opacity shadow-xs">
                                                    Dùng ngay
                                                </a>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-8 text-on-surface-variant text-xs space-y-2">
                                        <svg class="w-10 h-10 text-on-surface-variant/40 mx-auto"><use href="#icon-wallet-gift"/></svg>
                                        <p>Bạn chưa có mã quà tặng nào. Hãy bấm <strong>QUAY</strong> để rinh quà nhé!</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- THẺ 2: THỂ LỆ & QUY TẮC NHẬN THƯỞNG -->
                    <div class="bg-surface-container-lowest p-6 rounded-3xl shadow-xl border border-outline-variant">
                        <h3 class="font-bold text-sm text-on-surface flex items-center gap-2 mb-3">
                            <span class="material-symbols-outlined text-primary text-base">help</span>
                            Thể Lệ Tham Gia Vòng Quay
                        </h3>
                        <ul class="space-y-2.5 text-xs text-on-surface-variant">
                            <li class="flex items-start gap-2">
                                <span class="material-symbols-outlined text-sm text-amber-500 flex-shrink-0 mt-0.5">stars</span>
                                <div>
                                    <strong class="text-on-surface">Điểm danh hàng ngày:</strong> Mỗi tài khoản đăng nhập được tặng ngay 01 lượt quay miễn phí/ngày.
                                </div>
                            </li>
                            <li class="flex items-start gap-2">
                                <span class="material-symbols-outlined text-sm text-emerald-500 flex-shrink-0 mt-0.5">local_mall</span>
                                <div>
                                    <strong class="text-on-surface">Mua hàng nhận thêm:</strong> Hoàn tất đơn hàng thành công sẽ được tặng thêm lượt quay may mắn.
                                </div>
                            </li>
                            <li class="flex items-start gap-2">
                                <span class="material-symbols-outlined text-sm text-blue-500 flex-shrink-0 mt-0.5">confirmation_number</span>
                                <div>
                                    <strong class="text-on-surface">Sử dụng Voucher:</strong> Mã giảm giá được lưu tự động vào Ví và có thể áp dụng ngay ở bước thanh toán giỏ hàng.
                                </div>
                            </li>
                            <li class="flex items-start gap-2">
                                <span class="material-symbols-outlined text-sm text-rose-500 flex-shrink-0 mt-0.5">restart_alt</span>
                                <div>
                                    <strong class="text-on-surface">Quay trúng ô "+1 Lượt":</strong> Bạn sẽ được cộng thêm ngay một lượt quay tiếp theo!
                                </div>
                            </li>
                        </ul>
                    </div>

                </div>
            </div>
        </div>
    </main>

    <!-- ============================================================== -->
    <!-- MODAL THÔNG BÁO KẾT QUẢ TRÚNG THƯỞNG VỚI SUNBURST RAYS        -->
    <!-- ============================================================== -->
    <div id="prize-modal" class="fixed inset-0 z-[200] hidden items-center justify-center bg-slate-950/70 backdrop-blur-sm p-4">
        <div class="bg-white rounded-3xl max-w-sm w-full p-6 text-center shadow-2xl border border-slate-200 relative overflow-hidden transform transition-all scale-95 opacity-0 duration-300" id="prize-modal-content">
            <button type="button" onclick="closePrizeModal()" class="absolute top-3 right-3 text-slate-400 hover:text-slate-600 p-1.5 rounded-full hover:bg-slate-100 cursor-pointer z-20">
                <span class="material-symbols-outlined text-lg">close</span>
            </button>

            <!-- Vòng hào quang tỏa sáng (Shining Sunburst Rays) -->
            <div class="absolute -top-20 left-1/2 -translate-x-1/2 w-80 h-80 rounded-full bg-[radial-gradient(circle,_rgba(251,191,36,0.3)_0%,_transparent_70%)] animate-pulse pointer-events-none"></div>

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
                    <button type="button" onclick="closePrizeModal()" class="flex-1 py-2.5 rounded-xl border border-slate-200 text-slate-700 font-bold text-xs hover:bg-slate-50 transition-colors cursor-pointer">
                        Đóng
                    </button>
                    <a href="${pageContext.request.contextPath}/shop" class="flex-1 py-2.5 rounded-xl bg-primary text-white font-bold text-xs hover:bg-primary-container transition-colors shadow-sm">
                        Dùng ngay 🛒
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- FOOTER CHUNG CỦA HỆ THỐNG -->
    <jsp:include page="/WEB-INF/views/components/footer.jsp" />

    <!-- ============================================================== -->
    <!-- SCRIPT ĐIỀU KHIỂN BÁNH XE CANVAS & API TRÚNG THƯỞNG            -->
    <!-- ============================================================== -->
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
            const radius = centerX - 14;

            // ----------------------------------------------------
            // 1. TẠO 16 BÓNG ĐÈN LED CHẠY KIỂU LỄ HỘI / CARNIVAL
            // ----------------------------------------------------
            const ledContainer = document.getElementById('led-lights-container');
            const numLeds = 16;
            const leds = [];
            if (ledContainer) {
                for (let i = 0; i < numLeds; i++) {
                    const angle = (i * 2 * Math.PI) / numLeds - Math.PI / 2;
                    const x = 50 + 48.6 * Math.cos(angle);
                    const y = 50 + 48.6 * Math.sin(angle);
                    const bulb = document.createElement('div');
                    bulb.className = 'absolute w-3.5 h-3.5 rounded-full transition-all duration-100 transform -translate-x-1/2 -translate-y-1/2';
                    bulb.style.left = x + '%';
                    bulb.style.top = y + '%';
                    bulb.style.backgroundColor = (i % 2 === 0) ? '#FEF08A' : '#F59E0B';
                    bulb.style.boxShadow = '0 0 6px rgba(245, 158, 11, 0.7)';
                    ledContainer.appendChild(bulb);
                    leds.push(bulb);
                }
            }

            let ledInterval = null;
            let ledChaseIndex = 0;
            function startLedChase() {
                if (ledInterval) clearInterval(ledInterval);
                ledInterval = setInterval(() => {
                    ledChaseIndex = (ledChaseIndex + 1) % numLeds;
                    leds.forEach((bulb, idx) => {
                        const dist = (idx - ledChaseIndex + numLeds) % numLeds;
                        if (dist === 0) {
                            bulb.style.backgroundColor = '#FFFFFF';
                            bulb.style.boxShadow = '0 0 16px #FFFFFF, 0 0 8px #F59E0B';
                            bulb.style.transform = 'translate(-50%, -50%) scale(1.35)';
                        } else if (dist === 1 || dist === 2) {
                            bulb.style.backgroundColor = '#FEF08A';
                            bulb.style.boxShadow = '0 0 8px #FEF08A';
                            bulb.style.transform = 'translate(-50%, -50%) scale(1.15)';
                        } else {
                            bulb.style.backgroundColor = (idx % 2 === 0) ? '#F59E0B' : '#D97706';
                            bulb.style.boxShadow = '0 0 3px rgba(245, 158, 11, 0.35)';
                            bulb.style.transform = 'translate(-50%, -50%) scale(1)';
                        }
                    });
                }, 50);
            }

            function stopLedChase() {
                if (ledInterval) clearInterval(ledInterval);
                leds.forEach((bulb, idx) => {
                    bulb.style.backgroundColor = (idx % 2 === 0) ? '#FEF08A' : '#F59E0B';
                    bulb.style.boxShadow = '0 0 8px rgba(245, 158, 11, 0.7)';
                    bulb.style.transform = 'translate(-50%, -50%) scale(1)';
                });
            }

            // ----------------------------------------------------
            // 2. VẼ BÁNH XE BẰNG HTML5 CANVAS (100% CODE VECTOR MATH)
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

                    // 1. Góc hình quạt với gradient hướng tâm tạo độ sâu 3D
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.arc(0, 0, radius, startAngle, endAngle);
                    ctx.closePath();

                    const baseColor = p.colorBg || '#10B981';
                    const sliceGrad = ctx.createRadialGradient(0, 0, 35, 0, 0, radius);
                    sliceGrad.addColorStop(0, '#FFFFFF');
                    sliceGrad.addColorStop(0.2, baseColor);
                    sliceGrad.addColorStop(1, adjustColorBrightness(baseColor, -25));
                    ctx.fillStyle = sliceGrad;
                    ctx.fill();

                    // Viền nan quạt mạ vàng
                    ctx.strokeStyle = 'rgba(255, 255, 255, 0.75)';
                    ctx.lineWidth = 2;
                    ctx.stroke();

                    // Đinh tán vàng kim loại ở vành ngoài
                    const rivetX = Math.cos(startAngle) * (radius - 5);
                    const rivetY = Math.sin(startAngle) * (radius - 5);
                    ctx.beginPath();
                    ctx.arc(rivetX, rivetY, 2.5, 0, 2 * Math.PI);
                    ctx.fillStyle = '#FEF08A';
                    ctx.fill();
                    ctx.strokeStyle = '#B45309';
                    ctx.lineWidth = 0.8;
                    ctx.stroke();

                    // 2. Tên phần thưởng uốn lượn theo nan quạt
                    ctx.save();
                    const textAngle = startAngle + sliceAngle / 2;
                    ctx.rotate(textAngle);
                    ctx.textAlign = 'right';
                    ctx.textBaseline = 'middle';
                    ctx.shadowColor = 'rgba(0, 0, 0, 0.65)';
                    ctx.shadowBlur = 4;
                    ctx.shadowOffsetX = 1;
                    ctx.shadowOffsetY = 1;
                    ctx.fillStyle = p.colorText || '#FFFFFF';
                    ctx.font = 'bold 12.5px system-ui, -apple-system, sans-serif';

                    let displayName = p.name;
                    if (displayName.length > 15) displayName = displayName.substring(0, 13) + '..';
                    ctx.fillText(displayName, radius - 28, 0);

                    // 3. Vẽ Icon Vector cao cấp bằng Canvas 2D
                    ctx.shadowColor = 'transparent';
                    drawSliceIcon(ctx, p.iconType, radius - 14, 0);

                    ctx.restore();
                }

                // Vành đai tròn vàng bọc ngoài nan quạt
                ctx.beginPath();
                ctx.arc(0, 0, radius, 0, 2 * Math.PI);
                ctx.strokeStyle = '#F59E0B';
                ctx.lineWidth = 5;
                ctx.stroke();

                ctx.beginPath();
                ctx.arc(0, 0, radius - 2.5, 0, 2 * Math.PI);
                ctx.strokeStyle = '#FEF08A';
                ctx.lineWidth = 1.5;
                ctx.stroke();

                // Ổ trục trung tâm 3D mạ vàng
                ctx.beginPath();
                ctx.arc(0, 0, 46, 0, 2 * Math.PI);
                const hubGrad = ctx.createRadialGradient(0, 0, 10, 0, 0, 46);
                hubGrad.addColorStop(0, '#FFFBEB');
                hubGrad.addColorStop(0.5, '#F59E0B');
                hubGrad.addColorStop(1, '#B45309');
                ctx.fillStyle = hubGrad;
                ctx.fill();
                ctx.strokeStyle = '#FEF08A';
                ctx.lineWidth = 3.5;
                ctx.stroke();

                ctx.restore();
            }

            function adjustColorBrightness(hex, percent) {
                let num = parseInt(hex.replace('#', ''), 16);
                let amt = Math.round(2.55 * percent);
                let R = (num >> 16) + amt;
                let G = (num >> 8 & 0x00FF) + amt;
                let B = (num & 0x0000FF) + amt;
                return '#' + (0x1000000 + (R<255?R<1?0:R:255)*0x10000 + (G<255?G<1?0:G:255)*0x100 + (B<255?B<1?0:B:255)).toString(16).slice(1);
            }

            // ----------------------------------------------------
            // 3. VẼ ICON VECTOR TRÊN TỪNG Ô (VOUCHER, XE, QUÀ, SAO...)
            // ----------------------------------------------------
            function drawSliceIcon(c, iconType, x, y) {
                c.save();
                c.translate(x, y);

                if (iconType === 'star') {
                    // Ngôi sao 5 cánh vàng óng
                    c.fillStyle = '#FEF08A';
                    c.strokeStyle = '#B45309';
                    c.lineWidth = 1;
                    c.beginPath();
                    for (let i = 0; i < 5; i++) {
                        c.lineTo(Math.cos((18 + i * 72) * Math.PI / 180) * 7.5, -Math.sin((18 + i * 72) * Math.PI / 180) * 7.5);
                        c.lineTo(Math.cos((54 + i * 72) * Math.PI / 180) * 3.5, -Math.sin((54 + i * 72) * Math.PI / 180) * 3.5);
                    }
                    c.closePath();
                    c.fill();
                    c.stroke();
                } else if (iconType === 'gift') {
                    // Hộp quà 3D
                    c.fillStyle = '#FBBF24';
                    c.fillRect(-6, -4, 12, 9);
                    c.fillStyle = '#EF4444';
                    c.fillRect(-2, -4, 4, 9);
                    c.fillRect(-6, -1, 12, 3);
                    c.strokeStyle = '#FFFFFF';
                    c.lineWidth = 1;
                    c.strokeRect(-6, -4, 12, 9);
                } else if (iconType === 'shipping') {
                    // Xe tải giao hàng freeship
                    c.fillStyle = '#38BDF8';
                    c.fillRect(-7, -4, 8, 7);
                    c.fillRect(1, -2, 5, 5);
                    c.fillStyle = '#FFFFFF';
                    c.fillRect(2, -1.5, 3, 2.5);
                    c.fillStyle = '#1E293B';
                    c.beginPath();
                    c.arc(-4, 3.5, 2, 0, 2 * Math.PI);
                    c.arc(3.5, 3.5, 2, 0, 2 * Math.PI);
                    c.fill();
                } else if (iconType === 'spin') {
                    // Vòng lặp thêm lượt quay
                    c.strokeStyle = '#FEF08A';
                    c.lineWidth = 2;
                    c.beginPath();
                    c.arc(0, 0, 5.5, 0.3 * Math.PI, 1.7 * Math.PI);
                    c.stroke();
                    c.fillStyle = '#FEF08A';
                    c.beginPath();
                    c.moveTo(5, -3); c.lineTo(7, -7); c.lineTo(2, -6);
                    c.closePath();
                    c.fill();
                } else if (iconType === 'luck') {
                    // Cỏ 4 lá may mắn
                    c.fillStyle = '#4ADE80';
                    for (let k = 0; k < 4; k++) {
                        c.save();
                        c.rotate((k * Math.PI) / 2);
                        c.beginPath();
                        c.arc(0, -3.5, 2.5, 0, 2 * Math.PI);
                        c.fill();
                        c.restore();
                    }
                } else {
                    // Vé Voucher giảm giá có răng cưa
                    c.fillStyle = '#FEF08A';
                    c.fillRect(-6.5, -4, 13, 8);
                    c.fillStyle = '#10B981';
                    c.beginPath();
                    c.arc(-6.5, 0, 2, -Math.PI / 2, Math.PI / 2);
                    c.arc(6.5, 0, 2, Math.PI / 2, -Math.PI / 2);
                    c.fill();
                    c.fillStyle = '#065F46';
                    c.font = 'bold 7px sans-serif';
                    c.textAlign = 'center';
                    c.textBaseline = 'middle';
                    c.fillText('%', 0, 0);
                }

                c.restore();
            }

            drawWheel(0);

            // ----------------------------------------------------
            // 4. ÂM THANH WEB AUDIO SYNTHESIZER (TÍC TẮC & CHIẾN THẮNG)
            // ----------------------------------------------------
            const pointerEl = document.getElementById('wheel-pointer');
            function wobblePointer() {
                if (!pointerEl) return;
                pointerEl.style.transform = 'translate(-50%, -8px) rotate(-18deg)';
                setTimeout(() => {
                    pointerEl.style.transform = 'translate(-50%, -8px) rotate(0deg)';
                }, 55);
            }

            function playTickSound() {
                wobblePointer();
                try {
                    const AudioContext = window.AudioContext || window.webkitAudioContext;
                    if (!AudioContext) return;
                    const actx = new AudioContext();
                    const osc = actx.createOscillator();
                    const gain = actx.createGain();
                    osc.type = 'triangle';
                    osc.frequency.setValueAtTime(540, actx.currentTime);
                    osc.frequency.exponentialRampToValueAtTime(130, actx.currentTime + 0.035);
                    gain.gain.setValueAtTime(0.18, actx.currentTime);
                    gain.gain.exponentialRampToValueAtTime(0.01, actx.currentTime + 0.035);
                    osc.connect(gain);
                    gain.connect(actx.destination);
                    osc.start();
                    osc.stop(actx.currentTime + 0.04);
                } catch (e) {}
            }

            function playVictorySound() {
                try {
                    const AudioContext = window.AudioContext || window.webkitAudioContext;
                    if (!AudioContext) return;
                    const actx = new AudioContext();
                    const notes = [523.25, 659.25, 783.99, 1046.50]; // Hợp âm C5, E5, G5, C6
                    notes.forEach((freq, idx) => {
                        const osc = actx.createOscillator();
                        const gain = actx.createGain();
                        osc.type = 'sine';
                        osc.frequency.setValueAtTime(freq, actx.currentTime + idx * 0.12);
                        gain.gain.setValueAtTime(0.2, actx.currentTime + idx * 0.12);
                        gain.gain.exponentialRampToValueAtTime(0.01, actx.currentTime + idx * 0.12 + 0.4);
                        osc.connect(gain);
                        gain.connect(actx.destination);
                        osc.start(actx.currentTime + idx * 0.12);
                        osc.stop(actx.currentTime + idx * 0.12 + 0.45);
                    });
                } catch (e) {}
            }

            // ----------------------------------------------------
            // 5. XỬ LÝ QUAY BÁNH XE
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
                startLedChase();
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

                    // Phát âm thanh & rung kim chỉ khi qua mỗi ô
                    if (Math.abs(currentDeg - lastTickAngle) >= (360 / numSlices)) {
                        playTickSound();
                        lastTickAngle = currentDeg;
                    }

                    if (progress < 1) {
                        requestAnimationFrame(step);
                    } else {
                        stopLedChase();
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
                    playVictorySound();
                } else {
                    if (subTitle) subTitle.innerText = 'XIN CHÚC MỪNG!';
                    if (descEl) descEl.innerText = 'Mã ưu đãi đã được lưu vào Ví quà tặng của bạn.';
                    if (codeBox) codeBox.classList.remove('hidden');
                    if (codeEl) codeEl.innerText = currentPrizeCode;
                    playVictorySound();
                }

                modal.classList.remove('hidden');
                modal.classList.add('flex');
                setTimeout(() => {
                    modalContent.classList.remove('scale-95', 'opacity-0');
                    modalContent.classList.add('scale-100', 'opacity-100');
                    if (data.prizeType !== 'NO_PRIZE') {
                        launchConfetti();
                    }
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

            // Hiệu ứng pháo hoa Confetti cao cấp (sao vàng, ruy băng đa sắc)
            function launchConfetti() {
                const c = document.getElementById('confetti-canvas');
                if (!c) return;
                const cctx = c.getContext('2d');
                c.width = c.offsetWidth;
                c.height = c.offsetHeight;

                const particles = [];
                const colors = ['#10B981', '#F59E0B', '#EF4444', '#3B82F6', '#8B5CF6', '#EC4899', '#FEF08A'];

                for (let i = 0; i < 65; i++) {
                    particles.push({
                        x: c.width / 2,
                        y: c.height / 2,
                        vx: (Math.random() - 0.5) * 12,
                        vy: (Math.random() - 0.5) * 12 - 3,
                        size: Math.random() * 6 + 3,
                        color: colors[Math.floor(Math.random() * colors.length)],
                        alpha: 1,
                        isStar: i % 4 === 0,
                        rotation: Math.random() * 360
                    });
                }

                let animId;
                function render() {
                    cctx.clearRect(0, 0, c.width, c.height);
                    let alive = false;
                    particles.forEach(p => {
                        p.x += p.vx;
                        p.y += p.vy;
                        p.vy += 0.16; // trọng lực
                        p.rotation += 4;
                        p.alpha -= 0.014;
                        if (p.alpha > 0) {
                            alive = true;
                            cctx.save();
                            cctx.globalAlpha = p.alpha;
                            cctx.translate(p.x, p.y);
                            cctx.rotate((p.rotation * Math.PI) / 180);
                            cctx.fillStyle = p.color;
                            if (p.isStar) {
                                // Vẽ ngôi sao
                                cctx.beginPath();
                                for (let k = 0; k < 5; k++) {
                                    cctx.lineTo(Math.cos((18 + k * 72) * Math.PI / 180) * p.size, -Math.sin((18 + k * 72) * Math.PI / 180) * p.size);
                                    cctx.lineTo(Math.cos((54 + k * 72) * Math.PI / 180) * (p.size / 2), -Math.sin((54 + k * 72) * Math.PI / 180) * (p.size / 2));
                                }
                                cctx.closePath();
                                cctx.fill();
                            } else {
                                cctx.fillRect(-p.size / 2, -p.size / 2, p.size, p.size * 0.7);
                            }
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
