<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>${product.name} - Fruitables</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">

  <script src="https://cdn.tailwindcss.com?plugins=forms,typography,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-background text-on-background min-h-screen flex flex-col">

<!-- NAVBAR CHUNG -->
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<main class="flex-grow py-12">
  <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">

    <!-- Breadcrumb -->
    <nav class="mb-8 flex text-sm text-on-surface-variant font-medium">
      <a href="${pageContext.request.contextPath}/home" class="hover:text-primary transition-colors">Trang chủ</a>
      <span class="mx-2">/</span>
      <a href="${pageContext.request.contextPath}/shop" class="hover:text-primary transition-colors">Cửa hàng</a>
      <span class="mx-2">/</span>
      <span class="text-primary font-bold line-clamp-1">${product.name}</span>
    </nav>

    <!-- MAIN PRODUCT SECTION -->
    <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-outline-variant p-6 md:p-10 mb-12">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-start">

        <!-- Cột Trái: Ảnh Sản Phẩm -->
        <div class="relative group">
          <div class="w-full h-[400px] md:h-[500px] bg-surface-container rounded-xl overflow-hidden flex items-center justify-center border border-outline-variant">
            <img src="${not empty product.imageUrl ? product.imageUrl : pageContext.request.contextPath.concat('/assets/uploads/no-image.svg')}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/uploads/no-image.svg';" alt="${product.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
          </div>
          <c:if test="${product.stock > 0}">
            <div class="absolute top-4 left-4 bg-primary text-white text-xs font-bold px-3 py-1.5 rounded-full shadow-md flex items-center gap-1">
              <span class="material-symbols-outlined text-[14px]">check_circle</span> Còn hàng
            </div>
          </c:if>
        </div>

        <!-- Cột Phải: Thông tin -->
        <div class="flex flex-col h-full">
          <h1 class="text-3xl md:text-4xl font-headline-md font-bold text-on-surface mb-4 leading-tight">${product.name}</h1>

          <!-- ĐÁNH GIÁ SAO ĐỘNG -->
          <div class="flex items-center gap-4 mb-6 pb-6 border-b border-surface-variant">
            <div class="flex items-center text-yellow-500">
              <c:set var="rating" value="${product.avgRating != null ? product.avgRating : 0}" />
              <c:forEach begin="1" end="5" var="i">
                <c:choose>
                  <c:when test="${rating >= i}">
                    <span class="material-symbols-outlined text-lg" style="font-variation-settings: 'FILL' 1;">star</span>
                  </c:when>
                  <c:when test="${rating >= i - 0.5}">
                    <span class="material-symbols-outlined text-lg" style="font-variation-settings: 'FILL' 1;">star_half</span>
                  </c:when>
                  <c:otherwise>
                    <span class="material-symbols-outlined text-lg text-gray-300" style="font-variation-settings: 'FILL' 1;">star</span>
                  </c:otherwise>
                </c:choose>
              </c:forEach>
            </div>
            <span class="text-sm text-on-surface-variant font-medium">
              (${product.reviewCount != null ? product.reviewCount : 0} đánh giá)
            </span>
          </div>

          <div class="mb-6">
            <div class="text-4xl font-price-tag text-primary font-extrabold tracking-tight">
              <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> ₫
            </div>
            <c:if test="${product.taxRate > 0}">
              <div class="text-sm text-on-surface-variant mt-1">* Giá chưa bao gồm ${product.taxRate}% Thuế VAT</div>
            </c:if>
          </div>

          <p class="text-on-surface-variant text-base leading-relaxed mb-8">${product.description}</p>

          <!-- Thông số định lượng & bảo quản nhanh -->
          <div class="grid grid-cols-2 gap-3 mb-6">
            <div class="bg-surface-container-low p-3.5 rounded-xl border border-surface-variant flex items-center gap-3">
              <div class="w-9 h-9 rounded-lg bg-primary/10 text-primary flex items-center justify-center flex-shrink-0">
                <span class="material-symbols-outlined text-[20px]">scale</span>
              </div>
              <div class="min-w-0">
                <span class="text-[11px] text-on-surface-variant block">Định lượng chuẩn</span>
                <span class="font-label-bold text-xs text-on-surface truncate block font-bold">${product.weightGram != null ? product.weightGram : 500}g / phần</span>
              </div>
            </div>

            <div class="bg-surface-container-low p-3.5 rounded-xl border border-surface-variant flex items-center gap-3">
              <div class="w-9 h-9 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center flex-shrink-0">
                <span class="material-symbols-outlined text-[20px]">
                  <c:choose>
                    <c:when test="${product.storageType == 'COLD_CHAIN'}">ac_unit</c:when>
                    <c:when test="${product.storageType == 'FRAGILE_GIFT'}">featured_seasonal_and_gifts</c:when>
                    <c:otherwise>thermostat</c:otherwise>
                  </c:choose>
                </span>
              </div>
              <div class="min-w-0">
                <span class="text-[11px] text-on-surface-variant block">Bảo quản đề xuất</span>
                <span class="font-label-bold text-xs text-on-surface truncate block font-bold">
                  <c:choose>
                    <c:when test="${product.storageType == 'COLD_CHAIN'}">Chuỗi lạnh 0°C - 4°C</c:when>
                    <c:when test="${product.storageType == 'FRAGILE_GIFT'}">Hộp quà chống sốc</c:when>
                    <c:otherwise>Nhiệt độ phòng mát</c:otherwise>
                  </c:choose>
                </span>
              </div>
            </div>
          </div>

          <div class="bg-surface-container-low p-4 rounded-xl border border-surface-variant mb-8 space-y-2.5">
            <div class="flex items-center gap-3 text-xs text-on-surface">
              <span class="material-symbols-outlined text-primary text-base">local_shipping</span>
              <c:choose>
                <c:when test="${product.isFreeShipping}">
                  <span class="font-bold text-primary">Sản phẩm được Miễn phí giao hàng (Freeship)</span>
                </c:when>
                <c:otherwise>
                  <span>Miễn phí giao hàng cho mọi đơn từ 500.000₫</span>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="flex items-center gap-3 text-xs text-on-surface">
              <span class="material-symbols-outlined text-emerald-600 text-base">verified</span>
              <span>100% nông sản sạch VietGAP/GlobalGAP - Đổi trả trong 24h nếu dập hỏng</span>
            </div>
          </div>

          <!-- Xử lý Tồn kho & Form Thêm Giỏ Hàng -->
          <c:choose>
            <c:when test="${product.stock != null && product.stock <= 0}">
              <div class="mt-auto flex flex-col gap-4">
                <div class="bg-red-50 border border-red-200/80 px-5 py-4 rounded-2xl flex items-center gap-3 text-red-700 shadow-sm">
                  <span class="material-symbols-outlined text-3xl text-red-500">production_quantity_limits</span>
                  <div>
                    <div class="font-label-bold text-base">Sản phẩm tạm thời hết hàng</div>
                    <div class="text-xs text-red-600/90 mt-0.5">Mặt hàng này hiện không còn trong kho. Bạn vui lòng khám phá các sản phẩm tươi ngon khác nhé!</div>
                  </div>
                </div>
                <a href="${pageContext.request.contextPath}/shop" class="h-14 bg-primary text-white rounded-full font-label-bold text-base flex items-center justify-center gap-2 hover:bg-primary-container transition-all duration-300 shadow-[0_4px_14px_0_rgba(129,196,8,0.39)] hover:-translate-y-0.5">
                  <span class="material-symbols-outlined text-[22px]">storefront</span> Khám phá sản phẩm khác tại Cửa hàng
                </a>
              </div>
            </c:when>
            <c:otherwise>
              <!-- Form Thêm Giỏ Hàng bình thường khi còn hàng -->
              <form action="${pageContext.request.contextPath}/cart" method="POST" class="mt-auto flex flex-wrap gap-4">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="productId" value="${product.id}">

                <div class="flex items-center border-2 border-outline-variant rounded-full overflow-hidden w-36 bg-surface-container-lowest h-14">
                  <button type="button" class="w-12 h-full flex items-center justify-center text-on-surface hover:bg-surface-container transition-colors text-xl font-bold" onclick="this.nextElementSibling.stepDown()">-</button>
                  <input type="number" name="quantity" value="1" min="1" max="${product.stock}" class="w-12 text-center border-none focus:ring-0 text-on-surface bg-transparent font-label-bold p-0 text-lg">
                  <button type="button" class="w-12 h-full flex items-center justify-center text-on-surface hover:bg-surface-container transition-colors text-xl font-bold" onclick="this.previousElementSibling.stepUp()">+</button>
                </div>

                <button type="submit" class="flex-1 min-w-[200px] h-14 bg-primary text-white rounded-full font-label-bold text-lg flex items-center justify-center gap-2 hover:bg-primary-container transition-all duration-300 shadow-[0_4px_14px_0_rgba(129,196,8,0.39)] hover:shadow-[0_6px_20px_rgba(129,196,8,0.23)] hover:-translate-y-1">
                  <span class="material-symbols-outlined">add_shopping_cart</span> Thêm vào giỏ
                </button>
              </form>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <!-- TABS MÔ TẢ & ĐÁNH GIÁ (GIỮ NGUYÊN GỐC 100%) -->
    <div class="bg-surface-container-lowest rounded-2xl border border-outline-variant p-6 md:p-10 shadow-sm">

      <!-- Tab Headers -->
      <div class="flex border-b border-surface-variant mb-8 space-x-8">
        <button id="btn-tab-desc" onclick="switchTab('desc')" class="font-headline-md text-lg font-bold pb-4 border-b-2 border-primary text-primary transition-colors">
          Mô tả chi tiết
        </button>
        <button id="btn-tab-review" onclick="switchTab('review')" class="font-headline-md text-lg font-bold pb-4 border-b-2 border-transparent text-on-surface-variant hover:text-primary transition-colors">
          Đánh giá khách hàng (${product.reviewCount != null ? product.reviewCount : 0})
        </button>
      </div>

      <!-- Nội dung Tab: Mô tả -->
      <div id="tab-desc" class="block">
        <c:choose>
          <c:when test="${not empty product.detailedDescription}">
            <div class="prose prose-green max-w-none text-on-surface">
                ${product.detailedDescription}
            </div>
          </c:when>
          <c:otherwise>
            <div class="text-center py-10 text-on-surface-variant flex flex-col items-center border border-dashed border-outline-variant rounded-xl">
              <span class="material-symbols-outlined text-5xl mb-3 text-outline">article</span>
              <p>Sản phẩm này chưa có mô tả chi tiết.</p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Nội dung Tab: Đánh giá -->
      <div id="tab-review" class="hidden">

        <!-- Hiển thị thông báo trạng thái -->
        <c:if test="${param.review == 'success'}">
          <div class="bg-primary-container text-white p-4 rounded-xl mb-8 font-label-bold flex items-center gap-2 shadow-md">
            <span class="material-symbols-outlined">check_circle</span>
            Cảm ơn bạn đã gửi đánh giá sản phẩm!
          </div>
        </c:if>
        <c:if test="${param.review == 'already_reviewed'}">
          <div class="bg-blue-50 border border-blue-200 text-blue-800 p-4 rounded-xl mb-8 font-label-bold flex items-center gap-2 shadow-sm">
            <span class="material-symbols-outlined text-blue-600">info</span>
            Bạn đã gửi đánh giá cho sản phẩm này rồi! Mỗi đơn hàng thành công chỉ được đánh giá 1 lần.
          </div>
        </c:if>
        <c:if test="${param.review == 'order_processing'}">
          <div class="bg-amber-50 border border-amber-200 text-amber-800 p-4 rounded-xl mb-8 font-label-bold flex items-center gap-2 shadow-sm">
            <span class="material-symbols-outlined text-amber-600">schedule</span>
            Đơn hàng của bạn đang trong quá trình xử lý hoặc vận chuyển. Bạn vui lòng đánh giá sau khi nhận hàng thành công nhé!
          </div>
        </c:if>
        <c:if test="${param.review == 'not_purchased'}">
          <div class="bg-error-container text-error p-4 rounded-xl mb-8 font-label-bold flex items-center gap-2">
            <span class="material-symbols-outlined">error</span>
            Bạn cần mua và hoàn thành nhận hàng sản phẩm này để có thể đánh giá!
          </div>
        </c:if>
        <c:if test="${param.review == 'empty_comment'}">
          <div class="bg-error-container text-error p-4 rounded-xl mb-8 font-label-bold flex items-center gap-2">
            <span class="material-symbols-outlined">error</span>
            Vui lòng nhập nội dung nhận xét trước khi gửi đánh giá!
          </div>
        </c:if>
        <c:if test="${param.review == 'error'}">
          <div class="bg-error-container text-error p-4 rounded-xl mb-8 font-label-bold flex items-center gap-2">
            <span class="material-symbols-outlined">error</span>
            Có lỗi xảy ra khi gửi đánh giá. Vui lòng kiểm tra dung lượng ảnh (tối đa 10MB) và thử lại!
          </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
          <!-- Form Đánh Giá (Bên Trái) -->
          <div class="lg:col-span-1">
            <div class="bg-surface p-6 rounded-xl border border-outline-variant shadow-sm sticky top-28">
              <h3 class="font-headline-md text-xl mb-6 text-on-surface">Viết đánh giá</h3>
              <c:choose>
                <c:when test="${empty sessionScope.USERMODEL}">
                  <div class="text-center text-on-surface-variant font-body-md py-6">
                    Vui lòng <br>
                    <a href="${pageContext.request.contextPath}/login" class="inline-block mt-3 px-6 py-2 bg-primary text-white rounded-full font-label-bold hover:bg-primary-container transition-colors shadow-sm">Đăng nhập</a><br>
                    <span class="block mt-3">để để lại đánh giá.</span>
                  </div>
                </c:when>
                <c:when test="${canReview}">
                  <form action="${pageContext.request.contextPath}/submit-review" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="productId" value="${product.id}">
                    <div class="mb-5">
                      <label class="block font-label-bold mb-2 text-on-surface">Chất lượng</label>
                      <select name="rating" class="w-full px-4 py-3 border border-outline-variant rounded-lg focus:border-primary outline-none bg-surface-container-lowest">
                        <option value="5">5 Sao - Tuyệt vời</option>
                        <option value="4">4 Sao - Rất tốt</option>
                        <option value="3">3 Sao - Bình thường</option>
                        <option value="2">2 Sao - Kém</option>
                        <option value="1">1 Sao - Rất tệ</option>
                      </select>
                    </div>
                    <div class="mb-5">
                      <label class="block font-label-bold mb-2 text-on-surface">Nhận xét của bạn</label>
                      <textarea name="comment" rows="4" required placeholder="Sản phẩm tươi ngon, đóng gói cẩn thận..." class="w-full px-4 py-3 border border-outline-variant rounded-lg focus:border-primary outline-none bg-surface-container-lowest"></textarea>
                    </div>
                    <!-- Upload ảnh thực tế đơn hàng -->
                    <div class="mb-6">
                      <label class="block font-label-bold mb-2 text-on-surface flex items-center justify-between">
                        <span>Hình ảnh thực tế đơn hàng</span>
                        <span class="text-xs text-on-surface-variant font-normal">(Không bắt buộc)</span>
                      </label>
                      <div class="border-2 border-dashed border-outline-variant hover:border-primary rounded-xl p-4 text-center cursor-pointer transition-colors bg-surface-container-lowest relative group" onclick="document.getElementById('reviewImageInput').click()">
                        <input type="file" id="reviewImageInput" name="reviewImage" accept="image/*" class="hidden" onchange="previewReviewImage(this)">
                        <div id="uploadPrompt" class="flex flex-col items-center justify-center py-2">
                          <span class="material-symbols-outlined text-3xl text-primary mb-1">add_photo_alternate</span>
                          <span class="text-xs font-semibold text-on-surface">Đính kèm ảnh sản phẩm thực tế</span>
                          <span class="text-[11px] text-on-surface-variant mt-0.5">Hỗ trợ JPG, PNG, WEBP (tối đa 10MB)</span>
                        </div>
                        <div id="previewContainer" class="hidden relative inline-block">
                          <img id="reviewImagePreview" src="" alt="Ảnh xem trước" class="w-24 h-24 object-cover rounded-lg border shadow-sm mx-auto">
                          <button type="button" onclick="event.stopPropagation(); removeReviewImage();" class="absolute -top-2 -right-2 bg-error text-white rounded-full w-5 h-5 flex items-center justify-center shadow hover:bg-error/80 text-xs">
                            <span class="material-symbols-outlined text-xs">close</span>
                          </button>
                        </div>
                      </div>
                    </div>
                    <button type="submit" class="w-full bg-primary text-white px-6 py-3 rounded-full font-label-bold hover:bg-primary-container transition-colors shadow-md flex items-center justify-center gap-2">
                      <span class="material-symbols-outlined">send</span> Gửi đánh giá
                    </button>
                  </form>
                </c:when>
                <c:when test="${alreadyReviewed}">
                  <div class="bg-primary/10 border border-primary/20 rounded-xl p-5 text-center">
                    <span class="material-symbols-outlined text-primary text-4xl mb-2">verified</span>
                    <h4 class="font-bold text-on-surface text-base">Bạn đã đánh giá sản phẩm này</h4>
                    <p class="text-xs text-on-surface-variant mt-2 leading-relaxed">Cảm ơn bạn đã đóng góp ý kiến chân thực giúp Fruitables không ngừng hoàn thiện chất lượng phục vụ!</p>
                  </div>
                </c:when>
                <c:when test="${hasPurchased}">
                  <div class="bg-amber-50 border border-amber-200 rounded-xl p-5 text-center">
                    <span class="material-symbols-outlined text-amber-600 text-4xl mb-2">local_shipping</span>
                    <h4 class="font-bold text-amber-900 text-base">Đơn hàng đang giao</h4>
                    <p class="text-xs text-amber-700 mt-2 leading-relaxed">Bạn đã đặt mua sản phẩm này. Bạn có thể đánh giá ngay sau khi đơn hàng được giao thành công tới bạn nhé!</p>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="bg-surface-container-low border border-outline-variant rounded-xl p-5 text-center">
                    <span class="material-symbols-outlined text-outline text-4xl mb-2">shopping_bag</span>
                    <h4 class="font-bold text-on-surface text-base">Chưa mua sản phẩm</h4>
                    <p class="text-xs text-on-surface-variant mt-2 leading-relaxed">Để đảm bảo tính khách quan, chỉ những khách hàng đã mua và nhận hàng thành công mới có thể gửi đánh giá.</p>
                    <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center gap-1.5 mt-4 px-4 py-2 bg-primary/10 text-primary hover:bg-primary hover:text-white rounded-full text-xs font-bold transition-all">
                      <span class="material-symbols-outlined text-sm">storefront</span> Khám phá cửa hàng
                    </a>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <!-- Danh sách Comment (Bên Phải) - ĐÃ BỔ SUNG AVATAR & ẢNH ĐƠN HÀNG THỰC TẾ -->
          <div class="lg:col-span-2">
            <h3 class="font-headline-md text-xl mb-6 text-on-surface">Khách hàng đánh giá</h3>

            <c:choose>
              <c:when test="${not empty reviews}">
                <div class="space-y-6">
                  <c:forEach var="rv" items="${reviews}">
                    <div class="bg-surface-container-lowest p-5 rounded-xl border border-surface-variant hover:shadow-md transition-shadow">
                      <div class="flex items-center justify-between mb-4">
                        <div class="flex items-center gap-3">
                          <!-- AVATAR ĐỘNG TỪ DATABASE HOẶC CHỮ CÁI ĐẦU NẾU KHÔNG CÓ ẢNH -->
                          <c:choose>
                            <c:when test="${not empty rv.avatarUrl}">
                              <div class="w-10 h-10 rounded-full border border-outline-variant overflow-hidden">
                                <img src="${rv.avatarUrl}" alt="Avatar" class="w-full h-full object-cover">
                              </div>
                            </c:when>
                            <c:otherwise>
                              <div class="w-10 h-10 rounded-full bg-primary-container text-primary flex items-center justify-center font-bold text-lg uppercase">
                                  ${not empty rv.userName ? rv.userName.substring(0,1) : 'U'}
                              </div>
                            </c:otherwise>
                          </c:choose>
                          <div>
                            <div class="font-label-bold text-on-surface"><c:out value="${rv.userName}"/></div>
                            <div class="text-xs text-on-surface-variant"><fmt:formatDate value="${rv.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                          </div>
                        </div>

                        <!-- Sao của từng comment -->
                        <div class="flex text-yellow-500">
                          <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                              <c:when test="${rv.rating >= i}">
                                <span class="material-symbols-outlined text-[16px]" style="font-variation-settings: 'FILL' 1;">star</span>
                              </c:when>
                              <c:otherwise>
                                <span class="material-symbols-outlined text-[16px] text-gray-300" style="font-variation-settings: 'FILL' 1;">star</span>
                              </c:otherwise>
                            </c:choose>
                          </c:forEach>
                        </div>
                      </div>
                      <p class="font-body-md text-on-surface pl-13"><c:out value="${rv.comment}"/></p>
                      
                      <!-- Hiển thị ảnh đơn hàng đính kèm nếu có -->
                      <c:if test="${not empty rv.imageUrl}">
                        <div class="mt-3 pl-13 flex items-center gap-2">
                          <div class="relative group cursor-pointer" onclick="openLightbox('${rv.imageUrl}')">
                            <img src="${rv.imageUrl}" alt="Ảnh thực tế từ khách hàng" onerror="this.onerror=null;this.parentElement.parentElement.style.display='none';" class="w-24 h-24 object-cover rounded-lg border border-outline-variant group-hover:opacity-90 group-hover:scale-105 transition-all shadow-sm">
                            <div class="absolute inset-0 bg-black/20 opacity-0 group-hover:opacity-100 rounded-lg flex items-center justify-center text-white transition-opacity">
                              <span class="material-symbols-outlined text-lg">zoom_in</span>
                            </div>
                          </div>
                          <span class="text-xs text-on-surface-variant italic">(Ảnh chụp thực tế)</span>
                        </div>
                      </c:if>

                      <!-- PHẢN HỒI TỪ CỬA HÀNG / TRỢ LÝ AI CSKH -->
                      <c:if test="${not empty rv.reply}">
                        <div class="mt-4 ml-4 sm:ml-12 p-4 rounded-xl border ${rv.sentiment eq 'NEGATIVE' ? 'bg-amber-50/70 border-amber-200' : 'bg-surface-container-low border-surface-variant'} relative transition-all">
                          <!-- Mũi tên chỉ lên mô phỏng reply bubble -->
                          <div class="absolute -top-1.5 left-6 w-3 h-3 bg-inherit border-t border-l border-inherit transform rotate-45"></div>

                          <div class="flex items-center justify-between gap-2 mb-2 flex-wrap">
                            <div class="flex items-center gap-2">
                              <div class="w-6 h-6 rounded-full bg-primary flex items-center justify-center text-white text-xs font-bold shadow-sm">
                                🌿
                              </div>
                              <span class="font-label-bold text-xs text-primary font-bold">Fruitables Store</span>
                              <span class="text-[10px] uppercase font-bold tracking-wider px-2 py-0.5 rounded-full ${rv.sentiment eq 'NEGATIVE' ? 'bg-amber-100 text-amber-800' : 'bg-emerald-100 text-emerald-800'}">
                                ${rv.replyBy eq 'AI_AGENT' ? 'Trợ lý CSKH' : 'Quản trị viên'}
                              </span>
                            </div>
                            <c:if test="${not empty rv.replyAt}">
                              <span class="text-[11px] text-on-surface-variant">
                                <fmt:formatDate value="${rv.replyAt}" pattern="dd/MM/yyyy HH:mm"/>
                              </span>
                            </c:if>
                          </div>

                          <p class="font-body-md text-xs sm:text-sm text-on-surface leading-relaxed whitespace-pre-line">
                            <c:out value="${rv.reply}"/>
                          </p>

                          <!-- NẾU LÀ ĐÁNH GIÁ TIÊU CỰC: Nút Kêu Gọi Nhắn Tin Trực Tiếp Với CSKH -->
                          <c:if test="${rv.sentiment eq 'NEGATIVE' or rv.rating le 2}">
                            <div class="mt-3 pt-2.5 border-t border-amber-200/80 flex items-center justify-between flex-wrap gap-2">
                              <span class="text-xs text-amber-900 font-medium flex items-center gap-1">
                                <span class="material-symbols-outlined text-sm text-amber-700">support_agent</span>
                                Trải nghiệm của bạn chưa như ý?
                              </span>
                              <button type="button" onclick="if(window.openLiveChatSupport) window.openLiveChatSupport();" 
                                      class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-primary text-white rounded-lg text-xs font-bold hover:bg-emerald-700 transition-all shadow-sm active:scale-95 cursor-pointer">
                                <span class="material-symbols-outlined text-xs">chat</span>
                                <span>Nhắn tin với CSKH ngay</span>
                              </button>
                            </div>
                          </c:if>
                        </div>
                      </c:if>
                    </div>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise>
                <div class="text-center py-12 text-on-surface-variant flex flex-col items-center border border-dashed border-outline-variant rounded-xl">
                  <span class="material-symbols-outlined text-5xl mb-3 text-outline">forum</span>
                  <p>Chưa có đánh giá nào cho sản phẩm này.</p>
                  <p class="text-sm mt-2">Hãy là người đầu tiên mua và đánh giá sản phẩm!</p>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

    </div>
  </div>
