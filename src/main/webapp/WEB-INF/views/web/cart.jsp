<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Giỏ hàng - Fruitables</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>

<body class="bg-surface-container bg-pattern min-h-screen flex flex-col antialiased">
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<main class="flex-grow py-10 md:py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <h1 class="font-headline-md text-2xl md:text-3xl text-on-surface mb-8 font-extrabold flex items-center gap-3">
            <span class="material-symbols-outlined text-primary text-3xl">shopping_cart</span> Giỏ hàng của bạn
        </h1>

        <%-- Flash banners: thông báo reorder, lỗi đơn hàng, v.v. --%>
        <c:if test="${not empty sessionScope.ORDER_MESSAGE_SUCCESS}">
            <div class="mb-6 p-3.5 bg-green-50 border border-green-200 text-green-700 text-sm rounded-xl flex items-center gap-2.5">
                <span class="material-symbols-outlined text-base">check_circle</span>
                <span>${sessionScope.ORDER_MESSAGE_SUCCESS}</span>
            </div>
            <c:remove var="ORDER_MESSAGE_SUCCESS" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.ORDER_MESSAGE_ERROR}">
            <div class="mb-6 p-3.5 bg-red-50 border border-red-200 text-red-600 text-sm rounded-xl flex items-center gap-2.5">
                <span class="material-symbols-outlined text-base">error</span>
                <span>${sessionScope.ORDER_MESSAGE_ERROR}</span>
            </div>
            <c:remove var="ORDER_MESSAGE_ERROR" scope="session"/>
        </c:if>

        <c:choose>
            <c:when test="${empty sessionScope.CART || sessionScope.CART.size() == 0}">
                <div class="text-center py-20 bg-surface-container-lowest rounded-2xl shadow-sm border border-outline-variant max-w-2xl mx-auto p-6">
                    <div class="w-20 h-20 bg-surface-container rounded-full flex items-center justify-center mx-auto mb-4 text-outline">
                        <span class="material-symbols-outlined text-4xl">production_quantity_limits</span>
                    </div>
                    <h2 class="font-headline-md text-xl text-on-surface mb-2 font-bold">Giỏ hàng đang trống</h2>
                    <p class="font-body-md text-on-surface-variant text-sm mb-6">Bạn chưa có sản phẩm nào trong giỏ hàng. Hãy khám phá ngay các món tươi ngon của chúng tôi!</p>
                    <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center px-6 py-3 bg-primary text-white font-label-bold rounded-full hover:bg-primary-container transition-colors shadow-md text-sm">
                        <span class="material-symbols-outlined mr-2 text-base">storefront</span> Mua sắm ngay
                    </a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="flex flex-col lg:flex-row gap-8 items-start">
                    <!-- Danh sách sản phẩm -->
                    <div class="w-full lg:w-2/3 bg-surface-container-lowest rounded-2xl shadow-sm border border-outline-variant overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left">
                                <thead class="bg-surface-container-low border-b border-surface-variant text-on-surface-variant text-xs uppercase tracking-wider">
                                <tr>
                                    <th class="py-4 px-6 font-label-bold">Sản phẩm</th>
                                    <th class="py-4 px-6 font-label-bold">Đơn giá</th>
                                    <th class="py-4 px-6 font-label-bold text-center">Số lượng</th>
                                    <th class="py-4 px-6 font-label-bold text-right">Tổng</th>
                                    <th class="py-4 px-6 text-center"></th>
                                </tr>
                                </thead>
                                <tbody class="divide-y divide-surface-variant text-sm">
                                <c:set var="cartTotal" value="0"/>

                                <c:forEach var="item" items="${sessionScope.CART.values()}">
                                    <c:set var="cartTotal" value="${cartTotal + item.subTotal}"/>
                                    <tr class="hover:bg-surface-bright transition-colors">
                                        <td class="py-4 px-6 flex items-center gap-3">
                                            <img src="${not empty item.imageUrl ? item.imageUrl : pageContext.request.contextPath.concat('/assets/uploads/no-image.svg')}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/uploads/no-image.svg';" alt="${item.name}" class="w-16 h-16 object-cover rounded-xl border border-outline-variant flex-shrink-0">
                                            <span class="font-label-bold text-on-surface line-clamp-2"><c:out value="${item.name}"/></span>
                                        </td>
                                        <td class="py-4 px-6 text-on-surface whitespace-nowrap">
                                            <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td class="py-4 px-6">
                                            <form action="${pageContext.request.contextPath}/cart" method="POST" class="flex items-center justify-center bg-surface-container rounded-lg w-max mx-auto overflow-hidden border border-outline-variant">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <button type="submit" onclick="this.nextElementSibling.value--" class="px-2.5 py-1 text-on-surface hover:text-primary transition-colors">
                                                    <span class="material-symbols-outlined text-[16px] block">remove</span>
                                                </button>
                                                <input type="number" name="quantity" value="${item.quantity}" min="1" class="w-10 text-center bg-transparent border-none outline-none text-sm p-0 font-label-bold" onchange="this.form.submit()">
                                                <button type="submit" onclick="this.previousElementSibling.value++" class="px-2.5 py-1 text-on-surface hover:text-primary transition-colors">
                                                    <span class="material-symbols-outlined text-[16px] block">add</span>
                                                </button>
                                            </form>
                                        </td>
                                        <td class="py-4 px-6 text-right font-price-tag text-primary font-bold whitespace-nowrap">
                                            <fmt:formatNumber value="${item.subTotal}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td class="py-4 px-6 text-center">
                                            <form action="${pageContext.request.contextPath}/cart" method="POST">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <button type="submit" class="text-on-surface-variant hover:text-error transition-colors p-1.5 rounded-full hover:bg-error-container" title="Xóa món này">
                                                    <span class="material-symbols-outlined text-[18px] block">delete</span>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Cột tính toán tổng thanh toán -->
                    <div class="w-full lg:w-1/3 flex flex-col gap-6">
                        <div class="bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-outline-variant sticky top-28">
                            <h3 class="font-headline-md text-lg text-on-surface border-b border-surface-variant pb-3 mb-4 font-bold">Tổng quan đơn hàng</h3>

                            <div class="flex justify-between items-center mb-3 text-on-surface-variant text-sm">
                                <span>Tạm tính</span>
                                <span class="font-semibold text-on-surface">
                                    <fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/> ₫
                                </span>
                            </div>

                            <!-- XỬ LÝ HIỂN THỊ TIỀN GIẢM TỪ VOUCHER -->
                            <c:set var="discount" value="${sessionScope.DISCOUNT_AMOUNT != null ? sessionScope.DISCOUNT_AMOUNT : 0}"/>
                            <c:set var="finalTotal" value="${cartTotal - discount > 0 ? cartTotal - discount : 0}"/>

                            <c:if test="${discount > 0}">
                                <div class="flex justify-between items-center mb-3 text-emerald-600 text-sm font-semibold">
                                    <span class="flex items-center gap-1">
                                        <span class="material-symbols-outlined text-sm">sell</span> Giảm giá (${sessionScope.APPLIED_COUPON_CODE})
                                    </span>
                                    <span>- <fmt:formatNumber value="${discount}" type="number" groupingUsed="true"/> ₫</span>
                                </div>
                            </c:if>

                            <div class="flex justify-between items-center mb-4 text-on-surface-variant text-sm border-b border-surface-variant pb-3">
                                <span>Phí vận chuyển</span>
                                <span class="font-semibold text-primary">Miễn phí</span>
                            </div>

                            <!-- TỔNG THANH TOÁN SAU GIẢM GIÁ -->
                            <div class="flex justify-between items-center mb-6">
                                <span class="font-label-bold text-on-surface text-base">Tổng thanh toán</span>
                                <span class="font-price-tag text-2xl text-primary font-extrabold">
                                    <fmt:formatNumber value="${finalTotal}" type="number" groupingUsed="true"/> ₫
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/checkout" class="w-full flex items-center justify-center bg-primary text-white py-3.5 rounded-full font-label-bold text-base hover:bg-primary-container transition-all duration-300 shadow-md hover:-translate-y-0.5">
                                Tiến hành thanh toán
                            </a>
                            <a href="${pageContext.request.contextPath}/shop" class="w-full text-center block mt-3 text-on-surface-variant hover:text-primary font-body-md text-sm transition-colors">
                                Tiếp tục mua sắm
                            </a>

                            <%-- ════════════════════════════════════════════════════ --%>
                            <%-- KHUNG VOUCHER PICKER (Trigger bar + Modal)          --%>
                            <%-- ════════════════════════════════════════════════════ --%>
                            <div class="mt-6 pt-5 border-t border-surface-variant">
                                <label class="block font-label-bold text-sm text-on-surface mb-2 flex items-center gap-1.5">
                                    <span class="material-symbols-outlined text-primary text-lg">confirmation_number</span>
                                    Mã giảm giá (Voucher)
                                </label>

                                <%-- THÔNG BÁO KẾT QUẢ ÁP DỤNG --%>
                                <c:if test="${not empty sessionScope.COUPON_MESSAGE}">
                                    <div class="mb-3 p-2.5 bg-green-50 border border-green-200 text-green-700 text-xs rounded-lg flex items-center gap-2">
                                        <span class="material-symbols-outlined text-sm">check_circle</span>
                                        <span>${sessionScope.COUPON_MESSAGE}</span>
                                    </div>
                                    <c:remove var="COUPON_MESSAGE" scope="session"/>
                                </c:if>
                                <c:if test="${not empty sessionScope.COUPON_ERROR}">
                                    <div class="mb-3 p-2.5 bg-red-50 border border-red-200 text-red-600 text-xs rounded-lg flex items-center gap-2">
                                        <span class="material-symbols-outlined text-sm">error</span>
                                        <span>${sessionScope.COUPON_ERROR}</span>
                                    </div>
                                    <c:remove var="COUPON_ERROR" scope="session"/>
                                </c:if>

                                <c:choose>
                                    <%-- Chưa đăng nhập: prompt đăng nhập --%>
                                    <c:when test="${empty sessionScope.USERMODEL}">
                                        <div class="p-3 bg-surface-container rounded-xl text-xs text-on-surface-variant flex items-center justify-between">
                                            <span>Đăng nhập để dùng mã giảm giá độc quyền!</span>
                                            <a href="${pageContext.request.contextPath}/login" class="text-primary font-bold hover:underline ml-2 whitespace-nowrap">Đăng nhập</a>
                                        </div>
                                    </c:when>
                                    <%-- Đã đăng nhập --%>
                                    <c:otherwise>
                                        <%-- ── TRIGGER BAR ─────────────────────────────────── --%>
                                        <c:choose>
                                            <%-- Đã có voucher đang áp dụng --%>
                                            <c:when test="${not empty sessionScope.APPLIED_COUPON_CODE}">
                                                <div class="flex items-center justify-between p-3 rounded-xl bg-emerald-50 border border-emerald-300 gap-3">
                                                    <div class="flex items-center gap-2 min-w-0">
                                                        <span class="material-symbols-outlined text-emerald-600 text-base flex-shrink-0">sell</span>
                                                        <div class="min-w-0">
                                                            <div class="font-mono font-extrabold text-emerald-800 text-sm tracking-wider uppercase truncate">${sessionScope.APPLIED_COUPON_CODE}</div>
                                                            <div class="text-[11px] text-emerald-600">
                                                                <c:choose>
                                                                    <c:when test="${sessionScope.APPLIED_COUPON_TYPE == 'FREESHIP'}">Đang giảm phí vận chuyển</c:when>
                                                                    <c:otherwise>Tiết kiệm <fmt:formatNumber value="${sessionScope.DISCOUNT_AMOUNT}" type="number" groupingUsed="true"/> ₫</c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="flex items-center gap-2 flex-shrink-0">
                                                        <button type="button" onclick="openVoucherModal()"
                                                                class="text-xs text-primary font-bold hover:underline">Đổi mã</button>
                                                        <a href="${pageContext.request.contextPath}/apply-coupon?action=remove"
                                                           class="text-on-surface-variant hover:text-error p-1 rounded-full hover:bg-error-container transition-colors" title="Bỏ voucher">
                                                            <span class="material-symbols-outlined text-[16px] block">close</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <%-- Chưa có voucher: nút mở modal --%>
                                            <c:otherwise>
                                                <button type="button" id="btn-open-voucher-modal" onclick="openVoucherModal()"
                                                        class="w-full flex items-center justify-between px-4 py-3 rounded-xl border border-dashed border-outline-variant hover:border-primary hover:bg-primary/5 transition-all group">
                                                    <span class="text-sm text-on-surface-variant group-hover:text-primary flex items-center gap-2">
                                                        <span class="material-symbols-outlined text-base">add_circle</span>
                                                        Chọn hoặc nhập mã giảm giá
                                                    </span>
                                                    <span class="material-symbols-outlined text-on-surface-variant text-base group-hover:text-primary">chevron_right</span>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<%-- ══════════════════════════════════════════════════════════════════════════ --%>
