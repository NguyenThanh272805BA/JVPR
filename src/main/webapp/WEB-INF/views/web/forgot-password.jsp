<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Quên mật khẩu - Fruitables</title>

    <!-- Nhúng CSS tùy chỉnh -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">

    <!-- Nhúng Tailwind CSS CDN & Cấu hình -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
</head>

<body class="min-h-screen flex flex-col bg-background text-on-background">

<!-- NAVBAR CHUNG -->
<jsp:include page="/WEB-INF/views/components/navbar.jsp" />

<!-- Main Content -->
<main class="flex-grow flex items-center justify-center p-margin-mobile md:p-margin-desktop py-12">
    <div class="bg-surface rounded-2xl shadow-[0px_8px_30px_rgba(0,0,0,0.06)] overflow-hidden flex flex-col md:flex-row w-full max-w-4xl border border-outline-variant/60">

        <!-- Cột trái: Hình ảnh & Thông điệp -->
        <div class="md:w-5/12 relative min-h-[300px] md:min-h-full hidden md:block">
            <div class="bg-cover bg-center w-full h-full absolute inset-0" style="background-image: url('https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1974&auto=format&fit=crop');"></div>
            <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/40 to-transparent flex flex-col justify-end p-8">
                <span class="inline-block w-fit py-1 px-3 rounded-full bg-primary/25 text-white border border-primary/40 font-label-bold text-xs uppercase mb-3 backdrop-blur-sm">
                    Bảo mật tài khoản
                </span>
                <h2 class="font-display-lg text-2xl font-extrabold text-white mb-2 leading-snug">Khôi phục quyền truy cập dễ dàng</h2>
                <p class="font-body-md text-white/80 text-sm leading-relaxed">Chúng tôi sẽ gửi một mã OTP gồm 6 chữ số đến Gmail của bạn để xác thực danh tính.</p>
            </div>
        </div>

        <!-- Cột phải: Form nhập Email -->
        <div class="md:w-7/12 p-8 md:p-12 flex flex-col justify-center bg-surface-container-lowest">
            <div class="mb-8">
                <div class="w-12 h-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center mb-4">
                    <span class="material-symbols-outlined text-2xl">lock_reset</span>
                </div>
                <h2 class="font-headline-md text-2xl font-extrabold text-on-surface mb-2">Quên mật khẩu?</h2>
                <p class="font-body-md text-sm text-on-surface-variant leading-relaxed">
                    Đừng lo lắng! Hãy nhập địa chỉ email liên kết với tài khoản Fruitables của bạn, chúng tôi sẽ gửi mã xác minh ngay lập tức.
                </p>
            </div>

            <!-- THÔNG BÁO LỖI (NẾU CÓ) -->
            <c:if test="${not empty message}">
                <div class="bg-error-container/20 border border-error-container text-error p-3.5 rounded-xl mb-6 font-body-md text-sm flex items-center gap-2.5 shadow-sm animate-shake">
                    <span class="material-symbols-outlined text-[20px] flex-shrink-0">error</span>
                    <span><c:out value="${message}"/></span>
                </div>
            </c:if>

            <!-- FORM GỬI OTP -->
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST" class="space-y-6">
                <div>
                    <label class="block font-label-bold text-sm text-on-surface mb-2" for="email">
                        Địa chỉ Email đăng ký <span class="text-error">*</span>
                    </label>
                    <div class="relative">
                        <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant text-[20px]">mail</span>
                        <input class="w-full rounded-xl border border-outline-variant bg-surface-container-lowest text-on-surface font-body-md text-sm focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all pl-11 pr-4 py-3.5 outline-none"
                               id="email" name="email" placeholder="example@gmail.com" type="email" required />
                    </div>
                    <span class="text-xs text-on-surface-variant mt-1.5 block">Hệ thống sẽ gửi mã xác minh 6 số tới địa chỉ này.</span>
                </div>

                <button class="w-full bg-primary text-white font-label-bold text-sm py-3.5 rounded-full hover:bg-primary-container transition-all shadow-[0_4px_16px_rgba(129,196,8,0.35)] hover:-translate-y-0.5 active:translate-y-0 flex items-center justify-center gap-2 group" type="submit">
                    <span>Gửi mã xác nhận OTP</span>
                    <span class="material-symbols-outlined text-[18px] group-hover:translate-x-1 transition-transform">arrow_forward</span>
                </button>
            </form>

            <div class="mt-8 pt-6 border-t border-surface-variant/60 text-center">
                <a href="${pageContext.request.contextPath}/login" class="inline-flex items-center gap-1.5 text-sm font-label-bold text-primary hover:underline transition-colors">
                    <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                    <span>Quay lại trang Đăng nhập</span>
                </a>
            </div>
        </div>
    </div>
</main>

<!-- FOOTER CHUNG -->
<jsp:include page="/WEB-INF/views/components/footer.jsp" />

</body>
</html>
