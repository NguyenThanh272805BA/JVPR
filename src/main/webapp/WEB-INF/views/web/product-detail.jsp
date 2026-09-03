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

<main class="flex-grow py-12 bg-surface">
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
            <img src="${product.imageUrl}" alt="${product.name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
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

          <div class="bg-surface-container-low p-4 rounded-xl border border-surface-variant mb-8 space-y-3">
            <div class="flex items-center gap-3 text-sm text-on-surface">
              <span class="material-symbols-outlined text-primary">local_shipping</span>
              <span>Miễn phí giao hàng cho đơn từ 500.000đ</span>
            </div>
            <div class="flex items-center gap-3 text-sm text-on-surface">
              <span class="material-symbols-outlined text-primary">verified_user</span>
              <span>Cam kết 100% hữu cơ, đổi trả trong 24h nếu không tươi</span>
            </div>
          </div>

          <!-- Form Thêm Giỏ Hàng -->
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
        <c:if test="${param.review == 'not_purchased'}">
          <div class="bg-error-container text-error p-4 rounded-xl mb-8 font-label-bold flex items-center gap-2">
            <span class="material-symbols-outlined">error</span>
            Bạn cần mua và hoàn thành nhận hàng sản phẩm này để có thể đánh giá!
          </div>
        </c:if>
        <c:if test="${param.review == 'success'}">
          <div class="bg-primary-container text-white p-4 rounded-xl mb-8 font-label-bold flex items-center gap-2 shadow-md">
            <span class="material-symbols-outlined">check_circle</span>
            Cảm ơn bạn đã gửi đánh giá!
          </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
          <!-- Form Đánh Giá (Bên Trái) -->
          <div class="lg:col-span-1">
            <div class="bg-surface p-6 rounded-xl border border-outline-variant shadow-sm sticky top-28">
              <h3 class="font-headline-md text-xl mb-6 text-on-surface">Viết đánh giá</h3>
              <c:choose>
                <c:when test="${not empty sessionScope.USERMODEL}">
                  <form action="${pageContext.request.contextPath}/submit-review" method="POST">
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
                    <div class="mb-6">
                      <label class="block font-label-bold mb-2 text-on-surface">Nhận xét của bạn</label>
                      <textarea name="comment" rows="4" required placeholder="Sản phẩm tươi ngon, đóng gói cẩn thận..." class="w-full px-4 py-3 border border-outline-variant rounded-lg focus:border-primary outline-none bg-surface-container-lowest"></textarea>
                    </div>
                    <button type="submit" class="w-full bg-primary text-white px-6 py-3 rounded-full font-label-bold hover:bg-primary-container transition-colors shadow-md flex items-center justify-center gap-2">
                      <span class="material-symbols-outlined">send</span> Gửi đánh giá
                    </button>
                  </form>
                </c:when>
                <c:otherwise>
                  <div class="text-center text-on-surface-variant font-body-md py-6">
                    Vui lòng <br>
                    <a href="${pageContext.request.contextPath}/login" class="inline-block mt-3 px-6 py-2 bg-primary text-white rounded-full font-label-bold hover:bg-primary-container transition-colors shadow-sm">Đăng nhập</a><br>
                    <span class="block mt-3">để để lại đánh giá.</span>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <!-- Danh sách Comment (Bên Phải) - ĐÃ BỔ SUNG AVATAR THỰC TẾ -->
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
                                  ${rv.userName != null ? rv.userName.substring(0,1) : 'U'}
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

<!-- FOOTER CHUNG -->
<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<!-- KỊCH BẢN CHUYỂN TABS (GIỮ NGUYÊN GỐC 100%) -->
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
</script>
</body>
</html>