<%-- VOUCHER PICKER MODAL                                                       --%>
<%-- ══════════════════════════════════════════════════════════════════════════ --%>
<div id="voucher-modal-overlay"
     class="fixed inset-0 z-[9000] flex items-end sm:items-center justify-center p-4 hidden"
     onclick="handleOverlayClick(event)">

    <%-- Backdrop --%>
    <div class="absolute inset-0 bg-black/50 backdrop-blur-sm" id="voucher-modal-backdrop"></div>

    <%-- Modal Panel --%>
    <div id="voucher-modal-panel"
         class="relative w-full max-w-md bg-surface-container-lowest rounded-3xl shadow-2xl z-10
                flex flex-col max-h-[85vh] translate-y-8 opacity-0 scale-95
                transition-all duration-300 ease-out overflow-hidden">

        <%-- ── Header ──────────────────────────────────────────────────────── --%>
        <div class="flex items-center justify-between px-5 py-4 border-b border-surface-variant flex-shrink-0">
            <div class="flex items-center gap-2">
                <span class="material-symbols-outlined text-primary text-xl">confirmation_number</span>
                <h2 class="font-headline-md text-base font-bold text-on-surface">Chọn mã giảm giá</h2>
            </div>
            <button type="button" onclick="closeVoucherModal()"
                    class="w-8 h-8 flex items-center justify-center rounded-full hover:bg-surface-container transition-colors text-on-surface-variant hover:text-on-surface">
                <span class="material-symbols-outlined text-xl">close</span>
            </button>
        </div>

        <%-- ── Nhập mã thủ công ────────────────────────────────────────────── --%>
        <div class="px-5 py-4 border-b border-surface-variant flex-shrink-0 bg-surface-container/50">
            <form action="${pageContext.request.contextPath}/apply-coupon" method="POST"
                  class="flex gap-2" id="manual-coupon-form">
                <input type="text" name="couponCode" id="manual-coupon-input"
                       placeholder="Nhập mã bí mật / mã sự kiện..."
                       autocomplete="off" spellcheck="false"
                       class="flex-1 px-3.5 py-2.5 rounded-xl border border-outline-variant outline-none
                              focus:border-primary focus:ring-2 focus:ring-primary/20 text-sm uppercase
                              bg-surface-container-lowest tracking-widest font-mono placeholder:normal-case
                              placeholder:font-sans placeholder:tracking-normal transition-all">
                <button type="submit"
                        class="px-4 py-2.5 bg-primary text-white font-label-bold rounded-xl
                               hover:bg-primary-container transition-colors text-sm whitespace-nowrap
                               flex items-center gap-1 shadow-sm">
                    <span class="material-symbols-outlined text-base">check</span>
                    Áp dụng
                </button>
            </form>
        </div>

        <%-- ── Danh sách voucher ───────────────────────────────────────────── --%>
        <div class="flex-1 overflow-y-auto px-5 py-4 space-y-4" id="voucher-list-container">

            <%-- Skeleton loading --%>
            <div id="voucher-skeleton" class="space-y-3">
                <div class="h-4 w-32 bg-surface-container rounded animate-pulse"></div>
                <div class="h-20 bg-surface-container rounded-2xl animate-pulse"></div>
                <div class="h-20 bg-surface-container rounded-2xl animate-pulse"></div>
                <div class="h-4 w-40 bg-surface-container rounded animate-pulse mt-4"></div>
                <div class="h-20 bg-surface-container rounded-2xl animate-pulse opacity-60"></div>
            </div>

            <%-- Danh sách thực (ẩn cho đến khi load xong) --%>
            <div id="voucher-list-content" class="hidden space-y-5">
                <%-- Group: Khả dụng ngay --%>
                <div id="group-applicable">
                    <p class="text-xs font-bold text-on-surface-variant uppercase tracking-wider mb-2.5 flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-primary text-sm">verified</span>
                        <span id="group-applicable-title">Khả dụng ngay</span>
                    </p>
                    <div id="voucher-applicable-list" class="space-y-2.5"></div>
                </div>

                <%-- Group: Chưa đủ điều kiện --%>
                <div id="group-not-qualified" class="hidden">
                    <p class="text-xs font-bold text-on-surface-variant uppercase tracking-wider mb-2.5 flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-amber-500 text-sm">lock</span>
                        <span id="group-not-qualified-title">Chưa đủ điều kiện</span>
                    </p>
                    <div id="voucher-not-qualified-list" class="space-y-2.5"></div>
                </div>

                <%-- Empty state --%>
                <div id="voucher-empty" class="hidden py-8 text-center">
                    <span class="material-symbols-outlined text-4xl text-outline mb-2 block">confirmation_number</span>
                    <p class="text-sm text-on-surface-variant">Hiện chưa có mã giảm giá nào</p>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Hidden form for 1-click apply from modal --%>
