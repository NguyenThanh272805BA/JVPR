<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Quản lý Nhân sự & Phân quyền Role - Fruitables Admin</title>

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
                <span class="material-symbols-outlined text-primary text-2xl">badge</span>
                <span>Quản lý Tài khoản Nhân viên & Phân quyền Role</span>
            </h1>
            <p class="text-xs text-slate-400">Danh sách nhân sự nội bộ: Quản trị viên, Nhân viên Bán hàng và Tài xế Giao hàng</p>
        </div>

        <div class="flex items-center gap-4">
            <button type="button" onclick="openCreateEmployeeModal()"
                    class="px-4 py-2 bg-primary hover:bg-primary-container text-white text-xs font-bold rounded-xl shadow-sm transition-all flex items-center gap-1.5">
                <span class="material-symbols-outlined text-base">person_add</span>
                <span>Thêm Nhân viên mới</span>
            </button>

            <div class="flex items-center gap-3 border-l border-slate-200 pl-4">
                <div class="flex flex-col text-right">
                    <span class="font-bold text-xs text-on-surface">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
                    <span class="text-[10px] text-purple-700 font-bold bg-purple-50 px-1.5 py-0.2 rounded">Super Admin</span>
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
            <c:if test="${not empty param.msg}">
                <div class="p-4 rounded-2xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs font-bold flex items-center gap-2 animate-fade-in">
                    <span class="material-symbols-outlined text-base">check_circle</span>
                    <span><c:out value="${param.msg}"/></span>
                </div>
            </c:if>
            <c:if test="${param.error == 'permission_denied'}">
                <div class="p-4 rounded-2xl bg-rose-50 border border-rose-200 text-rose-800 text-xs font-bold flex items-center gap-2">
                    <span class="material-symbols-outlined text-base">block</span>
                    <span>Từ chối truy cập: Chỉ Quản trị viên cấp cao nhất (Super Admin) mới có quyền phân bổ nhân sự!</span>
                </div>
            </c:if>

            <!-- TABS ĐIỀU HƯỚNG PHÂN HỆ TÀI KHOẢN -->
            <div class="flex items-center gap-2 border-b border-slate-200 pb-3">
                <a href="${pageContext.request.contextPath}/admin/customers" 
                   class="flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold text-slate-600 hover:bg-slate-200/60 transition-all">
                    <span class="material-symbols-outlined text-lg">people</span>
                    <span>Tài khoản Khách hàng</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/employees" 
                   class="flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold bg-primary text-white shadow-sm transition-all">
                    <span class="material-symbols-outlined text-lg">badge</span>
                    <span>Tài khoản Nhân viên & Phân quyền Role</span>
                    <span class="ml-1.5 px-2 py-0.5 rounded-full text-[10px] bg-white/20 text-white font-bold">${employeeStats.totalEmployees != null ? employeeStats.totalEmployees : 0}</span>
                </a>
            </div>

            <!-- 1. 4 THẺ KPI NHÂN SỰ NỘI BỘ -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                <!-- Tổng nhân sự -->
                <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-slate-500 font-bold uppercase tracking-wider">Tổng nhân sự nội bộ</span>
                        <div class="text-2xl font-black text-slate-800 mt-1">${employeeStats.totalEmployees != null ? employeeStats.totalEmployees : 0}</div>
                        <div class="text-[11px] text-slate-400 mt-1">Đang hoạt động: <strong>${employeeStats.activeCount != null ? employeeStats.activeCount : 0}</strong></div>
                    </div>
                    <div class="w-12 h-12 rounded-2xl bg-slate-100 text-slate-700 flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">corporate_fare</span>
                    </div>
                </div>

                <!-- Super Admin -->
                <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-purple-700 font-bold uppercase tracking-wider">Quản trị viên (Admin)</span>
                        <div class="text-2xl font-black text-purple-800 mt-1">${employeeStats.adminCount != null ? employeeStats.adminCount : 0}</div>
                        <div class="text-[11px] text-slate-400 mt-1">Toàn quyền hệ thống</div>
                    </div>
                    <div class="w-12 h-12 rounded-2xl bg-purple-50 text-purple-700 flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">admin_panel_settings</span>
                    </div>
                </div>

                <!-- Nhân viên Sale -->
                <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-blue-700 font-bold uppercase tracking-wider">Nhân viên Bán hàng (Sale)</span>
                        <div class="text-2xl font-black text-blue-800 mt-1">${employeeStats.saleCount != null ? employeeStats.saleCount : 0}</div>
                        <div class="text-[11px] text-slate-400 mt-1">Duyệt đơn, kho & CSKH</div>
                    </div>
                    <div class="w-12 h-12 rounded-2xl bg-blue-50 text-blue-700 flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">point_of_sale</span>
                    </div>
                </div>

                <!-- Tài xế Shipper -->
                <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
                    <div>
                        <span class="text-xs text-amber-700 font-bold uppercase tracking-wider">Tài xế Giao hàng (Shipper)</span>
                        <div class="text-2xl font-black text-amber-800 mt-1">${employeeStats.shipperCount != null ? employeeStats.shipperCount : 0}</div>
                        <div class="text-[11px] text-slate-400 mt-1">Vận chuyển & Giao nhận</div>
                    </div>
                    <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-700 flex items-center justify-center">
                        <span class="material-symbols-outlined text-2xl">two_wheeler</span>
                    </div>
                </div>
            </div>

            <!-- 2. BỘ LỌC TÌM KIẾM NHÂN SỰ -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                <form action="${pageContext.request.contextPath}/admin/employees" method="GET" class="grid grid-cols-1 sm:grid-cols-12 gap-3 items-end">
                    <div class="sm:col-span-5">
                        <label class="block text-xs font-bold text-slate-600 mb-1">Tìm kiếm nhân viên</label>
                        <div class="relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-base">search</span>
                            <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo Tên, Username, SĐT, Email, Biển số xe..."
                                   class="w-full pl-9 pr-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs outline-none focus:border-primary focus:bg-white transition-colors">
                        </div>
                    </div>

                    <div class="sm:col-span-3">
                        <label class="block text-xs font-bold text-slate-600 mb-1">Vai trò / Chức vụ</label>
                        <select name="roleId" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs outline-none focus:border-primary">
                            <option value="ALL">Tất cả vai trò</option>
                            <option value="1" ${selectedRoleId == '1' ? 'selected' : ''}>Quản trị viên (Super Admin)</option>
                            <option value="2" ${selectedRoleId == '2' ? 'selected' : ''}>Nhân viên Bán hàng (Sale)</option>
                            <option value="4" ${selectedRoleId == '4' ? 'selected' : ''}>Tài xế Giao hàng (Shipper)</option>
                        </select>
                    </div>

                    <div class="sm:col-span-2">
                        <label class="block text-xs font-bold text-slate-600 mb-1">Trạng thái</label>
                        <select name="status" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs outline-none focus:border-primary">
                            <option value="ALL">Tất cả</option>
                            <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                            <option value="LOCKED" ${selectedStatus == 'LOCKED' ? 'selected' : ''}>Đã Khóa</option>
                        </select>
                    </div>

                    <div class="sm:col-span-2 flex items-center gap-2">
                        <button type="submit" class="flex-1 px-4 py-2 bg-primary hover:bg-primary-container text-white text-xs font-bold rounded-xl shadow-sm transition-colors flex items-center justify-center gap-1">
                            <span class="material-symbols-outlined text-sm">filter_alt</span> Lọc
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/employees" class="p-2 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-xl transition-colors" title="Đặt lại bộ lọc">
                            <span class="material-symbols-outlined text-sm">restart_alt</span>
                        </a>
                    </div>
                </form>
            </div>

            <!-- 3. BẢNG DANH SÁCH NHÂN SỰ & PHÂN QUYỀN -->
            <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="p-5 border-b border-slate-100 flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <h2 class="font-bold text-slate-800 text-sm">Danh sách nhân sự & phân quyền</h2>
                        <span class="px-2.5 py-0.5 rounded-full text-xs font-bold bg-slate-100 text-slate-700">${employees.size()} nhân sự</span>
                    </div>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse text-xs">
                        <thead>
                            <tr class="bg-slate-50 text-slate-600 font-bold border-b border-slate-200">
                                <th class="py-3.5 px-4">Nhân sự</th>
                                <th class="py-3.5 px-4">Tên đăng nhập & Liên hệ</th>
                                <th class="py-3.5 px-4">Vai trò (Role)</th>
                                <th class="py-3.5 px-4">Thông tin bổ sung</th>
                                <th class="py-3.5 px-4 text-center">Trạng thái</th>
                                <th class="py-3.5 px-4 text-center">Phân quyền & Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:choose>
                                <c:when test="${not empty employees}">
                                    <c:forEach var="emp" items="${employees}">
                                        <tr class="hover:bg-slate-50 transition-colors">
                                            <!-- Nhân sự -->
                                            <td class="py-3.5 px-4">
                                                <div class="flex items-center gap-3">
                                                    <img src="${emp.avatarUrl != null ? emp.avatarUrl : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'}"
                                                         class="w-10 h-10 rounded-full object-cover border-2 border-slate-200 shadow-sm flex-shrink-0">
                                                    <div>
                                                        <span class="font-bold text-slate-900 block text-xs">${emp.fullName}</span>
                                                        <span class="text-[10px] text-slate-400 font-mono">ID: #${emp.id}</span>
                                                    </div>
                                                </div>
                                            </td>

                                            <!-- Username & Liên hệ -->
                                            <td class="py-3.5 px-4">
                                                <div class="space-y-0.5">
                                                    <div class="font-mono font-bold text-primary text-xs">
                                                        @${emp.username != null ? emp.username : 'Chưa đặt'}
                                                    </div>
                                                    <div class="flex items-center gap-1 text-slate-600 text-[11px]">
                                                        <span class="material-symbols-outlined text-[13px] text-slate-400">mail</span>
                                                        <span>${emp.email != null ? emp.email : 'Chưa có email'}</span>
                                                    </div>
                                                    <div class="flex items-center gap-1 text-slate-500 text-[11px]">
                                                        <span class="material-symbols-outlined text-[13px] text-slate-400">call</span>
                                                        <span>${emp.phone != null ? emp.phone : 'Chưa cập nhật'}</span>
                                                    </div>
                                                </div>
                                            </td>

                                            <!-- Vai trò (Role) với Badge màu sắc nhận diện -->
                                            <td class="py-3.5 px-4">
                                                <c:choose>
                                                    <c:when test="${emp.roleId == 1}">
                                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-xl bg-purple-100 text-purple-800 border border-purple-200 font-bold text-[11px] shadow-sm">
                                                            <span class="material-symbols-outlined text-xs">shield_person</span>
                                                            <span>Super Admin</span>
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${emp.roleId == 2}">
                                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-xl bg-blue-100 text-blue-800 border border-blue-200 font-bold text-[11px] shadow-sm">
                                                            <span class="material-symbols-outlined text-xs">point_of_sale</span>
                                                            <span>Nhân viên Sale</span>
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${emp.roleId == 4}">
                                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-xl bg-amber-100 text-amber-800 border border-amber-200 font-bold text-[11px] shadow-sm">
                                                            <span class="material-symbols-outlined text-xs">local_shipping</span>
                                                            <span>Tài xế Shipper</span>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-xl bg-slate-100 text-slate-700 font-bold text-[11px]">
                                                            <span>Role #${emp.roleId}</span>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Thông tin bổ sung (Biển số xe...) -->
                                            <td class="py-3.5 px-4 text-slate-600">
                                                <c:choose>
                                                    <c:when test="${emp.roleId == 4}">
                                                        <div class="inline-flex items-center gap-1 bg-slate-100 px-2 py-0.5 rounded-lg font-mono text-[11px] font-bold text-slate-700 border border-slate-200">
                                                            <span class="material-symbols-outlined text-xs text-amber-600">two_wheeler</span>
                                                            <span>${emp.vehiclePlate != null ? emp.vehiclePlate : '29X1-888.88'}</span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-slate-400 italic">Văn phòng công ty</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Trạng thái -->
                                            <td class="py-3.5 px-4 text-center">
                                                <c:choose>
                                                    <c:when test="${emp.status == 'ACTIVE'}">
                                                        <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 font-bold text-[10px]">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> Đang trực
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-rose-100 text-rose-800 font-bold text-[10px]">
                                                            <span class="w-1.5 h-1.5 rounded-full bg-rose-500"></span> Đã khóa
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Phân quyền & Thao tác -->
                                            <td class="py-3.5 px-4 text-center">
                                                <div class="flex items-center justify-center gap-1.5">
                                                    <!-- Nút Đổi Role / Phân quyền -->
                                                    <button type="button" onclick="openRoleModal(${emp.id}, '${emp.fullName}', ${emp.roleId}, '${emp.status}', '${emp.vehiclePlate != null ? emp.vehiclePlate : ''}')"
                                                            class="px-2.5 py-1.5 rounded-xl bg-purple-50 hover:bg-purple-100 text-purple-700 font-bold text-[11px] border border-purple-200 transition-colors flex items-center gap-1 shadow-sm"
                                                            title="Phân quyền hoặc chuyển đổi vai trò nhân viên">
                                                        <span class="material-symbols-outlined text-sm">manage_accounts</span>
                                                        <span>Phân quyền</span>
                                                    </button>

                                                    <!-- Nút Khóa / Mở khóa -->
                                                    <form action="${pageContext.request.contextPath}/admin/employees" method="POST" class="inline"
                                                          onsubmit="return confirm('Bạn có chắc chắn muốn ${emp.status == 'ACTIVE' ? 'KHÓA' : 'KÍCH HOẠT'} tài khoản nhân viên này?');">
                                                        <input type="hidden" name="action" value="toggle_status"/>
                                                        <input type="hidden" name="userId" value="${emp.id}"/>
                                                        <input type="hidden" name="status" value="${emp.status == 'ACTIVE' ? 'LOCKED' : 'ACTIVE'}"/>

                                                        <c:choose>
                                                            <c:when test="${emp.status == 'ACTIVE'}">
                                                                <button type="submit" class="p-1.5 rounded-xl bg-rose-50 hover:bg-rose-100 text-rose-600 transition-colors" title="Khóa tài khoản này">
                                                                    <span class="material-symbols-outlined text-sm">lock</span>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="submit" class="p-1.5 rounded-xl bg-emerald-50 hover:bg-emerald-100 text-emerald-600 transition-colors" title="Kích hoạt tài khoản">
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
                                        <td colspan="6" class="py-8 text-center text-slate-400">
                                            <span class="material-symbols-outlined text-3xl block mb-1 text-slate-300">person_off</span>
                                            <span>Không tìm thấy nhân viên nào phù hợp với điều kiện lọc!</span>
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

