<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Hồ sơ cá nhân - Fruitables</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-surface-container bg-pattern min-h-screen flex flex-col antialiased">
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<main class="flex-grow py-10 md:py-12">
  <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto flex flex-col md:flex-row gap-8 items-start">

    <!-- SIDEBAR THÔNG TIN TÀI KHOẢN -->
    <aside class="w-full md:w-1/4">
      <div class="bg-surface-container-lowest p-6 rounded-2xl border border-outline-variant shadow-sm sticky top-28">
        <div class="flex items-center gap-4 mb-6 pb-6 border-b border-surface-variant">
          <div class="w-16 h-16 rounded-full border-2 border-primary flex items-center justify-center bg-surface-container overflow-hidden shrink-0">
            <c:choose>
                <c:when test="${not empty sessionScope.USERMODEL.avatarUrl}">
                    <img src="${sessionScope.USERMODEL.avatarUrl}" alt="Avatar" class="w-full h-full object-cover">
                </c:when>
                <c:otherwise>
                    <span class="material-symbols-outlined text-primary text-3xl">person</span>
                </c:otherwise>
            </c:choose>
          </div>

          <div class="overflow-hidden">
            <p class="text-xs text-on-surface-variant">Tài khoản</p>
            <p class="font-label-bold text-base text-on-surface truncate">${sessionScope.USERMODEL.fullName}</p>
          </div>
        </div>

        <ul class="space-y-2 font-label-bold text-sm">
          <li>
            <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-3 p-3 rounded-xl bg-primary/10 text-primary">
              <span class="material-symbols-outlined text-[20px]">manage_accounts</span> Thông tin tài khoản
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/order-history" class="flex items-center gap-3 p-3 rounded-xl text-on-surface-variant hover:bg-surface-container hover:text-on-surface transition-colors">
              <span class="material-symbols-outlined text-[20px]">receipt_long</span> Lịch sử đơn hàng
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/guest-tracking" class="flex items-center gap-3 p-3 rounded-xl text-on-surface-variant hover:bg-surface-container hover:text-on-surface transition-colors">
              <span class="material-symbols-outlined text-[20px]">local_shipping</span> Tra cứu đơn hàng
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-3 p-3 rounded-xl text-error hover:bg-error-container transition-colors mt-2 border-t border-surface-variant pt-4">
              <span class="material-symbols-outlined text-[20px]">logout</span> Đăng xuất
            </a>
          </li>
        </ul>
      </div>
    </aside>

    <!-- FORM CẬP NHẬT HỒ SƠ & THẺ THÀNH VIÊN VIP -->
    <div class="w-full md:w-3/4 space-y-6">

      <!-- THẺ HỘI VIÊN VIP CARD -->
      <div class="rounded-3xl p-6 md:p-8 text-white shadow-xl relative overflow-hidden bg-gradient-to-br from-slate-900 via-emerald-950 to-slate-900 border border-emerald-500/30">
        <div class="relative z-10 flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
          <div class="space-y-2">
            <div class="flex items-center gap-2">
              <span class="px-3 py-1 rounded-full text-xs font-black uppercase tracking-wider text-slate-900" style="background-color: ${sessionScope.USERMODEL.vipTierColor}">
                ⭐ Hạng ${sessionScope.USERMODEL.vipTier}
              </span>
              <span class="text-xs text-slate-300 font-medium">Fruitables Loyalty Member</span>
            </div>
            <h2 class="text-2xl font-black text-white">${sessionScope.USERMODEL.fullName}</h2>
            <p class="text-xs text-emerald-200/80">Thành viên thân thiết từ <fmt:formatDate value="${sessionScope.USERMODEL.createdAt}" pattern="MM/yyyy"/></p>
          </div>

          <div class="flex items-center gap-6 bg-white/10 backdrop-blur-md p-4 rounded-2xl border border-white/15">
            <div class="text-right">
              <span class="text-[11px] text-slate-300 block">Điểm khả dụng:</span>
              <span class="font-price-tag text-2xl font-black text-amber-400">
                ${sessionScope.USERMODEL.points} <span class="text-xs font-normal text-slate-300">điểm</span>
              </span>
              <span class="text-[10px] text-emerald-300 block mt-0.5">
                (~<fmt:formatNumber value="${sessionScope.USERMODEL.points * 100}" type="number" groupingUsed="true"/> ₫ mua sắm)
              </span>
            </div>
            <div class="w-10 h-10 rounded-full bg-amber-400/20 text-amber-300 flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-2xl">stars</span>
            </div>
          </div>
        </div>

        <div class="relative z-10 mt-6 pt-4 border-t border-white/10 grid grid-cols-1 sm:grid-cols-3 gap-3 text-xs text-slate-300">
          <div class="flex items-center gap-2">
            <span class="material-symbols-outlined text-sm text-emerald-400">percent</span>
            <span>Ưu đãi hạng: <strong class="text-white">${sessionScope.USERMODEL.vipDiscountPercent}%</strong> toàn đơn</span>
          </div>
          <div class="flex items-center gap-2">
            <span class="material-symbols-outlined text-sm text-amber-400">savings</span>
            <span>Tích lũy trọn đời: <strong class="text-white">${sessionScope.USERMODEL.accumulatedPoints} điểm</strong></span>
          </div>
          <div class="flex items-center gap-2">
            <span class="material-symbols-outlined text-sm text-sky-400">redeem</span>
            <span>Quy đổi: <strong class="text-white">1 điểm = 100₫</strong> trừ tiền mặt</span>
          </div>
        </div>
        <span class="material-symbols-outlined absolute -right-8 -bottom-8 text-[180px] text-white/5 pointer-events-none">loyalty</span>
      </div>

      <div class="bg-surface-container-lowest p-6 md:p-10 rounded-2xl shadow-sm border border-outline-variant">
        <h1 class="font-headline-md text-2xl text-on-surface mb-6 border-b border-surface-variant pb-4 font-bold">Thông tin cá nhân</h1>

        <c:if test="${not empty message}">
          <div class="mb-6 bg-primary/10 border border-primary/40 text-primary p-4 rounded-xl flex items-center gap-3 shadow-sm text-sm font-label-bold">
            <span class="material-symbols-outlined">check_circle</span>
            <span>${message}</span>
          </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
          <div class="mb-6 bg-error/10 border border-error/40 text-error p-4 rounded-xl flex items-center gap-3 shadow-sm text-sm font-label-bold">
            <span class="material-symbols-outlined">error</span>
            <span>${errorMessage}</span>
          </div>
        </c:if>

        <!-- BANNER KHUYẾN MẠI LIÊN KẾT GMAIL TẶNG 50K -->
        <c:if test="${empty sessionScope.USERMODEL.email}">
          <div id="gmail-promo-banner" class="mb-6 p-4 rounded-2xl bg-gradient-to-r from-amber-500/15 via-orange-500/15 to-emerald-500/15 border border-amber-500/40 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 shadow-sm">
            <div class="flex items-center gap-3">
              <div class="w-11 h-11 rounded-2xl bg-gradient-to-br from-amber-400 to-orange-500 text-slate-900 font-bold flex items-center justify-center flex-shrink-0 shadow-md">
                <span class="material-symbols-outlined text-2xl">redeem</span>
              </div>
              <div>
                <h4 class="font-label-bold text-sm text-on-surface flex items-center gap-2">
                  <span>Liên kết Gmail ngay - Nhận Voucher 50.000₫</span>
                  <span class="px-2 py-0.5 rounded-full bg-rose-500 text-white text-[10px] font-bold animate-pulse">HOT DEAL</span>
                </h4>
                <p class="text-xs text-on-surface-variant mt-0.5">Bổ sung địa chỉ Gmail để nhận hóa đơn điện tử, thông báo đơn hàng và nhận ngay mã giảm giá 50.000₫!</p>
              </div>
            </div>
            <button type="button" onclick="openOtpModal()" class="px-5 py-2.5 bg-gradient-to-r from-amber-500 to-orange-500 text-white rounded-xl text-xs font-bold shadow-md hover:shadow-lg hover:-translate-y-0.5 transition-all whitespace-nowrap flex items-center gap-1.5 flex-shrink-0">
              <span class="material-symbols-outlined text-[16px]">verified</span> Liên kết ngay
            </button>
          </div>
        </c:if>

        <!-- CONTAINER HIỂN THỊ MÃ VOUCHER NẾU VỪA NHẬN THƯỞNG -->
        <div id="reward-voucher-container" class="${not empty rewardCoupon ? '' : 'hidden'} mb-6 bg-gradient-to-r from-emerald-500/15 via-teal-500/15 to-primary/15 border border-emerald-500/40 text-emerald-900 p-4 rounded-2xl flex items-center gap-3.5 shadow-sm text-sm">
          <span class="material-symbols-outlined text-emerald-600 text-3xl flex-shrink-0">celebration</span>
          <div class="flex-1 min-w-0">
            <p class="font-bold text-emerald-900 text-base">🎉 Chúc mừng bạn đã nhận được Voucher 50.000₫!</p>
            <p class="text-xs text-emerald-800 mt-1">
              Mã ưu đãi của bạn: <span id="reward-voucher-code" class="font-mono font-black text-sm bg-emerald-100 text-emerald-900 px-3 py-1 rounded-lg border border-emerald-300 select-all tracking-wider"><c:out value="${rewardCoupon}"/></span>
              <button type="button" onclick="copyVoucherCode()" class="ml-2 px-2.5 py-1 bg-emerald-600 hover:bg-emerald-700 text-white text-[11px] font-bold rounded-lg transition-colors">
                Sao chép mã
              </button>
              <span class="block sm:inline sm:ml-2 text-[11px] text-emerald-700 mt-1 sm:mt-0">(Giảm 50.000₫ cho đơn từ 150K, áp dụng ngay trong giỏ hàng).</span>
            </p>
          </div>
        </div>

        <form action="${pageContext.request.contextPath}/profile" method="POST" enctype="multipart/form-data" class="space-y-6 max-w-2xl">
          <div>
            <label class="block font-label-bold text-sm text-on-surface mb-2">Ảnh đại diện mới</label>
            <input type="file" name="avatarFile" accept="image/*"
                   class="w-full text-xs text-on-surface-variant file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-label-bold file:bg-primary/10 file:text-primary hover:file:bg-primary/20 transition-colors cursor-pointer">
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
            <div>
              <label class="block font-label-bold text-sm text-on-surface mb-1.5">Tên đăng nhập</label>
              <input type="text" value="${sessionScope.USERMODEL.username}" disabled
                     class="w-full px-4 py-2.5 rounded-xl border border-outline-variant bg-surface-container-low text-on-surface-variant cursor-not-allowed text-sm font-medium">
            </div>
            <div>
              <div class="flex items-center justify-between mb-1.5">
                <label class="font-label-bold text-sm text-on-surface">Địa chỉ Email / Gmail</label>
                <div id="email-badge-container">
                  <c:choose>
                    <c:when test="${not empty sessionScope.USERMODEL.email}">
                      <span class="text-[10px] font-bold text-emerald-700 bg-emerald-100 px-2.5 py-0.5 rounded-full flex items-center gap-1 border border-emerald-200">
                        <span class="material-symbols-outlined text-[13px]">verified</span> Đã liên kết
                      </span>
                    </c:when>
                    <c:otherwise>
                      <span class="text-[10px] font-bold text-amber-700 bg-amber-100 px-2.5 py-0.5 rounded-full flex items-center gap-1 border border-amber-200 animate-pulse">
                        <span class="material-symbols-outlined text-[13px]">redeem</span> Nhận 50K
                      </span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>

              <!-- Hàng nhập Email có nút kích hoạt xác minh OTP -->
              <div class="flex gap-2">
                <input type="email" id="profile-email-display" value="${sessionScope.USERMODEL.email}" readonly
                       placeholder="Chưa liên kết Gmail..."
                       class="w-full px-4 py-2.5 rounded-xl border border-outline-variant bg-surface-container-low text-on-surface text-sm focus:outline-none ${not empty sessionScope.USERMODEL.email ? 'font-medium' : 'text-slate-400'}">
                <button type="button" onclick="openOtpModal()" id="btn-link-email-trigger"
                        class="px-3.5 py-2 rounded-xl text-xs font-label-bold flex items-center gap-1 transition-all whitespace-nowrap flex-shrink-0 ${not empty sessionScope.USERMODEL.email ? 'border border-outline-variant hover:bg-surface-container text-on-surface-variant' : 'bg-gradient-to-r from-amber-500 to-orange-500 text-white shadow-sm hover:shadow hover:-translate-y-0.5'}">
                  <span class="material-symbols-outlined text-[16px]">${not empty sessionScope.USERMODEL.email ? 'edit' : 'link'}</span>
                  <span>${not empty sessionScope.USERMODEL.email ? 'Thay đổi' : 'Liên kết'}</span>
                </button>
              </div>
            </div>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
            <div>
              <label class="block font-label-bold text-sm text-on-surface mb-1.5">Họ và tên <span class="text-error">*</span></label>
              <input type="text" name="fullName" value="${sessionScope.USERMODEL.fullName}" required
                     class="w-full px-4 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm">
            </div>
            <div>
              <label class="block font-label-bold text-sm text-on-surface mb-1.5">Số điện thoại</label>
              <input type="tel" name="phone" value="${sessionScope.USERMODEL.phone}"
                     class="w-full px-4 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm">
            </div>
          </div>

          <div>
            <label class="block font-label-bold text-sm text-on-surface mb-1.5">Địa chỉ nhận hàng mặc định</label>
            <textarea name="address" rows="3" placeholder="Nhập địa chỉ nhà của bạn..."
                      class="w-full px-4 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm leading-relaxed">${sessionScope.USERMODEL.address}</textarea>
          </div>

          <div class="pt-2">
            <button type="submit" class="flex items-center justify-center gap-2 bg-primary text-white px-8 py-3 rounded-full font-label-bold hover:bg-primary-container transition-all shadow-md hover:-translate-y-0.5 text-sm">
              <span class="material-symbols-outlined text-[18px]">save</span> Lưu thay đổi
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</main>

