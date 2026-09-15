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
                                <input type="text" name="name" id="productNameInput" value="${product != null ? product.name : ''}" required placeholder="VD: Táo Envy Mỹ size lớn"
                                       class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-colors bg-surface">
                            </div>
                            <div>
                                <div class="flex items-center justify-between mb-1.5">
                                    <label class="block font-label-bold text-sm">Mô tả ngắn</label>
                                    <button type="button" id="btnAIGenerateShortDesc" class="inline-flex items-center gap-1.5 px-3 py-1 rounded-md bg-primary/10 hover:bg-primary/20 text-primary font-label-bold text-xs transition-colors border border-primary/20 cursor-pointer" title="Trợ Lý AI phân tích tên sản phẩm để sinh mô tả ngắn">
                                        <span id="iconShortDesc" class="flex items-center">
                                            <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M12 2l2.4 7.2L22 12l-7.6 2.8L12 22l-2.4-7.2L2 12l7.6-2.8z"/>
                                            </svg>
                                        </span>
                                        <span id="textShortDesc">Tạo bằng Trợ Lý AI</span>
                                    </button>
                                </div>
                                <textarea name="description" id="shortDescription" rows="2" placeholder="Hiển thị ở trang danh sách sản phẩm..."
                                          class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-colors bg-surface">${product != null ? product.description : ''}</textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Card 2: Nội dung chi tiết (CKEditor) -->
                    <div class="bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant p-6">
                        <div class="flex items-center justify-between mb-3 border-b border-surface-variant pb-2">
                            <h2 class="text-lg font-label-bold text-primary">Bài viết giới thiệu</h2>
                            <span class="text-xs px-2.5 py-1 rounded-full bg-primary/10 text-primary font-medium flex items-center gap-1">
                                <svg class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 2l2.4 7.2L22 12l-7.6 2.8L12 22l-2.4-7.2L2 12l7.6-2.8z"/>
                                </svg>
                                Trợ Lý AI hỗ trợ soạn thảo
                            </span>
                        </div>

                        <!-- Bảng điều khiển Trợ Lý AI -->
                        <div class="mb-4 p-3.5 rounded-xl bg-surface border border-outline-variant/70 shadow-xs space-y-3">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-2">
                                    <svg class="w-4 h-4 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="4" y="4" width="16" height="16" rx="2" ry="2"/>
                                        <rect x="9" y="9" width="6" height="6"/>
                                        <line x1="9" y1="1" x2="9" y2="4"/>
                                        <line x1="15" y1="1" x2="15" y2="4"/>
                                        <line x1="9" y1="20" x2="9" y2="23"/>
                                        <line x1="15" y1="20" x2="15" y2="23"/>
                                        <line x1="20" y1="9" x2="23" y2="9"/>
                                        <line x1="20" y1="14" x2="23" y2="14"/>
                                        <line x1="1" y1="9" x2="4" y2="9"/>
                                        <line x1="1" y1="14" x2="4" y2="14"/>
                                    </svg>
                                    <span class="text-xs font-bold uppercase tracking-wider text-primary">Trợ Lý AI Soạn Thảo</span>
                                </div>
                                <span class="text-[11px] text-on-surface-variant">Tự động cấu trúc bài viết chuyên nghiệp chuẩn SEO</span>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <div>
                                    <label class="block text-xs font-medium text-on-surface-variant mb-1">Mẫu bài viết</label>
                                    <select id="aiTemplateType" class="w-full text-xs border border-outline-variant rounded-lg px-3 py-2 bg-surface-container-lowest focus:outline-none focus:border-primary">
                                        <option value="RETAIL">Chuẩn bán lẻ cao cấp (Xuất xứ, Hương vị, Dinh dưỡng, Bảo quản)</option>
                                        <option value="HEALTHY">Dinh dưỡng & Sức khỏe (Hàm lượng Vitamin, Detox, Giữ dáng)</option>
                                        <option value="GIFT">Giỏ quà biếu sang trọng (Chọn lọc loại 1, Ý nghĩa may mắn)</option>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-on-surface-variant mb-1">Văn phong / Giọng điệu</label>
                                    <select id="aiToneStyle" class="w-full text-xs border border-outline-variant rounded-lg px-3 py-2 bg-surface-container-lowest focus:outline-none focus:border-primary">
                                        <option value="Kích thích vị giác, tươi mát và hấp dẫn">Kích thích vị giác & Tươi mát</option>
                                        <option value="Chuyên gia dinh dưỡng, khoa học và an toàn">Chuyên gia dinh dưỡng & Khoa học</option>
                                        <option value="Sang trọng, đẳng cấp và cam kết chất lượng">Sang trọng & Uy tín cao cấp</option>
                                    </select>
                                </div>
                            </div>

                            <div class="flex flex-wrap items-center gap-2 pt-2 border-t border-outline-variant/40">
                                <button type="button" id="btnAIGenerateArticle" class="px-4 py-2 bg-primary text-white text-xs font-semibold rounded-lg hover:bg-primary/90 transition-all shadow-sm flex items-center gap-1.5 cursor-pointer">
                                    <span id="iconArticle" class="flex items-center">
                                        <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                        </svg>
                                    </span>
                                    <span id="textArticle">Viết bài tự động</span>
                                </button>

                                <button type="button" id="btnAIAppendFaq" class="px-3 py-2 border border-outline-variant text-on-surface text-xs font-medium rounded-lg hover:bg-surface-container-highest transition-colors flex items-center gap-1.5 cursor-pointer">
                                    <span id="iconFaq" class="flex items-center">
                                        <svg class="w-3.5 h-3.5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <circle cx="12" cy="12" r="10"/>
                                            <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/>
                                            <line x1="12" y1="17" x2="12.01" y2="17"/>
                                        </svg>
                                    </span>
                                    <span id="textFaq">Thêm câu hỏi thường gặp (FAQ)</span>
                                </button>
                            </div>
                        </div>

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
                        <div class="flex items-center justify-between mb-4 border-b border-surface-variant pb-2">
                            <h2 class="text-lg font-label-bold text-primary flex items-center gap-2">
                                <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="1" y="3" width="15" height="13"/>
                                    <polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/>
                                    <circle cx="5.5" cy="18.5" r="2.5"/>
                                    <circle cx="18.5" cy="18.5" r="2.5"/>
                                </svg>
                                Vận chuyển & Bảo quản
                            </h2>
                            <button type="button" id="btnAISuggestSpecs" class="text-xs px-2.5 py-1 rounded-md border border-primary/30 text-primary hover:bg-primary/10 transition-colors flex items-center gap-1 font-medium cursor-pointer" title="Phân tích tên sản phẩm để tự động gợi ý thông số">
                                <span id="iconSpecs" class="flex items-center">
                                    <svg class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M12 2l2.4 7.2L22 12l-7.6 2.8L12 22l-2.4-7.2L2 12l7.6-2.8z"/>
                                    </svg>
                                </span>
                                <span id="textSpecs">Trợ Lý AI gợi ý</span>
                            </button>
                        </div>
                        <div class="space-y-4">
                            <div>
                                <label class="block font-label-bold text-sm mb-1">Trọng lượng (Gram) <span class="text-error">*</span></label>
                                <input type="number" name="weightGram" id="weightGramInput" value="${product != null && product.weightGram != null ? product.weightGram : '500'}" required min="1" step="1" placeholder="VD: 500 hoặc 1000"
                                       class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary bg-surface text-sm">
                                <p class="text-[11px] text-on-surface-variant mt-1">Dùng để cộng dồn tính phụ phí hàng nặng (> 5kg: +5.000 đ/kg).</p>
                            </div>

                            <div>
                                <label class="block font-label-bold text-sm mb-1">Quy cách bảo quản</label>
                                <select name="storageType" id="storageTypeSelect" class="w-full border border-outline-variant px-4 py-2.5 rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary bg-surface text-sm">
                                    <option value="NORMAL" ${product == null || product.storageType == 'NORMAL' ? 'selected' : ''}>Tiêu chuẩn (Nhiệt độ phòng thường)</option>
                                    <option value="COLD_CHAIN" ${product != null && product.storageType == 'COLD_CHAIN' ? 'selected' : ''}>Chuỗi lạnh / Ướp mát (+10.000 đ ship)</option>
                                    <option value="FRAGILE_GIFT" ${product != null && product.storageType == 'FRAGILE_GIFT' ? 'selected' : ''}>Dễ dập nát / Hộp quà biếu (+20.000 đ ship)</option>
                                </select>
                            </div>

                            <div class="flex items-center gap-3 pt-2">
                                <input type="checkbox" name="isFreeShipping" id="isFreeShipping" ${product != null && product.isFreeShipping ? 'checked' : ''}
                                       class="w-5 h-5 text-primary border-outline-variant rounded focus:ring-primary">
                                <label for="isFreeShipping" class="font-label-bold text-sm cursor-pointer select-none text-on-surface">
                                    Hỗ trợ Freeship riêng cho sản phẩm này
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

