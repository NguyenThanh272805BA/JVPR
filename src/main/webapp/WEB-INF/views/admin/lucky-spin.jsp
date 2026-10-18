<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Quản Lý Vòng Quay May Mắn - Fruitables Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body class="bg-[#f8fafc] text-on-surface font-body-md flex h-screen overflow-hidden">

  <!-- SVG SPRITE -->
  <jsp:include page="/WEB-INF/views/components/svg-icons.jsp" />

  <!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
  <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />

  <!-- MAIN CONTENT -->
  <main class="flex-1 flex flex-col h-screen overflow-hidden">
    <!-- Header -->
    <header class="h-20 bg-surface flex items-center justify-between px-6 shadow-sm z-10 flex-shrink-0 border-b border-surface-variant">
      <div>
        <div class="flex items-center gap-2">
          <h1 class="font-headline-md text-lg font-bold text-on-surface">Quản Lý Vòng Quay May Mắn & Cấu Hình Giải Thưởng</h1>
          <span class="px-2.5 py-0.5 rounded-full bg-amber-100 text-amber-800 text-[11px] font-bold border border-amber-300 flex items-center gap-1">
            <span class="w-2 h-2 rounded-full bg-amber-500 animate-ping"></span> Mini Game Gamification
          </span>
        </div>
        <p class="text-xs text-on-surface-variant">Quản lý cơ cấu các ô bánh xe, xác suất trúng thưởng, quota ngân sách và theo dõi lịch sử quay của khách hàng</p>
      </div>

      <div class="flex items-center gap-3">
        <button type="button" onclick="openGrantSpinsModal()"
                class="flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-amber-50 hover:bg-amber-100 text-amber-800 text-xs font-bold transition-all shadow-xs border border-amber-200 cursor-pointer">
          <svg class="w-4 h-4 text-amber-700"><use href="#icon-prize-spin"/></svg>
          <span>Tặng Lượt Cho Khách</span>
        </button>
        <button type="button" onclick="openPrizeModal(null)"
                class="flex items-center gap-1.5 px-4 py-2 rounded-xl bg-primary hover:bg-primary-container text-white text-xs font-bold transition-all shadow-sm cursor-pointer">
          <span class="material-symbols-outlined text-base">add_circle</span>
          <span>Thêm Giải Thưởng Mới</span>
        </button>
        <div class="h-8 w-px bg-slate-200"></div>
        <span class="font-label-bold text-sm text-on-surface">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
      </div>
    </header>

    <!-- Workspace Container -->
    <div class="flex-1 overflow-y-auto p-6 space-y-6">

      <!-- Thông báo kết quả thao tác -->
      <c:if test="${not empty sessionScope.ADMIN_FLASH_MSG}">
        <div class="p-4 rounded-2xl bg-emerald-50 border border-emerald-300 text-emerald-800 text-xs font-bold flex items-center justify-between shadow-xs">
          <div class="flex items-center gap-2">
            <span class="material-symbols-outlined text-lg">check_circle</span>
            <span>${sessionScope.ADMIN_FLASH_MSG}</span>
          </div>
          <button type="button" onclick="this.parentElement.remove()" class="text-emerald-700 hover:text-emerald-900">
            <span class="material-symbols-outlined text-sm">close</span>
          </button>
        </div>
        <c:remove var="ADMIN_FLASH_MSG" scope="session"/>
      </c:if>

      <c:if test="${not empty sessionScope.ADMIN_FLASH_ERR}">
        <div class="p-4 rounded-2xl bg-rose-50 border border-rose-300 text-rose-800 text-xs font-bold flex items-center justify-between shadow-xs">
          <div class="flex items-center gap-2">
            <span class="material-symbols-outlined text-lg">error</span>
            <span>${sessionScope.ADMIN_FLASH_ERR}</span>
          </div>
          <button type="button" onclick="this.parentElement.remove()" class="text-rose-700 hover:text-rose-900">
            <span class="material-symbols-outlined text-sm">close</span>
          </button>
        </div>
        <c:remove var="ADMIN_FLASH_ERR" scope="session"/>
      </c:if>

      <!-- 4 THẺ CHỈ SỐ KPI VÒNG QUAY -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <!-- 1. Tổng lượt quay -->
        <div class="bg-surface p-5 rounded-2xl border border-outline-variant shadow-sm flex items-center justify-between">
          <div>
            <span class="text-xs font-bold uppercase tracking-wider text-slate-400 block mb-1">Tổng Lượt Đã Quay</span>
            <span class="text-2xl font-black text-on-surface font-headline-md tracking-tight">
              <fmt:formatNumber value="${stats.totalSpins}" type="number"/>
            </span>
            <span class="text-[11px] text-slate-500 block mt-1">Lượt tương tác khách hàng</span>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center">
            <svg class="w-6 h-6"><use href="#icon-lucky-spin"/></svg>
          </div>
        </div>

        <!-- 2. Quà đã trao -->
        <div class="bg-surface p-5 rounded-2xl border border-outline-variant shadow-sm flex items-center justify-between">
          <div>
            <span class="text-xs font-bold uppercase tracking-wider text-slate-400 block mb-1">Quà Tặng Đã Trao</span>
            <span class="text-2xl font-black text-emerald-600 font-headline-md tracking-tight">
              <fmt:formatNumber value="${stats.totalWonPrizes}" type="number"/>
            </span>
            <span class="text-[11px] text-emerald-700 block mt-1">Mã voucher & quà đã kích hoạt</span>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
            <svg class="w-6 h-6"><use href="#icon-prize-gift"/></svg>
          </div>
        </div>

        <!-- 3. Quà đã dùng thanh toán -->
        <div class="bg-surface p-5 rounded-2xl border border-outline-variant shadow-sm flex items-center justify-between">
          <div>
            <span class="text-xs font-bold uppercase tracking-wider text-slate-400 block mb-1">Đã Dùng Mua Hàng</span>
            <span class="text-2xl font-black text-primary font-headline-md tracking-tight">
              <fmt:formatNumber value="${stats.totalUsedPrizes}" type="number"/>
            </span>
            <span class="text-[11px] text-primary block mt-1">Thúc đẩy đơn hàng thành công</span>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center">
            <svg class="w-6 h-6"><use href="#icon-prize-voucher"/></svg>
          </div>
        </div>

        <!-- 4. Tỷ lệ quay trúng -->
        <div class="bg-surface p-5 rounded-2xl border border-outline-variant shadow-sm flex items-center justify-between">
          <div>
            <span class="text-xs font-bold uppercase tracking-wider text-slate-400 block mb-1">Tỷ Lệ Trúng Quà</span>
            <span class="text-2xl font-black text-amber-600 font-headline-md tracking-tight">
              ${stats.winRate}%
            </span>
            <span class="text-[11px] text-slate-500 block mt-1">Cân bằng ROI & chuyển đổi</span>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center">
            <svg class="w-6 h-6"><use href="#icon-prize-star"/></svg>
          </div>
        </div>
      </div>

      <!-- BẢNG CẤU HÌNH CÁC Ô TRÊN BÁNH XE QUAY -->
      <div class="bg-surface rounded-2xl border border-outline-variant shadow-sm overflow-hidden">
        <div class="p-5 border-b border-surface-variant flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div>
            <h2 class="font-headline-sm text-base font-bold text-on-surface">Cấu Hình Danh Sách Giải Thưởng Bánh Xe</h2>
            <p class="text-xs text-on-surface-variant mt-0.5">Các ô giải thưởng sẽ được hiển thị và quay trên trang người dùng theo thứ tự sắp xếp</p>
          </div>
          <span class="text-xs font-bold px-3 py-1 bg-surface-container rounded-lg border border-outline-variant">
            Tổng: ${prizes.size()} giải thưởng
          </span>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full text-left text-xs">
            <thead class="bg-surface-container-low text-on-surface-variant border-b border-surface-variant font-bold uppercase text-[10px] tracking-wider">
              <tr>
                <th class="py-3.5 px-4 w-12 text-center">STT</th>
                <th class="py-3.5 px-4">Tên Phần Thưởng & Nhận Diện Ô</th>
                <th class="py-3.5 px-4">Phân Loại Giải</th>
                <th class="py-3.5 px-4">Mức Giảm / Đơn Tối Thiểu</th>
                <th class="py-3.5 px-4">Xác Suất (%)</th>
                <th class="py-3.5 px-4">Kho Quà (Còn / Tổng)</th>
                <th class="py-3.5 px-4 text-center">Trạng Thái</th>
                <th class="py-3.5 px-4 text-right">Thao Tác</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-surface-variant">
              <c:forEach var="p" items="${prizes}" varStatus="status">
                <tr class="hover:bg-surface-container-low/60 transition-colors">
                  <td class="py-3 px-4 text-center font-bold text-slate-400">${p.displayOrder}</td>
                  <td class="py-3 px-4">
                    <div class="flex items-center gap-3">
                      <!-- Màu preview ô bánh xe -->
                      <div class="prize-badge-color w-9 h-9 rounded-xl flex items-center justify-center font-bold text-white shadow-xs border border-white"
                           data-bg="${p.colorBg}" data-color="${p.colorText}">
                        <c:choose>
                          <c:when test="${p.iconType == 'shipping'}"><svg class="w-4 h-4"><use href="#icon-prize-shipping"/></svg></c:when>
                          <c:when test="${p.iconType == 'gift'}"><svg class="w-4 h-4"><use href="#icon-prize-gift"/></svg></c:when>
                          <c:when test="${p.iconType == 'star'}"><svg class="w-4 h-4"><use href="#icon-prize-star"/></svg></c:when>
                          <c:when test="${p.iconType == 'spin'}"><svg class="w-4 h-4"><use href="#icon-prize-spin"/></svg></c:when>
                          <c:when test="${p.iconType == 'luck'}"><svg class="w-4 h-4"><use href="#icon-prize-luck"/></svg></c:when>
                          <c:otherwise><svg class="w-4 h-4"><use href="#icon-prize-voucher"/></svg></c:otherwise>
                        </c:choose>
                      </div>
                      <div>
                        <span class="font-bold text-on-surface block text-xs"><c:out value="${p.name}"/></span>
                        <span class="text-[10px] text-slate-400">Mã màu: ${p.colorBg}</span>
                      </div>
                    </div>
                  </td>
                  <td class="py-3 px-4">
                    <span class="px-2 py-0.5 rounded-full text-[10px] font-bold 
                      ${p.prizeType == 'FREESHIP' ? 'bg-emerald-100 text-emerald-800' :
                        (p.prizeType == 'DISCOUNT_AMOUNT' ? 'bg-primary/10 text-primary' :
                        (p.prizeType == 'DISCOUNT_PERCENT' ? 'bg-teal-100 text-teal-800' :
                        (p.prizeType == 'GIFT_PRODUCT' ? 'bg-purple-100 text-purple-800' :
                        (p.prizeType == 'EXTRA_SPIN' ? 'bg-amber-100 text-amber-800' : 'bg-slate-100 text-slate-700'))))}">
                      <c:out value="${p.badgeDescription}"/>
                    </span>
                  </td>
                  <td class="py-3 px-4">
                    <div class="font-medium text-slate-700">
                      <c:choose>
                        <c:when test="${p.prizeType == 'DISCOUNT_AMOUNT'}">
                          Giảm <strong><fmt:formatNumber value="${p.discountValue}" type="number"/>₫</strong>
                        </c:when>
                        <c:when test="${p.prizeType == 'DISCOUNT_PERCENT'}">
                          Giảm <strong>${p.discountValue.intValue()}%</strong>
                        </c:when>
                        <c:when test="${p.prizeType == 'FREESHIP'}">
                          Tối đa <strong><fmt:formatNumber value="${p.discountValue}" type="number"/>₫</strong>
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                      </c:choose>
                    </div>
                    <c:if test="${p.minOrderValue > 0}">
                      <span class="text-[10px] text-slate-400 block">Đơn từ: <fmt:formatNumber value="${p.minOrderValue}" type="number"/>₫</span>
                    </c:if>
                  </td>
                  <td class="py-3 px-4">
                    <div class="flex items-center gap-2">
                      <div class="w-16 bg-slate-200 h-2 rounded-full overflow-hidden">
                        <div class="prob-progress-bar bg-amber-500 h-full rounded-full" data-width="${p.probability * 2.5}%"></div>
                      </div>
                      <span class="font-mono font-bold text-slate-800">${p.probability}%</span>
                    </div>
                  </td>
                  <td class="py-3 px-4">
                    <c:choose>
                      <c:when test="${p.quantityLimit > 0}">
                        <div class="flex items-center gap-1.5">
                          <span class="font-bold ${p.quantityRemain <= 5 ? 'text-rose-600 font-black' : 'text-slate-800'}">
                            ${p.quantityRemain}
                          </span>
                          <span class="text-slate-400">/ ${p.quantityLimit}</span>
                          <button type="button"
                                  class="btn-reset-quota text-[10px] text-primary hover:underline ml-1 font-bold cursor-pointer"
                                  title="Đặt lại số lượng"
                                  data-id="${p.id}"
                                  data-name="<c:out value='${p.name}'/>"
                                  data-quota="${p.quantityLimit}">
                            [Nạp lại]
                          </button>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <span class="text-emerald-700 font-bold text-[11px]">Không giới hạn (∞)</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td class="py-3 px-4 text-center">
                    <form action="${pageContext.request.contextPath}/admin/lucky-spin" method="POST" class="inline-block">
                      <input type="hidden" name="action" value="toggle_status">
                      <input type="hidden" name="id" value="${p.id}">
                      <input type="hidden" name="status" value="${!p.status}">
                      <button type="submit" class="px-2.5 py-1 rounded-full text-[10px] font-bold transition-all cursor-pointer ${p.status ? 'bg-emerald-100 text-emerald-800 hover:bg-emerald-200' : 'bg-slate-200 text-slate-600 hover:bg-slate-300'}">
                        ${p.status ? 'Đang bật' : 'Đã tắt'}
                      </button>
                    </form>
                  </td>
                  <td class="py-3 px-4 text-right">
                    <div class="inline-flex items-center gap-1.5">
                      <button type="button"
                              class="btn-edit-prize p-1.5 rounded-lg text-slate-500 hover:text-primary hover:bg-surface-container transition-colors cursor-pointer"
                              title="Chỉnh sửa"
                              data-id="${p.id}"
                              data-name="<c:out value='${p.name}'/>"
                              data-type="${p.prizeType}"
                              data-discount="${p.discountValue}"
                              data-min-order="${p.minOrderValue}"
                              data-prob="${p.probability}"
                              data-limit="${p.quantityLimit}"
                              data-bg="${p.colorBg}"
                              data-text="${p.colorText}"
                              data-icon="${p.iconType}"
                              data-order="${p.displayOrder}"
                              data-status="${p.status}">
                        <span class="material-symbols-outlined text-sm">edit</span>
                      </button>
                      <form action="${pageContext.request.contextPath}/admin/lucky-spin" method="POST" onsubmit="return confirm('Bạn có chắc muốn xóa giải thưởng này?');" class="inline-block">
                        <input type="hidden" name="action" value="delete_prize">
                        <input type="hidden" name="id" value="${p.id}">
                        <button type="submit" class="p-1.5 rounded-lg text-slate-500 hover:text-rose-600 hover:bg-rose-50 transition-colors cursor-pointer" title="Xóa">
                          <span class="material-symbols-outlined text-sm">delete</span>
                        </button>
                      </form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>

      <!-- BẢNG LỊCH SỬ QUAY THƯỞNG GẦN ĐÂY CỦA KHÁCH HÀNG -->
      <div class="bg-surface rounded-2xl border border-outline-variant shadow-sm overflow-hidden">
        <div class="p-5 border-b border-surface-variant flex items-center justify-between">
          <div>
            <h2 class="font-headline-sm text-base font-bold text-on-surface">Lịch Sử Quay Thưởng Gần Đây</h2>
            <p class="text-xs text-on-surface-variant mt-0.5">Theo dõi thời gian thực các giải thưởng khách hàng vừa quay trúng</p>
          </div>
          <button type="button" onclick="location.reload()" class="text-xs text-primary font-bold hover:underline flex items-center gap-1">
            <span class="material-symbols-outlined text-sm">refresh</span> Làm mới
          </button>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full text-left text-xs">
            <thead class="bg-surface-container-low text-on-surface-variant border-b border-surface-variant font-bold uppercase text-[10px] tracking-wider">
              <tr>
                <th class="py-3 px-4">Thời Gian</th>
                <th class="py-3 px-4">Khách Hàng</th>
                <th class="py-3 px-4">Giải Thưởng Trúng</th>
                <th class="py-3 px-4">Mã Voucher Tạo Ra</th>
                <th class="py-3 px-4 text-center">Trạng Thái Sử Dụng</th>
                <th class="py-3 px-4">Hạn Sử Dụng</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-surface-variant">
              <c:forEach var="h" items="${history}">
                <tr class="hover:bg-surface-container-low/60 transition-colors">
                  <td class="py-2.5 px-4 font-mono text-slate-500">
                    <fmt:formatDate value="${h.createdAt}" pattern="HH:mm dd/MM/yyyy"/>
                  </td>
                  <td class="py-2.5 px-4">
                    <div class="font-bold text-slate-800">${h.userName != null ? h.userName : 'Khách vãng lai'}</div>
                    <span class="text-[10px] text-slate-400">${h.userPhone != null ? h.userPhone : 'ID: ' += h.userId}</span>
                  </td>
                  <td class="py-2.5 px-4 font-bold text-emerald-700">
                    <c:out value="${h.prizeName}"/>
                  </td>
                  <td class="py-2.5 px-4 font-mono font-bold text-primary">
                    <c:out value="${not empty h.rewardCode ? h.rewardCode : '—'}"/>
                  </td>
                  <td class="py-2.5 px-4 text-center">
                    <span class="px-2 py-0.5 rounded-full text-[10px] font-bold 
                      ${h.isUsed ? 'bg-slate-200 text-slate-700' : (h.expired ? 'bg-rose-100 text-rose-700' : 'bg-emerald-100 text-emerald-800')}">
                      <c:out value="${h.statusBadge}"/>
                    </span>
                  </td>
                  <td class="py-2.5 px-4 text-slate-500">
                    <fmt:formatDate value="${h.expiredAt}" pattern="dd/MM/yyyy"/>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty history}">
                <tr>
                  <td colspan="6" class="py-8 text-center text-slate-400">Chưa có lượt quay nào được ghi nhận.</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>

    </div>
  </main>

  <!-- ============================================================ -->
  <!-- MODAL: THÊM / CHỈNH SỬA GIẢI THƯỞNG TRÊN BÁNH XE             -->
  <!-- ============================================================ -->
  <div id="prize-modal" class="fixed inset-0 z-[200] hidden items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4">
    <div class="bg-white rounded-3xl max-w-lg w-full p-6 shadow-2xl border border-slate-200 relative max-h-[90vh] overflow-y-auto">
      <button type="button" onclick="closePrizeModal()" class="absolute top-4 right-4 text-slate-400 hover:text-slate-600 p-1.5 rounded-full hover:bg-slate-100">
        <span class="material-symbols-outlined text-lg">close</span>
      </button>

      <div class="flex items-center gap-3 mb-5">
        <div class="w-10 h-10 rounded-2xl bg-primary/10 text-primary flex items-center justify-center font-bold">
          <svg class="w-5 h-5"><use href="#icon-lucky-spin"/></svg>
        </div>
        <div>
          <h3 class="font-headline-sm text-lg font-bold text-slate-900" id="modal-form-title">Thêm Giải Thưởng Mới</h3>
          <p class="text-xs text-slate-500">Cấu hình ô bánh xe, mức giảm giá và xác suất trúng</p>
        </div>
      </div>

      <form action="${pageContext.request.contextPath}/admin/lucky-spin" method="POST" class="space-y-4">
        <input type="hidden" name="action" value="save_prize">
        <input type="hidden" name="id" id="prize-id" value="0">

        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Tên giải thưởng (*)</label>
          <input type="text" name="name" id="prize-name" required placeholder="Ví dụ: Voucher 20.000₫"
                 class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-1 focus:ring-primary focus:border-primary outline-none">
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">Loại phần thưởng</label>
            <select name="prizeType" id="prize-type" class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-1 focus:ring-primary outline-none">
              <option value="DISCOUNT_AMOUNT">Voucher giảm tiền mặt (VNĐ)</option>
              <option value="DISCOUNT_PERCENT">Voucher giảm % đơn hàng</option>
              <option value="FREESHIP">Miễn phí giao hàng (Freeship)</option>
              <option value="GIFT_PRODUCT">Quà tặng hoa quả tươi</option>
              <option value="EXTRA_SPIN">Thêm lượt quay thưởng (+1)</option>
              <option value="NO_PRIZE">Không trúng (Chúc may mắn)</option>
            </select>
          </div>
          <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">Xác suất trúng (%)</label>
            <input type="number" step="0.1" name="probability" id="prize-probability" required value="10.0"
                   class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-1 focus:ring-primary outline-none">
          </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">Giá trị giảm giá (VNĐ hoặc %)</label>
            <input type="number" name="discountValue" id="prize-discount-value" value="0"
                   class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-1 focus:ring-primary outline-none">
          </div>
          <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">Đơn tối thiểu áp dụng (VNĐ)</label>
            <input type="number" name="minOrderValue" id="prize-min-order" value="0"
                   class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-1 focus:ring-primary outline-none">
          </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">Giới hạn số lượng (-1: Vô hạn)</label>
            <input type="number" name="quantityLimit" id="prize-quantity-limit" value="-1"
                   class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-1 focus:ring-primary outline-none">
          </div>
          <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">Thứ tự hiển thị (1-8)</label>
            <input type="number" name="displayOrder" id="prize-display-order" value="1"
                   class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-1 focus:ring-primary outline-none">
          </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">Màu nền ô</label>
            <input type="color" name="colorBg" id="prize-color-bg" value="#10B981" class="w-full h-9 rounded-xl border border-slate-300 p-1 cursor-pointer">
          </div>
          <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">Màu chữ</label>
            <input type="color" name="colorText" id="prize-color-text" value="#FFFFFF" class="w-full h-9 rounded-xl border border-slate-300 p-1 cursor-pointer">
          </div>
          <div>
            <label class="block text-xs font-bold text-slate-700 mb-1">Loại Icon</label>
            <select name="iconType" id="prize-icon-type" class="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs focus:ring-1 focus:ring-primary outline-none">
              <option value="voucher">Voucher</option>
              <option value="shipping">Xe Freeship</option>
              <option value="gift">Hộp quà</option>
              <option value="star">Ngôi sao VIP</option>
              <option value="spin">Lượt quay</option>
              <option value="luck">Mặt cười</option>
            </select>
          </div>
        </div>

        <div class="pt-4 border-t border-slate-200 flex items-center justify-end gap-2.5">
          <button type="button" onclick="closePrizeModal()" class="px-4 py-2 rounded-xl border border-slate-300 text-slate-600 text-xs font-bold hover:bg-slate-50 transition-colors">
            Hủy
          </button>
          <button type="submit" class="px-5 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primary-container transition-colors shadow-sm">
            Lưu Giải Thưởng
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- ============================================================ -->
  <!-- MODAL: NẠP LẠI KHO GIẢI THƯỞNG (RESET QUOTA)                 -->
  <!-- ============================================================ -->
  <div id="quota-modal" class="fixed inset-0 z-[200] hidden items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4">
    <div class="bg-white rounded-3xl max-w-sm w-full p-6 shadow-2xl border border-slate-200 relative">
      <h3 class="font-bold text-base text-slate-900 mb-1">Nạp Thêm Kho Quà</h3>
      <p class="text-xs text-slate-500 mb-4" id="quota-modal-prize-name">Giải thưởng</p>

      <form action="${pageContext.request.contextPath}/admin/lucky-spin" method="POST" class="space-y-4">
        <input type="hidden" name="action" value="reset_quota">
        <input type="hidden" name="id" id="quota-prize-id" value="0">

        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Số lượng nạp mới</label>
          <input type="number" name="quota" id="quota-amount" required value="20" min="1"
                 class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-1 focus:ring-primary outline-none">
        </div>

        <div class="flex items-center justify-end gap-2">
          <button type="button" onclick="document.getElementById('quota-modal').classList.add('hidden')" class="px-4 py-2 rounded-xl border border-slate-300 text-slate-600 text-xs font-bold">
            Hủy
          </button>
          <button type="submit" class="px-5 py-2 rounded-xl bg-primary text-white text-xs font-bold">
            Cập nhật kho
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- ============================================================ -->
  <!-- MODAL: TẶNG LƯỢT QUAY CHO KHÁCH HÀNG                         -->
  <!-- ============================================================ -->
  <div id="grant-modal" class="fixed inset-0 z-[200] hidden items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4">
    <div class="bg-white rounded-3xl max-w-sm w-full p-6 shadow-2xl border border-slate-200 relative">
      <div class="flex items-center gap-2.5 mb-3">
        <div class="w-8 h-8 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center">
          <svg class="w-4 h-4"><use href="#icon-prize-spin"/></svg>
        </div>
        <h3 class="font-bold text-base text-slate-900">Tặng Lượt Quay Cho Khách</h3>
      </div>
      <p class="text-xs text-slate-500 mb-4">Nhập Số điện thoại, Email hoặc ID tài khoản khách hàng để tặng lượt quay tri ân</p>

      <form action="${pageContext.request.contextPath}/admin/lucky-spin" method="POST" class="space-y-4">
        <input type="hidden" name="action" value="grant_spins">

        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Thông tin khách hàng (*)</label>
          <input type="text" name="userIdentifier" required placeholder="Nhập SĐT hoặc Email khách..."
                 class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-1 focus:ring-primary outline-none">
        </div>

        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Số lượt tặng thêm (*)</label>
          <input type="number" name="spinAmount" required value="3" min="1" max="100"
                 class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs focus:ring-1 focus:ring-primary outline-none">
        </div>

        <div class="flex items-center justify-end gap-2">
          <button type="button" onclick="document.getElementById('grant-modal').classList.add('hidden')" class="px-4 py-2 rounded-xl border border-slate-300 text-slate-600 text-xs font-bold">
            Hủy
          </button>
          <button type="submit" class="px-5 py-2 rounded-xl bg-primary text-white text-xs font-bold">
            Xác nhận tặng
          </button>
        </div>
      </form>
    </div>
  </div>

  <script>
    function openPrizeModal(p) {
      document.getElementById('prize-id').value = p ? p.id : '0';
      document.getElementById('modal-form-title').innerText = p ? 'Chỉnh Sửa Giải Thưởng' : 'Thêm Giải Thưởng Mới';
      document.getElementById('prize-name').value = p ? p.name : '';
      document.getElementById('prize-type').value = p ? p.type : 'DISCOUNT_AMOUNT';
      document.getElementById('prize-discount-value').value = p ? p.discount : 0;
      document.getElementById('prize-min-order').value = p ? p.minOrder : 0;
      document.getElementById('prize-probability').value = p ? p.probability : 10.0;
      document.getElementById('prize-quantity-limit').value = p ? p.quantityLimit : -1;
      document.getElementById('prize-color-bg').value = p ? p.colorBg : '#10B981';
      document.getElementById('prize-color-text').value = p ? p.colorText : '#FFFFFF';
      document.getElementById('prize-icon-type').value = p ? p.iconType : 'voucher';
      document.getElementById('prize-display-order').value = p ? p.displayOrder : 1;

      document.getElementById('prize-modal').classList.remove('hidden');
      document.getElementById('prize-modal').classList.add('flex');
    }

    function editPrize(id, name, type, discount, minOrder, prob, limit, bg, text, icon, order, status) {
      openPrizeModal({
        id: id,
        name: name,
        type: type,
        discount: discount,
        minOrder: minOrder,
        probability: prob,
        quantityLimit: limit,
        colorBg: bg,
        colorText: text,
        iconType: icon,
        displayOrder: order,
        status: status
      });
    }

    function closePrizeModal() {
      document.getElementById('prize-modal').classList.remove('flex');
      document.getElementById('prize-modal').classList.add('hidden');
    }

    function openResetQuotaModal(id, name, limit) {
      document.getElementById('quota-prize-id').value = id;
      document.getElementById('quota-modal-prize-name').innerText = 'Giải: ' + name;
      document.getElementById('quota-amount').value = limit > 0 ? limit : 20;
      document.getElementById('quota-modal').classList.remove('hidden');
      document.getElementById('quota-modal').classList.add('flex');
    }

    function openGrantSpinsModal() {
      document.getElementById('grant-modal').classList.remove('hidden');
      document.getElementById('grant-modal').classList.add('flex');
    }

    // Render dynamic colors and progress bars without inline CSS errors
    document.querySelectorAll('.prize-badge-color').forEach(function(el) {
      if (el.dataset.bg) el.style.backgroundColor = el.dataset.bg;
      if (el.dataset.color) el.style.color = el.dataset.color;
    });
    document.querySelectorAll('.prob-progress-bar').forEach(function(el) {
      if (el.dataset.width) el.style.width = el.dataset.width;
    });

    // Handle Edit Prize clicks safely via dataset
    document.querySelectorAll('.btn-edit-prize').forEach(function(btn) {
      btn.addEventListener('click', function() {
        var d = this.dataset;
        editPrize(
          parseInt(d.id, 10),
          d.name,
          d.type,
          parseFloat(d.discount),
          parseFloat(d.minOrder),
          parseFloat(d.prob),
          parseInt(d.limit, 10),
          d.bg,
          d.text,
          d.icon,
          parseInt(d.order, 10),
          d.status === 'true'
        );
      });
    });

    // Handle Reset Quota clicks safely via dataset
    document.querySelectorAll('.btn-reset-quota').forEach(function(btn) {
      btn.addEventListener('click', function() {
        var d = this.dataset;
        openResetQuotaModal(parseInt(d.id, 10), d.name, parseInt(d.quota, 10));
      });
    });
  </script>
</body>
</html>