<!-- ========================================================================= -->
<!-- MODAL 1: TẠO MỚI TÀI KHOẢN NHÂN VIÊN                                      -->
<!-- ========================================================================= -->
<div id="createEmployeeModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm hidden flex items-center justify-center p-4">
    <div class="bg-white w-full max-w-lg rounded-3xl shadow-2xl border border-slate-100 overflow-hidden animate-fade-in">
        <div class="p-5 bg-gradient-to-r from-primary to-primary-container text-white flex items-center justify-between">
            <div class="flex items-center gap-2 font-bold text-sm">
                <span class="material-symbols-outlined text-xl">person_add</span>
                <span>Thêm Mới Nhân Viên Nội Bộ</span>
            </div>
            <button type="button" onclick="closeCreateEmployeeModal()" class="text-white/80 hover:text-white">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/employees" method="POST" class="p-6 space-y-4">
            <input type="hidden" name="action" value="create"/>

            <div>
                <label class="block text-xs font-bold text-slate-700 mb-1">Họ và tên nhân viên <span class="text-rose-500">*</span></label>
                <input type="text" name="fullName" placeholder="Ví dụ: Nguyễn Văn Hoàng" required
                       class="w-full text-xs rounded-xl border-slate-200 bg-slate-50 p-2.5 focus:border-primary focus:bg-white outline-none">
            </div>

            <div class="grid grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1">Tên đăng nhập (Username) <span class="text-rose-500">*</span></label>
                    <input type="text" name="username" placeholder="sale_hoang / shipper_nam" required
                           class="w-full text-xs rounded-xl border-slate-200 bg-slate-50 p-2.5 focus:border-primary focus:bg-white outline-none">
                </div>
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1">Số điện thoại</label>
                    <input type="text" name="phone" placeholder="09xxxxxxxx"
                           class="w-full text-xs rounded-xl border-slate-200 bg-slate-50 p-2.5 focus:border-primary focus:bg-white outline-none">
                </div>
            </div>

            <div class="grid grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1">Email nội bộ</label>
                    <input type="email" name="email" placeholder="hoang@fruitables.com"
                           class="w-full text-xs rounded-xl border-slate-200 bg-slate-50 p-2.5 focus:border-primary focus:bg-white outline-none">
                </div>
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1">Mật khẩu khởi tạo <span class="text-rose-500">*</span></label>
                    <input type="password" name="password" value="123456" required
                           class="w-full text-xs rounded-xl border-slate-200 bg-slate-50 p-2.5 focus:border-primary focus:bg-white outline-none font-mono">
                </div>
            </div>

            <!-- Chọn Role -->
            <div>
                <label class="block text-xs font-bold text-slate-700 mb-1">Phân quyền Vai trò <span class="text-rose-500">*</span></label>
                <div class="grid grid-cols-2 gap-3">
                    <label class="flex items-center gap-2 p-3 rounded-xl border border-slate-200 bg-slate-50 hover:bg-blue-50/50 cursor-pointer text-xs font-semibold">
                        <input type="radio" name="roleId" value="2" checked onchange="toggleVehiclePlateInput(false)" class="text-primary focus:ring-primary">
                        <span>Nhân viên Bán hàng (Sale)</span>
                    </label>
                    <label class="flex items-center gap-2 p-3 rounded-xl border border-slate-200 bg-slate-50 hover:bg-amber-50/50 cursor-pointer text-xs font-semibold">
                        <input type="radio" name="roleId" value="4" onchange="toggleVehiclePlateInput(true)" class="text-primary focus:ring-primary">
                        <span>Tài xế Giao hàng (Shipper)</span>
                    </label>
                </div>
            </div>

            <!-- Ô nhập Biển số xe (Chỉ hiện khi chọn Shipper) -->
            <div id="vehiclePlateGroup" class="hidden animate-fade-in">
                <label class="block text-xs font-bold text-amber-800 mb-1 flex items-center gap-1">
                    <span class="material-symbols-outlined text-sm">two_wheeler</span>
                    <span>Biển số xe giao hàng (Dành cho Shipper)</span>
                </label>
                <input type="text" name="vehiclePlate" placeholder="Ví dụ: 29B1-999.88"
                       class="w-full text-xs rounded-xl border-amber-200 bg-amber-50/50 p-2.5 focus:border-amber-500 focus:bg-white outline-none font-mono font-bold text-slate-800">
            </div>

            <div class="pt-3 border-t border-slate-100 flex items-center justify-end gap-2">
                <button type="button" onclick="closeCreateEmployeeModal()" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold transition-colors">
                    Hủy
                </button>
                <button type="submit" class="px-5 py-2 bg-primary hover:bg-primary-container text-white rounded-xl text-xs font-bold transition-colors shadow-sm flex items-center gap-1">
                    <span class="material-symbols-outlined text-sm">check</span>
                    <span>Tạo Tài Khoản</span>
                </button>
            </div>
        </form>
    </div>
