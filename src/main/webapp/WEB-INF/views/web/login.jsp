<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Đăng nhập - Fruitables</title>

    <!-- Nhúng CSS tùy chỉnh -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">

    <!-- Nhúng Tailwind CSS CDN & Cấu hình -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>

<body class="min-h-screen flex flex-col bg-background text-on-background">

<!-- NAVBAR CHUNG -->
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<!-- Main Content: Split Screen Login -->
<main class="flex-grow flex items-center justify-center p-margin-mobile md:p-margin-desktop">
    <div class="bg-surface rounded-xl shadow-[0px_4px_20px_rgba(0,0,0,0.05)] overflow-hidden flex flex-col md:flex-row w-full max-w-5xl">

        <!-- Left Side: Image -->
        <div class="md:w-1/2 relative min-h-[400px] md:min-h-full hidden md:block">
            <div class="bg-cover bg-center w-full h-full absolute inset-0" style="background-image: url('https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=2070&auto=format&fit=crop');"></div>
            <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent flex flex-col justify-end p-8">
                <h2 class="font-display-lg text-display-lg font-extrabold text-white mb-2">Chào mừng trở lại với sự tươi mới!</h2>
                <p class="font-body-lg text-body-lg text-white/90">Đăng nhập để tiếp tục khám phá những sản phẩm hữu cơ tốt nhất.</p>
            </div>
        </div>

        <!-- Right Side: Login Form -->
        <div class="md:w-1/2 p-8 md:p-12 flex flex-col justify-center bg-surface-container-lowest">
            <div class="text-center md:text-left mb-8 block md:hidden">
                <h2 class="font-headline-md text-headline-md text-on-surface mb-2">Chào mừng trở lại!</h2>
                <p class="font-body-md text-body-md text-on-surface-variant">Đăng nhập để tiếp tục</p>
            </div>

            <!-- KHỐI HIỂN THỊ THÔNG BÁO ĐĂNG KÝ THÀNH CÔNG TỪ SESSION -->
            <c:if test="${not empty sessionScope.successMsg}">
                <div class="bg-secondary-container text-on-secondary-container p-3 rounded-md mb-6 font-body-md flex items-center shadow-sm">
                    <span class="material-symbols-outlined mr-2">check_circle</span>
                    <c:out value="${sessionScope.successMsg}"/>
                </div>
                <c:remove var="successMsg" scope="session" />
            </c:if>

            <!-- KHỐI HIỂN THỊ THÔNG BÁO LỖI TỪ SERVLET (JSTL) -->
            <c:if test="${not empty message}">
                <div class="bg-error-container text-error p-3 rounded-md mb-6 font-body-md flex items-center shadow-sm">
                    <span class="material-symbols-outlined mr-2">error</span>
                    <c:out value="${message}"/>
                </div>
            </c:if>

            <!-- BẮT ĐẦU FORM XỬ LÝ ĐĂNG NHẬP (HỖ TRỢ USERNAME / SĐT / EMAIL) -->
            <form action="${pageContext.request.contextPath}/login" method="POST" class="space-y-6">
                <div>
                    <label class="block font-label-bold text-label-bold text-on-surface mb-1" for="identifier">Tài khoản</label>
                    <input class="w-full rounded-md border border-outline-variant bg-surface-container-lowest text-on-surface font-body-md text-body-md focus:border-primary-container focus:ring-primary-container focus:ring-1 transition-colors px-4 py-3"
                           id="identifier" name="identifier" placeholder="Tên đăng nhập, SĐT hoặc Email" type="text" required />
                </div>
                <div>
                    <div class="flex justify-between items-center mb-1">
                        <label class="block font-label-bold text-label-bold text-on-surface" for="password">Mật khẩu</label>
                        <a class="font-body-md text-body-md text-primary hover:underline text-sm" href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
                    </div>
                    <div class="relative">
                        <input class="w-full rounded-md border border-outline-variant bg-surface-container-lowest text-on-surface font-body-md text-body-md focus:border-primary-container focus:ring-primary-container focus:ring-1 transition-colors px-4 py-3"
                               id="password" name="password" placeholder="••••••••" type="password" required />
                        <button id="togglePassword" class="absolute right-3 top-1/2 transform -translate-y-1/2 text-on-surface-variant hover:text-primary transition-colors" type="button">
                            <span class="material-symbols-outlined text-lg" id="toggleIcon">visibility_off</span>
                        </button>
                    </div>
                </div>
                <div class="flex items-center">
                    <input class="rounded text-primary-container focus:ring-primary-container border-outline-variant bg-surface-container-lowest w-5 h-5 transition-colors cursor-pointer"
                           id="remember" name="remember" type="checkbox"/>
                    <label class="ml-2 font-body-md text-body-md text-on-surface cursor-pointer" for="remember">Ghi nhớ đăng nhập</label>
                </div>
                <button class="w-full bg-primary-container text-white font-label-bold text-label-bold py-3 rounded-full hover:bg-primary transition-colors shadow-[0px_4px_20px_rgba(129,196,8,0.15)] hover:-translate-y-1 transform duration-200" type="submit">
                    Đăng nhập
                </button>
            </form>

            <!-- Dải phân cách mạng xã hội (Giữ nguyên gốc) -->
            <div class="mt-8">
                <div class="relative">
                    <div class="absolute inset-0 flex items-center">
                        <div class="w-full border-t border-outline-variant"></div>
                    </div>
                    <div class="relative flex justify-center text-sm">
                        <span class="px-2 bg-surface-container-lowest text-on-surface-variant font-body-md">Hoặc tiếp tục với</span>
                    </div>
                </div>
                <div class="mt-6 grid grid-cols-2 gap-4">
                    <button class="flex items-center justify-center px-4 py-2 border border-outline-variant rounded-md hover:bg-surface-container-low transition-colors text-on-surface font-label-bold text-label-bold">
                        <svg class="h-5 w-5 mr-2" fill="currentColor" viewBox="0 0 24 24"><path d="M12.545,10.239v3.821h5.445c-0.712,2.315-2.647,3.972-5.445,3.972c-3.332,0-6.033-2.701-6.033-6.032s2.701-6.032,6.033-6.032c1.498,0,2.866,0.549,3.921,1.453l2.814-2.814C17.503,2.988,15.139,2,12.545,2C7.021,2,2.543,6.477,2.543,12s4.478,10,10.002,10c8.396,0,10.249-7.85,9.426-11.748L12.545,10.239z"></path></svg>
                        Google
                    </button>
                    <button class="flex items-center justify-center px-4 py-2 border border-outline-variant rounded-md hover:bg-surface-container-low transition-colors text-on-surface font-label-bold text-label-bold">
                        <svg class="h-5 w-5 mr-2 text-[#1877F2]" fill="currentColor" viewBox="0 0 24 24"><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.469h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.469h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"></path></svg>
                        Facebook
                    </button>
                </div>
            </div>

            <p class="mt-8 text-center font-body-md text-body-md text-on-surface-variant">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" class="text-primary hover:underline font-label-bold">Đăng ký ngay</a>
            </p>
        </div>
    </div>
</main>

<!-- FOOTER CHUNG -->
<jsp:include page="/WEB-INF/views/components/footer.jsp" />

<!-- Script nhỏ xử lý việc Ẩn/Hiện mật khẩu -->
<script>
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#password');
    const toggleIcon = document.querySelector('#toggleIcon');

    togglePassword.addEventListener('click', function (e) {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        toggleIcon.textContent = type === 'password' ? 'visibility_off' : 'visibility';
    });
</script>
</body>
</html>