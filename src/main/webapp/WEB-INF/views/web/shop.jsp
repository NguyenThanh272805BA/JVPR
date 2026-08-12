<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Cửa hàng - Fruitables</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>

<body class="bg-background text-on-background font-body-md min-h-screen flex flex-col antialiased">

<!-- NAVBAR -->
<nav class="bg-surface w-full sticky top-0 shadow-sm z-50">
    <div class="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <a class="font-display-lg-mobile md:font-display-lg text-display-lg-mobile md:text-display-lg font-extrabold text-primary" href="${pageContext.request.contextPath}/home">
            Fruitables
        </a>
        <div class="hidden md:flex space-x-8 items-center">
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <a class="font-body-md text-primary font-semibold border-b-2 border-primary pb-1" href="${pageContext.request.contextPath}/shop">Cửa hàng</a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="#">Khuyến mãi</a>
        </div>
        <div class="flex items-center space-x-4">
            <a href="${pageContext.request.contextPath}/cart" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors relative">
                <span class="material-symbols-outlined">shopping_cart</span>
                <span class="absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center">
                    ${not empty sessionScope.CART_TOTAL_ITEMS ? sessionScope.CART_TOTAL_ITEMS : 0}
                </span>
            </a>
            <c:choose>
                <c:when test="${not empty sessionScope.USERMODEL}">
                    <div class="group relative cursor-pointer">
                        <div class="flex items-center gap-2 text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors">
                            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">account_circle</span>
                        </div>
                        <div class="absolute right-0 mt-2 w-48 bg-surface-container-lowest rounded-md shadow-lg hidden group-hover:block border border-outline-variant">
                            <c:if test="${sessionScope.USERMODEL.roleId == 1 || sessionScope.USERMODEL.roleId == 2}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="block px-4 py-2 text-on-surface hover:bg-surface-container transition-colors">Trang Quản Trị</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-error hover:bg-error-container transition-colors">Đăng xuất</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors">
                        <span class="material-symbols-outlined">person</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<!-- SHOP HEADER -->
<div class="bg-primary-container text-white py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto text-center">
        <h1 class="font-display-lg text-4xl md:text-5xl font-extrabold mb-4">Cửa Hàng Trực Tuyến</h1>
        <p class="font-body-lg text-white/90">Khám phá các sản phẩm tươi sạch và an toàn nhất</p>
    </div>
</div>

<!-- MAIN SHOP CONTENT -->
<main class="flex-grow py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto flex flex-col md:flex-row gap-8">

        <!-- SIDEBAR -->
        <aside class="w-full md:w-1/4 flex flex-col gap-6">
            <!-- Tích hợp AJAX Live Search -->
            <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant">
                <h3 class="font-headline-md text-lg text-on-surface mb-4 border-b border-surface-variant pb-2">Tìm kiếm</h3>
                <div class="relative">
                    <form action="${pageContext.request.contextPath}/shop" method="GET" class="relative">
                        <input type="text" id="liveSearchInput" name="keyword" value="${keyword}" placeholder="Nhập tên sản phẩm..."
                               class="w-full pl-4 pr-10 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none font-body-md text-on-surface" autocomplete="off">
                        <button type="submit" class="absolute right-2 top-1/2 -translate-y-1/2 text-outline hover:text-primary">
                            <span class="material-symbols-outlined">search</span>
                        </button>
                    </form>

                    <!-- Khung chứa kết quả AJAX -->
                    <ul id="searchDropdown" class="absolute z-50 w-full bg-surface-container-lowest border border-outline-variant rounded-lg shadow-lg hidden mt-1 max-h-80 overflow-y-auto divide-y divide-surface-variant">
                    </ul>
                </div>
            </div>

            <!-- Danh mục -->
            <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant">
                <h3 class="font-headline-md text-lg text-on-surface mb-4 border-b border-surface-variant pb-2">Danh mục</h3>
                <ul class="space-y-3 font-body-md text-on-surface-variant">
                    <li>
                        <a href="${pageContext.request.contextPath}/shop" class="flex justify-between items-center hover:text-primary transition-colors">
                            <span>Tất cả sản phẩm</span>
                            <span class="bg-surface-container px-2 py-1 rounded text-xs">120</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?category=1" class="flex justify-between items-center hover:text-primary transition-colors">
                            <span>Hoa quả tươi</span>
                            <span class="bg-surface-container px-2 py-1 rounded text-xs">45</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?category=2" class="flex justify-between items-center hover:text-primary transition-colors">
                            <span>Rau củ quả</span>
                            <span class="bg-surface-container px-2 py-1 rounded text-xs">30</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?category=3" class="flex justify-between items-center hover:text-primary transition-colors">
                            <span>Thịt & Hải sản</span>
                            <span class="bg-surface-container px-2 py-1 rounded text-xs">25</span>
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

        <!-- PRODUCT GRID -->
        <div class="w-full md:w-3/4">
            <div class="flex justify-between items-center mb-6">
                <p class="font-body-md text-on-surface-variant">Hiển thị <span class="font-label-bold text-on-surface"><c:out value="${products.size()}"/></span> kết quả</p>
                <select class="border border-outline-variant rounded-md px-3 py-2 font-body-md text-on-surface bg-surface-container-lowest outline-none focus:border-primary">
                    <option>Mới nhất</option>
                    <option>Giá: Thấp đến Cao</option>
                    <option>Giá: Cao xuống Thấp</option>
                </select>
            </div>

            <!-- Lưới hiển thị sản phẩm -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="item" items="${products}">
                    <div class="bg-surface-container-lowest rounded-xl shadow-sm hover:shadow-md transition-shadow border border-outline-variant overflow-hidden group flex flex-col">
                        <div class="relative w-full h-48 bg-surface-container overflow-hidden">
                            <img src="${item.imageUrl}" alt="${item.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                            <div class="absolute top-3 left-3 bg-primary-container text-white text-xs font-bold px-2 py-1 rounded">
                                <c:out value="${item.categoryName}"/>
                            </div>
                        </div>
                        <div class="p-5 flex flex-col flex-grow">
                            <h3 class="font-label-bold text-lg text-on-surface mb-2"><c:out value="${item.name}"/></h3>
                            <div class="mt-auto flex items-center justify-between">
                                <span class="font-price-tag text-price-tag text-primary">
                                    <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                </span>
                                <!-- Nút Thêm Giỏ Hàng -->
                                <form action="${pageContext.request.contextPath}/cart" method="POST">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${item.id}">
                                    <button type="submit" class="w-10 h-10 rounded-full bg-surface-container hover:bg-primary hover:text-white text-primary flex items-center justify-center transition-colors shadow-sm">
                                        <span class="material-symbols-outlined text-[20px]">add_shopping_cart</span>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Phân trang -->
            <div class="mt-12 flex justify-center space-x-2">
                <button class="w-10 h-10 rounded-full border border-outline-variant flex items-center justify-center hover:bg-surface-container text-on-surface-variant transition-colors">
                    <span class="material-symbols-outlined text-[18px]">chevron_left</span>
                </button>
                <button class="w-10 h-10 rounded-full bg-primary text-white font-label-bold shadow-md">1</button>
                <button class="w-10 h-10 rounded-full border border-outline-variant flex items-center justify-center hover:bg-surface-container text-on-surface transition-colors font-label-bold">2</button>
                <button class="w-10 h-10 rounded-full border border-outline-variant flex items-center justify-center hover:bg-surface-container text-on-surface transition-colors font-label-bold">3</button>
                <button class="w-10 h-10 rounded-full border border-outline-variant flex items-center justify-center hover:bg-surface-container text-on-surface-variant transition-colors">
                    <span class="material-symbols-outlined text-[18px]">chevron_right</span>
                </button>
            </div>
        </div>
    </div>
