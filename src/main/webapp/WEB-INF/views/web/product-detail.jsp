<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>${product.name} - Fruitables</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">

  <!-- ĐÃ THÊM PLUGIN TYPOGRAPHY ĐỂ RENDER HTML TỪ CKEDITOR -->
  <script src="https://cdn.tailwindcss.com?plugins=forms,typography,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-background min-h-screen flex flex-col">

<!-- NAVBAR -->
<nav class="bg-surface w-full sticky top-0 shadow-sm z-50">
  <div class="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
    <a class="font-display-lg-mobile md:font-display-lg text-display-lg-mobile md:text-display-lg font-extrabold text-primary" href="${pageContext.request.contextPath}/home">
      Fruitables
    </a>
    <div class="hidden md:flex space-x-8 items-center">
      <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/home">Trang chủ</a>
      <a class="font-body-md text-primary font-semibold border-b-2 border-primary pb-1" href="${pageContext.request.contextPath}/shop">Cửa hàng</a>
      <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/promotions">Khuyến mãi</a>
    </div>
    <div class="flex items-center space-x-4">
      <a href="${pageContext.request.contextPath}/cart" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors relative">
        <span class="material-symbols-outlined">shopping_cart</span>
        <span class="absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center">
          ${not empty sessionScope.CART_TOTAL_ITEMS ? sessionScope.CART_TOTAL_ITEMS : 0}
        </span>
      </a>
      <c:choose>
        <c:when test="${not empty sessionScope.USERMODEL}">
          <div class="group relative cursor-pointer">
            <div class="flex items-center gap-2 text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors">
              <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">account_circle</span>
            </div>
            <div class="absolute right-0 mt-2 w-48 bg-surface-container-lowest rounded-md shadow-lg hidden group-hover:block border border-outline-variant z-50 overflow-hidden">
              <c:if test="${sessionScope.USERMODEL.roleId == 1 || sessionScope.USERMODEL.roleId == 2}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="block px-4 py-3 text-on-surface hover:bg-surface-container transition-colors">Trang Quản Trị</a>
              </c:if>
              <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-3 text-error hover:bg-error-container transition-colors border-t border-surface-variant">Đăng xuất</a>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/login" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors">
            <span class="material-symbols-outlined">person</span>
          </a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</nav>