<!-- Script: CKEditor & Trợ Lý AI -->
<script>
    let detailedEditorInstance = null;

    // Khởi tạo CKEditor 5
    ClassicEditor
        .create(document.querySelector('#detailedDescription'), {
            toolbar: [ 'heading', '|', 'bold', 'italic', 'bulletedList', 'numberedList', 'blockQuote', 'undo', 'redo' ]
        })
        .then(editor => {
            detailedEditorInstance = editor;
        })
        .catch(error => {
            console.error('Lỗi tải CKEditor:', error);
        });

    // Các mẫu icon vẽ bằng mã SVG thuần túy (Không dùng emoji, không dùng ký tự icon)
    const SVG_SPINNER = '<svg class="w-3.5 h-3.5 animate-spin" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10" stroke="currentColor" stroke-opacity="0.25"></circle><path d="M12 2a10 10 0 0 1 10 10" stroke="currentColor" stroke-linecap="round"></path></svg>';
    const SVG_SPARKLE = '<svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2l2.4 7.2L22 12l-7.6 2.8L12 22l-2.4-7.2L2 12l7.6-2.8z"/></svg>';
    const SVG_PEN = '<svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>';
    const SVG_FAQ = '<svg class="w-3.5 h-3.5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>';
    const SVG_SPECS = '<svg class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2l2.4 7.2L22 12l-7.6 2.8L12 22l-2.4-7.2L2 12l7.6-2.8z"/></svg>';

    // Hàm hiển thị Toast Notification vẽ icon hoàn toàn bằng code SVG
    function showToast(text, type = 'success') {
        const container = document.getElementById('toast-container');
        if (!container) return;

        const toast = document.createElement('div');
        const bgColor = type === 'success' ? 'bg-primary' : 'bg-error';
        const iconSvg = type === 'success'
            ? '<svg class="w-5 h-5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>'
            : '<svg class="w-5 h-5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>';

        toast.className = 'px-5 py-3.5 rounded-xl shadow-xl text-white font-label-bold transition-all duration-300 transform translate-y-[-100%] opacity-0 flex items-center gap-3 ' + bgColor;
        toast.innerHTML = iconSvg + '<span class="text-sm">' + text + '</span>';

        container.appendChild(toast);

        requestAnimationFrame(() => {
            toast.classList.remove('translate-y-[-100%]', 'opacity-0');
            toast.classList.add('translate-y-0', 'opacity-100');
        });

        setTimeout(() => {
            toast.classList.remove('translate-y-0', 'opacity-100');
            toast.classList.add('translate-y-[-100%]', 'opacity-0');
            setTimeout(() => toast.remove(), 300);
        }, 3500);
    }

    // Tiện ích lấy tên sản phẩm và danh mục
    function getProductContext() {
        const nameInput = document.getElementById('productNameInput');
        const nameVal = nameInput ? nameInput.value.trim() : '';

        if (!nameVal) {
            showToast('Vui lòng nhập Tên sản phẩm trước khi dùng Trợ Lý AI.', 'error');
            if (nameInput) nameInput.focus();
            return null;
        }

        const catSelect = document.querySelector('select[name="categoryId"]');
        const catName = catSelect && catSelect.selectedIndex >= 0 ? catSelect.options[catSelect.selectedIndex].text : 'Trái cây tươi';

        return { productName: nameVal, categoryName: catName };
    }

    document.addEventListener('DOMContentLoaded', function() {
        // 1. Kiểm tra message từ URL sau khi chuyển trang
        const urlParams = new URLSearchParams(window.location.search);
        const message = urlParams.get('message');
        if (message) {
            let toastText = '';
            let toastType = 'success';
            if (message === 'Success') toastText = 'Thêm sản phẩm thành công!';
            else if (message === 'UpdateSuccess') toastText = 'Cập nhật sản phẩm thành công!';
            else if (message === 'DeleteSuccess') toastText = 'Đã xóa sản phẩm!';
            else if (message === 'Error') {
                toastText = 'Có lỗi xảy ra trong quá trình xử lý!';
                toastType = 'error';
            }
            if (toastText !== '') {
                showToast(toastText, toastType);
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        }

        const apiBaseUrl = '${pageContext.request.contextPath}/api/admin/product-ai';

        // Hàm gọi API Trợ Lý AI tập trung và xử lý mã lỗi HTTP chuẩn xác
        function callProductAIApi(params) {
            return fetch(apiBaseUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: params.toString()
            })
            .then(async (res) => {
                const text = await res.text();
                let data = null;
                try {
                    data = JSON.parse(text);
                } catch (e) {
                    if (res.status === 404) throw new Error('Chưa tìm thấy endpoint Trợ Lý AI (HTTP 404).');
                    if (res.status === 403) throw new Error('Hết phiên đăng nhập Quản trị viên (HTTP 403).');
                    throw new Error('Máy chủ phản hồi không đúng định dạng (HTTP ' + res.status + ').');
                }
                if (!res.ok || (data && data.success === false)) {
                    throw new Error(data && data.message ? data.message : ('Lỗi phản hồi (HTTP ' + res.status + ')'));
                }
                return data;
            });
        }

        // 2. Trợ Lý AI: Sinh mô tả ngắn
        const btnShortDesc = document.getElementById('btnAIGenerateShortDesc');
        if (btnShortDesc) {
            btnShortDesc.addEventListener('click', function() {
                const ctx = getProductContext();
                if (!ctx) return;

                const iconEl = document.getElementById('iconShortDesc');
                const textEl = document.getElementById('textShortDesc');

                btnShortDesc.disabled = true;
                iconEl.innerHTML = SVG_SPINNER;
                textEl.textContent = 'Đang tạo...';

                const params = new URLSearchParams({
                    action: 'short_desc',
                    productName: ctx.productName,
                    categoryName: ctx.categoryName
                });

                callProductAIApi(params)
                .then(data => {
                    if (data.content) {
                        document.getElementById('shortDescription').value = data.content;
                        showToast('Trợ Lý AI đã tạo mô tả ngắn thành công!', 'success');
                    } else {
                        showToast('Không nhận được nội dung từ Trợ Lý AI.', 'error');
                    }
                })
                .catch(err => {
                    console.error('Lỗi gọi Trợ Lý AI:', err);
                    showToast(err.message || 'Lỗi kết nối tới Trợ Lý AI. Vui lòng thử lại.', 'error');
                })
                .finally(() => {
                    btnShortDesc.disabled = false;
                    iconEl.innerHTML = SVG_SPARKLE;
                    textEl.textContent = 'Tạo bằng Trợ Lý AI';
                });
            });
        }

        // 3. Trợ Lý AI: Viết bài giới thiệu tự động cho CKEditor
        const btnArticle = document.getElementById('btnAIGenerateArticle');
        if (btnArticle) {
            btnArticle.addEventListener('click', function() {
                const ctx = getProductContext();
                if (!ctx) return;

                if (!detailedEditorInstance) {
                    showToast('Trình soạn thảo đang tải, vui lòng đợi trong giây lát.', 'error');
                    return;
                }

                const currentContent = detailedEditorInstance.getData().trim();
                if (currentContent.length > 20) {
                    const ok = confirm('Bài viết giới thiệu đang có nội dung. Bạn có chắc muốn Trợ Lý AI thay thế toàn bộ bằng bài viết mới không?');
                    if (!ok) return;
                }

                const templateType = document.getElementById('aiTemplateType').value;
                const toneStyle = document.getElementById('aiToneStyle').value;

                const iconEl = document.getElementById('iconArticle');
                const textEl = document.getElementById('textArticle');

                btnArticle.disabled = true;
                iconEl.innerHTML = SVG_SPINNER;
                textEl.textContent = 'Đang soạn bài...';

                const params = new URLSearchParams({
                    action: 'article',
                    productName: ctx.productName,
                    categoryName: ctx.categoryName,
                    templateType: templateType,
                    toneStyle: toneStyle
                });

                callProductAIApi(params)
                .then(data => {
                    if (data.content) {
                        detailedEditorInstance.setData(data.content);
                        showToast('Trợ Lý AI đã hoàn thành bài viết giới thiệu!', 'success');
                    } else {
                        showToast('Không nhận được nội dung từ Trợ Lý AI.', 'error');
                    }
                })
                .catch(err => {
                    console.error('Lỗi gọi Trợ Lý AI:', err);
                    showToast(err.message || 'Lỗi kết nối tới Trợ Lý AI. Vui lòng thử lại.', 'error');
                })
                .finally(() => {
                    btnArticle.disabled = false;
                    iconEl.innerHTML = SVG_PEN;
                    textEl.textContent = 'Viết bài tự động';
                });
            });
        }

        // 4. Trợ Lý AI: Thêm câu hỏi thường gặp (FAQ)
        const btnFaq = document.getElementById('btnAIAppendFaq');
        if (btnFaq) {
            btnFaq.addEventListener('click', function() {
                const ctx = getProductContext();
                if (!ctx) return;

                if (!detailedEditorInstance) {
                    showToast('Trình soạn thảo đang tải, vui lòng đợi.', 'error');
                    return;
                }

                const iconEl = document.getElementById('iconFaq');
                const textEl = document.getElementById('textFaq');

                btnFaq.disabled = true;
                iconEl.innerHTML = SVG_SPINNER;
                textEl.textContent = 'Đang tạo FAQ...';

                const params = new URLSearchParams({
                    action: 'faq',
                    productName: ctx.productName,
                    categoryName: ctx.categoryName
                });

                callProductAIApi(params)
                .then(data => {
                    if (data.content) {
                        const existing = detailedEditorInstance.getData().trim();
                        const separator = existing.length > 0 ? '<hr><br>' : '';
                        detailedEditorInstance.setData(existing + separator + data.content);
                        showToast('Trợ Lý AI đã thêm câu hỏi thường gặp vào bài viết!', 'success');
                    } else {
                        showToast('Không nhận được FAQ từ Trợ Lý AI.', 'error');
                    }
                })
                .catch(err => {
                    console.error('Lỗi gọi Trợ Lý AI:', err);
                    showToast(err.message || 'Lỗi kết nối tới Trợ Lý AI. Vui lòng thử lại.', 'error');
                })
                .finally(() => {
                    btnFaq.disabled = false;
                    iconEl.innerHTML = SVG_FAQ;
                    textEl.textContent = 'Thêm câu hỏi thường gặp (FAQ)';
                });
            });
        }

        // 5. Trợ Lý AI: Gợi ý thông số vận chuyển & bảo quản
        const btnSpecs = document.getElementById('btnAISuggestSpecs');
        if (btnSpecs) {
            btnSpecs.addEventListener('click', function() {
                const ctx = getProductContext();
                if (!ctx) return;

                const iconEl = document.getElementById('iconSpecs');
                const textEl = document.getElementById('textSpecs');

                btnSpecs.disabled = true;
                iconEl.innerHTML = SVG_SPINNER;
                textEl.textContent = 'Đang phân tích...';

                const params = new URLSearchParams({
                    action: 'suggest_specs',
                    productName: ctx.productName,
                    categoryName: ctx.categoryName
                });

                callProductAIApi(params)
                .then(data => {
                    if (data.specs) {
                        if (data.specs.weightGram) {
                            const weightInput = document.getElementById('weightGramInput');
                            if (weightInput) weightInput.value = data.specs.weightGram;
                        }
                        if (data.specs.storageType) {
                            const storageSelect = document.getElementById('storageTypeSelect');
                            if (storageSelect) storageSelect.value = data.specs.storageType;
                        }
                        showToast('Trợ Lý AI đã phân tích và gợi ý thông số phù hợp!', 'success');
                    } else {
                        showToast('Không nhận được thông số gợi ý từ Trợ Lý AI.', 'error');
                    }
                })
                .catch(err => {
                    console.error('Lỗi gọi Trợ Lý AI:', err);
                    showToast(err.message || 'Lỗi kết nối tới Trợ Lý AI. Vui lòng thử lại.', 'error');
                })
                .finally(() => {
                    btnSpecs.disabled = false;
                    iconEl.innerHTML = SVG_SPECS;
                    textEl.textContent = 'Trợ Lý AI gợi ý';
                });
            });
        }
    });
</script>
</body>
</html>