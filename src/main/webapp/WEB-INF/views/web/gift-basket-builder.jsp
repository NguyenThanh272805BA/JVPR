<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Tự Thiết Kế Giỏ Quà Hoa Quả - Fruitables</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>
<body class="bg-surface-container bg-pattern min-h-screen flex flex-col antialiased">
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<main class="flex-grow py-8 md:py-12">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <!-- BREADCRUMB -->
        <nav class="flex items-center gap-2 text-xs text-on-surface-variant mb-6 font-medium">
            <a href="${pageContext.request.contextPath}/home" class="hover:text-primary">Trang chủ</a>
            <span>/</span>
            <span class="text-on-surface font-bold">Custom Fruit Gift Basket Builder</span>
        </nav>

        <!-- BANNER HERO -->
        <div class="bg-gradient-to-r from-[#1c3d24] via-[#0d2818] to-[#041a0f] text-white rounded-3xl p-6 md:p-10 shadow-xl mb-8 relative overflow-hidden">
            <div class="relative z-10 max-w-2xl space-y-3">
                <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-amber-400/20 text-amber-300 text-xs font-bold border border-amber-400/30">
                    <span class="material-symbols-outlined text-sm">featured_seasonal_and_gifts</span> Thiết kế quà tặng cao cấp
                </div>
                <h1 class="font-headline-lg text-3xl sm:text-4xl font-extrabold tracking-tight">
                    Tự Tay Mix Giỏ Quà Hoa Quả Theo Ý Muốn
                </h1>
                <p class="text-slate-300 text-xs sm:text-sm leading-relaxed">
                    Tự do lựa chọn vỏ giỏ quà sang trọng, gắp từng loại quả tươi ngon mọng nước bạn ưng ý nhất, thắt nơ ruy băng và in thiệp chúc mừng mạ vàng miễn phí.
                </p>
                <div class="flex flex-wrap gap-4 pt-2 text-xs text-slate-300">
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-emerald-400 text-sm">check_circle</span> Đóng gói chống sốc chuyên dụng</span>
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-amber-400 text-sm">palette</span> Miễn phí in thiệp & thắt nơ</span>
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-sky-400 text-sm">bolt</span> Giao hỏa tốc 1-2H</span>
                </div>
            </div>
            <span class="material-symbols-outlined absolute -right-10 -bottom-10 text-[240px] text-white/5 pointer-events-none">card_giftcard</span>
        </div>

        <form id="basketBuilderForm" action="${pageContext.request.contextPath}/gift-basket-builder" method="POST">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                
                <!-- CỘT TRÁI: CÁC BƯỚC THIẾT KẾ -->
                <div class="lg:col-span-8 space-y-8">
                    
                    <!-- BƯỚC 1: CHỌN MẪU VỎ GIỎ / HỘP QUÀ -->
                    <div class="bg-surface-container-lowest p-6 md:p-8 rounded-3xl shadow-sm border border-outline-variant space-y-4">
                        <div class="flex items-center justify-between pb-3 border-b border-surface-variant">
                            <h2 class="font-headline-md text-lg text-on-surface font-bold flex items-center gap-2">
                                <span class="w-7 h-7 rounded-full bg-primary text-white flex items-center justify-center text-xs font-bold">1</span>
                                Chọn Mẫu Vỏ Giỏ / Hộp Quà
                            </h2>
                            <span class="text-xs text-on-surface-variant">Bước 1/3</span>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                            <c:forEach var="t" items="${templates}" varStatus="loop">
                                <label class="relative block rounded-2xl border-2 p-4 cursor-pointer transition-all duration-300 hover:shadow-md template-card ${loop.first ? 'border-primary bg-primary/5 ring-2 ring-primary/20' : 'border-outline-variant bg-surface-container-lowest'}"
                                       onclick="selectTemplate(${t.id}, '${t.name}', ${t.basePrice}, ${t.capacityKg != null ? t.capacityKg : 5.0})">
                                    <input type="radio" name="templateId" value="${t.id}" class="sr-only" ${loop.first ? 'checked' : ''}>
                                    
                                    <div class="w-full h-36 rounded-xl overflow-hidden mb-3 bg-surface-container">
                                        <img src="${t.imageUrl}" alt="${t.name}" class="w-full h-full object-cover">
                                    </div>

                                    <h3 class="font-bold text-xs text-on-surface line-clamp-2 h-8">${t.name}</h3>
                                    <p class="text-[11px] text-on-surface-variant mt-1">Chất liệu: <strong class="text-on-surface">${t.material}</strong></p>
                                    <p class="text-[11px] text-on-surface-variant">Sức chứa: <strong class="text-emerald-700 font-bold">~${t.capacityKg} kg</strong></p>

                                    <div class="mt-3 pt-2 border-t border-surface-variant flex justify-between items-center">
                                        <span class="text-[10px] text-on-surface-variant">Giá vỏ hộp:</span>
                                        <span class="font-bold text-primary text-sm font-price-tag">
                                            <fmt:formatNumber value="${t.basePrice}" type="number" groupingUsed="true"/> ₫
                                        </span>
                                    </div>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- BƯỚC 2: GẮP HOA QUẢ TƯƠI VÀO GIỎ -->
                    <div class="bg-surface-container-lowest p-6 md:p-8 rounded-3xl shadow-sm border border-outline-variant space-y-4">
                        <div class="flex items-center justify-between pb-3 border-b border-surface-variant">
                            <h2 class="font-headline-md text-lg text-on-surface font-bold flex items-center gap-2">
                                <span class="w-7 h-7 rounded-full bg-primary text-white flex items-center justify-center text-xs font-bold">2</span>
                                Gắp Hoa Quả Tươi Vào Giỏ Hàng
                            </h2>
                            <span class="text-xs text-on-surface-variant">Bước 2/3</span>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 max-h-[500px] overflow-y-auto p-1">
                            <c:forEach var="f" items="${fruits}">
                                <div class="flex items-center gap-3 p-3 rounded-2xl border border-outline-variant bg-surface-container/40 hover:bg-surface-container/70 transition-colors">
                                    <input type="hidden" name="fruitId" value="${f.id}">
                                    <div class="w-16 h-16 rounded-xl overflow-hidden border border-outline-variant flex-shrink-0 bg-surface-container">
                                        <img src="${not empty f.imageUrl ? f.imageUrl : pageContext.request.contextPath.concat('/assets/uploads/no-image.svg')}"
                                             alt="${f.name}" class="w-full h-full object-cover">
                                    </div>
                                    <div class="flex-grow min-w-0">
                                        <h4 class="font-bold text-xs text-on-surface line-clamp-1">${f.name}</h4>
                                        <div class="text-[11px] font-price-tag text-primary font-bold mt-0.5" data-price="${f.price}">
                                            <fmt:formatNumber value="${f.price}" type="number" groupingUsed="true"/> ₫ / phần (~${f.weightGram != null ? f.weightGram : 500}g)
                                        </div>
                                        <div class="flex items-center gap-2 mt-2">
                                            <button type="button" onclick="adjustFruitQty(${f.id}, -1)" class="w-6 h-6 rounded-lg bg-surface-container-lowest border border-outline-variant flex items-center justify-center text-on-surface hover:bg-surface-variant font-bold text-xs">-</button>
                                            <input type="number" id="qty_${f.id}" name="quantity" value="0" min="0" max="10" readonly
                                                   data-name="${f.name}" data-price="${f.price}" data-weight="${f.weightGram != null ? f.weightGram : 500}"
                                                   class="fruit-qty-input w-9 text-center text-xs font-bold border-0 bg-transparent py-0 px-0 outline-none">
                                            <button type="button" onclick="adjustFruitQty(${f.id}, 1)" class="w-6 h-6 rounded-lg bg-primary text-white flex items-center justify-center hover:bg-primary-container font-bold text-xs">+</button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- BƯỚC 3: RUY BĂNG & THIỆP CHÚC MỪNG -->
                    <div class="bg-surface-container-lowest p-6 md:p-8 rounded-3xl shadow-sm border border-outline-variant space-y-4">
                        <div class="flex items-center justify-between pb-3 border-b border-surface-variant">
                            <h2 class="font-headline-md text-lg text-on-surface font-bold flex items-center gap-2">
                                <span class="w-7 h-7 rounded-full bg-primary text-white flex items-center justify-center text-xs font-bold">3</span>
                                Nơ Ruy Băng & Thiệp Chúc Mừng (Miễn Phí)
                            </h2>
                            <span class="text-xs text-on-surface-variant">Bước 3/3</span>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-on-surface mb-1.5">Màu nơ lụa ruy băng:</label>
                                <select name="ribbonColor" class="w-full px-3 py-2.5 rounded-xl border border-outline-variant bg-surface-container-low text-xs font-medium focus:border-primary outline-none">
                                    <option value="Đỏ May Mắn (Thịnh vượng & Tài lộc)" selected>🎀 Nơ Đỏ May Mắn (Thịnh vượng & Tài lộc)</option>
                                    <option value="Vàng Hoàng Gia (Sang trọng & Quý phái)">🎀 Nơ Vàng Hoàng Gia (Sang trọng & Quý phái)</option>
                                    <option value="Xanh Ngọc Bích (Thanh lịch & Tươi mát)">🎀 Nơ Xanh Ngọc Bích (Thanh lịch & Tươi mát)</option>
                                    <option value="Hồng Pastel (Tinh tế & Ấm áp)">🎀 Nơ Hồng Pastel (Tinh tế & Ấm áp)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-on-surface mb-1.5">Thông điệp in thiệp chúc mừng:</label>
                                <input type="text" name="cardMessage" placeholder="Ví dụ: Kính chúc Gia Đình Năm Mới Bình An Vạn Sự Như Ý..."
                                       class="w-full px-3 py-2.5 rounded-xl border border-outline-variant bg-surface-container-low text-xs focus:border-primary outline-none">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CỘT PHẢI: STICKY TỔNG HỢP & GIỎ HÀNG -->
                <div class="lg:col-span-4 sticky top-24 space-y-6">
                    <div class="bg-surface-container-lowest p-6 rounded-3xl shadow-lg border border-outline-variant space-y-4">
                        <h3 class="font-headline-md text-base text-on-surface font-bold pb-3 border-b border-surface-variant flex items-center justify-between">
                            <span>Giỏ Quà Của Bạn</span>
                            <span class="text-[10px] uppercase font-extrabold px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800">Live Preview</span>
                        </h3>

                        <!-- Thông tin mẫu giỏ -->
                        <div class="p-3 rounded-2xl bg-surface-container/60 border border-outline-variant space-y-1 text-xs">
                            <span class="text-[10px] text-on-surface-variant block">Mẫu vỏ giỏ:</span>
                            <span class="font-bold text-slate-800" id="selectedTemplateName">--</span>
                            <div class="flex justify-between text-[11px] text-on-surface-variant pt-1">
                                <span>Giá vỏ hộp:</span>
                                <strong class="text-slate-800 font-price-tag" id="selectedTemplatePrice">0 ₫</strong>
                            </div>
                        </div>

                        <!-- Danh sách quả đã gắp -->
                        <div class="space-y-2">
                            <span class="text-xs font-bold text-on-surface flex items-center justify-between">
                                <span>Hoa quả đã chọn:</span>
                                <span class="text-[11px] font-normal text-on-surface-variant" id="fruitCountLabel">0 loại</span>
                            </span>
                            <div id="selectedFruitsList" class="space-y-1.5 max-h-40 overflow-y-auto text-xs text-on-surface-variant pr-1">
                                <span class="italic text-[11px] text-slate-400 block py-2">Chưa gắp loại quả nào vào giỏ...</span>
                            </div>
                        </div>

                        <!-- Thanh cân nặng ước tính -->
                        <div class="space-y-1.5 pt-2 border-t border-surface-variant">
                            <div class="flex justify-between text-xs">
                                <span class="text-on-surface-variant">Trọng lượng giỏ:</span>
                                <span class="font-bold text-on-surface"><span id="totalWeightDisplay">1.0</span> / <span id="capacityKgDisplay">5.0</span> kg</span>
                            </div>
                            <div class="w-full h-2 bg-surface-variant rounded-full overflow-hidden">
                                <div id="weightProgressBar" class="h-full bg-primary transition-all duration-300" style="width: 20%;"></div>
                            </div>
                        </div>

                        <!-- Tổng chi phí -->
                        <div class="pt-3 border-t border-surface-variant flex justify-between items-center">
                            <div>
                                <span class="text-xs text-on-surface-variant block">Tổng giá trị giỏ quà:</span>
                                <span class="text-[10px] text-emerald-600 font-medium">Đã gồm vỏ hộp + hoa quả + nơ</span>
                            </div>
                            <span class="font-price-tag text-2xl text-primary font-extrabold" id="totalBasketPriceDisplay">0 ₫</span>
                        </div>

                        <button type="submit" id="btnAddToCart" class="w-full py-3.5 bg-primary hover:bg-primary-container text-white rounded-full font-bold text-sm shadow-md transition-all flex items-center justify-center gap-2 hover:-translate-y-0.5">
                            <span class="material-symbols-outlined text-lg">shopping_basket</span>
                            Thêm Giỏ Quà Vào Giỏ Hàng
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>

