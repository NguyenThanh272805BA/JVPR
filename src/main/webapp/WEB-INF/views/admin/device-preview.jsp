<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Giả lập & Kiểm thử Thiết bị - Fruitables Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
    <style>
        /* Tùy biến cuộn và hiệu ứng studio canvas */
        .preview-canvas {
            background-color: #0f172a;
            background-image: radial-gradient(rgba(148, 163, 184, 0.15) 1px, transparent 1px);
            background-size: 20px 20px;
        }
        .preview-canvas.light-canvas {
            background-color: #f1f5f9;
            background-image: radial-gradient(rgba(100, 116, 139, 0.2) 1px, transparent 1px);
            background-size: 20px 20px;
        }
        /* Cần cuộn mượt cho iframe */
        #preview-iframe {
            border: none;
            width: 100%;
            height: 100%;
            background: #ffffff;
        }
        /* Nút sườn điện thoại giả lập */
        .phone-button-volume {
            position: absolute;
            left: -4px;
            width: 4px;
            background: #475569;
            border-radius: 2px 0 0 2px;
        }
        .phone-button-power {
            position: absolute;
            right: -4px;
            top: 90px;
            width: 4px;
            height: 50px;
            background: #475569;
            border-radius: 0 2px 2px 0;
        }
    </style>
</head>
<body class="bg-background text-on-surface font-body-md text-body-md flex h-screen overflow-hidden">

<!-- SIDEBAR CHUẨN ADMIN -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />

