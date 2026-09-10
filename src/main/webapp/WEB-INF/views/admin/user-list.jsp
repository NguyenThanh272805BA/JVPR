<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Quản lý người dùng - Fruitables Admin</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-surface font-body-md flex h-screen overflow-hidden">

<!-- SIDEBAR ADMIN -->
<aside class="w-64 bg-surface-container-lowest border-r border-surface-variant flex flex-col h-full flex-shrink-0 z-20 shadow-sm hidden md:flex">
    <div class="h-20 flex items-center px-6 border-b border-surface-variant">
        <a class="group flex items-center gap-2.5" href="${pageContext.request.contextPath}/admin/dashboard">
            <div class="w-8 h-8 rounded-xl bg-gradient-to-br from-[#84cc16] via-[#65a30d] to-[#4d7c0f] flex items-center justify-center text-white shadow-sm flex-shrink-0 group-hover:scale-105 transition-transform">
                <svg class="w-4 h-4 text-white" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2C12 2 12.5 5 10 7C7.5 9 6 12 6 15C6 18.3137 8.68629 21 12 21C15.3137 21 18 18.3137 18 15C18 12 16.5 9 14 7C11.5 5 12 2 12 2Z" fill="currentColor"/>
                    <path d="M12 2C12 2 13.2 4.2 15.5 4.2C17.5 4.2 18.5 2.8 18.5 2.8C18.5 2.8 18 5.2 16 5.8C14 6.4 12.5 5.2 12 2Z" fill="#fef08a"/>
                </svg>
            </div>
            <div class="flex flex-col">
                <span class="text-base font-black tracking-tight leading-none text-slate-900">Fruit<span class="text-primary">ables</span></span>
                <span class="text-[8px] font-bold text-primary tracking-wider uppercase mt-0.5">Admin Portal</span>
            </div>
        </a>
    </div>
    <nav class="flex-1 overflow-y-auto py-6 px-4 space-y-2">
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors text-on-surface-variant hover:bg-surface-container-low hover:text-primary" href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="material-symbols-outlined">dashboard</span>
            <span class="font-label-bold">Tổng quan</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors text-on-surface-variant hover:bg-surface-container-low hover:text-primary" href="${pageContext.request.contextPath}/admin/products">
            <span class="material-symbols-outlined">inventory_2</span>
            <span class="font-label-bold">Sản phẩm</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors text-on-surface-variant hover:bg-surface-container-low hover:text-primary" href="${pageContext.request.contextPath}/admin/inventory">
            <span class="material-symbols-outlined">warehouse</span>
            <span class="font-label-bold">Kho nhập hàng</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors text-on-surface-variant hover:bg-surface-container-low hover:text-primary" href="${pageContext.request.contextPath}/admin/categories">
            <span class="material-symbols-outlined">category</span>
            <span class="font-label-bold">Danh mục</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors text-on-surface-variant hover:bg-surface-container-low hover:text-primary" href="${pageContext.request.contextPath}/admin/orders">
            <span class="material-symbols-outlined">receipt_long</span>
            <span class="font-label-bold">Đơn hàng</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors text-on-surface-variant hover:bg-surface-container-low hover:text-primary" href="${pageContext.request.contextPath}/admin/coupons">
            <span class="material-symbols-outlined">redeem</span>
            <span class="font-label-bold">Mã khuyến mãi</span>
        </a>
        <!-- Nút Users đang active -->
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors bg-primary text-white shadow-md" href="${pageContext.request.contextPath}/admin/users">
            <span class="material-symbols-outlined">group</span>
            <span class="font-label-bold">Người dùng</span>
        </a>
    </nav>
</aside>

