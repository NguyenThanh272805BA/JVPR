<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Trang chủ - Fruitables</title>

    <!-- Dùng chung cấu hình Tailwind và Font -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>

<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col antialiased">

<!-- NAVBAR -->
<nav class="bg-surface w-full sticky top-0 shadow-sm z-50">
    <div class="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <!-- Brand -->
        <a class="font-display-lg-mobile md:font-display-lg text-display-lg-mobile md:text-display-lg font-extrabold text-primary" href="${pageContext.request.contextPath}/home">
            Fruitables
        </a>

        <!-- Menu Links -->
        <div class="hidden md:flex space-x-8 items-center">
            <a class="font-body-md text-primary font-semibold border-b-2 border-primary pb-1" href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/shop">Cửa hàng</a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="#">Khuyến mãi</a>
        </div>

        <!-- User Actions -->
        <div class="flex items-center space-x-4">
            <a href="${pageContext.request.contextPath}/cart" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors relative">
                <span class="material-symbols-outlined">shopping_cart</span>
                <!-- Hiển thị số lượng giỏ hàng LINH ĐỘNG từ Session -->
                <c:if test="${not empty sessionScope.CART_TOTAL_ITEMS && sessionScope.CART_TOTAL_ITEMS > 0}">
                    <span class="absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center">
                        <c:out value="${sessionScope.CART_TOTAL_ITEMS}"/>
                    </span>
                </c:if>
            </a>

            <c:choose>
                <c:when test="${not empty sessionScope.USERMODEL}">
                    <!-- Đã đăng nhập -->
                    <div class="group relative cursor-pointer py-2">
                        <div class="flex items-center gap-2 text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors">
                            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">account_circle</span>
                            <span class="font-label-bold text-label-bold hidden md:block"><c:out value="${sessionScope.USERMODEL.fullName}"/></span>
                        </div>
                        <div class="absolute right-0 top-full w-48 bg-surface-container-lowest rounded-md shadow-lg hidden group-hover:block border border-outline-variant z-50 overflow-hidden">
                            <c:if test="${sessionScope.USERMODEL.roleId == 1 || sessionScope.USERMODEL.roleId == 2}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="block px-4 py-3 text-on-surface hover:bg-surface-container transition-colors">Trang Quản Trị</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-3 text-error hover:bg-error-container transition-colors border-t border-surface-variant">Đăng xuất</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Chưa đăng nhập -->
                    <a href="${pageContext.request.contextPath}/login" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors" title="Đăng nhập">
                        <span class="material-symbols-outlined">person</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<!-- THÔNG BÁO ĐẶT HÀNG THÀNH CÔNG TỪ CHECKOUT -->
<c:if test="${not empty sessionScope.orderSuccess}">
    <div class="bg-primary-container text-white text-center py-3 px-4 font-label-bold shadow-md relative flex justify-center items-center">
        <span class="material-symbols-outlined align-middle mr-2">check_circle</span>
        <c:out value="${sessionScope.orderSuccess}"/>
        <!-- Xóa thông báo khỏi session sau khi hiển thị để F5 không bị hiện lại -->
        <c:remove var="orderSuccess" scope="session"/>
    </div>
</c:if>

<!-- HERO SECTION -->
<section class="relative w-full bg-surface-container h-[500px] flex items-center overflow-hidden">
    <div class="absolute inset-0 bg-cover bg-center" style="background-image: url('https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1974&auto=format&fit=crop');"></div>
    <div class="absolute inset-0 bg-gradient-to-r from-black/80 to-transparent"></div>

    <div class="relative z-10 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto w-full">
        <h1 class="text-white font-display-lg text-[40px] md:text-[56px] font-extrabold max-w-xl leading-tight mb-4">
            Thực phẩm sạch,<br>Sức khỏe vàng
        </h1>
        <p class="text-white/90 font-body-lg mb-8 max-w-lg">
            Fruitables cung cấp 100% trái cây và rau củ hữu cơ tươi ngon mỗi ngày. Giao hàng tận nơi trong 2 giờ.
        </p>
        <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center justify-center bg-primary-container text-white px-8 py-3 rounded-full font-label-bold text-label-bold hover:bg-primary transition-all duration-300 shadow-lg hover:-translate-y-1">
            Mua sắm ngay
            <span class="material-symbols-outlined ml-2 text-[20px]">arrow_forward</span>
        </a>
    </div>
</section>

