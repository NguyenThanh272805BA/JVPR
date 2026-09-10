<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Chi Tiết Phiếu Nhập #${receipt.receiptCode} - Fruitables Admin</title>
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
      <span class="material-symbols-outlined">local_shipping</span>
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
  </nav>
</aside>

<main class="flex-1 flex flex-col h-screen overflow-hidden">
  <header class="h-20 bg-surface flex items-center justify-between px-6 shadow-sm z-10 flex-shrink-0 border-b border-surface-variant">
    <div class="flex items-center gap-3">
      <a href="${pageContext.request.contextPath}/admin/inventory" class="p-2 text-slate-500 hover:bg-slate-100 rounded-lg transition-colors">
        <span class="material-symbols-outlined">arrow_back</span>
      </a>
      <span class="font-bold text-lg text-slate-800">Phiếu nhập kho #${receipt.receiptCode}</span>
    </div>
    <div class="flex items-center gap-4 flex-shrink-0">
      <span class="font-label-bold mr-2 truncate max-w-[160px] whitespace-nowrap text-sm" title="${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
      <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full transition-colors flex-shrink-0" title="Đăng xuất">
        <span class="material-symbols-outlined">logout</span>
      </a>
    </div>
  </header>

  <div class="flex-1 overflow-y-auto p-6 bg-[#f8fafc]">
    <div class="max-w-4xl mx-auto space-y-6">
      
      <!-- Card Thông Tin Tổng Quan -->
      <div class="bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-surface-variant">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b pb-4 mb-4">
          <div>
            <div class="flex items-center gap-2">
              <span class="font-mono text-xl font-bold text-primary">${receipt.receiptCode}</span>
              <span class="px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 font-bold text-xs">
                ${receipt.status}
              </span>
            </div>
            <p class="text-xs text-slate-400 mt-1">
              Thời gian nhập: <fmt:formatDate value="${receipt.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
            </p>
          </div>
          <div class="text-right">
            <span class="text-xs text-slate-500">Tổng tiền nhập hàng:</span>
            <div class="text-2xl font-black text-amber-700">
              <fmt:formatNumber value="${receipt.totalCost}" type="number" groupingUsed="true"/> ₫
            </div>
          </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 text-xs text-slate-600">
          <div>
            <p><strong>Nhà cung cấp:</strong> ${not empty receipt.supplierName ? receipt.supplierName : 'Tự do'}</p>
            <p class="mt-1"><strong>Người lập phiếu:</strong> ${not empty receipt.creatorName ? receipt.creatorName : 'Admin'}</p>
          </div>
          <div>
            <p><strong>Ghi chú:</strong> ${not empty receipt.note ? receipt.note : 'Không có ghi chú'}</p>
          </div>
        </div>
      </div>

      <!-- Bảng danh sách chi tiết mặt hàng -->
      <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-variant overflow-hidden">
        <div class="p-4 bg-slate-50 border-b border-slate-200 font-bold text-xs text-slate-700 uppercase tracking-wider">
          Chi tiết danh mục sản phẩm nhập kho
        </div>
        <table class="w-full text-left border-collapse text-xs">
          <thead>
            <tr class="bg-slate-50 text-slate-500 border-b border-slate-200">
              <th class="py-3 px-6">Sản phẩm</th>
              <th class="py-3 px-6">Danh mục</th>
              <th class="py-3 px-6 text-center">Số lượng</th>
              <th class="py-3 px-6 text-right">Đơn giá nhập</th>
              <th class="py-3 px-6 text-right">Thành tiền</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100">
            <c:forEach var="item" items="${receipt.details}">
              <tr class="hover:bg-slate-50">
                <td class="py-3.5 px-6 font-medium text-slate-800 flex items-center gap-3">
                  <c:choose>
                    <c:when test="${not empty item.productImageUrl}">
                      <img src="${item.productImageUrl}" class="w-8 h-8 rounded-lg object-cover border">
                    </c:when>
                    <c:otherwise>
                      <div class="w-8 h-8 rounded-lg bg-slate-100 flex items-center justify-center text-slate-400">
                        <span class="material-symbols-outlined text-sm">image</span>
                      </div>
                    </c:otherwise>
                  </c:choose>
                  <span>${item.productName}</span>
                </td>
                <td class="py-3.5 px-6 text-slate-500">${item.categoryName}</td>
                <td class="py-3.5 px-6 text-center font-bold text-slate-700">${item.quantity}</td>
                <td class="py-3.5 px-6 text-right text-slate-600">
                  <fmt:formatNumber value="${item.importPrice}" type="number" groupingUsed="true"/> ₫
                </td>
                <td class="py-3.5 px-6 text-right font-bold text-amber-700">
                  <fmt:formatNumber value="${item.subTotal}" type="number" groupingUsed="true"/> ₫
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
