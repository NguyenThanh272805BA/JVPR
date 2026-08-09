<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Fruitables Admin Dashboard</title>

    <!-- Cấu hình CSS/Tailwind dùng chung từ Giai đoạn 2 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>

    <style>
        .sidebar-item-active {
            background-color: #81c408;
            color: white;
        }
        .sidebar-item-active .material-symbols-outlined {
            color: white;
        }
    </style>
</head>
<body class="bg-background text-on-surface font-body-md text-body-md flex h-screen overflow-hidden">

<!-- Sidebar -->
<aside class="w-64 bg-surface-container-lowest border-r border-surface-variant flex flex-col h-full flex-shrink-0 z-20 shadow-[0px_4px_20px_rgba(0,0,0,0.05)]">
    <div class="h-20 flex items-center px-6 border-b border-surface-variant">
        <span class="font-display-lg text-display-lg-mobile font-extrabold text-primary">Fruitables</span>
    </div>
    <nav class="flex-1 overflow-y-auto py-6 px-4 space-y-2">
        <a class="sidebar-item-active flex items-center gap-3 px-4 py-3 rounded-lg transition-colors" href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">dashboard</span>
            <span class="font-label-bold text-label-bold">Dashboard</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-primary transition-colors" href="${pageContext.request.contextPath}/admin/products">
            <span class="material-symbols-outlined">inventory_2</span>
            <span class="font-label-bold text-label-bold">Products</span>
        </a>
        <!-- Các menu khác -->
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-primary transition-colors" href="#">
            <span class="material-symbols-outlined">category</span>
            <span class="font-label-bold text-label-bold">Categories</span>
        </a>
        <a class="flex items-center gap-3 px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-low hover:text-primary transition-colors" href="#">
            <span class="material-symbols-outlined">receipt_long</span>
            <span class="font-label-bold text-label-bold">Orders</span>
        </a>
    </nav>
</aside>

