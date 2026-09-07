<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Quản lý Danh mục - Fruitables Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-surface font-body-md text-body-md flex h-screen overflow-hidden">

<!-- Sidebar -->
<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
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
  </nav>
</aside>

<!-- Main Content -->
<main class="flex-1 flex flex-col h-screen overflow-hidden">
  <header class="h-20 bg-surface flex items-center justify-between px-6 border-b border-surface-variant flex-shrink-0">
    <h1 class="text-xl font-bold text-gray-800">Cấu hình Danh mục Sản phẩm</h1>
    <div class="flex items-center gap-4">
      <span class="font-label-bold">${sessionScope.USERMODEL.fullName}</span>
    </div>
  </header>

  <div class="flex-1 overflow-y-auto p-6 bg-gray-50">
    <!-- Form Tạo mới Danh mục -->
    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200 mb-8 max-w-4xl">
      <h2 class="text-lg font-bold mb-4 border-b pb-2">Thêm Danh mục Mới</h2>

      <c:if test="${param.message == 'Error'}">
        <div class="bg-red-100 text-red-600 p-3 rounded mb-4 font-semibold text-sm">Đã có lỗi xảy ra. Không thể thêm danh mục!</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/admin/categories/add" method="POST" class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
        <div class="md:col-span-2">
          <label class="block text-sm font-semibold mb-1">Tên Danh mục</label>
          <input type="text" name="name" placeholder="VD: Trái cây nhập khẩu" required class="w-full border rounded px-3 py-2 outline-none focus:border-primary">
        </div>
        <div>
          <label class="block text-sm font-semibold mb-1">Thuế áp dụng (%)</label>
          <input type="number" step="0.01" name="taxRate" placeholder="VD: 5.0" required class="w-full border rounded px-3 py-2 outline-none focus:border-primary">
        </div>
        <div class="flex items-center mb-2">
          <input type="checkbox" name="status" id="status" checked class="w-5 h-5 text-green-600 rounded">
          <label for="status" class="ml-2 text-sm font-semibold cursor-pointer">Hiển thị</label>
        </div>
        <div class="md:col-span-4 mt-2">
          <button type="submit" class="bg-primary hover:bg-primary-container text-white font-bold py-2 px-6 rounded transition-colors">
            Lưu Danh mục
          </button>
        </div>
      </form>
    </div>

    <!-- Bảng danh sách Danh mục -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <table class="w-full text-left">
        <thead class="bg-gray-100 border-b border-gray-200">
        <tr>
          <th class="py-3 px-6">ID</th>
          <th class="py-3 px-6">Tên Danh mục</th>
          <th class="py-3 px-6">Thuế suất (%)</th>
          <th class="py-3 px-6">Trạng thái</th>
          <th class="py-3 px-6 text-center">Ngày tạo</th>
        </tr>
        </thead>
        <tbody class="divide-y divide-gray-100 text-sm">
        <c:forEach var="category" items="${categories}">
          <tr class="hover:bg-gray-50 transition-colors">
            <td class="py-3 px-6 font-bold text-gray-500">#<c:out value="${category.id}"/></td>
            <td class="py-3 px-6 font-bold text-gray-800"><c:out value="${category.name}"/></td>
            <td class="py-3 px-6 text-gray-600">
              <fmt:formatNumber value="${category.taxRate}" type="number" maxFractionDigits="2"/> %
            </td>
            <td class="py-3 px-6">
              <c:choose>
                <c:when test="${category.status}">
                  <span class="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold">Hiển thị</span>
                </c:when>
                <c:otherwise>
                  <span class="bg-gray-100 text-gray-500 px-2 py-1 rounded text-xs font-bold">Đang ẩn</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td class="py-3 px-6 text-center text-gray-500">
              <fmt:formatDate value="${category.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
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