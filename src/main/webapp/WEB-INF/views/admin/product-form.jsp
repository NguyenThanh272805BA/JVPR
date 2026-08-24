<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <title>${product != null ? 'Sửa' : 'Thêm'} Sản Phẩm - Fruitables Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 flex h-screen overflow-hidden text-gray-800">

<div class="flex-1 flex flex-col h-full overflow-y-auto">
    <header class="h-20 bg-white border-b border-gray-200 flex items-center px-8">
        <h1 class="text-2xl font-bold text-green-700">Fruitables Workspace</h1>
        <a href="${pageContext.request.contextPath}/admin/products" class="ml-auto text-blue-600 font-semibold hover:underline">Quay lại danh sách</a>
    </header>

    <main class="p-8 max-w-4xl mx-auto w-full">
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-8">
            <h2 class="text-xl font-bold mb-6 border-b pb-4">${product != null ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới'}</h2>

            <c:if test="${param.message == 'Error'}">
                <div class="bg-red-100 text-red-600 p-3 rounded mb-4 font-semibold">Lỗi hệ thống khi lưu sản phẩm!</div>
            </c:if>

            <!-- Action linh hoạt: Tùy thuộc đang Sửa hay Thêm -->
            <form action="${pageContext.request.contextPath}/admin/products/${product != null ? 'edit' : 'add'}" method="POST" enctype="multipart/form-data" class="space-y-6">

                <c:if test="${product != null}">
                    <input type="hidden" name="id" value="${product.id}">
                </c:if>

                <!-- Dòng 1: Tên và Danh mục (Chia 2 cột) -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label class="block font-semibold mb-2">Tên sản phẩm *</label>
                        <input type="text" name="name" value="${product != null ? product.name : ''}" required class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:outline-none focus:border-green-500">
                    </div>

                    <div>
                        <label class="block font-semibold mb-2">Danh mục *</label>
                        <select name="categoryId" class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:outline-none focus:border-green-500">
                            <option value="1" ${product != null && product.categoryId == 1 ? 'selected' : ''}>Trái cây nhập khẩu</option>
                            <option value="2" ${product != null && product.categoryId == 2 ? 'selected' : ''}>Trái cây nội địa</option>
                            <option value="3" ${product != null && product.categoryId == 3 ? 'selected' : ''}>Rau xanh</option>
                        </select>
                    </div>
                </div>

                <!-- Dòng 2: Giá gốc, Giá khuyến mãi, Tồn kho (Chia 3 cột) -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div>
                        <label class="block font-semibold mb-2">Giá gốc (VNĐ) *</label>
                        <input type="number" name="price" value="${product != null ? product.price : ''}" required min="0" class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:outline-none focus:border-green-500">
                    </div>

                    <div>
                        <label class="block font-semibold mb-2 text-red-600">Giá khuyến mãi (Tùy chọn)</label>
                        <input type="number" name="discountPrice" value="${product != null ? product.discountPrice : ''}" min="0" placeholder="Để trống nếu không giảm" class="w-full border border-red-300 px-4 py-2 rounded-lg focus:outline-none focus:border-red-500 bg-red-50">
                    </div>

                    <div>
                        <label class="block font-semibold mb-2">Tồn kho *</label>
                        <input type="number" name="stock" value="${product != null ? product.stock : ''}" required min="0" class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:outline-none focus:border-green-500">
                    </div>
                </div>

                <!-- Dòng 3: Mô tả -->
                <div>
                    <label class="block font-semibold mb-2">Mô tả sản phẩm</label>
                    <textarea name="description" rows="4" class="w-full border border-gray-300 px-4 py-2 rounded-lg focus:outline-none focus:border-green-500">${product != null ? product.description : ''}</textarea>
                </div>

                <!-- Dòng 4: Upload Ảnh -->
                <div>
                    <label class="block font-semibold mb-2">Ảnh sản phẩm ${product == null ? '*' : '(Bỏ trống nếu giữ nguyên)'}</label>
                    <!-- Bắt buộc chọn ảnh nếu là Thêm mới (product == null), không bắt buộc nếu là Sửa -->
                    <input type="file" name="imageFile" accept="image/*" ${product == null ? 'required' : ''} class="w-full border border-gray-300 px-4 py-2 rounded-lg file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-green-50 file:text-green-700 hover:file:bg-green-100">

                    <c:if test="${product != null && product.imageUrl != null}">
                        <div class="mt-4">
                            <p class="text-sm text-gray-500 mb-2">Ảnh hiện tại:</p>
                            <img src="${product.imageUrl}" class="w-32 h-32 object-cover rounded-md border border-gray-200 shadow-sm">
                        </div>
                    </c:if>
                </div>

                <!-- Dòng 5: Trạng thái -->
                <div class="flex items-center">
                    <input type="checkbox" name="status" id="status" ${product == null || product.status ? 'checked' : ''} class="w-5 h-5 text-green-600 rounded focus:ring-green-500">
                    <label for="status" class="ml-2 font-semibold cursor-pointer">Kích hoạt bán ngay lập tức</label>
                </div>

                <!-- Nút Submit -->
                <div class="pt-4 border-t border-gray-200 text-right">
                    <button type="submit" class="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-8 rounded-lg shadow-md transition-colors">
                        ${product != null ? 'Cập nhật Sản Phẩm' : 'Lưu Sản Phẩm'}
                    </button>
                </div>
            </form>
        </div>
    </main>
</div>
</body>
</html>