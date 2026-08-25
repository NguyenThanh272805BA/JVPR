<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Khuyến mãi & Ưu đãi - Fruitables</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>

<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col antialiased">

<!-- NAVBAR ĐỒNG BỘ -->
<nav class="bg-surface w-full sticky top-0 shadow-sm z-50">
  <div class="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
    <a class="font-display-lg-mobile md:font-display-lg text-display-lg-mobile md:text-display-lg font-extrabold text-primary" href="${pageContext.request.contextPath}/home">
      Fruitables
    </a>
    <div class="hidden md:flex space-x-8 items-center">
      <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/home">Trang chủ</a>
      <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/shop">Cửa hàng</a>
      <a class="font-body-md text-primary font-semibold border-b-2 border-primary pb-1" href="${pageContext.request.contextPath}/promotions">Khuyến mãi</a>
    </div>
    <div class="flex items-center space-x-4">
      <a href="${pageContext.request.contextPath}/cart" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors relative">
        <span class="material-symbols-outlined">shopping_cart</span>
        <c:if test="${not empty sessionScope.CART_TOTAL_ITEMS && sessionScope.CART_TOTAL_ITEMS > 0}">
                    <span class="absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center">
                        <c:out value="${sessionScope.CART_TOTAL_ITEMS}"/>
                    </span>
        </c:if>
      </a>
      <c:choose>
        <c:when test="${not empty sessionScope.USERMODEL}">
          <div class="group relative cursor-pointer py-2">
            <div class="flex items-center gap-2 text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors">
              <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">account_circle</span>
              <span class="font-label-bold text-label-bold hidden md:block"><c:out value="${sessionScope.USERMODEL.fullName}"/></span>
            </div>
            <div class="absolute right-0 top-full w-48 bg-surface-container-lowest rounded-md shadow-lg hidden group-hover:block border border-outline-variant z-50 overflow-hidden">
              <c:if test="${sessionScope.USERMODEL.roleId == 1 || sessionScope.USERMODEL.roleId == 2}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="block px-4 py-3 text-on-surface hover:bg-surface-container transition-colors">Trang Quản Trị</a>
              </c:if>
              <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-3 text-error hover:bg-error-container transition-colors border-t border-surface-variant">Đăng xuất</a>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/login" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors" title="Đăng nhập">
            <span class="material-symbols-outlined">person</span>
          </a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</nav>

<!-- HERO BANNER KHUYẾN MÃI -->
<section class="relative w-full text-white py-20 bg-[url('https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1920&auto=format&fit=crop](https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1920&auto=format&fit=crop')] bg-cover bg-center">
  <div class="absolute inset-0 bg-black/60"></div> <!-- Lớp màng đen tối màu -->
  <div class="relative max-w-container-max-width mx-auto px-margin-mobile md:px-margin-desktop text-center z-10">
    <span class="bg-primary text-white text-xs font-bold px-4 py-1.5 rounded-full uppercase tracking-wider mb-6 inline-block shadow-lg">Săn Voucher & Flash Sale</span>
    <h1 class="font-display-lg text-4xl md:text-5xl font-extrabold mb-4 drop-shadow-md">Kho Ưu Đãi Độc Quyền</h1>
    <p class="font-body-lg text-gray-200 max-w-xl mx-auto drop-shadow">Khám phá các mã giảm giá và hàng loạt sản phẩm trái cây, nông sản hữu cơ đang được xả kho với mức giá cực sốc.</p>
  </div>
</section>

