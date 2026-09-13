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

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />


<main class="flex-1 flex flex-col h-screen overflow-hidden">
  <header class="h-20 bg-surface flex items-center justify-between px-6 shadow-sm z-10 flex-shrink-0 border-b border-surface-variant">
    <div class="flex items-center flex-1 justify-end">
      <div class="flex items-center gap-4 flex-shrink-0">
        <span class="font-label-bold mr-2 truncate max-w-[160px] whitespace-nowrap text-sm" title="${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
        <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full transition-colors flex-shrink-0" title="Đăng xuất">
          <svg class="w-5 h-5"><use href="#icon-logout"/></svg>
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
              <span class="flex items-center gap-1.5"><svg class="w-3.5 h-3.5"><use href="#icon-search"/></svg> Tìm kiếm đơn hàng</span>
            </label>
            <div class="relative">
              <input type="text" name="keyword" value="<c:out value='${keyword}'/>" placeholder="Mã ĐH, tên khách, SĐT..."
                     class="w-full pl-9 pr-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
              <svg class="w-4 h-4 text-on-surface-variant absolute left-2.5 top-1/2 -translate-y-1/2"><use href="#icon-receipt"/></svg>
            </div>
          </div>

          <!-- Trạng thái đơn -->
          <div class="lg:col-span-2">
            <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1.5">
              <span class="flex items-center gap-1.5"><svg class="w-3.5 h-3.5"><use href="#icon-tune"/></svg> Trạng thái</span>
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
              <span class="flex items-center gap-1.5"><svg class="w-3.5 h-3.5"><use href="#icon-calendar"/></svg> Từ ngày</span>
            </label>
            <input type="date" id="filterStartDate" name="startDate" value="${startDate}"
                   class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
          </div>

          <!-- Đến ngày -->
          <div class="lg:col-span-2">
            <label class="block text-[11px] font-bold text-on-surface-variant uppercase tracking-wider mb-1.5">
              <span class="flex items-center gap-1.5"><svg class="w-3.5 h-3.5"><use href="#icon-calendar"/></svg> Đến ngày</span>
            </label>
            <input type="date" id="filterEndDate" name="endDate" value="${endDate}"
                   class="w-full px-3 py-2 text-xs rounded-xl border border-outline-variant bg-surface-container-low focus:bg-surface focus:border-primary outline-none transition-all">
          </div>

          <!-- Nút Thao tác Lọc -->
          <div class="lg:col-span-3 flex items-center gap-2">
            <button type="submit" class="flex-1 py-2 px-3 bg-primary hover:bg-primary-container text-white text-xs font-bold rounded-xl shadow-sm transition-all flex items-center justify-center gap-1.5">
              <svg class="w-4 h-4"><use href="#icon-filter"/></svg> Lọc đơn
            </button>
            <a href="${pageContext.request.contextPath}/admin/orders" class="py-2 px-3 bg-surface-container hover:bg-surface-container-high text-on-surface text-xs font-bold rounded-xl transition-all border border-outline-variant flex items-center justify-center gap-1" title="Đặt lại bộ lọc">
              <svg class="w-4 h-4"><use href="#icon-refresh"/></svg>
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
            <th class="py-4 px-6 text-center">Chi tiết & In</th>
          </tr>
          </thead>
          <tbody class="divide-y divide-surface-variant text-xs">
          <c:forEach var="order" items="${orders}">
            <tr id="order-row-${order.id}" class="hover:bg-surface-bright transition-colors" data-order-id="${order.id}" data-has-email="${not empty order.userId || not empty order.customerEmail}">
              <td class="py-4 px-6 font-bold text-primary whitespace-nowrap cursor-pointer group" onclick="openOrderDetailModal('${order.id}')" title="Nhấn để xem chi tiết đơn hàng">
                <div class="group-hover:underline flex items-center gap-1.5">
                  <span><c:out value="${order.orderCode}"/></span>
                  <svg class="w-3.5 h-3.5 text-primary/60 opacity-0 group-hover:opacity-100 transition-opacity"><use href="#icon-eye"/></svg>
                </div>
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
                  <svg class="w-3.5 h-3.5 text-on-surface-variant/80"><use href="#icon-phone"/></svg> <c:out value="${order.phone}"/>
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
                        <svg class="w-3.5 h-3.5"><use href="#icon-check"/></svg> Xác nhận
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
                        <svg class="w-3.5 h-3.5"><use href="#icon-inventory"/></svg> Đóng gói
                      </button>
                    </form>
                  </c:if>

                  <!-- Bước 3: PACKING -> SHIPPING (Kích hoạt Email & Web Notification nếu có) -->
                  <c:if test="${order.status == 'PACKING' || order.status == 'CONFIRMED'}">
                    <button type="button" onclick="openDispatchModal('${order.id}', '${order.orderCode}', '${order.recipientName}', '${order.shippingAddress}', '${order.deliverySlot}')"
                            class="px-2.5 py-1.5 bg-amber-500 text-white hover:bg-amber-600 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Gán Shipper nội bộ Fruitables">
                      <svg class="w-3.5 h-3.5"><use href="#icon-shipper"/></svg> Điều phối Shipper
                    </button>
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
                              <svg class="w-3.5 h-3.5"><use href="#icon-mail"/></svg> Đi giao (Báo Gmail)
                            </button>
                          </c:when>
                          <c:otherwise>
                            <button type="submit" class="px-2.5 py-1.5 bg-sky-600 text-white hover:bg-sky-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Khách vãng lai: Giao hàng (Khách tra cứu tiến độ qua SĐT)">
                              <svg class="w-3.5 h-3.5"><use href="#icon-delivery"/></svg> Đi giao (Khách SĐT)
                            </button>
                          </c:otherwise>
                        </c:choose>
                      </form>
                    </c:if>
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
                        <svg class="w-3.5 h-3.5"><use href="#icon-done-all"/></svg> Đã giao
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
                        <svg class="w-3.5 h-3.5"><use href="#icon-close"/></svg>
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
                        <svg class="w-3.5 h-3.5"><use href="#icon-claim"/></svg> Hoàn tất
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
                        <svg class="w-3.5 h-3.5"><use href="#icon-close"/></svg>
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
                        <svg class="w-3.5 h-3.5"><use href="#icon-refresh"/></svg>
                      </button>
                    </form>
                  </c:if>
                </div>
              </td>
              <td class="py-4 px-6 text-center whitespace-nowrap">
                <div class="flex items-center justify-center gap-1">
                  <button type="button" onclick="openOrderDetailModal('${order.id}')" class="text-primary hover:text-primary-container p-1.5 rounded-lg hover:bg-primary/10 transition-colors" title="Xem chi tiết đơn hàng">
                    <svg class="w-4 h-4"><use href="#icon-eye"/></svg>
                  </button>
                  <a href="${pageContext.request.contextPath}/admin/orders/export-invoice?orderCode=${order.orderCode}" class="text-primary hover:text-primary-container p-1.5 rounded-lg hover:bg-primary/10 transition-colors" title="Xuất hóa đơn PDF">
                    <svg class="w-4 h-4"><use href="#icon-print"/></svg>
                  </a>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty orders}">
            <tr>
              <td colspan="8" class="text-center py-12 text-on-surface-variant">
                <svg class="w-12 h-12 text-outline mb-2 mx-auto"><use href="#icon-inventory"/></svg>
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
    btn.innerHTML = '<svg class="w-3.5 h-3.5 animate-spin inline-block"><use href="#icon-spinner"/></svg>';

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
      actionsHtml += `
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="PACKING">
          <button type="submit" class="px-2.5 py-1.5 bg-indigo-600 text-white hover:bg-indigo-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Đóng gói & Giữ nhiệt lạnh">
            <svg class="w-3.5 h-3.5"><use href="#icon-inventory"/></svg> Đóng gói
          </button>
        </form>
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="return confirmCancelOrder(event, this);">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="CANCELLED">
          <button type="submit" class="p-1.5 bg-red-50 text-red-600 hover:bg-red-600 hover:text-white rounded-lg transition-colors" title="Hủy đơn & hoàn kho">
            <svg class="w-3.5 h-3.5"><use href="#icon-close"/></svg>
          </button>
        </form>
      `;
    } else if (status === 'PACKING') {
      const shipBtnText = hasEmail ? 'Đi giao (Báo Gmail)' : 'Đi giao (Khách SĐT)';
      const shipIcon = hasEmail ? 'icon-mail' : 'icon-delivery';
      actionsHtml += `
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="SHIPPING">
          <button type="submit" class="px-2.5 py-1.5 bg-sky-600 text-white hover:bg-sky-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Giao hàng">
            <svg class="w-3.5 h-3.5"><use href="#${shipIcon}"/></svg> ${shipBtnText}
          </button>
        </form>
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="return confirmCancelOrder(event, this);">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="CANCELLED">
          <button type="submit" class="p-1.5 bg-red-50 text-red-600 hover:bg-red-600 hover:text-white rounded-lg transition-colors" title="Hủy đơn & hoàn kho">
            <svg class="w-3.5 h-3.5"><use href="#icon-close"/></svg>
          </button>
        </form>
      `;
    } else if (status === 'SHIPPING') {
      actionsHtml += `
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="DELIVERED">
          <button type="submit" class="px-2.5 py-1.5 bg-emerald-600 text-white hover:bg-emerald-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Xác nhận đã giao hoa quả">
            <svg class="w-3.5 h-3.5"><use href="#icon-done-all"/></svg> Đã giao
          </button>
        </form>
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="FAILED">
          <button type="submit" class="p-1.5 bg-rose-50 text-rose-600 hover:bg-rose-600 hover:text-white rounded-lg transition-colors" title="Giao thất bại">
            <svg class="w-3.5 h-3.5"><use href="#icon-close"/></svg>
          </button>
        </form>
      `;
    } else if (status === 'DELIVERED') {
      actionsHtml += `
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="COMPLETED">
          <button type="submit" class="px-2.5 py-1.5 bg-green-700 text-white hover:bg-green-800 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm transition-all" title="Đơn hoàn tất thành công">
            <svg class="w-3.5 h-3.5"><use href="#icon-claim"/></svg> Hoàn tất
          </button>
        </form>
      `;
    } else if (status === 'FAILED') {
      actionsHtml += `
        <form action="${contextPath}/admin/orders" method="POST" class="inline" onsubmit="handleOrderStatusSubmit(event, this)">
          <input type="hidden" name="action" value="updateStatus">
          <input type="hidden" name="orderId" value="${orderId}">
          <input type="hidden" name="status" value="RETURNED">
          <button type="submit" class="p-1.5 bg-purple-50 text-purple-600 hover:bg-purple-600 hover:text-white rounded-lg transition-colors" title="Báo hoàn kho">
            <svg class="w-3.5 h-3.5"><use href="#icon-refresh"/></svg>
          </button>
        </form>
      `;
    } else {
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
    const iconId = isSuccess ? 'icon-check' : 'icon-alert';

    toast.className = bgClass + ' text-white px-4 py-3 rounded-2xl shadow-xl flex items-center gap-2.5 text-xs font-semibold pointer-events-auto transform translate-y-4 opacity-0 transition-all duration-300';
    toast.innerHTML = '<svg class="w-4 h-4 text-white flex-shrink-0"><use href="#' + iconId + '"/></svg><span>' + message + '</span>';

    container.appendChild(toast);

    requestAnimationFrame(() => {
      toast.classList.remove('translate-y-4', 'opacity-0');
    });

    setTimeout(() => {
      toast.classList.add('translate-y-4', 'opacity-0');
      setTimeout(() => toast.remove(), 300);
    }, 3200);
  }

  // 7. ĐIỀU PHỐI SHIPPER NỘI BỘ FRUITABLES
  function openDispatchModal(orderId, orderCode, recipient, address, slot) {
    document.getElementById('dispatchOrderId').value = orderId;
    document.getElementById('dispatchOrderCodeDisplay').innerText = '#' + orderCode;
    document.getElementById('dispatchRecipientDisplay').innerText = recipient || 'Khách hàng';
    document.getElementById('dispatchAddressDisplay').innerText = address || 'Theo thông tin đơn';
    
    let slotText = '⚡ Hỏa tốc 1 - 2H';
    if (slot === 'SLOT_MORNING') slotText = '🌅 Buổi Sáng (08:30 - 11:30)';
    else if (slot === 'SLOT_AFTERNOON') slotText = '☀️ Buổi Chiều (14:00 - 17:00)';
    else if (slot === 'SLOT_EVENING') slotText = '🌙 Buổi Tối (18:30 - 20:30)';
    document.getElementById('dispatchSlotDisplay').innerText = slotText;

    const modal = document.getElementById('dispatchShipperModal');
    if (modal) {
      modal.classList.remove('hidden');
      modal.classList.add('flex');
    }
  }

  function closeDispatchModal() {
    const modal = document.getElementById('dispatchShipperModal');
    if (modal) {
      modal.classList.add('hidden');
      modal.classList.remove('flex');
    }
  }

  // 8. CHI TIẾT ĐƠN HÀNG (ORDER DETAILS MODAL)
  async function openOrderDetailModal(orderId) {
    const modal = document.getElementById('orderDetailModal');
    const loading = document.getElementById('modalLoadingState');
    const content = document.getElementById('modalContentState');
    if (!modal) return;

    modal.classList.remove('hidden');
    modal.classList.add('flex');
    loading.classList.remove('hidden');
    content.classList.add('hidden');

    try {
      const resp = await fetch('${pageContext.request.contextPath}/admin/orders?action=getDetail&orderId=' + orderId);
      if (!resp.ok) throw new Error('Không tìm thấy dữ liệu đơn hàng');
      const order = await resp.json();

      document.getElementById('modalOrderCode').innerText = '#' + (order.orderCode || order.id);
      document.getElementById('modalOrderCreatedAt').innerText = order.createdAt || '--';

      const printBtn = document.getElementById('modalPrintBtn');
      if (printBtn) {
        printBtn.href = '${pageContext.request.contextPath}/admin/orders/export-invoice?orderCode=' + (order.orderCode || '');
      }

      // Trạng thái đơn
      const badgeContainer = document.getElementById('modalOrderStatusBadge');
      let statusBadge = '';
      switch (order.status) {
        case 'PENDING': statusBadge = '<span class="px-2.5 py-1 bg-amber-50 text-amber-600 border border-amber-200 rounded-full text-xs font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-amber-500"></span> 1. Đã đặt hàng</span>'; break;
        case 'CONFIRMED': statusBadge = '<span class="px-2.5 py-1 bg-blue-50 text-blue-600 border border-blue-200 rounded-full text-xs font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-blue-500"></span> 2. Đã xác nhận</span>'; break;
        case 'PACKING': statusBadge = '<span class="px-2.5 py-1 bg-indigo-50 text-indigo-600 border border-indigo-200 rounded-full text-xs font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-indigo-500"></span> 3. Đóng gói & Lạnh</span>'; break;
        case 'SHIPPING': statusBadge = '<span class="px-2.5 py-1 bg-sky-100 text-sky-700 border border-sky-300 rounded-full text-xs font-bold animate-pulse inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-sky-500"></span> 4. Đang giao hàng</span>'; break;
        case 'DELIVERED': statusBadge = '<span class="px-2.5 py-1 bg-emerald-100 text-emerald-700 border border-emerald-300 rounded-full text-xs font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> 5. Đã giao</span>'; break;
        case 'COMPLETED': statusBadge = '<span class="px-2.5 py-1 bg-green-100 text-green-800 border border-green-300 rounded-full text-xs font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-green-600"></span> Hoàn tất</span>'; break;
        case 'RETURNED': statusBadge = '<span class="px-2.5 py-1 bg-purple-100 text-purple-700 rounded-full text-xs font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-purple-600"></span> Đã hoàn hàng</span>'; break;
        case 'FAILED': statusBadge = '<span class="px-2.5 py-1 bg-rose-100 text-rose-700 rounded-full text-xs font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-rose-600"></span> Giao thất bại</span>'; break;
        case 'CANCELLED': statusBadge = '<span class="px-2.5 py-1 bg-red-100 text-red-700 rounded-full text-xs font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-red-600"></span> Đã hủy</span>'; break;
        default: statusBadge = '<span class="px-2.5 py-1 bg-gray-100 text-gray-700 rounded-full text-xs font-bold">' + (order.status || '') + '</span>';
      }
      badgeContainer.innerHTML = statusBadge;

      // Khách hàng
      const isMember = (order.userId != null && order.userId > 0);
      const custBadge = document.getElementById('modalCustomerTypeBadge');
      custBadge.innerText = isMember ? 'Thành viên Fruitables' : 'Khách vãng lai';
      custBadge.className = isMember ? 'text-[10px] px-2 py-0.5 rounded-full font-bold bg-emerald-100 text-emerald-800' : 'text-[10px] px-2 py-0.5 rounded-full font-bold bg-slate-100 text-slate-700';

      document.getElementById('modalRecipientName').innerText = order.recipientName || 'Khách vãng lai';
      document.getElementById('modalRecipientPhoneText').innerText = order.phone || '--';
      document.getElementById('modalRecipientEmail').innerText = order.customerEmail || '--';
      document.getElementById('modalShippingAddressText').innerText = order.shippingAddress || '--';

      const notesBox = document.getElementById('modalNotesContainer');
      if (order.orderNotes && order.orderNotes.trim() !== '') {
        notesBox.classList.remove('hidden');
        document.getElementById('modalOrderNotes').innerText = order.orderNotes;
      } else {
        notesBox.classList.add('hidden');
      }

      // Vận chuyển & Shipper
      let slotLabel = '⚡ Hỏa tốc 1 - 2H';
      if (order.deliverySlot === 'SLOT_MORNING') slotLabel = '🌅 Buổi Sáng (08:30 - 11:30)';
      else if (order.deliverySlot === 'SLOT_AFTERNOON') slotLabel = '☀️ Buổi Chiều (14:00 - 17:00)';
      else if (order.deliverySlot === 'SLOT_EVENING') slotLabel = '🌙 Buổi Tối (18:30 - 20:30)';
      document.getElementById('modalDeliverySlotBadge').innerText = slotLabel;

      if (order.shipper) {
        document.getElementById('modalShipperName').innerText = order.shipper.fullName || '--';
        document.getElementById('modalShipperPhone').innerText = order.shipper.phone || '--';
        document.getElementById('modalShipperPlate').innerText = order.shipper.vehiclePlate || '--';
      } else {
        document.getElementById('modalShipperName').innerText = 'Chưa phân công';
        document.getElementById('modalShipperPhone').innerText = '--';
        document.getElementById('modalShipperPlate').innerText = '--';
      }
      document.getElementById('modalTrackingNumber').innerText = order.trackingNumber || 'Chưa phát sinh';
      document.getElementById('modalEstimatedDelivery').innerText = order.estimatedDeliveryTime || 'Đang cập nhật';

      // Sản phẩm
      const tbody = document.getElementById('modalProductItemsTable');
      tbody.innerHTML = '';
      const items = order.details || [];
      document.getElementById('modalTotalItemCount').innerText = items.length;

      const fmt = new Intl.NumberFormat('vi-VN');

      const ctxPath = '${pageContext.request.contextPath}';
      items.forEach(it => {
        const tr = document.createElement('tr');
        tr.className = 'hover:bg-surface-container-low/50 transition-colors';
        const pName = it.productName || 'Sản phẩm';
        const pId = it.productId || '';
        const pPrice = fmt.format(it.price || 0);
        const pQty = it.quantity || 1;
        const pSub = fmt.format(it.subTotal || 0);
        // Build image URL: if productImageUrl is an absolute URL (http/https) use it directly, otherwise prefix context path
        const rawImg = it.productImageUrl || '';
        const imgUrl = rawImg.startsWith('http') ? rawImg : (rawImg ? ctxPath + (rawImg.startsWith('/') ? '' : '/') + rawImg : ctxPath + '/assets/web/img/fruite-item-5.jpg');
        tr.innerHTML = '<td class="py-3 px-4 flex items-center gap-3">' +
            '<img src="' + imgUrl + '" alt="' + pName + '" class="w-10 h-10 object-cover rounded-lg border border-outline-variant bg-white flex-shrink-0" onerror="this.src=\'' + ctxPath + '/assets/web/img/fruite-item-5.jpg\'">' +
            '<div>' +
              '<div class="font-bold text-on-surface text-xs">' + pName + '</div>' +
              '<div class="text-[10px] text-on-surface-variant font-mono">Mã SP: #' + pId + '</div>' +
            '</div>' +
          '</td>' +
          '<td class="py-3 px-4 text-right font-medium">' + pPrice + ' ₫</td>' +
          '<td class="py-3 px-4 text-center font-bold text-primary">x' + pQty + '</td>' +
          '<td class="py-3 px-4 text-right font-bold text-on-surface">' + pSub + ' ₫</td>';
        tbody.appendChild(tr);
      });

      // Tài chính
      document.getElementById('modalPaymentMethod').innerText = order.paymentMethod || 'COD';
      const isPaid = (order.paymentStatus === 'PAID');
      document.getElementById('modalPaymentStatusBadge').innerHTML = isPaid 
        ? '<span class="px-2 py-0.5 bg-green-100 text-green-700 rounded-full text-[11px] font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-green-600"></span> Đã thanh toán</span>'
        : '<span class="px-2 py-0.5 bg-amber-100 text-amber-700 rounded-full text-[11px] font-bold inline-flex items-center gap-1"><span class="w-1.5 h-1.5 rounded-full bg-amber-500"></span> Chưa thanh toán</span>';

      const subTotalSum = items.reduce((acc, cur) => acc + (cur.subTotal || 0), 0);
      document.getElementById('modalSubtotalAmount').innerText = fmt.format(subTotalSum > 0 ? subTotalSum : (order.totalAmount || 0)) + ' ₫';
      document.getElementById('modalShippingFee').innerText = fmt.format(order.shippingFee || 0) + ' ₫';

      const shipDiscRow = document.getElementById('modalShippingDiscountRow');
      if (order.shippingDiscount && order.shippingDiscount > 0) {
        shipDiscRow.classList.remove('hidden');
        document.getElementById('modalShippingDiscount').innerText = '-' + fmt.format(order.shippingDiscount) + ' ₫';
      } else {
        shipDiscRow.classList.add('hidden');
      }

      const ptsDiscRow = document.getElementById('modalPointsDiscountRow');
      if (order.pointsDiscount && order.pointsDiscount > 0) {
        ptsDiscRow.classList.remove('hidden');
        document.getElementById('modalPointsDiscount').innerText = '-' + fmt.format(order.pointsDiscount) + ' ₫ (' + (order.usedPoints || 0) + ' điểm)';
      } else {
        ptsDiscRow.classList.add('hidden');
      }

      document.getElementById('modalGrandTotal').innerText = fmt.format(order.totalAmount || 0) + ' ₫';

      loading.classList.add('hidden');
      content.classList.remove('hidden');
    } catch (e) {
      console.error('Error loading order details:', e);
      loading.innerHTML = '<div class="text-rose-600 font-medium text-center">Không thể tải thông tin chi tiết đơn hàng.<br><span class="text-xs text-on-surface-variant">' + e.message + '</span></div>';
    }
  }

  function closeOrderDetailModal() {
    const modal = document.getElementById('orderDetailModal');
    if (modal) {
      modal.classList.add('hidden');
      modal.classList.remove('flex');
    }
  }
