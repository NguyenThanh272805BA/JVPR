<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Tạo Phiếu Nhập Kho - Fruitables Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-surface font-body-md flex h-screen overflow-hidden">

<!-- Toast Notification Container -->
<div id="toast-container" class="fixed top-5 right-5 z-50 flex flex-col gap-3 pointer-events-none"></div>

<c:set var="currentURI" value="${requestScope['javax.servlet.forward.request_uri']}" />
<aside class="w-64 bg-surface-container-lowest border-r border-surface-variant flex flex-col h-full flex-shrink-0 z-20 shadow-sm hidden md:flex">
  <div class="h-20 flex items-center px-6 border-b border-surface-variant">
    <a class="group flex items-center gap-2.5" href="${pageContext.request.contextPath}/admin/dashboard">
        <div class="w-8 h-8 rounded-xl bg-gradient-to-br from-[#84cc16] via-[#65a30d] to-[#4d7c0f] flex items-center justify-center text-white shadow-sm flex-shrink-0 group-hover:scale-105 transition-transform">
            <svg class="w-4 h-4 text-white" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2C12 2 12.5 5 10 7C7.5 9 6 12 6 15C6 18.3137 8.68629 21 12 21C15.3137 21 18 18.3137 18 15C18 12 16.5 9 14 7C11.5 5 12 2 12 2Z" fill="currentColor"/>
                <path d="M12 2C12 2 13.2 4.2 15.5 4.2C17.5 4.2 18.5 2.8 18.5 2.8C18.5 2.8 18 5.2 16 5.8C14 6.4 12.5 5.2 12 2Z" fill="#fef08a"/>
            </svg>
        </div>
        <div class="flex flex-col">
            <span class="text-base font-black tracking-tight leading-none text-slate-900">Fruit<span class="text-primary">ables</span></span>
            <span class="text-[8px] font-bold text-primary tracking-wider uppercase mt-0.5">Admin Portal</span>
        </div>
    </a>
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
    <a class="flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${currentURI.contains('/inventory') ? 'bg-primary text-white shadow-md' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" href="${pageContext.request.contextPath}/admin/inventory">
      <span class="material-symbols-outlined">warehouse</span>
      <span class="font-label-bold">Kho nhập hàng</span>
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

