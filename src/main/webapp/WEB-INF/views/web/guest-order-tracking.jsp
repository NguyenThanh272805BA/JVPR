<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Tra cứu đơn hàng - Fruitables</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-surface-container bg-pattern min-h-screen flex flex-col antialiased">
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<!-- HERO BANNER: 3D LOGISTICS & REALTIME TRACKING HUB -->
<section class="tilt-3d-stage relative w-full min-h-[360px] md:min-h-[420px] flex items-center overflow-hidden bg-gradient-to-br from-[#062410] via-[#0b3324] to-[#031910] py-10 md:py-14 perspective-1200 shadow-xl">
    <!-- Nền không gian sâu công nghệ giao vận tươi sáng hữu cơ -->
    <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-emerald-800/35 via-[#083020]/70 to-[#02150c] z-0"></div>
    <div class="absolute -top-24 -left-24 w-96 h-96 bg-primary/25 rounded-full blur-[110px] pointer-events-none animate-ambient-aura z-0"></div>
    <div class="absolute -bottom-24 right-10 w-[30rem] h-[30rem] bg-teal-400/20 rounded-full blur-[120px] pointer-events-none animate-ambient-aura z-0" style="animation-delay: -3s;"></div>
    <div class="absolute inset-0 bg-[radial-gradient(#10b981_1px,transparent_1px)] [background-size:28px_28px] opacity-15 pointer-events-none z-0"></div>

    <div class="relative z-10 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto w-full grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
        <!-- Cột trái: Tiêu đề & Cam kết -->
        <div class="lg:col-span-7 text-left space-y-4">
            <div class="inline-flex items-center gap-2 py-1 px-3.5 rounded-full bg-sky-500/20 text-sky-400 border border-sky-500/30 font-label-bold text-xs uppercase tracking-wider backdrop-blur-sm">
                <span class="w-2 h-2 rounded-full bg-sky-400 animate-ping"></span>
                <span>Hệ Thống Theo Dõi Đơn Hàng Real-time</span>
            </div>

            <h1 class="text-white font-display-lg text-3xl sm:text-4xl md:text-5xl font-black tracking-tight drop-shadow-lg leading-tight">
                Tra Cứu Tiến Độ &<br>
                <span class="bg-gradient-to-r from-sky-400 via-teal-300 to-emerald-400 bg-clip-text text-transparent">Hành Trình Giao Hàng</span>
            </h1>

            <p class="text-slate-300 font-body-lg text-sm md:text-base max-w-xl leading-relaxed">
                Kiểm tra chính xác đơn hàng hoa quả của bạn đang ở khâu nào: từ Tiếp nhận, Đóng gói ướp lạnh đến lúc Shipper hỏa tốc mang đến tận cửa nhà bạn.
            </p>

            <div class="flex flex-wrap gap-3 pt-2 text-xs text-slate-300">
                <div class="flex items-center gap-1.5 bg-white/10 px-3 py-1.5 rounded-xl backdrop-blur-md border border-white/10">
                    <span class="material-symbols-outlined text-sky-400 text-sm">ac_unit</span> Thùng xốp giữ lạnh 4°C
                </div>
                <div class="flex items-center gap-1.5 bg-white/10 px-3 py-1.5 rounded-xl backdrop-blur-md border border-white/10">
                    <span class="material-symbols-outlined text-emerald-400 text-sm">verified</span> Đồng kiểm khi nhận
                </div>
                <div class="flex items-center gap-1.5 bg-white/10 px-3 py-1.5 rounded-xl backdrop-blur-md border border-white/10">
                    <span class="material-symbols-outlined text-amber-400 text-sm">electric_bolt</span> Giao siêu tốc 1 - 2H
                </div>
            </div>
        </div>

        <!-- Cột phải: Thẻ 3D Live Delivery Status Card -->
        <div class="lg:col-span-5 flex justify-center relative">
            <div data-3d-tilt data-tilt-max="14" data-tilt-scale="1.03"
                 class="preserve-3d relative w-full max-w-[380px] rounded-3xl glass-card-3d-dark p-6 border border-sky-400/30 shadow-[0_25px_60px_rgba(14,165,233,0.2)] cursor-pointer">
                
                <div class="shimmer-layer"></div>

                <!-- Layer z-30: Header thẻ -->
                <div class="translate-z-30 flex items-center justify-between border-b border-white/15 pb-3 mb-4">
                    <div class="flex items-center gap-2">
                        <span class="w-8 h-8 rounded-full bg-sky-500/20 text-sky-400 flex items-center justify-center font-bold text-xs border border-sky-500/30">
                            <span class="material-symbols-outlined text-base">near_me</span>
                        </span>
                        <div>
                            <div class="text-xs font-bold text-white">Fruitables Express Hub</div>
                            <div class="text-[10px] text-slate-400">Điều phối giao vận thông minh</div>
                        </div>
                    </div>
                    <span class="px-2.5 py-0.5 rounded-full bg-emerald-500/20 text-emerald-300 text-[10px] font-bold border border-emerald-500/40">
                        GPS Active
                    </span>
                </div>

                <!-- Layer z-50: Hình ảnh shipper / delivery 3D minh họa -->
                <div class="translate-z-50 relative flex items-center justify-center my-3">
                    <div class="absolute w-40 h-40 bg-sky-500/20 rounded-full blur-2xl pointer-events-none animate-pulse"></div>
                    <img src="https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=600&auto=format&fit=crop" 
                         alt="Logistics Delivery 3D" 
                         class="w-64 h-36 object-cover rounded-2xl shadow-xl border border-white/20 transform -rotate-1 hover:rotate-0 transition-transform duration-500">
                </div>

                <!-- Layer z-40: Trạng thái tóm tắt -->
                <div class="translate-z-40 bg-white/10 backdrop-blur-md rounded-xl p-3 border border-white/15 flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <span class="w-2.5 h-2.5 rounded-full bg-emerald-400 animate-ping"></span>
                        <span class="text-xs text-slate-200 font-medium">Bảo đảm nguyên kiện tươi 100%</span>
                    </div>
                    <span class="text-[11px] font-bold text-sky-400">Đúng giờ</span>
                </div>

                <!-- Floating badges -->
                <div class="translate-z-60 absolute -top-3 -right-3 bg-gradient-to-r from-sky-500 to-teal-500 text-white text-[10px] font-bold px-3 py-1 rounded-full shadow-lg border border-white/30 animate-float-3d">
                    ⚡ Cập nhật theo thời gian thực
                </div>
            </div>
        </div>
    </div>
</section>

<main class="flex-grow pb-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">

        <!-- Flash messages -->
        <c:if test="${not empty sessionScope.ORDER_MESSAGE_SUCCESS}">
            <div class="max-w-xl mx-auto mb-6 p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 flex items-center gap-3 shadow-sm">
                <span class="material-symbols-outlined text-emerald-600 text-2xl">check_circle</span>
                <div class="flex-grow font-medium text-sm"><c:out value="${sessionScope.ORDER_MESSAGE_SUCCESS}"/></div>
            </div>
            <c:remove var="ORDER_MESSAGE_SUCCESS" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.ORDER_MESSAGE_ERROR}">
            <div class="max-w-xl mx-auto mb-6 p-4 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 flex items-center gap-3 shadow-sm">
                <span class="material-symbols-outlined text-rose-600 text-2xl">error</span>
                <div class="flex-grow font-medium text-sm"><c:out value="${sessionScope.ORDER_MESSAGE_ERROR}"/></div>
            </div>
            <c:remove var="ORDER_MESSAGE_ERROR" scope="session"/>
        </c:if>

        <!-- Form tra cứu -->
        <div class="max-w-xl mx-auto bg-surface-container-lowest p-6 md:p-8 rounded-2xl shadow-sm border border-outline-variant mb-12">
            <form action="${pageContext.request.contextPath}/guest-tracking" method="POST" class="space-y-4">
                <div>
                    <label class="block font-label-bold text-on-surface mb-1.5">Số điện thoại đã dùng để đặt hàng</label>
                    <input type="tel" name="phone" placeholder="Nhập số điện thoại đã dùng để đặt hàng (VD: 0375162932)" value="${param.phone}"
                           class="w-full px-4 py-3 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface text-sm">
                </div>
                <div class="text-center font-label-bold text-xs text-on-surface-variant">--- HOẶC ---</div>
                <div>
                    <label class="block font-label-bold text-on-surface mb-1.5">Mã đơn hàng của bạn</label>
                    <input type="text" name="orderCode" placeholder="Nhập mã đơn hàng của bạn (VD: ORD-1729000000)" value="${param.orderCode}"
                           class="w-full px-4 py-3 rounded-xl border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface uppercase text-sm">
                </div>
                <button type="submit" class="w-full bg-primary hover:bg-primary-container text-white py-3.5 rounded-xl font-label-bold text-base transition-all shadow-md mt-2 flex items-center justify-center gap-2">
                    <span class="material-symbols-outlined">search</span> Tra cứu ngay
                </button>
            </form>
        </div>

        <!-- Kết quả tra cứu -->
        <c:if test="${searched}">
            <div class="max-w-4xl mx-auto">
                <c:choose>
                    <c:when test="${not empty foundOrders}">
                        <h2 class="font-headline-md text-xl text-on-surface mb-6 font-bold flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary">inventory_2</span> Kết quả tìm thấy (${foundOrders.size()} đơn hàng)
                        </h2>
                        <div class="space-y-6">
                            <c:forEach var="order" items="${foundOrders}">
                                <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant shadow-sm space-y-4">
                                    <div class="flex flex-col md:flex-row md:items-center justify-between pb-4 border-b border-surface-variant gap-2">
                                        <div>
                                            <span class="text-xs text-on-surface-variant">Mã đơn hàng:</span>
                                            <span class="font-label-bold text-primary text-lg ml-1">${order.orderCode}</span>
                                            <span class="text-xs text-on-surface-variant block mt-1"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                        </div>
                                        <div>
                                            <c:choose>
                                                <c:when test="${order.status == 'COMPLETED'}"><span class="px-3 py-1 bg-green-100 text-green-700 rounded-full text-xs font-bold">Hoàn tất</span></c:when>
                                                <c:when test="${order.status == 'DELIVERED'}"><span class="px-3 py-1 bg-emerald-100 text-emerald-700 rounded-full text-xs font-bold">Giao thành công</span></c:when>
                                                <c:when test="${order.status == 'SHIPPING'}"><span class="px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-xs font-bold animate-pulse">Đang giao hàng</span></c:when>
                                                <c:when test="${order.status == 'PACKING'}"><span class="px-3 py-1 bg-indigo-100 text-indigo-700 rounded-full text-xs font-bold">Đang đóng gói & ướp lạnh</span></c:when>
                                                <c:when test="${order.status == 'CONFIRMED'}"><span class="px-3 py-1 bg-cyan-100 text-cyan-700 rounded-full text-xs font-bold">Đã xác nhận</span></c:when>
                                                <c:when test="${order.status == 'RETURNED'}"><span class="px-3 py-1 bg-purple-100 text-purple-700 rounded-full text-xs font-bold">Đơn hoàn hàng</span></c:when>
                                                <c:when test="${order.status == 'FAILED'}"><span class="px-3 py-1 bg-rose-100 text-rose-700 rounded-full text-xs font-bold">Giao thất bại</span></c:when>
                                                <c:when test="${order.status == 'CANCELLED'}"><span class="px-3 py-1 bg-red-100 text-red-700 rounded-full text-xs font-bold">Đã hủy</span></c:when>
                                                <c:otherwise><span class="px-3 py-1 bg-amber-100 text-amber-700 rounded-full text-xs font-bold">Đang xử lý</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- ORDER TRACKING STEPPER 5 BƯỚC HOA QUẢ TƯƠI -->
                                    <c:choose>
                                        <c:when test="${order.status == 'CANCELLED'}">
                                            <div class="p-4 rounded-xl bg-red-50 border border-red-200 text-red-700 text-xs flex items-center gap-3">
                                                <span class="material-symbols-outlined text-2xl text-red-600">cancel</span>
                                                <div>
                                                    <div class="font-bold">Đơn hàng này đã được hủy</div>
                                                    <p class="mt-0.5 text-red-600/80">Nếu bạn vẫn có nhu cầu mua trái cây, xin vui lòng đặt lại đơn mới hoặc liên hệ CSKH qua ô chat trực tuyến bên dưới.</p>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:when test="${order.status == 'RETURNED' || order.status == 'FAILED'}">
                                            <div class="p-4 rounded-xl bg-purple-50 border border-purple-200 text-purple-700 text-xs flex items-center gap-3">
                                                <span class="material-symbols-outlined text-2xl text-purple-600">assignment_return</span>
                                                <div>
                                                    <div class="font-bold">Đơn hàng giao không thành công / Hoàn kho</div>
                                                    <p class="mt-0.5 text-purple-600/80">Nhân viên CSKH Fruitables sẽ liên hệ lại với bạn qua số điện thoại để hỗ trợ giải quyết.</p>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Tính bước hiện tại: 1 = PENDING, 2 = CONFIRMED, 3 = PACKING, 4 = SHIPPING, 5 = DELIVERED/COMPLETED -->
                                            <c:set var="stepNum" value="1"/>
                                            <c:if test="${order.status == 'CONFIRMED'}"><c:set var="stepNum" value="2"/></c:if>
                                            <c:if test="${order.status == 'PACKING'}"><c:set var="stepNum" value="3"/></c:if>
                                            <c:if test="${order.status == 'SHIPPING'}"><c:set var="stepNum" value="4"/></c:if>
                                            <c:if test="${order.status == 'DELIVERED' || order.status == 'COMPLETED'}"><c:set var="stepNum" value="5"/></c:if>

                                            <div class="py-4 px-2">
                                                <div class="flex items-center justify-between relative">
                                                    <!-- Đường nối giữa các bước -->
                                                    <div class="absolute left-0 top-1/2 -translate-y-1/2 w-full h-1 bg-surface-variant z-0 rounded-full"></div>
                                                    <div class="absolute left-0 top-1/2 -translate-y-1/2 h-1 bg-primary z-0 rounded-full transition-all duration-500"
                                                         style="width: ${(stepNum - 1) * 25}%;"></div>

                                                    <!-- Bước 1: Đã đặt hàng -->
                                                    <div class="flex flex-col items-center relative z-10">
                                                        <div class="w-9 h-9 rounded-full flex items-center justify-center font-bold text-xs shadow-sm transition-all ${stepNum >= 1 ? 'bg-primary text-white ring-4 ring-primary/20' : 'bg-surface-container text-on-surface-variant'}">
                                                            <span class="material-symbols-outlined text-base">receipt</span>
                                                        </div>
                                                        <span class="text-[11px] font-label-bold mt-2 text-center ${stepNum >= 1 ? 'text-primary font-bold' : 'text-on-surface-variant'}">Đặt hàng</span>
                                                        <span class="text-[9px] text-on-surface-variant/70 hidden sm:block">Đã tiếp nhận</span>
                                                    </div>

                                                    <!-- Bước 2: Đã xác nhận -->
                                                    <div class="flex flex-col items-center relative z-10">
                                                        <div class="w-9 h-9 rounded-full flex items-center justify-center font-bold text-xs shadow-sm transition-all ${stepNum >= 2 ? 'bg-primary text-white ring-4 ring-primary/20' : 'bg-surface-container text-on-surface-variant'}">
                                                            <span class="material-symbols-outlined text-base">task_alt</span>
                                                        </div>
                                                        <span class="text-[11px] font-label-bold mt-2 text-center ${stepNum >= 2 ? 'text-primary font-bold' : 'text-on-surface-variant'}">Xác nhận</span>
                                                        <span class="text-[9px] text-on-surface-variant/70 hidden sm:block">Duyệt đơn</span>
                                                    </div>

                                                    <!-- Bước 3: Đóng gói & Ướp lạnh -->
                                                    <div class="flex flex-col items-center relative z-10">
                                                        <div class="w-9 h-9 rounded-full flex items-center justify-center font-bold text-xs shadow-sm transition-all ${stepNum >= 3 ? 'bg-primary text-white ring-4 ring-primary/20' : 'bg-surface-container text-on-surface-variant'}">
                                                            <span class="material-symbols-outlined text-base">inventory_2</span>
                                                        </div>
                                                        <span class="text-[11px] font-label-bold mt-2 text-center ${stepNum >= 3 ? 'text-primary font-bold' : 'text-on-surface-variant'}">Đóng gói</span>
                                                        <span class="text-[9px] text-on-surface-variant/70 hidden sm:block">Ướp lạnh tươi</span>
                                                    </div>

                                                    <!-- Bước 4: Đang giao hỏa tốc -->
                                                    <div class="flex flex-col items-center relative z-10">
                                                        <div class="w-9 h-9 rounded-full flex items-center justify-center font-bold text-xs shadow-sm transition-all ${stepNum == 4 ? 'bg-sky-600 text-white ring-4 ring-sky-200 animate-bounce' : (stepNum > 4 ? 'bg-primary text-white ring-4 ring-primary/20' : 'bg-surface-container text-on-surface-variant')}">
                                                            <span class="material-symbols-outlined text-base">local_shipping</span>
                                                        </div>
                                                        <span class="text-[11px] font-label-bold mt-2 text-center ${stepNum == 4 ? 'text-sky-700 font-bold' : (stepNum > 4 ? 'text-primary font-bold' : 'text-on-surface-variant')}">Đang giao</span>
                                                        <span class="text-[9px] ${stepNum == 4 ? 'text-sky-600 font-medium' : 'text-on-surface-variant/70'} hidden sm:block">1 - 2 giờ tới</span>
                                                    </div>

                                                    <!-- Bước 5: Giao thành công -->
                                                    <div class="flex flex-col items-center relative z-10">
                                                        <div class="w-9 h-9 rounded-full flex items-center justify-center font-bold text-xs shadow-sm transition-all ${stepNum >= 5 ? 'bg-emerald-600 text-white ring-4 ring-emerald-200' : 'bg-surface-container text-on-surface-variant'}">
                                                            <span class="material-symbols-outlined text-base">verified</span>
                                                        </div>
                                                        <span class="text-[11px] font-label-bold mt-2 text-center ${stepNum >= 5 ? 'text-emerald-700 font-bold' : 'text-on-surface-variant'}">Giao tận nơi</span>
                                                        <span class="text-[9px] ${stepNum >= 5 ? 'text-emerald-700 font-bold' : 'text-on-surface-variant/70'} hidden sm:block">Hoàn tất</span>
                                                    </div>
                                                </div>

                                                <!-- Banner thông tin bảo quản hoa quả khi đang giao -->
                                                <c:if test="${order.status == 'SHIPPING'}">
                                                    <div class="mt-4 p-3 rounded-xl bg-sky-50 border border-sky-200 text-sky-800 text-xs flex items-center gap-2.5">
                                                        <span class="material-symbols-outlined text-sky-600 text-xl flex-shrink-0 animate-spin">cyclone</span>
                                                        <div>
                                                            <strong class="font-bold">Đơn hàng hoa quả đang được Shipper hỏa tốc mang đến bạn!</strong>
                                                            <p class="text-[11px] text-sky-700 mt-0.5">Trái cây được bảo quản bằng thùng xốp giữ nhiệt. Shipper sẽ gọi điện trước khi đến, vui lòng giữ liên lạc.</p>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <c:if test="${order.status == 'DELIVERED' || order.status == 'COMPLETED'}">
                                                    <div class="mt-4 p-3 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-center gap-2.5">
                                                        <span class="material-symbols-outlined text-emerald-600 text-xl flex-shrink-0">check_circle</span>
                                                        <div>
                                                            <strong class="font-bold">Đơn hàng đã được giao thành công!</strong>
                                                            <p class="text-[11px] text-emerald-700 mt-0.5">Cảm ơn bạn đã lựa chọn hoa quả sạch và tươi ngon tại Fruitables. Chúc bạn ngon miệng!</p>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- DANH SÁCH SẢN PHẨM ĐÃ MUA KÈM HÌNH ẢNH -->
                                    <c:if test="${not empty order.details}">
                                        <div class="space-y-3 py-2 border-b border-surface-variant">
                                            <p class="text-xs font-label-bold text-on-surface-variant uppercase tracking-wider">Sản phẩm trong đơn hàng:</p>
                                            <c:forEach var="item" items="${order.details}">
                                                <div class="flex items-center gap-4 py-2">
                                                    <div class="w-16 h-16 rounded-lg border border-outline-variant overflow-hidden flex-shrink-0 bg-surface-container">
                                                        <img src="${item.productImageUrl}" alt="${item.productName}" class="w-full h-full object-cover">
                                                    </div>
                                                    <div class="flex-grow">
                                                        <h4 class="font-label-bold text-on-surface text-sm line-clamp-1 hover:text-primary">
                                                            <a href="${pageContext.request.contextPath}/product-detail?id=${item.productId}"><c:out value="${item.productName}"/></a>
                                                        </h4>
                                                        <p class="text-xs text-on-surface-variant mt-1">Số lượng: <span class="font-bold text-on-surface">x${item.quantity}</span></p>
                                                    </div>
                                                    <div class="font-price-tag text-sm text-on-surface font-semibold">
                                                        <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                                        <div>
                                            <p class="text-on-surface-variant">SĐT người nhận:</p>
                                            <p class="font-semibold text-on-surface">${order.phone}</p>
                                        </div>
                                        <div class="md:col-span-2">
                                            <p class="text-on-surface-variant">Địa chỉ giao:</p>
                                            <p class="font-semibold text-on-surface">${order.shippingAddress}</p>
                                        </div>
                                    </div>
                                    <div class="flex flex-col sm:flex-row justify-between items-end gap-4 pt-4 border-t border-surface-variant text-sm">
                                        <div>
                                            <span class="text-on-surface-variant">Phương thức:</span>
                                            <span class="font-medium text-on-surface">${order.paymentMethod}</span>
                                            <span class="ml-2 font-bold ${order.paymentStatus == 'PAID' ? 'text-primary' : 'text-error'}">(${order.paymentStatus == 'PAID' ? 'Đã thanh toán' : 'Chưa thanh toán'})</span>
                                        </div>
                                        <div class="flex items-center gap-4 flex-wrap">
                                            <div class="text-right">
                                                <span class="text-on-surface-variant mr-1">Tổng tiền:</span>
                                                <span class="font-price-tag text-lg text-primary font-bold"><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/> ₫</span>
                                            </div>

                                            <!-- Nút Hủy Đơn Hàng Dành Cho Khách Khi Đang PENDING -->
                                            <c:if test="${order.status == 'PENDING'}">
                                                <button type="button" onclick="openCancelModal('${order.id}', '${order.orderCode}', '${order.phone}')" class="px-4 py-2 bg-rose-50 hover:bg-rose-100 text-rose-600 hover:text-rose-700 border border-rose-200 rounded-full font-label-bold text-xs shadow-sm transition-all flex items-center gap-1 whitespace-nowrap">
                                                    <span class="material-symbols-outlined text-[16px]">cancel</span> Hủy đơn
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-surface-container-lowest p-12 rounded-xl text-center border border-outline-variant shadow-sm">
                            <span class="material-symbols-outlined text-5xl text-outline-variant mb-2">search_off</span>
                            <p class="font-label-bold text-on-surface text-lg">Không tìm thấy đơn hàng nào</p>
                            <p class="text-sm text-on-surface-variant mt-1">Vui lòng kiểm tra lại Số điện thoại hoặc Mã đơn hàng của bạn.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>
