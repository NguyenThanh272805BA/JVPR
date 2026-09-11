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
                     class="w-full px-4 py-2.5 rounded-xl border border-outline-variant bg-surface-container-low text-on-surface-variant cursor-not-allowed text-sm">
            </div>
            <div>
              <label class="block font-label-bold text-sm text-on-surface mb-1.5">Địa chỉ Email</label>
              <input type="email" value="${sessionScope.USERMODEL.email}" disabled
                     class="w-full px-4 py-2.5 rounded-xl border border-outline-variant bg-surface-container-low text-on-surface-variant cursor-not-allowed text-sm">
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

<jsp:include page="/WEB-INF/views/components/footer.jsp" />
</body>
</html>