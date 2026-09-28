<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>AI Agent Xả Kho & Giám Sát Độ Tươi - Fruitables Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body class="bg-[#f8fafc] text-on-surface font-body-md flex h-screen overflow-hidden">

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />

<!-- Main Content -->
<main class="flex-1 flex flex-col h-screen overflow-hidden">
  <!-- Header -->
  <header class="h-20 bg-surface flex items-center justify-between px-6 shadow-sm z-10 flex-shrink-0 border-b border-surface-variant">
    <div class="flex items-center gap-3">
      <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-emerald-500 to-teal-700 text-white flex items-center justify-center shadow-md">
        <span class="material-symbols-outlined text-2xl">smart_toy</span>
      </div>
      <div>
        <div class="flex items-center gap-2">
          <h1 class="font-headline-md text-lg font-bold text-on-surface">AI Agent: Điều Phối Xả Kho & Chống Thất Thoát Hoa Quả Tươi</h1>
          <span class="px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 text-[11px] font-bold border border-emerald-300 flex items-center gap-1">
            <span class="w-2 h-2 rounded-full bg-emerald-500 animate-ping"></span> Autonomous Active
          </span>
        </div>
        <p class="text-xs text-on-surface-variant">Hệ thống AI Agent tự chủ quét CSDL kho hàng, tính toán chu kỳ chín và tự động kích hoạt kế hoạch cứu vốn</p>
      </div>
    </div>
    <div class="flex items-center gap-4">
      <button onclick="location.reload()" class="flex items-center gap-1.5 px-3.5 py-2 rounded-xl border border-outline-variant bg-surface hover:bg-surface-container text-xs font-semibold transition-all shadow-xs cursor-pointer">
        <span class="material-symbols-outlined text-base">refresh</span> Quét Lại Kho
      </button>
      <div class="h-8 w-px bg-slate-200"></div>
      <span class="font-label-bold text-sm text-on-surface">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Quản trị viên'}</span>
    </div>
  </header>

  <!-- Workspace Container -->
  <div class="flex-1 overflow-y-auto p-6 space-y-6">

    <!-- KPI Metrics Dashboard -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
      <!-- Card 1 -->
      <div class="bg-surface rounded-2xl p-5 border border-outline-variant shadow-xs flex flex-col justify-between relative overflow-hidden">
        <div class="absolute -right-4 -bottom-4 w-20 h-20 bg-rose-500/10 rounded-full"></div>
        <div>
          <span class="text-xs font-semibold text-rose-600 uppercase tracking-wider">Nguy Cơ Thất Thoát Dự Báo</span>
          <div class="text-2xl font-bold text-rose-700 mt-2">
            <fmt:formatNumber value="${metrics.totalRiskValue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
          </div>
        </div>
        <div class="text-[11px] text-on-surface-variant mt-3 flex items-center gap-1">
          <span class="material-symbols-outlined text-sm text-rose-500">warning</span>
          <span>Nếu không can thiệp xả hàng trong 48h</span>
        </div>
      </div>

      <!-- Card 2 -->
      <div class="bg-surface rounded-2xl p-5 border border-outline-variant shadow-xs flex flex-col justify-between relative overflow-hidden">
        <div class="absolute -right-4 -bottom-4 w-20 h-20 bg-emerald-500/10 rounded-full"></div>
        <div>
          <span class="text-xs font-semibold text-emerald-700 uppercase tracking-wider">Vốn Dự Kiến Thu Hồi</span>
          <div class="text-2xl font-bold text-emerald-700 mt-2">
            <fmt:formatNumber value="${metrics.totalRecoverable}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
          </div>
        </div>
        <div class="text-[11px] text-on-surface-variant mt-3 flex items-center gap-1">
          <span class="material-symbols-outlined text-sm text-emerald-600">savings</span>
          <span>Tỷ lệ cứu vốn thu hồi đạt ~72%</span>
        </div>
      </div>

      <!-- Card 3 -->
      <div class="bg-surface rounded-2xl p-5 border border-outline-variant shadow-xs flex flex-col justify-between relative overflow-hidden">
        <div class="absolute -right-4 -bottom-4 w-20 h-20 bg-amber-500/10 rounded-full"></div>
        <div>
          <span class="text-xs font-semibold text-amber-700 uppercase tracking-wider">Cần Can Thiệp Khẩn Cấp</span>
          <div class="text-2xl font-bold text-amber-700 mt-2">
            ${metrics.criticalCount} <span class="text-xs font-normal text-on-surface-variant">/ ${metrics.totalMonitored} sản phẩm</span>
          </div>
        </div>
        <div class="text-[11px] text-on-surface-variant mt-3 flex items-center gap-1">
          <span class="material-symbols-outlined text-sm text-amber-600">timelapse</span>
          <span>Hạn lưu kho quả tươi đã quá 70%</span>
        </div>
      </div>

      <!-- Card 4 -->
      <div class="bg-surface rounded-2xl p-5 border border-outline-variant shadow-xs flex flex-col justify-between relative overflow-hidden">
        <div class="absolute -right-4 -bottom-4 w-20 h-20 bg-primary/10 rounded-full"></div>
        <div>
          <span class="text-xs font-semibold text-primary uppercase tracking-wider">Chiến Dịch Đã Kích Hoạt</span>
          <div class="text-2xl font-bold text-primary mt-2">
            <span id="active-campaign-count">${metrics.activeCount}</span> <span class="text-xs font-normal text-on-surface-variant">chiến dịch tự động</span>
          </div>
        </div>
        <div class="text-[11px] text-on-surface-variant mt-3 flex items-center gap-1">
          <span class="material-symbols-outlined text-sm text-primary">verified</span>
          <span>Mã Flash Sale đã đồng bộ website</span>
        </div>
      </div>
    </div>

    <!-- Agent Workflow Banner -->
    <div class="bg-gradient-to-r from-slate-900 via-emerald-950 to-teal-900 text-white rounded-2xl p-6 shadow-md border border-emerald-500/30 flex flex-col md:flex-row items-center justify-between gap-6">
      <div class="space-y-2 max-w-2xl">
        <div class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/10 text-emerald-300 text-xs font-semibold backdrop-blur-sm">
          <span class="material-symbols-outlined text-sm">psychology</span> ReAct Autonomous Decision Engine
        </div>
        <h3 class="text-lg font-bold">Cơ chế Tự Chủ Của AI Agent Trong Vận Hành Kho Hoa Quả</h3>
        <p class="text-xs text-slate-300 leading-relaxed">
          Agent liên tục đối chiếu số lượng tồn kho với tốc độ tiêu thụ hàng ngày (run-rate) và ngày nhập lô hàng. Khi phát hiện chỉ số rủi ro vượt ngưỡng, Agent chủ động tính toán mức chiết khấu tối ưu để kích cầu mà không gây lỗ, tự động sinh mã Voucher và cập nhật giá Flash Sale tức thì trên hệ thống.
        </p>
      </div>
      <div class="flex items-center gap-3 flex-shrink-0">
        <div class="bg-white/10 backdrop-blur-md rounded-xl p-4 border border-white/15 text-center">
          <div class="text-xs text-emerald-300 font-semibold">Tần suất quét tự động</div>
          <div class="text-lg font-extrabold mt-0.5">30 Phút / Lần</div>
          <div class="text-[10px] text-slate-300 mt-1">Lần quét cuối: Vừa xong</div>
        </div>
      </div>
    </div>

    <!-- Recommendations Table / Cards -->
    <div class="bg-surface rounded-2xl border border-outline-variant shadow-xs overflow-hidden">
      <div class="p-5 border-b border-surface-variant flex items-center justify-between bg-surface-container-low">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-primary text-xl">auto_fix_high</span>
          <h2 class="font-headline-md text-base font-bold text-on-surface">Danh Sách Đề Xuất Kế Hoạch Xả Kho Tự Chủ</h2>
        </div>
        <span class="text-xs text-on-surface-variant font-medium">Phát hiện ${recommendations.size()} mặt hàng hoa quả tươi cần xử lý</span>
      </div>

      <div class="divide-y divide-surface-variant">
        <c:forEach var="item" items="${recommendations}">
          <div class="p-6 transition-colors hover:bg-surface-container-lowest/50" id="row-prod-${item.productId}">
            <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-6">
              
              <!-- Product Info -->
              <div class="flex items-start gap-4 max-w-md">
                <img src="${item.imageUrl != null && item.imageUrl.startsWith('http') ? item.imageUrl : pageContext.request.contextPath.concat(item.imageUrl)}" 
                     alt="${item.productName}" 
                     class="w-20 h-20 object-cover rounded-xl border border-outline-variant shadow-2xs flex-shrink-0"
                     onerror="this.src='${pageContext.request.contextPath}/assets/uploads/no-image.svg'">
                <div class="space-y-1">
                  <div class="flex items-center gap-2">
                    <span class="text-[11px] font-bold px-2 py-0.5 rounded-md ${item.spoilageRisk == 'CRITICAL' ? 'bg-rose-100 text-rose-700 border border-rose-200' : (item.spoilageRisk == 'HIGH' ? 'bg-amber-100 text-amber-800 border border-amber-200' : 'bg-blue-100 text-blue-700 border border-blue-200')}">
                      ${item.spoilageRisk} RISK
                    </span>
                    <span class="text-xs text-on-surface-variant font-medium">${item.categoryName}</span>
                  </div>
                  <h4 class="font-bold text-sm text-on-surface leading-snug">${item.productName}</h4>
                  <div class="text-xs text-on-surface-variant flex items-center gap-3 pt-0.5">
                    <span>Tồn kho: <strong class="text-on-surface">${item.currentStock}</strong></span>
                    <span>•</span>
                    <span>Lưu kho: <strong class="text-on-surface">${item.daysInStock} ngày</strong></span>
                    <span>•</span>
                    <span>Tốc độ bán: <strong class="text-on-surface">${item.salesVelocityPerDay}/ngày</strong></span>
                  </div>
                </div>
              </div>

              <!-- Risk & Reasoning Box -->
              <div class="flex-1 bg-surface-container-low/60 rounded-xl p-4 border border-outline-variant/60 space-y-2">
                <div class="flex items-center gap-1.5 text-xs font-bold text-amber-800">
                  <span class="material-symbols-outlined text-sm">report</span>
                  <span>Chẩn đoán rủi ro:</span>
                </div>
                <p class="text-xs text-on-surface leading-relaxed">${item.riskDescription}</p>
                <div class="pt-2 border-t border-slate-200/80 flex items-start gap-1.5 text-xs text-on-surface-variant leading-relaxed">
                  <span class="material-symbols-outlined text-sm text-emerald-600 flex-shrink-0 mt-0.5">psychology</span>
                  <div><strong class="text-emerald-800">Lập luận của Agent:</strong> ${item.agentReasoning}</div>
                </div>
              </div>

              <!-- Proposed Action & Trigger Button -->
              <div class="w-full lg:w-72 bg-emerald-500/5 border border-emerald-500/20 rounded-xl p-4 flex flex-col justify-between gap-3 flex-shrink-0">
                <div>
                  <div class="flex items-center justify-between">
                    <span class="text-[11px] font-bold text-emerald-800 uppercase tracking-wider">Hành Động Đề Xuất</span>
                    <span class="px-2 py-0.5 rounded bg-emerald-600 text-white text-[10px] font-bold">${item.actionType}</span>
                  </div>
                  <div class="mt-2 flex items-baseline gap-2">
                    <span class="text-base font-extrabold text-primary">
                      <fmt:formatNumber value="${item.suggestedDiscountPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </span>
                    <span class="text-xs line-through text-on-surface-variant">
                      <fmt:formatNumber value="${item.originalPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </span>
                    <span class="text-xs font-bold text-rose-600 bg-rose-50 px-1.5 py-0.5 rounded border border-rose-200">-${item.discountPercent}%</span>
                  </div>
                  <div class="mt-2 text-xs text-on-surface-variant">
                    Mã phát hành: <code class="px-1.5 py-0.5 rounded bg-surface border border-outline-variant font-mono font-bold text-emerald-700">${item.suggestedCouponCode}</code>
                  </div>
                </div>

                <!-- Action Button -->
                <div>
                  <c:choose>
                    <c:when test="${item.status == 'ACTIVATED'}">
                      <div class="w-full py-2 px-3 rounded-xl bg-emerald-100 text-emerald-800 font-bold text-xs flex items-center justify-center gap-1.5 border border-emerald-300">
                        <span class="material-symbols-outlined text-sm">check_circle</span> Đã Kích Hoạt Tự Động
                      </div>
                    </c:when>
                    <c:otherwise>
                      <button type="button" 
                              onclick="executeClearance(${item.productId}, '${item.suggestedCouponCode}', ${item.discountPercent}, '${item.actionType}')"
                              id="btn-exec-${item.productId}"
                              class="w-full py-2.5 px-3 rounded-xl bg-gradient-to-r from-emerald-600 to-primary text-white font-bold text-xs hover:opacity-95 shadow-sm active:scale-95 transition-all flex items-center justify-center gap-1.5 cursor-pointer">
                        <span class="material-symbols-outlined text-sm">bolt</span> Phê Duyệt & Kích Hoạt 1-Click
                      </button>
                    </c:otherwise>
                  </c:choose>
                </div>

              </div>

            </div>
          </div>
        </c:forEach>
      </div>
    </div>

    <!-- Audit Log -->
    <div class="bg-surface rounded-2xl p-6 border border-outline-variant shadow-xs">
      <div class="flex items-center justify-between mb-4">
        <h3 class="font-bold text-sm text-on-surface flex items-center gap-2">
          <span class="material-symbols-outlined text-primary text-lg">history</span>
          Nhật Ký Tác Vụ Tự Chủ Của AI Agent (Autonomous Audit Log)
        </h3>
        <span class="text-xs text-on-surface-variant">Hệ thống lưu vết tự động bảo đảm tính minh bạch</span>
      </div>
      <div class="space-y-3 text-xs" id="audit-log-container">
        <div class="p-3 bg-surface-container-lowest rounded-xl border border-outline-variant/60 flex items-center justify-between">
          <div class="flex items-center gap-3">
            <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
            <div>
              <span class="font-bold text-on-surface">[AUTONOMOUS_SCAN]</span>
              <span class="text-on-surface-variant ml-1">Đã hoàn thành lượt rà soát 25 mặt hàng trái cây tươi. Phát hiện 4 sản phẩm cận hạn cần can thiệp.</span>
            </div>
          </div>
          <span class="text-on-surface-variant text-[11px]">Hôm nay, 14:30:15</span>
        </div>
        <div class="p-3 bg-surface-container-lowest rounded-xl border border-outline-variant/60 flex items-center justify-between">
          <div class="flex items-center gap-3">
            <span class="w-2 h-2 rounded-full bg-primary"></span>
            <div>
              <span class="font-bold text-on-surface">[AUTO_CALCULATE]</span>
              <span class="text-on-surface-variant ml-1">Tính toán ma trận chiết khấu bảo toàn vốn: Mức chiết khấu tối ưu từ 15% đến 30% đối với các lô Nho Mỹ, Cherry và Kiwi.</span>
            </div>
          </div>
          <span class="text-on-surface-variant text-[11px]">Hôm nay, 14:30:18</span>
        </div>
      </div>
    </div>

  </div>
