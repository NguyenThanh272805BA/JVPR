<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Nạp bộ thư viện vector SVG thuần (Code-Drawn Icons) dùng chung toàn web -->
<jsp:include page="/WEB-INF/views/components/svg-icons.jsp" />

<!-- THANH ĐIỀU HƯỚNG NỔI BO GÓC CAO CẤP (FLOATING CAPSULE ISLAND NAVBAR) -->
<header class="sticky top-2 sm:top-3 z-50 px-2 sm:px-4 md:px-6 w-full max-w-[1440px] mx-auto transition-all duration-300">
    <nav class="bg-white/95 backdrop-blur-md rounded-2xl md:rounded-3xl shadow-[0_8px_30px_rgb(0,0,0,0.07)] border border-outline-variant/60 px-3 sm:px-4 md:px-5 lg:px-6 h-[68px] md:h-[72px] flex items-center justify-between gap-2.5 md:gap-3.5 lg:gap-4 transition-all">
        <!-- Logo Fruitables Đẳng Cấp Thương Hiệu -->
        <a class="group flex items-center gap-2 md:gap-2.5 transition-all duration-300 select-none flex-shrink-0" href="${pageContext.request.contextPath}/home" title="Fruitables - Thực phẩm sạch hữu cơ">
            <div class="w-10 h-10 md:w-11 md:h-11 rounded-2xl bg-gradient-to-br from-[#84cc16] via-[#65a30d] to-[#4d7c0f] flex items-center justify-center text-white shadow-[0_4px_16px_rgba(101,163,13,0.35)] group-hover:scale-105 group-hover:rotate-3 transition-all duration-300 relative overflow-hidden flex-shrink-0 border border-white/30">
                <div class="absolute inset-0 bg-gradient-to-tr from-transparent via-white/25 to-transparent"></div>
                <svg class="w-6 h-6 text-white drop-shadow-sm" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2C12 2 12.5 5 10 7C7.5 9 6 12 6 15C6 18.3137 8.68629 21 12 21C15.3137 21 18 18.3137 18 15C18 12 16.5 9 14 7C11.5 5 12 2 12 2Z" fill="currentColor" fill-opacity="0.95"/>
                    <path d="M12 2C12 2 13.2 4.2 15.5 4.2C17.5 4.2 18.5 2.8 18.5 2.8C18.5 2.8 18 5.2 16 5.8C14 6.4 12.5 5.2 12 2Z" fill="#fef08a"/>
                    <circle cx="9.5" cy="13.5" r="1.5" fill="white" fill-opacity="0.75"/>
                </svg>
            </div>
            <div class="flex flex-col">
                <div class="flex items-center text-xl sm:text-2xl md:text-[25px] font-black tracking-tight leading-none">
                    <span class="text-slate-900 font-display-lg">Fruit</span><span class="bg-gradient-to-r from-primary via-[#84cc16] to-[#65a30d] bg-clip-text text-transparent font-display-lg">ables</span>
                    <span class="w-2 h-2 rounded-full bg-primary ml-1 animate-pulse"></span>
                </div>
                <span class="text-[8.5px] md:text-[9px] font-bold text-on-surface-variant/75 tracking-[0.2em] uppercase mt-0.5 pl-0.5">Organic & Fresh</span>
            </div>
        </a>

        <!-- Menu điều hướng chức năng hệ thống hiển thị 100% trên Desktop -->
        <div class="hidden lg:flex items-center gap-1 xl:gap-2 flex-shrink-0 text-[13px] xl:text-sm font-semibold">
            <a class="px-2.5 py-1.5 rounded-xl text-on-surface-variant hover:text-primary hover:bg-primary/5 transition-all flex items-center gap-1.5" href="${pageContext.request.contextPath}/home">
                <span class="material-symbols-outlined text-[18px]">home</span>
                <span>Trang chủ</span>
            </a>
            <a class="px-2.5 py-1.5 rounded-xl text-on-surface-variant hover:text-primary hover:bg-primary/5 transition-all flex items-center gap-1.5" href="${pageContext.request.contextPath}/shop">
                <span class="material-symbols-outlined text-[18px]">storefront</span>
                <span>Cửa hàng</span>
            </a>
            <a class="px-2.5 py-1.5 rounded-xl text-emerald-700 bg-emerald-50/70 hover:bg-emerald-100 hover:text-emerald-800 transition-all flex items-center gap-1.5 font-bold" href="${pageContext.request.contextPath}/gift-basket-builder">
                <span class="material-symbols-outlined text-[18px] text-amber-500">card_giftcard</span>
                <span>Tự mix giỏ quà</span>
            </a>
            <!-- Khuyến mãi Dropdown trượt mượt mà khi hover -->
            <div class="relative group py-1.5">
                <a class="px-2.5 py-1.5 rounded-xl text-on-surface-variant hover:text-primary hover:bg-primary/5 transition-all flex items-center gap-1 cursor-pointer" href="${pageContext.request.contextPath}/promotions">
                    <span class="material-symbols-outlined text-[18px] text-rose-500">redeem</span>
                    <span>Khuyến mãi</span>
                    <span class="material-symbols-outlined text-[16px] transition-transform duration-200 group-hover:rotate-180 text-on-surface-variant/70">expand_more</span>
                </a>

                <!-- Submenu Slide-down -->
                <div class="absolute left-0 top-full pt-1.5 z-[110] opacity-0 translate-y-2 pointer-events-none group-hover:opacity-100 group-hover:translate-y-0 group-hover:pointer-events-auto transition-all duration-200 w-64">
                    <div class="bg-surface-container-lowest rounded-2xl shadow-xl border border-outline-variant/80 p-2 space-y-1 backdrop-blur-lg">
                        <a href="${pageContext.request.contextPath}/promotions#coupons-section"
                           class="flex items-center gap-3 p-2.5 rounded-xl hover:bg-surface-container transition-all group/item">
                            <div class="w-9 h-9 rounded-xl bg-primary/10 text-primary flex items-center justify-center flex-shrink-0 group-hover/item:scale-110 transition-transform">
                                <span class="material-symbols-outlined text-[20px]">confirmation_number</span>
                            </div>
                            <div class="flex flex-col min-w-0">
                                <span class="text-xs font-bold text-on-surface group-hover/item:text-primary transition-colors">Mã Khuyến Mãi & Voucher</span>
                                <span class="text-[10px] text-on-surface-variant truncate">Sưu tầm mã giảm giá đến 50k</span>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/promotions#flash-sale-section"
                           class="flex items-center gap-3 p-2.5 rounded-xl hover:bg-surface-container transition-all group/item">
                            <div class="w-9 h-9 rounded-xl bg-rose-50 text-rose-600 flex items-center justify-center flex-shrink-0 group-hover/item:scale-110 transition-transform">
                                <span class="material-symbols-outlined text-[20px]">local_fire_department</span>
                            </div>
                            <div class="flex flex-col min-w-0">
                                <span class="text-xs font-bold text-on-surface group-hover/item:text-rose-600 transition-colors">Sản Phẩm Flash Sale</span>
                                <span class="text-[10px] text-on-surface-variant truncate">Hoa quả tươi giảm giá sốc</span>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/lucky-spin"
                           class="flex items-center gap-3 p-2.5 rounded-xl hover:bg-surface-container transition-all group/item">
                            <div class="w-9 h-9 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center flex-shrink-0 group-hover/item:scale-110 transition-transform">
                                <svg class="w-6 h-6 animate-[spin_10s_linear_infinite] group-hover/item:rotate-180 transition-transform duration-500" viewBox="0 0 32 32"><use href="#icon-lucky-spin-color"/></svg>
                            </div>
                            <div class="flex flex-col min-w-0">
                                <span class="text-xs font-bold text-on-surface group-hover/item:text-amber-600 transition-colors">Vòng Quay May Mắn</span>
                                <span class="text-[10px] text-on-surface-variant truncate">Quay thưởng hàng ngày & Ví quà</span>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            <a class="px-2.5 py-1.5 rounded-xl text-on-surface-variant hover:text-primary hover:bg-primary/5 transition-all flex items-center gap-1.5" href="${pageContext.request.contextPath}/guest-tracking">
                <span class="material-symbols-outlined text-[18px] text-sky-600">local_shipping</span>
                <span>Tra cứu</span>
            </a>
        </div>

        <!-- Thanh Tìm kiếm Real-time với Autocomplete Dropdown -->
        <div class="relative hidden md:block min-w-[130px] max-w-[160px] lg:max-w-[190px] xl:max-w-[240px] flex-1" id="navbar-search-wrapper">
            <form action="${pageContext.request.contextPath}/shop" method="GET" class="relative">
                <input type="text" id="navbar-search-input" name="keyword" autocomplete="off"
                       placeholder="Tìm trái cây, rau củ..."
                       class="w-full pl-8 pr-3 py-1.5 text-xs rounded-full border border-outline-variant bg-surface-container-low focus:bg-white focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-all text-on-surface placeholder:text-on-surface-variant/60">
                <span class="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-on-surface-variant text-[17px] pointer-events-none">search</span>
            </form>

            <!-- Autocomplete Dropdown Result Box -->
            <div id="navbar-search-results" class="hidden absolute left-0 right-0 top-full mt-2 w-72 md:w-80 bg-surface-container-lowest rounded-2xl shadow-xl border border-outline-variant overflow-hidden z-[120] transition-all">
                <div id="navbar-search-list" class="max-h-80 overflow-y-auto divide-y divide-surface-variant"></div>
                <div id="navbar-search-footer" class="p-2.5 bg-surface-container-low border-t border-surface-variant text-center hidden">
                    <a id="navbar-search-view-all" href="#" class="text-xs font-label-bold text-primary hover:underline inline-flex items-center gap-1">
                        <span>Xem tất cả kết quả</span>
                        <span class="material-symbols-outlined text-xs">arrow_forward</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Tiện ích người dùng, Vòng quay & Giỏ hàng -->
        <div class="flex items-center space-x-1.5 sm:space-x-2 md:space-x-2.5 flex-shrink-0">
            <!-- Nút Vòng Quay May Mắn Đặc Trưng Trên Thanh Điều Hướng (Code-Drawn Animated Icon) -->
            <a id="navbar-lucky-spin-btn" href="${pageContext.request.contextPath}/lucky-spin"
               class="group/spin relative flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5 rounded-full bg-gradient-to-r from-amber-500/15 via-rose-500/10 to-amber-500/20 hover:from-amber-500/25 hover:via-rose-500/20 hover:to-amber-500/35 border border-amber-400/60 hover:border-amber-500 shadow-xs hover:shadow-md hover:scale-105 active:scale-95 transition-all text-amber-950"
               title="Vòng Quay May Mắn - Điểm danh nhận voucher & quà tặng mỗi ngày">
                <!-- Icon bánh xe xoay đa sắc màu với ánh sáng hào quang nhấp nháy -->
                <div class="relative w-5 h-5 sm:w-5.5 sm:h-5.5 flex-shrink-0 flex items-center justify-center">
                    <div class="absolute inset-0 rounded-full bg-amber-400/35 blur-xs group-hover/spin:blur-sm animate-pulse"></div>
                    <svg class="w-5 h-5 sm:w-5.5 sm:h-5.5 relative z-10 transition-transform duration-700 ease-out group-hover/spin:rotate-180 animate-[spin_10s_linear_infinite]" viewBox="0 0 32 32">
                        <use href="#icon-lucky-spin-color"/>
                    </svg>
                </div>
                <div class="hidden xl:flex flex-col text-left leading-none">
                    <span class="text-[11px] font-black text-amber-950 group-hover/spin:text-rose-600 transition-colors uppercase tracking-wider">Vòng Quay</span>
                    <span class="text-[8px] font-bold text-amber-700/90">Quà mỗi ngày</span>
                </div>
                <!-- Badge HOT nhấp nháy lôi cuốn -->
                <span class="px-1.5 py-0.2 rounded-full text-[8px] font-black uppercase tracking-wider bg-gradient-to-r from-rose-500 to-amber-500 text-white shadow-xs animate-bounce">
                    HOT
                </span>
            </a>

            <!-- Nút Giỏ Hàng -->
            <a id="navbar-cart-btn" href="${pageContext.request.contextPath}/cart" class="text-primary hover:bg-primary/10 p-2 rounded-full transition-colors relative inline-flex items-center justify-center" title="Giỏ hàng">
                <span id="navbar-cart-icon" class="material-symbols-outlined inline-block transition-transform select-none text-[22px]">shopping_cart</span>
                <c:if test="${not empty sessionScope.CART_TOTAL_ITEMS && sessionScope.CART_TOTAL_ITEMS > 0}">
                    <span id="navbar-cart-badge" class="absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center transition-transform">
                        <c:out value="${sessionScope.CART_TOTAL_ITEMS}"/>
                    </span>
                </c:if>
            </a>

            <!-- Notification Bell Icon (Chỉ hiện khi đã đăng nhập) -->
            <c:if test="${not empty sessionScope.USERMODEL}">
                <div class="relative" id="notification-dropdown-wrapper">
                    <button id="notification-btn" class="text-primary hover:bg-primary/10 p-2 rounded-full transition-colors relative inline-flex items-center justify-center" title="Thông báo đơn hàng">
                        <span class="material-symbols-outlined inline-block select-none text-[22px]">notifications</span>
                        <span id="notif-badge" class="hidden absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full items-center justify-center animate-pulse">0</span>
                    </button>

                    <!-- Dropdown danh sách thông báo -->
                    <div id="notif-dropdown" class="hidden absolute right-0 top-full mt-2 w-80 md:w-96 bg-surface-container-lowest rounded-2xl shadow-xl border border-outline-variant overflow-hidden z-[110] transition-all">
                        <div class="p-4 border-b border-surface-variant flex items-center justify-between bg-surface-container-low">
                            <div class="flex items-center gap-2">
                                <span class="material-symbols-outlined text-primary text-lg">notifications_active</span>
                                <h4 class="font-label-bold text-sm text-on-surface">Thông báo đơn hàng</h4>
                            </div>
                            <button id="mark-all-read-btn" class="text-xs text-primary hover:underline font-medium">Đã đọc tất cả</button>
                        </div>

                        <!-- Danh sách item thông báo -->
                        <div id="notif-list" class="max-h-80 overflow-y-auto divide-y divide-surface-variant">
                            <div class="p-6 text-center text-xs text-on-surface-variant">Đang tải thông báo...</div>
                        </div>

                        <div class="p-2.5 bg-surface-container-low border-t border-surface-variant text-center">
                            <a href="${pageContext.request.contextPath}/order-history" class="text-xs font-label-bold text-primary hover:underline inline-flex items-center gap-1">
                                <span>Xem toàn bộ lịch sử đơn hàng</span>
                                <span class="material-symbols-outlined text-xs">arrow_forward</span>
                            </a>
                        </div>
                    </div>
                </div>

                <script>
                    (function() {
                        const notifBtn = document.getElementById('notification-btn');
                        const notifDropdown = document.getElementById('notif-dropdown');
                        const notifBadge = document.getElementById('notif-badge');
                        const notifList = document.getElementById('notif-list');
                        const markAllBtn = document.getElementById('mark-all-read-btn');

                        if (!notifBtn) return;

                        // Toggle dropdown
                        notifBtn.addEventListener('click', function(e) {
                            e.stopPropagation();
                            notifDropdown.classList.toggle('hidden');
                            if (!notifDropdown.classList.contains('hidden')) {
                                fetchNotifications();
                            }
                        });

                        document.addEventListener('click', function(e) {
                            if (!notifDropdown.contains(e.target) && !notifBtn.contains(e.target)) {
                                notifDropdown.classList.add('hidden');
                            }
                        });

                        // Đánh dấu tất cả đã đọc
                        markAllBtn.addEventListener('click', function(e) {
                            e.stopPropagation();
                            fetch('${pageContext.request.contextPath}/api/notifications', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'action=mark_all_read'
                            }).then(() => {
                                notifBadge.classList.add('hidden');
                                notifBadge.innerText = '0';
                                fetchNotifications();
                            });
                        });

                        function escapeHtml(str) {
                            if (!str) return '';
                            return String(str)
                                .replace(/&/g, '&amp;')
                                .replace(/</g, '&lt;')
                                .replace(/>/g, '&gt;')
                                .replace(/"/g, '&quot;')
                                .replace(/'/g, '&#039;');
                        }

                        function formatNotifTime(dateStr) {
                            if (!dateStr) return '';
                            try {
                                const d = new Date(dateStr);
                                if (isNaN(d.getTime())) return dateStr;
                                const now = new Date();
                                const diffMs = now - d;
                                const diffMins = Math.floor(diffMs / 60000);
                                if (diffMins < 1) return 'Vừa xong';
                                if (diffMins < 60) return diffMins + ' phút trước';
                                const diffHours = Math.floor(diffMins / 60);
                                if (diffHours < 24) return diffHours + ' giờ trước';
                                const diffDays = Math.floor(diffHours / 24);
                                if (diffDays < 7) return diffDays + ' ngày trước';
                                return d.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' });
                            } catch (e) {
                                return dateStr;
                            }
                        }

                        window.handleNotificationClick = function(id) {
                            if (id) {
                                fetch('${pageContext.request.contextPath}/api/notifications', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'action=mark_read&id=' + id
                                }).finally(() => {
                                    window.location.href = '${pageContext.request.contextPath}/order-history';
                                });
                            } else {
                                window.location.href = '${pageContext.request.contextPath}/order-history';
                            }
                        };

                        function fetchNotifications() {
                            fetch('${pageContext.request.contextPath}/api/notifications')
                                .then(res => res.json())
                                .then(data => {
                                    if (!data.authenticated) return;

                                    if (data.unreadCount > 0) {
                                        notifBadge.innerText = data.unreadCount > 9 ? '9+' : data.unreadCount;
                                        notifBadge.classList.remove('hidden');
                                        notifBadge.classList.add('flex');
                                    } else {
                                        notifBadge.classList.add('hidden');
                                        notifBadge.classList.remove('flex');
                                    }

                                    if (!data.notifications || data.notifications.length === 0) {
                                        notifList.innerHTML = `
                                            <div class="p-6 text-center text-xs text-on-surface-variant flex flex-col items-center gap-2">
                                                <span class="material-symbols-outlined text-3xl text-surface-variant">notifications_off</span>
                                                <p>Hiện bạn chưa có thông báo đơn hàng nào.</p>
                                            </div>
                                        `;
                                        return;
                                    }

                                    notifList.innerHTML = data.notifications.map(n => {
                                        let icon = 'local_shipping';
                                        let iconColor = 'text-primary bg-primary/10';
                                        if (n.type === 'ORDER_SHIPPING') {
                                            icon = 'local_shipping';
                                            iconColor = 'text-amber-600 bg-amber-100';
                                        } else if (n.type === 'ORDER_DELIVERED') {
                                            icon = 'verified';
                                            iconColor = 'text-emerald-600 bg-emerald-100';
                                        } else if (n.type === 'ORDER_PENDING') {
                                            icon = 'receipt_long';
                                            iconColor = 'text-blue-600 bg-blue-100';
                                        }

                                        const readBg = n.isRead ? 'bg-surface-container-lowest opacity-75' : 'bg-primary/5 font-semibold';
                                        const unreadDot = !n.isRead ? '<span class="w-2 h-2 rounded-full bg-primary flex-shrink-0"></span>' : '';
                                        const timeStr = formatNotifTime(n.createdAt);
                                        const safeTitle = escapeHtml(n.title || 'Thông báo đơn hàng');
                                        const safeMsg = escapeHtml(n.message || '');
                                        const notifId = n.id || 0;

                                        return `
                                            <div class="p-3.5 hover:bg-surface-container transition-colors flex items-start gap-3 \${readBg} cursor-pointer" onclick="handleNotificationClick(\${notifId})">
                                                <div class="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 \${iconColor}">
                                                    <span class="material-symbols-outlined text-base">\${icon}</span>
                                                </div>
                                                <div class="flex-1 min-w-0">
                                                    <div class="flex items-center justify-between gap-1">
                                                        <h5 class="text-xs font-bold text-on-surface truncate">\${safeTitle}</h5>
                                                        \${unreadDot}
                                                    </div>
                                                    <p class="text-[11px] text-on-surface-variant mt-0.5 line-clamp-2 leading-tight font-normal">\${safeMsg}</p>
                                                    <span class="text-[9px] text-on-surface-variant/70 mt-1 inline-block">\${timeStr}</span>
                                                </div>
                                            </div>
                                        `;
                                    }).join('');
                                })
                                .catch(err => console.error(err));
                        }

                        // Lần đầu tải và định kỳ mỗi 15 giây
                        fetchNotifications();
                        setInterval(fetchNotifications, 15000);
                    })();
                </script>
            </c:if>
            <c:choose>
                <c:when test="${not empty sessionScope.USERMODEL}">
                    <div class="group relative cursor-pointer py-1.5 flex-shrink-0">
                        <div class="flex items-center gap-1.5 md:gap-2 text-primary hover:bg-primary/10 p-1 md:p-1.5 rounded-full transition-colors border border-outline-variant/50">
                            <c:choose>
                                <c:when test="${not empty sessionScope.USERMODEL.avatarUrl}">
                                    <img src="${sessionScope.USERMODEL.avatarUrl}" class="w-8 h-8 rounded-full object-cover border border-primary flex-shrink-0">
                                </c:when>
                                <c:otherwise>
                                    <span class="material-symbols-outlined text-[26px] flex-shrink-0 text-primary" style="font-variation-settings: 'FILL' 1;">account_circle</span>
                                </c:otherwise>
                            </c:choose>
                            <span class="font-label-bold hidden sm:inline-block max-w-[80px] md:max-w-[100px] xl:max-w-[140px] truncate whitespace-nowrap text-xs md:text-sm text-slate-800" title="<c:out value="${sessionScope.USERMODEL.fullName}"/>"><c:out value="${sessionScope.USERMODEL.fullName}"/></span>
                            <span class="material-symbols-outlined text-[16px] text-on-surface-variant hidden sm:inline-block">expand_more</span>
                        </div>

                        <!-- Dropdown menu tài khoản -->
                        <div class="absolute right-0 top-full pt-2 z-[100] hidden group-hover:block w-56">
                            <div class="bg-surface-container-lowest rounded-2xl shadow-xl border border-outline-variant overflow-hidden py-1.5">
                                <c:if test="${sessionScope.USERMODEL.roleId == 1 || sessionScope.USERMODEL.roleId == 2}">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center gap-2.5 px-4 py-2.5 text-xs text-on-surface hover:bg-surface-container font-semibold transition-colors">
                                        <span class="material-symbols-outlined text-base text-primary">dashboard</span> Trang Quản Trị
                                    </a>
                                </c:if>
                                <c:if test="${sessionScope.USERMODEL.roleId == 4}">
                                    <a href="${pageContext.request.contextPath}/shipper/portal" class="flex items-center gap-2.5 px-4 py-2.5 text-xs text-amber-700 bg-amber-50 hover:bg-amber-100 font-bold transition-colors">
                                        <span class="material-symbols-outlined text-base text-amber-600">local_shipping</span> Cổng Tài Xế (Shipper)
                                    </a>
                                </c:if>
                                <c:if test="${sessionScope.USERMODEL.roleId == 1}">
                                    <a href="${pageContext.request.contextPath}/shipper/portal" class="flex items-center gap-2.5 px-4 py-2.5 text-xs text-on-surface hover:bg-surface-container transition-colors">
                                        <span class="material-symbols-outlined text-base text-amber-600">local_shipping</span> Xem Cổng Tài Xế
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-2.5 px-4 py-2.5 text-xs text-on-surface hover:bg-surface-container font-medium transition-colors">
                                    <span class="material-symbols-outlined text-base text-slate-500">manage_accounts</span> Thông tin tài khoản
                                </a>
                                <a href="${pageContext.request.contextPath}/profile#wallet" class="flex items-center gap-2.5 px-4 py-2.5 text-xs text-amber-900 bg-amber-50/50 hover:bg-amber-100/70 font-semibold transition-colors group/item">
                                    <svg class="w-4 h-4 animate-[spin_10s_linear_infinite] group-hover/item:rotate-180 transition-transform duration-500 flex-shrink-0" viewBox="0 0 32 32"><use href="#icon-lucky-spin-color"/></svg>
                                    <span>Ví Quà & Vòng quay</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/order-history" class="flex items-center gap-2.5 px-4 py-2.5 text-xs text-on-surface hover:bg-surface-container font-medium transition-colors">
                                    <span class="material-symbols-outlined text-base text-slate-500">receipt_long</span> Lịch sử đơn hàng
                                </a>
                                <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-2.5 px-4 py-2.5 text-xs text-error hover:bg-error-container font-semibold transition-colors border-t border-surface-variant mt-1">
                                    <span class="material-symbols-outlined text-base">logout</span> Đăng xuất
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="text-primary hover:bg-primary/10 px-3 py-1.5 rounded-full transition-colors flex items-center gap-1.5 border border-primary/30" title="Đăng nhập">
                        <span class="material-symbols-outlined text-[18px]">person</span>
                        <span class="font-label-bold text-xs hidden md:inline">Đăng nhập</span>
                    </a>
                </c:otherwise>
            </c:choose>

            <!-- Nút bật tắt Menu Mobile (Bo góc mềm mại cho điện thoại) -->
            <button type="button" id="mobile-menu-toggle-btn"
                    class="lg:hidden text-on-surface hover:text-primary p-2 rounded-2xl hover:bg-surface-container-highest transition-all flex items-center justify-center border border-outline-variant/60"
                    aria-label="Mở menu">
                <span id="mobile-menu-icon" class="material-symbols-outlined text-[24px]">menu</span>
            </button>
        </div>
    </nav>

    <!-- KHUNG MENU MOBILE DẠNG THẺ NỔI BO GÓC DÀNH CHO ĐIỆN THOẠI -->
    <div id="mobile-menu-drawer" class="hidden lg:hidden mt-2 transition-all duration-300">
        <div class="bg-white/95 backdrop-blur-xl rounded-3xl p-4 shadow-2xl border border-outline-variant space-y-3">
            <!-- Ô tìm kiếm nhanh trên điện thoại -->
            <form action="${pageContext.request.contextPath}/shop" method="GET" class="relative">
                <input type="text" name="keyword" autocomplete="off"
                       placeholder="Tìm trái cây, rau củ..."
                       class="w-full pl-9 pr-4 py-2 text-xs rounded-2xl border border-outline-variant bg-surface-container-low focus:bg-surface-container-lowest focus:border-primary outline-none transition-all text-on-surface placeholder:text-on-surface-variant/60">
                <span class="material-symbols-outlined absolute left-2.5 top-1/2 -translate-y-1/2 text-on-surface-variant text-base pointer-events-none">search</span>
            </form>

            <!-- Danh sách liên kết điều hướng bo góc -->
            <div class="grid grid-cols-1 gap-1 pt-1 font-body-md text-sm">
                <a class="flex items-center gap-3 p-2.5 rounded-2xl text-on-surface hover:bg-primary/10 hover:text-primary transition-all font-medium" href="${pageContext.request.contextPath}/home">
                    <div class="w-8 h-8 rounded-xl bg-primary/10 text-primary flex items-center justify-center flex-shrink-0">
                        <span class="material-symbols-outlined text-[18px]">home</span>
                    </div>
                    <span>Trang chủ</span>
                </a>
                <a class="flex items-center gap-3 p-2.5 rounded-2xl text-on-surface hover:bg-primary/10 hover:text-primary transition-all font-medium" href="${pageContext.request.contextPath}/shop">
                    <div class="w-8 h-8 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center flex-shrink-0">
                        <span class="material-symbols-outlined text-[18px]">storefront</span>
                    </div>
                    <span>Cửa hàng hoa quả</span>
                </a>
                <a class="flex items-center justify-between p-2.5 rounded-2xl text-emerald-800 bg-emerald-50/60 hover:bg-emerald-100/70 transition-all font-semibold" href="${pageContext.request.contextPath}/gift-basket-builder">
                    <div class="flex items-center gap-3">
                        <div class="w-8 h-8 rounded-xl bg-amber-100 text-amber-600 flex items-center justify-center flex-shrink-0">
                            <span class="material-symbols-outlined text-[18px]">card_giftcard</span>
                        </div>
                        <span>Tự mix giỏ quà</span>
                    </div>
                    <span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-amber-400 text-slate-900 uppercase">Hot</span>
                </a>
                <a class="flex items-center justify-between p-2.5 rounded-2xl text-amber-950 bg-gradient-to-r from-amber-500/15 via-rose-500/10 to-amber-500/15 border border-amber-400/40 hover:border-amber-500 transition-all font-bold group" href="${pageContext.request.contextPath}/lucky-spin">
                    <div class="flex items-center gap-3">
                        <div class="w-8 h-8 rounded-xl bg-gradient-to-br from-amber-400 to-orange-500 text-white flex items-center justify-center flex-shrink-0 shadow-xs group-hover:scale-110 transition-transform">
                            <svg class="w-5 h-5 animate-[spin_8s_linear_infinite]" viewBox="0 0 32 32">
                                <use href="#icon-lucky-spin-color"/>
                            </svg>
                        </div>
                        <div class="flex flex-col">
                            <span class="text-xs font-black uppercase tracking-wider text-amber-950">Vòng quay may mắn</span>
                            <span class="text-[9px] font-medium text-amber-800/80">Quay mỗi ngày & ví quà</span>
                        </div>
                    </div>
                    <span class="text-[9px] font-black px-2 py-0.5 rounded-full bg-rose-600 text-white uppercase shadow-xs animate-pulse">Quay</span>
                </a>
                <a class="flex items-center justify-between p-2.5 rounded-2xl text-on-surface hover:bg-primary/10 hover:text-primary transition-all font-medium" href="${pageContext.request.contextPath}/promotions">
                    <div class="flex items-center gap-3">
                        <div class="w-8 h-8 rounded-xl bg-rose-50 text-rose-600 flex items-center justify-center flex-shrink-0">
                            <span class="material-symbols-outlined text-[18px]">redeem</span>
                        </div>
                        <span>Khuyến mãi & Flash Sale</span>
                    </div>
                    <span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-rose-100 text-rose-700">Ưu đãi</span>
                </a>
                <a class="flex items-center gap-3 p-2.5 rounded-2xl text-on-surface hover:bg-primary/10 hover:text-primary transition-all font-medium" href="${pageContext.request.contextPath}/guest-tracking">
                    <div class="w-8 h-8 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center flex-shrink-0">
                        <span class="material-symbols-outlined text-[18px]">local_shipping</span>
                    </div>
                    <span>Tra cứu đơn hàng</span>
                </a>
            </div>

            <!-- Tiện ích tài khoản trên điện thoại -->
            <c:choose>
                <c:when test="${not empty sessionScope.USERMODEL}">
                    <div class="pt-2 border-t border-surface-variant flex flex-col gap-1 text-xs">
                        <div class="flex items-center justify-between px-3 py-2 bg-surface-container rounded-2xl">
                            <div class="flex items-center gap-2">
                                <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                                <span class="font-bold text-on-surface truncate max-w-[170px]"><c:out value="${sessionScope.USERMODEL.fullName}"/></span>
                            </div>
                            <c:choose>
                                <c:when test="${sessionScope.USERMODEL.vipTier == 'KIM CƯƠNG'}">
                                    <span class="text-[10px] font-bold px-2 py-0.5 rounded-full text-slate-900 uppercase tracking-wider bg-cyan-400">
                                        ⭐ Hạng KIM CƯƠNG
                                    </span>
                                </c:when>
                                <c:when test="${sessionScope.USERMODEL.vipTier == 'VÀNG'}">
                                    <span class="text-[10px] font-bold px-2 py-0.5 rounded-full text-slate-900 uppercase tracking-wider bg-amber-400">
                                        ⭐ Hạng VÀNG
                                    </span>
                                </c:when>
                                <c:when test="${sessionScope.USERMODEL.vipTier == 'BẠC'}">
                                    <span class="text-[10px] font-bold px-2 py-0.5 rounded-full text-slate-900 uppercase tracking-wider bg-slate-300">
                                        ⭐ Hạng BẠC
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-[10px] font-bold px-2 py-0.5 rounded-full text-white uppercase tracking-wider bg-amber-700">
                                        ⭐ Hạng ĐỒNG
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="grid grid-cols-2 gap-1.5 pt-1">
                            <a href="${pageContext.request.contextPath}/profile" class="flex items-center justify-center gap-1.5 py-2 px-3 bg-surface-container-low hover:bg-surface-container text-on-surface rounded-xl font-medium">
                                <span class="material-symbols-outlined text-sm">manage_accounts</span> Tài khoản
                            </a>
                            <a href="${pageContext.request.contextPath}/profile#wallet" class="flex items-center justify-center gap-1.5 py-2 px-3 bg-amber-100 hover:bg-amber-200 text-amber-900 rounded-xl font-bold">
                                <svg class="w-4 h-4"><use href="#icon-lucky-spin-color"/></svg> Ví Quà
                            </a>
                        </div>
                        <c:if test="${sessionScope.USERMODEL.roleId == 1 || sessionScope.USERMODEL.roleId == 2}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center justify-center gap-1.5 py-2 px-3 bg-slate-900 text-emerald-300 rounded-xl font-bold mt-1">
                                <span class="material-symbols-outlined text-sm">dashboard</span> Cổng Quản Trị
                            </a>
                        </c:if>
                        <c:if test="${sessionScope.USERMODEL.roleId == 4}">
                            <a href="${pageContext.request.contextPath}/shipper/portal" class="flex items-center justify-center gap-1.5 py-2 px-3 bg-amber-500 text-slate-900 rounded-xl font-bold mt-1">
                                <span class="material-symbols-outlined text-sm">local_shipping</span> Cổng Tài Xế (Shipper)
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/logout" class="flex items-center justify-center gap-1.5 py-2 px-3 text-error hover:bg-error-container rounded-xl font-medium mt-1">
                            <span class="material-symbols-outlined text-sm">logout</span> Đăng xuất
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="pt-2 border-t border-surface-variant">
                        <a href="${pageContext.request.contextPath}/login" class="w-full bg-primary hover:bg-primary-container text-white font-label-bold text-xs py-2.5 rounded-2xl flex items-center justify-center gap-1.5 shadow-sm transition-all">
                            <span class="material-symbols-outlined text-base">person</span> Đăng nhập / Đăng ký
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<!-- Script: Live Search Autocomplete & Mobile Menu Toggle -->
<script>
    (function() {
        // Xử lý bật/tắt Mobile Menu Drawer bo góc
        const mobileMenuToggleBtn = document.getElementById('mobile-menu-toggle-btn');
        const mobileMenuDrawer = document.getElementById('mobile-menu-drawer');
        const mobileMenuIcon = document.getElementById('mobile-menu-icon');

        if (mobileMenuToggleBtn && mobileMenuDrawer) {
            mobileMenuToggleBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                const isHidden = mobileMenuDrawer.classList.contains('hidden');
                if (isHidden) {
                    mobileMenuDrawer.classList.remove('hidden');
                    if (mobileMenuIcon) mobileMenuIcon.innerText = 'close';
                } else {
                    mobileMenuDrawer.classList.add('hidden');
                    if (mobileMenuIcon) mobileMenuIcon.innerText = 'menu';
                }
            });

            document.addEventListener('click', function(e) {
                if (!mobileMenuDrawer.contains(e.target) && !mobileMenuToggleBtn.contains(e.target)) {
                    mobileMenuDrawer.classList.add('hidden');
                    if (mobileMenuIcon) mobileMenuIcon.innerText = 'menu';
                }
            });
        }
        const searchInput = document.getElementById('navbar-search-input');
        const searchResults = document.getElementById('navbar-search-results');
        const searchList = document.getElementById('navbar-search-list');
        const searchFooter = document.getElementById('navbar-search-footer');
        const searchViewAll = document.getElementById('navbar-search-view-all');
        let searchTimeout = null;

        if (!searchInput) return;

        searchInput.addEventListener('input', function() {
            const query = this.value.trim();
            if (searchTimeout) clearTimeout(searchTimeout);

            if (query.length < 2) {
                searchResults.classList.add('hidden');
                searchList.innerHTML = '';
                searchFooter.classList.add('hidden');
                return;
            }

            searchTimeout = setTimeout(() => {
                fetch('${pageContext.request.contextPath}/api/search-products?keyword=' + encodeURIComponent(query))
                    .then(res => res.json())
                    .then(data => {
                        if (!Array.isArray(data) || data.length === 0) {
                            searchList.innerHTML = `
                                <div class="p-4 text-center text-xs text-on-surface-variant">
                                    Không tìm thấy sản phẩm phù hợp với "<strong>\${escapeHtml(query)}</strong>"
                                </div>
                            `;
                            searchFooter.classList.add('hidden');
                            searchResults.classList.remove('hidden');
                            return;
                        }

                        searchList.innerHTML = data.map(p => {
                            const hasDisc = (p.discountPrice && p.discountPrice > 0 && p.discountPrice < p.price);
                            const price = hasDisc ? p.discountPrice : p.price;
                            const priceFmt = new Intl.NumberFormat('vi-VN').format(price) + ' ₫';
                            const origPriceFmt = hasDisc
                                ? `<span class="line-through text-on-surface-variant/70 text-[10px] ml-1">\${new Intl.NumberFormat('vi-VN').format(p.price)} ₫</span>`
                                : '';
                            const discBadge = hasDisc
                                ? `<span class="bg-rose-50 text-rose-600 text-[9px] font-bold px-1 rounded border border-rose-200 ml-1">-\${Math.round((p.price - p.discountPrice) / p.price * 100)}%</span>`
                                : '';
                            const img = p.imageUrl || '${pageContext.request.contextPath}/assets/web/images/placeholder.png';

                            return `
                                <a href="${pageContext.request.contextPath}/product-detail?id=\${p.id}" class="flex items-center gap-3 p-3 hover:bg-surface-container transition-colors">
                                    <img src="\${img}" class="w-10 h-10 object-cover rounded-lg border border-outline-variant flex-shrink-0 bg-surface-container">
                                    <div class="flex-1 min-w-0">
                                        <h5 class="text-xs font-bold text-on-surface truncate">\${escapeHtml(p.name)}</h5>
                                        <div class="flex items-center gap-1 mt-0.5 flex-wrap">
                                            <span class="text-xs font-extrabold \${hasDisc ? 'text-rose-600' : 'text-primary'} font-price-tag">\${priceFmt}</span>
                                            \${origPriceFmt}
                                            \${discBadge}
                                        </div>
                                    </div>
                                </a>
                            `;
                        }).join('');

                        searchViewAll.href = '${pageContext.request.contextPath}/shop?keyword=' + encodeURIComponent(query);
                        searchFooter.classList.remove('hidden');
                        searchResults.classList.remove('hidden');
                    })
                    .catch(err => {
                        console.error('Lỗi tìm kiếm sản phẩm:', err);
                    });
            }, 250);
        });

        document.addEventListener('click', function(e) {
            if (!document.getElementById('navbar-search-wrapper')?.contains(e.target)) {
                searchResults.classList.add('hidden');
            }
        });

        searchInput.addEventListener('focus', function() {
            if (this.value.trim().length >= 2 && searchList.children.length > 0) {
                searchResults.classList.remove('hidden');
            }
        });

        function escapeHtml(str) {
            if (!str) return '';
            return String(str)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#039;');
        }
    })();
</script>