<form id="quick-apply-form" action="${pageContext.request.contextPath}/apply-coupon" method="POST" class="hidden">
    <input type="hidden" name="couponCode" id="quick-apply-code">
</form>

<script>
// ════════════════════════════════════════════════════════════════════
//  VOUCHER PICKER — JavaScript Logic
// ════════════════════════════════════════════════════════════════════
const ctxPath = '${pageContext.request.contextPath}';
let voucherDataLoaded = false;

/** Mở Modal và load dữ liệu nếu chưa có */
function openVoucherModal() {
    const overlay = document.getElementById('voucher-modal-overlay');
    const panel   = document.getElementById('voucher-modal-panel');
    overlay.classList.remove('hidden');
    document.body.style.overflow = 'hidden';

    // Animate in
    requestAnimationFrame(() => {
        panel.classList.remove('translate-y-8', 'opacity-0', 'scale-95');
        panel.classList.add('translate-y-0', 'opacity-100', 'scale-100');
    });

    // Focus vào input mã thủ công
    setTimeout(() => {
        const inp = document.getElementById('manual-coupon-input');
        if (inp) inp.focus();
    }, 300);

    // Load dữ liệu (chỉ 1 lần mỗi lần mở)
    if (!voucherDataLoaded) {
        loadVoucherList();
    }
}

