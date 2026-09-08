<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Quản lý Đơn hàng - Fruitables Admin</title>
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
    <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/chat') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/chat">
      <span class="material-symbols-outlined">support_agent</span>
      <span class="font-label-bold">Live Chat CSKH</span>
    </a>
  </nav>
</aside>

<main class="flex-1 flex flex-col h-screen overflow-hidden">
  <header class="h-20 bg-surface flex items-center justify-between px-6 shadow-sm z-10 flex-shrink-0 border-b border-surface-variant">
    <div class="flex items-center flex-1 justify-end">
      <div class="flex items-center gap-4">
        <span class="font-label-bold mr-2">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
        <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full transition-colors" title="Đăng xuất">
          <span class="material-symbols-outlined">logout</span>
        </a>
      </div>
    </div>
  </header>

  <div id="orderScrollContainer" class="flex-1 overflow-y-auto p-6 bg-[#f8fafc]">
    <div class="flex justify-between items-center mb-6">
      <div>
        <h1 class="font-headline-md text-2xl font-bold text-on-surface">Quản lý Đơn hàng</h1>
        <p class="text-xs text-on-surface-variant mt-1">Quy trình xử lý hoa quả tươi: Tiếp nhận &rarr; Xác nhận &rarr; Đóng gói &rarr; Giao hàng hỏa tốc (Báo email) &rarr; Hoàn tất</p>
      </div>
      <div class="text-xs text-on-surface-variant bg-surface-container-lowest px-4 py-2 rounded-xl border border-outline-variant shadow-sm flex items-center gap-2">
        <span class="w-2 h-2 rounded-full bg-primary animate-pulse"></span>
        <span>Tổng số đơn: <strong class="text-primary text-sm font-bold"><c:out value="${orders.size()}"/></strong></span>
      </div>
    </div>

    <!-- THANH TÌM KIẾM VÀ BỘ LỌC ĐƠN HÀNG NÂNG CAO (THEO NGÀY THÁNG, TRẠNG THÁI, TỪ KHÓA) -->
    <div class="bg-surface-container-lowest p-5 rounded-2xl border border-outline-variant shadow-sm mb-6">
      <form id="orderFilterForm" action="${pageContext.request.contextPath}/admin/orders" method="GET" class="space-y-4">
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-12 gap-3.5 items-end">
          <!-- Tìm kiếm từ khóa -->
          <div class="lg:col-span-3">
            <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1.5">
              <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">search</span> Tìm kiếm đơn hàng</span>
            </label>
            <div class="relative">
              <input type="text" name="keyword" value="<c:out value='${keyword}'/>" placeholder="Mã ĐH, tên khách, SĐT..."
                     class="w-full pl-9 pr-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
              <span class="material-symbols-outlined text-[16px] text-on-surface-variant absolute left-2.5 top-1/2 -translate-y-1/2">receipt</span>
            </div>
          </div>

          <!-- Trạng thái đơn -->
          <div class="lg:col-span-2">
            <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1.5">
              <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">tune</span> Trạng thái</span>
            </label>
            <select name="status" class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
              <option value="ALL" ${selectedStatus == 'ALL' || empty selectedStatus ? 'selected' : ''}>Tất cả trạng thái</option>
              <option value="PENDING" ${selectedStatus == 'PENDING' ? 'selected' : ''}>1. Đã đặt hàng</option>
              <option value="CONFIRMED" ${selectedStatus == 'CONFIRMED' ? 'selected' : ''}>2. Đã xác nhận</option>
              <option value="PACKING" ${selectedStatus == 'PACKING' ? 'selected' : ''}>3. Đóng gói & Lạnh</option>
              <option value="SHIPPING" ${selectedStatus == 'SHIPPING' ? 'selected' : ''}>4. Đang giao hàng</option>
              <option value="DELIVERED" ${selectedStatus == 'DELIVERED' ? 'selected' : ''}>5. Đã giao</option>
              <option value="COMPLETED" ${selectedStatus == 'COMPLETED' ? 'selected' : ''}>Hoàn tất</option>
              <option value="FAILED" ${selectedStatus == 'FAILED' ? 'selected' : ''}>Giao thất bại</option>
              <option value="RETURNED" ${selectedStatus == 'RETURNED' ? 'selected' : ''}>Đã hoàn hàng</option>
              <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
            </select>
          </div>

          <!-- Từ ngày -->
          <div class="lg:col-span-2">
            <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1.5">
              <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">calendar_today</span> Từ ngày</span>
            </label>
            <input type="date" id="filterStartDate" name="startDate" value="${startDate}"
                   class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
          </div>

          <!-- Đến ngày -->
          <div class="lg:col-span-2">
            <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1.5">
              <span class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">event</span> Đến ngày</span>
            </label>
            <input type="date" id="filterEndDate" name="endDate" value="${endDate}"
                   class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
          </div>

          <!-- Nút Thao tác Lọc -->
          <div class="lg:col-span-3 flex items-center gap-2">
            <button type="submit" class="flex-1 py-2 px-3 bg-primary hover:bg-primary-container text-white text-xs font-bold rounded-xl shadow-sm transition-all flex items-center justify-center gap-1.5">
              <span class="material-symbols-outlined text-[16px]">filter_alt</span> Lọc đơn
            </button>
            <a href="${pageContext.request.contextPath}/admin/orders" class="py-2 px-3 bg-surface-container hover:bg-surface-container-high text-on-surface text-xs font-bold rounded-xl transition-all border border-outline-variant flex items-center justify-center gap-1" title="Đặt lại bộ lọc">
              <span class="material-symbols-outlined text-[16px]">restart_alt</span>
            </a>
          </div>
        </div>

        <!-- Quick Date Presets -->
        <div class="flex items-center gap-2 pt-2 border-t border-surface-variant text-xs flex-wrap">
          <span class="text-on-surface-variant text-[11px] font-medium">Chọn nhanh mốc:</span>
          <button type="button" onclick="setQuickDate('today')" class="px-2.5 py-1 rounded-lg bg-surface-container-low hover:bg-primary/10 hover:text-primary text-on-surface-variant font-medium text-[11px] border border-outline-variant transition-colors">Hôm nay</button>
          <button type="button" onclick="setQuickDate('yesterday')" class="px-2.5 py-1 rounded-lg bg-surface-container-low hover:bg-primary/10 hover:text-primary text-on-surface-variant font-medium text-[11px] border border-outline-variant transition-colors">Hôm qua</button>
          <button type="button" onclick="setQuickDate('7days')" class="px-2.5 py-1 rounded-lg bg-surface-container-low hover:bg-primary/10 hover:text-primary text-on-surface-variant font-medium text-[11px] border border-outline-variant transition-colors">7 ngày qua</button>
          <button type="button" onclick="setQuickDate('thisMonth')" class="px-2.5 py-1 rounded-lg bg-surface-container-low hover:bg-primary/10 hover:text-primary text-on-surface-variant font-medium text-[11px] border border-outline-variant transition-colors">Tháng này</button>
          <button type="button" onclick="setQuickDate('clear')" class="px-2.5 py-1 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-600 font-medium text-[11px] transition-colors ml-auto">Xóa ngày</button>
        </div>
      </form>
    </div>

    <div class="bg-surface-container-lowest rounded-2xl shadow-sm overflow-hidden border border-outline-variant">
      <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
          <thead>
          <tr class="border-b border-surface-variant bg-surface-container-low text-on-surface-variant font-label-bold text-xs uppercase tracking-wider">
            <th class="py-4 px-6">Mã ĐH & Thời gian</th>
            <th class="py-4 px-6">Khách nhận & SĐT</th>
            <th class="py-4 px-6">Tổng tiền</th>
            <th class="py-4 px-6">PTTT</th>
            <th class="py-4 px-6">Thanh toán</th>
            <th class="py-4 px-6">Tiến độ đơn</th>
            <th class="py-4 px-6 text-center">Chuyển trạng thái quy trình</th>
            <th class="py-4 px-6 text-center">In</th>
          </tr>
          </thead>
          <tbody class="divide-y divide-surface-variant text-xs">
          <c:forEach var="order" items="${orders}">
            <tr id="order-row-${order.id}" class="hover:bg-surface-bright transition-colors" data-order-id="${order.id}" data-has-email="${not empty order.userId || not empty order.customerEmail}">
              <td class="py-4 px-6 font-bold text-primary whitespace-nowrap">
                <div><c:out value="${order.orderCode}"/></div>
                <div class="text-[10px] text-on-surface-variant font-normal mt-0.5">
                  <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                </div>
              </td>
              <td class="py-4 px-6">
                <div class="flex items-center gap-1.5">
                  <span class="font-bold text-on-surface"><c:out value="${order.recipientName != null ? order.recipientName : 'Khách vãng lai'}"/></span>
                  <c:choose>
                    <c:when test="${not empty order.userId}">
                      <span class="px-1.5 py-0.5 bg-emerald-50 text-emerald-700 rounded text-[9px] font-bold border border-emerald-200">Thành viên</span>
                    </c:when>
                    <c:otherwise>
                      <span class="px-1.5 py-0.5 bg-slate-100 text-slate-600 rounded text-[9px] font-bold border border-slate-200">Vãng lai</span>
                    </c:otherwise>
                  </c:choose>
                </div>
                <div class="text-on-surface-variant flex items-center gap-1 mt-0.5 text-[11px]">
                  <span class="material-symbols-outlined text-[13px]">call</span> <c:out value="${order.phone}"/>
                </div>
                <c:if test="${not empty order.customerEmail}">
                  <div class="text-on-surface-variant/70 text-[10px] truncate max-w-[140px]"><c:out value="${order.customerEmail}"/></div>
                </c:if>
              </td>
              <td class="py-4 px-6 font-price-tag text-on-surface font-semibold whitespace-nowrap">
                <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫
              </td>
              <td class="py-4 px-6 text-on-surface-variant whitespace-nowrap"><c:out value="${order.paymentMethod}"/></td>
              <td class="py-4 px-6 whitespace-nowrap">
                <c:choose>
                  <c:when test="${order.paymentStatus == 'PAID'}">
                    <span class="px-2.5 py-1 bg-green-100 text-green-700 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                      <span class="w-1.5 h-1.5 rounded-full bg-green-600"></span> Đã TT
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="px-2.5 py-1 bg-amber-100 text-amber-700 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                      <span class="w-1.5 h-1.5 rounded-full bg-amber-500"></span> Chưa TT
                    </span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td id="order-status-badge-${order.id}" class="py-4 px-6 whitespace-nowrap">
                <c:choose>
                  <c:when test="${order.status == 'PENDING'}">
                    <span class="px-2.5 py-1 bg-amber-50 text-amber-600 border border-amber-200 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                      <span class="w-1.5 h-1.5 rounded-full bg-amber-500"></span> 1. Đã đặt hàng
                    </span>
                  </c:when>
                  <c:when test="${order.status == 'CONFIRMED'}">
                    <span class="px-2.5 py-1 bg-blue-50 text-blue-600 border border-blue-200 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                      <span class="w-1.5 h-1.5 rounded-full bg-blue-500"></span> 2. Đã xác nhận
                    </span>
                  </c:when>
                  <c:when test="${order.status == 'PACKING'}">
                    <span class="px-2.5 py-1 bg-indigo-50 text-indigo-600 border border-indigo-200 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                      <span class="w-1.5 h-1.5 rounded-full bg-indigo-500"></span> 3. Đóng gói & Lạnh
                    </span>
                  </c:when>
                  <c:when test="${order.status == 'SHIPPING'}">
                    <span class="px-2.5 py-1 bg-sky-100 text-sky-700 border border-sky-300 rounded-full text-[11px] font-bold animate-pulse inline-flex items-center gap-1">
                      <span class="w-1.5 h-1.5 rounded-full bg-sky-500"></span> 4. Đang giao hàng
                    </span>
                  </c:when>
                  <c:when test="${order.status == 'DELIVERED'}">
                    <span class="px-2.5 py-1 bg-emerald-100 text-emerald-700 border border-emerald-300 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                      <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> 5. Đã giao
                    </span>
                  </c:when>
                  <c:when test="${order.status == 'COMPLETED'}">
                    <span class="px-2.5 py-1 bg-green-100 text-green-800 border border-green-300 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                      <span class="w-1.5 h-1.5 rounded-full bg-green-600"></span> Hoàn tất
                    </span>
                  </c:when>
                  <c:when test="${order.status == 'RETURNED'}">
                    <span class="px-2.5 py-1 bg-purple-100 text-purple-700 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                      <span class="w-1.5 h-1.5 rounded-full bg-purple-600"></span> Đã hoàn hàng
                    </span>
                  </c:when>
                  <c:when test="${order.status == 'FAILED'}">
                    <span class="px-2.5 py-1 bg-rose-100 text-rose-700 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                      <span class="w-1.5 h-1.5 rounded-full bg-rose-600"></span> Giao thất bại
                    </span>
                  </c:when>
                  <c:when test="${order.status == 'CANCELLED'}">
                    <span class="px-2.5 py-1 bg-red-100 text-red-700 rounded-full text-[11px] font-bold inline-flex items-center gap-1">
                      <span class="w-1.5 h-1.5 rounded-full bg-red-600"></span> Đã hủy
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="px-2.5 py-1 bg-gray-100 text-gray-700 rounded-full text-[11px] font-bold"><c:out value="${order.status}"/></span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td id="order-actions-${order.id}" class="py-4 px-6 text-center">
                <div class="flex items-center justify-center gap-1.5 flex-wrap">
                  <!-- Bước 1: PENDING -> CONFIRMED -->
                  <c:if test="${order.status == 'PENDING'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="CONFIRMED">
                      <input type="hidden" name="filterStatus" value="${selectedStatus}">
                      <input type="hidden" name="startDate" value="${startDate}">
                      <input type="hidden" name="endDate" value="${endDate}">
                      <input type="hidden" name="keyword" value="${keyword}">
                      <button type="submit" class="px-2.5 py-1.5 bg-blue-600 text-white hover:bg-blue-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Xác nhận đơn">
                        <span class="material-symbols-outlined text-[14px]">check</span> Xác nhận
                      </button>
                    </form>
                  </c:if>

                  <!-- Bước 2: CONFIRMED -> PACKING -->
                  <c:if test="${order.status == 'CONFIRMED'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="PACKING">
                      <input type="hidden" name="filterStatus" value="${selectedStatus}">
                      <input type="hidden" name="startDate" value="${startDate}">
                      <input type="hidden" name="endDate" value="${endDate}">
                      <input type="hidden" name="keyword" value="${keyword}">
                      <button type="submit" class="px-2.5 py-1.5 bg-indigo-600 text-white hover:bg-indigo-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Đóng gói & Giữ nhiệt lạnh">
                        <span class="material-symbols-outlined text-[14px]">inventory_2</span> Đóng gói
                      </button>
                    </form>
                  </c:if>

                  <!-- Bước 3: PACKING -> SHIPPING (Kích hoạt Email & Web Notification nếu có) -->
                  <c:if test="${order.status == 'PACKING'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="SHIPPING">
                      <input type="hidden" name="filterStatus" value="${selectedStatus}">
                      <input type="hidden" name="startDate" value="${startDate}">
                      <input type="hidden" name="endDate" value="${endDate}">
                      <input type="hidden" name="keyword" value="${keyword}">
                      <c:choose>
                        <c:when test="${not empty order.userId || not empty order.customerEmail}">
                          <button type="submit" class="px-2.5 py-1.5 bg-sky-600 text-white hover:bg-sky-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Khách có tài khoản: Đi giao + Báo Gmail & Web Notification">
                            <span class="material-symbols-outlined text-[14px]">forward_to_inbox</span> Đi giao (Báo Gmail)
                          </button>
                        </c:when>
                        <c:otherwise>
                          <button type="submit" class="px-2.5 py-1.5 bg-sky-600 text-white hover:bg-sky-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Khách vãng lai: Giao hàng (Khách tra cứu tiến độ qua SĐT)">
                            <span class="material-symbols-outlined text-[14px]">local_shipping</span> Đi giao (Khách SĐT)
                          </button>
                        </c:otherwise>
                      </c:choose>
                    </form>
                  </c:if>

                  <!-- Bước 4: SHIPPING -> DELIVERED / FAILED / RETURNED -->
                  <c:if test="${order.status == 'SHIPPING'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="DELIVERED">
                      <input type="hidden" name="filterStatus" value="${selectedStatus}">
                      <input type="hidden" name="startDate" value="${startDate}">
                      <input type="hidden" name="endDate" value="${endDate}">
                      <input type="hidden" name="keyword" value="${keyword}">
                      <button type="submit" class="px-2.5 py-1.5 bg-emerald-600 text-white hover:bg-emerald-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Xác nhận đã giao hoa quả">
                        <span class="material-symbols-outlined text-[14px]">done_all</span> Đã giao
                      </button>
                    </form>
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="FAILED">
                      <input type="hidden" name="filterStatus" value="${selectedStatus}">
                      <input type="hidden" name="startDate" value="${startDate}">
                      <input type="hidden" name="endDate" value="${endDate}">
                      <input type="hidden" name="keyword" value="${keyword}">
                      <button type="submit" class="p-1.5 bg-rose-50 text-rose-600 hover:bg-rose-600 hover:text-white rounded-lg transition-colors" title="Giao thất bại">
                        <span class="material-symbols-outlined text-[14px]">cancel</span>
                      </button>
                    </form>
                  </c:if>

                  <!-- Bước 5: DELIVERED -> COMPLETED -->
                  <c:if test="${order.status == 'DELIVERED'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="COMPLETED">
                      <input type="hidden" name="filterStatus" value="${selectedStatus}">
                      <input type="hidden" name="startDate" value="${startDate}">
                      <input type="hidden" name="endDate" value="${endDate}">
                      <input type="hidden" name="keyword" value="${keyword}">
                      <button type="submit" class="px-2.5 py-1.5 bg-green-700 text-white hover:bg-green-800 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Đơn hoàn tất thành công">
                        <span class="material-symbols-outlined text-[14px]">verified</span> Hoàn tất
                      </button>
                    </form>
                  </c:if>

                  <!-- Nút Hủy Đơn (Chỉ cho phép khi chưa giao) -->
                  <c:if test="${order.status == 'PENDING' || order.status == 'CONFIRMED' || order.status == 'PACKING'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline" onsubmit="return confirmCancelOrder(event, this);">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="CANCELLED">
                      <input type="hidden" name="filterStatus" value="${selectedStatus}">
                      <input type="hidden" name="startDate" value="${startDate}">
                      <input type="hidden" name="endDate" value="${endDate}">
                      <input type="hidden" name="keyword" value="${keyword}">
                      <button type="submit" class="p-1.5 bg-red-50 text-red-600 hover:bg-red-600 hover:text-white rounded-lg transition-colors" title="Hủy đơn & hoàn kho">
                        <span class="material-symbols-outlined text-[14px]">close</span>
                      </button>
                    </form>
                  </c:if>

                  <!-- Nút Hoàn hàng cho đơn lỗi -->
                  <c:if test="${order.status == 'FAILED'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="RETURNED">
                      <input type="hidden" name="filterStatus" value="${selectedStatus}">
                      <input type="hidden" name="startDate" value="${startDate}">
                      <input type="hidden" name="endDate" value="${endDate}">
                      <input type="hidden" name="keyword" value="${keyword}">
                      <button type="submit" class="p-1.5 bg-purple-50 text-purple-600 hover:bg-purple-600 hover:text-white rounded-lg transition-colors" title="Báo hoàn kho">
                        <span class="material-symbols-outlined text-[14px]">assignment_return</span>
                      </button>
                    </form>
                  </c:if>
                </div>
              </td>
              <td class="py-4 px-6 text-center">
                <a href="${pageContext.request.contextPath}/admin/orders/export-invoice?orderCode=${order.orderCode}" class="text-primary hover:text-primary-container transition-colors inline-block p-1 rounded-md hover:bg-primary/10" title="Xuất hóa đơn PDF">
                  <span class="material-symbols-outlined text-lg">print</span>
                </a>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty orders}">
            <tr>
              <td colspan="8" class="text-center py-12 text-on-surface-variant">
                <span class="material-symbols-outlined text-4xl text-outline mb-2">inventory_2</span>
                <p class="font-medium">Không tìm thấy đơn hàng nào phù hợp với bộ lọc.</p>
                <p class="text-xs text-on-surface-variant/70 mt-1">Vui lòng thử điều chỉnh lại từ khóa hoặc khoảng ngày tìm kiếm.</p>
              </td>
            </tr>
          </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</main>