<main class="flex-grow py-12 bg-surface">
  <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">

    <!-- Breadcrumb -->
    <nav class="mb-8 flex text-sm text-on-surface-variant font-medium">
      <a href="${pageContext.request.contextPath}/home" class="hover:text-primary transition-colors">Trang chủ</a>
      <span class="mx-2">/</span>
      <a href="${pageContext.request.contextPath}/shop" class="hover:text-primary transition-colors">Cửa hàng</a>
      <span class="mx-2">/</span>
      <span class="text-primary font-bold line-clamp-1">${product.name}</span>
    </nav>

    <!-- MAIN PRODUCT SECTION -->
    <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-outline-variant p-6 md:p-10 mb-12">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-start">

        <!-- Cột Trái: Ảnh Sản Phẩm (UI Mới) -->
        <div class="relative group">
          <div class="w-full h-[400px] md:h-[500px] bg-surface-container rounded-xl overflow-hidden flex items-center justify-center border border-outline-variant">
            <img src="${product.imageUrl}" alt="${product.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
          </div>
          <!-- Badge trạng thái -->
          <c:if test="${product.stock > 0}">
            <div class="absolute top-4 left-4 bg-primary text-white text-xs font-bold px-3 py-1.5 rounded-full shadow-md flex items-center gap-1">
              <span class="material-symbols-outlined text-[14px]">check_circle</span> Còn hàng
            </div>
          </c:if>
        </div>

        <!-- Cột Phải: Thông tin -->
        <div class="flex flex-col h-full">
          <h1 class="text-3xl md:text-4xl font-headline-md font-bold text-on-surface mb-4 leading-tight">${product.name}</h1>

          <div class="flex items-center gap-4 mb-6 pb-6 border-b border-surface-variant">
            <div class="flex items-center text-yellow-500">
              <span class="material-symbols-outlined text-lg" style="font-variation-settings: 'FILL' 1;">star</span>
              <span class="material-symbols-outlined text-lg" style="font-variation-settings: 'FILL' 1;">star</span>
              <span class="material-symbols-outlined text-lg" style="font-variation-settings: 'FILL' 1;">star</span>
              <span class="material-symbols-outlined text-lg" style="font-variation-settings: 'FILL' 1;">star</span>
              <span class="material-symbols-outlined text-lg" style="font-variation-settings: 'FILL' 1;">star_half</span>
            </div>
            <span class="text-sm text-on-surface-variant font-medium">(Chưa có đánh giá)</span>
            <span class="w-1 h-1 rounded-full bg-outline-variant mx-1"></span>
            <span class="text-sm font-medium text-primary-container">Đã bán: 0</span>
          </div>

          <div class="mb-6">
            <div class="text-4xl font-price-tag text-primary font-extrabold tracking-tight">
              <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> ₫
            </div>
            <c:if test="${product.taxRate > 0}">
              <div class="text-sm text-on-surface-variant mt-1">* Giá chưa bao gồm ${product.taxRate}% Thuế VAT</div>
            </c:if>
          </div>

          <p class="text-on-surface-variant text-base leading-relaxed mb-8">${product.description}</p>

          <!-- Khung ưu đãi (Thêm UI Trust Indicators) -->
          <div class="bg-surface-container-low p-4 rounded-xl border border-surface-variant mb-8 space-y-3">
            <div class="flex items-center gap-3 text-sm text-on-surface">
              <span class="material-symbols-outlined text-primary">local_shipping</span>
              <span>Miễn phí giao hàng cho đơn từ 500.000đ</span>
            </div>
            <div class="flex items-center gap-3 text-sm text-on-surface">
              <span class="material-symbols-outlined text-primary">verified_user</span>
              <span>Cam kết 100% hữu cơ, đổi trả trong 24h nếu không tươi</span>
            </div>
          </div>

          <!-- Form Thêm Giỏ Hàng -->
          <form action="${pageContext.request.contextPath}/cart" method="POST" class="mt-auto flex flex-wrap gap-4">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="${product.id}">

            <div class="flex items-center border-2 border-outline-variant rounded-full overflow-hidden w-36 bg-surface-container-lowest h-14">
              <button type="button" class="w-12 h-full flex items-center justify-center text-on-surface hover:bg-surface-container transition-colors text-xl font-bold" onclick="this.nextElementSibling.stepDown()">-</button>
              <input type="number" name="quantity" value="1" min="1" max="${product.stock}" class="w-12 text-center border-none focus:ring-0 text-on-surface bg-transparent font-label-bold p-0 text-lg">
              <button type="button" class="w-12 h-full flex items-center justify-center text-on-surface hover:bg-surface-container transition-colors text-xl font-bold" onclick="this.previousElementSibling.stepUp()">+</button>
            </div>

            <button type="submit" class="flex-1 min-w-[200px] h-14 bg-primary text-white rounded-full font-label-bold text-lg flex items-center justify-center gap-2 hover:bg-primary-container transition-all duration-300 shadow-[0_4px_14px_0_rgba(129,196,8,0.39)] hover:shadow-[0_6px_20px_rgba(129,196,8,0.23)] hover:-translate-y-1">
              <span class="material-symbols-outlined">add_shopping_cart</span> Thêm vào giỏ
            </button>
          </form>
        </div>
      </div>
    </div>

    <!-- TABS MÔ TẢ & ĐÁNH GIÁ -->
    <div class="bg-surface-container-lowest rounded-2xl border border-outline-variant p-6 md:p-10 shadow-sm">

      <!-- Tab Headers -->
      <div class="flex border-b border-surface-variant mb-8 space-x-8">
        <button id="btn-tab-desc" onclick="switchTab('desc')" class="font-headline-md text-lg font-bold pb-4 border-b-2 border-primary text-primary transition-colors">
          Mô tả chi tiết
        </button>
        <button id="btn-tab-review" onclick="switchTab('review')" class="font-headline-md text-lg font-bold pb-4 border-b-2 border-transparent text-on-surface-variant hover:text-primary transition-colors">
          Đánh giá khách hàng (0)
        </button>
      </div>

      <!-- Nội dung Tab: Mô tả (Sử dụng class prose của Tailwind) -->
      <div id="tab-desc" class="block">
        <c:choose>
          <c:when test="${not empty product.detailedDescription}">
            <!-- Class 'prose max-w-none' sẽ tự động format H1, H2, UL, LI, B, I từ CKEditor -->
            <div class="prose prose-green max-w-none text-on-surface">
                ${product.detailedDescription}
            </div>
          </c:when>
          <c:otherwise>
            <div class="text-center py-10 text-on-surface-variant flex flex-col items-center">
              <span class="material-symbols-outlined text-5xl mb-3 text-outline">article</span>
              <p>Sản phẩm này chưa có mô tả chi tiết.</p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Nội dung Tab: Đánh giá -->
      <div id="tab-review" class="hidden">
        <div class="text-center py-10 text-on-surface-variant flex flex-col items-center">
          <span class="material-symbols-outlined text-5xl mb-3 text-outline">forum</span>
          <p>Chưa có đánh giá nào cho sản phẩm này.</p>
          <p class="text-sm mt-2">Hãy là người đầu tiên mua và đánh giá sản phẩm!</p>
        </div>
        <!-- Vùng này sẽ chèn Form Đánh giá sau vì chưa động tới -->
      </div>

    </div>
  </div>
</main>

<script>
  // Logic chuyển đổi qua lại giữa các Tab
  function switchTab(tabName) {
    const tabDesc = document.getElementById('tab-desc');
    const tabReview = document.getElementById('tab-review');
    const btnDesc = document.getElementById('btn-tab-desc');
    const btnReview = document.getElementById('btn-tab-review');

    if (tabName === 'desc') {
      tabDesc.classList.remove('hidden');
      tabDesc.classList.add('block');
      tabReview.classList.remove('block');
      tabReview.classList.add('hidden');

      btnDesc.classList.add('border-primary', 'text-primary');
      btnDesc.classList.remove('border-transparent', 'text-on-surface-variant');
      btnReview.classList.remove('border-primary', 'text-primary');
      btnReview.classList.add('border-transparent', 'text-on-surface-variant');
    } else {
      tabReview.classList.remove('hidden');
      tabReview.classList.add('block');
      tabDesc.classList.remove('block');
      tabDesc.classList.add('hidden');

      btnReview.classList.add('border-primary', 'text-primary');
      btnReview.classList.remove('border-transparent', 'text-on-surface-variant');
      btnDesc.classList.remove('border-primary', 'text-primary');
      btnDesc.classList.add('border-transparent', 'text-on-surface-variant');
    }
  }
</script>
</body>
</html>