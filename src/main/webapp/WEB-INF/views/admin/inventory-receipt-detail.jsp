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

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />


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