<!-- MAIN WRAPPER -->
<main class="flex-1 flex flex-col h-screen overflow-hidden">

    <!-- TOP TOOLBAR: ĐIỀU KHIỂN & CHỌN THIẾT BỊ -->
    <header class="bg-surface border-b border-surface-variant flex-shrink-0 z-10 shadow-sm">
        <!-- Hàng 1: Tiêu đề, chọn thiết bị và công cụ hỗ trợ -->
        <div class="px-5 py-2.5 flex flex-wrap items-center justify-between gap-3 border-b border-slate-100">
            
            <!-- Tiêu đề & Breakpoint Badge -->
            <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-lg bg-primary/10 text-primary flex items-center justify-center">
                    <svg class="w-5 h-5"><use href="#icon-device-preview"/></svg>
                </div>
                <div>
                    <div class="flex items-center gap-2">
                        <h1 class="text-base font-bold text-slate-800">Giả lập Thiết bị</h1>
                        <span id="badge-breakpoint" class="px-2 py-0.5 text-xs font-bold rounded-full bg-emerald-100 text-emerald-700">
                            XS (&lt;576px)
                        </span>
                    </div>
                    <p class="text-[11px] text-slate-500">Kiểm tra hiển thị Responsive của Fruitables trên đa nền tảng</p>
                </div>
            </div>

            <!-- Bộ nút chọn thiết bị nhanh (Device Presets) -->
            <div class="flex items-center gap-1.5 bg-slate-100 p-1 rounded-xl border border-slate-200" id="device-selector-group">
                <button type="button" onclick="selectDevice('iphone14')" data-device="iphone14" 
                        class="device-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all bg-white text-primary shadow-sm">
                    <svg class="w-3.5 h-3.5"><use href="#icon-smartphone"/></svg>
                    <span>iPhone 15/14</span>
                </button>
                <button type="button" onclick="selectDevice('compact')" data-device="compact" 
                        class="device-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all text-slate-600 hover:text-slate-900">
                    <svg class="w-3.5 h-3.5"><use href="#icon-smartphone"/></svg>
                    <span>Mobile (SE)</span>
                </button>
                <button type="button" onclick="selectDevice('android')" data-device="android" 
                        class="device-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all text-slate-600 hover:text-slate-900">
                    <svg class="w-3.5 h-3.5"><use href="#icon-smartphone"/></svg>
                    <span>Galaxy S23</span>
                </button>
                <button type="button" onclick="selectDevice('ipadmini')" data-device="ipadmini" 
                        class="device-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all text-slate-600 hover:text-slate-900">
                    <svg class="w-3.5 h-3.5"><use href="#icon-tablet"/></svg>
                    <span>iPad Mini</span>
                </button>
                <button type="button" onclick="selectDevice('ipadpro')" data-device="ipadpro" 
                        class="device-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all text-slate-600 hover:text-slate-900">
                    <svg class="w-3.5 h-3.5"><use href="#icon-tablet"/></svg>
                    <span>iPad Pro</span>
                </button>
                <button type="button" onclick="selectDevice('laptop')" data-device="laptop" 
                        class="device-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all text-slate-600 hover:text-slate-900">
                    <svg class="w-3.5 h-3.5"><use href="#icon-laptop"/></svg>
                    <span>Laptop</span>
                </button>
                <button type="button" onclick="selectDevice('custom')" data-device="custom" 
                        class="device-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all text-slate-600 hover:text-slate-900">
                    <span>Tùy chỉnh</span>
                </button>
            </div>

            <!-- Nhóm công cụ: Xoay, Khung máy, Tỉ lệ thu phóng -->
            <div class="flex items-center gap-2">
                <!-- Nút Xoay màn hình -->
                <button type="button" id="btn-rotate" onclick="toggleOrientation()" title="Xoay dọc/ngang (Phím tắt: R)"
                        class="flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold bg-white border border-slate-200 text-slate-700 hover:bg-slate-50 hover:text-primary transition-colors shadow-sm">
                    <svg class="w-3.5 h-3.5 text-primary"><use href="#icon-rotate"/></svg>
                    <span id="text-orientation">Dọc (Portrait)</span>
                </button>

                <!-- Bật/Tắt Khung Viền Thiết bị -->
                <button type="button" id="btn-toggle-frame" onclick="toggleMockupFrame()" title="Bật/Tắt viền máy (Phím tắt: F)"
                        class="flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold bg-white border border-slate-200 text-slate-700 hover:bg-slate-50 transition-colors shadow-sm">
                    <span class="w-2 h-2 rounded-full bg-primary" id="indicator-frame"></span>
                    <span>Khung viền máy</span>
                </button>

                <!-- Tỉ lệ thu phóng (Scale / Zoom) -->
                <div class="flex items-center gap-1 bg-white border border-slate-200 rounded-lg px-2 py-1 shadow-sm">
                    <span class="text-[11px] font-semibold text-slate-500">Zoom:</span>
                    <select id="select-zoom" onchange="changeZoom(this.value)" class="text-xs font-bold text-slate-700 bg-transparent border-none py-0 pl-1 pr-5 focus:ring-0 cursor-pointer">
                        <option value="fit" selected>Auto Fit (Vừa màn)</option>
                        <option value="1">100% (Thực tế)</option>
                        <option value="0.85">85%</option>
                        <option value="0.75">75%</option>
                        <option value="0.67">67%</option>
                        <option value="0.5">50%</option>
                    </select>
                </div>

                <!-- Đổi tông màu Canvas (Dark/Light) -->
                <button type="button" onclick="toggleCanvasTheme()" title="Đổi màu nền làm việc Studio"
                        class="p-1.5 rounded-lg border border-slate-200 bg-white text-slate-600 hover:text-slate-900 transition-colors shadow-sm">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"></path>
                    </svg>
                </button>
            </div>
        </div>

        <!-- Hàng 2: Điều hướng URL, kích thước chi tiết và chọn trang mẫu -->
        <div class="px-5 py-2 flex flex-wrap items-center justify-between gap-3 bg-slate-50/70">
            
            <!-- Ô nhập URL & Nút thao tác -->
            <div class="flex-1 flex items-center gap-2 max-w-3xl">
                <!-- Dropdown chọn trang nhanh -->
                <select id="select-page" onchange="navigateToPreset(this.value)" 
                        class="text-xs font-semibold bg-white border border-slate-300 rounded-lg py-1.5 px-2.5 text-slate-700 shadow-sm focus:border-primary focus:ring-primary">
                    <c:forEach var="pageItem" items="${samplePages}">
                        <option value="${pageItem.path}" ${pageItem.path == initialPath ? 'selected' : ''}>
                            <c:out value="${pageItem.name}"/>
                        </option>
                    </c:forEach>
                </select>

                <!-- Input đường dẫn URL -->
                <div class="flex-1 relative flex items-center">
                    <span class="absolute left-3 text-xs text-slate-400 font-mono select-none">
                        ${pageContext.request.contextPath}
                    </span>
                    <input type="text" id="input-url" value="${initialPath}" 
                           onkeydown="if(event.key==='Enter') navigateToUrl(this.value)"
                           placeholder="/home, /shop, /cart..."
                           class="w-full text-xs font-mono font-medium pl-28 pr-20 py-1.5 bg-white border border-slate-300 rounded-lg text-slate-800 shadow-sm focus:border-primary focus:ring-primary"/>
                    
                    <button type="button" onclick="navigateToUrl(document.getElementById('input-url').value)"
                            class="absolute right-1.5 bg-primary hover:bg-primary-container text-white text-[11px] font-bold px-2.5 py-0.5 rounded transition-colors shadow-sm">
                        Đi tới
                    </button>
                </div>

                <!-- Nút Reload -->
                <button type="button" onclick="reloadIframe()" title="Làm mới nội dung trang"
                        class="p-1.5 rounded-lg border border-slate-300 bg-white text-slate-600 hover:text-primary transition-colors shadow-sm">
                    <svg class="w-4 h-4"><use href="#icon-refresh-cw"/></svg>
                </button>

                <!-- Nút Mở Tab Mới -->
                <button type="button" onclick="openInNewTab()" title="Mở đường dẫn này sang Tab mới"
                        class="p-1.5 rounded-lg border border-slate-300 bg-white text-slate-600 hover:text-primary transition-colors shadow-sm">
                    <svg class="w-4 h-4"><use href="#icon-external-link"/></svg>
                </button>
            </div>

            <!-- Thông số Kích thước Viewport (Width x Height) -->
            <div class="flex items-center gap-2 text-xs font-mono bg-white px-3 py-1.5 rounded-lg border border-slate-200 shadow-sm">
                <span class="text-slate-400">Viewport:</span>
                <span id="display-width" class="font-bold text-slate-800">393</span>
                <span class="text-slate-400">×</span>
                <span id="display-height" class="font-bold text-slate-800">852</span>
                <span class="text-slate-400 text-[10px]">px</span>
                
                <!-- Inputs tùy chỉnh kích thước khi ở chế độ custom -->
                <div id="custom-size-inputs" class="hidden items-center gap-1 border-l border-slate-200 pl-2 ml-1">
                    <input type="number" id="input-custom-w" value="393" min="280" max="2560" 
                           onchange="updateCustomSize()" class="w-16 text-xs p-0.5 border rounded text-center"/>
                    <span>×</span>
                    <input type="number" id="input-custom-h" value="852" min="300" max="2560" 
                           onchange="updateCustomSize()" class="w-16 text-xs p-0.5 border rounded text-center"/>
                </div>
            </div>

        </div>
    </header>

    <!-- WORKSPACE / STUDIO CANVAS -->
    <div id="canvas-container" class="preview-canvas flex-1 overflow-auto p-8 flex items-start justify-center transition-colors duration-200 select-none">
        
        <!-- WRAPPER CHO TRANSFORM SCALE -->
        <div id="scale-wrapper" class="transition-transform duration-200 origin-top flex flex-col items-center">
            
            <!-- DEVICE CONTAINER -->
            <div id="device-frame" class="relative transition-all duration-300">
                
                <!-- Nút bấm viền điện thoại (chỉ hiển thị khi bật mockup frame) -->
                <div id="frame-buttons" class="block">
                    <!-- Volume up & down -->
                    <div class="phone-button-volume top-24 h-12"></div>
                    <div class="phone-button-volume top-40 h-12"></div>
                    <!-- Power button -->
                    <div class="phone-button-power"></div>
                </div>

                <!-- NOTCH / DYNAMIC ISLAND -->
                <div id="device-notch" class="absolute top-2.5 left-1/2 -translate-x-1/2 w-28 h-6 bg-black rounded-full z-30 flex items-center justify-between px-3 pointer-events-none transition-all">
                    <!-- Camera lens & sensor indicator -->
                    <div class="w-2.5 h-2.5 rounded-full bg-slate-900 border border-slate-800"></div>
                    <div class="w-2 h-2 rounded-full bg-emerald-500/80 animate-pulse"></div>
                </div>

                <!-- BROWSER TOP BAR MINI (khi tắt khung điện thoại hoặc ở laptop) -->
                <div id="minimal-header" class="hidden bg-slate-800 text-slate-300 px-3 py-1.5 rounded-t-xl items-center justify-between border-b border-slate-700">
                    <div class="flex items-center gap-1.5">
                        <span class="w-2.5 h-2.5 rounded-full bg-red-500 inline-block"></span>
                        <span class="w-2.5 h-2.5 rounded-full bg-yellow-500 inline-block"></span>
                        <span class="w-2.5 h-2.5 rounded-full bg-green-500 inline-block"></span>
                    </div>
                    <span id="minimal-url-text" class="text-[10px] font-mono text-slate-400 truncate max-w-xs"></span>
                    <div class="w-8"></div>
                </div>

                <!-- KHUNG MÀN HÌNH CHÍNH (SCREEN BOX) -->
                <div id="screen-box" class="relative overflow-hidden bg-white shadow-2xl transition-all duration-300">
                    <!-- IFRAME TRANG WEB -->
                    <iframe id="preview-iframe" 
                            src="${pageContext.request.contextPath}${initialPath}" 
                            title="Device Preview" 
                            allow="geolocation; microphone; camera; payment">
                    </iframe>
                </div>

                <!-- HOME INDICATOR BAR (Đáy điện thoại) -->
                <div id="home-indicator" class="absolute bottom-2 left-1/2 -translate-x-1/2 w-32 h-1 bg-black/40 rounded-full z-30 pointer-events-none transition-all"></div>

            </div>

            <!-- CHÚ THÍCH PHÍA DƯỚI THIẾT BỊ -->
            <div class="mt-4 text-center">
                <p class="text-xs font-medium text-slate-400 tracking-wide" id="device-caption">
                    iPhone 15/14 • 393 × 852 px • Portrait
                </p>
                <p class="text-[11px] text-slate-500 mt-0.5">
                    Có thể click, cuộn và trải nghiệm đầy đủ các tính năng website như người dùng thật.
                </p>
            </div>

        </div>

    </div>

