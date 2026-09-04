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

<body class="bg-surface-container bg-pattern min-h-screen flex flex-col antialiased">
<!-- NAVBAR CHUNG -->
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<!-- SHOP HERO BANNER -->
<section class="relative w-full h-[300px] md:h-[400px] flex items-center justify-center overflow-hidden">
    <div class="absolute inset-0 bg-cover bg-center" style="background-image: url('https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=2070&auto=format&fit=crop');"></div>
    <div class="absolute inset-0 bg-black/50"></div>
    <div class="relative z-10 text-center px-4">
        <h1 class="text-white font-display-lg text-4xl md:text-5xl font-extrabold mb-4 tracking-wide drop-shadow-lg">Cửa Hàng Trực Tuyến</h1>
        <p class="text-white/90 font-body-lg text-lg md:text-xl max-w-2xl mx-auto drop-shadow-md">Khám phá các sản phẩm tươi sạch, an toàn và 100% hữu cơ được thu hoạch mỗi ngày từ nông trại.</p>
    </div>
</section>

<!-- MAIN SHOP CONTENT -->
<main class="flex-grow py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto flex flex-col md:flex-row gap-8">

        <!-- SIDEBAR -->
        <aside class="w-full md:w-1/4 flex flex-col gap-6 relative z-10">
            <!-- Tích hợp AJAX Live Search -->
            <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant shadow-sm">
                <h3 class="font-headline-md text-lg text-on-surface mb-4 border-b border-surface-variant pb-2">Tìm kiếm</h3>
                <div class="relative">
                    <form action="${pageContext.request.contextPath}/shop" method="GET" class="relative">
                        <input type="text" id="liveSearchInput" name="keyword" value="${keyword}" placeholder="Nhập tên sản phẩm..."
                               class="w-full pl-4 pr-10 py-3 rounded-lg border border-outline-variant focus:border-primary outline-none font-body-md text-on-surface transition-colors" autocomplete="off">
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
            <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant shadow-sm">
                <h3 class="font-headline-md text-lg text-on-surface mb-4 border-b border-surface-variant pb-2">Danh mục</h3>
                <ul class="space-y-3 font-body-md text-on-surface-variant">
                    <li>
                        <a href="${pageContext.request.contextPath}/shop" class="flex justify-between items-center hover:text-primary transition-colors">
                            <span>Tất cả sản phẩm</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?category=1" class="flex justify-between items-center hover:text-primary transition-colors">
                            <span>Trái cây nhập khẩu</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?category=2" class="flex justify-between items-center hover:text-primary transition-colors">
                            <span>Trái cây nội địa</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?category=3" class="flex justify-between items-center hover:text-primary transition-colors">
                            <span>Rau xanh</span>
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

        <!-- PRODUCT GRID -->
        <div class="w-full md:w-3/4">
            <div class="flex justify-between items-center mb-6">
                <p class="font-body-md text-on-surface-variant">Hiển thị <span class="font-label-bold text-on-surface"><c:out value="${products.size()}"/></span> kết quả</p>
                <form action="${pageContext.request.contextPath}/shop" method="GET">
                    <input type="hidden" name="keyword" value="${keyword}">
                    <input type="hidden" name="category" value="${selectedCategory}">
                    <select name="sort" onchange="this.form.submit()" class="border border-outline-variant rounded-md px-3 py-2 font-body-md text-on-surface bg-surface-container-lowest outline-none focus:border-primary">
                        <option value="newest" ${selectedSort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                        <option value="price_asc" ${selectedSort == 'price_asc' ? 'selected' : ''}>Giá: Thấp đến Cao</option>
                        <option value="price_desc" ${selectedSort == 'price_desc' ? 'selected' : ''}>Giá: Cao xuống Thấp</option>
                    </select>
                </form>
            </div>

            <!-- Lưới hiển thị sản phẩm -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="item" items="${products}">
                    <div class="bg-surface-container-lowest rounded-xl shadow-sm hover:shadow-md transition-shadow border border-outline-variant overflow-hidden group flex flex-col">
                        <!-- Product Image Clickable -->
                        <a href="${pageContext.request.contextPath}/product-detail?id=${item.id}" class="relative w-full h-48 bg-surface-container overflow-hidden block">
                            <img src="${item.imageUrl}" alt="${item.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                            <div class="absolute top-3 left-3 bg-primary-container text-white text-xs font-bold px-2 py-1 rounded">
                                <c:out value="${item.categoryName}"/>
                            </div>
                        </a>

                        <div class="p-5 flex flex-col flex-grow">
                            <!-- Product Title Clickable -->
                            <a href="${pageContext.request.contextPath}/product-detail?id=${item.id}" class="hover:text-primary transition-colors">
                                <h3 class="font-label-bold text-lg text-on-surface mb-2 line-clamp-1"><c:out value="${item.name}"/></h3>
                            </a>

                            <!-- Render số sao động từ Database -->
                            <div class="flex items-center mb-3">
                                <c:set var="rating" value="${item.avgRating != null ? item.avgRating : 0}" />
                                <div class="flex text-yellow-500">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${rating >= i}">
                                                <span class="material-symbols-outlined text-[16px]" style="font-variation-settings: 'FILL' 1;">star</span>
                                            </c:when>
                                            <c:when test="${rating >= i - 0.5}">
                                                <span class="material-symbols-outlined text-[16px]" style="font-variation-settings: 'FILL' 1;">star_half</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="material-symbols-outlined text-[16px] text-gray-300">star</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                <span class="text-xs text-on-surface-variant ml-2">(${item.reviewCount != null ? item.reviewCount : 0})</span>
                            </div>

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

            <!-- Phân trang (Giữ nguyên gốc 100%) -->
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

<!-- FOOTER CHUNG -->
<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<!-- SCRIPT: Xử lý gọi AJAX Fetch API cho tính năng Live Search (Giữ nguyên gốc) -->
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
                                    window.location.href = `${pageContext.request.contextPath}/product-detail?id=` + product.id;
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

        document.addEventListener('click', function(e) {
            if (!searchInput.contains(e.target) && !searchDropdown.contains(e.target)) {
                searchDropdown.classList.add('hidden');
            }
        });
    });
