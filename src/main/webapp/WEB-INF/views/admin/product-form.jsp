<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <title>${product != null ? 'Sửa' : 'Thêm'} Sản Phẩm - Fruitables Admin</title>

    <!-- Cấu hình TailwindCSS (Cùng chuẩn với hệ thống) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>

    <!-- Tích hợp CKEditor 5 -->
    <script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>

    <style>
        /* Tùy chỉnh chiều cao CKEditor */
        .ck-editor__editable_inline {
            min-height: 300px;
            font-family: inherit;
        }
        /* PHỤC HỒI LẠI ĐỊNH DẠNG CSS BỊ TAILWIND XÓA (Dành riêng cho vùng CKEditor) */
        .ck-content h2 { display: block; font-size: 1.5em; font-weight: bold; margin-top: 1em; margin-bottom: 0.5em; }
        .ck-content h3 { display: block; font-size: 1.17em; font-weight: bold; margin-top: 1em; margin-bottom: 0.5em; }
        .ck-content p { display: block; margin-bottom: 1em; line-height: 1.6; }
        .ck-content ul { display: block; list-style-type: disc; margin-bottom: 1em; padding-left: 40px; }
        .ck-content ol { display: block; list-style-type: decimal; margin-bottom: 1em; padding-left: 40px; }
        .ck-content strong { font-weight: bold; }
        .ck-content i { font-style: italic; }
        .ck-content blockquote { border-left: 4px solid #81c408; padding-left: 1rem; color: #6b7280; font-style: italic; }
    </style>
</head>
<body class="bg-surface-container flex h-screen overflow-hidden text-on-surface">

<!-- Toast Notification Container -->
<div id="toast-container" class="fixed top-5 right-5 z-50 flex flex-col gap-3 pointer-events-none"></div>

<div class="flex-1 flex flex-col h-full overflow-y-auto">
    <!-- Header -->
    <header class="h-20 bg-surface-container-lowest border-b border-surface-variant flex items-center justify-between px-8 shadow-sm sticky top-0 z-40">
        <div class="flex items-center gap-4">
            <div class="w-10 h-10 bg-primary-container text-primary rounded-lg flex items-center justify-center">
                <span class="material-symbols-outlined">inventory_2</span>
            </div>
            <h1 class="text-xl font-headline-md font-bold text-on-surface">
                ${product != null ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới'}
            </h1>
        </div>
        <a href="${pageContext.request.contextPath}/admin/products" class="flex items-center gap-2 text-on-surface-variant hover:text-primary transition-colors font-label-bold">
            <span class="material-symbols-outlined text-[20px]">arrow_back</span>
            Quay lại danh sách
        </a>
    </header>

    <main class="p-8 max-w-5xl mx-auto w-full">
        <form action="${pageContext.request.contextPath}/admin/products/${product != null ? 'edit' : 'add'}" method="POST" enctype="multipart/form-data" class="space-y-6">

            <c:if test="${product != null}">
                <input type="hidden" name="id" value="${product.id}">
            </c:if>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Cột chính (Rộng 2/3) -->
                <div class="lg:col-span-2 space-y-6">

                    <!-- Card 1: Thông tin cơ bản -->
                    <div class="bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant p-6">
                        <h2 class="text-lg font-label-bold mb-4 border-b border-surface-variant pb-2 text-primary">Thông tin cơ bản</h2>
                        <div class="space-y-4">
                            <div>
                                <label class="block font-label-bold text-sm mb-1">Tên sản phẩm <span class="text-error">*</span></label>
                                <input type="text" name="name" value="${product != null ? product.name : ''}" required placeholder="VD: Táo Envy Mỹ size lớn"
                                       class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-colors bg-surface">
                            </div>
                            <div>
                                <label class="block font-label-bold text-sm mb-1">Mô tả ngắn</label>
                                <textarea name="description" rows="2" placeholder="Hiển thị ở trang danh sách sản phẩm..."
                                          class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-colors bg-surface">${product != null ? product.description : ''}</textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Card 2: Nội dung chi tiết (CKEditor) -->
                    <div class="bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant p-6">
                        <h2 class="text-lg font-label-bold mb-4 border-b border-surface-variant pb-2 text-primary">Bài viết giới thiệu</h2>
                        <div>
                            <textarea name="detailedDescription" id="detailedDescription">${product != null ? product.detailedDescription : ''}</textarea>
                        </div>
                    </div>

                </div>

                <!-- Cột phụ (Rộng 1/3) -->
                <div class="space-y-6">

                    <!-- Card 3: Phân loại & Trạng thái -->
                    <div class="bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant p-6">
                        <h2 class="text-lg font-label-bold mb-4 border-b border-surface-variant pb-2 text-primary">Phân loại</h2>
                        <div class="space-y-4">
                            <div>
                                <label class="block font-label-bold text-sm mb-1">Danh mục <span class="text-error">*</span></label>
                                <select name="categoryId" class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary bg-surface">
                                    <option value="1" ${product != null && product.categoryId == 1 ? 'selected' : ''}>Trái cây nhập khẩu</option>
                                    <option value="2" ${product != null && product.categoryId == 2 ? 'selected' : ''}>Trái cây nội địa</option>
                                    <option value="3" ${product != null && product.categoryId == 3 ? 'selected' : ''}>Rau xanh</option>
                                </select>
                            </div>
                            <div class="flex items-center gap-3 pt-2">
                                <input type="checkbox" name="status" id="status" ${product == null || product.status ? 'checked' : ''}
                                       class="w-5 h-5 text-primary border-outline-variant rounded focus:ring-primary">
                                <label for="status" class="font-label-bold text-sm cursor-pointer select-none">Kích hoạt bán ngay</label>
                            </div>
                        </div>
                    </div>

                    <!-- Card 4: Giá & Kho -->
                    <div class="bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant p-6">
                        <h2 class="text-lg font-label-bold mb-4 border-b border-surface-variant pb-2 text-primary">Định giá & Tồn kho</h2>
                        <div class="space-y-4">
                            <div>
                                <label class="block font-label-bold text-sm mb-1">Giá gốc (VNĐ) <span class="text-error">*</span></label>
                                <input type="number" name="price" value="${product != null ? product.price : ''}" required min="0"
                                       class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary bg-surface">
                            </div>
                            <div>
                                <label class="block font-label-bold text-sm mb-1">Thuế VAT (%) <span class="text-error">*</span></label>
                                <input type="number" name="taxRate" value="${product != null ? product.taxRate : '0'}" step="0.01" min="0" required
                                       class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary bg-surface">
                            </div>
                            <div>
                                <label class="block font-label-bold text-sm mb-1 text-error">Giá khuyến mãi</label>
                                <input type="number" name="discountPrice" value="${product != null ? product.discountPrice : ''}" min="0" placeholder="Để trống nếu không giảm"
                                       class="w-full border border-error/50 px-4 py-2.5 rounded-lg focus:outline-none focus:border-error focus:ring-1 focus:ring-error bg-error-container/10">
                            </div>
                            <div>
                                <label class="block font-label-bold text-sm mb-1">Số lượng tồn kho <span class="text-error">*</span></label>
                                <input type="number" name="stock" value="${product != null ? product.stock : ''}" required min="0"
                                       class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary bg-surface">
                            </div>
                        </div>
                    </div>

                    <!-- Card 5: Cấu hình vận chuyển & Bảo quản -->
                    <div class="bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant p-6">
                        <h2 class="text-lg font-label-bold mb-4 border-b border-surface-variant pb-2 text-primary flex items-center gap-2">
                            <span class="material-symbols-outlined text-xl">local_shipping</span> Vận chuyển & Bảo quản
                        </h2>
                        <div class="space-y-4">
                            <div>
                                <label class="block font-label-bold text-sm mb-1">Trọng lượng (Gram) <span class="text-error">*</span></label>
                                <input type="number" name="weightGram" value="${product != null && product.weightGram != null ? product.weightGram : '500'}" required min="1" step="10" placeholder="VD: 500 hoặc 1000"
                                       class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary bg-surface text-sm">
                                <p class="text-[11px] text-on-surface-variant mt-1">Dùng để cộng dồn tính phụ phí hàng nặng (> 5kg: +5.000 ₫/kg).</p>
                            </div>

                            <div>
                                <label class="block font-label-bold text-sm mb-1">Quy cách bảo quản</label>
                                <select name="storageType" class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary bg-surface text-sm">
                                    <option value="NORMAL" ${product == null || product.storageType == 'NORMAL' ? 'selected' : ''}>Tiêu chuẩn (Nhiệt độ phòng thường)</option>
                                    <option value="COLD_CHAIN" ${product != null && product.storageType == 'COLD_CHAIN' ? 'selected' : ''}>❄️ Chuỗi lạnh / Ướp đá (+10.000 ₫ ship)</option>
                                    <option value="FRAGILE_GIFT" ${product != null && product.storageType == 'FRAGILE_GIFT' ? 'selected' : ''}>🎁 Dễ dập nát / Hộp quà cao cấp (+20.000 ₫ ship)</option>
                                </select>
                            </div>

                            <div class="flex items-center gap-3 pt-2">
                                <input type="checkbox" name="isFreeShipping" id="isFreeShipping" ${product != null && product.isFreeShipping ? 'checked' : ''}
                                       class="w-5 h-5 text-primary border-outline-variant rounded focus:ring-primary">
                                <label for="isFreeShipping" class="font-label-bold text-sm cursor-pointer select-none text-on-surface">
                                    ⚡ Hỗ trợ Freeship riêng cho sản phẩm này
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Card 6: Hình ảnh -->
                    <div class="bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant p-6">
                        <h2 class="text-lg font-label-bold mb-4 border-b border-surface-variant pb-2 text-primary">Hình ảnh</h2>
                        <div>
                            <input type="file" name="imageFile" accept="image/*" ${product == null ? 'required' : ''}
                                   class="w-full border border-outline-variant px-3 py-2 rounded-lg file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-label-bold file:bg-primary-container file:text-on-primary-container hover:file:bg-primary hover:file:text-white transition-colors cursor-pointer text-sm">

                            <c:if test="${product != null && product.imageUrl != null}">
                                <div class="mt-4 rounded-lg border border-outline-variant p-2 bg-surface">
                                    <p class="text-xs text-on-surface-variant mb-2 font-label-bold text-center">Ảnh hiện tại</p>
                                    <img src="${product.imageUrl}" class="w-full h-40 object-cover rounded-md shadow-sm">
                                </div>
                            </c:if>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Footer Buttons -->
            <div class="flex justify-end gap-4 pt-4 border-t border-outline-variant mt-8">
                <a href="${pageContext.request.contextPath}/admin/products" class="px-6 py-2.5 border border-outline-variant text-on-surface font-label-bold rounded-lg hover:bg-surface-container transition-colors shadow-sm">
                    Hủy bỏ
                </a>
                <button type="submit" class="px-8 py-2.5 bg-primary text-white font-label-bold rounded-lg hover:bg-[#6ba306] transition-colors shadow-md flex items-center gap-2">
                    <span class="material-symbols-outlined text-[20px]">save</span>
                    ${product != null ? 'Lưu thay đổi' : 'Tạo sản phẩm'}
                </button>
            </div>
        </form>
    </main>
</div>

<!-- Script: CKEditor -->
<script>
    ClassicEditor
        .create(document.querySelector('#detailedDescription'), {
            toolbar: [ 'heading', '|', 'bold', 'italic', 'bulletedList', 'numberedList', 'blockQuote', 'undo', 'redo' ]
        })
        .catch(error => {
            console.error('Lỗi tải CKEditor:', error);
        });
</script>

<!-- Script: Toast Notification (Bắt tham số URL) -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const message = urlParams.get('message');

        if (message) {
            let toastText = '';
            let toastType = 'success'; // 'success' hoặc 'error'

            // Map các mã message trả về từ Backend
            if (message === 'Success') toastText = 'Thêm sản phẩm thành công!';
            else if (message === 'UpdateSuccess') toastText = 'Cập nhật sản phẩm thành công!';
            else if (message === 'DeleteSuccess') toastText = 'Đã xóa sản phẩm!';
            else if (message === 'Error') {
                toastText = 'Có lỗi xảy ra trong quá trình xử lý!';
                toastType = 'error';
            }

            if (toastText !== '') {
                showToast(toastText, toastType);
                // Xóa tham số trên URL để F5 không bị hiện lại
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        }

        function showToast(text, type) {
            const container = document.getElementById('toast-container');
            const toast = document.createElement('div');

            const bgColor = type === 'success' ? 'bg-primary' : 'bg-error';
            const icon = type === 'success' ? 'check_circle' : 'error';

            toast.className = `px-6 py-4 rounded-lg shadow-xl text-white font-label-bold transition-all duration-300 transform translate-y-[-100%] opacity-0 flex items-center gap-3 ` + bgColor;
            toast.innerHTML = `<span class="material-symbols-outlined text-[24px]">` + icon + `</span> ` + text;

            container.appendChild(toast);

            // Kích hoạt Animation
            requestAnimationFrame(() => {
                toast.classList.remove('translate-y-[-100%]', 'opacity-0');
                toast.classList.add('translate-y-0', 'opacity-100');
            });

            // Tự động tắt sau 3 giây
            setTimeout(() => {
                toast.classList.remove('translate-y-0', 'opacity-100');
                toast.classList.add('translate-y-[-100%]', 'opacity-0');
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }
    });
</script>
</body>
</html>