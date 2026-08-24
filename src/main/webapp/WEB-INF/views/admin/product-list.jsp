<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Fruitables - Quản lý Sản phẩm</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-surface font-body-md text-body-md flex h-screen overflow-hidden">

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<c:set var="currentURI" value="${requestScope['javax.servlet.forward.request_uri']}" />
<aside class="w-64 bg-surface-container-lowest border-r border-surface-variant flex flex-col h-full flex-shrink-0 z-20 shadow-sm hidden md:flex">
    <div class="h-20 flex items-center px-6 border-b border-surface-variant">
        <span class="font-display-lg text-xl font-extrabold text-primary">Fruitables</span>
    </div>
    <nav class="flex-1 overflow-y-auto py-6 px-4 space-y-2">
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/dashboard') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="material-symbols-outlined">dashboard</span>
            <span class="font-label-bold">Tổng quan</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/products') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/products">
            <span class="material-symbols-outlined">inventory_2</span>
            <span class="font-label-bold">Sản phẩm</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/categories') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/categories">
            <span class="material-symbols-outlined">category</span>
            <span class="font-label-bold">Danh mục</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/orders') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/orders">
            <span class="material-symbols-outlined">receipt_long</span>
            <span class="font-label-bold">Đơn hàng</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/coupons') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/coupons">
            <span class="material-symbols-outlined">redeem</span>
            <span class="font-label-bold">Mã khuyến mãi</span>
        </a>
    </nav>
</aside>

<!-- Main Content -->
<main class="flex-1 flex flex-col h-screen overflow-hidden">

    <!-- Header -->
    <header class="h-20 bg-surface flex items-center justify-between px-margin-desktop shadow-[0px_4px_20px_rgba(0,0,0,0.05)] z-10 flex-shrink-0">
        <div class="flex items-center md:hidden">
            <button class="p-2 text-on-surface-variant">
                <span class="material-symbols-outlined">menu</span>
            </button>
        </div>
        <div class="flex items-center flex-1 md:justify-end justify-between">
            <div class="relative w-full max-w-md hidden md:block mr-6">
                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">search</span>
                <input class="w-full pl-10 pr-4 py-2 rounded-md border border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary outline-none font-body-md text-body-md bg-surface-container-lowest" placeholder="Tìm kiếm..." type="text"/>
            </div>
            <div class="flex items-center gap-4">
                <span class="font-label-bold text-label-bold mr-2">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full transition-colors flex items-center" title="Đăng xuất">
                    <span class="material-symbols-outlined">logout</span>
                </a>
            </div>
        </div>
    </header>

    <!-- Scrollable Content Area -->
    <div class="flex-1 overflow-y-auto p-margin-mobile md:p-margin-desktop bg-[#f8fafc]">

        <!-- Page Header -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
            <h1 class="font-headline-md text-headline-md text-on-surface">Quản lý Sản phẩm</h1>
            <!-- Đã gắn link chuyển hướng sang form Thêm sản phẩm mới -->
            <a href="${pageContext.request.contextPath}/admin/products/add" class="flex items-center gap-2 bg-primary-container hover:bg-primary text-on-primary px-6 py-3 rounded-full font-label-bold text-label-bold transition-all duration-200 shadow-[0_4px_12px_rgba(129,196,8,0.15)] hover:-translate-y-1">
                <span class="material-symbols-outlined">add</span>
                Thêm sản phẩm mới
            </a>
        </div>

        <!-- Data Table Card -->
        <div class="bg-surface-container-lowest rounded-lg shadow-[0px_4px_20px_rgba(0,0,0,0.05)] overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                    <tr class="border-b border-surface-variant bg-surface-container-low text-on-surface-variant font-label-bold text-label-bold">
                        <th class="py-4 px-6">Mã SP</th>
                        <th class="py-4 px-6">Hình ảnh</th>
                        <th class="py-4 px-6">Tên sản phẩm</th>
                        <th class="py-4 px-6">Danh mục</th>
                        <th class="py-4 px-6">Giá</th>
                        <th class="py-4 px-6">Tồn kho</th>
                        <th class="py-4 px-6">Trạng thái</th>
                        <th class="py-4 px-6 text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-surface-variant">
                    <c:forEach var="item" items="${products}">
                        <tr class="hover:bg-surface-container-lowest transition-colors">
                            <td class="py-4 px-6 text-on-surface-variant font-medium">#PRD-<c:out value="${item.id}"/></td>
                            <td class="py-4 px-6">
                                <div class="w-12 h-12 rounded bg-surface-container overflow-hidden">
                                    <img class="w-full h-full object-cover" src="${item.imageUrl}" alt="Product Image"/>
                                </div>
                            </td>
                            <td class="py-4 px-6 font-label-bold text-label-bold text-on-surface"><c:out value="${item.name}"/></td>
                            <td class="py-4 px-6 text-on-surface-variant"><c:out value="${item.categoryName}"/></td>
                            <td class="py-4 px-6 font-price-tag text-price-tag text-primary">
                                <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> ₫
                            </td>
                            <td class="py-4 px-6 text-on-surface-variant"><c:out value="${item.stock}"/></td>
                            <td class="py-4 px-6">
                                <c:choose>
                                    <c:when test="${item.stock > 20}">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-secondary-container text-on-secondary-container">Còn hàng</span>
                                    </c:when>
                                    <c:when test="${item.stock > 0}">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-error-container text-on-error-container" style="background-color:#ffe4b5; color:#b8860b">Sắp hết hàng</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-surface-variant text-on-surface-variant">Hết hàng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <!-- Đã mapping nút Sửa trỏ trực tiếp đến trang chỉnh sửa theo ID sản phẩm -->
                            <td class="py-4 px-6 text-center">
                                <a href="${pageContext.request.contextPath}/admin/products/edit?id=${item.id}" class="text-on-surface-variant hover:text-primary mx-1 transition-colors" title="Sửa">
                                    <span class="material-symbols-outlined">edit</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/products/delete?id=${item.id}" onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này không?');" class="text-on-surface-variant hover:text-error mx-1 transition-colors" title="Xóa">
                                    <span class="material-symbols-outlined">delete</span>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
</body>
</html>