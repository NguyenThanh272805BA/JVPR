<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="bg-surface w-full sticky top-0 shadow-sm z-50">
    <div class="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <!-- Logo Fruitables Đẳng Cấp Thương Hiệu -->
        <a class="group flex items-center gap-3 transition-all duration-300 select-none" href="${pageContext.request.contextPath}/home" title="Fruitables - Thực phẩm sạch hữu cơ">
            <div class="w-10 h-10 md:w-11 md:h-11 rounded-2xl bg-gradient-to-br from-[#84cc16] via-[#65a30d] to-[#4d7c0f] flex items-center justify-center text-white shadow-[0_4px_16px_rgba(101,163,13,0.35)] group-hover:scale-105 group-hover:rotate-3 transition-all duration-300 relative overflow-hidden flex-shrink-0 border border-white/30">
                <div class="absolute inset-0 bg-gradient-to-tr from-transparent via-white/25 to-transparent"></div>
                <svg class="w-6 h-6 text-white drop-shadow-sm" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2C12 2 12.5 5 10 7C7.5 9 6 12 6 15C6 18.3137 8.68629 21 12 21C15.3137 21 18 18.3137 18 15C18 12 16.5 9 14 7C11.5 5 12 2 12 2Z" fill="currentColor" fill-opacity="0.95"/>
                    <path d="M12 2C12 2 13.2 4.2 15.5 4.2C17.5 4.2 18.5 2.8 18.5 2.8C18.5 2.8 18 5.2 16 5.8C14 6.4 12.5 5.2 12 2Z" fill="#fef08a"/>
                    <circle cx="9.5" cy="13.5" r="1.5" fill="white" fill-opacity="0.75"/>
                </svg>
            </div>
            <div class="flex flex-col">
                <div class="flex items-center text-2xl md:text-[27px] font-black tracking-tight leading-none">
                    <span class="text-slate-900 font-display-lg">Fruit</span><span class="bg-gradient-to-r from-primary via-[#84cc16] to-[#65a30d] bg-clip-text text-transparent font-display-lg">ables</span>
                    <span class="w-2 h-2 rounded-full bg-primary ml-1 animate-pulse"></span>
                </div>
                <span class="text-[9px] font-bold text-on-surface-variant/75 tracking-[0.22em] uppercase mt-0.5 pl-0.5">Organic & Fresh</span>
            </div>
        </a>

        <!-- Menu điều hướng đồng bộ icon -->
        <div class="hidden md:flex space-x-8 items-center">
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors flex items-center gap-1.5" href="${pageContext.request.contextPath}/home">
                <span class="material-symbols-outlined text-[18px]">home</span> Trang chủ
            </a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors flex items-center gap-1.5" href="${pageContext.request.contextPath}/shop">
                <span class="material-symbols-outlined text-[18px]">storefront</span> Cửa hàng
            </a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors flex items-center gap-1.5" href="${pageContext.request.contextPath}/promotions">
                <span class="material-symbols-outlined text-[18px]">redeem</span> Khuyến mãi
            </a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors flex items-center gap-1.5" href="${pageContext.request.contextPath}/guest-tracking">
                <span class="material-symbols-outlined text-[18px]">local_shipping</span> Tra cứu đơn hàng
            </a>
        </div>

        <!-- Tiện ích người dùng & Giỏ hàng -->
        <div class="flex items-center space-x-4">
            <a id="navbar-cart-btn" href="${pageContext.request.contextPath}/cart" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors relative inline-block" title="Giỏ hàng">
                <span id="navbar-cart-icon" class="material-symbols-outlined inline-block transition-transform select-none">shopping_cart</span>
                <c:if test="${not empty sessionScope.CART_TOTAL_ITEMS && sessionScope.CART_TOTAL_ITEMS > 0}">
                    <span id="navbar-cart-badge" class="absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center transition-transform">
                        <c:out value="${sessionScope.CART_TOTAL_ITEMS}"/>
                    </span>
                </c:if>
            </a>

            <!-- Notification Bell Icon (Chỉ hiện khi đã đăng nhập) -->
            <c:if test="${not empty sessionScope.USERMODEL}">
                <div class="relative" id="notification-dropdown-wrapper">
                    <button id="notification-btn" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors relative inline-block" title="Thông báo đơn hàng">
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
                    <div class="group relative cursor-pointer py-2">
                        <div class="flex items-center gap-2 text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors">
                            <c:choose>
                                <c:when test="${not empty sessionScope.USERMODEL.avatarUrl}">
                                    <img src="${sessionScope.USERMODEL.avatarUrl}" class="w-8 h-8 rounded-full object-cover border border-primary">
                                </c:when>
                                <c:otherwise>
                                    <span class="material-symbols-outlined text-[28px]" style="font-variation-settings: 'FILL' 1;">account_circle</span>
                                </c:otherwise>
                            </c:choose>
                            <span class="font-label-bold hidden md:block max-w-[120px] truncate"><c:out value="${sessionScope.USERMODEL.fullName}"/></span>
                        </div>

                        <!-- Dropdown menu -->
                        <div class="absolute right-0 top-full pt-2 z-[100] hidden group-hover:block w-52">
                            <div class="bg-surface-container-lowest rounded-xl shadow-lg border border-outline-variant overflow-hidden py-1">
                                <c:if test="${sessionScope.USERMODEL.roleId == 1 || sessionScope.USERMODEL.roleId == 2}">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center gap-2 px-4 py-2.5 text-on-surface hover:bg-surface-container transition-colors">
                                        <span class="material-symbols-outlined text-sm">dashboard</span> Trang Quản Trị
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-2 px-4 py-2.5 text-on-surface hover:bg-surface-container transition-colors">
                                    <span class="material-symbols-outlined text-sm">person</span> Trang cá nhân
                                </a>
                                <a href="${pageContext.request.contextPath}/order-history" class="flex items-center gap-2 px-4 py-2.5 text-on-surface hover:bg-surface-container transition-colors">
                                    <span class="material-symbols-outlined text-sm">receipt_long</span> Lịch sử đơn hàng
                                </a>
                                <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-2 px-4 py-2.5 text-error hover:bg-error-container transition-colors border-t border-surface-variant">
                                    <span class="material-symbols-outlined text-sm">logout</span> Đăng xuất
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors flex items-center gap-1.5" title="Đăng nhập">
                        <span class="material-symbols-outlined text-[18px]">person</span>
                        <span class="font-label-bold text-sm hidden md:inline">Đăng nhập</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>