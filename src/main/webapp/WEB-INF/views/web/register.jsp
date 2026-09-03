<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Đăng ký - Fruitables</title>

  <!-- Nhúng CSS & Cấu hình Tailwind dùng chung -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col antialiased">

<!-- NAVBAR CHUNG -->
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<main class="flex-grow flex items-center justify-center p-margin-mobile md:p-margin-desktop w-full max-w-container-max-width mx-auto py-12">
  <div class="w-full flex flex-col lg:flex-row bg-surface-container-lowest rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] overflow-hidden min-h-[700px]">

    <!-- Left Side: Image -->
    <div class="relative w-full lg:w-1/2 min-h-[300px] lg:min-h-full hidden md:block">
      <div class="absolute inset-0 bg-cover bg-center" style="background-image: url('https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1974&auto=format&fit=crop');"></div>
      <div class="absolute inset-0 bg-gradient-to-t from-primary/80 to-transparent flex flex-col justify-end p-12">
        <h2 class="font-headline-md text-headline-md text-on-primary mb-4 text-shadow-sm">Gia nhập gia đình Fruitables</h2>
        <p class="font-body-lg text-body-lg text-inverse-on-surface opacity-90 max-w-md">Trải nghiệm sự tươi mới của nông sản hữu cơ được giao tận cửa nhà bạn.</p>
      </div>
    </div>

    <!-- Right Side: Register Form -->
    <div class="w-full lg:w-1/2 flex flex-col justify-center px-6 py-12 md:px-16 md:py-16">
      <div class="max-w-md w-full mx-auto">
        <h1 class="font-display-lg-mobile md:font-display-lg text-display-lg-mobile md:text-display-lg text-on-surface mb-8 hidden md:block">Đăng ký</h1>

        <!-- Hiển thị lỗi nếu có -->
        <c:if test="${not empty message}">
          <div class="bg-error-container text-error p-3 rounded-md mb-6 font-body-md flex items-center shadow-sm">
            <span class="material-symbols-outlined mr-2">error</span>
            <c:out value="${message}"/>
          </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="POST" class="space-y-5">
          <!-- BỔ SUNG: Tên đăng nhập -->
          <div>
            <label class="block font-label-bold text-label-bold text-on-surface-variant mb-1" for="username">Tên đăng nhập *</label>
            <div class="relative">
              <span class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-outline">
                  <span class="material-symbols-outlined">badge</span>
              </span>
              <input class="w-full pl-10 pr-4 py-2.5 bg-background border border-outline-variant rounded-md focus:border-primary-container focus:ring-2 focus:ring-primary-container/20 transition-all"
                     id="username" name="username" placeholder="Nhập tên tài khoản" type="text" required/>
            </div>
          </div>

          <div>
            <label class="block font-label-bold text-label-bold text-on-surface-variant mb-1" for="fullname">Họ và tên *</label>
            <div class="relative">
              <span class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-outline">
                  <span class="material-symbols-outlined">person_outline</span>
              </span>
              <input class="w-full pl-10 pr-4 py-2.5 bg-background border border-outline-variant rounded-md focus:border-primary-container focus:ring-2 focus:ring-primary-container/20 transition-all"
                     id="fullname" name="fullname" placeholder="Nhập họ và tên của bạn" type="text" required/>
            </div>
          </div>

          <!-- BỔ SUNG: Số điện thoại -->
          <div>
            <label class="block font-label-bold text-label-bold text-on-surface-variant mb-1" for="phone">Số điện thoại *</label>
            <div class="relative">
              <span class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-outline">
                  <span class="material-symbols-outlined">call</span>
              </span>
              <input class="w-full pl-10 pr-4 py-2.5 bg-background border border-outline-variant rounded-md focus:border-primary-container focus:ring-2 focus:ring-primary-container/20 transition-all"
                     id="phone" name="phone" placeholder="VD: 0988888888" type="tel" required/>
            </div>
          </div>

          <!-- Email (Đổi thành Tùy chọn) -->
          <div>
            <label class="block font-label-bold text-label-bold text-on-surface-variant mb-1" for="email">
              Email <span class="text-xs text-on-surface-variant font-normal">(Không bắt buộc)</span>
            </label>
            <div class="relative">
              <span class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-outline">
                  <span class="material-symbols-outlined">mail</span>
              </span>
              <input class="w-full pl-10 pr-4 py-2.5 bg-background border border-outline-variant rounded-md focus:border-primary-container focus:ring-2 focus:ring-primary-container/20 transition-all"
                     id="email" name="email" placeholder="ví dụ: ten@email.com" type="email"/>
            </div>
          </div>

          <div>
            <label class="block font-label-bold text-label-bold text-on-surface-variant mb-1" for="password">Mật khẩu *</label>
            <div class="relative">
              <span class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-outline">
                  <span class="material-symbols-outlined">lock</span>
              </span>
              <input class="w-full pl-10 pr-4 py-2.5 bg-background border border-outline-variant rounded-md focus:border-primary-container focus:ring-2 focus:ring-primary-container/20 transition-all"
                     id="password" name="password" placeholder="Tạo mật khẩu mạnh" type="password" required/>
            </div>
          </div>

          <div>
            <label class="block font-label-bold text-label-bold text-on-surface-variant mb-1" for="confirm_password">Xác nhận mật khẩu *</label>
            <div class="relative">
              <span class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-outline">
                  <span class="material-symbols-outlined">check_circle</span>
              </span>
              <input class="w-full pl-10 pr-4 py-2.5 bg-background border border-outline-variant rounded-md focus:border-primary-container focus:ring-2 focus:ring-primary-container/20 transition-all"
                     id="confirm_password" name="confirm_password" placeholder="Nhập lại mật khẩu" type="password" required/>
            </div>
          </div>

          <div class="pt-2">
            <button type="submit" class="w-full flex justify-center py-3.5 px-4 rounded-full shadow-[0px_4px_20px_rgba(129,196,8,0.15)] font-label-bold text-label-bold text-on-primary bg-primary-container hover:bg-primary transition-all duration-300">
              Đăng ký
            </button>
          </div>
        </form>

        <div class="mt-6 text-center">
          <p class="font-body-md text-body-md text-on-surface-variant text-sm">
            Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="font-label-bold text-label-bold text-primary hover:text-primary-container transition-colors ml-1">Đăng nhập</a>
          </p>
        </div>
      </div>
    </div>
  </div>
</main>

<!-- FOOTER CHUNG -->
<jsp:include page="/WEB-INF/views/components/footer.jsp" />
</body>
</html>