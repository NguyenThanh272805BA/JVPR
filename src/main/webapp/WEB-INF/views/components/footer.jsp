<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="bg-surface-container py-12 border-t border-outline-variant mt-auto">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto grid grid-cols-1 md:grid-cols-4 gap-8">
        <div>
            <a class="font-display-lg text-headline-md font-extrabold text-primary block mb-4" href="${pageContext.request.contextPath}/home">Fruitables</a>
            <p class="text-on-surface-variant font-body-md text-sm">Hệ thống phân phối nông sản, hoa quả sạch chuẩn VietGAP số 1 Việt Nam. Đảm bảo tươi sạch mỗi ngày.</p>
        </div>
        <div>
            <h4 class="font-label-bold text-on-surface mb-4 text-base">Liên kết nhanh</h4>
            <ul class="space-y-2 text-on-surface-variant text-sm font-body-md">
                <li><a href="${pageContext.request.contextPath}/home" class="hover:text-primary transition-colors">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/shop" class="hover:text-primary transition-colors">Cửa hàng hoa quả</a></li>
                <li><a href="${pageContext.request.contextPath}/guest-tracking" class="hover:text-primary transition-colors">Tra cứu đơn hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/promotions" class="hover:text-primary transition-colors">Chương trình khuyến mãi</a></li>
            </ul>
        </div>
        <div>
            <h4 class="font-label-bold text-on-surface mb-4 text-base">Hỗ trợ khách hàng</h4>
            <ul class="space-y-2 text-on-surface-variant text-sm font-body-md">
                <li class="flex items-center gap-2"><span class="material-symbols-outlined text-[18px]">location_on</span> Đây là dự án của sinh viên nên không có địa chỉ đâu</li>
                <li class="flex items-center gap-2"><span class="material-symbols-outlined text-[18px]">call</span> 0375162932 </li>
                <li class="flex items-center gap-2"><span class="material-symbols-outlined text-[18px]">mail</span> monimeo2807@gmail.com</li>
            </ul>
        </div>
        <div>
            <h4 class="font-label-bold text-on-surface mb-4 text-base">Đăng ký nhận tin</h4>
            <p class="text-on-surface-variant font-body-md text-sm mb-4">Nhận ngay thông báo ưu đãi và voucher mua hàng hấp dẫn.</p>
            <div class="flex">
                <input type="email" placeholder="Email của bạn..." class="w-full px-4 py-2 rounded-l-lg border border-outline-variant outline-none focus:border-primary text-sm bg-surface-container-lowest">
                <button class="bg-primary hover:bg-primary-container text-white px-4 rounded-r-lg transition-colors font-label-bold text-sm">Gửi</button>
            </div>
        </div>
    </div>
    <div class="border-t border-surface-variant mt-8 pt-6 text-center text-on-surface-variant text-xs font-body-md">
        <p>© 2026 Fruitables. All rights reserved.</p>
    </div>
</footer>