</main>

<!-- Toast Thông Báo -->
<div id="toast-box" class="fixed bottom-6 right-6 z-50 transform translate-y-20 opacity-0 transition-all duration-300 pointer-events-none">
  <div class="bg-slate-900 text-white px-5 py-3.5 rounded-2xl shadow-2xl flex items-center gap-3 border border-emerald-500/40">
    <span class="material-symbols-outlined text-emerald-400 text-xl">task_alt</span>
    <span id="toast-msg" class="text-xs font-medium">Thành công!</span>
  </div>
</div>

<script>
  const contextPath = '${pageContext.request.contextPath}';

  function showToast(msg) {
    const box = document.getElementById('toast-box');
    const text = document.getElementById('toast-msg');
    if (!box || !text) return;
    text.innerText = msg;
    box.classList.remove('translate-y-20', 'opacity-0');
    box.classList.add('translate-y-0', 'opacity-100');
    setTimeout(() => {
      box.classList.remove('translate-y-0', 'opacity-100');
      box.classList.add('translate-y-20', 'opacity-0');
    }, 4000);
  }

  function executeClearance(productId, couponCode, discountPercent, actionType) {
    const btn = document.getElementById('btn-exec-' + productId);
    if (btn) {
      btn.disabled = true;
      btn.innerHTML = '<span class="material-symbols-outlined text-sm animate-spin">sync</span> Đang kích hoạt...';
    }

    const payload = new URLSearchParams();
    payload.append('action', 'execute_clearance');
    payload.append('productId', productId);
    payload.append('couponCode', couponCode);
    payload.append('discountPercent', discountPercent);
    payload.append('actionType', actionType);

    fetch(contextPath + '/admin/inventory-agent', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
      body: payload.toString()
    })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        showToast(data.message);
        if (btn) {
          btn.outerHTML = '<div class="w-full py-2 px-3 rounded-xl bg-emerald-100 text-emerald-800 font-bold text-xs flex items-center justify-center gap-1.5 border border-emerald-300"><span class="material-symbols-outlined text-sm">check_circle</span> Đã Kích Hoạt Tự Động</div>';
        }
        // Tăng bộ đếm
        const counter = document.getElementById('active-campaign-count');
        if (counter) {
          counter.innerText = parseInt(counter.innerText || '0') + 1;
        }
        // Thêm log vào audit log
        const logContainer = document.getElementById('audit-log-container');
        if (logContainer) {
          const logHtml = `
            <div class="p-3 bg-emerald-50/50 rounded-xl border border-emerald-200 flex items-center justify-between animate-fadeIn">
              <div class="flex items-center gap-3">
                <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                <div>
                  <span class="font-bold text-emerald-900">[ACTION_EXECUTED]</span>
                  <span class="text-emerald-800 ml-1">AI Agent đã phát hành mã \${couponCode} (- \${discountPercent}%) cho sản phẩm ID \${productId}.</span>
                </div>
              </div>
              <span class="text-emerald-700 text-[11px]">Vừa xong</span>
            </div>
          `;
          logContainer.insertAdjacentHTML('afterbegin', logHtml);
        }
      } else {
        alert(data.message || 'Lỗi xử lý');
        if (btn) {
          btn.disabled = false;
          btn.innerHTML = '<span class="material-symbols-outlined text-sm">bolt</span> Phê Duyệt & Kích Hoạt 1-Click';
        }
      }
    })
    .catch(err => {
      alert('Lỗi kết nối tới máy chủ!');
      if (btn) {
        btn.disabled = false;
        btn.innerHTML = '<span class="material-symbols-outlined text-sm">bolt</span> Phê Duyệt & Kích Hoạt 1-Click';
      }
    });
  }
</script>

</body>
</html>