<!-- Main Content Wrapper -->
<div class="flex-1 flex flex-col h-full overflow-hidden">

    <!-- Header -->
    <header class="h-20 bg-surface-container-lowest border-b border-surface-variant flex items-center justify-between px-margin-desktop flex-shrink-0 z-10 shadow-[0px_4px_20px_rgba(0,0,0,0.02)]">
        <div class="flex items-center w-full max-w-md">
            <div class="relative w-full">
                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">search</span>
                <input class="w-full pl-10 pr-4 py-2 bg-surface-container rounded-md border-transparent focus:border-primary-container focus:ring-1 focus:ring-primary-container font-body-md text-body-md transition-shadow" placeholder="Search..." type="text"/>
            </div>
        </div>
        <div class="flex items-center gap-6">
            <div class="flex items-center gap-3">
                <div class="flex flex-col text-right">
                    <!-- Lấy tên từ Session -->
                    <span class="font-label-bold text-label-bold text-on-surface">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}</span>
                    <span class="text-sm text-on-surface-variant">Quản trị viên</span>
                </div>
                <span class="material-symbols-outlined text-4xl text-primary" style="font-variation-settings: 'FILL' 1;">account_circle</span>
            </div>
            <!-- Nút Logout -->
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-2 text-error hover:text-on-error-container transition-colors">
                <span class="material-symbols-outlined">logout</span>
                <span class="font-label-bold text-label-bold">Logout</span>
            </a>
        </div>
    </header>

    <!-- Main Scrollable Area -->
    <main class="flex-1 overflow-y-auto p-margin-desktop bg-background">
        <div class="max-w-container-max-width mx-auto space-y-8">
            <div>
                <h1 class="font-headline-md text-headline-md text-on-surface">Overview</h1>
            </div>

            <!-- Stats Row -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-gutter">
                <!-- Stat Card 1 -->
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-transform duration-300">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-on-surface-variant font-label-bold text-label-bold">Total Revenue</span>
                        <div class="w-10 h-10 rounded-full bg-primary-container/20 flex items-center justify-center text-primary-container">
                            <span class="material-symbols-outlined">payments</span>
                        </div>
                    </div>
                    <div class="font-price-tag text-price-tag text-primary">${totalRevenue} ₫</div>
                </div>
                <!-- Stat Card 2 -->
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-transform duration-300">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-on-surface-variant font-label-bold text-label-bold">Total Orders</span>
                        <div class="w-10 h-10 rounded-full bg-primary-container/20 flex items-center justify-center text-primary-container">
                            <span class="material-symbols-outlined">shopping_cart</span>
                        </div>
                    </div>
                    <div class="font-price-tag text-price-tag text-on-surface">${totalOrders}</div>
                </div>
                <!-- Stat Card 3 -->
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-transform duration-300">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-on-surface-variant font-label-bold text-label-bold">Total Products</span>
                        <div class="w-10 h-10 rounded-full bg-primary-container/20 flex items-center justify-center text-primary-container">
                            <span class="material-symbols-outlined">inventory_2</span>
                        </div>
                    </div>
                    <div class="font-price-tag text-price-tag text-on-surface">${totalProducts}</div>
                </div>
                <!-- Stat Card 4 -->
                <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] hover:-translate-y-1 transition-transform duration-300">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-on-surface-variant font-label-bold text-label-bold">Out of Stock</span>
                        <div class="w-10 h-10 rounded-full bg-error-container text-error flex items-center justify-center">
                            <span class="material-symbols-outlined">warning</span>
                        </div>
                    </div>
                    <div class="font-price-tag text-price-tag text-error">${outOfStock}</div>
                </div>
            </div>

            <!-- Chart Section -->
            <div class="bg-surface-container-lowest p-6 rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] h-96 flex flex-col">
                <h2 class="font-label-bold text-label-bold text-on-surface mb-4">Revenue Overview</h2>
                <div class="flex-1 border-2 border-dashed border-surface-variant rounded-lg flex items-center justify-center bg-surface-container/30">
                    <span class="text-outline font-body-md text-body-md">Chart.js Canvas Placeholder here</span>
                </div>
            </div>

            <!-- Recent Products (Dummy Data) -->
            <div class="bg-surface-container-lowest rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] overflow-hidden">
                <div class="p-6 border-b border-surface-variant flex justify-between items-center">
                    <h2 class="font-label-bold text-label-bold text-on-surface">Recent Products</h2>
                    <a href="${pageContext.request.contextPath}/admin/products" class="text-primary-container hover:text-primary font-label-bold text-label-bold transition-colors">View All</a>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                        <tr class="bg-surface-container text-on-surface-variant font-label-bold text-label-bold text-sm">
                            <th class="py-4 px-6 font-medium">ID</th>
                            <th class="py-4 px-6 font-medium">Image</th>
                            <th class="py-4 px-6 font-medium">Name</th>
                            <th class="py-4 px-6 font-medium">Category</th>
                            <th class="py-4 px-6 font-medium">Price</th>
                            <th class="py-4 px-6 font-medium">Stock</th>
                            <th class="py-4 px-6 font-medium">Status</th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-surface-variant text-body-md text-on-surface">
                        <!-- Dummy Row 1 -->
                        <tr class="hover:bg-surface-bright transition-colors">
                            <td class="py-4 px-6">#PRD-001</td>
                            <td class="py-4 px-6">
                                <div class="w-12 h-12 bg-surface-variant rounded-md flex items-center justify-center text-outline">
                                    <span class="material-symbols-outlined text-sm">image</span>
                                </div>
                            </td>
                            <td class="py-4 px-6 font-medium">Organic Bananas</td>
                            <td class="py-4 px-6 text-on-surface-variant">Fruits</td>
                            <td class="py-4 px-6">45,000 ₫</td>
                            <td class="py-4 px-6">120</td>
                            <td class="py-4 px-6">
                                <span class="px-3 py-1 bg-primary-container/20 text-primary-container rounded-full text-xs font-semibold">Active</span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>