</main>

<!-- Modal Xác nhận Hủy Đơn Hàng cho Khách Vãng Lai -->
<div id="cancelOrderModal" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-center justify-center p-4 transition-opacity">
    <div class="bg-surface-container-lowest rounded-2xl max-w-md w-full p-6 shadow-2xl border border-outline-variant transform transition-transform">
        <div class="flex items-center justify-between pb-3 border-b border-surface-variant">
            <div class="flex items-center gap-2 text-rose-600">
                <span class="material-symbols-outlined text-2xl">warning</span>
                <h3 class="font-headline-md font-bold text-lg text-on-surface">Xác nhận hủy đơn hàng</h3>
            </div>
            <button type="button" onclick="closeCancelModal()" class="text-on-surface-variant hover:text-on-surface p-1 rounded-full hover:bg-surface-container">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/order/cancel" method="POST" class="mt-4 space-y-4">
            <input type="hidden" name="from" value="tracking">
            <input type="hidden" id="modalCancelOrderId" name="orderId" value="">
            <input type="hidden" id="modalCancelOrderCodeVal" name="orderCode" value="">
            <input type="hidden" id="modalCancelOrderPhoneVal" name="phone" value="">

            <p class="text-sm text-on-surface-variant">
                Bạn có chắc chắn muốn hủy đơn hàng <strong id="modalCancelOrderCode" class="text-primary"></strong>?
                Sau khi xác nhận hủy, đơn hàng sẽ chuyển sang trạng thái đã hủy và hoàn tồn kho sản phẩm.
            </p>

            <div>
                <label class="block text-xs font-label-bold text-on-surface-variant mb-2">Vui lòng chọn lý do hủy đơn:</label>
                <div class="space-y-2 text-sm text-on-surface">
                    <label class="flex items-center gap-2 p-2.5 rounded-lg border border-outline-variant hover:bg-surface-container cursor-pointer">
                        <input type="radio" name="reason" value="Muốn thay đổi địa chỉ hoặc số điện thoại" checked class="text-primary focus:ring-primary">
                        <span>Muốn thay đổi địa chỉ hoặc số điện thoại</span>
                    </label>
                    <label class="flex items-center gap-2 p-2.5 rounded-lg border border-outline-variant hover:bg-surface-container cursor-pointer">
                        <input type="radio" name="reason" value="Muốn đổi hoặc thêm sản phẩm khác" class="text-primary focus:ring-primary">
                        <span>Muốn đổi hoặc thêm sản phẩm khác</span>
                    </label>
                    <label class="flex items-center gap-2 p-2.5 rounded-lg border border-outline-variant hover:bg-surface-container cursor-pointer">
                        <input type="radio" name="reason" value="Tìm thấy giá tốt hơn ở nơi khác" class="text-primary focus:ring-primary">
                        <span>Tìm thấy giá tốt hơn ở nơi khác</span>
                    </label>
                    <label class="flex items-center gap-2 p-2.5 rounded-lg border border-outline-variant hover:bg-surface-container cursor-pointer">
                        <input type="radio" name="reason" value="Đặt nhầm hoặc không còn nhu cầu" class="text-primary focus:ring-primary">
                        <span>Đặt nhầm hoặc không còn nhu cầu</span>
                    </label>
                </div>
            </div>

            <div class="flex items-center justify-end gap-3 pt-3 border-t border-surface-variant">
                <button type="button" onclick="closeCancelModal()" class="px-4 py-2 rounded-full border border-outline-variant text-on-surface hover:bg-surface-container text-sm font-label-bold transition-colors">
                    Đóng
                </button>
                <button type="submit" class="px-5 py-2 rounded-full bg-rose-600 hover:bg-rose-700 text-white text-sm font-label-bold shadow-md transition-all flex items-center gap-1">
                    <span class="material-symbols-outlined text-[18px]">check</span> Đồng ý hủy đơn
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function openCancelModal(orderId, orderCode, phone) {
    document.getElementById('modalCancelOrderId').value = orderId;
    document.getElementById('modalCancelOrderCodeVal').value = orderCode;
    document.getElementById('modalCancelOrderPhoneVal').value = phone;
    document.getElementById('modalCancelOrderCode').textContent = orderCode;
    document.getElementById('cancelOrderModal').classList.remove('hidden');
}
function closeCancelModal() {
    document.getElementById('cancelOrderModal').classList.add('hidden');
}
</script>

<jsp:include page="/WEB-INF/views/components/footer.jsp" />
<script src="${pageContext.request.contextPath}/assets/web/js/banner-3d.js"></script>
</body>
</html>