</main>

<script>
    // BẢNG DANH SÁCH THIẾT BỊ CÀI ĐẶT SẴN (PRESETS)
    const DEVICES = {
        iphone14: {
            name: "iPhone 15/14",
            width: 393,
            height: 852,
            type: "mobile",
            hasNotch: true,
            radius: "48px",
            innerRadius: "38px",
            padding: "12px",
            desc: "iPhone 15 / 14 (393 × 852 px)"
        },
        compact: {
            name: "Mobile SE / Compact",
            width: 375,
            height: 667,
            type: "mobile",
            hasNotch: false,
            radius: "40px",
            innerRadius: "30px",
            padding: "14px",
            desc: "iPhone SE / Mobile nhỏ (375 × 667 px)"
        },
        android: {
            name: "Samsung Galaxy S23",
            width: 412,
            height: 915,
            type: "mobile",
            hasNotch: true,
            radius: "42px",
            innerRadius: "32px",
            padding: "12px",
            desc: "Android Flagship (412 × 915 px)"
        },
        ipadmini: {
            name: "iPad Mini",
            width: 768,
            height: 1024,
            type: "tablet",
            hasNotch: false,
            radius: "30px",
            innerRadius: "20px",
            padding: "16px",
            desc: "iPad Mini 8.3\" (768 × 1024 px)"
        },
        ipadpro: {
            name: "iPad Pro 12.9\"",
            width: 1024,
            height: 1366,
            type: "tablet",
            hasNotch: false,
            radius: "28px",
            innerRadius: "18px",
            padding: "16px",
            desc: "iPad Pro Retina (1024 × 1366 px)"
        },
        laptop: {
            name: "Laptop Standard",
            width: 1280,
            height: 800,
            type: "desktop",
            hasNotch: false,
            radius: "16px",
            innerRadius: "10px",
            padding: "12px",
            desc: "Laptop Viewport (1280 × 800 px)"
        },
        custom: {
            name: "Tùy chỉnh (Custom)",
            width: 393,
            height: 852,
            type: "custom",
            hasNotch: false,
            radius: "16px",
            innerRadius: "10px",
            padding: "8px",
            desc: "Kích thước người dùng tự đặt"
        }
    };

    // TRẠNG THÁI HIỆN TẠI CỦA ỨNG DỤNG
    const state = {
        deviceKey: 'iphone14',
        isLandscape: false,
        hasMockup: true,
        zoom: 'fit',
        contextPath: '${pageContext.request.contextPath}',
        currentPath: '${initialPath}'
    };

    // HÀM CHỌN THIẾT BỊ
    function selectDevice(key) {
        state.deviceKey = key;
        
        // Cập nhật giao diện nút chọn thiết bị
        document.querySelectorAll('#device-selector-group .device-btn').forEach(btn => {
            if (btn.getAttribute('data-device') === key) {
                btn.className = "device-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all bg-white text-primary shadow-sm";
            } else {
                btn.className = "device-btn flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all text-slate-600 hover:text-slate-900";
            }
        });

        // Ẩn/hiện ô nhập custom
        const customInputs = document.getElementById('custom-size-inputs');
        if (key === 'custom') {
            customInputs.classList.remove('hidden');
            customInputs.classList.add('flex');
        } else {
            customInputs.classList.remove('flex');
            customInputs.classList.add('hidden');
        }

        applyDeviceLayout();
    }

    // HÀM XOAY HƯỚNG MÀN HÌNH (PORTRAIT / LANDSCAPE)
    function toggleOrientation() {
        state.isLandscape = !state.isLandscape;
        
        const btnText = document.getElementById('text-orientation');
        if (state.isLandscape) {
            btnText.textContent = "Ngang (Landscape)";
        } else {
            btnText.textContent = "Dọc (Portrait)";
        }
        
        applyDeviceLayout();
    }

    // HÀM BẬT/TẮT KHUNG VIỀN MÁY (MOCKUP FRAME)
    function toggleMockupFrame() {
        state.hasMockup = !state.hasMockup;
        const indicator = document.getElementById('indicator-frame');
        
        if (state.hasMockup) {
            indicator.className = "w-2 h-2 rounded-full bg-primary";
        } else {
            indicator.className = "w-2 h-2 rounded-full bg-slate-300";
        }
        
        applyDeviceLayout();
    }

    // HÀM ĐỔI MỨC THU PHÓNG (ZOOM)
    function changeZoom(value) {
        state.zoom = value;
        applyScale();
    }

    // HÀM ĐỔI GIAO DIỆN NỀN CANVAS (DARK / LIGHT)
    function toggleCanvasTheme() {
        const canvas = document.getElementById('canvas-container');
        canvas.classList.toggle('light-canvas');
    }

    // CẬP NHẬT KÍCH THƯỚC CUSTOM DO NGƯỜI DÙNG NHẬP
    function updateCustomSize() {
        const w = parseInt(document.getElementById('input-custom-w').value) || 393;
        const h = parseInt(document.getElementById('input-custom-h').value) || 852;
        DEVICES.custom.width = w;
        DEVICES.custom.height = h;
        applyDeviceLayout();
    }

    // TÍNH TOÁN VÀ ÁP DỤNG THIẾT BỊ VÀO KHUNG CANVAS
    function applyDeviceLayout() {
        const device = DEVICES[state.deviceKey];
        let w = device.width;
        let h = device.height;

        // Nếu xoay ngang, hoán đổi chiều dài và rộng
        if (state.isLandscape) {
            const temp = w;
            w = h;
            h = temp;
        }

        // Cập nhật số liệu hiển thị
        document.getElementById('display-width').textContent = w;
        document.getElementById('display-height').textContent = h;

        // Cập nhật Breakpoint Badge
        updateBreakpointBadge(w);

        // Các phần tử DOM cần tinh chỉnh
        const deviceFrame = document.getElementById('device-frame');
        const screenBox = document.getElementById('screen-box');
        const notch = document.getElementById('device-notch');
        const homeBar = document.getElementById('home-indicator');
        const frameButtons = document.getElementById('frame-buttons');
        const minimalHeader = document.getElementById('minimal-header');
        const caption = document.getElementById('device-caption');

        caption.textContent = device.name + " • " + w + " × " + h + " px • " + (state.isLandscape ? "Landscape" : "Portrait");

        // Đặt kích thước màn hình
        screenBox.style.width = w + "px";
        screenBox.style.height = h + "px";

        if (state.hasMockup && device.type !== 'desktop' && state.deviceKey !== 'custom') {
            // Hiển thị khung viền chuẩn điện thoại / tablet chân thực
            deviceFrame.style.padding = device.padding;
            deviceFrame.style.borderRadius = device.radius;
            deviceFrame.className = "relative transition-all duration-300 bg-slate-950 shadow-2xl ring-1 ring-slate-800 ring-offset-4 ring-offset-slate-950";
            
            screenBox.style.borderRadius = device.innerRadius;
            
            // Notch / Dynamic Island
            if (device.hasNotch && !state.isLandscape) {
                notch.classList.remove('hidden');
                notch.classList.add('flex');
            } else {
                notch.classList.remove('flex');
                notch.classList.add('hidden');
            }

            // Home bar
            if (device.type === 'mobile' && !state.isLandscape) {
                homeBar.classList.remove('hidden');
            } else {
                homeBar.classList.add('hidden');
            }

            // Nút viền điện thoại
            if (device.type === 'mobile' && !state.isLandscape) {
                frameButtons.classList.remove('hidden');
            } else {
                frameButtons.classList.add('hidden');
            }

            minimalHeader.classList.remove('flex');
            minimalHeader.classList.add('hidden');

        } else {
            // Chế độ viền tối giản (Minimal Clean Frame)
            deviceFrame.style.padding = "0px";
            deviceFrame.style.borderRadius = "12px";
            deviceFrame.className = "relative transition-all duration-300 shadow-2xl rounded-xl ring-1 ring-slate-700/50 bg-slate-800";
            
            screenBox.style.borderRadius = "0 0 12px 12px";
            
            notch.classList.remove('flex');
            notch.classList.add('hidden');
            homeBar.classList.add('hidden');
            frameButtons.classList.add('hidden');

            minimalHeader.classList.remove('hidden');
            minimalHeader.classList.add('flex');
            minimalHeader.style.width = w + "px";
            document.getElementById('minimal-url-text').textContent = state.contextPath + state.currentPath;
        }

        // Tự động căn chỉnh Scale / Zoom
        applyScale();
    }

    // TÍNH TOÁN SCALE PHÙ HỢP
    function applyScale() {
        const scaleWrapper = document.getElementById('scale-wrapper');
        const canvas = document.getElementById('canvas-container');
        const deviceFrame = document.getElementById('device-frame');

        if (state.zoom === 'fit') {
            // Lấy không gian khả dụng của canvas
            const availWidth = canvas.clientWidth - 80;
            const availHeight = canvas.clientHeight - 100;

            const frameWidth = deviceFrame.offsetWidth || 420;
            const frameHeight = deviceFrame.offsetHeight || 880;

            let scale = Math.min(availWidth / frameWidth, availHeight / frameHeight);
            if (scale > 1) scale = 1; // Không phóng to hơn 100% nếu thừa chỗ
            if (scale < 0.3) scale = 0.3; // Giới hạn nhỏ nhất

            scaleWrapper.style.transform = "scale(" + scale.toFixed(3) + ")";
        } else {
            const scale = parseFloat(state.zoom) || 1;
            scaleWrapper.style.transform = "scale(" + scale + ")";
        }
    }

    // CẬP NHẬT BREAKPOINT BADGE THEO WIDTH
    function updateBreakpointBadge(w) {
        const badge = document.getElementById('badge-breakpoint');
        if (w < 576) {
            badge.className = "px-2 py-0.5 text-xs font-bold rounded-full bg-emerald-100 text-emerald-800";
            badge.textContent = "XS (<576px - Mobile)";
        } else if (w < 768) {
            badge.className = "px-2 py-0.5 text-xs font-bold rounded-full bg-blue-100 text-blue-800";
            badge.textContent = "SM (576-767px - Mobile lớn)";
        } else if (w < 992) {
            badge.className = "px-2 py-0.5 text-xs font-bold rounded-full bg-purple-100 text-purple-800";
            badge.textContent = "MD (768-991px - Tablet)";
        } else if (w < 1200) {
            badge.className = "px-2 py-0.5 text-xs font-bold rounded-full bg-amber-100 text-amber-800";
            badge.textContent = "LG (992-1199px - Laptop)";
        } else {
            badge.className = "px-2 py-0.5 text-xs font-bold rounded-full bg-rose-100 text-rose-800";
            badge.textContent = "XL (≥1200px - Desktop)";
        }
    }

    // ĐIỀU HƯỚNG SANG TRANG CHỌN TỪ PRESET
    function navigateToPreset(path) {
        document.getElementById('input-url').value = path;
        navigateToUrl(path);
    }

    // ĐIỀU HƯỚNG TRANG WEB TRONG IFRAME
    function navigateToUrl(rawPath) {
        if (!rawPath) return;
        let cleanPath = rawPath.trim();
        
        // Chuẩn hóa đường dẫn: nếu người dùng gõ /home hoặc home
        if (!cleanPath.startsWith('/') && !cleanPath.startsWith('http')) {
            cleanPath = '/' + cleanPath;
        }

        state.currentPath = cleanPath;
        const fullUrl = cleanPath.startsWith('http') ? cleanPath : (state.contextPath + cleanPath);
        
        const iframe = document.getElementById('preview-iframe');
        iframe.src = fullUrl;

        // Cập nhật minimal header
        document.getElementById('minimal-url-text').textContent = fullUrl;

        // Đồng bộ với dropdown nếu có khớp
        const selectPage = document.getElementById('select-page');
        for (let i = 0; i < selectPage.options.length; i++) {
            if (selectPage.options[i].value === cleanPath) {
                selectPage.selectedIndex = i;
                break;
            }
        }
    }

    // LÀM MỚI TRANG TRONG IFRAME
    function reloadIframe() {
        const iframe = document.getElementById('preview-iframe');
        iframe.src = iframe.src;
    }

    // MỞ ĐƯỜNG DẪN HIỆN TẠI SANG TAB TRÌNH DUYỆT MỚI
    function openInNewTab() {
        const fullUrl = state.currentPath.startsWith('http') ? state.currentPath : (state.contextPath + state.currentPath);
        window.open(fullUrl, '_blank');
    }

    // LẮNG NGHE PHÍM TẮT TIỆN ÍCH
    window.addEventListener('keydown', function(e) {
        // Nếu người dùng đang gõ vào input hoặc select thì bỏ qua
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT' || e.target.tagName === 'TEXTAREA') {
            return;
        }
        if (e.key === 'r' || e.key === 'R') {
            toggleOrientation();
        } else if (e.key === 'f' || e.key === 'F') {
            toggleMockupFrame();
        }
    });

    // LẮNG NGHE RESIZE CỬA SỔ ĐỂ TÍNH LẠI AUTO FIT
    window.addEventListener('resize', function() {
        if (state.zoom === 'fit') {
            applyScale();
        }
    });

    // KHỞI ĐỘNG BAN ĐẦU
    document.addEventListener('DOMContentLoaded', function() {
        applyDeviceLayout();
    });
</script>

</body>
</html>