<!-- FEATURES BANNERS -->
<section class="py-12 bg-surface">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto grid grid-cols-1 md:grid-cols-4 gap-6">
        <div class="bg-surface-container-lowest p-6 rounded-xl shadow-sm border border-outline-variant flex items-start gap-4">
            <div class="w-12 h-12 rounded-full bg-primary-container/20 flex items-center justify-center text-primary-container flex-shrink-0">
                <span class="material-symbols-outlined">local_shipping</span>
            </div>
            <div>
                <h3 class="font-label-bold text-label-bold text-on-surface mb-1">Miễn phí giao hàng</h3>
                <p class="text-sm text-on-surface-variant">Cho đơn hàng từ 500k</p>
            </div>
        </div>
        <div class="bg-surface-container-lowest p-6 rounded-xl shadow-sm border border-outline-variant flex items-start gap-4">
            <div class="w-12 h-12 rounded-full bg-secondary-container/50 flex items-center justify-center text-on-secondary-container flex-shrink-0">
                <span class="material-symbols-outlined">verified</span>
            </div>
            <div>
                <h3 class="font-label-bold text-label-bold text-on-surface mb-1">100% Hữu cơ</h3>
                <p class="text-sm text-on-surface-variant">Đạt chứng nhận VietGAP</p>
            </div>
        </div>
        <div class="bg-surface-container-lowest p-6 rounded-xl shadow-sm border border-outline-variant flex items-start gap-4">
            <div class="w-12 h-12 rounded-full bg-error-container/50 flex items-center justify-center text-error flex-shrink-0">
                <span class="material-symbols-outlined">currency_exchange</span>
            </div>
            <div>
                <h3 class="font-label-bold text-label-bold text-on-surface mb-1">Hoàn tiền 100%</h3>
                <p class="text-sm text-on-surface-variant">Nếu hàng không tươi</p>
            </div>
        </div>
        <div class="bg-surface-container-lowest p-6 rounded-xl shadow-sm border border-outline-variant flex items-start gap-4">
            <div class="w-12 h-12 rounded-full bg-tertiary-container/30 flex items-center justify-center text-tertiary flex-shrink-0">
                <span class="material-symbols-outlined">support_agent</span>
            </div>
            <div>
                <h3 class="font-label-bold text-label-bold text-on-surface mb-1">Hỗ trợ 24/7</h3>
                <p class="text-sm text-on-surface-variant">Luôn sẵn sàng giải đáp</p>
            </div>
        </div>
    </div>
</section>

<!-- FEATURED PRODUCTS -->
<section class="py-12 bg-background flex-grow">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <div class="flex justify-between items-end mb-8">
            <div>
                <h2 class="font-headline-md text-headline-md text-on-surface mb-2">Sản phẩm nổi bật</h2>
                <p class="font-body-md text-on-surface-variant">Những sản phẩm được yêu thích nhất tuần qua</p>
            </div>
            <a href="${pageContext.request.contextPath}/shop" class="hidden md:flex items-center text-primary font-label-bold hover:underline">
                Xem tất cả <span class="material-symbols-outlined ml-1 text-sm">arrow_forward_ios</span>
            </a>
        </div>

        <!-- Products Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <!-- LẶP DANH SÁCH SẢN PHẨM TỪ CONTROLLER -->
            <c:forEach var="item" items="${topProducts}">
                <div class="bg-surface-container-lowest rounded-xl shadow-sm hover:shadow-md transition-shadow border border-outline-variant overflow-hidden group">
                    <!-- Product Image -->
                    <div class="relative w-full h-56 bg-surface-container overflow-hidden">
                        <img src="${item.imageUrl}" alt="${item.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                        <div class="absolute top-3 left-3 bg-primary-container text-white text-xs font-bold px-2 py-1 rounded">
                            <c:out value="${item.categoryName}"/>
                        </div>
                    </div>

                    <!-- Product Info -->
                    <div class="p-5 flex flex-col h-full">
                        <h3 class="font-label-bold text-lg text-on-surface mb-2 line-clamp-1"><c:out value="${item.name}"/></h3>

                        <!-- Đánh giá sao (Mặc định tĩnh) -->
                        <div class="flex items-center mb-4">
                            <span class="material-symbols-outlined text-[16px] text-yellow-500" style="font-variation-settings: 'FILL' 1;">star</span>
                            <span class="material-symbols-outlined text-[16px] text-yellow-500" style="font-variation-settings: 'FILL' 1;">star</span>
                            <span class="material-symbols-outlined text-[16px] text-yellow-500" style="font-variation-settings: 'FILL' 1;">star</span>
                            <span class="material-symbols-outlined text-[16px] text-yellow-500" style="font-variation-settings: 'FILL' 1;">star</span>
                            <span class="material-symbols-outlined text-[16px] text-yellow-500" style="font-variation-settings: 'FILL' 1;">star_half</span>
                        </div>

                        <div class="mt-auto flex items-center justify-between">
                            <span class="font-price-tag text-price-tag text-primary">
                                <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                            </span>

                            <!-- FORM THÊM VÀO GIỎ HÀNG -->
                            <form action="${pageContext.request.contextPath}/cart" method="POST">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${item.id}">
                                <button type="submit" class="w-10 h-10 rounded-full border border-primary text-primary hover:bg-primary hover:text-white flex items-center justify-center transition-colors">
                                    <span class="material-symbols-outlined text-[20px]">add_shopping_cart</span>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Mobile View All Button -->
        <div class="mt-8 text-center md:hidden">
            <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center text-primary font-label-bold border border-primary px-6 py-2 rounded-full hover:bg-primary-container hover:text-white transition-colors">
                Xem tất cả sản phẩm
            </a>
        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="bg-surface-container py-12 border-t border-outline-variant mt-auto">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto grid grid-cols-1 md:grid-cols-3 gap-8">
        <div>
            <a class="font-display-lg text-headline-md font-extrabold text-primary block mb-4" href="#">Fruitables</a>
            <p class="text-on-surface-variant font-body-md">Hệ thống phân phối nông sản, hoa quả sạch số 1 Việt Nam. Đảm bảo 100% hữu cơ.</p>
        </div>
        <div>
            <h4 class="font-label-bold text-on-surface mb-4 text-lg">Liên hệ</h4>
            <ul class="space-y-2 text-on-surface-variant font-body-md">
                <li class="flex items-center gap-2"><span class="material-symbols-outlined text-[20px]">location_on</span> Đại học Công nghệ Đông Á</li>
                <li class="flex items-center gap-2"><span class="material-symbols-outlined text-[20px]">call</span> 1900 123 456</li>
                <li class="flex items-center gap-2"><span class="material-symbols-outlined text-[20px]">mail</span> cskh@fruitables.com</li>
            </ul>
        </div>
        <div>
            <h4 class="font-label-bold text-on-surface mb-4 text-lg">Đăng ký nhận tin</h4>
            <p class="text-on-surface-variant font-body-md mb-4">Nhận ngay mã giảm giá 50.000đ cho đơn hàng đầu tiên.</p>
            <div class="flex">
                <input type="email" placeholder="Email của bạn" class="w-full px-4 py-2 rounded-l-md border border-outline-variant outline-none focus:border-primary">
                <button class="bg-primary text-white px-4 rounded-r-md hover:bg-primary-container transition-colors">Gửi</button>
            </div>
        </div>
    </div>
