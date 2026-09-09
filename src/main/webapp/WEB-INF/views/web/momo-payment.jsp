<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Thanh toán qua Ví MoMo | Fruitables</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Material Symbols Icons -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['"Plus Jakarta Sans"', 'sans-serif'],
                    },
                    colors: {
                        momo: {
                            50: '#fdf2f8',
                            100: '#fce7f3',
                            500: '#ec4899',
                            600: '#d82d8b',
                            700: '#a50064',
                            800: '#83004f',
                            900: '#5c0037'
                        }
                    }
                }
            }
        }
    </script>
    <style>
        @keyframes pulse-glow {
            0%, 100% { box-shadow: 0 0 15px rgba(216, 45, 139, 0.2); }
            50% { box-shadow: 0 0 30px rgba(216, 45, 139, 0.45); }
        }
        .qr-glow {
            animation: pulse-glow 3s infinite ease-in-out;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-pink-50 via-slate-50 to-purple-50 min-h-screen text-slate-800 font-sans antialiased py-8 px-4 flex items-center justify-center">

    <!-- Toast Thông báo copy -->
    <div id="copyToast" class="fixed top-6 right-6 z-50 transform translate-y-[-100px] opacity-0 transition-all duration-300 bg-slate-900 text-white px-5 py-3 rounded-xl shadow-2xl flex items-center gap-3 text-sm font-medium">
        <span class="material-symbols-outlined text-green-400 text-lg">check_circle</span>
        <span>Đã sao chép vào bộ nhớ tạm!</span>
    </div>

    <div class="max-w-4xl w-full bg-white rounded-3xl shadow-xl border border-pink-100 overflow-hidden">
        <!-- Header MoMo Branded -->
        <header class="bg-gradient-to-r from-momo-700 via-momo-600 to-pink-600 text-white px-6 py-5 sm:px-8 flex flex-wrap items-center justify-between gap-4 shadow-md">
            <div class="flex items-center gap-3">
                <div class="w-12 h-12 bg-white rounded-2xl p-1.5 shadow-md flex items-center justify-center flex-shrink-0">
                    <!-- MoMo Official Icon SVG -->
                    <svg viewBox="0 0 40 40" class="w-full h-full" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect width="40" height="40" rx="8" fill="#A50064"/>
                        <circle cx="20" cy="20" r="14" fill="#FFFFFF"/>
                        <path d="M14 18C14 14.6863 16.6863 12 20 12C23.3137 12 26 14.6863 26 18V22C26 25.3137 23.3137 28 20 28C16.6863 28 14 25.3137 14 22V18Z" fill="#A50064"/>
                        <circle cx="17.5" cy="18" r="2" fill="#FFFFFF"/>
                        <circle cx="22.5" cy="18" r="2" fill="#FFFFFF"/>
                        <path d="M17 22C17.8 23.2 22.2 23.2 23 22" stroke="#FFFFFF" stroke-width="1.8" stroke-linecap="round"/>
                    </svg>
                </div>
                <div>
                    <h1 class="text-xl font-extrabold tracking-tight">CỔNG THANH TOÁN VÍ MOMO</h1>
                    <p class="text-pink-100 text-xs sm:text-sm font-medium">Hệ thống phân phối nông sản cao cấp Fruitables</p>
                </div>
            </div>

            <!-- Đồng hồ đếm ngược -->
            <div class="flex items-center gap-2 bg-white/15 backdrop-blur-md px-4 py-2 rounded-2xl border border-white/20">
                <span class="material-symbols-outlined text-pink-200 text-lg animate-spin" style="animation-duration: 4s;">schedule</span>
                <div class="text-right">
                    <div class="text-[11px] uppercase tracking-wider text-pink-100 font-semibold">Thời gian còn lại</div>
                    <div id="timer" class="font-mono font-extrabold text-lg text-white">15:00</div>
                </div>
            </div>
        </header>

        <!-- Main Body -->
        <main class="p-6 sm:p-8 grid grid-cols-1 lg:grid-cols-12 gap-8">
            <!-- Cột trái: Khung Mã QR MoMo Động -->
            <section class="lg:col-span-5 flex flex-col items-center justify-between border-b lg:border-b-0 lg:border-r border-slate-100 pb-8 lg:pb-0 lg:pr-8">
                <div class="w-full text-center">
                    <span class="inline-flex items-center gap-1.5 text-xs font-bold text-momo-700 bg-momo-50 border border-momo-100 px-3 py-1 rounded-full mb-3">
                        <span class="w-2 h-2 rounded-full bg-momo-600 animate-ping"></span>
                        Mã QR Quét Tự Động
                    </span>
                    <h2 class="text-slate-700 font-bold text-base">Mở ứng dụng MoMo để quét</h2>
                    <p class="text-slate-400 text-xs mt-1">Hệ thống tự động điền sẵn số tiền & nội dung</p>
                </div>

                <!-- Khung viền QR sang trọng -->
                <div class="relative my-5 p-4 bg-white rounded-3xl border-2 border-dashed border-momo-200 qr-glow shadow-sm">
                    <img id="qrImage" src="${qrImageUrl}" alt="Mã QR Thanh toán MoMo" class="w-60 h-60 object-contain rounded-2xl">
                    <!-- Logo MoMo mini đóng dấu giữa mã QR -->
                    <div class="absolute inset-0 flex items-center justify-center pointer-events-none">
                        <div class="w-11 h-11 bg-white p-1 rounded-xl shadow-lg border border-pink-100 flex items-center justify-center">
                            <svg viewBox="0 0 40 40" class="w-full h-full" fill="none">
                                <rect width="40" height="40" rx="8" fill="#A50064"/>
                                <circle cx="20" cy="20" r="14" fill="#FFFFFF"/>
                                <circle cx="17.5" cy="18" r="2" fill="#A50064"/>
                                <circle cx="22.5" cy="18" r="2" fill="#A50064"/>
                                <path d="M17 22C17.8 23.2 22.2 23.2 23 22" stroke="#A50064" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Nút mở App MoMo trên thiết bị di động -->
                <div class="w-full space-y-2">
                    <a href="https://me.momo.vn/${phoneNumber}" target="_blank" class="w-full inline-flex items-center justify-center gap-2 bg-momo-50 hover:bg-momo-100 text-momo-700 font-bold py-2.5 px-4 rounded-xl text-xs transition-colors border border-momo-200">
                        <span class="material-symbols-outlined text-sm">phone_iphone</span>
                        Mở App MoMo trên điện thoại
                    </a>
                    <p class="text-center text-[11px] text-slate-400">
                        Đang chờ quý khách chuyển tiền...
                    </p>
                </div>
            </section>

            <!-- Cột phải: Thông tin giao dịch chi tiết -->
            <section class="lg:col-span-7 flex flex-col justify-between space-y-6">
                <!-- Box Tổng tiền -->
                <div class="bg-gradient-to-br from-pink-50/70 to-slate-50 p-5 rounded-2xl border border-pink-100">
                    <div class="flex items-center justify-between mb-1">
                        <span class="text-xs uppercase font-bold text-slate-500 tracking-wider">Tổng tiền thanh toán</span>
                        <span class="text-xs font-semibold px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-700">Chờ thanh toán</span>
                    </div>
                    <div class="flex items-baseline justify-between">
                        <div class="text-3xl font-extrabold text-momo-700 tracking-tight">
                            <fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true"/>
                            <span class="text-lg font-bold text-slate-500">VNĐ</span>
                        </div>
                        <button type="button" onclick="copyText('${roundedAmount}', 'Số tiền')" class="text-xs font-semibold text-momo-600 hover:text-momo-800 flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm">content_copy</span> Sao chép
                        </button>
                    </div>
                </div>

                <!-- Chi tiết tài khoản nhận tiền -->
                <div class="space-y-3">
                    <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wider">Thông tin người nhận ví MoMo</h3>

                    <!-- Tên người nhận -->
                    <div class="flex items-center justify-between p-3.5 bg-slate-50 hover:bg-slate-100/70 rounded-xl border border-slate-200/80 transition-colors">
                        <div class="flex items-center gap-3">
                            <span class="material-symbols-outlined text-slate-400 text-xl">person</span>
                            <div>
                                <div class="text-[11px] text-slate-400 font-medium">Chủ tài khoản</div>
                                <div class="text-sm font-bold text-slate-800 uppercase">${accountName}</div>
                            </div>
                        </div>
                        <button type="button" onclick="copyText('${accountName}', 'Tên chủ tài khoản')" class="p-1.5 hover:bg-white rounded-lg text-slate-400 hover:text-slate-700 transition-colors" title="Sao chép tên">
                            <span class="material-symbols-outlined text-lg">content_copy</span>
                        </button>
                    </div>

                    <!-- Số điện thoại ví MoMo -->
                    <div class="flex items-center justify-between p-3.5 bg-slate-50 hover:bg-slate-100/70 rounded-xl border border-slate-200/80 transition-colors">
                        <div class="flex items-center gap-3">
                            <span class="material-symbols-outlined text-momo-600 text-xl">phone_android</span>
                            <div>
                                <div class="text-[11px] text-slate-400 font-medium">Số điện thoại / Ví MoMo</div>
                                <div class="text-base font-extrabold text-slate-900 tracking-wider">${phoneNumber}</div>
                            </div>
                        </div>
                        <button type="button" onclick="copyText('${phoneNumber}', 'Số điện thoại')" class="flex items-center gap-1 text-xs font-bold bg-white text-momo-700 hover:bg-momo-50 border border-momo-200 px-3 py-1.5 rounded-lg shadow-sm transition-colors">
                            <span class="material-symbols-outlined text-sm">content_copy</span> Sao chép
                        </button>
                    </div>

                    <!-- Lời nhắn / Nội dung chuyển khoản -->
                    <div class="flex items-center justify-between p-3.5 bg-pink-50/50 hover:bg-pink-50 rounded-xl border border-pink-200/80 transition-colors">
                        <div class="flex items-center gap-3">
                            <span class="material-symbols-outlined text-momo-700 text-xl">receipt_long</span>
                            <div>
                                <div class="text-[11px] text-momo-700 font-bold uppercase">Nội dung chuyển khoản (Bắt buộc)</div>
                                <div class="text-base font-mono font-extrabold text-momo-800">${orderCode}</div>
                            </div>
                        </div>
                        <button type="button" onclick="copyText('${orderCode}', 'Mã đơn hàng')" class="flex items-center gap-1 text-xs font-bold bg-momo-700 hover:bg-momo-800 text-white px-3 py-1.5 rounded-lg shadow-sm transition-colors">
                            <span class="material-symbols-outlined text-sm">content_copy</span> Sao chép
                        </button>
                    </div>
                </div>

                <!-- Cảnh báo lưu ý quan trọng -->
                <div class="bg-amber-50 border border-amber-200 rounded-xl p-3.5 flex items-start gap-3 text-xs text-amber-800">
                    <span class="material-symbols-outlined text-amber-600 text-lg flex-shrink-0 mt-0.5">info</span>
                    <div>
                        <span class="font-bold">Lưu ý quan trọng:</span> Quý khách vui lòng giữ nguyên nội dung chuyển khoản là mã <strong class="underline">${orderCode}</strong> để hệ thống tự động xác nhận đơn hàng nhanh nhất.
                    </div>
                </div>

                <!-- Các nút hành động -->
                <div class="space-y-2.5 pt-2">
                    <!-- Nút Đã chuyển tiền thành công -->
                    <form action="${pageContext.request.contextPath}/momo-return" method="POST">
                        <input type="hidden" name="orderCode" value="${orderCode}">
                        <input type="hidden" name="status" value="SUCCESS">
                        <button type="submit" class="w-full bg-gradient-to-r from-momo-700 to-pink-600 hover:from-momo-800 hover:to-pink-700 text-white font-bold py-3.5 px-6 rounded-xl shadow-lg shadow-pink-500/25 flex items-center justify-center gap-2 transition-all transform active:scale-[0.98]">
                            <span class="material-symbols-outlined text-xl">check_circle</span>
                            Tôi đã chuyển tiền thành công
                        </button>
                    </form>

                    <!-- Nút Hủy thanh toán -->
                    <form action="${pageContext.request.contextPath}/momo-return" method="POST">
                        <input type="hidden" name="orderCode" value="${orderCode}">
                        <input type="hidden" name="status" value="CANCEL">
                        <button type="submit" onclick="return confirm('Bạn có chắc chắn muốn hủy thanh toán cho đơn hàng này không?');" class="w-full bg-slate-100 hover:bg-slate-200 text-slate-600 font-semibold py-2.5 px-4 rounded-xl text-xs flex items-center justify-center gap-1.5 transition-colors">
                            <span class="material-symbols-outlined text-sm">close</span>
                            Hủy giao dịch & Quay lại
                        </button>
                    </form>
                </div>
            </section>
        </main>

        <!-- Footer -->
        <footer class="bg-slate-50 border-t border-slate-100 px-6 py-4 flex flex-wrap items-center justify-between gap-2 text-xs text-slate-400">
            <span>© 2026 Fruitables E-Commerce. All rights reserved.</span>
            <div class="flex items-center gap-1 text-slate-500">
                <span class="material-symbols-outlined text-emerald-500 text-sm">lock</span>
                <span>Kết nối mã hóa SSL 256-bit an toàn</span>
            </div>
        </footer>
    </div>

    <!-- Script xử lý đếm ngược và copy clipboard -->
    <script>
        // Hàm sao chép vào bộ nhớ tạm
        function copyText(text, label) {
            navigator.clipboard.writeText(text).then(function() {
                showToast("Đã sao chép " + label + ": " + text);
            }).catch(function(err) {
                // Fallback nếu browser chặn
                var textArea = document.createElement("textarea");
                textArea.value = text;
                document.body.appendChild(textArea);
                textArea.select();
                document.execCommand('copy');
                document.body.removeChild(textArea);
                showToast("Đã sao chép " + label + ": " + text);
            });
        }

        function showToast(message) {
            var toast = document.getElementById("copyToast");
            toast.querySelector("span:last-child").textContent = message;
            toast.classList.remove("translate-y-[-100px]", "opacity-0");
            toast.classList.add("translate-y-0", "opacity-100");

            setTimeout(function() {
                toast.classList.remove("translate-y-0", "opacity-100");
                toast.classList.add("translate-y-[-100px]", "opacity-0");
            }, 2500);
        }

        // Đếm ngược 15 phút (900 giây)
        var timeLeft = 15 * 60;
        var timerElement = document.getElementById("timer");

        var countdown = setInterval(function() {
            var minutes = Math.floor(timeLeft / 60);
            var seconds = timeLeft % 60;

            var minStr = minutes < 10 ? "0" + minutes : minutes;
            var secStr = seconds < 10 ? "0" + seconds : seconds;

            timerElement.textContent = minStr + ":" + secStr;

            if (timeLeft <= 0) {
                clearInterval(countdown);
                timerElement.textContent = "HẾT HẠN";
                timerElement.classList.add("text-red-300");
                alert("Đã hết thời gian thanh toán cho đơn hàng. Vui lòng thử lại!");
            }
            timeLeft--;
        }, 1000);
    </script>
</body>
</html>