</script>

<!-- MODAL ĐIỀU PHỐI SHIPPER NỘI BỘ -->
<div id="dispatchShipperModal" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden items-center justify-center p-4 transition-opacity">
  <div class="bg-surface-container-lowest rounded-2xl max-w-md w-full p-6 shadow-2xl border border-outline-variant transform transition-transform">
    <div class="flex items-center justify-between pb-3 border-b border-surface-variant">
      <div class="flex items-center gap-2">
        <span class="w-8 h-8 rounded-full bg-amber-500/20 text-amber-600 flex items-center justify-center font-bold text-sm">
          <svg class="w-4 h-4"><use href="#icon-shipper"/></svg>
        </span>
        <h3 class="font-headline-md text-base text-on-surface font-bold">Bàn Giao Shipper Nội Bộ</h3>
      </div>
      <button type="button" onclick="closeDispatchModal()" class="text-on-surface-variant hover:text-on-surface p-1 rounded-lg">
        <svg class="w-4 h-4"><use href="#icon-close"/></svg>
      </button>
    </div>

    <form action="${pageContext.request.contextPath}/admin/orders/dispatch" method="POST" class="mt-4 space-y-4">
      <input type="hidden" name="orderId" id="dispatchOrderId" value="">

      <!-- Thông tin tóm tắt đơn -->
      <div class="p-3.5 rounded-xl bg-surface-container/60 border border-outline-variant space-y-2 text-xs">
        <div class="flex justify-between">
          <span class="text-on-surface-variant">Mã đơn hàng:</span>
          <span class="font-bold text-primary" id="dispatchOrderCodeDisplay">--</span>
        </div>
        <div class="flex justify-between">
          <span class="text-on-surface-variant">Người nhận:</span>
          <span class="font-semibold text-on-surface" id="dispatchRecipientDisplay">--</span>
        </div>
        <div class="flex justify-between">
          <span class="text-on-surface-variant">Khung giờ:</span>
          <span class="font-bold text-amber-600" id="dispatchSlotDisplay">--</span>
        </div>
        <div class="pt-1 border-t border-surface-variant text-[11px] text-on-surface-variant truncate" id="dispatchAddressDisplay">
          --
        </div>
      </div>

      <div>
        <label class="block text-xs font-bold text-on-surface mb-1.5">Chọn tài xế giao hàng Fruitables <span class="text-red-500">*</span></label>
        <select name="shipperId" required class="w-full px-3 py-2.5 rounded-xl border border-outline-variant bg-surface-container-low text-xs font-medium focus:border-primary outline-none">
          <c:forEach var="s" items="${shippers}">
            <option value="${s.id}" ${s.status == 'AVAILABLE' ? 'selected' : ''}>
              ${s.status == 'AVAILABLE' ? '🟢 Sẵn sàng' : '🟡 Đang bận'} - ${s.fullName} (${s.phone} - ${s.vehiclePlate})
            </option>
          </c:forEach>
        </select>
      </div>

      <div>
        <label class="block text-xs font-bold text-on-surface mb-1.5">Thời gian dự kiến giao đến:</label>
        <input type="text" name="estimatedTime" value="Giao trong 45 - 60 phút" placeholder="Ví dụ: Giao trước 11:30..."
               class="w-full px-3 py-2 rounded-xl border border-outline-variant bg-surface-container-low text-xs focus:border-primary outline-none">
      </div>

      <div class="p-3 rounded-xl bg-sky-50 border border-sky-200 text-sky-800 text-[11px] flex items-center gap-2">
        <svg class="w-4 h-4 text-sky-600 flex-shrink-0"><use href="#icon-info"/></svg>
        <span>Hệ thống sẽ tự động chuyển trạng thái đơn sang <strong>SHIPPING</strong>, sinh mã vận đơn và gửi thông báo cho khách.</span>
      </div>

      <div class="flex items-center justify-end gap-2 pt-3 border-t border-surface-variant">
        <button type="button" onclick="closeDispatchModal()" class="px-4 py-2 text-xs font-semibold text-on-surface-variant hover:bg-surface-container rounded-xl">
          Hủy bỏ
        </button>
        <button type="submit" class="px-5 py-2 text-xs font-bold bg-amber-500 hover:bg-amber-600 text-white rounded-xl shadow-md flex items-center gap-1.5">
          <svg class="w-4 h-4 text-white"><use href="#icon-send"/></svg> Bàn giao ngay
        </button>
      </div>
    </form>
  </div>