/** Đóng Modal */
function closeVoucherModal() {
    const overlay = document.getElementById('voucher-modal-overlay');
    const panel   = document.getElementById('voucher-modal-panel');
    panel.classList.add('translate-y-8', 'opacity-0', 'scale-95');
    panel.classList.remove('translate-y-0', 'opacity-100', 'scale-100');
    setTimeout(() => {
        overlay.classList.add('hidden');
        document.body.style.overflow = '';
    }, 280);
    // Reset flag để lần mở tiếp sẽ load lại data (giỏ hàng có thể đã thay đổi)
    voucherDataLoaded = false;
}

/** Đóng khi click backdrop */
function handleOverlayClick(e) {
    if (e.target === document.getElementById('voucher-modal-backdrop')) {
        closeVoucherModal();
    }
}

/** Phím ESC đóng modal */
document.addEventListener('keydown', e => {
    if (e.key === 'Escape') closeVoucherModal();
});

/** Gọi API lấy danh sách voucher và render */
async function loadVoucherList() {
    voucherDataLoaded = false;
    try {
        const resp = await fetch(ctxPath + '/api/coupon?action=list', {
            credentials: 'same-origin',
            headers: { 'Accept': 'application/json' }
        });

        if (resp.status === 401) {
            // Chưa đăng nhập — không nên xảy ra vì trigger bar đã kiểm soát
            showVoucherError('Vui lòng đăng nhập để xem mã giảm giá.');
            return;
        }

        const data = await resp.json();
        renderVoucherList(data);
        voucherDataLoaded = true;

    } catch (err) {
        showVoucherError('Không tải được danh sách voucher. Vui lòng thử lại!');
        console.error('CouponAPI error:', err);
    }
}

