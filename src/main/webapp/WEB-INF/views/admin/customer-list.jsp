<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Quản lý Tài khoản Khách hàng - Fruitables Admin</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>

    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</head>
<body class="bg-background text-on-surface font-body-md flex h-screen overflow-hidden">

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />

<!-- MAIN CONTENT WRAPPER -->
<div class="flex-1 flex flex-col h-full overflow-hidden">

    <!-- HEADER -->
    <header class="h-20 bg-surface-container-lowest border-b border-surface-variant flex items-center justify-between px-6 flex-shrink-0 z-10 shadow-[0px_4px_20px_rgba(0,0,0,0.02)]">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center gap-2">
                <span class="material-symbols-outlined text-primary text-2xl">people</span>
                <span>Quản lý Tài khoản Khách hàng</span>
            </h1>
            <p class="text-xs text-slate-400">Danh sách tài khoản khách hàng mua sắm, điểm tích lũy và trạng thái tài khoản</p>
        </div>

        <div class="flex items-center gap-4">
            <div class="flex items-center gap-3">
                <div class="flex flex-col text-right">
                    <span class="font-bold text-xs text-on-surface">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
                    <span class="text-[10px] text-slate-400">Quản trị viên</span>
                </div>
                <span class="material-symbols-outlined text-4xl text-primary flex-shrink-0">account_circle</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-1 text-xs text-error hover:underline font-semibold">
                <span class="material-symbols-outlined text-base">logout</span>
                <span>Đăng xuất</span>
            </a>
        </div>
    </header>

    <!-- CONTENT BODY -->
    <main class="flex-1 overflow-y-auto p-6 space-y-6 bg-slate-50">
        <div class="max-w-7xl mx-auto space-y-6">

            <!-- FLASH ALERTS -->
            <c:if test="${param.msg == 'status_updated'}">
                <div class="p-4 rounded-2xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs font-bold flex items-center gap-2">
                    <span class="material-symbols-outlined text-base">check_circle</span>
                    <span>Cập nhật trạng thái tài khoản khách hàng thành công!</span>
                </div>
            </c:if>
            <c:if test="${param.error == 'permission_denied'}">
                <div class="p-4 rounded-2xl bg-rose-50 border border-rose-200 text-rose-800 text-xs font-bold flex items-center gap-2">
                    <span class="material-symbols-outlined text-base">block</span>
                    <span>Bạn không có quyền thực hiện thao tác này!</span>
                </div>
            </c:if>

            <!-- TABS ĐIỀU HƯỚNG PHÂN HỆ TÀI KHOẢN -->
            <div class="flex items-center gap-2 border-b border-slate-200 pb-3">
                <a href="${pageContext.request.contextPath}/admin/customers" 
                   class="flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold bg-primary text-white shadow-sm transition-all">
                    <span class="material-symbols-outlined text-lg">people</span>
                    <span>Tài khoản Khách hàng</span>
                    <span class="ml-1.5 px-2 py-0.5 rounded-full text-[10px] bg-white/20 text-white font-bold">${customerStats.totalCustomers != null ? customerStats.totalCustomers : 0}</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/employees" 
                   class="flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold text-slate-600 hover:bg-slate-200/60 transition-all">
                    <span class="material-symbols-outlined text-lg">badge</span>
                    <span>Tài khoản Nhân viên & Phân quyền Role</span>
                </a>
            </div>

            <!-- 1. 4 THẺ KPI KHÁCH HÀNG -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                <!-- Tổng khách hàng -->
                <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-slate-500 font-bold uppercase tracking-wider">Tổng khách hàng</span>
                        <div class="text-2xl font-black text-slate-800 mt-1">${customerStats.totalCustomers != null ? customerStats.totalCustomers : 0}</div>
                        <div class="text-[11px] text-emerald-600 font-semibold mt-1 flex items-center gap-0.5">
                            <span class="material-symbols-outlined text-xs">trending_up</span> +${customerStats.newWeek != null ? customerStats.newWeek : 0} trong 7 ngày
                        </div>
                    </div>
                    <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">group</span>
                    </div>
                </div>

                <!-- Đang hoạt động -->
                <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-slate-500 font-bold uppercase tracking-wider">Đang hoạt động</span>
                        <div class="text-2xl font-black text-primary mt-1">${customerStats.activeCount != null ? customerStats.activeCount : 0}</div>
                        <div class="text-[11px] text-slate-400 mt-1">Sẵn sàng đặt đơn</div>
                    </div>
                    <div class="w-12 h-12 rounded-2xl bg-lime-50 text-primary flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">verified_user</span>
                    </div>
                </div>

                <!-- Tài khoản bị khóa -->
                <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-slate-500 font-bold uppercase tracking-wider">Tài khoản bị khóa</span>
                        <div class="text-2xl font-black text-rose-600 mt-1">${customerStats.lockedCount != null ? customerStats.lockedCount : 0}</div>
                        <div class="text-[11px] text-slate-400 mt-1">Vi phạm chính sách / BOM hàng</div>
                    </div>
                    <div class="w-12 h-12 rounded-2xl bg-rose-50 text-rose-600 flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">lock</span>
                    </div>
                </div>

                <!-- Tổng điểm thưởng tích lũy -->
                <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-slate-500 font-bold uppercase tracking-wider">Điểm thưởng lưu hành</span>
                        <div class="text-2xl font-black text-amber-600 mt-1">
                            <fmt:formatNumber value="${customerStats.totalPoints != null ? customerStats.totalPoints : 0}" type="number"/> pts
                        </div>
                        <div class="text-[11px] text-slate-400 mt-1">Chương trình Khách hàng VIP</div>
                    </div>
                    <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">stars</span>
                    </div>
                </div>
            </div>

            <!-- 2. BỘ LỌC & TÌM KIẾM KHÁCH HÀNG -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                <form action="${pageContext.request.contextPath}/admin/customers" method="GET" class="grid grid-cols-1 sm:grid-cols-12 gap-3 items-end">
                    <div class="sm:col-span-5">
                        <label class="block text-xs font-bold text-slate-600 mb-1">Tìm kiếm khách hàng</label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-base">search</span>
                            <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo Họ tên, SĐT, Email..."
                                   class="w-full pl-9 pr-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs outline-none focus:border-primary focus:bg-white transition-colors">
                        </div>
                    </div>

                    <div class="sm:col-span-3">
                        <label class="block text-xs font-bold text-slate-600 mb-1">Trạng thái tài khoản</label>
                        <select name="status" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs outline-none focus:border-primary">
                            <option value="ALL">Tất cả trạng thái</option>
                            <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                            <option value="LOCKED" ${selectedStatus == 'LOCKED' ? 'selected' : ''}>Đã Khóa</option>
                        </select>
                    </div>

                    <div class="sm:col-span-2">
                        <label class="block text-xs font-bold text-slate-600 mb-1">Đăng nhập</label>
                        <select name="loginType" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs outline-none focus:border-primary">
                            <option value="ALL">Tất cả</option>
                            <option value="LOCAL" ${selectedLoginType == 'LOCAL' ? 'selected' : ''}>Thường</option>
                            <option value="GOOGLE" ${selectedLoginType == 'GOOGLE' ? 'selected' : ''}>Google</option>
                        </select>
                    </div>

                    <div class="sm:col-span-2 flex items-center gap-2">
                        <button type="submit" class="flex-1 px-4 py-2 bg-primary hover:bg-primary-container text-white text-xs font-bold rounded-xl shadow-sm transition-colors flex items-center justify-center gap-1">
                            <span class="material-symbols-outlined text-sm">filter_alt</span> Lọc
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/customers" class="p-2 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-xl transition-colors" title="Đặt lại bộ lọc">
                            <span class="material-symbols-outlined text-sm">restart_alt</span>
                        </a>
                    </div>
                </form>
            </div>

            <!-- 3. BẢNG DANH SÁCH KHÁCH HÀNG -->
            <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="p-5 border-b border-slate-100 flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <h2 class="font-bold text-slate-800 text-sm">Danh sách tài khoản khách hàng</h2>
                        <span class="px-2.5 py-0.5 rounded-full text-xs font-bold bg-slate-100 text-slate-700">${customers.size()} khách</span>
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse text-xs">
                        <thead>
                            <tr class="bg-slate-50 text-slate-600 font-bold border-b border-slate-200">
                                <th class="py-3.5 px-4">Khách hàng</th>
                                <th class="py-3.5 px-4">Liên hệ & Email</th>
                                <th class="py-3.5 px-4">Đăng nhập</th>
                                <th class="py-3.5 px-4 text-center">Điểm thưởng (VIP)</th>
                                <th class="py-3.5 px-4">Ngày tạo</th>
                                <th class="py-3.5 px-4 text-center">Trạng thái</th>
                                <th class="py-3.5 px-4 text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:choose>
                                <c:when test="${not empty customers}">
                                    <c:forEach var="c" items="${customers}">
                                        <tr class="hover:bg-slate-50 transition-colors">
                                            <!-- Khách hàng -->
                                            <td class="py-3 px-4">
                                                <div class="flex items-center gap-3">
                                                    <img src="${c.avatarUrl != null ? c.avatarUrl : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'}"
                                                         class="w-9 h-9 rounded-full object-cover border border-slate-200 shadow-sm">
                                                    <div>
                                                        <span class="font-bold text-slate-800 block text-xs">${c.fullName}</span>
                                                        <span class="text-[10px] text-slate-400 font-mono">ID: #${c.id}</span>
                                                    </div>
                                                </div>
                                            </td>

                                            <!-- SĐT & Email -->
                                            <td class="py-3 px-4">
                                                <div class="space-y-0.5">
                                                    <div class="flex items-center gap-1 text-slate-700">
                                                        <span class="material-symbols-outlined text-[13px] text-slate-400">call</span>
                                                        <span>${c.phone != null ? c.phone : 'Chưa cập nhật'}</span>
                                                    </div>
                                                    <div class="flex items-center gap-1 text-slate-500 text-[11px]">
                                                        <span class="material-symbols-outlined text-[13px] text-slate-400">mail</span>
                                                        <span>${c.email != null ? c.email : 'Chưa có email'}</span>
                                                    </div>
                                                </div>
                                            </td>

                                            <!-- Loại đăng nhập -->
                                            <td class="py-3 px-4">
                                                <c:choose>
                                                    <c:when test="${c.loginType == 'GOOGLE'}">
                                                        <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-rose-50 text-rose-700 font-bold text-[10px] border border-rose-200">
                                                            <span class="material-symbols-outlined text-xs">g_mobiledata</span> Google
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-slate-100 text-slate-700 font-bold text-[10px]">
                                                            <span class="material-symbols-outlined text-xs">badge</span> Tài khoản thường
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Điểm thưởng & Hạng VIP -->
                                            <td class="py-3 px-4 text-center">
                                                <div class="inline-block">
                                                    <span class="font-black text-amber-600 text-xs">${c.points} pts</span>
                                                    <span class="block text-[9px] font-bold px-1.5 py-0.2 rounded mt-0.5 text-white" style="background-color: ${c.vipTierColor};">
                                                        ${c.vipTier}
                                                    </span>
                                                </div>
                                            </td>

                                            <!-- Ngày tạo -->
                                            <td class="py-3 px-4 text-slate-500 text-[11px]">
                                                <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>

                                            <!-- Trạng thái -->
                                            <td class="py-3 px-4 text-center">
                                                <c:choose>
                                                    <c:when test="${c.status == 'ACTIVE'}">
                                                        <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800 font-bold text-[10px]">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> Hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-rose-100 text-rose-800 font-bold text-[10px]">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-rose-500"></span> Đã khóa
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Thao tác -->
                                            <td class="py-3 px-4 text-center">
                                                <div class="flex items-center justify-center gap-1.5">
                                                    <!-- Nút xem chi tiêu -->
                                                    <button type="button" onclick="showCustomerDetail(${c.id}, '${c.fullName}')"
                                                            class="p-1.5 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-600 transition-colors" title="Xem chi tiêu & Lịch sử mua hàng">
                                                        <span class="material-symbols-outlined text-sm">visibility</span>
                                                    </button>

                                                    <!-- Nút Khóa / Mở khóa -->
                                                    <form action="${pageContext.request.contextPath}/admin/customers" method="POST" class="inline" onsubmit="return confirm('Bạn có chắc muốn ${c.status == 'ACTIVE' ? 'KHÓA' : 'MỞ KHÓA'} tài khoản khách hàng này?');">
                                                        <input type="hidden" name="customerId" value="${c.id}"/>
                                                        <input type="hidden" name="status" value="${c.status == 'ACTIVE' ? 'LOCKED' : 'ACTIVE'}"/>
                                                        <c:choose>
                                                            <c:when test="${c.status == 'ACTIVE'}">
                                                                <button type="submit" class="p-1.5 rounded-lg bg-rose-50 hover:bg-rose-100 text-rose-600 transition-colors" title="Khóa tài khoản này">
                                                                    <span class="material-symbols-outlined text-sm">lock</span>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="submit" class="p-1.5 rounded-lg bg-emerald-50 hover:bg-emerald-100 text-emerald-600 transition-colors" title="Mở khóa tài khoản">
                                                                    <span class="material-symbols-outlined text-sm">lock_open</span>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="py-8 text-center text-slate-400">
                                            <span class="material-symbols-outlined text-3xl block mb-1 text-slate-300">person_off</span>
                                            <span>Không tìm thấy tài khoản khách hàng nào phù hợp!</span>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- MODAL XEM CHI TIÊU & ĐƠN HÀNG CỦA KHÁCH HÀNG -->