</div>

<!-- MODAL CHI TIẾT ĐƠN HÀNG (ORDER DETAILS MODAL) -->
<div id="orderDetailModal" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden items-center justify-center p-4 transition-opacity">
  <div class="bg-surface-container-lowest rounded-2xl max-w-4xl w-full max-h-[90vh] flex flex-col shadow-2xl border border-outline-variant overflow-hidden">
    <!-- Header Modal -->
    <div class="flex items-center justify-between px-6 py-4 border-b border-surface-variant bg-surface-container-low">
      <div class="flex items-center gap-3">
        <span class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center font-bold">
          <svg class="w-5 h-5"><use href="#icon-order"/></svg>
        </span>
        <div>
          <div class="flex items-center gap-2.5 flex-wrap">
            <h3 class="font-headline-md text-base text-on-surface font-bold">Chi tiết đơn hàng <span id="modalOrderCode" class="text-primary">--</span></h3>
            <span id="modalOrderStatusBadge"></span>
          </div>
          <p class="text-xs text-on-surface-variant mt-0.5">Thời gian đặt hàng: <span id="modalOrderCreatedAt" class="font-medium text-on-surface">--</span></p>
        </div>
      </div>
      <div class="flex items-center gap-2">
        <a id="modalPrintBtn" href="#" target="_blank" class="px-3 py-1.5 rounded-xl border border-outline-variant bg-surface hover:bg-surface-container text-on-surface text-xs font-semibold flex items-center gap-1.5 transition-colors" title="In hoá đơn đơn hàng">
          <svg class="w-4 h-4 text-primary"><use href="#icon-print"/></svg>
          <span>In hóa đơn</span>
        </a>
        <button type="button" onclick="closeOrderDetailModal()" class="text-on-surface-variant hover:text-on-surface p-1.5 rounded-xl hover:bg-surface-container transition-colors" title="Đóng">
          <svg class="w-5 h-5"><use href="#icon-close"/></svg>
        </button>
      </div>
    </div>

    <!-- Body Modal (Scrollable) -->
    <div class="p-6 overflow-y-auto space-y-6 flex-1 text-xs">
      <!-- Loading State -->
      <div id="modalLoadingState" class="py-16 flex flex-col items-center justify-center text-on-surface-variant">
        <svg class="w-8 h-8 animate-spin text-primary mb-3"><use href="#icon-spinner"/></svg>
        <p class="font-medium">Đang tải thông tin chi tiết đơn hàng...</p>
      </div>

      <!-- Content State -->
      <div id="modalContentState" class="hidden space-y-6">
        <!-- 2 Cards: Thông tin khách hàng & Thông tin vận chuyển -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <!-- Thẻ Người nhận -->
          <div class="bg-surface-container-low/60 rounded-xl p-4 border border-outline-variant space-y-2.5">
            <div class="flex items-center justify-between pb-2 border-b border-surface-variant">
              <span class="font-bold text-on-surface text-xs flex items-center gap-1.5">
                <svg class="w-4 h-4 text-primary"><use href="#icon-customer"/></svg>
                Thông tin người nhận
              </span>
              <span id="modalCustomerTypeBadge" class="text-[10px] px-2 py-0.5 rounded-full font-bold"></span>
            </div>
            <div class="space-y-1.5">
              <div class="flex justify-between">
                <span class="text-on-surface-variant">Họ và tên:</span>
                <span id="modalRecipientName" class="font-bold text-on-surface">--</span>
              </div>
              <div class="flex justify-between">
                <span class="text-on-surface-variant">Số điện thoại:</span>
                <span id="modalRecipientPhone" class="font-semibold text-primary flex items-center gap-1">
                  <svg class="w-3 h-3"><use href="#icon-phone"/></svg>
                  <span id="modalRecipientPhoneText">--</span>
                </span>
              </div>
              <div class="flex justify-between">
                <span class="text-on-surface-variant">Email:</span>
                <span id="modalRecipientEmail" class="text-on-surface font-medium">--</span>
              </div>
              <div class="pt-1.5 border-t border-surface-variant">
                <span class="text-on-surface-variant block mb-1">Địa chỉ giao hàng:</span>
                <p id="modalShippingAddress" class="text-on-surface font-medium leading-relaxed flex items-start gap-1">
                  <svg class="w-3.5 h-3.5 text-rose-500 flex-shrink-0 mt-0.5"><use href="#icon-location"/></svg>
                  <span id="modalShippingAddressText">--</span>
                </p>
              </div>
              <div id="modalNotesContainer" class="pt-1.5 border-t border-surface-variant hidden">
                <span class="text-on-surface-variant block mb-1">Ghi chú của khách:</span>
                <p id="modalOrderNotes" class="italic text-amber-700 bg-amber-50 p-2 rounded-lg border border-amber-200">--</p>
              </div>
            </div>
          </div>

          <!-- Thẻ Giao nhận & Shipper -->
          <div class="bg-surface-container-low/60 rounded-xl p-4 border border-outline-variant space-y-2.5">
            <div class="flex items-center justify-between pb-2 border-b border-surface-variant">
              <span class="font-bold text-on-surface text-xs flex items-center gap-1.5">
                <svg class="w-4 h-4 text-amber-600"><use href="#icon-delivery"/></svg>
                Vận chuyển & Điều phối
              </span>
              <span id="modalDeliverySlotBadge" class="text-[10px] px-2 py-0.5 rounded-full font-bold bg-amber-100 text-amber-800">--</span>
            </div>
            <div class="space-y-1.5">
              <div class="flex justify-between">
                <span class="text-on-surface-variant">Shipper phụ trách:</span>
                <span id="modalShipperName" class="font-bold text-on-surface">--</span>
              </div>
              <div class="flex justify-between">
                <span class="text-on-surface-variant">SĐT Shipper:</span>
                <span id="modalShipperPhone" class="font-semibold text-on-surface">--</span>
              </div>
              <div class="flex justify-between">
                <span class="text-on-surface-variant">Biển số xe:</span>
                <span id="modalShipperPlate" class="text-on-surface">--</span>
              </div>
              <div class="flex justify-between">
                <span class="text-on-surface-variant">Mã vận đơn:</span>
                <span id="modalTrackingNumber" class="font-mono text-primary font-bold">--</span>
              </div>
              <div class="flex justify-between">
                <span class="text-on-surface-variant">Dự kiến giao:</span>
                <span id="modalEstimatedDelivery" class="text-on-surface font-medium">--</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Bảng danh sách sản phẩm trong đơn -->
        <div class="rounded-xl border border-outline-variant overflow-hidden">
          <div class="bg-surface-container-low px-4 py-2.5 border-b border-surface-variant font-bold text-on-surface flex items-center justify-between">
            <span class="flex items-center gap-1.5">
              <svg class="w-4 h-4 text-primary"><use href="#icon-inventory"/></svg>
              Danh sách sản phẩm trong đơn (<span id="modalTotalItemCount">0</span> món)
            </span>
          </div>
          <div class="overflow-x-auto">
            <table class="w-full text-left text-xs">
              <thead class="bg-surface-container-lowest border-b border-surface-variant text-on-surface-variant uppercase text-[10px] tracking-wider">
                <tr>
                  <th class="py-2.5 px-4">Sản phẩm</th>
                  <th class="py-2.5 px-4 text-right">Đơn giá</th>
                  <th class="py-2.5 px-4 text-center">Số lượng</th>
                  <th class="py-2.5 px-4 text-right">Thành tiền</th>
                </tr>
              </thead>
              <tbody id="modalProductItemsTable" class="divide-y divide-surface-variant">
                <!-- Dynamic items -->
              </tbody>
            </table>
          </div>
        </div>

        <!-- Tóm tắt thanh toán & Tài chính -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 items-end">
          <!-- Thông tin phương thức & trạng thái thanh toán -->
          <div class="bg-surface-container-low/40 rounded-xl p-4 border border-outline-variant space-y-2">
            <div class="text-xs font-bold text-on-surface">Thông tin thanh toán</div>
            <div class="flex justify-between items-center text-xs">
              <span class="text-on-surface-variant">Hình thức thanh toán:</span>
              <span id="modalPaymentMethod" class="font-bold text-on-surface">--</span>
            </div>
            <div class="flex justify-between items-center text-xs">
              <span class="text-on-surface-variant">Trạng thái thanh toán:</span>
              <span id="modalPaymentStatusBadge">--</span>
            </div>
          </div>

          <!-- Chi tiết cộng trừ tiền -->
          <div class="bg-surface-container-low/40 rounded-xl p-4 border border-outline-variant space-y-2 text-xs">
            <div class="flex justify-between text-on-surface-variant">
              <span>Tạm tính tiền hàng:</span>
              <span id="modalSubtotalAmount" class="font-semibold text-on-surface">--</span>
            </div>
            <div class="flex justify-between text-on-surface-variant">
              <span>Phí vận chuyển:</span>
              <span id="modalShippingFee">--</span>
            </div>
            <div id="modalShippingDiscountRow" class="flex justify-between text-emerald-700 hidden">
              <span>Giảm phí vận chuyển:</span>
              <span id="modalShippingDiscount">--</span>
            </div>
            <div id="modalPointsDiscountRow" class="flex justify-between text-emerald-700 hidden">
              <span>Giảm điểm thưởng:</span>
              <span id="modalPointsDiscount">--</span>
            </div>
            <div class="pt-2 border-t border-surface-variant flex justify-between items-center">
              <span class="font-bold text-sm text-on-surface">Tổng thanh toán:</span>
              <span id="modalGrandTotal" class="font-bold text-lg text-emerald-600">--</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer Modal -->
    <div class="px-6 py-3 bg-surface-container-low border-t border-surface-variant flex items-center justify-between">
      <div class="text-xs text-on-surface-variant flex items-center gap-1.5">
        <svg class="w-3.5 h-3.5 text-primary"><use href="#icon-info"/></svg>
        <span>Fruitables Express & Fresh Delivery System</span>
      </div>
      <button type="button" onclick="closeOrderDetailModal()" class="px-5 py-2 text-xs font-bold bg-surface-container hover:bg-surface-container-high text-on-surface rounded-xl border border-outline-variant transition-colors">
        Đóng
      </button>
    </div>
  </div>
</div>
</body>
</html>