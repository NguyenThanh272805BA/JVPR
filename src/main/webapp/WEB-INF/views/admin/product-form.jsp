<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <title>Thêm Sản Phẩm Mới - Fruitables Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 flex h-screen overflow-hidden text-gray-800">

<!-- Cấu trúc Sidebar & Header Admin giản lược cho form -->
<div class="flex-1 flex flex-col h-full overflow-y-auto">
    <header class="h-20 bg-white border-b border-gray-200 flex items-center px-8">
        <h1 class="text-2xl font-bold text-green-700">Fruitables Workspace</h1>
        <a href="${pageContext.request.contextPath}/admin/products" class="ml-auto text-blue-600 font-semibold hover:underline">Quay lại danh sách</a>
    </header>

    <main class="p-8 max-w-4xl mx-auto w-full">
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-8">
            <h2 class="text-xl font-bold mb-6 border-b pb-4">Thêm sản phẩm mới</h2>

            <c:if test="${param.message == 'Error'}">
                <div class="bg-red-100 text-red-600 p-3 rounded mb-4 font-semibold">Lỗi hệ thống khi thêm sản phẩm!</div>
            </c:if>

            <!-- FORM MULTIPART -->
            <form action="${pageContext.request.contextPath}/admin/products/add" method="POST" enctype="multipart/form-data" class="space-y-6">

                <div class="grid grid-cols-2 gap-6">
                    <div>
                        <label class="block font-semibold mb-2">Tên sản phẩm *</label>
                        <input type="text" name="name" required class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:outline-none focus:border-green-500">
                    </div>

                    <div>
                        <label class="block font-semibold mb-2">Danh mục *</label>
                        <select name="categoryId" class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:outline-none focus:border-green-500">
                            <option value="1">Trái cây nhập khẩu</option>
                            <option value="2">Trái cây nội địa</option>
                            <option value="3">Rau xanh</option>
                        </select>
                    </div>

                    <div>
                        <label class="block font-semibold mb-2">Giá bán (VNĐ) *</label>
                        <input type="number" name="price" required min="0" class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:outline-none focus:border-green-500">
                    </div>

                    <div>
                        <label class="block font-semibold mb-2">Tồn kho ban đầu *</label>
                        <input type="number" name="stock" required min="0" class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:outline-none focus:border-green-500">
                    </div>
                </div>

                <div>
                    <label class="block font-semibold mb-2">Mô tả sản phẩm</label>
                    <textarea name="description" rows="4" class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:outline-none focus:border-green-500"></textarea>
                </div>

                <div>
                    <label class="block font-semibold mb-2">Ảnh sản phẩm *</label>
                    <input type="file" name="imageFile" accept="image/*" required class="w-full border border-gray-300 px-4 py-2 rounded-lg file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-green-50 file:text-green-700 hover:file:bg-green-100">
                </div>

                <div class="flex items-center">
                    <input type="checkbox" name="status" id="status" checked class="w-5 h-5 text-green-600 rounded">
                    <label for="status" class="ml-2 font-semibold">Kích hoạt bán ngay lập tức</label>
                </div>

                <div class="pt-4 border-t border-gray-200 text-right">
                    <button type="submit" class="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-8 rounded-lg shadow-md transition-colors">
                        Lưu Sản Phẩm
                    </button>
                </div>
            </form>
        </div>
    </main>
</div>
</body>
</html>