<!-- MAIN CONTENT: DANH SÁCH VOUCHER & FLASH SALE -->
<main class="flex-grow py-12 bg-background">
  <div class="max-w-container-max-width mx-auto px-margin-mobile md:px-margin-desktop">

    <!-- THÔNG BÁO CHO KHÁCH CHƯA ĐĂNG NHẬP -->
    <c:if test="${empty sessionScope.USERMODEL}">
      <div class="mb-8 p-4 bg-surface-container-high border-l-4 border-primary rounded-r-lg flex items-center justify-between shadow-sm">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary text-3xl">info</span>
          <div>
            <h4 class="font-label-bold text-on-surface">Bạn chưa đăng nhập!</h4>
            <p class="text-sm text-on-surface-variant">Hãy đăng nhập tài khoản thành viên để có thể áp dụng các mã giảm giá này khi thanh toán đơn hàng.</p>
          </div>
        </div>
        <a href="${pageContext.request.contextPath}/login" class="px-6 py-2 bg-primary text-white font-label-bold rounded-full hover:bg-primary-container transition-colors whitespace-nowrap">Đăng nhập ngay</a>
      </div>
    </c:if>

    <!-- DANH SÁCH VOUCHER -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <c:forEach var="coupon" items="${coupons}">
        <div class="bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant overflow-hidden flex flex-col relative hover:shadow-md transition-shadow">
          <!-- Decor viền trái màu xanh -->
          <div class="absolute left-0 top-0 bottom-0 w-3 bg-primary-container"></div>

          <div class="p-6 pl-8 flex flex-col flex-grow">
            <div class="flex justify-between items-start mb-3">
                            <span class="text-xs font-bold uppercase tracking-wider px-2.5 py-1 bg-surface-container text-primary rounded">
                                <c:choose>
                                  <c:when test="${coupon.discountType == 'FIXED'}">Giảm trực tiếp</c:when>
                                  <c:otherwise>Giảm theo phần trăm</c:otherwise>
                                </c:choose>
                            </span>
              <span class="text-xs text-on-surface-variant font-medium">HSD: <fmt:formatDate value="${coupon.endDate}" pattern="dd/MM/yyyy"/></span>
            </div>

            <h3 class="font-headline-md text-2xl text-on-surface font-extrabold mb-1">
              <c:choose>
                <c:when test="${coupon.discountType == 'FIXED'}">
                  -<fmt:formatNumber value="${coupon.discountValue}" type="number" groupingUsed="true"/> ₫
                </c:when>
                <c:otherwise>
                  -<c:out value="${coupon.discountValue}"/>%
                </c:otherwise>
              </c:choose>
            </h3>

            <p class="text-sm text-on-surface-variant mb-6">Đơn hàng tối thiểu: <b class="text-on-surface"><fmt:formatNumber value="${coupon.minOrderValue}" type="number" groupingUsed="true"/> ₫</b></p>

            <div class="mt-auto pt-4 border-t border-surface-variant flex items-center justify-between">
              <div class="bg-surface-container px-3 py-1.5 rounded border border-outline-variant font-mono font-bold text-primary tracking-widest select-all">
                <c:out value="${coupon.code}"/>
              </div>

              <c:choose>
                <c:when test="${not empty sessionScope.USERMODEL}">
                  <a href="${pageContext.request.contextPath}/shop" class="text-xs bg-primary text-white px-4 py-2 rounded-full font-label-bold hover:bg-primary-container transition-colors">
                    Dùng ngay
                  </a>
                </c:when>
                <c:otherwise>
                  <a href="${pageContext.request.contextPath}/login" class="text-xs bg-surface-container-high text-on-surface-variant px-4 py-2 rounded-full font-label-bold hover:text-primary transition-colors">
                    Đăng nhập để dùng
                  </a>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- FLASH SALE SECTION -->
    <c:if test="${not empty flashSaleProducts}">
      <div class="mt-20 mb-8 border-t border-surface-variant pt-12">
        <div class="flex items-center justify-between mb-8">
          <h2 class="font-display-md text-3xl font-extrabold text-on-surface flex items-center gap-2">
            <span class="material-symbols-outlined text-red-500 text-4xl">local_fire_department</span>
            Sản Phẩm Flash Sale
          </h2>
          <a href="${pageContext.request.contextPath}/shop" class="text-primary font-semibold hover:underline transition-colors">Xem tất cả ></a>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          <c:forEach var="product" items="${flashSaleProducts}">
            <div class="bg-white rounded-xl shadow-sm border border-red-100 overflow-hidden hover:shadow-md transition-shadow relative group">

              <!-- Nhãn giảm giá % -->
              <div class="absolute top-2 left-2 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded z-10 shadow-sm">
                - <fmt:formatNumber value="${(product.price - product.discountPrice) / product.price * 100}" maxFractionDigits="0"/>%
              </div>

              <!-- Ảnh sản phẩm -->
              <div class="aspect-square bg-gray-50 overflow-hidden relative">
                <img src="${product.imageUrl}" alt="${product.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
              </div>

              <!-- Thông tin sản phẩm -->
              <div class="p-4 flex flex-col h-full">
                <p class="text-sm text-gray-500 mb-1"><c:out value="${product.categoryName}"/></p>
                <h3 class="font-bold text-gray-800 mb-2 truncate" title="${product.name}"><c:out value="${product.name}"/></h3>

                <div class="flex flex-wrap items-center gap-2 mb-4">
                  <span class="text-red-600 font-bold text-lg"><fmt:formatNumber value="${product.discountPrice}" type="number" groupingUsed="true"/> ₫</span>
                  <span class="text-gray-400 text-sm line-through"><fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> ₫</span>
                </div>

                <!-- Nút Thêm vào giỏ -->
                <button onclick="window.location.href='${pageContext.request.contextPath}/cart/add?id=${product.id}'" class="mt-auto w-full py-2 bg-red-50 text-red-600 font-bold rounded-lg border border-red-200 hover:bg-red-500 hover:text-white transition-colors flex justify-center items-center gap-2">
                  <span class="material-symbols-outlined text-sm">shopping_cart</span> Thêm vào giỏ
                </button>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>
    </c:if>

  </div>
</main>

<!-- FOOTER -->
<footer class="bg-surface-container py-12 border-t border-outline-variant mt-auto">
  <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto text-center text-on-surface-variant font-body-md">
    <p>© 2026 Fruitables. Bài tập lớn công nghệ Java.</p>
  </div>
</footer>

</body>
</html>