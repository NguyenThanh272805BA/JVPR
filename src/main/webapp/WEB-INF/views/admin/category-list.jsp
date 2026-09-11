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

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />


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

      <c:if test="${param.message == 'AddSuccess'}">
        <div class="bg-green-100 text-green-700 p-3 rounded-lg mb-4 font-semibold text-sm flex items-center gap-2">
          <span class="material-symbols-outlined text-sm">check_circle</span> Thêm danh mục mới thành công!
        </div>
      </c:if>
      <c:if test="${param.message == 'UpdateSuccess'}">
        <div class="bg-blue-100 text-blue-700 p-3 rounded-lg mb-4 font-semibold text-sm flex items-center gap-2">
          <span class="material-symbols-outlined text-sm">check_circle</span> Cập nhật thông tin danh mục thành công!
        </div>
      </c:if>
      <c:if test="${param.message == 'Error'}">
        <div class="bg-red-100 text-red-600 p-3 rounded-lg mb-4 font-semibold text-sm flex items-center gap-2">
          <span class="material-symbols-outlined text-sm">error</span> Đã có lỗi xảy ra. Vui lòng kiểm tra lại dữ liệu!
        </div>
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
          <button type="submit" class="bg-primary hover:bg-primary-container text-white font-bold py-2 px-6 rounded transition-colors flex items-center gap-1.5 shadow-sm">
            <span class="material-symbols-outlined text-[18px]">add_circle</span> Lưu Danh mục
          </button>
        </div>
      </form>
    </div>

    <!-- Bảng danh sách Danh mục -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <table class="w-full text-left">
        <thead class="bg-gray-100 border-b border-gray-200">
        <tr>
          <th class="py-3.5 px-6">ID</th>
          <th class="py-3.5 px-6">Tên Danh mục</th>
          <th class="py-3.5 px-6">Thuế suất (%)</th>
          <th class="py-3.5 px-6">Trạng thái</th>
          <th class="py-3.5 px-6 text-center">Ngày tạo</th>
          <th class="py-3.5 px-6 text-center">Thao tác</th>
        </tr>
        </thead>
        <tbody class="divide-y divide-gray-100 text-sm">
        <c:forEach var="category" items="${categories}">
          <tr class="hover:bg-gray-50 transition-colors">
            <td class="py-3.5 px-6 font-bold text-gray-500">#<c:out value="${category.id}"/></td>
            <td class="py-3.5 px-6 font-bold text-gray-800"><c:out value="${category.name}"/></td>
            <td class="py-3.5 px-6 text-gray-600">
              <fmt:formatNumber value="${category.taxRate}" type="number" maxFractionDigits="2"/> %
            </td>
            <td class="py-3.5 px-6">
              <c:choose>
                <c:when test="${category.status}">
                  <span class="bg-green-100 text-green-700 px-2.5 py-1 rounded-full text-xs font-bold inline-flex items-center gap-1">
                    <span class="w-1.5 h-1.5 rounded-full bg-green-600"></span> Hiển thị
                  </span>
                </c:when>
                <c:otherwise>
                  <span class="bg-gray-100 text-gray-500 px-2.5 py-1 rounded-full text-xs font-bold inline-flex items-center gap-1">
                    <span class="w-1.5 h-1.5 rounded-full bg-gray-400"></span> Đang ẩn
                  </span>
                </c:otherwise>
              </c:choose>
            </td>
            <td class="py-3.5 px-6 text-center text-gray-500">
              <fmt:formatDate value="${category.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
            </td>
            <td class="py-3.5 px-6 text-center">
              <button type="button" 
                      onclick="openEditModal('${category.id}', '${category.name}', '${category.taxRate}', ${category.status})"
                      class="px-3 py-1.5 bg-blue-50 text-blue-600 hover:bg-blue-600 hover:text-white rounded-lg transition-colors font-semibold text-xs inline-flex items-center gap-1 border border-blue-200">
                <span class="material-symbols-outlined text-[16px]">edit</span> Sửa
              </button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</main>

<!-- MODAL CHỈNH SỬA DANH MỤC -->
<div id="editCategoryModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4 transition-all">
  <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg overflow-hidden border border-gray-100 animate-in fade-in zoom-in-95 duration-200" onclick="event.stopPropagation()">
    <!-- Modal Header -->
    <div class="bg-gradient-to-r from-blue-600 to-indigo-600 px-6 py-4 flex items-center justify-between text-white">
      <div class="flex items-center gap-2">
        <span class="material-symbols-outlined">edit_note</span>
        <h3 class="font-bold text-lg">Chỉnh Sửa Danh Mục</h3>
      </div>
      <button type="button" onclick="closeEditModal()" class="w-8 h-8 rounded-full bg-white/20 hover:bg-white/30 flex items-center justify-center transition-colors">
        <span class="material-symbols-outlined text-sm">close</span>
      </button>
    </div>

    <!-- Modal Form -->
    <form action="${pageContext.request.contextPath}/admin/categories/edit" method="POST" class="p-6 space-y-4">
      <input type="hidden" id="editCategoryId" name="id">

      <div>
        <label class="block text-sm font-bold text-gray-700 mb-1">Tên Danh mục <span class="text-red-500">*</span></label>
        <input type="text" id="editCategoryName" name="name" required class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-600 text-sm">
      </div>

      <div>
        <label class="block text-sm font-bold text-gray-700 mb-1">Thuế suất (%) <span class="text-red-500">*</span></label>
        <input type="number" step="0.01" id="editCategoryTaxRate" name="taxRate" required class="w-full border border-gray-300 rounded-lg px-3.5 py-2.5 outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-600 text-sm">
      </div>

      <div class="flex items-center gap-3 pt-2">
        <input type="checkbox" id="editCategoryStatus" name="status" class="w-5 h-5 text-blue-600 rounded cursor-pointer">
        <label for="editCategoryStatus" class="text-sm font-semibold text-gray-700 cursor-pointer">Cho phép hiển thị ngoài website</label>
      </div>

      <div class="flex items-center justify-end gap-3 pt-4 border-t border-gray-100">
        <button type="button" onclick="closeEditModal()" class="px-5 py-2.5 rounded-lg border border-gray-300 text-gray-700 font-semibold hover:bg-gray-50 text-sm transition-colors">
          Hủy bỏ
        </button>
        <button type="submit" class="px-6 py-2.5 rounded-lg bg-blue-600 hover:bg-blue-700 text-white font-bold text-sm shadow-md transition-colors flex items-center gap-1.5">
          <span class="material-symbols-outlined text-[18px]">save</span> Cập nhật
        </button>
      </div>
    </form>
  </div>
</div>

<script>
  function openEditModal(id, name, taxRate, status) {
    document.getElementById('editCategoryId').value = id;
    document.getElementById('editCategoryName').value = name;
    document.getElementById('editCategoryTaxRate').value = taxRate;
    document.getElementById('editCategoryStatus').checked = (status === true || status === 'true');
    document.getElementById('editCategoryModal').classList.remove('hidden');
  }

  function closeEditModal() {
    document.getElementById('editCategoryModal').classList.add('hidden');
  }
</script>
</body>
</html>