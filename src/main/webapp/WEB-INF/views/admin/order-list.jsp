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

  <div class="flex-1 overflow-y-auto p-6 bg-[#f8fafc]">
    <div class="flex justify-between items-center mb-8">
      <div>
        <h1 class="font-headline-md text-2xl font-bold text-on-surface">Quản lý Đơn hàng</h1>
        <p class="text-xs text-on-surface-variant mt-1">Quy trình xử lý hoa quả tươi: Tiếp nhận &rarr; Xác nhận &rarr; Đóng gói &rarr; Giao hàng hỏa tốc (Báo email) &rarr; Hoàn tất</p>
      </div>
    </div>

    <div class="bg-surface-container-lowest rounded-2xl shadow-sm overflow-hidden border border-outline-variant">
      <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
          <thead>
          <tr class="border-b border-surface-variant bg-surface-container-low text-on-surface-variant font-label-bold text-xs uppercase tracking-wider">
            <th class="py-4 px-6">Mã ĐH</th>
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
            <tr class="hover:bg-surface-bright transition-colors">
              <td class="py-4 px-6 font-bold text-primary whitespace-nowrap">
                <c:out value="${order.orderCode}"/>
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
              <td class="py-4 px-6 whitespace-nowrap">
                <c:choose>
                  <c:when test="${order.status == 'PENDING'}">
                    <span class="px-2.5 py-1 bg-amber-50 text-amber-600 border border-amber-200 rounded-full text-[11px] font-bold">1. Đã đặt hàng</span>
                  </c:when>
                  <c:when test="${order.status == 'CONFIRMED'}">
                    <span class="px-2.5 py-1 bg-blue-50 text-blue-600 border border-blue-200 rounded-full text-[11px] font-bold">2. Đã xác nhận</span>
                  </c:when>
                  <c:when test="${order.status == 'PACKING'}">
                    <span class="px-2.5 py-1 bg-indigo-50 text-indigo-600 border border-indigo-200 rounded-full text-[11px] font-bold">3. Đóng gói & Lạnh</span>
                  </c:when>
                  <c:when test="${order.status == 'SHIPPING'}">
                    <span class="px-2.5 py-1 bg-sky-100 text-sky-700 border border-sky-300 rounded-full text-[11px] font-bold animate-pulse">4. Đang giao hàng</span>
                  </c:when>
                  <c:when test="${order.status == 'DELIVERED'}">
                    <span class="px-2.5 py-1 bg-emerald-100 text-emerald-700 border border-emerald-300 rounded-full text-[11px] font-bold">5. Đã giao</span>
                  </c:when>
                  <c:when test="${order.status == 'COMPLETED'}">
                    <span class="px-2.5 py-1 bg-green-100 text-green-800 border border-green-300 rounded-full text-[11px] font-bold">Hoàn tất</span>
                  </c:when>
                  <c:when test="${order.status == 'RETURNED'}">
                    <span class="px-2.5 py-1 bg-purple-100 text-purple-700 rounded-full text-[11px] font-bold">Đã hoàn hàng</span>
                  </c:when>
                  <c:when test="${order.status == 'FAILED'}">
                    <span class="px-2.5 py-1 bg-rose-100 text-rose-700 rounded-full text-[11px] font-bold">Giao thất bại</span>
                  </c:when>
                  <c:when test="${order.status == 'CANCELLED'}">
                    <span class="px-2.5 py-1 bg-red-100 text-red-700 rounded-full text-[11px] font-bold">Đã hủy</span>
                  </c:when>
                  <c:otherwise>
                    <span class="px-2.5 py-1 bg-gray-100 text-gray-700 rounded-full text-[11px] font-bold"><c:out value="${order.status}"/></span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="py-4 px-6 text-center">
                <div class="flex items-center justify-center gap-1.5 flex-wrap">
                  <!-- Bước 1: PENDING -> CONFIRMED -->
                  <c:if test="${order.status == 'PENDING'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="CONFIRMED">
                      <button type="submit" class="px-2.5 py-1.5 bg-blue-600 text-white hover:bg-blue-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm" title="Xác nhận đơn">
                        <span class="material-symbols-outlined text-[14px]">check</span> Xác nhận
                      </button>
                    </form>
                  </c:if>

                  <!-- Bước 2: CONFIRMED -> PACKING -->
                  <c:if test="${order.status == 'CONFIRMED'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="PACKING">
                      <button type="submit" class="px-2.5 py-1.5 bg-indigo-600 text-white hover:bg-indigo-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm" title="Đóng gói & Giữ nhiệt lạnh">
                        <span class="material-symbols-outlined text-[14px]">inventory_2</span> Đóng gói
                      </button>
                    </form>
                  </c:if>

                  <!-- Bước 3: PACKING -> SHIPPING (Kích hoạt Email & Web Notification nếu có) -->
                  <c:if test="${order.status == 'PACKING'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="SHIPPING">
                      <c:choose>
                        <c:when test="${not empty order.userId || not empty order.customerEmail}">
                          <button type="submit" class="px-2.5 py-1.5 bg-sky-600 text-white hover:bg-sky-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm" title="Khách có tài khoản: Đi giao + Báo Gmail & Web Notification">
                            <span class="material-symbols-outlined text-[14px]">forward_to_inbox</span> Đi giao (Báo Gmail)
                          </button>
                        </c:when>
                        <c:otherwise>
                          <button type="submit" class="px-2.5 py-1.5 bg-sky-600 text-white hover:bg-sky-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm" title="Khách vãng lai: Giao hàng (Khách tra cứu tiến độ qua SĐT)">
                            <span class="material-symbols-outlined text-[14px]">local_shipping</span> Đi giao (Khách SĐT)
                          </button>
                        </c:otherwise>
                      </c:choose>
                    </form>
                  </c:if>

                  <!-- Bước 4: SHIPPING -> DELIVERED / FAILED / RETURNED -->
                  <c:if test="${order.status == 'SHIPPING'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="DELIVERED">
                      <button type="submit" class="px-2.5 py-1.5 bg-emerald-600 text-white hover:bg-emerald-700 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm" title="Xác nhận đã giao hoa quả">
                        <span class="material-symbols-outlined text-[14px]">done_all</span> Đã giao
                      </button>
                    </form>
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="FAILED">
                      <button type="submit" class="p-1.5 bg-rose-50 text-rose-600 hover:bg-rose-600 hover:text-white rounded-lg transition-colors" title="Giao thất bại">
                        <span class="material-symbols-outlined text-[14px]">cancel</span>
                      </button>
                    </form>
                  </c:if>

                  <!-- Bước 5: DELIVERED -> COMPLETED -->
                  <c:if test="${order.status == 'DELIVERED'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="COMPLETED">
                      <button type="submit" class="px-2.5 py-1.5 bg-green-700 text-white hover:bg-green-800 rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-sm" title="Đơn hoàn tất thành công">
                        <span class="material-symbols-outlined text-[14px]">verified</span> Hoàn tất
                      </button>
                    </form>
                  </c:if>

                  <!-- Nút Hủy Đơn (Chỉ cho phép khi chưa giao) -->
                  <c:if test="${order.status == 'PENDING' || order.status == 'CONFIRMED' || order.status == 'PACKING'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline" onsubmit="return confirm('Bạn có chắc muốn hủy đơn này? Tồn kho hoa quả sẽ được hoàn lại tự động.');">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="CANCELLED">
                      <button type="submit" class="p-1.5 bg-red-50 text-red-600 hover:bg-red-600 hover:text-white rounded-lg transition-colors" title="Hủy đơn & hoàn kho">
                        <span class="material-symbols-outlined text-[14px]">close</span>
                      </button>
                    </form>
                  </c:if>

                  <!-- Nút Hoàn hàng cho đơn lỗi -->
                  <c:if test="${order.status == 'FAILED'}">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="inline">
                      <input type="hidden" name="action" value="updateStatus">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <input type="hidden" name="status" value="RETURNED">
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
          </tbody>
        </table>
      </div>
    </div>
  </div>
</main>
</body>
</html>