</footer>
<!-- JAVASCRIPT AJAX ADD TO CART & TOAST NOTIFICATION -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Tìm tất cả các form gửi đến /cart
        const addCartForms = document.querySelectorAll('form[action$="/cart"]');

        addCartForms.forEach(form => {
            // Chỉ bắt sự kiện với những form có input action = add
            const actionInput = form.querySelector('input[name="action"][value="add"]');

            if (actionInput) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault(); // Chặn hành vi load lại trang mặc định

                    const formData = new FormData(this);
                    const data = new URLSearchParams(formData);

                    // Gửi request ngầm (Fetch API)
                    fetch(`${pageContext.request.contextPath}/api/add-to-cart`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: data.toString()
                    })
                        .then(response => response.json())
                        .then(res => {
                            if (res.status === 'success') {
                                updateCartBadge(res.totalItems);
                                showToast(res.message, 'success');
                            } else {
                                showToast(res.message, 'error');
                            }
                        })
                        .catch(err => {
                            console.error('Lỗi API:', err);
                            showToast('Có lỗi xảy ra, vui lòng thử lại.', 'error');
                        });
                });
            }
        });

        // Hàm 1: Cập nhật con số trên Navbar (Badge)
        function updateCartBadge(total) {
            // Tìm nút giỏ hàng trên Navbar
            const cartLink = document.querySelector('a[href$="/cart"]');
            if (cartLink) {
                let badge = cartLink.querySelector('span.bg-error');

                // Nếu chưa có badge (giỏ hàng đang 0), thì tạo mới HTML
                if (!badge) {
                    badge = document.createElement('span');
                    badge.className = 'absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center';
                    cartLink.appendChild(badge);
                }
                badge.textContent = total;
            }
        }

        // Hàm 2: Hiển thị thông báo Toast góc dưới màn hình
        function showToast(message, type) {
            let container = document.getElementById('toast-container');
            if (!container) {
                container = document.createElement('div');
                container.id = 'toast-container';
                container.className = 'fixed bottom-5 right-5 z-50 flex flex-col gap-3 pointer-events-none';
                document.body.appendChild(container);
            }

            const toast = document.createElement('div');
            // Cấu hình màu nền dựa trên trạng thái
            const bgColor = type === 'success' ? 'bg-primary' : 'bg-error';
            const icon = type === 'success' ? 'check_circle' : 'error';

            toast.className = `px-6 py-3 rounded-lg shadow-lg text-white font-label-bold transition-all duration-300 transform translate-y-10 opacity-0 flex items-center gap-2 ` + bgColor;
            toast.innerHTML = `<span class="material-symbols-outlined">` + icon + `</span> ` + message;

            container.appendChild(toast);

            // Kích hoạt Animation hiện lên
            requestAnimationFrame(() => {
                toast.classList.remove('translate-y-10', 'opacity-0');
                toast.classList.add('translate-y-0', 'opacity-100');
            });

            // Tự động tắt sau 3 giây
            setTimeout(() => {
                toast.classList.remove('translate-y-0', 'opacity-100');
                toast.classList.add('translate-y-10', 'opacity-0');
                setTimeout(() => toast.remove(), 300); // Xóa element sau khi fade out
            }, 3000);
        }
    });
</script>
</body>
</html>