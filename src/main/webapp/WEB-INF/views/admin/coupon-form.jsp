<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <title>Chỉnh sửa Voucher - Fruitables Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex h-screen overflow-hidden text-gray-800 font-sans">

<div class="flex-1 flex flex-col h-full overflow-y-auto">
    <header class="h-20 bg-white border-b border-gray-200 flex items-center justify-between px-8 shadow-sm z-10 sticky top-0">
        <div class="flex items-center gap-3">
            <span class="material-symbols-outlined text-green-600 text-3xl">redeem</span>
            <h1 class="text-2xl font-extrabold text-green-700 tracking-tight">Fruitables Workspace</h1>
        </div>
        <a href="${pageContext.request.contextPath}/admin/coupons" class="flex items-center gap-2 bg-gray-100 text-gray-600 hover:bg-gray-200 hover:text-gray-900 px-4 py-2 rounded-lg font-semibold transition-colors border border-gray-200">
            <span class="material-symbols-outlined text-sm">arrow_back_ios_new</span>
            Quay lại danh sách
        </a>
    </header>

    <main class="p-8 max-w-5xl mx-auto w-full">
        <div class="mb-8">
            <h2 class="text-3xl font-bold text-gray-800 flex items-center gap-3">
                Chỉnh sửa Mã Voucher
                <span class="bg-green-100 text-green-700 px-4 py-1 rounded-full text-xl border border-green-200 shadow-sm uppercase tracking-wider">
                    ${coupon.code}
                </span>
            </h2>
            <p class="text-gray-500 mt-2">Cập nhật thông tin cấu hình, điều kiện áp dụng và thời gian cho mã giảm giá này.</p>
        </div>

        <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-8 md:p-10">
            <form action="${pageContext.request.contextPath}/admin/coupons/edit" method="POST" class="space-y-8">
                <input type="hidden" name="id" value="${coupon.id}">

                <!-- KHỐI 1: THÔNG TIN CƠ BẢN -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 pb-8 border-b border-gray-100">
                    <div class="md:col-span-1">
                        <h3 class="text-lg font-bold text-gray-800 mb-1">Thông tin cơ bản</h3>
                        <p class="text-sm text-gray-500">Mã code, số lượng và đối tượng áp dụng voucher.</p>
                    </div>
                    <div class="md:col-span-2 grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-2">Mã Voucher <span class="text-red-500">*</span></label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">tag</span>
                                <input type="text" name="code" value="${coupon.code}" required class="w-full bg-gray-50 border border-gray-300 rounded-xl pl-10 pr-4 py-2.5 outline-none focus:bg-white focus:border-green-500 focus:ring-2 focus:ring-green-200 transition-all uppercase font-semibold text-gray-800">
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-2">Số lượng giới hạn</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">inventory</span>
                                <input type="number" name="usageLimit" value="${coupon.usageLimit}" class="w-full bg-gray-50 border border-gray-300 rounded-xl pl-10 pr-4 py-2.5 outline-none focus:bg-white focus:border-green-500 focus:ring-2 focus:ring-green-200 transition-all font-semibold text-gray-800">
                            </div>
                        </div>

                        <!-- ĐỐI TƯỢNG ÁP DỤNG -->
                        <div class="md:col-span-2">
                            <label class="block text-sm font-bold text-gray-700 mb-2">Đối tượng áp dụng</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">group</span>
                                <select name="targetAudience" class="w-full bg-gray-50 border border-gray-300 rounded-xl pl-10 pr-4 py-2.5 outline-none focus:bg-white focus:border-green-500 focus:ring-2 focus:ring-green-200 transition-all font-semibold text-gray-800">
                                    <option value="ALL" ${coupon.targetAudience == 'ALL' ? 'selected' : ''}>Tất cả người dùng (Công khai)</option>
                                    <option value="REGULAR" ${coupon.targetAudience == 'REGULAR' ? 'selected' : ''}>Tài khoản người dùng thông thường</option>
                                    <option value="GMAIL" ${coupon.targetAudience == 'GMAIL' ? 'selected' : ''}>Chỉ dành riêng cho tài khoản Gmail</option>
                                </select>
                            </div>
                        </div>

                        <!-- PHẠM VI ÁP DỤNG (SẢN PHẨM) -->
                        <div class="md:col-span-2">
                            <label class="block text-sm font-bold text-gray-700 mb-2">Phạm vi áp dụng (Sản phẩm)</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">inventory_2</span>
                                <select name="productId" class="w-full bg-gray-50 border border-gray-300 rounded-xl pl-10 pr-4 py-2.5 outline-none focus:bg-white focus:border-green-500 focus:ring-2 focus:ring-green-200 transition-all font-semibold text-gray-800">
                                    <option value="" ${empty coupon.productId ? 'selected' : ''}>Toàn bộ đơn hàng (Tất cả sản phẩm)</option>
                                    <c:forEach var="p" items="${products}">
                                        <option value="${p.id}" ${coupon.productId == p.id ? 'selected' : ''}>Áp dụng riêng cho: <c:out value="${p.name}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- KHỐI 2: ĐIỀU KIỆN ÁP DỤNG -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 pb-8 border-b border-gray-100">
                    <div class="md:col-span-1">
                        <h3 class="text-lg font-bold text-gray-800 mb-1">Cấu hình giá trị</h3>
                        <p class="text-sm text-gray-500">Mức giảm và điều kiện đơn hàng tối thiểu.</p>
                    </div>
                    <div class="md:col-span-2 grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-2">Loại giảm giá</label>
                            <select name="discountType" class="w-full bg-gray-50 border border-gray-300 rounded-xl px-4 py-2.5 outline-none focus:bg-white focus:border-green-500 focus:ring-2 focus:ring-green-200 transition-all font-semibold text-gray-800">
                                <option value="FIXED" ${coupon.discountType == 'FIXED' ? 'selected' : ''}>Giảm tiền trực tiếp (VNĐ)</option>
                                <option value="PERCENT" ${coupon.discountType == 'PERCENT' ? 'selected' : ''}>Giảm theo %</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-2">Mức giảm <span class="text-red-500">*</span></label>
                            <input type="number" name="discountValue" value="${coupon.discountValue}" required class="w-full bg-red-50 border border-red-200 rounded-xl px-4 py-2.5 outline-none focus:bg-white focus:border-red-500 focus:ring-2 focus:ring-red-200 transition-all font-bold text-red-600">
                        </div>

                        <div class="md:col-span-2">
                            <label class="block text-sm font-bold text-green-700 mb-2">Điều kiện đơn tối thiểu (VNĐ) <span class="text-red-500">*</span></label>
                            <input type="number" name="minOrderValue" value="${coupon.minOrderValue}" required class="w-full bg-green-50 border border-green-300 rounded-xl px-4 py-2.5 outline-none focus:bg-white focus:border-green-600 focus:ring-2 focus:ring-green-200 transition-all font-bold text-green-700">
                        </div>
                    </div>
                </div>

                <!-- KHỐI 3: THỜI GIAN & TRẠNG THÁI -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 pb-4">
                    <div class="md:col-span-1">
                        <h3 class="text-lg font-bold text-gray-800 mb-1">Thời hạn & Trạng thái</h3>
                    </div>
                    <div class="md:col-span-2 grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-2">Thời gian Bắt đầu</label>
                            <input type="datetime-local" name="startDate" value="<fmt:formatDate value="${coupon.startDate}" pattern="yyyy-MM-dd'T'HH:mm"/>" required class="w-full bg-gray-50 border border-gray-300 rounded-xl px-4 py-2.5 outline-none focus:border-green-500 font-semibold text-gray-800">
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-2">Thời gian Kết thúc</label>
                            <input type="datetime-local" name="endDate" value="<fmt:formatDate value="${coupon.endDate}" pattern="yyyy-MM-dd'T'HH:mm"/>" required class="w-full bg-gray-50 border border-gray-300 rounded-xl px-4 py-2.5 outline-none focus:border-green-500 font-semibold text-gray-800">
                        </div>

                        <div class="md:col-span-2 mt-2">
                            <label class="flex items-center gap-3 p-4 border border-gray-200 rounded-xl bg-gray-50 cursor-pointer hover:bg-gray-100 transition-colors w-max">
                                <input type="checkbox" name="status" id="status" ${coupon.status ? 'checked' : ''} class="w-6 h-6 text-green-600 bg-white border-gray-300 rounded focus:ring-green-500">
                                <span class="font-bold text-gray-700 select-none">Cho phép mã này hoạt động trên hệ thống</span>
                            </label>
                        </div>
                    </div>
                </div>

                <div class="pt-6 border-t border-gray-100 flex items-center justify-end gap-4 mt-8">
                    <a href="${pageContext.request.contextPath}/admin/coupons" class="px-6 py-3 bg-white border border-gray-300 text-gray-700 font-bold rounded-xl hover:bg-gray-50 transition-colors">Hủy bỏ</a>
                    <button type="submit" class="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-8 rounded-xl shadow-lg transition-all">Lưu Cập Nhật</button>
                </div>
            </form>
        </div>
    </main>
</div>
</body>
</html>