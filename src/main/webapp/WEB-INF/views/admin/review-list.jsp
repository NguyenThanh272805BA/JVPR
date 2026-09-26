<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Đánh Giá & Trợ Lý AI Phản Hồi - Fruitables Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
</head>
<body class="bg-background text-on-surface font-body-md flex h-screen overflow-hidden">

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />

<main class="flex-1 flex flex-col h-screen overflow-hidden">
  <!-- TOP HEADER -->
  <header class="h-20 bg-surface flex items-center justify-between px-6 shadow-sm z-10 flex-shrink-0 border-b border-surface-variant">
    <div class="flex items-center gap-3">
      <div class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center">
        <span class="material-symbols-outlined text-2xl">rate_review</span>
      </div>
      <div>
        <h1 class="text-lg font-bold text-on-surface flex items-center gap-2">
          Quản Lý Đánh Giá & AI Phản Hồi Tự Động
        </h1>
        <p class="text-xs text-on-surface-variant">Hệ thống phân tích cảm xúc (Sentiment Analysis) và phản hồi khách hàng thông minh</p>
      </div>
    </div>
    <div class="flex items-center gap-4">
      <span class="font-label-bold text-sm">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
      <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full" title="Đăng xuất">
        <span class="material-symbols-outlined">logout</span>
      </a>
    </div>
  </header>

  <!-- NỘI DUNG CUỘN -->
  <div class="flex-1 overflow-y-auto p-6 md:p-8 space-y-6">

    <!-- THẺ THỐNG KÊ NHANH -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <div class="bg-surface-container-lowest p-5 rounded-2xl border border-outline-variant shadow-sm flex items-center justify-between">
        <div>
          <span class="text-xs text-on-surface-variant font-medium">Tổng Đánh Giá</span>
          <div class="text-2xl font-black text-on-surface mt-1">${countAll}</div>
        </div>
        <div class="w-12 h-12 rounded-xl bg-slate-100 text-slate-700 flex items-center justify-center">
          <span class="material-symbols-outlined text-2xl">reviews</span>
        </div>
      </div>

      <div class="bg-surface-container-lowest p-5 rounded-2xl border border-outline-variant shadow-sm flex items-center justify-between">
        <div>
          <span class="text-xs text-emerald-600 font-bold uppercase tracking-wider">Tích Cực (Hài lòng)</span>
          <div class="text-2xl font-black text-emerald-700 mt-1">${countPositive}</div>
        </div>
        <div class="w-12 h-12 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
          <span class="material-symbols-outlined text-2xl">sentiment_very_satisfied</span>
        </div>
      </div>

      <div class="bg-surface-container-lowest p-5 rounded-2xl border border-amber-300 bg-amber-50/30 shadow-sm flex items-center justify-between">
        <div>
          <span class="text-xs text-amber-700 font-bold uppercase tracking-wider">Tiêu Cực (Cần CSKH)</span>
          <div class="text-2xl font-black text-amber-800 mt-1">${countNegative}</div>
        </div>
        <div class="w-12 h-12 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center">
          <span class="material-symbols-outlined text-2xl">sentiment_very_dissatisfied</span>
        </div>
      </div>

      <div class="bg-surface-container-lowest p-5 rounded-2xl border border-outline-variant shadow-sm flex items-center justify-between">
        <div>
          <span class="text-xs text-on-surface-variant font-medium">Trung Tính / Thắc Mắc</span>
          <div class="text-2xl font-black text-on-surface mt-1">${countNeutral}</div>
        </div>
        <div class="w-12 h-12 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center">
          <span class="material-symbols-outlined text-2xl">sentiment_neutral</span>
        </div>
      </div>
    </div>

    <!-- THANH CÔNG CỤ: FILTER TABS & TÌM KIẾM -->
    <div class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
      <!-- TABS LỌC CẢM XÚC -->
      <div class="flex items-center gap-2 flex-wrap">
        <a href="${pageContext.request.contextPath}/admin/reviews?sentiment=ALL&keyword=${keyword}" 
           class="px-4 py-2 rounded-xl text-xs font-bold transition-all ${selectedSentiment eq 'ALL' ? 'bg-primary text-white shadow-sm' : 'bg-surface-container hover:bg-surface-container-high text-on-surface-variant'}">
          Tất cả (${countAll})
        </a>
        <a href="${pageContext.request.contextPath}/admin/reviews?sentiment=NEGATIVE&keyword=${keyword}" 
           class="px-4 py-2 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${selectedSentiment eq 'NEGATIVE' ? 'bg-amber-600 text-white shadow-sm' : 'bg-amber-50 hover:bg-amber-100 text-amber-800'}">
          <span class="w-2 h-2 rounded-full bg-amber-500"></span>
          Tiêu cực & Cần CSKH (${countNegative})
        </a>
        <a href="${pageContext.request.contextPath}/admin/reviews?sentiment=POSITIVE&keyword=${keyword}" 
           class="px-4 py-2 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${selectedSentiment eq 'POSITIVE' ? 'bg-emerald-600 text-white shadow-sm' : 'bg-emerald-50 hover:bg-emerald-100 text-emerald-800'}">
          <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
          Tích cực (${countPositive})
        </a>
        <a href="${pageContext.request.contextPath}/admin/reviews?sentiment=NEUTRAL&keyword=${keyword}" 
           class="px-4 py-2 rounded-xl text-xs font-bold transition-all ${selectedSentiment eq 'NEUTRAL' ? 'bg-slate-700 text-white shadow-sm' : 'bg-surface-container hover:bg-surface-container-high text-on-surface-variant'}">
          Trung tính (${countNeutral})
        </a>
      </div>

      <!-- Ô TÌM KIẾM -->
      <form action="${pageContext.request.contextPath}/admin/reviews" method="GET" class="flex items-center gap-2">
        <input type="hidden" name="sentiment" value="${selectedSentiment}">
        <div class="relative w-full md:w-64">
          <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant text-sm">search</span>
          <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên quả, khách..." 
                 class="w-full pl-9 pr-3 py-2 text-xs rounded-xl bg-surface-container border border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary outline-none">
        </div>
        <button type="submit" class="px-3.5 py-2 bg-primary text-white rounded-xl text-xs font-bold hover:bg-primary-container hover:text-on-primary-container transition-all cursor-pointer">
          Lọc
        </button>
      </form>
    </div>

    <!-- BẢNG DANH SÁCH ĐÁNH GIÁ -->
    <div class="bg-surface-container-lowest rounded-2xl border border-outline-variant shadow-sm overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full text-left text-xs border-collapse">
          <thead class="bg-surface-container-low text-on-surface-variant uppercase font-label-bold tracking-wider border-b border-surface-variant">
            <tr>
              <th class="py-3.5 px-4 w-44">Khách hàng</th>
              <th class="py-3.5 px-4 w-48">Sản phẩm</th>
              <th class="py-3.5 px-4 w-52">Đánh giá & Ảnh</th>
              <th class="py-3.5 px-4 w-32 text-center">Cảm xúc AI</th>
              <th class="py-3.5 px-4">Phản hồi của Shop</th>
              <th class="py-3.5 px-4 w-36 text-center">Thao tác</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-surface-variant">
            <c:choose>
              <c:when test="${not empty reviews}">
                <c:forEach var="rv" items="${reviews}">
                  <tr class="hover:bg-surface-container-lowest/50 transition-colors ${rv.sentiment eq 'NEGATIVE' ? 'bg-amber-50/20' : ''}">
                    <!-- Khách hàng -->
                    <td class="py-3.5 px-4 align-top">
                      <div class="flex items-center gap-2.5">
                        <c:choose>
                          <c:when test="${not empty rv.avatarUrl}">
                            <img src="${rv.avatarUrl}" class="w-8 h-8 rounded-full object-cover border border-outline-variant">
                          </c:when>
                          <c:otherwise>
                            <div class="w-8 h-8 rounded-full bg-primary/10 text-primary font-bold flex items-center justify-center text-xs">
                              ${not empty rv.userName ? rv.userName.substring(0,1).toUpperCase() : 'U'}
                            </div>
                          </c:otherwise>
                        </c:choose>
                        <div>
                          <div class="font-bold text-on-surface"><c:out value="${rv.userName}"/></div>
                          <div class="text-[10px] text-on-surface-variant"><fmt:formatDate value="${rv.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                        </div>
                      </div>
                    </td>

                    <!-- Sản phẩm -->
                    <td class="py-3.5 px-4 align-top">
                      <div class="flex items-center gap-2">
                        <c:if test="${not empty rv.productImage}">
                          <img src="${rv.productImage}" class="w-10 h-10 rounded-lg object-cover border border-outline-variant flex-shrink-0">
                        </c:if>
                        <div>
                          <a href="${pageContext.request.contextPath}/product-detail?id=${rv.productId}" target="_blank" class="font-bold text-primary hover:underline line-clamp-2">
                            <c:out value="${rv.productName}"/>
                          </a>
                          <span class="text-[10px] text-on-surface-variant">Đơn #${rv.orderId}</span>
                        </div>
                      </div>
                    </td>

                    <!-- Đánh giá -->
                    <td class="py-3.5 px-4 align-top">
                      <div class="flex items-center gap-1 mb-1">
                        <c:forEach begin="1" end="5" var="i">
                          <span class="material-symbols-outlined text-[14px] ${i <= rv.rating ? 'text-amber-500' : 'text-gray-300'}" style="font-variation-settings: 'FILL' 1;">star</span>
                        </c:forEach>
                        <span class="text-[11px] font-bold ml-1 ${rv.rating le 2 ? 'text-amber-700' : 'text-emerald-700'}">${rv.rating} sao</span>
                      </div>
                      <p class="text-on-surface font-normal line-clamp-3 leading-relaxed">
                        <c:out value="${rv.comment}"/>
                      </p>
                      <c:if test="${not empty rv.imageUrl}">
                        <div class="mt-1.5">
                          <img src="${rv.imageUrl}" onclick="showPhoto('${rv.imageUrl}')" 
                               class="w-12 h-12 object-cover rounded-lg border border-outline-variant cursor-pointer hover:opacity-80 transition-opacity shadow-sm">
                        </div>
                      </c:if>
                    </td>

                    <!-- Cảm xúc AI -->
                    <td class="py-3.5 px-4 align-top text-center">
                      <c:choose>
                        <c:when test="${rv.sentiment eq 'NEGATIVE'}">
                          <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-amber-100 text-amber-800 border border-amber-300">
                            <span class="material-symbols-outlined text-xs">warning</span>
                            Tiêu cực
                          </span>
                        </c:when>
                        <c:when test="${rv.sentiment eq 'POSITIVE'}">
                          <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-300">
                            <span class="material-symbols-outlined text-xs">check_circle</span>
                            Tích cực
                          </span>
                        </c:when>
                        <c:otherwise>
                          <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-blue-50 text-blue-800 border border-blue-200">
                            <span class="material-symbols-outlined text-xs">info</span>
                            Trung tính
                          </span>
                        </c:otherwise>
                      </c:choose>
                    </td>

                    <!-- Phản hồi của Shop -->
                    <td class="py-3.5 px-4 align-top">
                      <c:choose>
                        <c:when test="${not empty rv.reply}">
                          <div class="p-2.5 rounded-xl ${rv.sentiment eq 'NEGATIVE' ? 'bg-amber-50/80 border border-amber-200' : 'bg-surface-container-low border border-surface-variant'}">
                            <div class="flex items-center justify-between mb-1">
                              <span class="font-bold text-[10px] uppercase tracking-wider ${rv.replyBy eq 'AI_AGENT' ? 'text-primary' : 'text-slate-700'}">
                                ${rv.replyBy eq 'AI_AGENT' ? '🤖 Trợ lý AI CSKH' : '👤 Quản trị viên'}
                              </span>
                              <c:if test="${not empty rv.replyAt}">
                                <span class="text-[10px] text-on-surface-variant">
                                  <fmt:formatDate value="${rv.replyAt}" pattern="dd/MM HH:mm"/>
                                </span>
                              </c:if>
                            </div>
                            <p class="text-xs text-on-surface leading-relaxed line-clamp-3">
                              <c:out value="${rv.reply}"/>
                            </p>
                          </div>
                        </c:when>
                        <c:otherwise>
                          <span class="text-on-surface-variant italic">Chưa có phản hồi</span>
                        </c:otherwise>
                      </c:choose>
                    </td>

                    <!-- Thao tác -->
                    <td class="py-3.5 px-4 align-top text-center">
                      <div class="flex flex-col gap-1.5 items-center">
                        <button type="button" onclick="openReplyModal(${rv.id}, '<c:out value="${rv.userName}"/>', `<c:out value="${rv.reply != null ? rv.reply : ''}"/>`)"
                                class="w-full px-2.5 py-1 bg-surface-container hover:bg-surface-container-high text-on-surface rounded-lg font-bold text-[11px] flex items-center justify-center gap-1 transition-all cursor-pointer">
                          <span class="material-symbols-outlined text-xs">edit_note</span>
                          Sửa phản hồi
                        </button>

                        <c:if test="${rv.userId != null}">
                          <a href="${pageContext.request.contextPath}/admin/chat?userId=${rv.userId}" 
                             class="w-full px-2.5 py-1 bg-primary/10 hover:bg-primary text-primary hover:text-white rounded-lg font-bold text-[11px] flex items-center justify-center gap-1 transition-all">
                            <span class="material-symbols-outlined text-xs">chat</span>
                            Chat với khách
                          </a>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/reviews" method="POST" class="w-full" onsubmit="return confirm('Bạn có muốn AI phân tích và tạo lại phản hồi cho đánh giá này?');">
                          <input type="hidden" name="action" value="regenerate_ai">
                          <input type="hidden" name="reviewId" value="${rv.id}">
                          <input type="hidden" name="sentiment" value="${selectedSentiment}">
                          <button type="submit" class="w-full px-2 py-0.5 text-on-surface-variant hover:text-primary text-[10px] flex items-center justify-center gap-1 cursor-pointer">
                            <span class="material-symbols-outlined text-[10px]">auto_awesome</span>
                            AI soạn lại
                          </button>
                        </form>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="6" class="py-12 text-center text-on-surface-variant">
                    <span class="material-symbols-outlined text-4xl mb-2 text-slate-300">inbox</span>
                    <p class="font-medium">Không tìm thấy đánh giá nào phù hợp với bộ lọc.</p>
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

      <!-- PHÂN TRANG -->
      <c:if test="${totalPages > 1}">
        <div class="px-6 py-4 bg-surface-container-low border-t border-surface-variant flex items-center justify-between">
          <span class="text-xs text-on-surface-variant">Trang ${currentPage} / ${totalPages}</span>
          <div class="flex items-center gap-1">
            <c:forEach begin="1" end="${totalPages}" var="p">
              <a href="${pageContext.request.contextPath}/admin/reviews?sentiment=${selectedSentiment}&keyword=${keyword}&page=${p}" 
                 class="w-8 h-8 rounded-lg text-xs font-bold flex items-center justify-center transition-all ${currentPage == p ? 'bg-primary text-white shadow-sm' : 'bg-surface-container hover:bg-surface-container-high text-on-surface'}">
                ${p}
              </a>
            </c:forEach>
          </div>
        </div>
      </c:if>
    </div>

  </div>
