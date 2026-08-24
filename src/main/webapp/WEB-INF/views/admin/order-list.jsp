<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Fruitables - Quản lý Đơn hàng</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-surface font-body-md flex h-screen overflow-hidden">

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<c:set var="currentURI" value="${requestScope['javax.servlet.forward.request_uri']}" />
<aside class="w-64 bg-surface-container-lowest border-r border-surface-variant flex flex-col h-full flex-shrink-0 z-20 shadow-sm hidden md:flex">
  <div class="h-20 flex items-center px-6 border-b border-surface-variant">
    <span class="font-display-lg text-xl font-extrabold text-primary">Fruitables</span>
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
  </nav>
</aside>

<!-- Main Content -->
<main class="flex-1 flex flex-col h-screen overflow-hidden">
  <!-- Header -->
  <header class="h-20 bg-surface flex items-center justify-between px-6 shadow-sm z-10 flex-shrink-0">
    <div class="flex items-center flex-1 justify-end">
      <div class="flex items-center gap-4">
        <span class="font-label-bold mr-2">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
        <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full transition-colors" title="Đăng xuất">
          <span class="material-symbols-outlined">logout</span>
        </a>
      </div>
    </div>
  </header>

  <!-- Scrollable Content Area -->
  <div class="flex-1 overflow-y-auto p-6 bg-[#f8fafc]">
    <div class="flex justify-between items-center mb-8">
      <h1 class="font-headline-md text-2xl font-bold text-on-surface">Quản lý Đơn hàng</h1>
    </div>

    <div class="bg-surface-container-lowest rounded-lg shadow-sm overflow-hidden border border-outline-variant">
      <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
          <thead>
          <tr class="border-b border-surface-variant bg-surface-container-low text-on-surface-variant font-label-bold">
            <th class="py-4 px-6">Mã ĐH</th>
            <th class="py-4 px-6">SĐT Khách</th>
            <th class="py-4 px-6">Tổng tiền</th>
            <th class="py-4 px-6">PTTT</th>
            <th class="py-4 px-6">Trạng thái PTTT</th>
            <th class="py-4 px-6">Tình trạng ĐH</th>
            <th class="py-4 px-6 text-center">Thao tác</th>
          </tr>
          </thead>
          <tbody class="divide-y divide-surface-variant">
          <c:forEach var="order" items="${orders}">
            <tr class="hover:bg-surface-container-lowest transition-colors">
              <td class="py-4 px-6 font-bold text-primary"><c:out value="${order.orderCode}"/></td>
              <td class="py-4 px-6"><c:out value="${order.phone}"/></td>
              <td class="py-4 px-6 font-price-tag text-on-surface">
                <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫
              </td>
              <td class="py-4 px-6 text-on-surface-variant"><c:out value="${order.paymentMethod}"/></td>
              <td class="py-4 px-6">
                <c:choose>
                  <c:when test="${order.paymentStatus == 'PAID'}">
                    <span class="px-2 py-1 bg-green-100 text-green-700 rounded text-xs font-bold">Đã thanh toán</span>
                  </c:when>
                  <c:otherwise>
                    <span class="px-2 py-1 bg-red-100 text-red-700 rounded text-xs font-bold">Chưa thanh toán</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="py-4 px-6">
                <span class="px-2 py-1 bg-blue-100 text-blue-700 rounded text-xs font-bold"><c:out value="${order.status}"/></span>
              </td>
              <td class="py-4 px-6 text-center">
                <a href="${pageContext.request.contextPath}/admin/orders/export-invoice?orderCode=${order.orderCode}" class="text-primary hover:text-primary-container transition-colors" title="Xuất PDF">
                  <span class="material-symbols-outlined">print</span>
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