<!-- TOAST THÔNG BÁO NỔI -->
<div id="toastContainer" class="fixed bottom-6 right-6 z-50 flex flex-col gap-2 pointer-events-none"></div>

<script>
  // 1. CHỌN NHANH MỐC THỜI GIAN LỌC
  function setQuickDate(type) {
    const startInput = document.getElementById('filterStartDate');
    const endInput = document.getElementById('filterEndDate');
    const form = document.getElementById('orderFilterForm');
    const today = new Date();

    function formatDate(d) {
      const year = d.getFullYear();
      const month = String(d.getMonth() + 1).padStart(2, '0');
      const day = String(d.getDate()).padStart(2, '0');
      return year + '-' + month + '-' + day;
    }

    if (type === 'today') {
      const str = formatDate(today);
      startInput.value = str;
      endInput.value = str;
    } else if (type === 'yesterday') {
      const y = new Date(today);
      y.setDate(y.getDate() - 1);
      const str = formatDate(y);
      startInput.value = str;
      endInput.value = str;
    } else if (type === '7days') {
      const past = new Date(today);
      past.setDate(past.getDate() - 7);
      startInput.value = formatDate(past);
      endInput.value = formatDate(today);
    } else if (type === 'thisMonth') {
      const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
      startInput.value = formatDate(firstDay);
      endInput.value = formatDate(today);
    } else if (type === 'clear') {
      startInput.value = '';
      endInput.value = '';
    }
    form.submit();
  }

  // 2. KHÔI PHỤC VỊ TRÍ CUỘN SAU KHI LOAD TRANG
  window.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('orderScrollContainer');
    const savedScroll = sessionStorage.getItem('adminOrdersScrollTop');
    if (container && savedScroll !== null) {
      container.scrollTop = parseInt(savedScroll, 10);
      sessionStorage.removeItem('adminOrdersScrollTop');
    } else if (window.location.hash) {
      const target = document.querySelector(window.location.hash);
      if (target) {
        target.scrollIntoView({ behavior: 'smooth', block: 'center' });
        target.classList.add('bg-primary/10');
        setTimeout(() => target.classList.remove('bg-primary/10'), 2500);
      }
    }
  });

  function saveCurrentScroll() {
    const container = document.getElementById('orderScrollContainer');
    if (container) {
      sessionStorage.setItem('adminOrdersScrollTop', container.scrollTop);
    }
  }

  // 3. XÁC NHẬN HỦY ĐƠN
  function confirmCancelOrder(event, form) {
    if (confirm('Bạn có chắc muốn hủy đơn này? Tồn kho hoa quả sẽ được hoàn lại tự động.')) {
      handleOrderStatusSubmit(event, form);
      return false;
    }
    event.preventDefault();
    return false;
  }

  // 4. XỬ LÝ AJAX CẬP NHẬT TRẠNG THÁI KHÔNG LÀM NHẢY VỊ TRÍ CUỘN
  async function handleOrderStatusSubmit(event, form) {
    event.preventDefault();
    saveCurrentScroll();

    const btn = form.querySelector('button[type="submit"]');
    if (!btn) return;

    const originalHtml = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = '<span class="material-symbols-outlined text-[14px] animate-spin">progress_activity</span>';

    const formData = new FormData(form);
    const orderId = formData.get('orderId');
    const newStatus = formData.get('status');
    const contextPath = '${pageContext.request.contextPath}';

    try {
      const response = await fetch(form.action, {
        method: 'POST',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: new URLSearchParams(formData).toString()
      });

      if (response.ok) {
        const data = await response.json();
        if (data.success) {
          const row = document.getElementById('order-row-' + orderId);
          const hasEmail = row ? (row.getAttribute('data-has-email') === 'true') : false;

          updateRowStatusInPlace(orderId, newStatus, contextPath, hasEmail);
          showToast('Cập nhật trạng thái đơn #' + orderId + ' thành công!', 'success');
        } else {
          showToast('Lỗi: ' + (data.message || 'Không thể cập nhật'), 'error');
          btn.disabled = false;
          btn.innerHTML = originalHtml;
        }
      } else {
        // Fallback: Nếu backend phản hồi không phải 200, submit bình thường
        form.submit();
      }
    } catch (err) {
      console.error('AJAX error, falling back to form submit:', err);
      form.submit();
    }
  }

  // 5. CẬP NHẬT GIAO DIỆN DÒNG ĐƠN HÀNG NGAY TẠI CHỖ (IN-PLACE DOM UPDATE)
  function updateRowStatusInPlace(orderId, status, contextPath, hasEmail) {
    const badgeCell = document.getElementById('order-status-badge-' + orderId);
    const actionsCell = document.getElementById('order-actions-' + orderId);
    if (!badgeCell || !actionsCell) return;

    // A. Cập nhật Badge
    let badgeHtml = '';
    switch (status) {
      case 'PENDING':
        badgeHtml = '<span class="px-2.5 py-1 bg-amber-50 text-amber-600 border border-amber-200 rounded-full text-[11px] font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-amber-500"></span> 1. Đã đặt hàng</span>';
        break;
      case 'CONFIRMED':
        badgeHtml = '<span class="px-2.5 py-1 bg-blue-50 text-blue-600 border border-blue-200 rounded-full text-[11px] font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-blue-500"></span> 2. Đã xác nhận</span>';
        break;
      case 'PACKING':
        badgeHtml = '<span class="px-2.5 py-1 bg-indigo-50 text-indigo-600 border border-indigo-200 rounded-full text-[11px] font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-indigo-500"></span> 3. Đóng gói & Lạnh</span>';
        break;
      case 'SHIPPING':
        badgeHtml = '<span class="px-2.5 py-1 bg-sky-100 text-sky-700 border border-sky-300 rounded-full text-[11px] font-bold animate-pulse inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-sky-500"></span> 4. Đang giao hàng</span>';
        break;
      case 'DELIVERED':
        badgeHtml = '<span class="px-2.5 py-1 bg-emerald-100 text-emerald-700 border border-emerald-300 rounded-full text-[11px] font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> 5. Đã giao</span>';
        break;
      case 'COMPLETED':
        badgeHtml = '<span class="px-2.5 py-1 bg-green-100 text-green-800 border border-green-300 rounded-full text-[11px] font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-green-600"></span> Hoàn tất</span>';
        break;
      case 'FAILED':
        badgeHtml = '<span class="px-2.5 py-1 bg-rose-100 text-rose-700 rounded-full text-[11px] font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-rose-600"></span> Giao thất bại</span>';
        break;
      case 'RETURNED':
        badgeHtml = '<span class="px-2.5 py-1 bg-purple-100 text-purple-700 rounded-full text-[11px] font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-purple-600"></span> Đã hoàn hàng</span>';
        break;
      case 'CANCELLED':
        badgeHtml = '<span class="px-2.5 py-1 bg-red-100 text-red-700 rounded-full text-[11px] font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-red-600"></span> Đã hủy</span>';
        break;
      default:
        badgeHtml = '<span class="px-2.5 py-1 bg-gray-100 text-gray-700 rounded-full text-[11px] font-bold">' + status + '</span>';
    }
    badgeCell.innerHTML = badgeHtml;

    // B. Cập nhật Action Buttons tương ứng
    let actionsHtml = '<div class="flex items-center justify-center gap-1.5 flex-wrap">';
    
    if (status === 'CONFIRMED') {
      // Tiếp theo: PACKING + CANCELLED
      actionsHtml += `
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="PACKING">
          <button type="submit" class="px-2.5 py-1.5 bg-indigo-600 text-white hover:bg-indigo-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Đóng gói & Giữ nhiệt lạnh">
            <span class="material-symbols-outlined text-[14px]">inventory_2</span> Đóng gói
          </button>
        </form>
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="return confirmCancelOrder(event, this);">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="CANCELLED">
          <button type="submit" class="p-1.5 bg-red-50 text-red-600 hover:bg-red-600 hover:text-white rounded-lg transition-colors" title="Hủy đơn & hoàn kho">
            <span class="material-symbols-outlined text-[14px]">close</span>
          </button>
        </form>
      `;
    } else if (status === 'PACKING') {
      // Tiếp theo: SHIPPING + CANCELLED
      const shipBtnText = hasEmail ? 'Đi giao (Báo Gmail)' : 'Đi giao (Khách SĐT)';
      const shipIcon = hasEmail ? 'forward_to_inbox' : 'local_shipping';
      actionsHtml += `
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="SHIPPING">
          <button type="submit" class="px-2.5 py-1.5 bg-sky-600 text-white hover:bg-sky-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Giao hàng">
            <span class="material-symbols-outlined text-[14px]">${shipIcon}</span> ${shipBtnText}
          </button>
        </form>
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="return confirmCancelOrder(event, this);">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="CANCELLED">
          <button type="submit" class="p-1.5 bg-red-50 text-red-600 hover:bg-red-600 hover:text-white rounded-lg transition-colors" title="Hủy đơn & hoàn kho">
            <span class="material-symbols-outlined text-[14px]">close</span>
          </button>
        </form>
      `;
    } else if (status === 'SHIPPING') {
      // Tiếp theo: DELIVERED + FAILED
      actionsHtml += `
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="DELIVERED">
          <button type="submit" class="px-2.5 py-1.5 bg-emerald-600 text-white hover:bg-emerald-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Xác nhận đã giao hoa quả">
            <span class="material-symbols-outlined text-[14px]">done_all</span> Đã giao
          </button>
        </form>
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="FAILED">
          <button type="submit" class="p-1.5 bg-rose-50 text-rose-600 hover:bg-rose-600 hover:text-white rounded-lg transition-colors" title="Giao thất bại">
            <span class="material-symbols-outlined text-[14px]">cancel</span>
          </button>
        </form>
      `;
    } else if (status === 'DELIVERED') {
      // Tiếp theo: COMPLETED
      actionsHtml += `
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="COMPLETED">
          <button type="submit" class="px-2.5 py-1.5 bg-green-700 text-white hover:bg-green-800 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Đơn hoàn tất thành công">
            <span class="material-symbols-outlined text-[14px]">verified</span> Hoàn tất
          </button>
        </form>
      `;
    } else if (status === 'FAILED') {
      // Tiếp theo: RETURNED
      actionsHtml += `
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="RETURNED">
          <button type="submit" class="p-1.5 bg-purple-50 text-purple-600 hover:bg-purple-600 hover:text-white rounded-lg transition-colors" title="Báo hoàn kho">
            <span class="material-symbols-outlined text-[14px]">assignment_return</span>
          </button>
        </form>
      `;
    } else {
      // COMPLETED, CANCELLED, RETURNED -> Không còn nút hành động tiếp
      actionsHtml += '<span class="text-[11px] text-on-surface-variant italic">Đã kết thúc</span>';
    }

    actionsHtml += '</div>';
    actionsCell.innerHTML = actionsHtml;

    // Hiệu ứng highlight dòng vừa được cập nhật
    const row = document.getElementById('order-row-' + orderId);
    if (row) {
      row.classList.add('bg-primary/10');
      setTimeout(() => row.classList.remove('bg-primary/10'), 1500);
    }
  }

  // 6. THÔNG BÁO TOAST NỔI HIỆN ĐẠI
  function showToast(message, type = 'success') {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const toast = document.createElement('div');
    const isSuccess = (type === 'success');
    const bgClass = isSuccess ? 'bg-emerald-600' : 'bg-red-600';
    const icon = isSuccess ? 'check_circle' : 'error';

    toast.className = bgClass + ' text-white px-4 py-3 rounded-2xl shadow-xl flex items-center gap-2.5 text-xs font-semibold pointer-events-auto transform translate-y-4 opacity-0 transition-all duration-300';
    toast.innerHTML = '<span class="material-symbols-outlined text-base">' + icon + '</span><span>' + message + '</span>';

    container.appendChild(toast);

    // Kích hoạt transition
    requestAnimationFrame(() => {
      toast.classList.remove('translate-y-4', 'opacity-0');
    });

    setTimeout(() => {
      toast.classList.add('translate-y-4', 'opacity-0');
      setTimeout(() => toast.remove(), 300);
    }, 3200);
  }
</script>
</body>
</html>