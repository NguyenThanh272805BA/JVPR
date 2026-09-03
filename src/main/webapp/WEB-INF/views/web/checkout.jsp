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

<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col antialiased">

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

        <form action="${pageContext.request.contextPath}/checkout" method="POST" class="flex flex-col lg:flex-row gap-8 items-start">
            <!-- CỘT TRÁI: Form điền thông tin khách hàng -->
            <div class="w-full lg:w-2/3 space-y-6">
                <div class="bg-surface-container-lowest p-6 md:p-8 rounded-2xl shadow-sm border border-outline-variant">
                    <h2 class="font-headline-md text-lg text-on-surface mb-6 border-b border-surface-variant pb-3 font-bold">1. Thông tin giao nhận hàng</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">
                        <div>
                            <label class="block font-label-bold text-sm text-on-surface mb-1.5">Họ và tên người nhận <span class="text-error">*</span></label>
                            <input type="text" name="fullName" required value="${sessionScope.USERMODEL != null ? sessionScope.USERMODEL.fullName : ''}"
                                   class="w-full px-4 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm">
                        </div>
                        <div>
                            <label class="block font-label-bold text-sm text-on-surface mb-1.5">Số điện thoại liên hệ <span class="text-error">*</span></label>
                            <input type="tel" name="phone" required value="${sessionScope.USERMODEL != null ? sessionScope.USERMODEL.phone : ''}"
                                   placeholder="VD: 0988888888"
                                   class="w-full px-4 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm">
                        </div>
                    </div>

                    <div class="mb-5">
                        <label class="block font-label-bold text-sm text-on-surface mb-1.5">Địa chỉ Email (Để nhận biên nhận & hóa đơn)</label>
                        <c:choose>
                            <c:when test="${not empty sessionScope.USERMODEL}">
                                <input type="email" name="email" readonly value="${sessionScope.USERMODEL.email}"
                                       class="w-full px-4 py-2.5 rounded-xl border border-outline-variant bg-surface-container-low text-on-surface-variant cursor-not-allowed text-sm">
                            </c:when>
                            <c:otherwise>
                                <input type="email" name="email" placeholder="example@email.com"
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

                        <input type="text" id="street" placeholder="Số nhà, tên ngõ, tên đường..." class="w-full px-4 py-2.5 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm mb-2">
                        <input type="hidden" name="address" id="fullAddress" value="${sessionScope.USERMODEL != null ? sessionScope.USERMODEL.address : ''}" required>

                        <c:if test="${not empty sessionScope.USERMODEL.address}">
                            <p class="text-xs text-primary font-label-bold mt-1.5 flex items-center gap-1">
                                <span class="material-symbols-outlined text-sm">home_pin</span> Địa chỉ hồ sơ: ${sessionScope.USERMODEL.address} (Có thể chọn lại nếu muốn giao tới nơi khác)
                            </p>
                        </c:if>
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
                                    <span class="font-medium text-on-surface line-clamp-1 max-w-[150px]"><c:out value="${item.name}"/></span>
                                </div>
                                <span class="font-label-bold text-on-surface whitespace-nowrap">
                                    <fmt:formatNumber value="${item.subTotal}" type="number" groupingUsed="true"/> ₫
                                </span>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="space-y-2.5 text-xs text-on-surface-variant mb-4 border-b border-surface-variant pb-4">
                        <div class="flex justify-between items-center">
                            <span>Tạm tính hàng hóa</span>
                            <span class="font-semibold text-on-surface"><fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true"/> ₫</span>
                        </div>
                        <div class="flex justify-between items-center text-error">
                            <span>Thuế VAT tính thêm</span>
                            <span class="font-semibold">+ <fmt:formatNumber value="${totalTaxValue}" type="number" groupingUsed="true"/> ₫</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span>Phí vận chuyển</span>
                            <span class="font-semibold text-primary">Miễn phí</span>
                        </div>
                    </div>

                    <div class="flex justify-between items-center mb-6">
                        <span class="font-label-bold text-on-surface text-sm">Tổng thanh toán</span>
                        <span class="font-price-tag text-2xl text-primary font-extrabold">
                            <fmt:formatNumber value="${totalAmount + totalTaxValue}" type="number" groupingUsed="true"/> ₫
                        </span>
                    </div>

                    <button type="submit" class="w-full flex items-center justify-center bg-primary text-white py-3.5 rounded-full font-label-bold text-base hover:bg-primary-container transition-all shadow-md hover:-translate-y-0.5">
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

        axios.get('https://provinces.open-api.vn/api/?depth=3')
            .then(res => {
                const data = res.data;
                data.forEach(p => provinceSelect.add(new Option(p.name, p.code)));

                provinceSelect.addEventListener('change', function() {
                    districtSelect.length = 1;
                    wardSelect.length = 1;
                    districtSelect.disabled = false;
                    wardSelect.disabled = true;

                    const selProvince = data.find(p => p.code == this.value);
                    if(selProvince) {
                        selProvince.districts.forEach(d => districtSelect.add(new Option(d.name, d.code)));
                    }
                    updateFullAddress();
                });

                districtSelect.addEventListener('change', function() {
                    wardSelect.length = 1;
                    wardSelect.disabled = false;

                    const selProvince = data.find(p => p.code == provinceSelect.value);
                    const selDistrict = selProvince?.districts.find(d => d.code == this.value);
                    if(selDistrict) {
                        selDistrict.wards.forEach(w => wardSelect.add(new Option(w.name, w.code)));
                    }
                    updateFullAddress();
                });

                wardSelect.addEventListener('change', updateFullAddress);
                streetInput.addEventListener('input', updateFullAddress);
            });

        function updateFullAddress() {
            const provinceName = provinceSelect.options[provinceSelect.selectedIndex]?.text || '';
            const districtName = districtSelect.options[districtSelect.selectedIndex]?.text || '';
            const wardName = wardSelect.options[wardSelect.selectedIndex]?.text || '';
            const street = streetInput.value.trim();

            let finalAddress = [];
            if (street) finalAddress.push(street);
            if (wardSelect.value) finalAddress.push(wardName);
            if (districtSelect.value) finalAddress.push(districtName);
            if (provinceSelect.value) finalAddress.push(provinceName);

            if (finalAddress.length > 0) {
                fullAddressInput.value = finalAddress.join(', ');
            }
        }
    });
</script>
</body>
</html>