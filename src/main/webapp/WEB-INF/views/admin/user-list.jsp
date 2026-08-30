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
        <span class="font-display-lg text-xl font-extrabold text-primary">Fruitables</span>
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
                <div class="bg-primary-container/20 border border-primary-container text-primary p-4 rounded-xl flex items-center gap-3">
                    <span class="material-symbols-outlined">check_circle</span>
                    <span class="font-label-bold">Cập nhật quyền và trạng thái người dùng thành công!</span>
                </div>
            </c:if>

            <div class="bg-surface-container-lowest rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] overflow-hidden border border-surface-variant">
                <div class="p-6 border-b border-surface-variant flex justify-between items-center bg-surface-container-lowest">
                    <h2 class="font-label-bold text-lg text-on-surface">Tất cả tài khoản</h2>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                        <tr class="bg-surface-container text-on-surface-variant font-label-bold text-sm">
                            <th class="py-4 px-6 font-medium">Họ tên</th>
                            <th class="py-4 px-6 font-medium">Email / Phân loại</th>
                            <th class="py-4 px-6 font-medium">Phân quyền</th>
                            <th class="py-4 px-6 font-medium">Trạng thái</th>
                            <th class="py-4 px-6 font-medium text-center">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-surface-variant text-body-md text-on-surface">
                        <c:forEach var="u" items="${users}">
                            <tr class="hover:bg-surface-bright transition-colors">
                                <td class="py-4 px-6 font-label-bold">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-full bg-primary-container/20 flex items-center justify-center text-primary">
                                            <span class="material-symbols-outlined">person</span>
                                        </div>
                                            ${u.fullName}
                                    </div>
                                </td>
                                <td class="py-4 px-6">
                                    <div class="text-on-surface">${u.email}</div>
                                    <span class="inline-flex items-center gap-1 mt-1 px-2 py-0.5 rounded-md text-[10px] font-bold ${u.loginType == 'GOOGLE' ? 'bg-secondary-container text-on-secondary-container' : 'bg-surface-variant text-on-surface-variant'}">
                                            ${u.loginType}
                                    </span>
                                </td>
                                <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                                    <input type="hidden" name="id" value="${u.id}">
                                    <td class="py-4 px-6">
                                        <select name="roleId" class="w-full px-3 py-2 border border-outline-variant rounded-lg bg-surface-container-lowest outline-none focus:border-primary text-sm">
                                            <option value="1" ${u.roleId == 1 ? 'selected' : ''}>Super Admin</option>
                                            <option value="2" ${u.roleId == 2 ? 'selected' : ''}>Nhân viên Sale</option>
                                            <option value="3" ${u.roleId == 3 ? 'selected' : ''}>Khách hàng</option>
                                        </select>
                                    </td>
                                    <td class="py-4 px-6">
                                        <select name="status" class="w-full px-3 py-2 border border-outline-variant rounded-lg outline-none text-sm ${u.status == 'ACTIVE' ? 'bg-primary-container/10 text-primary-container border-primary-container/30' : 'bg-error-container/10 text-error border-error-container/30'}">
                                            <option value="ACTIVE" ${u.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="LOCKED" ${u.status == 'LOCKED' ? 'selected' : ''}>Đã Khóa</option>
                                        </select>
                                    </td>
                                    <td class="py-4 px-6 text-center">
                                        <button type="submit" class="px-4 py-2 bg-primary text-white font-label-bold rounded-lg hover:bg-primary-container transition-colors shadow-sm text-sm inline-flex items-center gap-1">
                                            <span class="material-symbols-outlined text-[18px]">save</span> Lưu
                                        </button>
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
</body>
</html>