/** Render 2 nhóm voucher: Khả dụng / Chưa đủ điều kiện */
function renderVoucherList(coupons) {
    // Ẩn skeleton, hiện content
    document.getElementById('voucher-skeleton').classList.add('hidden');
    document.getElementById('voucher-list-content').classList.remove('hidden');

    const applicable    = coupons.filter(c => c.applicable);
    const notQualified  = coupons.filter(c => !c.applicable);

    const appList  = document.getElementById('voucher-applicable-list');
    const nqList   = document.getElementById('voucher-not-qualified-list');
    const appTitle = document.getElementById('group-applicable-title');
    const nqTitle  = document.getElementById('group-not-qualified-title');
    const nqGroup  = document.getElementById('group-not-qualified');
    const emptyEl  = document.getElementById('voucher-empty');

    appList.innerHTML = '';
    nqList.innerHTML  = '';

    if (coupons.length === 0) {
        emptyEl.classList.remove('hidden');
        document.getElementById('group-applicable').classList.add('hidden');
        return;
    }

    // ── NHÓM KHẢI DỤNG ──────────────────────────────────────────────
    appTitle.textContent = 'Khả dụng ngay (' + applicable.length + ')';

    if (applicable.length === 0) {
        appList.innerHTML = '<p class="text-xs text-on-surface-variant py-2 text-center">Không có mã nào phù hợp với đơn hàng hiện tại</p>';
    } else {
        applicable.forEach(c => {
            appList.insertAdjacentHTML('beforeend', buildVoucherCard(c, true));
        });
    }

    // ── NHÓM CHƯA ĐỦ ĐIỀU KIỆN ─────────────────────────────────────
    if (notQualified.length > 0) {
        nqGroup.classList.remove('hidden');
        nqTitle.textContent = 'Chưa đủ điều kiện (' + notQualified.length + ')';
        notQualified.forEach(c => {
            nqList.insertAdjacentHTML('beforeend', buildVoucherCard(c, false));
        });
    }
}

