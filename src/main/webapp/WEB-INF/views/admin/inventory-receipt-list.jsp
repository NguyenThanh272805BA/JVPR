<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Kho Nhập Hàng & Tồn Kho - Fruitables Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-surface font-body-md flex h-screen overflow-hidden">

<c:set var="currentURI" value="${requestScope['javax.servlet.forward.request_uri']}" />
<aside class="w-64 bg-surface-container-lowest border-r border-surface-variant flex flex-col h-full flex-shrink-0 z-20 shadow-sm hidden md:flex">
  <div class="h-20 flex items-center px-6 border-b border-surface-variant">
    <a class="group flex items-center gap-2.5" href="${pageContext.request.contextPath}/admin/dashboard">
        <div class="w-8 h-8 rounded-xl bg-gradient-to-br from-[#84cc16] via-[#65a30d] to-[#4d7c0f] flex items-center justify-center text-white shadow-sm flex-shrink-0 group-hover:scale-105 transition-transform">
            <svg class="w-4 h-4 text-white" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2C12 2 12.5 5 10 7C7.5 9 6 12 6 15C6 18.3137 8.68629 21 12 21C15.3137 21 18 18.3137 18 15C18 12 16.5 9 14 7C11.5 5 12 2 12 2Z" fill="currentColor"/>
                <path d="M12 2C12 2 13.2 4.2 15.5 4.2C17.5 4.2 18.5 2.8 18.5 2.8C18.5 2.8 18 5.2 16 5.8C14 6.4 12.5 5.2 12 2Z" fill="#fef08a"/>
            </svg>
        </div>
        <div class="flex flex-col">
            <span class="text-base font-black tracking-tight leading-none text-slate-900">Fruit<span class="text-primary">ables</span></span>
            <span class="text-[8px] font-bold text-primary tracking-wider uppercase mt-0.5">Admin Portal</span>
        </div>
    </a>
  </div>
  <nav class="flex-1 overflow-y-auto py-6 px-4 space-y-2">
    <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/dashboard') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/dashboard">
      <span class="material-symbols-outlined">dashboard</span>
      <span class="font-label-bold">Tổng quan</span>
    </a>
    <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/products') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/products">
      <span class="material-symbols-outlined">inventory_2</span>
      <span class="font-label-bold">Sản phẩm</span>
    </a>
    <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/inventory') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/inventory">
      <span class="material-symbols-outlined">warehouse</span>
      <span class="font-label-bold">Kho nhập hàng</span>
    </a>
    <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/categories') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/categories">
      <span class="material-symbols-outlined">category</span>
      <span class="font-label-bold">Danh mục</span>
    </a>
    <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/orders') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/orders">
      <span class="material-symbols-outlined">receipt_long</span>
      <span class="font-label-bold">Đơn hàng</span>
    </a>
    <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/coupons') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/coupons">
      <span class="material-symbols-outlined">redeem</span>
      <span class="font-label-bold">Mã khuyến mãi</span>
    </a>
  </nav>
</aside>

