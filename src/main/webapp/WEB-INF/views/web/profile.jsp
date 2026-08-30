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
<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col antialiased">

<!-- NAVBAR (Chuẩn của Fruitables Web) -->
<nav class="bg-surface w-full sticky top-0 shadow-sm z-50">
  <div class="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
    <a class="font-display-lg-mobile font-extrabold text-primary" href="${pageContext.request.contextPath}/home">Fruitables</a>
    <div class="flex items-center space-x-4">
      <a href="${pageContext.request.contextPath}/shop" class="text-on-surface-variant hover:text-primary font-label-bold mr-4 hidden md:block transition-colors">Tiếp tục mua sắm</a>
      <a href="${pageContext.request.contextPath}/cart" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors relative flex items-center">
        <span class="material-symbols-outlined">shopping_cart</span>
      </a>
    </div>
  </div>
</nav>

<!-- MAIN CONTENT -->
<main class="flex-grow py-12">
  <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto flex flex-col md:flex-row gap-8">

    <!-- SIDEBAR TÀI KHOẢN -->
    <aside class="w-full md:w-1/4">
      <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant shadow-sm sticky top-28">
        <div class="flex items-center gap-4 mb-6 pb-6 border-b border-surface-variant">
          <div class="w-14 h-14 bg-primary rounded-full flex items-center justify-center text-white text-2xl">
            <span class="material-symbols-outlined">person</span>
          </div>
          <div>
            <p class="text-sm text-on-surface-variant">Tài khoản của</p>
            <p class="font-label-bold text-lg text-on-surface">${sessionScope.USERMODEL.fullName}</p>
          </div>
        </div>
        <ul class="space-y-2 font-label-bold">
          <li>
            <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-3 p-3 rounded-lg bg-primary-container/10 text-primary-container">
              <span class="material-symbols-outlined">manage_accounts</span> Thông tin tài khoản
            </a>
          </li>
          <li>
            <a href="#" class="flex items-center gap-3 p-3 rounded-lg text-on-surface-variant hover:bg-surface-container hover:text-on-surface transition-colors">
              <span class="material-symbols-outlined">receipt_long</span> Quản lý đơn hàng
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-3 p-3 rounded-lg text-error hover:bg-error-container transition-colors mt-4">
              <span class="material-symbols-outlined">logout</span> Đăng xuất
            </a>
          </li>
        </ul>
      </div>
    </aside>

    <!-- FORM CẬP NHẬT -->
    <div class="w-full md:w-3/4">
      <div class="bg-surface-container-lowest p-6 md:p-10 rounded-xl shadow-sm border border-outline-variant">
        <h1 class="font-headline-md text-2xl text-on-surface mb-6 border-b border-surface-variant pb-4">Hồ sơ cá nhân</h1>

        <c:if test="${not empty message}">
          <div class="mb-6 bg-primary-container/20 border border-primary-container text-primary p-4 rounded-xl flex items-center gap-3 shadow-sm">
            <span class="material-symbols-outlined">check_circle</span>
            <span class="font-label-bold">${message}</span>
          </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/profile" method="POST" class="space-y-6 max-w-2xl">
          <div class="mb-6">
            <label class="block font-label-bold text-on-surface mb-2">Email đăng nhập <span class="text-error">*</span></label>
            <div class="relative">
              <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant">mail</span>
              <input type="email" value="${sessionScope.USERMODEL.email}" disabled
                     class="w-full pl-12 pr-4 py-3 rounded-lg border border-outline-variant bg-surface-container-low text-on-surface-variant cursor-not-allowed">
            </div>
            <p class="text-xs text-on-surface-variant mt-2">Email không thể thay đổi để đảm bảo bảo mật tài khoản.</p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block font-label-bold text-on-surface mb-2">Họ và tên <span class="text-error">*</span></label>
              <input type="text" name="fullName" value="${sessionScope.USERMODEL.fullName}" required
                     class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface transition-colors">
            </div>
            <div>
              <label class="block font-label-bold text-on-surface mb-2">Số điện thoại</label>
              <input type="tel" name="phone" value="${sessionScope.USERMODEL.phone}"
                     class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface transition-colors">
            </div>
          </div>

          <div>
            <label class="block font-label-bold text-on-surface mb-2">Địa chỉ nhận hàng mặc định</label>
            <textarea name="address" rows="3" placeholder="Nhập địa chỉ của bạn (Số nhà, đường, xã/phường...)"
                      class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface transition-colors">${sessionScope.USERMODEL.address}</textarea>
          </div>

          <div class="pt-4">
            <button type="submit" class="flex items-center justify-center gap-2 bg-primary text-white px-8 py-3 rounded-full font-label-bold hover:bg-primary-container transition-all duration-300 shadow-md hover:-translate-y-1">
              <span class="material-symbols-outlined">save</span>
              Lưu thay đổi
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</main>
</body>
</html>