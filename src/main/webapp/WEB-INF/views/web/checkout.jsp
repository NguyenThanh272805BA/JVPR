<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Thanh toán - Fruitables</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>

<body class="bg-surface-container bg-pattern min-h-screen flex flex-col antialiased">
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<main class="flex-grow py-10 md:py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <div class="flex items-center justify-between mb-8 pb-4 border-b border-surface-variant">
            <h1 class="font-headline-md text-2xl md:text-3xl text-on-surface font-extrabold flex items-center gap-3">
                <span class="material-symbols-outlined text-primary text-3xl">fact_check</span> Chi tiết thanh toán
            </h1>
            <a href="${pageContext.request.contextPath}/cart" class="text-on-surface-variant hover:text-primary transition-colors text-sm font-label-bold flex items-center gap-1">
                <span class="material-symbols-outlined text-base">arrow_back</span> Quay lại Giỏ hàng
            </a>
        </div>

        <!-- Banner mời đăng nhập đối với Khách vãng lai -->
        <c:if test="${empty sessionScope.USERMODEL}">
            <div class="mb-8 bg-primary/10 border border-primary/30 p-4 rounded-2xl flex flex-col md:flex-row items-center justify-between gap-4 shadow-sm">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-primary rounded-xl flex items-center justify-center text-white flex-shrink-0">
                        <span class="material-symbols-outlined">redeem</span>
                    </div>
                    <div>
                        <h4 class="font-label-bold text-on-surface text-base">Bạn là khách hàng mới?</h4>
                        <p class="font-body-md text-on-surface-variant text-xs">Đăng nhập tài khoản giúp bạn lưu lịch sử đơn hàng, dùng Voucher giảm giá và tích điểm nhận ưu đãi.</p>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/login" class="whitespace-nowrap px-5 py-2 bg-primary text-white font-label-bold rounded-full hover:bg-primary-container transition-colors shadow-sm text-xs">
                    Đăng nhập ngay
                </a>
            </div>
        </c:if>

        <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="POST" class="flex flex-col lg:flex-row gap-8 items-start">
            <!-- Hidden inputs lưu thông tin vận chuyển & địa chỉ gửi về Server -->
            <input type="hidden" name="shippingFee" id="inputShippingFee" value="0">
            <input type="hidden" name="distanceKm" id="inputDistanceKm" value="0">
            <input type="hidden" name="shippingDiscount" id="inputShippingDiscount" value="0">
            <input type="hidden" name="provinceName" id="inputProvinceName" value="">
            <input type="hidden" name="districtName" id="inputDistrictName" value="">
            <input type="hidden" name="wardName" id="inputWardName" value="">

            <!-- CỘT TRÁI: Form điền thông tin khách hàng -->
            <div class="w-full lg:w-2/3 space-y-6">
                <div class="bg-surface-container-lowest p-6 md:p-8 rounded-2xl shadow-sm border border-outline-variant">
                    <h2 class="font-headline-md text-lg text-on-surface mb-6 border-b border-surface-variant pb-3 font-bold flex items-center justify-between">
                        <span>1. Thông tin giao nhận hàng</span>
                        <span class="text-xs font-normal text-on-surface-variant flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm text-primary">store</span> Kho gửi: Fruitables Nam Từ Liêm, HN
                        </span>
                    </h2>

                    <!-- SỔ ĐỊA CHỈ ĐÃ LƯU (Dành cho thành viên đã đăng nhập) -->
                    <c:if test="${not empty savedAddresses}">
                        <div class="mb-5 p-4 rounded-xl bg-surface-container/60 border border-outline-variant">
                            <div class="flex items-center justify-between mb-2">
                                <label class="font-label-bold text-xs text-on-surface flex items-center gap-1.5 text-primary">
                                    <span class="material-symbols-outlined text-base">bookmarks</span>
                                    Chọn từ sổ địa chỉ của bạn:
                                </label>
                                <button type="button" id="btnNewAddress" class="text-xs text-primary font-bold hover:underline">
                                    + Dùng địa chỉ mới
                                </button>
                            </div>
                            <select id="savedAddressSelect" class="w-full px-3 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-xs font-medium">
                                <option value="">-- Chọn địa chỉ đã lưu hoặc bấm Dùng địa chỉ mới --</option>
                                <c:forEach var="addr" items="${savedAddresses}">
                                    <option value="${addr.id}"
                                            data-recipient="${addr.recipientName}"
                                            data-phone="${addr.phone}"
                                            data-province="${addr.province}"
                                            data-district="${addr.district}"
                                            data-ward="${addr.ward}"
                                            data-street="${addr.streetAddress}"
                                            data-full="${addr.fullAddress}"
                                            ${addr.isDefault ? 'selected' : ''}>
                                        ${addr.isDefault ? '⭐ [Mặc định] ' : '📍 '}${addr.recipientName} - ${addr.phone} (${addr.fullAddress})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </c:if>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">
                        <div>
                            <label class="block font-label-bold text-sm text-on-surface mb-1.5">Họ và tên người nhận <span class="text-error">*</span></label>
                            <input type="text" id="fullName" name="fullName" required value="${sessionScope.USERMODEL != null ? sessionScope.USERMODEL.fullName : ''}"
                                   class="w-full px-4 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm">
                        </div>
                        <div>
                            <label class="block font-label-bold text-sm text-on-surface mb-1.5">Số điện thoại liên hệ <span class="text-error">*</span></label>
                            <input type="tel" id="phone" name="phone" required value="${sessionScope.USERMODEL != null ? sessionScope.USERMODEL.phone : ''}"
                                   placeholder="VD: 0988888888"
                                   class="w-full px-4 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm">
                        </div>
                    </div>

                    <div class="mb-5">
                        <label class="block font-label-bold text-sm text-on-surface mb-1.5">
                            Địa chỉ Email <span class="text-xs font-normal text-on-surface-variant">(Thành viên nhận thông báo giao hàng qua Gmail; Khách vãng lai có thể để trống)</span>
                        </label>
                        <c:choose>
                            <c:when test="${not empty sessionScope.USERMODEL}">
                                <input type="email" name="email" readonly value="${sessionScope.USERMODEL.email}"
                                       class="w-full px-4 py-2.5 rounded-xl border border-outline-variant bg-surface-container-low text-on-surface-variant cursor-not-allowed text-sm">
                            </c:when>
                            <c:otherwise>
                                <input type="email" name="email" placeholder="example@email.com (Không bắt buộc với khách vãng lai)"
                                       class="w-full px-4 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="mb-2">
                        <label class="block font-label-bold text-sm text-on-surface mb-1.5">Địa chỉ giao hàng chi tiết <span class="text-error">*</span></label>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-3 mb-3">
                            <select id="province" class="w-full px-3 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-xs">
                                <option value="">-- Chọn Tỉnh/Thành --</option>
                            </select>
                            <select id="district" class="w-full px-3 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-xs" disabled>
                                <option value="">-- Chọn Quận/Huyện --</option>
                            </select>
                            <select id="ward" class="w-full px-3 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-xs" disabled>
                                <option value="">-- Chọn Phường/Xã --</option>
                            </select>
                        </div>

                        <input type="text" id="street" name="street" placeholder="Số nhà, tên ngõ, tên đường..." class="w-full px-4 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm mb-2">
                        <input type="hidden" name="address" id="fullAddress" value="${sessionScope.USERMODEL != null ? sessionScope.USERMODEL.address : ''}" required>

                        <c:if test="${not empty sessionScope.USERMODEL}">
                            <div class="mt-2 flex items-center gap-2">
                                <input type="checkbox" name="saveAddress" id="saveAddress" value="1" class="w-4 h-4 text-primary focus:ring-primary border-outline-variant rounded">
                                <label for="saveAddress" class="text-xs text-on-surface-variant cursor-pointer select-none">
                                    Lưu địa chỉ này vào sổ địa chỉ để sử dụng cho các lần mua tiếp theo
                                </label>
                            </div>
                        </c:if>
                    </div>

                    <!-- LIVE SHIPPING ESTIMATION BADGE -->
                    <div id="shippingInfoCard" class="mt-5 p-4 rounded-2xl bg-gradient-to-r from-primary/5 via-primary/10 to-primary/5 border border-primary/20 space-y-3 transition-all">
                        <div class="flex items-center justify-between flex-wrap gap-2">
                            <div class="flex items-center gap-2 text-primary font-label-bold text-sm">
                                <span class="material-symbols-outlined text-xl animate-pulse">local_shipping</span>
                                <span>Tính cước vận chuyển tự động theo khoảng cách</span>
                            </div>
                            <span id="shippingBadgeTag" class="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-primary text-white shadow-xs">
                                Đang tính toán...
                            </span>
                        </div>

                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-2 text-xs">
                            <div class="p-2.5 bg-surface-container-lowest rounded-xl border border-surface-variant shadow-xs">
                                <span class="text-on-surface-variant block text-[10px]">Kho xuất hàng</span>
                                <span class="font-semibold text-on-surface line-clamp-1" title="Kho Trịnh Văn Bô, Nam Từ Liêm, HN">Fruitables Hà Nội</span>
                            </div>
                            <div class="p-2.5 bg-surface-container-lowest rounded-xl border border-surface-variant shadow-xs">
                                <span class="text-on-surface-variant block text-[10px]">Khoảng cách</span>
                                <span class="font-bold text-primary text-sm" id="shippingDistanceDisplay">-- km</span>
                            </div>
                            <div class="p-2.5 bg-surface-container-lowest rounded-xl border border-surface-variant shadow-xs">
                                <span class="text-on-surface-variant block text-[10px]">Khối lượng kiện</span>
                                <span class="font-bold text-on-surface text-sm" id="shippingWeightDisplay">-- kg</span>
                            </div>
                            <div class="p-2.5 bg-surface-container-lowest rounded-xl border border-surface-variant shadow-xs">
                                <span class="text-on-surface-variant block text-[10px]">Cước vận chuyển</span>
                                <span class="font-bold text-primary text-sm" id="shippingFeeDisplay">-- ₫</span>
                            </div>
                        </div>

                        <div class="text-[11px] text-on-surface-variant flex items-center gap-1.5 pt-0.5">
                            <span class="material-symbols-outlined text-sm text-primary">info</span>
                            <span id="shippingNoteText">Đang tải khoảng cách và bảng cước vận chuyển hoa quả tươi...</span>
                        </div>
                    </div>

                    <div class="mt-4">
                        <label class="block font-label-bold text-sm text-on-surface mb-1.5">Ghi chú đơn hàng (Tùy chọn)</label>
                        <textarea name="notes" rows="2" placeholder="Ví dụ: Giao giờ hành chính, chọn quả ngọt mọng nước, đóng gói hộp quà..."
                                  class="w-full px-4 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm"></textarea>
                    </div>
                </div>

                <!-- PHƯƠNG THỨC THANH TOÁN -->
                <div class="bg-surface-container-lowest p-6 md:p-8 rounded-2xl shadow-sm border border-outline-variant">
                    <h2 class="font-headline-md text-lg text-on-surface mb-6 border-b border-surface-variant pb-3 font-bold">2. Phương thức thanh toán</h2>
                    <div class="space-y-3">
                        <label class="flex items-center p-4 border border-outline-variant rounded-xl cursor-pointer hover:bg-surface-container transition-colors">
                            <input type="radio" name="paymentMethod" value="COD" checked class="w-4 h-4 text-primary focus:ring-primary border-outline-variant">
                            <span class="ml-3 font-label-bold text-on-surface text-sm flex items-center gap-2">
                                <span class="material-symbols-outlined text-primary">local_shipping</span> Thanh toán tiền mặt khi nhận hàng (COD)
                            </span>
                        </label>

                        <label class="flex items-center p-4 border border-outline-variant rounded-xl cursor-pointer hover:bg-surface-container transition-colors">
                            <input type="radio" name="paymentMethod" value="VNPAY" class="w-4 h-4 text-primary focus:ring-primary border-outline-variant">
                            <span class="ml-3 font-label-bold text-on-surface text-sm flex items-center gap-2">
                                <span class="material-symbols-outlined text-primary">qr_code_scanner</span> Quét mã VNPAY-QR (Hỗ trợ tất cả ngân hàng)
                            </span>
                        </label>

                        <label class="flex items-center p-4 border border-outline-variant rounded-xl cursor-pointer hover:bg-surface-container transition-colors">
                            <input type="radio" name="paymentMethod" value="MOMO" class="w-4 h-4 text-primary focus:ring-primary border-outline-variant">
                            <span class="ml-3 font-label-bold text-on-surface text-sm flex items-center gap-2">
                                <span class="material-symbols-outlined text-[#a50064]">account_balance_wallet</span> Thanh toán trực tuyến qua Ví MoMo
                            </span>
                        </label>
                    </div>
                </div>
            </div>

            <!-- CỘT PHẢI: Box Tóm tắt đơn hàng & Xác nhận -->
            <div class="w-full lg:w-1/3 flex flex-col gap-6 sticky top-28">
                <div class="bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-outline-variant">
                    <h3 class="font-headline-md text-lg text-on-surface border-b border-surface-variant pb-3 mb-4 font-bold">Đơn hàng của bạn</h3>

                    <div class="space-y-3 mb-5 border-b border-surface-variant pb-4 max-h-64 overflow-y-auto">
                        <c:set var="totalAmount" value="0"/>
                        <c:set var="totalTaxValue" value="0"/>

                        <c:forEach var="item" items="${sessionScope.CART.values()}">
                            <c:set var="totalAmount" value="${totalAmount + item.subTotal}"/>
                            <c:set var="totalTaxValue" value="${totalTaxValue + (item.taxAmount != null ? item.taxAmount : 0)}"/>

                            <div class="flex justify-between items-center text-xs">
                                <div class="flex items-center gap-2.5">
                                    <div class="relative w-11 h-11 rounded-lg border border-outline-variant overflow-hidden flex-shrink-0">
                                        <img src="${item.imageUrl}" class="w-full h-full object-cover">
                                        <span class="absolute -top-1 -right-1 bg-surface-variant text-on-surface-variant text-[9px] w-4 h-4 flex items-center justify-center rounded-full font-bold">
                                            <c:out value="${item.quantity}"/>
                                        </span>
                                    </div>
                                    <div class="flex flex-col">
                                        <span class="font-medium text-on-surface line-clamp-1 max-w-[150px]"><c:out value="${item.name}"/></span>
                                        <span class="text-[10px] text-on-surface-variant">
                                            <c:if test="${item.storageType == 'COLD_CHAIN'}">❄️ Ướp lạnh</c:if>
                                            <c:if test="${item.storageType == 'FRAGILE_GIFT'}">🎁 Hộp quà</c:if>
                                            <c:if test="${item.isFreeShipping}">⚡ Freeship</c:if>
                                        </span>
                                    </div>
                                </div>
                                <span class="font-label-bold text-on-surface whitespace-nowrap">
                                    <fmt:formatNumber value="${item.subTotal}" type="number" groupingUsed="true"/> ₫
                                </span>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- KHỐI TÍNH TOÁN TIỀN HÀNG, THUẾ, GIẢM GIÁ & PHÍ SHIP -->
                    <c:set var="discount" value="${sessionScope.DISCOUNT_AMOUNT != null ? sessionScope.DISCOUNT_AMOUNT : 0}"/>
                    <c:set var="isFreeshipCoupon" value="${sessionScope.APPLIED_COUPON_TYPE == 'FREESHIP'}"/>
                    <c:set var="merchDiscount" value="${isFreeshipCoupon ? 0 : discount}"/>
                    <c:set var="initialGrandTotal" value="${(totalAmount + totalTaxValue - merchDiscount) > 0 ? (totalAmount + totalTaxValue - merchDiscount) : 0}"/>

                    <div class="space-y-2.5 text-xs text-on-surface-variant mb-4 border-b border-surface-variant pb-4">
                        <div class="flex justify-between items-center">
                            <span>Tạm tính hàng hóa</span>
                            <span class="font-semibold text-on-surface" id="summarySubTotal" data-value="${totalAmount}">
                                <fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true"/> ₫
                            </span>
                        </div>

                        <div class="flex justify-between items-center text-error">
                            <span>Thuế VAT tính thêm</span>
                            <span class="font-semibold" id="summaryTax" data-value="${totalTaxValue}">
                                + <fmt:formatNumber value="${totalTaxValue}" type="number" groupingUsed="true"/> ₫
                            </span>
                        </div>

                        <!-- HIỂN THỊ TIỀN ĐÃ TRỪ TỪ MÃ GIẢM GIÁ HÀNG HÓA (NẾU CÓ - KHÔNG PHẢI FREESHIP) -->
                        <c:if test="${not isFreeshipCoupon && discount > 0}">
                            <div class="flex justify-between items-center text-emerald-600 font-semibold">
                                <span class="flex items-center gap-1">
                                    <span class="material-symbols-outlined text-xs">sell</span> Mã giảm giá (${sessionScope.APPLIED_COUPON_CODE})
                                </span>
                                <span>- <fmt:formatNumber value="${discount}" type="number" groupingUsed="true"/> ₫</span>
                            </div>
                        </c:if>

                        <div class="flex justify-between items-center">
                            <span class="flex items-center gap-1">
                                <span>Phí vận chuyển</span>
                                <span id="summaryDistanceLabel" class="text-[10px] text-on-surface-variant"></span>
                            </span>
                            <span class="font-semibold text-on-surface" id="summaryRawShippingFee">0 ₫</span>
                        </div>

                        <!-- Giảm giá phí ship (Freeship coupon hoặc tự động) -->
                        <div id="rowShippingDiscount" class="flex justify-between items-center text-emerald-600 font-semibold hidden">
                            <span class="flex items-center gap-1">
                                <span class="material-symbols-outlined text-xs">local_shipping</span> Giảm phí ship
                                <c:if test="${isFreeshipCoupon}">(${sessionScope.APPLIED_COUPON_CODE})</c:if>
                            </span>
                            <span id="summaryShippingDiscount">- 0 ₫</span>
                        </div>
                    </div>

                    <!-- TỔNG TIỀN CUỐI CÙNG ĐÃ TRỪ GIẢM GIÁ VÀ CỘNG SHIP -->
                    <div class="flex justify-between items-center mb-6">
                        <span class="font-label-bold text-on-surface text-sm">Tổng thanh toán</span>
                        <span class="font-price-tag text-2xl text-primary font-extrabold" id="summaryGrandTotal">
                            <fmt:formatNumber value="${initialGrandTotal}" type="number" groupingUsed="true"/> ₫
                        </span>
                    </div>

                    <button type="submit" id="btnSubmitOrder" class="w-full flex items-center justify-center bg-primary text-white py-3.5 rounded-full font-label-bold text-base hover:bg-primary-container transition-all shadow-md hover:-translate-y-0.5">
                        Xác nhận đặt hàng
                    </button>
                </div>
            </div>
        </form>
    </div>