<main class="flex-1 flex flex-col h-screen overflow-hidden">
  <header class="h-20 bg-surface flex items-center justify-between px-6 shadow-sm z-10 flex-shrink-0 border-b border-surface-variant">
    <div class="flex items-center gap-3 min-w-0">
      <h2 class="font-bold text-lg text-slate-800 truncate">Hệ Thống Kho Nhập Hàng & Tồn Kho</h2>
    </div>
    <div class="flex items-center gap-3 flex-shrink-0">
      <span class="font-label-bold hidden sm:inline-block max-w-[150px] truncate whitespace-nowrap text-sm" title="${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}">
        ${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}
      </span>
      <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full transition-colors flex-shrink-0" title="Đăng xuất">
        <span class="material-symbols-outlined">logout</span>
      </a>
    </div>
  </header>

  <div class="flex-1 overflow-y-auto p-4 sm:p-6 bg-[#f8fafc] space-y-6">
    <!-- Thông báo thành công nếu có -->
    <c:if test="${not empty sessionScope.SUCCESS_MSG}">
        <div class="p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 flex items-center justify-between shadow-xs">
            <div class="flex items-center gap-2.5">
                <span class="material-symbols-outlined text-emerald-600">check_circle</span>
                <span class="text-sm font-semibold">${sessionScope.SUCCESS_MSG}</span>
            </div>
            <button onclick="this.parentElement.remove()" class="text-emerald-500 hover:text-emerald-700">
                <span class="material-symbols-outlined text-sm">close</span>
            </button>
        </div>
        <c:remove var="SUCCESS_MSG" scope="session"/>
    </c:if>

    <!-- Top Action & Title Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="font-headline-md text-2xl font-black text-on-surface">Quản lý Kho Nhập Hàng</h1>
        <p class="text-xs text-slate-500 mt-1">Lịch sử nhập kho, quản lý giá vốn bình quân gia quyền (COGS) và điều chuyển tồn kho</p>
      </div>
      <div class="flex items-center gap-3 flex-wrap">
        <a href="${pageContext.request.contextPath}/admin/suppliers" class="inline-flex items-center gap-2 px-4 py-2 bg-white border border-slate-300 hover:bg-slate-50 text-slate-700 rounded-xl font-bold text-xs shadow-sm transition-all">
          <span class="material-symbols-outlined text-base">store</span>
          <span>Nhà cung cấp</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/inventory/create" class="inline-flex items-center gap-2 px-4 py-2 bg-primary hover:bg-primary-container text-white rounded-xl font-bold text-xs shadow-sm transition-all hover:shadow-md">
          <span class="material-symbols-outlined text-base">add_circle</span>
          <span>Tạo phiếu nhập mới</span>
        </a>
      </div>
    </div>

    <!-- TÍNH TOÁN NHANH TỔNG GIÁ TRỊ KHO -->
    <c:set var="totalInventoryValue" value="0"/>
    <c:set var="totalStockUnits" value="0"/>
    <c:forEach var="p" items="${products}">
      <c:set var="totalInventoryValue" value="${totalInventoryValue + (p.stock * p.costPrice)}"/>
      <c:set var="totalStockUnits" value="${totalStockUnits + p.stock}"/>
    </c:forEach>

    <!-- 3 Thẻ thống kê nhanh -->
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
      <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-xs flex items-center gap-4">
        <div class="w-12 h-12 rounded-xl bg-primary/10 text-primary flex items-center justify-center flex-shrink-0">
          <span class="material-symbols-outlined text-2xl">receipt_long</span>
        </div>
        <div>
          <span class="text-xs text-slate-500 font-semibold block">Tổng phiếu nhập kho</span>
          <div class="text-xl font-black text-slate-800">${fn:length(receipts)} <span class="text-xs font-normal text-slate-400">đợt nhập</span></div>
        </div>
      </div>

      <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-xs flex items-center gap-4">
        <div class="w-12 h-12 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center flex-shrink-0">
          <span class="material-symbols-outlined text-2xl">warehouse</span>
        </div>
        <div>
          <span class="text-xs text-slate-500 font-semibold block">Mặt hàng trong kho</span>
          <div class="text-xl font-black text-slate-800">${fn:length(products)} <span class="text-xs font-normal text-slate-400">sản phẩm (${totalStockUnits} đơn vị)</span></div>
        </div>
      </div>

      <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-xs flex items-center gap-4">
        <div class="w-12 h-12 rounded-xl bg-amber-50 text-amber-700 flex items-center justify-center flex-shrink-0">
          <span class="material-symbols-outlined text-2xl">savings</span>
        </div>
        <div>
          <span class="text-xs text-slate-500 font-semibold block">Tổng giá trị vốn tồn kho</span>
          <div class="text-xl font-black text-amber-700">
            <fmt:formatNumber value="${totalInventoryValue}" type="number" groupingUsed="true"/> ₫
          </div>
        </div>
      </div>
    </div>

    <!-- TABS ĐIỀU HƯỚNG VIEW -->
    <div class="flex items-center gap-4 border-b border-slate-200">
      <button id="tabBtnReceipts" onclick="switchView('receipts')" class="pb-3 text-sm font-bold text-primary border-b-2 border-primary flex items-center gap-2 transition-all">
        <span class="material-symbols-outlined text-base">history</span>
        Lịch Sử Phiếu Nhập Kho (${fn:length(receipts)})
      </button>
      <button id="tabBtnStock" onclick="switchView('stock')" class="pb-3 text-sm font-bold text-slate-500 border-b-2 border-transparent hover:text-slate-800 flex items-center gap-2 transition-all">
        <span class="material-symbols-outlined text-base">inventory_2</span>
        Sản Phẩm Trong Kho & Giá Vốn (${fn:length(products)})
      </button>
    </div>

    <!-- VIEW 1: BẢNG DANH SÁCH PHIẾU NHẬP -->
    <div id="viewReceipts" class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-variant overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
          <thead>
            <tr class="bg-slate-50 text-slate-600 font-bold text-xs uppercase tracking-wider border-b border-slate-200">
              <th class="py-4 px-6">Mã Phiếu</th>
              <th class="py-4 px-6">Thời Gian Nhập</th>
              <th class="py-4 px-6">Nhà Cung Cấp</th>
              <th class="py-4 px-6">Người Nhập</th>
              <th class="py-4 px-6 text-center">Số Mặt Hàng</th>
              <th class="py-4 px-6">Tổng Chi Phí Vốn</th>
              <th class="py-4 px-6 text-center">Trạng Thái</th>
              <th class="py-4 px-6 text-right">Thao Tác</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100 text-sm text-slate-700">
            <c:choose>
              <c:when test="${not empty receipts}">
                <c:forEach var="r" items="${receipts}">
                  <tr class="hover:bg-slate-50/60 transition-colors">
                    <td class="py-4 px-6 font-mono font-bold text-primary text-xs">
                      ${r.receiptCode}
                    </td>
                    <td class="py-4 px-6 text-xs text-slate-500">
                      <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                    </td>
                    <td class="py-4 px-6 font-medium text-xs">
                      ${not empty r.supplierName ? r.supplierName : 'Nhà cung cấp tự do'}
                    </td>
                    <td class="py-4 px-6 text-xs text-slate-600">
                      ${not empty r.creatorName ? r.creatorName : 'Admin Quản Trị'}
                    </td>
                    <td class="py-4 px-6 text-center">
                      <span class="inline-block px-2.5 py-1 rounded-full text-xs font-bold bg-slate-100 text-slate-700">
                        ${r.totalItems != null ? r.totalItems : (r.itemCount != null ? r.itemCount : 0)} sản phẩm
                      </span>
                    </td>
                    <td class="py-4 px-6 font-bold text-slate-900 text-sm">
                      <fmt:formatNumber value="${r.totalCost}" type="number" groupingUsed="true"/> ₫
                    </td>
                    <td class="py-4 px-6 text-center">
                      <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-emerald-100 text-emerald-800">
                        <span class="material-symbols-outlined text-xs">check_circle</span> Hoàn thành
                      </span>
                    </td>
                    <td class="py-4 px-6 text-right">
                      <a href="${pageContext.request.contextPath}/admin/inventory/detail?id=${r.id}" class="inline-flex items-center gap-1 text-primary hover:text-primary-container font-bold text-xs px-3 py-1.5 rounded-lg hover:bg-primary/5 transition-colors">
                        <span>Chi tiết</span>
                        <span class="material-symbols-outlined text-sm">arrow_forward</span>
                      </a>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="8" class="text-center py-12 text-slate-400 text-sm">
                    <span class="material-symbols-outlined text-4xl mb-2 block">inventory_2</span>
                    Chưa có phiếu nhập kho nào trong hệ thống.
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>

    <!-- VIEW 2: BẢNG SẢN PHẨM TRONG KHO & GIÁ VỐN (KÈM NÚT NHẬP THÊM) -->
    <div id="viewStock" class="hidden bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-variant overflow-hidden">
      <div class="p-4 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-wrap gap-2">
        <span class="text-xs text-slate-600 font-semibold">Danh sách toàn bộ sản phẩm trong kho. Bấm "Nhập thêm hàng" để tạo nhanh phiếu nhập cho sản phẩm đó.</span>
        <a href="${pageContext.request.contextPath}/admin/inventory/create" class="px-3.5 py-1.5 bg-primary text-white rounded-lg text-xs font-bold flex items-center gap-1 shadow-xs">
          <span class="material-symbols-outlined text-sm">add</span> Nhập hàng mới
        </a>
      </div>
      <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse text-xs">
          <thead>
            <tr class="bg-slate-50 text-slate-600 font-bold uppercase tracking-wider border-b border-slate-200">
              <th class="py-3.5 px-5">Sản Phẩm</th>
              <th class="py-3.5 px-4">Danh Mục</th>
              <th class="py-3.5 px-4 text-center">Tồn Kho Hiện Tại</th>
              <th class="py-3.5 px-4 text-right">Giá Vốn Hiện Tại (COGS)</th>
              <th class="py-3.5 px-4 text-right">Giá Bán Niêm Yết</th>
              <th class="py-3.5 px-4 text-right">Tổng Giá Trị Tồn</th>
              <th class="py-3.5 px-5 text-right">Thao Tác</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100 text-slate-700">
            <c:forEach var="p" items="${products}">
              <tr class="hover:bg-slate-50/60 transition-colors">
                <td class="py-3.5 px-5">
                  <div class="flex items-center gap-3">
                    <img src="${not empty p.imageUrl ? p.imageUrl : 'https://placehold.co/100x100/f1f5f9/94a3b8?text=Fruit'}" onerror="this.onerror=null;this.src='https://placehold.co/100x100/f1f5f9/94a3b8?text=Fruit';" alt="${p.name}" class="w-10 h-10 rounded-lg object-cover border border-slate-200 flex-shrink-0">
                    <div>
                      <div class="font-bold text-slate-900">${p.name}</div>
                      <span class="text-[10px] text-slate-400 font-mono">#PRD-${p.id}</span>
                    </div>
                  </div>
                </td>
                <td class="py-3.5 px-4">
                  <span class="px-2 py-0.5 rounded bg-slate-100 text-slate-600 font-semibold">${p.categoryName != null ? p.categoryName : 'Nông sản'}</span>
                </td>
                <td class="py-3.5 px-4 text-center">
                  <span class="inline-block px-2.5 py-1 rounded-full text-xs font-bold ${p.stock > 20 ? 'bg-emerald-100 text-emerald-800' : (p.stock > 0 ? 'bg-amber-100 text-amber-800' : 'bg-red-100 text-red-800')}">
                    ${p.stock}
                  </span>
                </td>
                <td class="py-3.5 px-4 text-right font-bold text-amber-700">
                  <fmt:formatNumber value="${p.costPrice}" type="number" groupingUsed="true"/> ₫
                </td>
                <td class="py-3.5 px-4 text-right font-semibold text-slate-800">
                  <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> ₫
                </td>
                <td class="py-3.5 px-4 text-right font-bold text-slate-900">
                  <fmt:formatNumber value="${p.stock * p.costPrice}" type="number" groupingUsed="true"/> ₫
                </td>
                <td class="py-3.5 px-5 text-right">
                  <a href="${pageContext.request.contextPath}/admin/inventory/create?productId=${p.id}" class="inline-flex items-center gap-1 px-3 py-1.5 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border border-emerald-300 rounded-lg text-xs font-bold transition-all shadow-xs">
                    <span class="material-symbols-outlined text-sm">local_shipping</span>
                    <span>Nhập thêm hàng</span>
                  </a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</main>

<script>
  function switchView(viewName) {
    const viewReceipts = document.getElementById('viewReceipts');
    const viewStock = document.getElementById('viewStock');
    const tabBtnReceipts = document.getElementById('tabBtnReceipts');
    const tabBtnStock = document.getElementById('tabBtnStock');

    if (viewName === 'receipts') {
      viewReceipts.classList.remove('hidden');
      viewStock.classList.add('hidden');
      tabBtnReceipts.className = 'pb-3 text-sm font-bold text-primary border-b-2 border-primary flex items-center gap-2 transition-all';
      tabBtnStock.className = 'pb-3 text-sm font-bold text-slate-500 border-b-2 border-transparent hover:text-slate-800 flex items-center gap-2 transition-all';
    } else {
      viewReceipts.classList.add('hidden');
      viewStock.classList.remove('hidden');
      tabBtnReceipts.className = 'pb-3 text-sm font-bold text-slate-500 border-b-2 border-transparent hover:text-slate-800 flex items-center gap-2 transition-all';
      tabBtnStock.className = 'pb-3 text-sm font-bold text-primary border-b-2 border-primary flex items-center gap-2 transition-all';
    }
  }
</script>

</body>
</html>