<main class="flex-1 flex flex-col h-screen overflow-hidden">
  <header class="h-20 bg-surface flex items-center justify-between px-6 shadow-sm z-10 flex-shrink-0 border-b border-surface-variant">
    <div class="flex items-center gap-3 min-w-0">
      <a href="${pageContext.request.contextPath}/admin/inventory" class="p-2 text-slate-500 hover:bg-slate-100 rounded-lg transition-colors flex-shrink-0">
        <span class="material-symbols-outlined">arrow_back</span>
      </a>
      <span class="font-bold text-lg text-slate-800 truncate">Tạo Phiếu Nhập Kho Mới</span>
    </div>
    <div class="flex items-center gap-3 flex-shrink-0">
      <span class="font-label-bold hidden sm:inline-block max-w-[150px] truncate whitespace-nowrap text-sm" title="${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}">
        ${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Admin'}
      </span>
      <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full transition-colors flex-shrink-0" title="Đăng xuất">
        <span class="material-symbols-outlined">logout</span>
      </a>
    </div>
  </header>

  <div class="flex-1 overflow-y-auto p-4 sm:p-6 bg-[#f8fafc]">
    <form action="${pageContext.request.contextPath}/admin/inventory/create" method="POST" id="receiptForm" class="max-w-5xl mx-auto space-y-6">
      
      <!-- Card Thông tin Nhà Cung Cấp & Ghi Chú -->
      <div class="bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-surface-variant space-y-4">
        <div class="flex items-center justify-between border-b pb-3">
          <h2 class="font-bold text-base text-slate-800 flex items-center gap-2">
            <span class="material-symbols-outlined text-primary">store</span>
            1. Thông tin Đối tác & Đợt nhập
          </h2>
          <button type="button" onclick="document.getElementById('quickSupplierModal').classList.remove('hidden')" class="text-xs font-bold text-primary hover:underline flex items-center gap-1">
            <span class="material-symbols-outlined text-sm">add</span> Thêm nhanh nhà cung cấp
          </button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-bold text-slate-700 mb-1.5">Nhà cung cấp (*):</label>
            <select name="supplierId" required class="w-full border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm bg-white focus:border-primary outline-none shadow-sm">
              <c:choose>
                <c:when test="${not empty suppliers}">
                  <c:forEach var="s" items="${suppliers}">
                    <option value="${s.id}">${s.name} ${not empty s.phone ? '('.concat(s.phone).concat(')') : ''}</option>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <option value="" disabled selected>Chưa có nhà cung cấp nào - Hãy bấm "Thêm nhanh"</option>
                </c:otherwise>
              </c:choose>
            </select>
          </div>

          <div>
            <label class="block text-xs font-bold text-slate-700 mb-1.5">Ghi chú phiếu nhập:</label>
            <input type="text" name="note" placeholder="VD: Nhập lô hoa quả đợt mới tháng 9, bảo quản mát..." class="w-full border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm bg-white focus:border-primary outline-none shadow-sm">
          </div>
        </div>
      </div>

      <!-- Card Danh sách sản phẩm nhập -->
      <div class="bg-surface-container-lowest p-6 rounded-2xl shadow-sm border border-surface-variant space-y-4">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b pb-3">
          <div>
            <h2 class="font-bold text-base text-slate-800 flex items-center gap-2">
              <span class="material-symbols-outlined text-primary">inventory_2</span>
              2. Danh sách Sản phẩm Nhập kho
            </h2>
            <p class="text-xs text-slate-500 mt-0.5">Tồn kho tự động tăng và giá vốn bình quân gia quyền (COGS) tự động cập nhật lại</p>
          </div>
          <div class="flex items-center flex-wrap gap-2">
            <!-- Nút 1: Chọn từ kho có sẵn -->
            <button type="button" onclick="openWarehouseCatalogModal()" class="px-3.5 py-2 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border border-emerald-300 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 shadow-sm">
              <span class="material-symbols-outlined text-base">warehouse</span> Lấy từ kho có sẵn
            </button>
            <!-- Nút 2: Nhập mặt hàng hoàn toàn mới -->
            <button type="button" onclick="openQuickProductModal()" class="px-3.5 py-2 bg-amber-50 hover:bg-amber-100 text-amber-800 border border-amber-300 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 shadow-sm">
              <span class="material-symbols-outlined text-base">add_box</span> + Nhập sản phẩm mới
            </button>
            <!-- Nút 3: Thêm dòng nhanh -->
            <button type="button" onclick="addProductRow()" class="px-3 py-2 bg-primary/10 hover:bg-primary text-primary hover:text-white rounded-xl text-xs font-bold transition-all flex items-center gap-1 shadow-sm">
              <span class="material-symbols-outlined text-base">add</span> Thêm dòng
            </button>
          </div>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full text-left border-collapse text-xs" id="itemsTable">
            <thead>
              <tr class="bg-slate-50 text-slate-600 font-bold border-b border-slate-200">
                <th class="py-3 px-4 w-5/12">Sản phẩm</th>
                <th class="py-3 px-4 w-2/12 text-center">Số lượng nhập</th>
                <th class="py-3 px-4 w-2/12 text-right">Đơn giá nhập (VNĐ)</th>
                <th class="py-3 px-4 w-2/12 text-right">Thành tiền</th>
                <th class="py-3 px-4 w-1/12 text-center">Xóa</th>
              </tr>
            </thead>
            <tbody id="itemsBody" class="divide-y divide-slate-100">
              <!-- Hàng sản phẩm render bằng JS -->
            </tbody>
          </table>
        </div>

        <div class="pt-4 border-t border-slate-100 flex flex-col sm:flex-row items-center justify-between gap-4">
          <div class="text-xs text-slate-500 space-y-1">
            <p class="flex items-center gap-1">
              <span class="material-symbols-outlined text-sm text-emerald-600">verified</span>
              <strong>Công thức giá vốn mới:</strong> (Tồn cũ &times; Giá vốn cũ + SL nhập &times; Giá nhập mới) / Tổng tồn sau nhập
            </p>
          </div>

          <div class="text-right">
            <span class="text-xs text-slate-500">Tổng chi phí vốn đợt này:</span>
            <div id="grandTotalText" class="text-2xl font-black text-amber-700">0 ₫</div>
          </div>
        </div>
      </div>

      <!-- Action Buttons -->
      <div class="flex items-center justify-end gap-3 pt-2">
        <a href="${pageContext.request.contextPath}/admin/inventory" class="px-6 py-2.5 bg-slate-200 hover:bg-slate-300 text-slate-700 font-bold text-sm rounded-xl transition-colors">
          Hủy bỏ
        </a>
        <button type="submit" class="px-8 py-2.5 bg-primary hover:bg-primary-container text-white font-bold text-sm rounded-xl shadow-lg hover:shadow-xl transition-all flex items-center gap-2">
          <span class="material-symbols-outlined text-base">check_circle</span>
          Hoàn tất & Cập nhật kho
        </button>
      </div>

    </form>
  </div>
</main>

<!-- MODAL 1: LẤY SẢN PHẨM TỪ KHO HÀNG CÓ SẴN (CATALOG PICKER) -->
<div id="warehouseCatalogModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4">
  <div class="bg-white rounded-2xl shadow-2xl w-full max-w-3xl max-h-[90vh] flex flex-col overflow-hidden border border-slate-200">
    <div class="p-5 border-b border-slate-200 flex items-center justify-between bg-slate-50">
      <div>
        <h3 class="font-bold text-base text-slate-800 flex items-center gap-2">
          <span class="material-symbols-outlined text-emerald-600">warehouse</span>
          Kho Hàng Sẵn Có - Chọn Sản Phẩm Nhập Thêm
        </h3>
        <p class="text-xs text-slate-500 mt-0.5">Dễ dàng tìm kiếm và chọn các mặt hàng đã có trong kho để tiếp tục nhập thêm số lượng</p>
      </div>
      <button type="button" onclick="closeWarehouseCatalogModal()" class="text-slate-400 hover:text-slate-600 p-1.5 rounded-lg hover:bg-slate-200">
        <span class="material-symbols-outlined text-lg">close</span>
      </button>
    </div>

    <!-- Thanh tìm kiếm & lọc danh mục -->
    <div class="p-4 border-b border-slate-100 flex flex-col sm:flex-row gap-3 bg-white">
      <div class="relative flex-1">
        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-base">search</span>
        <input type="text" id="catalogSearchInput" oninput="filterCatalog()" placeholder="Tìm tên sản phẩm trong kho..."
               class="w-full pl-9 pr-3 py-2 border border-slate-300 rounded-xl text-xs outline-none focus:border-primary">
      </div>
      <select id="catalogCategoryFilter" onchange="filterCatalog()" class="border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary bg-white">
        <option value="">Tất cả danh mục</option>
        <c:forEach var="cat" items="${categories}">
          <option value="${cat.name}">${cat.name}</option>
        </c:forEach>
      </select>
    </div>

    <!-- Danh sách sản phẩm dạng thẻ -->
    <div class="p-4 overflow-y-auto flex-1 space-y-3" id="catalogProductContainer">
      <!-- Render bằng JavaScript -->
    </div>

    <div class="p-4 border-t border-slate-200 bg-slate-50 flex items-center justify-between text-xs text-slate-500">
      <span>Gợi ý: Chọn sản phẩm xong, bạn có thể chỉnh lại số lượng và đơn giá nhập thực tế trên bảng.</span>
      <button type="button" onclick="closeWarehouseCatalogModal()" class="px-4 py-2 bg-slate-200 hover:bg-slate-300 text-slate-700 font-bold rounded-xl">
        Đóng
      </button>
    </div>
  </div>
</div>

<!-- MODAL 2: NHẬP SẢN PHẨM HOÀN TOÀN MỚI VÀO KHO -->
<div id="quickProductModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4">
  <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg overflow-hidden border border-slate-200">
    <form id="quickProductForm" onsubmit="submitQuickProduct(event)" class="p-6 space-y-4">
      <div class="flex items-center justify-between border-b pb-3">
        <div>
          <h3 class="font-bold text-base text-slate-800 flex items-center gap-2">
            <span class="material-symbols-outlined text-amber-600">add_box</span>
            Nhập Sản Phẩm Hoàn Toàn Mới
          </h3>
          <p class="text-xs text-slate-500 mt-0.5">Tạo thông tin mặt hàng mới và tự động đưa vào phiếu nhập này</p>
        </div>
        <button type="button" onclick="closeQuickProductModal()" class="text-slate-400 hover:text-slate-600">
          <span class="material-symbols-outlined text-sm">close</span>
        </button>
      </div>

      <div>
        <label class="block text-xs font-bold text-slate-700 mb-1">Tên sản phẩm (*):</label>
        <input type="text" name="name" required placeholder="VD: Dâu Tây Giống Nhật Mộc Châu..." class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
      </div>

      <div class="grid grid-cols-2 gap-3">
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Danh mục (*):</label>
          <select name="categoryId" required class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary bg-white">
            <c:forEach var="cat" items="${categories}">
              <option value="${cat.id}">${cat.name}</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Giá bán niêm yết (*):</label>
          <input type="number" name="price" required min="0" step="1000" placeholder="VD: 150000" class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
        </div>
      </div>

      <div class="grid grid-cols-2 gap-3">
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Định lượng (gram):</label>
          <input type="number" name="weightGram" value="500" min="10" step="50" class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
        </div>
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Cách bảo quản:</label>
          <select name="storageType" class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary bg-white">
            <option value="COLD_CHAIN">❄️ Chuỗi lạnh 0 - 4°C</option>
            <option value="NORMAL" selected>🌡️ Nhiệt độ phòng</option>
            <option value="FRAGILE_GIFT">🎁 Hộp quà chống sốc</option>
          </select>
        </div>
      </div>

      <div class="grid grid-cols-2 gap-3 bg-amber-50/70 p-3 rounded-xl border border-amber-200">
        <div>
          <label class="block text-xs font-bold text-amber-900 mb-1">Số lượng nhập lần này (*):</label>
          <input type="number" id="quickInitialQty" required min="1" value="50" class="w-full border border-amber-300 rounded-xl px-3 py-2 text-xs font-bold text-center outline-none focus:border-primary bg-white">
        </div>
        <div>
          <label class="block text-xs font-bold text-amber-900 mb-1">Đơn giá nhập đợt này (*):</label>
          <input type="number" id="quickInitialCost" required min="0" step="500" placeholder="VD: 90000" class="w-full border border-amber-300 rounded-xl px-3 py-2 text-xs font-bold text-right outline-none focus:border-primary bg-white">
        </div>
      </div>

      <!-- UPLOAD HÌNH ẢNH SẢN PHẨM TRỰC TIẾP -->
      <div>
        <label class="block text-xs font-bold text-slate-700 mb-1.5">Hình ảnh sản phẩm:</label>
        
        <!-- Khung Upload file / Dropzone -->
        <div id="quickImageUploadZone" onclick="document.getElementById('quickImageFile').click()"
             class="border-2 border-dashed border-slate-300 hover:border-amber-500 bg-slate-50/70 hover:bg-amber-50/30 rounded-xl p-3 text-center cursor-pointer transition-all group relative">
          
          <input type="file" id="quickImageFile" name="imageFile" accept="image/*" class="hidden" onchange="previewQuickProductImage(event)">
          
          <!-- Trạng thái 1: Chưa chọn file -->
          <div id="quickImagePlaceholder" class="flex flex-col items-center justify-center py-2">
            <div class="w-10 h-10 rounded-full bg-white shadow-xs border border-slate-200 group-hover:border-amber-400 group-hover:scale-110 text-slate-400 group-hover:text-amber-600 flex items-center justify-center transition-all">
              <span class="material-symbols-outlined text-xl">add_photo_alternate</span>
            </div>
            <p class="text-xs font-bold text-slate-700 mt-2">Bấm để chọn ảnh từ máy tính</p>
            <p class="text-[11px] text-slate-400 mt-0.5">Hỗ trợ JPG, PNG, WEBP (Tối đa 10MB)</p>
          </div>

          <!-- Trạng thái 2: Xem trước ảnh đã chọn -->
          <div id="quickImagePreviewBox" class="hidden items-center gap-3 p-1">
            <img id="quickImagePreviewImg" src="#" alt="Preview" class="w-16 h-16 object-cover rounded-lg border border-slate-200 shadow-xs flex-shrink-0">
            <div class="flex-1 text-left min-w-0">
              <div id="quickImageFileName" class="text-xs font-bold text-slate-800 truncate">hinh-anh.png</div>
              <div id="quickImageFileSize" class="text-[10px] text-slate-400 mt-0.5">1.2 MB</div>
              <div class="mt-1 flex items-center gap-2">
                <span class="text-[10px] text-emerald-600 font-bold flex items-center gap-0.5">
                  <span class="material-symbols-outlined text-xs">check_circle</span> Sẵn sàng tải lên
                </span>
                <button type="button" onclick="clearQuickProductImage(event)" class="text-[10px] text-red-500 hover:text-red-700 underline font-semibold ml-2">
                  Đổi ảnh khác
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Tùy chọn mở rộng: dán URL dự phòng -->
        <div class="mt-1.5 flex justify-end">
          <button type="button" onclick="toggleQuickImageUrl()" class="text-[11px] text-slate-500 hover:text-amber-700 underline inline-flex items-center gap-1">
            <span class="material-symbols-outlined text-xs">link</span> Hoặc dùng đường link URL
          </button>
        </div>
        <div id="quickImageUrlContainer" class="hidden mt-1.5">
          <input type="url" id="quickImageUrlInput" name="imageUrl" placeholder="https://... (nếu không tải file từ máy tính)" class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
        </div>
      </div>

      <div>
        <label class="block text-xs font-bold text-slate-700 mb-1">Mô tả ngắn:</label>
        <textarea name="description" rows="2" placeholder="Ghi chú về xuất xứ, hương vị..." class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary"></textarea>
      </div>

      <div class="flex items-center justify-end gap-2 pt-2 border-t">
        <button type="button" onclick="closeQuickProductModal()" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-xl text-xs font-bold">
          Hủy
        </button>
        <button type="submit" id="btnSubmitQuickProduct" class="px-5 py-2 bg-amber-600 hover:bg-amber-700 text-white rounded-xl text-xs font-bold shadow flex items-center gap-1.5">
          <span class="material-symbols-outlined text-sm">check</span>
          Tạo & Đưa vào phiếu nhập
        </button>
      </div>
    </form>
  </div>
</div>

<!-- MODAL 3: THÊM NHANH NHÀ CUNG CẤP -->
<div id="quickSupplierModal" class="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm hidden flex items-center justify-center p-4">
  <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden border border-slate-200">
    <form action="${pageContext.request.contextPath}/admin/suppliers" method="POST" class="p-6 space-y-4">
      <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/admin/inventory/create">
      <div class="flex items-center justify-between border-b pb-3">
        <h3 class="font-bold text-base text-slate-800">Thêm Nhà Cung Cấp Mới</h3>
        <button type="button" onclick="document.getElementById('quickSupplierModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600">
          <span class="material-symbols-outlined text-sm">close</span>
        </button>
      </div>

      <div>
        <label class="block text-xs font-bold text-slate-700 mb-1">Tên nhà cung cấp / Nông trại (*):</label>
        <input type="text" name="name" required placeholder="VD: Nông trại Hữu cơ Mộc Châu..." class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
      </div>
      <div>
        <label class="block text-xs font-bold text-slate-700 mb-1">Người liên hệ:</label>
        <input type="text" name="contactName" placeholder="VD: Nguyễn Văn A (Quản lý vườn)" class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
      </div>
      <div class="grid grid-cols-2 gap-2">
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Số điện thoại:</label>
          <input type="text" name="phone" placeholder="0987..." class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
        </div>
        <div>
          <label class="block text-xs font-bold text-slate-700 mb-1">Email:</label>
          <input type="email" name="email" placeholder="contact@..." class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
        </div>
      </div>
      <div>
        <label class="block text-xs font-bold text-slate-700 mb-1">Địa chỉ:</label>
        <input type="text" name="address" placeholder="Xã Chiềng Mung, Huyện Mai Sơn, Sơn La" class="w-full border border-slate-300 rounded-xl px-3 py-2 text-xs outline-none focus:border-primary">
      </div>

      <div class="flex items-center justify-end gap-2 pt-2 border-t">
        <button type="button" onclick="document.getElementById('quickSupplierModal').classList.add('hidden')" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-xl text-xs font-bold">
          Hủy
        </button>
        <button type="submit" class="px-4 py-2 bg-primary hover:bg-primary-container text-white rounded-xl text-xs font-bold shadow">
          Lưu nhà cung cấp
        </button>
      </div>
    </form>
  </div>
</div>

<!-- JavaScript Logic -->
<script>
  let availableProducts = [
    <c:forEach var="p" items="${products}" varStatus="st">
      {
        id: ${p.id},
        name: "${p.name.replace('"', '\\"')}",
        category: "${p.categoryName != null ? p.categoryName : ''}",
        stock: ${p.stock != null ? p.stock : 0},
        costPrice: ${p.costPrice != null ? p.costPrice : 0.0},
        price: ${p.price != null ? p.price : 0.0},
        imageUrl: "${p.imageUrl != null ? p.imageUrl : 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=600&auto=format&fit=crop'}"
      }${!st.last ? ',' : ''}
    </c:forEach>
  ];

  function showToast(message, type = 'success') {
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = `px-4 py-3 rounded-xl shadow-lg text-xs font-bold flex items-center gap-2 pointer-events-auto transition-all transform duration-300 \${
      type === 'success' ? 'bg-emerald-600 text-white' : 'bg-red-600 text-white'
    }`;
    toast.innerHTML = `<span class="material-symbols-outlined text-sm">\${type === 'success' ? 'check_circle' : 'error'}</span> <span>\${message}</span>`;
    container.appendChild(toast);
    setTimeout(() => {
      toast.classList.add('opacity-0', 'translate-y-2');
      setTimeout(() => toast.remove(), 300);
    }, 3500);
  }

  // --- QUẢN LÝ DÒNG SẢN PHẨM TRONG BẢNG ---
  function addProductRow(selectedId = null, defaultQty = 10, defaultCost = null) {
    const tbody = document.getElementById('itemsBody');
    if (availableProducts.length === 0) {
      alert('Hiện chưa có sản phẩm nào trong kho. Hãy bấm "+ Nhập sản phẩm mới" để tạo mặt hàng đầu tiên!');
      return;
    }

    const tr = document.createElement('tr');
    tr.className = 'hover:bg-slate-50 transition-colors';

    let selectOptions = '';
    availableProducts.forEach(p => {
      const isSel = (selectedId && selectedId === p.id) ? 'selected' : '';
      selectOptions += `<option value="\${p.id}" \${isSel}>\${p.name} (Tồn: \${p.stock} | Vốn cũ: \${p.costPrice.toLocaleString('vi-VN')} ₫)</option>`;
    });

    const currentProd = selectedId ? availableProducts.find(x => x.id === selectedId) : availableProducts[0];
    const initialPrice = defaultCost !== null ? defaultCost : (currentProd ? (currentProd.costPrice > 0 ? currentProd.costPrice : Math.round(currentProd.price * 0.6)) : 0);

    tr.innerHTML = `
      <td class="py-3 px-4">
        <select name="productId[]" onchange="onProductChange(this)" class="w-full border border-slate-300 rounded-lg px-2.5 py-1.5 text-xs bg-white focus:border-primary outline-none shadow-xs">
          \${selectOptions}
        </select>
      </td>
      <td class="py-3 px-4 text-center">
        <input type="number" name="quantity[]" value="\${defaultQty}" min="1" oninput="calculateRowTotal(this)" class="w-24 text-center border border-slate-300 rounded-lg px-2 py-1.5 text-xs font-bold focus:border-primary outline-none">
      </td>
      <td class="py-3 px-4 text-right">
        <input type="number" name="importPrice[]" value="\${initialPrice}" min="0" step="500" oninput="calculateRowTotal(this)" class="w-32 text-right border border-slate-300 rounded-lg px-2 py-1.5 text-xs font-bold text-amber-700 focus:border-primary outline-none">
      </td>
      <td class="py-3 px-4 text-right font-bold text-slate-900 row-subtotal">
        \${(defaultQty * initialPrice).toLocaleString('vi-VN')} ₫
      </td>
      <td class="py-3 px-4 text-center">
        <button type="button" onclick="removeProductRow(this)" class="p-1 text-slate-400 hover:text-red-600 transition-colors" title="Xóa mặt hàng này">
          <span class="material-symbols-outlined text-base">delete</span>
        </button>
      </td>
    `;
    tbody.appendChild(tr);
    recalcGrandTotal();
  }

  function onProductChange(select) {
    const tr = select.closest('tr');
    const pId = parseInt(select.value);
    const prod = availableProducts.find(x => x.id === pId);
    if (prod) {
      const priceInput = tr.querySelector('input[name="importPrice[]"]');
      const suggestedCost = prod.costPrice > 0 ? prod.costPrice : Math.round(prod.price * 0.6);
      priceInput.value = suggestedCost;
      calculateRowTotal(priceInput);
    }
  }

  function calculateRowTotal(input) {
    const tr = input.closest('tr');
    const qty = parseFloat(tr.querySelector('input[name="quantity[]"]').value) || 0;
    const price = parseFloat(tr.querySelector('input[name="importPrice[]"]').value) || 0;
    const sub = qty * price;
    tr.querySelector('.row-subtotal').innerText = sub.toLocaleString('vi-VN') + ' ₫';
    recalcGrandTotal();
  }

  function removeProductRow(btn) {
    const tbody = document.getElementById('itemsBody');
    if (tbody.children.length <= 1) {
      alert('Phiếu nhập kho phải có ít nhất 1 sản phẩm!');
      return;
    }
    btn.closest('tr').remove();
    recalcGrandTotal();
  }

  function recalcGrandTotal() {
    let total = 0;
    const rows = document.querySelectorAll('#itemsBody tr');
    rows.forEach(r => {
      const qty = parseFloat(r.querySelector('input[name="quantity[]"]').value) || 0;
      const price = parseFloat(r.querySelector('input[name="importPrice[]"]').value) || 0;
      total += (qty * price);
    });
    document.getElementById('grandTotalText').innerText = total.toLocaleString('vi-VN') + ' ₫';
  }

  // --- MODAL 1: CHỌN TỪ KHO HÀNG CÓ SẴN (CATALOG PICKER) ---
  function openWarehouseCatalogModal() {
    renderCatalogItems(availableProducts);
    document.getElementById('warehouseCatalogModal').classList.remove('hidden');
    document.getElementById('catalogSearchInput').focus();
  }

  function closeWarehouseCatalogModal() {
    document.getElementById('warehouseCatalogModal').classList.add('hidden');
  }

  function renderCatalogItems(productsToRender) {
    const container = document.getElementById('catalogProductContainer');
    if (!productsToRender || productsToRender.length === 0) {
      container.innerHTML = `
        <div class="text-center py-8 text-slate-400">
          <span class="material-symbols-outlined text-4xl mb-1">inventory_2</span>
          <p class="text-xs">Không tìm thấy sản phẩm nào phù hợp trong kho.</p>
        </div>
      `;
      return;
    }

    container.innerHTML = productsToRender.map(p => `
      <div class="p-3 bg-white border border-slate-200 hover:border-emerald-300 rounded-xl flex items-center justify-between gap-3 hover:shadow-sm transition-all group">
        <div class="flex items-center gap-3 min-w-0">
          <img src="\${p.imageUrl || 'https://placehold.co/100x100/f1f5f9/94a3b8?text=Fruit'}" onerror="this.onerror=null;this.src='https://placehold.co/100x100/f1f5f9/94a3b8?text=Fruit';" alt="\${p.name}" class="w-12 h-12 rounded-lg object-cover border border-slate-200 flex-shrink-0">
          <div class="min-w-0">
            <div class="flex items-center gap-2">
              <h4 class="font-bold text-xs text-slate-800 truncate">\${p.name}</h4>
              <span class="text-[9px] px-1.5 py-0.5 rounded bg-slate-100 text-slate-600 font-semibold">\${p.category || 'Nông sản'}</span>
            </div>
            <div class="flex items-center gap-3 text-[11px] text-slate-500 mt-1">
              <span>Tồn kho: <strong class="text-emerald-600">\${p.stock}</strong></span>
              <span>•</span>
              <span>Giá vốn cũ: <strong class="text-amber-700">\${p.costPrice > 0 ? p.costPrice.toLocaleString('vi-VN') + ' ₫' : 'Chưa có'}</strong></span>
              <span>•</span>
              <span>Giá bán: <strong>\${p.price.toLocaleString('vi-VN')} ₫</strong></span>
            </div>
          </div>
        </div>
        <button type="button" onclick="selectFromCatalog(\${p.id})" class="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-bold flex items-center gap-1 shadow-sm flex-shrink-0">
          <span class="material-symbols-outlined text-sm">add</span> Chọn nhập
        </button>
      </div>
    `).join('');
  }

  function filterCatalog() {
    const keyword = document.getElementById('catalogSearchInput').value.toLowerCase().trim();
    const selectedCat = document.getElementById('catalogCategoryFilter').value;

    const filtered = availableProducts.filter(p => {
      const matchName = p.name.toLowerCase().includes(keyword);
      const matchCat = !selectedCat || p.category === selectedCat;
      return matchName && matchCat;
    });
    renderCatalogItems(filtered);
  }

  function selectFromCatalog(productId) {
    const prod = availableProducts.find(x => x.id === productId);
    if (!prod) return;
    const suggestedCost = prod.costPrice > 0 ? prod.costPrice : Math.round(prod.price * 0.6);
    addProductRow(productId, 20, suggestedCost);
    closeWarehouseCatalogModal();
    showToast(`Đã thêm sản phẩm "\${prod.name}" vào danh sách nhập!`);
  }

  // --- MODAL 2: NHẬP SẢN PHẨM MỚI (QUICK ADD PRODUCT) ---
  function openQuickProductModal() {
    document.getElementById('quickProductModal').classList.remove('hidden');
  }

  function closeQuickProductModal() {
    document.getElementById('quickProductModal').classList.add('hidden');
    document.getElementById('quickProductForm').reset();
    clearQuickProductImage();
    const urlBox = document.getElementById('quickImageUrlContainer');
    if (urlBox) urlBox.classList.add('hidden');
  }

  function previewQuickProductImage(e) {
    const file = e.target.files[0];
    if (!file) return;

    if (file.size > 10 * 1024 * 1024) {
      alert('Kích thước ảnh không được vượt quá 10MB!');
      e.target.value = '';
      return;
    }

    const reader = new FileReader();
    reader.onload = function(evt) {
      document.getElementById('quickImagePreviewImg').src = evt.target.result;
      document.getElementById('quickImageFileName').innerText = file.name;
      document.getElementById('quickImageFileSize').innerText = (file.size / (1024 * 1024)).toFixed(2) + ' MB';

      document.getElementById('quickImagePlaceholder').classList.add('hidden');
      const pBox = document.getElementById('quickImagePreviewBox');
      pBox.classList.remove('hidden');
      pBox.classList.add('flex');
    };
    reader.readAsDataURL(file);
  }

  function clearQuickProductImage(e) {
    if (e) {
      e.stopPropagation();
      e.preventDefault();
    }
    const fileInput = document.getElementById('quickImageFile');
    if (fileInput) fileInput.value = '';
    const previewImg = document.getElementById('quickImagePreviewImg');
    if (previewImg) previewImg.src = '#';
    const placeholder = document.getElementById('quickImagePlaceholder');
    if (placeholder) placeholder.classList.remove('hidden');
    const pBox = document.getElementById('quickImagePreviewBox');
    if (pBox) {
      pBox.classList.add('hidden');
      pBox.classList.remove('flex');
    }
  }

  function toggleQuickImageUrl() {
    const box = document.getElementById('quickImageUrlContainer');
    if (box) {
      box.classList.toggle('hidden');
      if (!box.classList.contains('hidden')) {
        document.getElementById('quickImageUrlInput').focus();
      }
    }
  }

  function submitQuickProduct(e) {
    e.preventDefault();
    const form = document.getElementById('quickProductForm');
    const submitBtn = document.getElementById('btnSubmitQuickProduct');
    const formData = new FormData(form);

    const initialQty = parseInt(document.getElementById('quickInitialQty').value) || 50;
    const initialCost = parseFloat(document.getElementById('quickInitialCost').value) || 0;

    submitBtn.disabled = true;
    submitBtn.innerHTML = `<span class="material-symbols-outlined text-sm animate-spin">progress_activity</span> Đang tải lên & tạo...`;

    fetch('${pageContext.request.contextPath}/admin/inventory/quick-product', {
      method: 'POST',
      body: formData
    })
    .then(res => res.json())
    .then(data => {
      submitBtn.disabled = false;
      submitBtn.innerHTML = `<span class="material-symbols-outlined text-sm">check</span> Tạo & Đưa vào phiếu nhập`;

      if (data.success) {
        // Thêm vào mảng local
        const newProduct = {
          id: data.id,
          name: data.name,
          category: data.categoryName,
          stock: 0,
          costPrice: 0.0,
          price: data.price,
          imageUrl: data.imageUrl
        };
        availableProducts.unshift(newProduct);

        // Đưa ngay vào bảng phiếu nhập kho
        addProductRow(data.id, initialQty, initialCost);
        closeQuickProductModal();
        showToast(`Đã tạo thành công sản phẩm mới "\${data.name}" và thêm vào phiếu nhập!`);
      } else {
        alert('Có lỗi khi tạo sản phẩm: ' + (data.message || 'Vui lòng kiểm tra lại thông tin'));
      }
    })
    .catch(err => {
      submitBtn.disabled = false;
      submitBtn.innerHTML = `<span class="material-symbols-outlined text-sm">check</span> Tạo & Đưa vào phiếu nhập`;
      alert('Lỗi kết nối máy chủ: ' + err);
    });
  }

  // --- KHỞI TẠO TRANG & XỬ LÝ QUERY PARAM PRODUCT_ID ---
  document.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    const preselectedId = urlParams.get('productId');

    if (preselectedId && availableProducts.some(p => p.id == preselectedId)) {
      addProductRow(parseInt(preselectedId), 20);
    } else if (availableProducts.length > 0) {
      addProductRow(availableProducts[0].id, 10);
    }
  });
</script>
</body>
</html>