<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<script>
    let currentTemplate = {
        id: 1,
        name: '${templates != null && !templates.isEmpty() ? templates.get(0).name : ""}',
        price: ${templates != null && !templates.isEmpty() ? templates.get(0).basePrice : 0},
        capacity: ${templates != null && !templates.isEmpty() ? templates.get(0).capacityKg : 5.0}
    };

    function formatCurrency(num) {
        return new Intl.NumberFormat('vi-VN').format(Math.round(num)) + ' ₫';
    }

    function selectTemplate(id, name, price, capacity) {
        currentTemplate = { id, name, price, capacity };
        document.querySelectorAll('.template-card').forEach(c => {
            c.classList.remove('border-primary', 'bg-primary/5', 'ring-2', 'ring-primary/20');
            c.classList.add('border-outline-variant', 'bg-surface-container-lowest');
        });
        event.currentTarget.classList.remove('border-outline-variant', 'bg-surface-container-lowest');
        event.currentTarget.classList.add('border-primary', 'bg-primary/5', 'ring-2', 'ring-primary/20');
        
        recalculateBasket();
    }

    function adjustFruitQty(id, delta) {
        const input = document.getElementById('qty_' + id);
        if (!input) return;
        let current = parseInt(input.value) || 0;
        current = Math.max(0, Math.min(10, current + delta));
        input.value = current;
        recalculateBasket();
    }

    function recalculateBasket() {
        let total = currentTemplate.price;
        let weightGram = 1000; // Khối lượng vỏ giỏ & phụ kiện
        let fruitCount = 0;
        const selectedListEl = document.getElementById('selectedFruitsList');
        selectedListEl.innerHTML = '';

        const fruitInputs = document.querySelectorAll('.fruit-qty-input');
        fruitInputs.forEach(input => {
            const qty = parseInt(input.value) || 0;
            if (qty > 0) {
                fruitCount++;
                const name = input.getAttribute('data-name');
                const price = parseFloat(input.getAttribute('data-price')) || 0;
                const weight = parseInt(input.getAttribute('data-weight')) || 500;

                total += price * qty;
                weightGram += weight * qty;

                const row = document.createElement('div');
                row.className = 'flex justify-between items-center py-1 border-b border-surface-variant/40';
                row.innerHTML = '<span class="truncate max-w-[170px]">' + qty + 'x ' + name + '</span><span class="font-bold text-slate-800">' + formatCurrency(price * qty) + '</span>';
                selectedListEl.appendChild(row);
            }
        });

        if (fruitCount === 0) {
            selectedListEl.innerHTML = '<span class="italic text-[11px] text-slate-400 block py-2">Chưa gắp loại quả nào vào giỏ...</span>';
        }

        document.getElementById('selectedTemplateName').innerText = currentTemplate.name;
        document.getElementById('selectedTemplatePrice').innerText = formatCurrency(currentTemplate.price);
        document.getElementById('fruitCountLabel').innerText = fruitCount + ' loại';

        const weightKg = (weightGram / 1000).toFixed(1);
        document.getElementById('totalWeightDisplay').innerText = weightKg;
        document.getElementById('capacityKgDisplay').innerText = currentTemplate.capacity;

        const percent = Math.min(100, Math.round((weightKg / currentTemplate.capacity) * 100));
        const progressBar = document.getElementById('weightProgressBar');
        progressBar.style.width = percent + '%';
        if (percent > 90) {
            progressBar.className = 'h-full bg-amber-500 transition-all duration-300';
        } else {
            progressBar.className = 'h-full bg-primary transition-all duration-300';
        }

        document.getElementById('totalBasketPriceDisplay').innerText = formatCurrency(total);
    }

    document.addEventListener('DOMContentLoaded', () => {
        recalculateBasket();
    });
</script>
</body>
</html>
