<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Quản lý Khuyến mãi - Fruitables Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-surface font-body-md text-body-md flex h-screen overflow-hidden">

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
  <header class="h-20 bg-surface flex items-center justify-between px-6 border-b border-surface-variant flex-shrink-0">
    <h1 class="text-xl font-bold text-gray-800">Cấu hình Mã Giảm Giá / Voucher</h1>
    <div class="flex items-center gap-4">
      <span class="font-label-bold">${sessionScope.USERMODEL.fullName}</span>
    </div>
  </header>

  <div class="flex-1 overflow-y-auto p-6 bg-gray-50">
    <!-- Form Tạo mới Khuyến mãi -->
    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200 mb-8">
      <h2 class="text-lg font-bold mb-4 border-b pb-2">Thiết kế Voucher mới</h2>
      <form action="${pageContext.request.contextPath}/admin/coupons/add" method="POST" class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
        <div>
          <label class="block text-sm font-semibold mb-1">Mã Voucher</label>
          <input type="text" name="code" placeholder="VD: SALE50K" required class="w-full border rounded px-3 py-2 outline-none focus:border-primary uppercase">
        </div>
        <div>
          <label class="block text-sm font-semibold mb-1">Loại giảm</label>
          <select name="discountType" class="w-full border rounded px-3 py-2 outline-none focus:border-primary">
            <option value="FIXED">Giảm tiền trực tiếp (VNĐ)</option>
            <option value="PERCENT">Giảm theo %</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-semibold mb-1">Mức giảm</label>
          <input type="number" name="discountValue" placeholder="VD: 50000" required class="w-full border rounded px-3 py-2 outline-none focus:border-primary">
        </div>
        <div>
          <label class="block text-sm font-semibold mb-1 text-primary">Điều kiện (Đơn tối thiểu)</label>
          <input type="number" name="minOrderValue" placeholder="VD: 500000" required class="w-full border rounded px-3 py-2 outline-none focus:border-primary border-primary">
        </div>
        <div>
          <label class="block text-sm font-semibold mb-1">Từ ngày</label>
          <input type="datetime-local" name="startDate" required class="w-full border rounded px-3 py-2 outline-none focus:border-primary">
        </div>
        <div>
          <label class="block text-sm font-semibold mb-1">Đến ngày</label>
          <input type="datetime-local" name="endDate" required class="w-full border rounded px-3 py-2 outline-none focus:border-primary">
        </div>
        <div>
          <label class="block text-sm font-semibold mb-1">Số lượng giới hạn</label>
          <input type="number" name="usageLimit" value="100" class="w-full border rounded px-3 py-2 outline-none focus:border-primary">
        </div>
        <div>
          <button type="submit" class="w-full bg-primary hover:bg-primary-container text-white font-bold py-2 px-4 rounded transition-colors">
            Tạo Voucher
          </button>
        </div>
      </form>
    </div>

    <!-- Bảng danh sách các Voucher đang hoạt động -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <table class="w-full text-left">
        <thead class="bg-gray-100 border-b border-gray-200">
        <tr>
          <th class="py-3 px-4">Mã Voucher</th>
          <th class="py-3 px-4">Giảm giá</th>
          <th class="py-3 px-4">Điều kiện tối thiểu</th>
          <th class="py-3 px-4">Thời gian áp dụng</th>
          <th class="py-3 px-4 text-center">Trạng thái</th>
        </tr>
        </thead>
        <tbody class="divide-y divide-gray-100 text-sm">

        <!-- Vòng lặp JSTL đổ dữ liệu thật từ DB -->
        <c:forEach var="coupon" items="${coupons}">
          <tr>
            <td class="py-3 px-4 font-bold text-primary uppercase"><c:out value="${coupon.code}"/></td>

            <td class="py-3 px-4 text-red-500 font-bold">
              <c:choose>
                <c:when test="${coupon.discountType == 'FIXED'}">
                  - <fmt:formatNumber value="${coupon.discountValue}" type="number" groupingUsed="true"/> ₫
                </c:when>
                <c:otherwise>
                  - <c:out value="${coupon.discountValue}"/> %
                </c:otherwise>
              </c:choose>
            </td>

            <td class="py-3 px-4 font-medium">Đơn từ <fmt:formatNumber value="${coupon.minOrderValue}" type="number" groupingUsed="true"/> ₫</td>
            <td class="py-3 px-4 text-gray-500">
              Đến <fmt:formatDate value="${coupon.endDate}" pattern="dd/MM/yyyy HH:mm"/>
            </td>
            <td class="py-3 px-4 text-center">
              <c:choose>
                <c:when test="${coupon.status}">
                  <span class="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold">Hoạt động</span>
                </c:when>
                <c:otherwise>
                  <span class="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs font-bold">Đã đóng</span>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>

        </tbody>
      </table>
    </div>
  </div>
</main>
</body>
</html>