</main>

<!-- MODAL CHỈNH SỬA PHẢN HỒI -->
<div id="replyModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4">
  <div class="bg-surface-container-lowest w-full max-w-lg rounded-2xl shadow-2xl border border-outline-variant overflow-hidden" onclick="event.stopPropagation()">
    <div class="px-6 py-4 border-b border-surface-variant flex items-center justify-between">
      <h3 class="font-bold text-sm text-on-surface flex items-center gap-2">
        <span class="material-symbols-outlined text-primary">rate_review</span>
        Chỉnh sửa phản hồi của Cửa Hàng
      </h3>
      <button type="button" onclick="closeReplyModal()" class="p-1 rounded-full hover:bg-surface-container text-on-surface-variant cursor-pointer">
        <span class="material-symbols-outlined text-sm">close</span>
      </button>
    </div>

    <form action="${pageContext.request.contextPath}/admin/reviews" method="POST" class="p-6 space-y-4">
      <input type="hidden" name="action" value="update_reply">
      <input type="hidden" id="modalReviewId" name="reviewId" value="">
      <input type="hidden" name="sentiment" value="${selectedSentiment}">

      <div>
        <label class="block text-xs font-bold text-on-surface-variant mb-1">Khách hàng nhận phản hồi:</label>
        <div id="modalCustomerName" class="text-xs font-bold text-on-surface bg-surface-container p-2.5 rounded-xl border border-outline-variant"></div>
      </div>

      <div>
        <label class="block text-xs font-bold text-on-surface-variant mb-1">Nội dung phản hồi chính thức:</label>
        <textarea id="modalReplyContent" name="replyContent" rows="5" required
                  placeholder="Nhập nội dung phản hồi chân thành tới khách hàng..."
                  class="w-full text-xs p-3 rounded-xl bg-surface-container border border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary outline-none leading-relaxed"></textarea>
      </div>

      <div class="flex items-center justify-end gap-2 pt-2">
        <button type="button" onclick="closeReplyModal()" 
                class="px-4 py-2 rounded-xl text-xs font-bold bg-surface-container hover:bg-surface-container-high text-on-surface cursor-pointer">
          Hủy bỏ
        </button>
        <button type="submit" 
                class="px-5 py-2 rounded-xl text-xs font-bold bg-primary text-white hover:bg-primary-container hover:text-on-primary-container shadow-sm cursor-pointer">
          Lưu phản hồi
        </button>
      </div>
    </form>
  </div>
</div>

<!-- MODAL LIGHTBOX XEM ẢNH -->
<div id="photoModal" class="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm hidden flex items-center justify-center p-4 cursor-pointer" onclick="this.classList.add('hidden')">
  <div class="relative max-w-xl max-h-[85vh]">
    <img id="photoModalImg" src="" class="max-w-full max-h-[85vh] rounded-xl shadow-2xl object-contain">
  </div>
</div>

<script>
  function openReplyModal(id, customerName, currentReply) {
    document.getElementById('modalReviewId').value = id;
    document.getElementById('modalCustomerName').innerText = customerName;
    document.getElementById('modalReplyContent').value = currentReply || '';
    document.getElementById('replyModal').classList.remove('hidden');
  }

  function closeReplyModal() {
    document.getElementById('replyModal').classList.add('hidden');
  }

  function showPhoto(url) {
    document.getElementById('photoModalImg').src = url;
    document.getElementById('photoModal').classList.remove('hidden');
  }
</script>

</body>
</html>