</div>

<!-- ========================================================================= -->
<!-- MODAL 2: PHÂN QUYỀN / CHUYỂN ĐỔI VAI TRÒ NHÂN VIÊN                        -->
<!-- ========================================================================= -->
<div id="roleModal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm hidden flex items-center justify-center p-4">
    <div class="bg-white w-full max-w-md rounded-3xl shadow-2xl border border-slate-100 overflow-hidden animate-fade-in">
        <div class="p-5 bg-purple-700 text-white flex items-center justify-between">
            <div class="flex items-center gap-2 font-bold text-sm">
                <span class="material-symbols-outlined text-xl">admin_panel_settings</span>
                <span>Phân Quyền Vai Trò Nhân Sự</span>
            </div>
            <button type="button" onclick="closeRoleModal()" class="text-white/80 hover:text-white">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/employees" method="POST" class="p-6 space-y-4">
            <input type="hidden" name="action" value="update_role"/>
            <input type="hidden" id="editUserId" name="userId"/>

            <div>
                <span class="text-xs text-slate-400 block font-semibold">Nhân viên đang phân quyền:</span>
                <span id="editFullName" class="text-base font-black text-slate-800 block mt-0.5"></span>
            </div>

            <div>
                <label class="block text-xs font-bold text-slate-700 mb-1">Vai trò mới (Role) <span class="text-rose-500">*</span></label>
                <select id="editRoleId" name="roleId" onchange="handleEditRoleChange(this.value)"
                        class="w-full text-xs font-bold rounded-xl border-slate-200 bg-slate-50 p-2.5 focus:border-purple-600 focus:bg-white outline-none">
                    <option value="1">Quản trị viên (Super Admin - Toàn quyền)</option>
                    <option value="2">Nhân viên Bán hàng (Sale - Duyệt đơn & CSKH)</option>
                    <option value="4">Tài xế Giao hàng (Shipper - Nhận đơn & Giao)</option>
                </select>
            </div>

            <!-- Biển số xe nếu là Shipper -->
            <div id="editVehicleGroup" class="hidden">
                <label class="block text-xs font-bold text-amber-800 mb-1 flex items-center gap-1">
                    <span class="material-symbols-outlined text-sm">two_wheeler</span>
                    <span>Biển số xe giao hàng</span>
                </label>
                <input type="text" id="editVehiclePlate" name="vehiclePlate" placeholder="Ví dụ: 29B1-889.99"
                       class="w-full text-xs rounded-xl border-amber-200 bg-amber-50/50 p-2.5 focus:border-amber-500 focus:bg-white outline-none font-mono font-bold text-slate-800">
            </div>

            <div>
                <label class="block text-xs font-bold text-slate-700 mb-1">Trạng thái tài khoản</label>
                <select id="editStatus" name="status" class="w-full text-xs rounded-xl border-slate-200 bg-slate-50 p-2.5 focus:border-purple-600 outline-none">
                    <option value="ACTIVE">Hoạt động bình thường</option>
                    <option value="LOCKED">Khóa tài khoản</option>
                </select>
            </div>

            <div class="pt-3 border-t border-slate-100 flex items-center justify-end gap-2">
                <button type="button" onclick="closeRoleModal()" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold transition-colors">
                    Hủy
                </button>
                <button type="submit" class="px-5 py-2 bg-purple-700 hover:bg-purple-800 text-white rounded-xl text-xs font-bold transition-colors shadow-sm flex items-center gap-1">
                    <span class="material-symbols-outlined text-sm">check</span>
                    <span>Lưu Phân Quyền</span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreateEmployeeModal() {
        document.getElementById('createEmployeeModal').classList.remove('hidden');
    }

    function closeCreateEmployeeModal() {
        document.getElementById('createEmployeeModal').classList.add('hidden');
    }

    function toggleVehiclePlateInput(isShipper) {
        const group = document.getElementById('vehiclePlateGroup');
        if (isShipper) {
            group.classList.remove('hidden');
        } else {
            group.classList.add('hidden');
        }
    }

    function openRoleModal(userId, fullName, roleId, status, vehiclePlate) {
        document.getElementById('editUserId').value = userId;
        document.getElementById('editFullName').innerText = fullName;
        document.getElementById('editRoleId').value = roleId;
        document.getElementById('editStatus').value = status;
        document.getElementById('editVehiclePlate').value = vehiclePlate || '';

        handleEditRoleChange(roleId);
        document.getElementById('roleModal').classList.remove('hidden');
    }

    function closeRoleModal() {
        document.getElementById('roleModal').classList.add('hidden');
    }

    function handleEditRoleChange(val) {
        const group = document.getElementById('editVehicleGroup');
        if (val == 4) {
            group.classList.remove('hidden');
        } else {
            group.classList.add('hidden');
        }
    }
</script>
</body>
</html>
