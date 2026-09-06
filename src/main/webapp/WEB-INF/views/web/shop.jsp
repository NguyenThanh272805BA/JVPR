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
                        <c:if test="${not empty selectedCategory}"><input type="hidden" name="category" value="${selectedCategory}"></c:if>
                        <c:if test="${not empty selectedMinPrice}"><input type="hidden" name="minPrice" value="${selectedMinPrice}"></c:if>
                        <c:if test="${not empty selectedMaxPrice}"><input type="hidden" name="maxPrice" value="${selectedMaxPrice}"></c:if>
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
                        <a href="${pageContext.request.contextPath}/shop" class="flex justify-between items-center hover:text-primary transition-colors ${empty selectedCategory ? 'text-primary font-bold' : ''}">
                            <span>Tất cả sản phẩm</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?category=1" class="flex justify-between items-center hover:text-primary transition-colors ${selectedCategory == 1 ? 'text-primary font-bold' : ''}">
                            <span>Trái cây nhập khẩu</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?category=2" class="flex justify-between items-center hover:text-primary transition-colors ${selectedCategory == 2 ? 'text-primary font-bold' : ''}">
                            <span>Trái cây nội địa</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?category=3" class="flex justify-between items-center hover:text-primary transition-colors ${selectedCategory == 3 ? 'text-primary font-bold' : ''}">
                            <span>Rau xanh</span>
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Bộ lọc khoảng giá (Mới bổ sung) -->
            <div class="bg-surface-container-lowest p-6 rounded-xl border border-outline-variant shadow-sm">
                <div class="flex items-center justify-between mb-4 border-b border-surface-variant pb-2">
                    <h3 class="font-headline-md text-lg text-on-surface">Khoảng giá (VNĐ)</h3>
                    <c:if test="${not empty selectedMinPrice || not empty selectedMaxPrice}">
                        <a href="${pageContext.request.contextPath}/shop<c:if test='${not empty selectedCategory}'>?category=${selectedCategory}</c:if>" 
                           class="text-xs text-rose-500 hover:text-rose-700 font-label-bold flex items-center gap-0.5" title="Xóa bộ lọc giá">
                            <span class="material-symbols-outlined text-[14px]">refresh</span> Đặt lại
                        </a>
                    </c:if>
                </div>

                <!-- Mức giá gợi ý -->
                <ul class="space-y-2 mb-4 text-xs text-on-surface-variant">
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?maxPrice=50000<c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                           class="flex items-center justify-between p-2 rounded-lg hover:bg-surface-container transition-colors ${empty selectedMinPrice && selectedMaxPrice == 50000 ? 'bg-primary/10 text-primary font-bold border border-primary/30' : ''}">
                            <span>Dưới 50.000₫</span>
                            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?minPrice=50000&maxPrice=100000<c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                           class="flex items-center justify-between p-2 rounded-lg hover:bg-surface-container transition-colors ${selectedMinPrice == 50000 && selectedMaxPrice == 100000 ? 'bg-primary/10 text-primary font-bold border border-primary/30' : ''}">
                            <span>50.000₫ - 100.000₫</span>
                            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?minPrice=100000&maxPrice=200000<c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                           class="flex items-center justify-between p-2 rounded-lg hover:bg-surface-container transition-colors ${selectedMinPrice == 100000 && selectedMaxPrice == 200000 ? 'bg-primary/10 text-primary font-bold border border-primary/30' : ''}">
                            <span>100.000₫ - 200.000₫</span>
                            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/shop?minPrice=200000<c:if test='${not empty selectedCategory}'>&category=${selectedCategory}</c:if><c:if test='${not empty selectedSort}'>&sort=${selectedSort}</c:if>"
                           class="flex items-center justify-between p-2 rounded-lg hover:bg-surface-container transition-colors ${selectedMinPrice == 200000 && empty selectedMaxPrice ? 'bg-primary/10 text-primary font-bold border border-primary/30' : ''}">
                            <span>Trên 200.000₫</span>
                            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                        </a>
                    </li>
                </ul>

                <!-- Tùy chỉnh khoảng giá -->
                <form action="${pageContext.request.contextPath}/shop" method="GET" class="space-y-3 pt-3 border-t border-surface-variant">
                    <input type="hidden" name="keyword" value="${keyword}">
                    <c:if test="${not empty selectedCategory}">
                        <input type="hidden" name="category" value="${selectedCategory}">
                    </c:if>
                    <c:if test="${not empty selectedSort}">
                        <input type="hidden" name="sort" value="${selectedSort}">
                    </c:if>
                    
                    <div class="text-xs font-label-bold text-on-surface-variant">Tự nhập khoảng giá:</div>
                    <div class="flex items-center gap-2">
                        <input type="number" name="minPrice" placeholder="Từ (₫)" value="${selectedMinPrice != null ? selectedMinPrice.intValue() : ''}" min="0" step="5000"
                               class="w-1/2 px-2.5 py-1.5 text-xs rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface">
                        <span class="text-on-surface-variant text-xs">-</span>
                        <input type="number" name="maxPrice" placeholder="Đến (₫)" value="${selectedMaxPrice != null ? selectedMaxPrice.intValue() : ''}" min="0" step="5000"
                               class="w-1/2 px-2.5 py-1.5 text-xs rounded-lg border border-outline-variant focus:border-primary outline-none bg-surface-container-lowest text-on-surface">
                    </div>
                    <button type="submit" class="w-full py-2 bg-primary hover:bg-primary-container text-white text-xs font-label-bold rounded-lg transition-all shadow-sm flex items-center justify-center gap-1">
                        <span class="material-symbols-outlined text-[16px]">tune</span> Áp dụng khoảng giá
                    </button>
                </form>
            </div>
        </aside>

        <!-- PRODUCT GRID -->
        <div class="w-full md:w-3/4">
            <div class="flex justify-between items-center mb-6">
                <p class="font-body-md text-on-surface-variant">Hiển thị <span class="font-label-bold text-on-surface"><c:out value="${products.size()}"/></span> kết quả</p>
                <form action="${pageContext.request.contextPath}/shop" method="GET">
                    <input type="hidden" name="keyword" value="${keyword}">
                    <input type="hidden" name="category" value="${selectedCategory}">
                    <c:if test="${not empty selectedMinPrice}"><input type="hidden" name="minPrice" value="${selectedMinPrice}"></c:if>
                    <c:if test="${not empty selectedMaxPrice}"><input type="hidden" name="maxPrice" value="${selectedMaxPrice}"></c:if>
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
                    <c:set var="isOutOfStock" value="${item.stock != null && item.stock <= 0}" />
                    <c:set var="hasDiscount" value="${item.discountPrice != null && item.discountPrice > 0 && item.discountPrice < item.price}" />

                    <div class="bg-surface-container-lowest rounded-2xl shadow-sm hover:shadow-xl transition-all duration-300 border border-outline-variant/80 hover:border-primary/50 overflow-hidden group flex flex-col hover:-translate-y-1 relative">
                        <!-- Product Image Clickable -->
                        <a href="${pageContext.request.contextPath}/product-detail?id=${item.id}" class="relative w-full h-48 bg-surface-container overflow-hidden block">
                            <img src="${item.imageUrl}" alt="${item.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500 ${isOutOfStock ? 'grayscale opacity-75' : ''}">
                            <div class="absolute top-3 left-3 bg-primary/95 backdrop-blur-xs text-white text-[11px] font-bold px-2.5 py-1 rounded-full shadow-sm">
                                <c:out value="${item.categoryName}"/>
                            </div>

                            <c:if test="${hasDiscount}">
                                <div class="absolute top-3 right-3 bg-red-500 text-white text-[11px] font-bold px-2 py-0.5 rounded-full shadow-md animate-pulse">
                                    -<fmt:formatNumber value="${(item.price - item.discountPrice) / item.price * 100}" maxFractionDigits="0"/>%
                                </div>
                            </c:if>

                            <c:if test="${isOutOfStock}">
                                <div class="absolute inset-0 bg-black/40 backdrop-blur-[2px] flex items-center justify-center">
                                    <span class="bg-red-600 text-white font-label-bold text-xs uppercase tracking-wider px-3 py-1 rounded-full shadow-lg border border-white/20 flex items-center gap-1">
                                        <span class="material-symbols-outlined text-[15px]">remove_shopping_cart</span> Hết hàng
                                    </span>
                                </div>
                            </c:if>
                        </a>

                        <div class="p-5 flex flex-col flex-grow">
                            <!-- Product Title Clickable -->
                            <a href="${pageContext.request.contextPath}/product-detail?id=${item.id}" class="hover:text-primary transition-colors">
                                <h3 class="font-label-bold text-base text-on-surface mb-2 line-clamp-1" title="${item.name}"><c:out value="${item.name}"/></h3>
                            </a>

                            <!-- Render số sao động từ Database -->
                            <div class="flex items-center gap-1.5 mb-2">
                                <c:set var="rating" value="${item.avgRating != null ? item.avgRating : 5.0}" />
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
                                <span class="text-xs font-bold text-amber-600 bg-amber-50 px-1.5 py-0.5 rounded border border-amber-200">
                                    <fmt:formatNumber value="${rating}" maxFractionDigits="1" minFractionDigits="1"/>
                                </span>
                                <span class="text-xs text-on-surface-variant font-medium">(${item.reviewCount != null ? item.reviewCount : 0})</span>
                            </div>

                            <!-- Số lượt bán -->
                            <div class="flex items-center gap-1.5 mb-3">
                                <span class="inline-flex items-center gap-1 text-[11px] font-semibold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-md border border-emerald-200/80">
                                    <span class="material-symbols-outlined text-[13px]">shopping_bag</span>
                                    Đã bán <span class="font-bold"><c:out value="${item.totalSold != null ? item.totalSold : 0}"/></span>
                                </span>
                            </div>

                            <div class="mt-auto flex items-center justify-between pt-2 border-t border-surface-variant/40">
                                <div>
                                    <c:choose>
                                        <c:when test="${hasDiscount}">
                                            <div class="flex flex-col">
                                                <span class="font-price-tag text-lg text-primary font-bold">
                                                    <fmt:formatNumber value="${item.discountPrice}" type="number" groupingUsed="true"/> ₫
                                                </span>
                                                <span class="text-xs text-on-surface-variant line-through -mt-1">
                                                    <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                                </span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="font-price-tag text-lg text-primary font-bold">
                                                <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <c:choose>
                                    <c:when test="${isOutOfStock}">
                                        <button type="button" onclick="triggerOutOfStockModal('${item.name}')" class="w-10 h-10 rounded-full bg-red-100 hover:bg-red-200 text-red-600 flex items-center justify-center transition-colors shadow-sm" title="Sản phẩm đã hết hàng">
                                            <span class="material-symbols-outlined text-[20px]">production_quantity_limits</span>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/cart" method="POST">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${item.id}">
                                            <button type="submit" class="w-10 h-10 rounded-full bg-surface-container hover:bg-primary hover:text-white text-primary flex items-center justify-center transition-colors shadow-sm active:scale-95" title="Thêm vào giỏ">
                                                <span class="material-symbols-outlined text-[20px]">add_shopping_cart</span>
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
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

                    const currentForm = this;
                    const formData = new FormData(currentForm);
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
                                const card = currentForm.closest('.group') || currentForm.closest('.product-card') || currentForm.parentElement;
                                const img = card ? card.querySelector('img') : null;
                                flyToCart(img, () => {
                                    updateCartBadge(res.totalItems);
                                });
                                showToast(res.message, 'success');
                            } else if (res.status === 'out_of_stock') {
                                triggerOutOfStockModal(res.message);
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

        function flyToCart(imgElement, callback) {
            const cartBtn = document.getElementById('navbar-cart-btn') || document.querySelector('a[href$="/cart"]');
            const cartIcon = document.getElementById('navbar-cart-icon');
            if (!imgElement || !cartBtn) {
                if (callback) callback();
                triggerCartShake();
                return;
            }

            const imgRect = imgElement.getBoundingClientRect();
            const cartRect = (cartIcon || cartBtn).getBoundingClientRect();

            const clone = document.createElement('img');
            clone.src = imgElement.src;
            clone.className = 'fly-item';
            clone.style.top = imgRect.top + 'px';
            clone.style.left = imgRect.left + 'px';
            clone.style.width = imgRect.width + 'px';
            clone.style.height = imgRect.height + 'px';
            document.body.appendChild(clone);

            void clone.offsetWidth; // Trigger reflow

            const targetX = cartRect.left + (cartRect.width / 2) - 16;
            const targetY = cartRect.top + (cartRect.height / 2) - 16;

            clone.style.top = targetY + 'px';
            clone.style.left = targetX + 'px';
            clone.style.width = '32px';
            clone.style.height = '32px';
            clone.style.opacity = '0.35';
            clone.style.transform = 'scale(0.4) rotate(360deg)';

            setTimeout(() => {
                clone.remove();
                if (callback) callback();
                triggerCartShake();
            }, 720);
        }

        function triggerCartShake() {
            const cartIcon = document.getElementById('navbar-cart-icon') || document.getElementById('navbar-cart-btn');
            if (cartIcon) {
                cartIcon.classList.remove('animate-cart-shake');
                void cartIcon.offsetWidth;
                cartIcon.classList.add('animate-cart-shake');
                setTimeout(() => cartIcon.classList.remove('animate-cart-shake'), 700);
            }
        }

        // Kiểm tra xem trang có được redirect sang do hết hàng không
        const urlParams = new URLSearchParams(window.location.search);
        <c:if test="${not empty sessionScope.OUT_OF_STOCK_PRODUCT_NAME}">
            triggerOutOfStockModal('<c:out value="${sessionScope.OUT_OF_STOCK_PRODUCT_NAME}"/>');
            <c:remove var="OUT_OF_STOCK_PRODUCT_NAME" scope="session"/>
        </c:if>
        if (urlParams.get('outOfStock') === '1') {
            triggerOutOfStockModal('sản phẩm bạn chọn');
        }

        function updateCartBadge(total) {
            const cartLink = document.getElementById('navbar-cart-btn') || document.querySelector('a[href$="/cart"]');
            if (cartLink) {
                let badge = document.getElementById('navbar-cart-badge') || cartLink.querySelector('span.bg-error');
                if (!badge && total > 0) {
                    badge = document.createElement('span');
                    badge.id = 'navbar-cart-badge';
                    badge.className = 'absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center transition-transform';
                    cartLink.appendChild(badge);
                }
                if (badge) {
                    badge.textContent = total;
                    badge.classList.remove('animate-badge-pop');
                    void badge.offsetWidth;
                    badge.classList.add('animate-badge-pop');
                }
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

    function triggerOutOfStockModal(productName) {
        const modal = document.getElementById('shopOutOfStockModal');
        const box = document.getElementById('shopModalBox');
        const nameEl = document.getElementById('shopModalProductName');

        if (nameEl && productName) {
            nameEl.textContent = productName.startsWith('“') ? productName : '“' + productName + '”';
        }

        modal.classList.remove('opacity-0', 'pointer-events-none');
        modal.classList.add('opacity-100', 'pointer-events-auto');
        box.classList.remove('scale-90');
        box.classList.add('scale-100');
    }

    function closeShopOutOfStockModal() {
        const modal = document.getElementById('shopOutOfStockModal');
        const box = document.getElementById('shopModalBox');

        modal.classList.remove('opacity-100', 'pointer-events-auto');
        modal.classList.add('opacity-0', 'pointer-events-none');
        box.classList.remove('scale-100');
        box.classList.add('scale-90');
    }
</script>

<!-- MODAL HẾT HÀNG CHO TRANG SHOP -->
<div id="shopOutOfStockModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm opacity-0 pointer-events-none transition-opacity duration-300">
    <div id="shopModalBox" class="bg-surface-container-lowest rounded-3xl p-8 max-w-md w-full mx-4 shadow-2xl text-center transform scale-90 transition-transform duration-300 border border-outline-variant/60 relative overflow-hidden">
        <div class="relative w-20 h-20 mx-auto mb-5 rounded-2xl bg-red-50 border border-red-200/80 flex items-center justify-center text-red-500 shadow-inner animate-bounce">
            <span class="material-symbols-outlined text-4xl">remove_shopping_cart</span>
        </div>
        <h3 class="font-headline-md text-2xl font-extrabold text-on-surface mb-2">Sản phẩm đã hết hàng!</h3>
        <p class="text-sm text-on-surface-variant leading-relaxed mb-6">
            Rất tiếc, sản phẩm <span id="shopModalProductName" class="font-bold text-red-600">này</span> tạm thời hết hàng do nhu cầu mua cao. Bạn vui lòng chọn các sản phẩm hoa quả, rau củ tươi ngon khác nhé!
        </p>
        <button type="button" onclick="closeShopOutOfStockModal()" class="w-full bg-primary text-white py-3 px-6 rounded-full font-label-bold text-sm hover:bg-primary-container transition-all shadow-[0_4px_16px_rgba(129,196,8,0.35)]">
            Đã hiểu, tôi sẽ chọn sản phẩm khác
        </button>
    </div>
</div>
</body>
</html>