/** Tạo HTML cho một voucher card */
function buildVoucherCard(c, applicable) {
    const discountBadge = buildDiscountBadge(c);
    const audienceBadge = buildAudienceBadge(c);
    const expiryText    = c.endDate ? '<span class="text-[10px] text-outline">HSD: ' + c.endDate + '</span>' : '';
    const productBadge  = c.productName
        ? '<span class="text-[10px] text-purple-600 font-medium">Cho: ' + escHtml(c.productName) + '</span>'
        : '';
    const minOrderText  = c.minOrderValue > 0
        ? 'Đơn từ <strong>' + formatMoney(c.minOrderValue) + ' ₫</strong>'
        : 'Không giới hạn đơn';

    if (applicable) {
        // Card sáng — có thể áp dụng ngay
        const savingText = c.discountType === 'FREESHIP'
            ? 'Tiết kiệm tối đa <strong>' + formatMoney(c.calculatedDiscount) + ' ₫</strong> phí ship'
            : 'Tiết kiệm <strong>' + formatMoney(c.calculatedDiscount) + ' ₫</strong>';

        return '<div class="relative flex items-stretch rounded-2xl border border-primary/30 overflow-hidden ' +
               'shadow-sm hover:shadow-md hover:-translate-y-0.5 transition-all bg-white group">' +
               // Dải màu trái
               '<div class="w-1.5 flex-shrink-0 bg-gradient-to-b from-primary to-[#6ca305]"></div>' +
               // Nội dung
               '<div class="flex-1 p-3.5 flex items-center gap-3 min-w-0">' +
               '<div class="flex-1 min-w-0">' +
               '<div class="flex flex-wrap items-center gap-1.5 mb-1">' + discountBadge + audienceBadge + '</div>' +
               '<div class="font-mono font-extrabold text-on-surface text-base tracking-widest uppercase mb-0.5">' + escHtml(c.code) + '</div>' +
               '<div class="text-xs text-on-surface-variant flex flex-wrap gap-x-3 gap-y-0.5">' +
               '<span>' + minOrderText + '</span>' + productBadge +
               '</div>' +
               '<div class="text-xs text-emerald-600 font-medium mt-1">' + savingText + '</div>' +
               '</div>' +
               // Nút áp dụng
               '<button type="button" onclick="applyVoucher(\'' + escAttr(c.code) + '\')" ' +
               'class="flex-shrink-0 px-3.5 py-2 bg-primary text-white font-label-bold rounded-xl text-xs ' +
               'hover:bg-primary-container transition-colors shadow-sm hover:shadow whitespace-nowrap">' +
               'Dùng ngay</button>' +
               '</div>' +
               // Dấu đứt khúc
               '<div class="absolute right-[72px] top-1/2 -translate-y-1/2 h-full flex flex-col justify-center gap-1 pointer-events-none opacity-0"></div>' +
               '</div>';
    } else {
        // Card mờ — chưa đủ điều kiện
        const reasonText = c.reasonNotQualified
            ? '<div class="text-[11px] text-amber-700 bg-amber-50 border border-amber-200 rounded-lg px-2 py-1 mt-1.5">' +
              '<span class="material-symbols-outlined text-[12px] mr-0.5 align-middle">info</span>' +
              escHtml(c.reasonNotQualified) + '</div>'
            : '';
        const shopBtn = c.shortfallAmount > 0
            ? '<a href="' + ctxPath + '/shop" class="flex-shrink-0 px-3.5 py-2 bg-surface-container text-on-surface-variant ' +
              'border border-outline-variant font-label-bold rounded-xl text-[11px] hover:bg-surface-container-high ' +
              'transition-colors whitespace-nowrap text-center">Mua thêm</a>'
            : '<div class="flex-shrink-0 w-16"></div>';

        return '<div class="relative flex items-stretch rounded-2xl border border-outline-variant overflow-hidden opacity-70 bg-surface-container-lowest">' +
               '<div class="w-1.5 flex-shrink-0 bg-slate-300"></div>' +
               '<div class="flex-1 p-3.5 flex items-center gap-3 min-w-0">' +
               '<div class="flex-1 min-w-0">' +
               '<div class="flex flex-wrap items-center gap-1.5 mb-1">' + discountBadge + audienceBadge + '</div>' +
               '<div class="font-mono font-extrabold text-on-surface-variant text-base tracking-widest uppercase mb-0.5">' + escHtml(c.code) + '</div>' +
               '<div class="text-xs text-on-surface-variant flex flex-wrap gap-x-3 gap-y-0.5">' +
               '<span>' + minOrderText + '</span>' + productBadge + expiryText +
               '</div>' + reasonText +
               '</div>' + shopBtn +
               '</div></div>';
    }
}

