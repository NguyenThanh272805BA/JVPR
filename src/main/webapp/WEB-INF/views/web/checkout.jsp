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

<!-- NAVBAR -->
<nav class="bg-surface w-full sticky top-0 shadow-sm z-50">
    <div class="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <a class="font-display-lg-mobile font-extrabold text-primary" href="${pageContext.request.contextPath}/home">Fruitables</a>
        <a href="${pageContext.request.contextPath}/cart" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors flex items-center">
            <span class="material-symbols-outlined mr-2">arrow_back</span>
            <span class="font-label-bold hidden md:inline">Quay lại Giỏ hàng</span>
        </a>
    </div>
</nav>

<!-- MAIN CHECKOUT CONTENT -->
<main class="flex-grow py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <h1 class="font-headline-md text-3xl text-on-surface mb-8 font-bold">Chi tiết thanh toán</h1>

        <!-- BANNER KHUYẾN KHÍCH ĐĂNG NHẬP DÀNH CHO KHÁCH VÃNG LAI -->
        <c:if test="${empty sessionScope.USERMODEL}">
            <div class="mb-8 bg-inverse-primary/20 border border-primary-container p-4 rounded-xl flex flex-col md:flex-row items-center justify-between gap-4 shadow-sm">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-primary rounded-full flex items-center justify-center text-white flex-shrink-0">
                        <span class="material-symbols-outlined">redeem</span>
                    </div>
                    <div>
                        <h4 class="font-label-bold text-on-surface text-lg">Bạn có mã giảm giá hoặc điểm tích lũy?</h4>
                        <p class="font-body-md text-on-surface-variant text-sm">Đăng nhập ngay để sử dụng ưu đãi và theo dõi đơn hàng dễ dàng hơn.</p>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/login" class="whitespace-nowrap px-6 py-2 bg-primary text-white font-label-bold rounded-full hover:bg-primary-container transition-colors shadow-md">
                    Đăng nhập ngay
                </a>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/checkout" method="POST" class="flex flex-col lg:flex-row gap-8">

            <!-- CỘT TRÁI: Form điền thông tin -->
            <div class="w-full lg:w-2/3 space-y-6">
                <div class="bg-surface-container-lowest p-6 md:p-8 rounded-xl shadow-sm border border-outline-variant">
                    <h2 class="font-headline-md text-xl text-on-surface mb-6 border-b border-surface-variant pb-4">Thông tin giao hàng</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <label class="block font-label-bold text-on-surface mb-2">Họ và tên *</label>
                            <input type="text" name="fullName" required value="${sessionScope.USERMODEL != null ? sessionScope.USERMODEL.fullName : ''}"
                                   class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface transition-colors">
                        </div>
                        <div>
                            <label class="block font-label-bold text-on-surface mb-2">Số điện thoại *</label>
                            <input type="tel" name="phone" required value="${sessionScope.USERMODEL != null ? sessionScope.USERMODEL.phone : ''}"
                                   class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface transition-colors">
                        </div>
                    </div>

                    <div class="mb-6">
                        <label class="block font-label-bold text-on-surface mb-2">Địa chỉ Email</label>
                        <c:choose>
                            <c:when test="${not empty sessionScope.USERMODEL}">
                                <!-- Đã đăng nhập -> Khóa ô Email -->
                                <input type="email" name="email" readonly value="${sessionScope.USERMODEL.email}"
                                       class="w-full px-4 py-3 rounded-lg border border-outline-variant bg-surface-container-low text-on-surface-variant cursor-not-allowed">
                            </c:when>
                            <c:otherwise>
                                <!-- Khách vãng lai -> Cho phép nhập Email -->
                                <input type="email" name="email" placeholder="Nhập địa chỉ email của bạn..."
                                       class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface transition-colors">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="mb-6">
                        <label class="block font-label-bold text-on-surface mb-2">Địa chỉ nhận hàng *</label>

                        <!-- 3 Dropdown chọn Tỉnh/Quận/Phường -->
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                            <select id="province" class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface">
                                <option value="">-- Chọn Tỉnh/Thành --</option>
                            </select>
                            <select id="district" class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface" disabled>
                                <option value="">-- Chọn Quận/Huyện --</option>
                            </select>
                            <select id="ward" class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface" disabled>
                                <option value="">-- Chọn Phường/Xã --</option>
                            </select>
                        </div>

                        <!-- Ô nhập số nhà -->
                        <input type="text" id="street" placeholder="Số nhà, tên đường, tòa nhà..." class="w-full px-4 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface mb-2">

                        <!-- Input ẩn để gộp toàn bộ chuỗi địa chỉ gửi về Servlet -->
                        <input type="hidden" name="address" id="fullAddress" value="${sessionScope.USERMODEL != null ? sessionScope.USERMODEL.address : ''}" required>

                        <!-- Hiển thị lại địa chỉ đã lưu (nếu có) -->
                        <c:if test="${not empty sessionScope.USERMODEL.address}">
                            <p class="text-sm text-primary font-label-bold mt-2">Địa chỉ mặc định: ${sessionScope.USERMODEL.address} (Bạn có thể chọn lại ở trên để thay đổi)</p>
                        </c:if>
                    </div>
                </div>

                <!-- PHƯƠNG THỨC THANH TOÁN -->
                <div class="bg-surface-container-lowest p-6 md:p-8 rounded-xl shadow-sm border border-outline-variant">
                    <h2 class="font-headline-md text-xl text-on-surface mb-6 border-b border-surface-variant pb-4">Phương thức thanh toán</h2>

                    <div class="space-y-4">
                        <!-- COD -->
                        <label class="flex items-center p-4 border border-outline-variant rounded-lg cursor-pointer hover:bg-surface-container transition-colors">
                            <input type="radio" name="paymentMethod" value="COD" checked class="w-5 h-5 text-primary focus:ring-primary border-outline-variant">
                            <span class="ml-4 font-label-bold text-on-surface flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary">local_shipping</span>
                                    Thanh toán khi nhận hàng (COD)
                                </span>
                        </label>

                        <!-- VNPAY -->
                        <label class="flex items-center p-4 border border-outline-variant rounded-lg cursor-pointer hover:bg-surface-container transition-colors">
                            <input type="radio" name="paymentMethod" value="VNPAY" class="w-5 h-5 text-primary focus:ring-primary border-outline-variant">
                            <span class="ml-4 font-label-bold text-on-surface flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary">qr_code_scanner</span>
                                    Thanh toán qua VNPAY-QR
                                </span>
                        </label>

                        <!-- MoMo -->
                        <label class="flex items-center p-4 border border-outline-variant rounded-lg cursor-pointer hover:bg-surface-container transition-colors">
                            <input type="radio" name="paymentMethod" value="MOMO" class="w-5 h-5 text-primary focus:ring-primary border-outline-variant">
                            <span class="ml-4 font-label-bold text-on-surface flex items-center gap-2">
                                    <span class="material-symbols-outlined text-[#a50064]">account_balance_wallet</span>
                                    Thanh toán qua Ví MoMo
                                </span>
                        </label>
                    </div>
                </div>
            </div>

            <!-- CỘT PHẢI: Box Tóm tắt đơn hàng -->
            <div class="w-full lg:w-1/3">
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-sm border border-outline-variant sticky top-28">
                    <h3 class="font-headline-md text-xl text-on-surface border-b border-surface-variant pb-4 mb-4">Đơn hàng của bạn</h3>

                    <!-- List Sản phẩm -->
                    <div class="space-y-4 mb-6 border-b border-surface-variant pb-6">
                        <c:set var="totalAmount" value="0"/>
                        <c:set var="totalTaxValue" value="0"/>

                        <c:forEach var="item" items="${sessionScope.CART.values()}">
                            <c:set var="totalAmount" value="${totalAmount + item.subTotal}"/>
                            <c:set var="totalTaxValue" value="${totalTaxValue + (item.taxAmount != null ? item.taxAmount : 0)}"/>

                            <div class="flex justify-between items-center">
                                <div class="flex items-center gap-3">
                                    <div class="relative w-12 h-12 rounded-md border border-outline-variant overflow-hidden">
                                        <img src="${item.imageUrl}" class="w-full h-full object-cover">
                                        <span class="absolute -top-1 -right-1 bg-surface-variant text-on-surface-variant text-[10px] w-4 h-4 flex items-center justify-center rounded-full font-bold">
                                                <c:out value="${item.quantity}"/>
                                            </span>
                                    </div>
                                    <span class="font-body-md text-on-surface line-clamp-1"><c:out value="${item.name}"/></span>
                                </div>
                                <span class="font-label-bold text-on-surface">
                                        <fmt:formatNumber value="${item.subTotal}" type="number" groupingUsed="true"/> ₫
                                    </span>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Tính tiền -->
                    <div class="flex justify-between items-center mb-4 text-on-surface-variant font-body-md">
                        <span>Tạm tính (chưa thuế)</span>
                        <span class="font-medium text-on-surface"><fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true"/> ₫</span>
                    </div>
                    <div class="flex justify-between items-center mb-4 text-error font-body-md">
                        <span>Thuế VAT áp dụng</span>
                        <span class="font-medium text-error">+ <fmt:formatNumber value="${totalTaxValue}" type="number" groupingUsed="true"/> ₫</span>
                    </div>
                    <div class="flex justify-between items-center mb-4 text-on-surface-variant font-body-md border-b border-surface-variant pb-4">
                        <span>Phí giao hàng</span>
                        <span class="font-medium text-on-surface">Miễn phí</span>
                    </div>

                    <div class="flex justify-between items-center mb-8">
                        <span class="font-label-bold text-on-surface text-lg">Tổng thanh toán</span>
                        <span class="font-price-tag text-2xl text-primary">
                                <fmt:formatNumber value="${totalAmount + totalTaxValue}" type="number" groupingUsed="true"/> ₫
                            </span>
                    </div>

                    <button type="submit" class="w-full flex items-center justify-center bg-primary-container text-white py-4 rounded-full font-label-bold hover:bg-primary transition-all duration-300 shadow-md hover:-translate-y-1">
                        Xác nhận đặt hàng
                    </button>
                </div>
            </div>
        </form>
    </div>
    <!-- BỘ KHUNG NHẬP VOUCHER -->
    <div class="mt-6 pt-6 border-t border-surface-variant">
        <label class="block font-label-bold text-on-surface mb-2">Mã giảm giá / Voucher</label>

        <c:choose>
            <%-- TRƯỜNG HỢP CHƯA ĐĂNG NHẬP: Bắt buộc đăng nhập để dùng voucher --%>
            <c:when test="${empty sessionScope.USERMODEL}">
                <div class="p-3 bg-surface-container rounded-lg text-sm text-on-surface-variant flex items-center justify-between">
                    <span>Đăng nhập để sử dụng Voucher độc quyền cho thành viên!</span>
                    <a href="${pageContext.request.contextPath}/login" class="text-primary font-label-bold hover:underline whitespace-nowrap ml-2">Đăng nhập</a>
                </div>
            </c:when>

            <%-- TRƯỜNG HỢP ĐÃ ĐĂNG NHẬP: Cho phép nhập mã voucher --%>
            <c:otherwise>
                <form action="${pageContext.request.contextPath}/apply-coupon" method="POST" class="flex gap-2">
                    <input type="text" name="couponCode" placeholder="Nhập mã (VD: FRUIT50K)"
                           class="flex-1 px-3 py-2 rounded-md border border-outline-variant outline-none focus:border-primary text-sm bg-surface-container-lowest">
                    <button type="submit" class="px-4 py-2 bg-primary text-white font-label-bold rounded-md hover:bg-primary-container transition-colors text-sm">
                        Áp dụng
                    </button>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.6.2/axios.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const provinceSelect = document.getElementById('province');
        const districtSelect = document.getElementById('district');
        const wardSelect = document.getElementById('ward');
        const streetInput = document.getElementById('street');
        const fullAddressInput = document.getElementById('fullAddress');

        // Gọi API lấy toàn bộ Tỉnh/Thành phố
        axios.get('https://provinces.open-api.vn/api/?depth=3')
            .then(response => {
                const data = response.data;
                data.forEach(province => {
                    provinceSelect.add(new Option(province.name, province.code));
                });

                // Khi đổi Tỉnh
                provinceSelect.addEventListener('change', function() {
                    districtSelect.length = 1;
                    wardSelect.length = 1;
                    districtSelect.disabled = false;
                    wardSelect.disabled = true;

                    const selectedProvince = data.find(p => p.code == this.value);
                    if(selectedProvince) {
                        selectedProvince.districts.forEach(district => {
                            districtSelect.add(new Option(district.name, district.code));
                        });
                    }
                    updateFullAddress();
                });

                // Khi đổi Quận/Huyện
                districtSelect.addEventListener('change', function() {
                    wardSelect.length = 1;
                    wardSelect.disabled = false;

                    const selectedProvince = data.find(p => p.code == provinceSelect.value);
                    const selectedDistrict = selectedProvince.districts.find(d => d.code == this.value);
                    if(selectedDistrict) {
                        selectedDistrict.wards.forEach(ward => {
                            wardSelect.add(new Option(ward.name, ward.code));
                        });
                    }
                    updateFullAddress();
                });

                // Khi đổi Phường hoặc gõ Số nhà
                wardSelect.addEventListener('change', updateFullAddress);
                streetInput.addEventListener('input', updateFullAddress);
            });

        // Hàm nối chuỗi địa chỉ
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

            // Cập nhật giá trị vào input ẩn để gửi đi
            fullAddressInput.value = finalAddress.join(', ');
        }
    });
</script>
</body>
</html>