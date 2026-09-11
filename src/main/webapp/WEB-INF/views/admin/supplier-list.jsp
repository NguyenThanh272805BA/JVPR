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

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />


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