</main>

<!-- LIGHTBOX MODAL PHÓNG TO ẢNH ĐÁNH GIÁ -->
<div id="lightboxModal" class="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm hidden flex items-center justify-center p-4 transition-all" onclick="closeLightbox()">
  <div class="relative max-w-3xl max-h-[90vh]" onclick="event.stopPropagation()">
    <img id="lightboxImg" src="" alt="Ảnh phóng to" class="max-w-full max-h-[85vh] rounded-xl shadow-2xl object-contain">
    <button type="button" onclick="closeLightbox()" class="absolute -top-3 -right-3 bg-white text-gray-800 rounded-full w-8 h-8 flex items-center justify-center shadow-lg hover:bg-gray-100 font-bold">
      <span class="material-symbols-outlined text-sm">close</span>
    </button>
  </div>
</div>

<!-- FOOTER CHUNG -->
<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<!-- KỊCH BẢN CHUYỂN TABS & XỬ LÝ ẢNH REVIEW -->
<script>
  function switchTab(tabName) {
    const tabDesc = document.getElementById('tab-desc');
    const tabReview = document.getElementById('tab-review');
    const btnDesc = document.getElementById('btn-tab-desc');
    const btnReview = document.getElementById('btn-tab-review');

    if (tabName === 'desc') {
      tabDesc.classList.remove('hidden');
      tabDesc.classList.add('block');
      tabReview.classList.remove('block');
      tabReview.classList.add('hidden');

      btnDesc.classList.add('border-primary', 'text-primary');
      btnDesc.classList.remove('border-transparent', 'text-on-surface-variant');
      btnReview.classList.remove('border-primary', 'text-primary');
      btnReview.classList.add('border-transparent', 'text-on-surface-variant');
    } else {
      tabReview.classList.remove('hidden');
      tabReview.classList.add('block');
      tabDesc.classList.remove('block');
      tabDesc.classList.add('hidden');

      btnReview.classList.add('border-primary', 'text-primary');
      btnReview.classList.remove('border-transparent', 'text-on-surface-variant');
      btnDesc.classList.remove('border-primary', 'text-primary');
      btnDesc.classList.add('border-transparent', 'text-on-surface-variant');
    }
  }

  function previewReviewImage(input) {
    const prompt = document.getElementById('uploadPrompt');
    const container = document.getElementById('previewContainer');
    const preview = document.getElementById('reviewImagePreview');
    if (input.files && input.files[0]) {
      const file = input.files[0];
      if (file.size > 10 * 1024 * 1024) {
        alert("Dung lượng ảnh không được vượt quá 10MB!");
        removeReviewImage();
        return;
      }
      if (!file.type.startsWith('image/')) {
        alert("Vui lòng chỉ chọn tệp hình ảnh (JPG, PNG, WEBP)!");
        removeReviewImage();
        return;
      }
      const reader = new FileReader();
      reader.onload = function(e) {
        preview.src = e.target.result;
        prompt.classList.add('hidden');
        container.classList.remove('hidden');
      };
      reader.readAsDataURL(file);
    }
  }

  function removeReviewImage() {
    const input = document.getElementById('reviewImageInput');
    const prompt = document.getElementById('uploadPrompt');
    const container = document.getElementById('previewContainer');
    const preview = document.getElementById('reviewImagePreview');
    input.value = '';
    preview.src = '';
    container.classList.add('hidden');
    prompt.classList.remove('hidden');
  }

  function openLightbox(imageUrl) {
    const modal = document.getElementById('lightboxModal');
    const img = document.getElementById('lightboxImg');
    img.src = imageUrl;
    modal.classList.remove('hidden');
  }

  function closeLightbox() {
    const modal = document.getElementById('lightboxModal');
    modal.classList.add('hidden');
    document.getElementById('lightboxImg').src = '';
  }

  // Tự động mở tab Đánh giá nếu có tham số review trên URL hoặc hash
  document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('review') || window.location.hash === '#tab-review') {
      switchTab('review');
      setTimeout(function() {
        const reviewTab = document.getElementById('btn-tab-review');
        if (reviewTab) {
          reviewTab.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }, 150);
    }
  });
</script>
</body>
</html>