<!-- MAIN CONTENT -->
<div class="flex-1 flex flex-col h-full overflow-hidden">
    <!-- HEADER -->
    <header class="h-20 bg-surface-container-lowest border-b border-surface-variant flex items-center justify-between px-margin-desktop shadow-[0px_4px_20px_rgba(0,0,0,0.02)]">
        <div class="font-headline-md text-xl font-bold">Danh sách Người dùng</div>
        <div class="flex items-center gap-6">
            <div class="flex items-center gap-3">
                <div class="flex flex-col text-right">
                    <span class="font-label-bold text-on-surface">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
                    <span class="text-sm text-on-surface-variant">Quản trị viên</span>
                </div>
                <span class="material-symbols-outlined text-4xl text-primary" style="font-variation-settings: 'FILL' 1;">account_circle</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-2 text-error hover:text-on-error-container transition-colors">
                <span class="material-symbols-outlined">logout</span>
                <span class="font-label-bold">Đăng xuất</span>
            </a>
        </div>
    </header>

    <!-- CONTENT -->
    <main class="flex-1 overflow-y-auto p-margin-desktop bg-background">
        <div class="max-w-container-max-width mx-auto space-y-8">
            <c:if test="${param.msg == 'success'}">
                <div class="bg-primary-container/20 border border-primary-container text-primary p-4 rounded-xl flex items-center gap-3 shadow-sm">
                    <span class="material-symbols-outlined">check_circle</span>
                    <span class="font-label-bold">Cập nhật quyền và trạng thái người dùng thành công!</span>
                </div>
            </c:if>

            <!-- 1. Hàng Thẻ KPI Thống Kê Người Dùng -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="bg-surface-container-lowest p-5 rounded-xl border border-surface-variant shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-on-surface-variant font-bold uppercase tracking-wider">Tổng người dùng</span>
                        <div class="text-2xl font-black text-slate-900 mt-1">${userStats.totalUsers}</div>
                        <div class="text-xs text-green-600 font-semibold mt-1 flex items-center gap-0.5">
                            <span class="material-symbols-outlined text-xs">arrow_upward</span> +${userStats.newToday} hôm nay
                        </div>
                    </div>
                    <div class="w-12 h-12 rounded-xl bg-primary/10 text-primary flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">group</span>
                    </div>
                </div>

                <div class="bg-surface-container-lowest p-5 rounded-xl border border-surface-variant shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-on-surface-variant font-bold uppercase tracking-wider">Người dùng mới (Tuần)</span>
                        <div class="text-2xl font-black text-blue-600 mt-1">+${userStats.newThisWeek}</div>
                        <div class="text-xs ${userStats.weekGrowth >= 0 ? 'text-green-600' : 'text-red-500'} font-semibold mt-1 flex items-center gap-0.5">
                            <span class="material-symbols-outlined text-xs">${userStats.weekGrowth >= 0 ? 'trending_up' : 'trending_down'}</span>
                            ${userStats.weekGrowth >= 0 ? '+' : ''}${userStats.weekGrowth}% vs tuần trước
                        </div>
                    </div>
                    <div class="w-12 h-12 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">person_add</span>
                    </div>
                </div>

                <div class="bg-surface-container-lowest p-5 rounded-xl border border-surface-variant shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-on-surface-variant font-bold uppercase tracking-wider">Phân loại đăng nhập</span>
                        <div class="text-sm font-bold text-slate-800 mt-1 flex items-center gap-2">
                            <span class="text-red-600 font-black">${userStats.googleCount} Google</span>
                            <span>•</span>
                            <span class="text-slate-600 font-black">${userStats.localCount} Thường</span>
                        </div>
                        <div class="w-full bg-slate-100 rounded-full h-1.5 mt-2 flex overflow-hidden">
                            <div class="bg-red-500 h-1.5" style="width: ${(userStats.googleCount / (userStats.totalUsers > 0 ? userStats.totalUsers : 1)) * 100}%;"></div>
                            <div class="bg-slate-400 h-1.5" style="width: ${(userStats.localCount / (userStats.totalUsers > 0 ? userStats.totalUsers : 1)) * 100}%;"></div>
                        </div>
                    </div>
                    <div class="w-12 h-12 rounded-xl bg-orange-50 text-orange-600 flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">lock_person</span>
                    </div>
                </div>

                <div class="bg-surface-container-lowest p-5 rounded-xl border border-surface-variant shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-on-surface-variant font-bold uppercase tracking-wider">Trạng thái tài khoản</span>
                        <div class="text-sm font-bold text-slate-800 mt-1 flex items-center gap-2">
                            <span class="text-green-600 font-black">${userStats.activeCount} Hoạt động</span>
                            <span>•</span>
                            <span class="text-red-500 font-black">${userStats.lockedCount} Khóa</span>
                        </div>
                        <div class="text-xs text-slate-400 mt-1 font-medium">Bảo vệ an ninh hệ thống</div>
                    </div>
                    <div class="w-12 h-12 rounded-xl bg-green-50 text-green-600 flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">verified_user</span>
                    </div>
                </div>
            </div>

            <!-- 2. Biểu đồ So Sánh Người Dùng Mới Theo Thời Gian (Requirement 3) -->
            <div class="bg-surface-container-lowest p-6 rounded-xl shadow-sm border border-surface-variant flex flex-col">
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                    <div>
                        <div class="flex items-center gap-3">
                            <h2 class="font-label-bold text-lg text-on-surface font-bold">Biểu đồ tăng trưởng & so sánh người dùng mới</h2>
                            <span id="userGrowthBadge" class="px-2.5 py-0.5 rounded-full text-xs font-bold bg-blue-100 text-blue-700 flex items-center gap-1">
                                <span class="material-symbols-outlined text-[14px]">trending_up</span> +0%
                            </span>
                        </div>
                        <p class="text-xs text-on-surface-variant mt-1">So sánh lượng tài khoản mới đăng ký giữa kỳ hiện tại (xanh lam) và kỳ trước (nét đứt xám)</p>
                    </div>
                    <div class="flex items-center gap-3">
                        <select id="userChartFilter" class="border border-outline-variant rounded-lg px-3.5 py-2 font-body-md text-sm text-on-surface focus:border-primary outline-none bg-surface-container-lowest shadow-sm">
                            <option value="day" selected>Theo ngày (7 ngày qua vs 7 ngày trước)</option>
                            <option value="week">Theo tuần (4 tuần qua vs 4 tuần trước)</option>
                            <option value="month">Theo tháng (6 tháng qua vs 6 tháng trước)</option>
                        </select>
                    </div>
                </div>
                <div class="relative h-[300px] w-full">
                    <canvas id="userGrowthChart"></canvas>
                </div>
            </div>

            <!-- 3. Thanh Tìm kiếm & Bộ lọc người dùng -->
            <div class="bg-surface-container-lowest p-6 rounded-xl shadow-sm border border-surface-variant">
                <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-5 gap-4 items-end">
                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold text-slate-600 mb-1">Tìm kiếm người dùng</label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-2.5 text-slate-400 text-lg">search</span>
                            <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo Tên, Email, SĐT..." class="w-full pl-9 pr-4 py-2 border border-outline-variant rounded-lg outline-none focus:border-primary text-sm bg-surface-container-lowest">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-600 mb-1">Phân quyền</label>
                        <select name="roleId" class="w-full px-3 py-2 border border-outline-variant rounded-lg outline-none focus:border-primary text-sm bg-surface-container-lowest">
                            <option value="ALL">Tất cả vai trò</option>
                            <option value="1" ${selectedRoleId == '1' ? 'selected' : ''}>Super Admin</option>
                            <option value="2" ${selectedRoleId == '2' ? 'selected' : ''}>Nhân viên Sale</option>
                            <option value="3" ${selectedRoleId == '3' ? 'selected' : ''}>Khách hàng</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-600 mb-1">Trạng thái</label>
                        <select name="status" class="w-full px-3 py-2 border border-outline-variant rounded-lg outline-none focus:border-primary text-sm bg-surface-container-lowest">
                            <option value="ALL">Tất cả trạng thái</option>
                            <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                            <option value="LOCKED" ${selectedStatus == 'LOCKED' ? 'selected' : ''}>Đã Khóa</option>
                        </select>
                    </div>
                    <div class="flex items-center gap-2">
                        <button type="submit" class="flex-1 bg-primary hover:bg-primary-container text-white py-2 px-4 rounded-lg font-bold text-sm shadow-sm transition-colors flex items-center justify-center gap-1">
                            <span class="material-symbols-outlined text-[18px]">filter_list</span> Lọc
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/users" class="px-3 py-2 border border-outline-variant hover:bg-slate-50 text-slate-600 rounded-lg text-sm font-semibold transition-colors" title="Xóa bộ lọc">
                            <span class="material-symbols-outlined text-[18px]">refresh</span>
                        </a>
                    </div>
                </form>
            </div>

            <!-- 4. Bảng Danh sách Người dùng -->
            <div class="bg-surface-container-lowest rounded-xl shadow-sm overflow-hidden border border-surface-variant">
                <div class="p-6 border-b border-surface-variant flex justify-between items-center bg-surface-container-lowest">
                    <div class="flex items-center gap-2">
                        <h2 class="font-label-bold text-lg text-on-surface font-bold">Danh sách tài khoản</h2>
                        <span class="px-2.5 py-0.5 rounded-full text-xs font-bold bg-slate-100 text-slate-700">${users.size()} kết quả</span>
                    </div>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                        <tr class="bg-surface-container text-on-surface-variant font-label-bold text-sm">
                            <th class="py-4 px-6 font-medium">Họ tên & Thông tin</th>
                            <th class="py-4 px-6 font-medium">Email / Đăng nhập</th>
                            <th class="py-4 px-6 font-medium">Phân quyền</th>
                            <th class="py-4 px-6 font-medium">Trạng thái</th>
                            <th class="py-4 px-6 font-medium text-center">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-surface-variant text-body-md text-on-surface text-sm">
                        <c:forEach var="u" items="${users}">
                            <tr class="hover:bg-surface-bright transition-colors">
                                <td class="py-4 px-6 font-label-bold">
                                    <div class="flex items-center gap-3">
                                        <c:choose>
                                            <c:when test="${not empty u.avatarUrl}">
                                                <img src="${u.avatarUrl}" class="w-10 h-10 rounded-full object-cover border border-slate-200">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary font-bold">
                                                    ${u.fullName != null && u.fullName.length() > 0 ? u.fullName.substring(0,1) : 'U'}
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div>
                                            <div class="text-slate-900 font-bold">${u.fullName}</div>
                                            <div class="text-xs text-slate-400 font-normal">SĐT: ${u.phone != null && !u.phone.isEmpty() ? u.phone : 'Chưa cập nhật'}</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="py-4 px-6">
                                    <div class="text-on-surface font-medium">${u.email != null ? u.email : (u.username != null ? u.username : '---')}</div>
                                    <span class="inline-flex items-center gap-1 mt-1 px-2 py-0.5 rounded-md text-[10px] font-bold ${u.loginType == 'GOOGLE' ? 'bg-red-50 text-red-600 border border-red-200' : 'bg-slate-100 text-slate-600'}">
                                        ${u.loginType}
                                    </span>
                                </td>
                                <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                                    <input type="hidden" name="id" value="${u.id}">
                                    <td class="py-4 px-6">
                                        <select name="roleId" class="w-full px-3 py-2 border border-outline-variant rounded-lg bg-surface-container-lowest outline-none focus:border-primary text-xs font-semibold">
                                            <option value="1" ${u.roleId == 1 ? 'selected' : ''}>Super Admin</option>
                                            <option value="2" ${u.roleId == 2 ? 'selected' : ''}>Nhân viên Sale</option>
                                            <option value="3" ${u.roleId == 3 ? 'selected' : ''}>Khách hàng</option>
                                        </select>
                                    </td>
                                    <td class="py-4 px-6">
                                        <select name="status" class="w-full px-3 py-2 border border-outline-variant rounded-lg outline-none text-xs font-bold ${u.status == 'ACTIVE' ? 'bg-green-50 text-green-700 border-green-200' : 'bg-red-50 text-red-600 border-red-200'}">
                                            <option value="ACTIVE" ${u.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="LOCKED" ${u.status == 'LOCKED' ? 'selected' : ''}>Đã Khóa</option>
                                        </select>
                                    </td>
                                    <td class="py-4 px-6 text-center">
                                        <div class="flex items-center justify-center gap-2">
                                            <button type="submit" class="px-3 py-1.5 bg-primary text-white font-label-bold rounded-lg hover:bg-primary-container transition-colors shadow-sm text-xs inline-flex items-center gap-1">
                                                <span class="material-symbols-outlined text-[16px]">save</span> Lưu
                                            </button>
                                            <button type="button" 
                                                    onclick="openUserDetailModal('${u.id}', '${u.fullName}', '${u.email}', '${u.phone}', '${u.loginType}', '${u.status}', '${u.avatarUrl}')" 
                                                    class="px-3 py-1.5 bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold rounded-lg transition-colors text-xs inline-flex items-center gap-1">
                                                <span class="material-symbols-outlined text-[16px]">visibility</span> Chi tiết
                                            </button>
                                        </div>
                                    </td>
                                </form>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- MODAL XEM CHI TIẾT NGƯỜI DÙNG & LỊCH SỬ CHI TIÊU -->
<div id="userDetailModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4 transition-all">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden border border-slate-200 animate-in fade-in zoom-in-95 duration-200" onclick="event.stopPropagation()">
        <!-- Header -->
        <div class="bg-gradient-to-r from-slate-800 to-slate-900 px-6 py-5 text-white flex items-center justify-between">
            <div class="flex items-center gap-3">
                <div id="modalUserAvatar" class="w-12 h-12 rounded-full bg-primary text-white flex items-center justify-center font-bold text-lg shadow-sm overflow-hidden">
                    U
                </div>
                <div>
                    <h3 id="modalUserName" class="font-bold text-base leading-tight">Tên Người Dùng</h3>
                    <p id="modalUserEmail" class="text-xs text-slate-300 mt-0.5">email@example.com</p>
                </div>
            </div>
            <button type="button" onclick="closeUserDetailModal()" class="w-8 h-8 rounded-full bg-white/10 hover:bg-white/20 flex items-center justify-center transition-colors">
                <span class="material-symbols-outlined text-sm">close</span>
            </button>
        </div>

        <!-- Body -->
        <div class="p-6 space-y-4 text-xs">
            <div class="grid grid-cols-2 gap-3">
                <div class="p-3 bg-slate-50 rounded-xl border border-slate-100">
                    <span class="text-slate-400 font-semibold">Phương thức:</span>
                    <div id="modalUserLoginType" class="font-bold text-slate-800 text-sm mt-0.5">LOCAL</div>
                </div>
                <div class="p-3 bg-slate-50 rounded-xl border border-slate-100">
                    <span class="text-slate-400 font-semibold">Trạng thái:</span>
                    <div id="modalUserStatus" class="font-bold text-green-600 text-sm mt-0.5">ACTIVE</div>
                </div>
            </div>

            <div class="p-4 bg-primary/5 rounded-xl border border-primary/20 space-y-3">
                <h4 class="font-bold text-slate-900 text-xs uppercase tracking-wider flex items-center gap-1 text-primary">
                    <span class="material-symbols-outlined text-sm">insights</span> Hiệu suất mua sắm (LTV)
                </h4>
                <div class="flex justify-between items-center">
                    <span class="text-slate-500">Tổng số đơn hàng:</span>
                    <span id="modalOrderCount" class="font-bold text-slate-900 text-sm">Đang tải...</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-slate-500">Tổng tiền tích lũy:</span>
                    <span id="modalTotalSpent" class="font-bold text-primary text-sm">Đang tải...</span>
                </div>
                <div class="flex justify-between items-center pt-2 border-t border-dashed border-primary/20">
                    <span class="text-slate-500">Đơn hàng gần nhất:</span>
                    <span id="modalLastOrderDate" class="text-slate-700 font-semibold">---</span>
                </div>
            </div>

            <div class="flex justify-between items-center py-2 px-1 text-slate-500">
                <span>Số điện thoại:</span>
                <span id="modalUserPhone" class="font-bold text-slate-800">---</span>
            </div>
        </div>

        <!-- Footer -->
        <div class="px-6 py-3 bg-slate-50 border-t border-slate-200 flex justify-end">
            <button type="button" onclick="closeUserDetailModal()" class="px-4 py-2 bg-slate-200 hover:bg-slate-300 text-slate-700 font-bold rounded-lg transition-colors text-xs">
                Đóng
            </button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    let userGrowthChart = null;

    function loadUserGrowthChart(filter) {
        fetch('${pageContext.request.contextPath}/admin/users/stats?filter=' + filter)
            .then(res => res.json())
            .then(data => {
                const ctx = document.getElementById('userGrowthChart').getContext('2d');
                if (userGrowthChart) userGrowthChart.destroy();

                const badge = document.getElementById('userGrowthBadge');
                if (badge) {
                    const rate = data.growthRate !== undefined ? data.growthRate : 0;
                    if (rate >= 0) {
                        badge.className = 'px-2.5 py-0.5 rounded-full text-xs font-bold bg-green-100 text-green-700 flex items-center gap-1';
                        badge.innerHTML = '<span class="material-symbols-outlined text-[14px]">trending_up</span> +' + rate + '%';
                    } else {
                        badge.className = 'px-2.5 py-0.5 rounded-full text-xs font-bold bg-red-100 text-red-600 flex items-center gap-1';
                        badge.innerHTML = '<span class="material-symbols-outlined text-[14px]">trending_down</span> ' + rate + '%';
                    }
                }

                userGrowthChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: data.labels,
                        datasets: [
                            {
                                label: 'Kỳ hiện tại (Tài khoản mới)',
                                data: data.currentData,
                                borderColor: '#3b82f6',
                                backgroundColor: 'rgba(59, 130, 246, 0.15)',
                                borderWidth: 3,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#3b82f6',
                                pointBorderWidth: 2,
                                pointRadius: 5,
                                fill: true,
                                tension: 0.35
                            },
                            {
                                label: 'Kỳ trước đó (Đối sánh)',
                                data: data.previousData,
                                borderColor: '#94a3b8',
                                backgroundColor: 'transparent',
                                borderWidth: 2,
                                borderDash: [5, 5],
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#94a3b8',
                                pointBorderWidth: 1.5,
                                pointRadius: 4,
                                fill: false,
                                tension: 0.35
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        interaction: { mode: 'index', intersect: false },
                        plugins: {
                            legend: { position: 'top', labels: { usePointStyle: true } }
                        },
                        scales: {
                            y: { beginAtZero: true, ticks: { stepSize: 1 } }
                        }
                    }
                });
            })
            .catch(err => console.error('Lỗi khi vẽ biểu đồ người dùng:', err));
    }

    function openUserDetailModal(id, name, email, phone, loginType, status, avatarUrl) {
        document.getElementById('modalUserName').innerText = name || 'Khách hàng';
        document.getElementById('modalUserEmail').innerText = email || 'Chưa có email';
        document.getElementById('modalUserPhone').innerText = phone || 'Chưa cập nhật';
        document.getElementById('modalUserLoginType').innerText = loginType;
        document.getElementById('modalUserStatus').innerText = status;

        const avatarContainer = document.getElementById('modalUserAvatar');
        if (avatarUrl && avatarUrl !== 'null' && avatarUrl.trim() !== '') {
            avatarContainer.innerHTML = '<img src="' + avatarUrl + '" class="w-full h-full object-cover">';
        } else {
            avatarContainer.innerHTML = (name && name.length > 0) ? name.substring(0, 1).toUpperCase() : 'U';
        }

        document.getElementById('modalOrderCount').innerText = 'Đang tải...';
        document.getElementById('modalTotalSpent').innerText = 'Đang tải...';
        document.getElementById('modalLastOrderDate').innerText = 'Đang tải...';

        document.getElementById('userDetailModal').classList.remove('hidden');

        fetch('${pageContext.request.contextPath}/admin/users/detail?userId=' + id)
            .then(res => res.json())
            .then(data => {
                document.getElementById('modalOrderCount').innerText = (data.orderCount || 0) + ' đơn';
                document.getElementById('modalTotalSpent').innerText = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.totalSpent || 0);
                document.getElementById('modalLastOrderDate').innerText = data.lastOrderDate ? new Date(data.lastOrderDate).toLocaleDateString('vi-VN') : 'Chưa phát sinh đơn';
            })
            .catch(err => {
                document.getElementById('modalOrderCount').innerText = '0 đơn';
                document.getElementById('modalTotalSpent').innerText = '0 ₫';
                document.getElementById('modalLastOrderDate').innerText = 'Không có';
            });
    }

    function closeUserDetailModal() {
        document.getElementById('userDetailModal').classList.add('hidden');
    }

    document.addEventListener('DOMContentLoaded', function() {
        loadUserGrowthChart('day');
        document.getElementById('userChartFilter').addEventListener('change', function() {
            loadUserGrowthChart(this.value);
        });
    });
</script>
</body>
</html>