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

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />


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
          <label class="block text-sm font-semibold mb-1">Sản phẩm áp dụng</label>
          <select name="productId" class="w-full border rounded px-3 py-2 outline-none focus:border-primary">
            <option value="">Toàn bộ đơn hàng (Tất cả SP)</option>
            <c:forEach var="p" items="${products}">
              <option value="${p.id}">Áp dụng riêng: <c:out value="${p.name}"/></option>
            </c:forEach>
          </select>
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
          <th class="py-3 px-4">Phạm vi áp dụng</th>
          <th class="py-3 px-4">Điều kiện tối thiểu</th>
          <th class="py-3 px-4">Thời gian áp dụng</th>
          <th class="py-3 px-4 text-center">Trạng thái</th>
          <th class="py-3 px-4 text-center">Thao tác</th> <!-- Đã bổ sung cột Thao tác -->
        </tr>
        </thead>
        <tbody class="divide-y divide-gray-100 text-sm">

        <!-- Vòng lặp JSTL đổ dữ liệu thật từ DB -->
        <c:forEach var="coupon" items="${coupons}">
          <tr class="hover:bg-gray-50 transition-colors">
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

            <td class="py-3 px-4">
              <c:choose>
                <c:when test="${not empty coupon.productName}">
                  <span class="inline-flex items-center gap-1 px-2.5 py-1 bg-purple-50 text-purple-700 rounded-full text-xs font-semibold border border-purple-200">
                    <span class="material-symbols-outlined text-[14px]">inventory_2</span> <c:out value="${coupon.productName}"/>
                  </span>
                </c:when>
                <c:otherwise>
                  <span class="inline-flex items-center gap-1 px-2.5 py-1 bg-emerald-50 text-emerald-700 rounded-full text-xs font-semibold border border-emerald-200">
                    <span class="material-symbols-outlined text-[14px]">shopping_bag</span> Toàn bộ đơn
                  </span>
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

            <!-- NỘI DUNG CỘT THAO TÁC -->
            <td class="py-3 px-4 text-center">
              <c:choose>
                <c:when test="${coupon.status}">
                  <!-- TRẠNG THÁI ACTIVE: Sửa và Ẩn (Soft Delete) -->
                  <a href="${pageContext.request.contextPath}/admin/coupons/edit?id=${coupon.id}" class="text-blue-500 hover:text-blue-700 mx-1 transition-colors" title="Chỉnh sửa">
                    <span class="material-symbols-outlined text-xl">edit_square</span>
                  </a>
                  <a href="${pageContext.request.contextPath}/admin/coupons/toggle-status?id=${coupon.id}&action=hide" onclick="return confirm('Bạn có muốn khóa/ẩn mã ${coupon.code} này đi không?');" class="text-orange-500 hover:text-orange-700 mx-1 transition-colors" title="Khóa/Ẩn mã">
                    <span class="material-symbols-outlined text-xl">visibility_off</span>
                  </a>
                </c:when>

                <c:otherwise>
                  <!-- TRẠNG THÁI INACTIVE (ĐÃ ẨN): Khôi phục, Sửa và Xóa Vĩnh Viễn (Hard Delete) -->
                  <a href="${pageContext.request.contextPath}/admin/coupons/toggle-status?id=${coupon.id}&action=restore" class="text-green-500 hover:text-green-700 mx-1 transition-colors" title="Khôi phục mã">
                    <span class="material-symbols-outlined text-xl">restore</span>
                  </a>
                  <a href="${pageContext.request.contextPath}/admin/coupons/edit?id=${coupon.id}" class="text-blue-500 hover:text-blue-700 mx-1 transition-colors" title="Chỉnh sửa">
                    <span class="material-symbols-outlined text-xl">edit_square</span>
                  </a>
                  <a href="${pageContext.request.contextPath}/admin/coupons/hard-delete?id=${coupon.id}" onclick="return confirm('CẢNH BÁO MẤT DỮ LIỆU: Bạn có chắc muốn XÓA VĨNH VIỄN mã ${coupon.code} này? Hành động này không thể hoàn tác!');" class="text-red-500 hover:text-red-700 mx-1 transition-colors" title="Xóa vĩnh viễn">
                    <span class="material-symbols-outlined text-xl">delete_forever</span>
                  </a>
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