</main>

<!-- FOOTER -->
<footer class="bg-surface-container py-12 border-t border-outline-variant mt-auto">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto text-center text-on-surface-variant font-body-md">
        <p>© 2026 Fruitables.</p>
    </div>
</footer>

<!-- SCRIPT: Xử lý gọi AJAX Fetch API cho tính năng Live Search -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('liveSearchInput');
        const searchDropdown = document.getElementById('searchDropdown');
        let timeoutId;

        searchInput.addEventListener('input', function() {
            clearTimeout(timeoutId);
            const keyword = this.value.trim();

            if (keyword.length < 2) {
                searchDropdown.classList.add('hidden');
                return;
            }

            // Debounce: Đợi 300ms sau khi ngừng gõ mới gọi API
            timeoutId = setTimeout(() => {
                fetch(`${pageContext.request.contextPath}/api/search-products?keyword=` + encodeURIComponent(keyword))
                    .then(response => response.json())
                    .then(data => {
                        searchDropdown.innerHTML = '';

                        if (data.length > 0) {
                            data.forEach(product => {
                                const priceStr = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(product.price);

                                const li = document.createElement('li');
                                li.className = 'px-4 py-3 hover:bg-surface-container cursor-pointer flex items-center gap-3 transition-colors';
                                li.innerHTML = `
                                    <img src="` + product.imageUrl + `" class="w-12 h-12 object-cover rounded-md border border-outline-variant">
                                    <div class="flex-1 overflow-hidden">
                                        <div class="font-label-bold text-sm text-on-surface truncate">` + product.name + `</div>
                                        <div class="text-primary text-xs font-bold mt-1">` + priceStr + `</div>
                                    </div>
                                `;
                                li.addEventListener('click', () => {
                                    window.location.href = `${pageContext.request.contextPath}/shop?keyword=` + encodeURIComponent(product.name);
                                });
                                searchDropdown.appendChild(li);
                            });
                            searchDropdown.classList.remove('hidden');
                        } else {
                            searchDropdown.innerHTML = '<li class="px-4 py-4 text-sm text-on-surface-variant text-center">Không tìm thấy sản phẩm phù hợp.</li>';
                            searchDropdown.classList.remove('hidden');
                        }
                    })
                    .catch(err => console.error('Lỗi khi tải kết quả tìm kiếm:', err));
            }, 300);
        });

        // Ẩn dropdown khi click ra ngoài
        document.addEventListener('click', function(e) {
            if (!searchInput.contains(e.target) && !searchDropdown.contains(e.target)) {
                searchDropdown.classList.add('hidden');
            }
        });
    });
</script>
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