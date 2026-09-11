<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Bảo Hành & Khiếu Nại Hoa Quả - Fruitables Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-surface font-body-md flex h-screen overflow-hidden">

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />


<main class="flex-1 flex flex-col h-screen overflow-hidden">
  <header class="h-20 bg-surface flex items-center justify-between px-6 shadow-sm z-10 flex-shrink-0 border-b border-surface-variant">
    <h1 class="text-lg font-bold text-on-surface flex items-center gap-2">
      <span class="material-symbols-outlined text-primary">verified_user</span>
      Trung Tâm Tiếp Nhận & Giải Quyết Khiếu Nại Hoa Quả (Chính Sách 1 Đổi 1)
    </h1>
    <div class="flex items-center gap-4">
      <span class="font-label-bold text-sm">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
      <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full" title="Đăng xuất">
        <span class="material-symbols-outlined">logout</span>
      </a>
    </div>
  </header>

  <div class="flex-1 overflow-y-auto p-6 md:p-8 space-y-6">
    <div class="flex justify-between items-center flex-wrap gap-4">
      <div>
        <p class="text-xs text-on-surface-variant">Cam kết hoa quả tươi ngon: Xử lý đền bù Voucher 100% hoặc đổi trả hỏa tốc trong 2 giờ</p>
      </div>
      <div class="text-xs text-on-surface-variant bg-surface-container-lowest px-4 py-2 rounded-xl border border-outline-variant shadow-sm flex items-center gap-2">
        <span class="w-2 h-2 rounded-full bg-primary animate-pulse"></span>
        <span>Tổng số khiếu nại: <strong class="text-primary text-sm font-bold"><c:out value="${claims.size()}"/></strong></span>
      </div>
    </div>

    <!-- BẢNG DANH SÁCH KHIẾU NẠI -->
    <div class="bg-surface-container-lowest rounded-2xl border border-outline-variant shadow-sm overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full text-left text-xs border-collapse">
          <thead class="bg-surface-container-low text-on-surface-variant uppercase font-label-bold tracking-wider border-b border-surface-variant">
            <tr>
              <th class="py-3.5 px-4">Mã Đơn / Ngày gửi</th>
              <th class="py-3.5 px-4">Khách hàng</th>
              <th class="py-3.5 px-4">Sản phẩm lỗi</th>
              <th class="py-3.5 px-4">Ảnh chụp bằng chứng</th>
              <th class="py-3.5 px-4">Lý do & Ghi chú</th>
              <th class="py-3.5 px-4">Đề xuất giải quyết</th>
              <th class="py-3.5 px-4">Trạng thái</th>
              <th class="py-3.5 px-4 text-center">Thao tác</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-surface-variant">
            <c:forEach var="c" items="${claims}">
              <tr class="hover:bg-surface-container-low/50 transition-colors">
                <td class="py-4 px-4 whitespace-nowrap">
                  <span class="font-bold text-primary block">#${c.orderCode}</span>
                  <span class="text-[10px] text-on-surface-variant"><fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                </td>
                <td class="py-4 px-4 whitespace-nowrap">
                  <div class="font-semibold text-on-surface">${c.customerName}</div>
                  <div class="text-on-surface-variant text-[11px]">${c.customerPhone}</div>
                </td>
                <td class="py-4 px-4">
                  <span class="font-semibold text-slate-800 line-clamp-1 max-w-[140px]">${c.productName}</span>
                </td>
                <td class="py-4 px-4 whitespace-nowrap">
                  <c:if test="${not empty c.proofImageUrl}">
                    <a href="${c.proofImageUrl}" target="_blank" class="block w-12 h-12 rounded-xl overflow-hidden border border-outline-variant hover:scale-105 transition-transform" title="Bấm xem ảnh lớn">
                      <img src="${c.proofImageUrl}" alt="Proof" class="w-full h-full object-cover">
                    </a>
                  </c:if>
                </td>
                <td class="py-4 px-4 max-w-[200px]">
                  <div class="font-semibold text-rose-700 line-clamp-1">${c.reason}</div>
                  <c:if test="${not empty c.customerNote}">
                    <div class="text-[11px] text-slate-500 italic line-clamp-2 mt-0.5">"${c.customerNote}"</div>
                  </c:if>
                </td>
                <td class="py-4 px-4 whitespace-nowrap">
                  <c:choose>
                    <c:when test="${c.claimSolution == 'REFUND_VOUCHER'}">
                      <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-amber-100 text-amber-800">🎟️ Voucher 100%</span>
                    </c:when>
                    <c:otherwise>
                      <span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-sky-100 text-sky-800">📦 Đổi quả mới</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="py-4 px-4 whitespace-nowrap">
                  <c:choose>
                    <c:when test="${c.status == 'APPROVED'}">
                      <span class="px-2.5 py-1 rounded-full text-[11px] font-bold bg-emerald-100 text-emerald-800">Đã duyệt</span>
                    </c:when>
                    <c:when test="${c.status == 'REJECTED'}">
                      <span class="px-2.5 py-1 rounded-full text-[11px] font-bold bg-rose-100 text-rose-800">Từ chối</span>
                    </c:when>
                    <c:otherwise>
                      <span class="px-2.5 py-1 rounded-full text-[11px] font-bold bg-amber-100 text-amber-800 animate-pulse">Chờ duyệt</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="py-4 px-4 text-center whitespace-nowrap">
                  <c:if test="${c.status == 'PENDING'}">
                    <div class="flex items-center justify-center gap-1.5">
                      <!-- Duyệt -->
                      <form action="${pageContext.request.contextPath}/admin/claims" method="POST" class="inline" onsubmit="return confirm('Bạn đồng ý phê duyệt đền bù cho yêu cầu này?');">
                        <input type="hidden" name="claimId" value="${c.id}">
                        <input type="hidden" name="action" value="APPROVE">
                        <button type="submit" class="px-2.5 py-1 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg font-bold text-[11px] flex items-center gap-1 shadow-xs">
                          <span class="material-symbols-outlined text-[13px]">check</span> Duyệt đền bù
                        </button>
                      </form>

                      <!-- Từ chối -->
                      <form action="${pageContext.request.contextPath}/admin/claims" method="POST" class="inline" onsubmit="return confirm('Bạn muốn từ chối yêu cầu này?');">
                        <input type="hidden" name="claimId" value="${c.id}">
                        <input type="hidden" name="action" value="REJECT">
                        <button type="submit" class="px-2.5 py-1 bg-rose-100 hover:bg-rose-200 text-rose-700 rounded-lg font-bold text-[11px] flex items-center gap-1">
                          <span class="material-symbols-outlined text-[13px]">close</span> Từ chối
                        </button>
                      </form>
                    </div>
                  </c:if>
                  <c:if test="${c.status != 'PENDING'}">
                    <c:if test="${not empty c.compensationVoucher}">
                      <span class="font-mono text-[10px] text-emerald-700 block font-bold">${c.compensationVoucher}</span>
                    </c:if>
                    <span class="text-[10px] text-slate-400 italic">Đã xử lý</span>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty claims}">
              <tr>
                <td colspan="8" class="text-center py-10 text-on-surface-variant italic">
                  Hiện chưa có khiếu nại hoa quả nào cần xử lý.
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</main>
</body>
</html>