</main>

<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.6.2/axios.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const provinceSelect = document.getElementById('province');
        const districtSelect = document.getElementById('district');
        const wardSelect = document.getElementById('ward');
        const streetInput = document.getElementById('street');
        const fullAddressInput = document.getElementById('fullAddress');
        const fullNameInput = document.getElementById('fullName');
        const phoneInput = document.getElementById('phone');
        const savedAddressSelect = document.getElementById('savedAddressSelect');
        const btnNewAddress = document.getElementById('btnNewAddress');

        const inputShippingFee = document.getElementById('inputShippingFee');
        const inputDistanceKm = document.getElementById('inputDistanceKm');
        const inputShippingDiscount = document.getElementById('inputShippingDiscount');
        const inputProvinceName = document.getElementById('inputProvinceName');
        const inputDistrictName = document.getElementById('inputDistrictName');
        const inputWardName = document.getElementById('inputWardName');

        const shippingDistanceDisplay = document.getElementById('shippingDistanceDisplay');
        const shippingWeightDisplay = document.getElementById('shippingWeightDisplay');
        const shippingFeeDisplay = document.getElementById('shippingFeeDisplay');
        const shippingBadgeTag = document.getElementById('shippingBadgeTag');
        const shippingNoteText = document.getElementById('shippingNoteText');

        const summarySubTotalEl = document.getElementById('summarySubTotal');
        const summaryTaxEl = document.getElementById('summaryTax');
        const summaryDistanceLabel = document.getElementById('summaryDistanceLabel');
        const summaryRawShippingFee = document.getElementById('summaryRawShippingFee');
        const rowShippingDiscount = document.getElementById('rowShippingDiscount');
        const summaryShippingDiscount = document.getElementById('summaryShippingDiscount');
        const summaryGrandTotal = document.getElementById('summaryGrandTotal');

        const baseMerchSubTotal = parseFloat(summarySubTotalEl?.getAttribute('data-value') || '0');
        const baseTax = parseFloat(summaryTaxEl?.getAttribute('data-value') || '0');
        const isFreeshipCoupon = ${isFreeshipCoupon ? 'true' : 'false'};
        const merchDiscount = parseFloat('${merchDiscount != null ? merchDiscount : 0}') || 0;

        let provincesData = [];
        let calcTimeout = null;

        function formatCurrency(num) {
            return new Intl.NumberFormat('vi-VN').format(Math.round(num)) + ' ₫';
        }

        // Tải danh sách Tỉnh/Thành từ Open API
        axios.get('https://provinces.open-api.vn/api/?depth=3')
            .then(res => {
                provincesData = res.data;
                provincesData.forEach(p => provinceSelect.add(new Option(p.name, p.code)));

                provinceSelect.addEventListener('change', function() {
                    districtSelect.length = 1;
                    wardSelect.length = 1;
                    districtSelect.disabled = false;
                    wardSelect.disabled = true;

                    const selProvince = provincesData.find(p => p.code == this.value);
                    if (selProvince) {
                        selProvince.districts.forEach(d => districtSelect.add(new Option(d.name, d.code)));
                    }
                    updateFullAddress();
                    scheduleShippingCalculation();
                });

                districtSelect.addEventListener('change', function() {
                    wardSelect.length = 1;
                    wardSelect.disabled = false;

                    const selProvince = provincesData.find(p => p.code == provinceSelect.value);
                    const selDistrict = selProvince?.districts.find(d => d.code == this.value);
                    if (selDistrict) {
                        selDistrict.wards.forEach(w => wardSelect.add(new Option(w.name, w.code)));
                    }
                    updateFullAddress();
                    scheduleShippingCalculation();
                });

                wardSelect.addEventListener('change', function() {
                    updateFullAddress();
                    scheduleShippingCalculation();
                });

                streetInput.addEventListener('input', function() {
                    updateFullAddress();
                    scheduleShippingCalculation();
                });

                // Kiểm tra xem có default saved address không
                if (savedAddressSelect && savedAddressSelect.value) {
                    applySavedAddress(savedAddressSelect.options[savedAddressSelect.selectedIndex]);
                } else {
                    // Mặc định tính ship ngay cho khu vực nội thành
                    requestShippingCalculation();
                }
            })
            .catch(err => {
                console.warn('Lỗi tải danh mục Tỉnh Thành từ CDN:', err);
                requestShippingCalculation();
            });

        // Xử lý khi chọn từ sổ địa chỉ đã lưu
        if (savedAddressSelect) {
            savedAddressSelect.addEventListener('change', function() {
                if (this.value) {
                    const opt = this.options[this.selectedIndex];
                    applySavedAddress(opt);
                }
            });
        }

        if (btnNewAddress) {
            btnNewAddress.addEventListener('click', function() {
                if (savedAddressSelect) savedAddressSelect.value = '';
                provinceSelect.value = '';
                districtSelect.length = 1;
                districtSelect.disabled = true;
                wardSelect.length = 1;
                wardSelect.disabled = true;
                streetInput.value = '';
                fullAddressInput.value = '';
                inputProvinceName.value = '';
                inputDistrictName.value = '';
                inputWardName.value = '';
                requestShippingCalculation();
            });
        }

        function applySavedAddress(opt) {
            const recipient = opt.getAttribute('data-recipient');
            const phone = opt.getAttribute('data-phone');
            const province = opt.getAttribute('data-province');
            const district = opt.getAttribute('data-district');
            const ward = opt.getAttribute('data-ward');
            const street = opt.getAttribute('data-street');
            const full = opt.getAttribute('data-full');

            if (recipient && fullNameInput) fullNameInput.value = recipient;
            if (phone && phoneInput) phoneInput.value = phone;
            if (full && fullAddressInput) fullAddressInput.value = full;
            if (street && streetInput) streetInput.value = street;

            inputProvinceName.value = province || '';
            inputDistrictName.value = district || '';
            inputWardName.value = ward || '';

            requestShippingCalculation(opt.value, province, district, ward, street);
        }

        function updateFullAddress() {
            const provinceName = provinceSelect.options[provinceSelect.selectedIndex]?.text || '';
            const districtName = districtSelect.options[districtSelect.selectedIndex]?.text || '';
            const wardName = wardSelect.options[wardSelect.selectedIndex]?.text || '';
            const street = streetInput.value.trim();

            inputProvinceName.value = provinceSelect.value ? provinceName : '';
            inputDistrictName.value = districtSelect.value ? districtName : '';
            inputWardName.value = wardSelect.value ? wardName : '';

            let finalAddress = [];
            if (street) finalAddress.push(street);
            if (wardSelect.value) finalAddress.push(wardName);
            if (districtSelect.value) finalAddress.push(districtName);
            if (provinceSelect.value) finalAddress.push(provinceName);

            if (finalAddress.length > 0) {
                fullAddressInput.value = finalAddress.join(', ');
            }
        }

        function scheduleShippingCalculation() {
            if (calcTimeout) clearTimeout(calcTimeout);
            calcTimeout = setTimeout(() => {
                requestShippingCalculation();
            }, 350);
        }

        function requestShippingCalculation(addressId, province, district, ward, street) {
            const pName = province || inputProvinceName.value || '';
            const dName = district || inputDistrictName.value || '';
            const wName = ward || inputWardName.value || '';
            const sName = street || streetInput.value.trim() || '';
            const addrId = addressId || (savedAddressSelect ? savedAddressSelect.value : '');

            const params = new URLSearchParams();
            if (addrId) params.append('addressId', addrId);
            if (pName) params.append('province', pName);
            if (dName) params.append('district', dName);
            if (wName) params.append('ward', wName);
            if (sName) params.append('street', sName);

            shippingBadgeTag.innerText = 'Đang tính toán...';
            shippingBadgeTag.className = 'px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-amber-500 text-white';

            fetch('${pageContext.request.contextPath}/api/calculate-shipping?' + params.toString())
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        renderShippingResult(data);
                    } else {
                        console.warn(data.message);
                    }
                })
                .catch(err => {
                    console.error('Lỗi gọi API tính phí ship:', err);
                });
        }

        function renderShippingResult(data) {
            const dist = data.distanceKm || 0;
            const weightKg = ((data.totalWeightGram || 0) / 1000).toFixed(1);
            const rawFee = data.rawShippingFee || 0;
            const shipDiscount = data.shippingDiscount || 0;
            const finalFee = data.finalShippingFee || 0;

            // Cập nhật Hidden Fields cho Form Submit
            inputShippingFee.value = rawFee;
            inputDistanceKm.value = dist;
            inputShippingDiscount.value = shipDiscount;

            // Cập nhật Card Ước tính vận chuyển
            shippingDistanceDisplay.innerText = dist + ' km';
            shippingWeightDisplay.innerText = weightKg + ' kg';
            shippingFeeDisplay.innerText = finalFee === 0 ? 'Miễn phí' : formatCurrency(finalFee);

            if (finalFee === 0) {
                shippingBadgeTag.innerText = 'Freeship';
                shippingBadgeTag.className = 'px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-emerald-600 text-white shadow-xs';
            } else if (dist <= 15) {
                shippingBadgeTag.innerText = 'Giao hỏa tốc 1-2h';
                shippingBadgeTag.className = 'px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-primary text-white shadow-xs';
            } else {
                shippingBadgeTag.innerText = 'Giao tiêu chuẩn';
                shippingBadgeTag.className = 'px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-sky-600 text-white shadow-xs';
            }

            if (data.note) {
                shippingNoteText.innerText = data.note;
            } else {
                shippingNoteText.innerText = 'Khoảng cách ~' + dist + 'km từ kho tổng Fruitables Nam Từ Liêm đến điểm giao.';
            }

            // Cập nhật Tóm tắt đơn hàng bên phải
            summaryDistanceLabel.innerText = '(' + dist + ' km)';
            summaryRawShippingFee.innerText = formatCurrency(rawFee);

            if (shipDiscount > 0) {
                rowShippingDiscount.classList.remove('hidden');
                summaryShippingDiscount.innerText = '- ' + formatCurrency(shipDiscount);
            } else {
                rowShippingDiscount.classList.add('hidden');
            }

            // Tính Tổng thanh toán cuối cùng
            const calculatedGrandTotal = Math.max(0, (baseMerchSubTotal + baseTax - merchDiscount + finalFee));
            summaryGrandTotal.innerText = formatCurrency(calculatedGrandTotal);
        }
    });
</script>
</body>
</html>