</script>

<!-- JAVASCRIPT AJAX ADD TO CART & TOAST NOTIFICATION (Giữ nguyên gốc) -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const addCartForms = document.querySelectorAll('form[action$="/cart"]');

        addCartForms.forEach(form => {
            const actionInput = form.querySelector('input[name="action"][value="add"]');

            if (actionInput) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();

                    const formData = new FormData(this);
                    const data = new URLSearchParams(formData);

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

        function updateCartBadge(total) {
            const cartLink = document.querySelector('a[href$="/cart"]');
            if (cartLink) {
                let badge = cartLink.querySelector('span.bg-error');
                if (!badge) {
                    badge = document.createElement('span');
                    badge.className = 'absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center';
                    cartLink.appendChild(badge);
                }
                badge.textContent = total;
            }
        }

        function showToast(message, type) {
            let container = document.getElementById('toast-container');
            if (!container) {
                container = document.createElement('div');
                container.id = 'toast-container';
                container.className = 'fixed bottom-5 right-5 z-50 flex flex-col gap-3 pointer-events-none';
                document.body.appendChild(container);
            }

            const toast = document.createElement('div');
            const bgColor = type === 'success' ? 'bg-primary' : 'bg-error';
            const icon = type === 'success' ? 'check_circle' : 'error';

            toast.className = `px-6 py-3 rounded-lg shadow-lg text-white font-label-bold transition-all duration-300 transform translate-y-10 opacity-0 flex items-center gap-2 ` + bgColor;
            toast.innerHTML = `<span class="material-symbols-outlined">` + icon + `</span> ` + message;

            container.appendChild(toast);

            requestAnimationFrame(() => {
                toast.classList.remove('translate-y-10', 'opacity-0');
                toast.classList.add('translate-y-0', 'opacity-100');
            });

            setTimeout(() => {
                toast.classList.remove('translate-y-0', 'opacity-100');
                toast.classList.add('translate-y-10', 'opacity-0');
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }
    });
</script>
</body>
</html>