<div id="customerDetailModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm hidden flex items-center justify-center p-4">
    <div class="bg-white w-full max-w-md rounded-2xl shadow-xl border border-slate-100 overflow-hidden">
        <div class="p-4 bg-slate-50 border-b border-slate-200 flex items-center justify-between">
            <div class="flex items-center gap-2 font-bold text-sm text-slate-800">
                <span class="material-symbols-outlined text-primary text-lg">receipt_long</span>
                <span id="modalCustomerName">Chi tiêu khách hàng</span>
            </div>
            <button type="button" onclick="document.getElementById('customerDetailModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600">
                <span class="material-symbols-outlined text-sm">close</span>
            </button>
        </div>
        <div class="p-5 space-y-3" id="modalCustomerContent">
            <div class="text-center text-slate-400 text-xs py-4">Đang tải dữ liệu chi tiêu...</div>
        </div>
        <div class="p-3 bg-slate-50 border-t border-slate-100 text-right">
            <button type="button" onclick="document.getElementById('customerDetailModal').classList.add('hidden')" class="px-4 py-1.5 bg-slate-200 hover:bg-slate-300 text-slate-700 rounded-xl text-xs font-bold transition-colors">
                Đóng
            </button>
        </div>
    </div>
</div>

<script>
    function showCustomerDetail(userId, name) {
        document.getElementById('modalCustomerName').innerText = 'Lịch sử mua sắm: ' + name;
        document.getElementById('modalCustomerContent').innerHTML = '<div class="text-center text-slate-400 text-xs py-4">Đang tải dữ liệu...</div>';
        document.getElementById('customerDetailModal').classList.remove('hidden');

        fetch('${pageContext.request.contextPath}/admin/users/detail?userId=' + userId)
            .then(res => res.json())
            .then(data => {
                const count = data.orderCount || 0;
                const spent = data.totalSpent || 0;
                const fmtSpent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(spent);
                const lastDate = data.lastOrderDate ? new Date(data.lastOrderDate).toLocaleDateString('vi-VN') : 'Chưa có đơn hàng';

                document.getElementById('modalCustomerContent').innerHTML = `
                    <div class="grid grid-cols-2 gap-3 text-center">
                        <div class="p-3 rounded-xl bg-slate-50 border border-slate-100">
                            <span class="text-[10px] text-slate-400 uppercase font-bold">Tổng đơn hàng</span>
                            <div class="text-xl font-black text-slate-800 mt-0.5">\${count} đơn</div>
                        </div>
                        <div class="p-3 rounded-xl bg-emerald-50 border border-emerald-100">
                            <span class="text-[10px] text-emerald-600 uppercase font-bold">Tổng đã chi tiêu</span>
                            <div class="text-lg font-black text-emerald-700 mt-0.5">\${fmtSpent}</div>
                        </div>
                    </div>
                    <div class="text-xs text-slate-500 pt-2 border-t border-slate-100">
                        <span>Đơn hàng gần nhất: <strong>\${lastDate}</strong></span>
                    </div>
                `;
            })
            .catch(err => {
                document.getElementById('modalCustomerContent').innerHTML = '<div class="text-center text-rose-500 text-xs py-4">Lỗi khi tải thông tin đơn hàng!</div>';
            });
    }
</script>
</body>
</html>