<!-- ============================================================ -->
<!-- MODAL POPUP: XÁC MINH GMAIL BẰNG MÃ OTP & NHẬN VOUCHER 50K  -->
<!-- ============================================================ -->
<div id="otp-modal" class="fixed inset-0 bg-slate-950/60 backdrop-blur-sm z-[200] hidden items-center justify-center p-4">
  <div class="bg-white rounded-3xl max-w-md w-full p-6 sm:p-7 shadow-2xl border border-slate-200 relative overflow-hidden transition-all duration-300">
    <!-- Nút đóng Modal -->
    <button type="button" onclick="closeOtpModal()" class="absolute top-4 right-4 w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 hover:text-slate-700 flex items-center justify-center transition-colors">
      <span class="material-symbols-outlined text-[20px]">close</span>
    </button>

    <!-- Header Modal -->
    <div class="flex items-center gap-3 mb-5">
      <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-amber-400 to-orange-500 text-white flex items-center justify-center shadow-lg shadow-orange-500/20 flex-shrink-0">
        <span class="material-symbols-outlined text-[26px]">mail_lock</span>
      </div>
      <div>
        <h3 class="font-headline-sm text-lg font-bold text-slate-900">Xác minh liên kết Gmail</h3>
        <p class="text-xs text-slate-500 mt-0.5">Xác thực chính chủ để nhận ngay Voucher 50.000₫</p>
      </div>
    </div>

    <!-- Thông báo lỗi / thông tin trong Modal -->
    <div id="modal-alert-box" class="hidden mb-4 p-3 rounded-xl text-xs font-medium flex items-center gap-2"></div>

    <!-- BƯỚC 1: NHẬP ĐỊA CHỈ GMAIL -->
    <div id="otp-step-1" class="space-y-4">
      <div>
        <label class="block text-xs font-bold text-slate-700 mb-1.5">Địa chỉ Gmail của bạn</label>
        <div class="relative">
          <input type="email" id="modal-gmail-input" placeholder="Ví dụ: yourname@gmail.com"
                 value="${sessionScope.USERMODEL.email}"
                 class="w-full pl-10 pr-4 py-2.5 rounded-xl border border-slate-300 focus:border-primary focus:ring-1 focus:ring-primary outline-none text-sm bg-slate-50 focus:bg-white text-slate-800 transition-all">
          <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-[18px]">mail</span>
        </div>
        <p class="text-[11px] text-slate-400 mt-1">Mã xác minh gồm 6 số sẽ được gửi tới hộp thư này.</p>
      </div>

      <button type="button" id="btn-send-otp" onclick="handleSendOtp()"
              class="w-full py-3 bg-gradient-to-r from-primary to-[#6ca305] hover:from-[#6ca305] hover:to-primary text-white font-bold text-sm rounded-xl shadow-md hover:shadow-lg transition-all flex items-center justify-center gap-2">
        <span class="material-symbols-outlined text-[18px]">send</span>
        <span>Gửi mã xác minh OTP</span>
      </button>
    </div>

    <!-- BƯỚC 2: NHẬP MÃ OTP 6 CHỮ SỐ -->
    <div id="otp-step-2" class="space-y-4 hidden">
      <div class="bg-amber-50 border border-amber-200 rounded-xl p-3 text-xs text-amber-800">
        Mã OTP đã được gửi tới: <strong id="display-target-email" class="text-slate-900"></strong>.
        Vui lòng kiểm tra Hộp thư đến (hoặc thư mục Spam/Quảng cáo).
      </div>

      <div>
        <label class="block text-xs font-bold text-slate-700 mb-1.5 text-center">Nhập mã xác minh 6 số</label>
        <input type="text" id="modal-otp-input" maxlength="6" autocomplete="one-time-code"
               placeholder="______"
               class="w-full text-center tracking-[0.5em] text-2xl font-black font-mono py-2.5 rounded-xl border-2 border-primary/50 focus:border-primary outline-none bg-primary/5 text-slate-900 transition-all">
        <div class="flex items-center justify-between mt-2 text-[11px] text-slate-500">
          <span id="otp-countdown-text">Mã có hiệu lực: <strong id="otp-timer">05:00</strong></span>
          <button type="button" onclick="handleSendOtp()" id="btn-resend-otp" class="text-primary hover:underline font-bold">Gửi lại mã</button>
        </div>
      </div>

      <button type="button" id="btn-verify-otp" onclick="handleVerifyOtp()"
              class="w-full py-3 bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600 text-white font-bold text-sm rounded-xl shadow-md hover:shadow-lg transition-all flex items-center justify-center gap-2">
        <span class="material-symbols-outlined text-[18px]">verified</span>
        <span>Xác nhận & Nhận Voucher 50K</span>
      </button>

      <button type="button" onclick="backToStep1()" class="w-full text-center text-xs text-slate-400 hover:text-slate-600 py-1 font-medium">
        ← Đổi địa chỉ Gmail khác
      </button>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<script>
  let otpTimerInterval = null;

  function openOtpModal() {
    const modal = document.getElementById('otp-modal');
    modal.classList.remove('hidden');
    modal.classList.add('flex');
    hideAlert();
    backToStep1();
  }

  function closeOtpModal() {
    const modal = document.getElementById('otp-modal');
    modal.classList.add('hidden');
    modal.classList.remove('flex');
    if (otpTimerInterval) clearInterval(otpTimerInterval);
  }

  function backToStep1() {
    document.getElementById('otp-step-1').classList.remove('hidden');
    document.getElementById('otp-step-2').classList.add('hidden');
    hideAlert();
  }

  function showAlert(msg, isError) {
    const box = document.getElementById('modal-alert-box');
    box.className = isError
      ? 'mb-4 p-3 rounded-xl text-xs font-bold flex items-center gap-2 bg-rose-50 text-rose-700 border border-rose-200'
      : 'mb-4 p-3 rounded-xl text-xs font-bold flex items-center gap-2 bg-emerald-50 text-emerald-800 border border-emerald-200';
    box.innerHTML = '<span class="material-symbols-outlined text-sm">' + (isError ? 'error' : 'check_circle') + '</span><span>' + msg + '</span>';
    box.classList.remove('hidden');
  }

  function hideAlert() {
    const box = document.getElementById('modal-alert-box');
    box.classList.add('hidden');
    box.innerHTML = '';
  }

  function startCountdown(durationSeconds) {
    if (otpTimerInterval) clearInterval(otpTimerInterval);
    let remaining = durationSeconds;
    const timerEl = document.getElementById('otp-timer');
    const resendBtn = document.getElementById('btn-resend-otp');
    resendBtn.disabled = true;
    resendBtn.classList.add('opacity-50', 'cursor-not-allowed');

    function update() {
      const m = Math.floor(remaining / 60);
      const s = remaining % 60;
      timerEl.innerText = (m < 10 ? '0' + m : m) + ':' + (s < 10 ? '0' + s : s);
      if (remaining <= 0) {
        clearInterval(otpTimerInterval);
        timerEl.innerText = 'Hết hạn';
        resendBtn.disabled = false;
        resendBtn.classList.remove('opacity-50', 'cursor-not-allowed');
      }
      remaining--;
    }

    update();
    otpTimerInterval = setInterval(update, 1000);
  }

  function handleSendOtp() {
    const email = document.getElementById('modal-gmail-input').value.trim();
    if (!email) {
      showAlert('Vui lòng nhập địa chỉ Gmail!', true);
      return;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      showAlert('Địa chỉ Email không đúng định dạng hợp lệ!', true);
      return;
    }

    const btn = document.getElementById('btn-send-otp');
    const originalText = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = '<span class="material-symbols-outlined text-[18px] animate-spin">progress_activity</span><span>Đang gửi mã OTP...</span>';
    hideAlert();

    fetch('${pageContext.request.contextPath}/api/link-email', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
      body: 'action=send_otp&email=' + encodeURIComponent(email)
    })
    .then(res => res.json())
    .then(data => {
      btn.disabled = false;
      btn.innerHTML = originalText;
      if (data.success) {
        document.getElementById('display-target-email').innerText = email;
        document.getElementById('otp-step-1').classList.add('hidden');
        document.getElementById('otp-step-2').classList.remove('hidden');
        document.getElementById('modal-otp-input').value = '';
        document.getElementById('modal-otp-input').focus();
        showAlert(data.message || 'Mã OTP đã được gửi!', false);
        startCountdown(300);
      } else {
        showAlert(data.message || 'Không thể gửi mã OTP, vui lòng thử lại!', true);
      }
    })
    .catch(err => {
      btn.disabled = false;
      btn.innerHTML = originalText;
      showAlert('Lỗi kết nối máy chủ: ' + err.message, true);
    });
  }

  function handleVerifyOtp() {
    const otp = document.getElementById('modal-otp-input').value.trim();
    if (!otp || otp.length !== 6) {
      showAlert('Vui lòng nhập đủ 6 chữ số mã OTP!', true);
      return;
    }

    const btn = document.getElementById('btn-verify-otp');
    const originalText = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = '<span class="material-symbols-outlined text-[18px] animate-spin">progress_activity</span><span>Đang xác thực...</span>';
    hideAlert();

    fetch('${pageContext.request.contextPath}/api/link-email', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
      body: 'action=verify_otp&otpCode=' + encodeURIComponent(otp)
    })
    .then(res => res.json())
    .then(data => {
      btn.disabled = false;
      btn.innerHTML = originalText;
      if (data.success) {
        // Cập nhật giao diện trang cá nhân tức thì
        const displayInput = document.getElementById('profile-email-display');
        if (displayInput) {
          displayInput.value = data.email;
          displayInput.classList.remove('text-slate-400');
          displayInput.classList.add('font-medium');
        }

        const badgeContainer = document.getElementById('email-badge-container');
        if (badgeContainer) {
          badgeContainer.innerHTML = `
            <span class="text-[10px] font-bold text-emerald-700 bg-emerald-100 px-2.5 py-0.5 rounded-full flex items-center gap-1 border border-emerald-200">
              <span class="material-symbols-outlined text-[13px]">verified</span> Đã liên kết
            </span>
          `;
        }

        const triggerBtn = document.getElementById('btn-link-email-trigger');
        if (triggerBtn) {
          triggerBtn.className = 'px-3.5 py-2 rounded-xl text-xs font-label-bold flex items-center gap-1 transition-all whitespace-nowrap flex-shrink-0 border border-outline-variant hover:bg-surface-container text-on-surface-variant';
          triggerBtn.innerHTML = '<span class="material-symbols-outlined text-[16px]">edit</span><span>Thay đổi</span>';
        }

        const promoBanner = document.getElementById('gmail-promo-banner');
        if (promoBanner) promoBanner.remove();

        if (data.rewardCoupon) {
          const voucherCard = document.getElementById('reward-voucher-container');
          const codeEl = document.getElementById('reward-voucher-code');
          if (codeEl) codeEl.innerText = data.rewardCoupon;
          if (voucherCard) voucherCard.classList.remove('hidden');
        }

        closeOtpModal();
        alert('🎉 ' + data.message + (data.rewardCoupon ? '\nMã Voucher 50K của bạn: ' + data.rewardCoupon : ''));
      } else {
        showAlert(data.message || 'Mã OTP không chính xác!', true);
      }
    })
    .catch(err => {
      btn.disabled = false;
      btn.innerHTML = originalText;
      showAlert('Lỗi kết nối máy chủ: ' + err.message, true);
    });
  }

  function copyVoucherCode() {
    const code = document.getElementById('reward-voucher-code')?.innerText.trim();
    if (code) {
      navigator.clipboard.writeText(code).then(() => {
        alert('Đã sao chép mã ưu đãi: ' + code);
      });
    }
  }
</script>
</body>
</html>