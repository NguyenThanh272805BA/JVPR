<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Danh Sách Nhà Cung Cấp - Fruitables Admin</title>
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
      <span class="font-bold text-lg text-slate-800">Đối tác & Nhà Cung Cấp</span>
    </div>
    <div class="flex items-center gap-4 flex-shrink-0">
      <span class="font-label-bold mr-2 truncate max-w-[160px] whitespace-nowrap text-sm" title="${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
      <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full transition-colors flex-shrink-0" title="Đăng xuất">
        <span class="material-symbols-outlined">logout</span>
      </a>
    </div>
  </header>

  <div class="flex-1 overflow-y-auto p-6 bg-[#f8fafc]">
    <div class="max-w-5xl mx-auto space-y-6">
      
      <div class="flex justify-between items-center">
        <div>
          <h1 class="font-bold text-2xl text-slate-900">Danh Sách Nhà Cung Cấp</h1>
          <p class="text-xs text-slate-500 mt-1">Các nông trại, đơn vị nhập khẩu hoa quả và hợp tác xã cung ứng</p>
        </div>
        <button type="button" onclick="document.getElementById('quickSupplierModal').classList.remove('hidden')" class="px-4 py-2.5 bg-primary hover:bg-primary-container text-white font-bold text-xs rounded-xl shadow transition-all flex items-center gap-2">
          <span class="material-symbols-outlined text-base">add</span>
          Thêm nhà cung cấp
        </button>
      </div>

      <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-surface-variant overflow-hidden">
        <table class="w-full text-left border-collapse text-xs">
          <thead>
            <tr class="bg-slate-50 text-slate-600 font-bold border-b border-slate-200 uppercase tracking-wider">
              <th class="py-4 px-6">Tên Nhà Cung Cấp</th>
              <th class="py-4 px-6">Người Liên Hệ</th>
              <th class="py-4 px-6">Số Điện Thoại</th>
              <th class="py-4 px-6">Email</th>
              <th class="py-4 px-6">Địa Chỉ</th>
              <th class="py-4 px-6 text-center">Trạng Thái</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100">
            <c:choose>
              <c:when test="${not empty suppliers}">
                <c:forEach var="s" items="${suppliers}">
                  <tr class="hover:bg-slate-50">
                    <td class="py-3.5 px-6 font-bold text-slate-800">${s.name}</td>
                    <td class="py-3.5 px-6 text-slate-600">${s.contactName}</td>
                    <td class="py-3.5 px-6 font-mono text-slate-600">${s.phone}</td>
                    <td class="py-3.5 px-6 text-slate-600">${s.email}</td>
                    <td class="py-3.5 px-6 text-slate-500">${s.address}</td>
                    <td class="py-3.5 px-6 text-center">
                      <span class="px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 font-bold text-[10px]">
                        Đang hợp tác
                      </span>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="6" class="py-12 text-center text-slate-400">
                    Chưa có nhà cung cấp nào. Hãy bấm "Thêm nhà cung cấp" để bắt đầu!
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

    </div>
  </div>
</main>

<!-- MODAL THÊM NHÀ CUNG CẤP -->
<div id="quickSupplierModal" class="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm hidden flex items-center justify-center p-4">
  <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden border border-slate-200">
    <form action="${pageContext.request.contextPath}/admin/suppliers" method="POST" class="p-6 space-y-4">
      <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/admin/suppliers">
      <div class="flex items-center justify-between border-b pb-3">
        <h3 class="font-bold text-base text-slate-800">Thêm Nhà Cung Cấp Mới</h3>
        <button type="button" onclick="document.getElementById('quickSupplierModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600">
          <span class="material-symbols-outlined text-sm">close</span>
        </button>
      </div>

      <div>
        <label class="block text-xs font-bold text-slate-700 mb-1">Tên nhà cung cấp / Nông trại (*):</label>
        <input type="text" name="name" required placeholder="VD: Nông trại Đà Lạt Organic..." class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
      </div>
      <div>
        <label class="block text-xs font-bold text-slate-700 mb-1">Người liên hệ:</label>
        <input type="text" name="contactName" placeholder="VD: Anh Minh (Chủ vườn)" class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
      </div>
      <div class="grid grid-cols-2 gap-2">
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Số điện thoại:</label>
          <input type="text" name="phone" placeholder="0987..." class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
        </div>
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Email:</label>
          <input type="email" name="email" placeholder="dalat@..." class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
        </div>
      </div>
      <div>
        <label class="block text-xs font-bold text-slate-700 mb-1">Địa chỉ:</label>
        <input type="text" name="address" placeholder="Đơn Dương, Lâm Đồng" class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
      </div>

      <div class="flex items-center justify-end gap-2 pt-2 border-t">
        <button type="button" onclick="document.getElementById('quickSupplierModal').classList.add('hidden')" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-lg text-xs font-bold">
          Hủy
        </button>
        <button type="submit" class="px-4 py-2 bg-primary hover:bg-primary-container text-white rounded-lg text-xs font-bold shadow">
          Lưu nhà cung cấp
        </button>
      </div>
    </form>
  </div>
</div>
</body>
</html>