function buildDiscountBadge(c) {
    if (c.discountType === 'FREESHIP') {
        return '<span class="text-[10px] font-bold px-2 py-0.5 rounded-md bg-blue-50 text-blue-700 border border-blue-200">Freeship</span>';
    } else if (c.discountType === 'PERCENT') {
        return '<span class="text-[10px] font-bold px-2 py-0.5 rounded-md bg-orange-50 text-orange-700 border border-orange-200">-' + c.discountValue + '%</span>';
    } else {
        return '<span class="text-[10px] font-bold px-2 py-0.5 rounded-md bg-emerald-50 text-emerald-700 border border-emerald-200">-' + formatMoney(c.discountValue) + '₫</span>';
    }
}

function buildAudienceBadge(c) {
    if (c.targetAudience === 'GMAIL') {
        return '<span class="text-[10px] font-bold px-2 py-0.5 rounded-md bg-rose-50 text-rose-600 border border-rose-100">Gmail only</span>';
    } else if (c.targetAudience === 'REGULAR') {
        return '<span class="text-[10px] font-bold px-2 py-0.5 rounded-md bg-blue-50 text-blue-600 border border-blue-100">Thành viên</span>';
    }
    return '';
}

/** Áp dụng voucher qua hidden form (chờ animation đóng xong rồi mới submit) */
function applyVoucher(code) {
    document.getElementById('quick-apply-code').value = code;
    closeVoucherModal();
    // Chờ 300ms cho animation closeVoucherModal kết thúc trước khi submit
    setTimeout(() => {
        document.getElementById('quick-apply-form').submit();
    }, 310);
}

function showVoucherError(msg) {
    document.getElementById('voucher-skeleton').classList.add('hidden');
    document.getElementById('voucher-list-content').classList.remove('hidden');
    document.getElementById('voucher-applicable-list').innerHTML =
        '<div class="p-3 bg-red-50 border border-red-200 text-red-600 text-xs rounded-xl flex items-center gap-2">' +
        '<span class="material-symbols-outlined text-sm">error</span>' + escHtml(msg) + '</div>';
}

function formatMoney(n) {
    if (!n) return '0';
    return Math.round(n).toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');
}

function escHtml(str) {
    if (!str) return '';
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function escAttr(str) {
    if (!str) return '';
    return str.replace(/'/g, "\\'").replace(/"/g, '\\"');
}
</script>
</body>
</html>