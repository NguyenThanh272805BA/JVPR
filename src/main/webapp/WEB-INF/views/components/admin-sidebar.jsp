<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Xác định URI hiện tại để highlight menu tương ứng chính xác 100% --%>
<c:set var="reqURI" value="${not empty requestScope['javax.servlet.forward.request_uri'] ? requestScope['javax.servlet.forward.request_uri'] : pageContext.request.requestURI}" />

<aside class="w-64 bg-surface-container-lowest border-r border-surface-variant flex flex-col h-full flex-shrink-0 z-20 shadow-sm hidden md:flex select-none">
    <!-- BRAND LOGO -->
    <div class="h-20 flex items-center px-6 border-b border-surface-variant flex-shrink-0">
        <a class="group flex items-center gap-3" href="${pageContext.request.contextPath}/admin/dashboard">
            <div class="w-9 h-9 rounded-xl bg-gradient-to-br from-[#84cc16] via-[#65a30d] to-[#4d7c0f] flex items-center justify-center text-white shadow-sm flex-shrink-0 group-hover:scale-105 transition-transform duration-200">
                <svg class="w-5 h-5 text-white" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2C12 2 12.5 5 10 7C7.5 9 6 12 6 15C6 18.3137 8.68629 21 12 21C15.3137 21 18 18.3137 18 15C18 12 16.5 9 14 7C11.5 5 12 2 12 2Z" fill="currentColor"/>
                    <path d="M12 2C12 2 13.2 4.2 15.5 4.2C17.5 4.2 18.5 2.8 18.5 2.8C18.5 2.8 18 5.2 16 5.8C14 6.4 12.5 5.2 12 2Z" fill="#fef08a"/>
                </svg>
            </div>
            <div class="flex flex-col">
                <span class="text-lg font-black tracking-tight leading-none text-slate-900">Fruit<span class="text-primary">ables</span></span>
                <span class="text-[9px] font-bold text-primary tracking-widest uppercase mt-1">Admin Portal</span>
            </div>
        </a>
    </div>

    <!-- NAVIGATION LINKS -->
    <nav class="flex-1 overflow-y-auto py-4 px-3 space-y-1 text-sm font-medium">
        
        <!-- NHÓM 1: TỔNG QUAN -->
        <div class="text-[10px] font-bold uppercase tracking-wider text-slate-400 px-3 pt-2 pb-1">
            Tổng quan
        </div>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/dashboard') ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="material-symbols-outlined text-[20px]">dashboard</span>
            <span>Tổng quan</span>
        </a>

        <!-- NHÓM 2: HÀNG HÓA & KHO BÃI -->
        <div class="text-[10px] font-bold uppercase tracking-wider text-slate-400 px-3 pt-3 pb-1">
            Sản phẩm & Kho
        </div>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/products') ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/products">
            <span class="material-symbols-outlined text-[20px]">inventory_2</span>
            <span>Sản phẩm</span>
        </a>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/categories') ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/categories">
            <span class="material-symbols-outlined text-[20px]">category</span>
            <span>Danh mục</span>
        </a>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/inventory') ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/inventory">
            <span class="material-symbols-outlined text-[20px]">warehouse</span>
            <span>Kho nhập hàng</span>
        </a>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/suppliers') ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/suppliers">
            <span class="material-symbols-outlined text-[20px]">storefront</span>
            <span>Nhà cung cấp</span>
        </a>

        <!-- NHÓM 3: BÁN HÀNG & DỊCH VỤ -->
        <div class="text-[10px] font-bold uppercase tracking-wider text-slate-400 px-3 pt-3 pb-1">
            Bán hàng & Hậu mãi
        </div>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/orders') ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/orders">
            <span class="material-symbols-outlined text-[20px]">receipt_long</span>
            <span>Đơn hàng</span>
        </a>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/claims') ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/claims">
            <span class="material-symbols-outlined text-[20px]">verified_user</span>
            <span>Bảo hành hoa quả</span>
        </a>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/coupons') ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/coupons">
            <span class="material-symbols-outlined text-[20px]">redeem</span>
            <span>Mã khuyến mãi</span>
        </a>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/delivery-failures') ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/delivery-failures">
            <span class="material-symbols-outlined text-[20px]">local_shipping</span>
            <span>Giao Hàng</span>
        </a>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/shipper/portal') ? 'bg-amber-600 text-white shadow-md font-bold' : 'text-amber-800 bg-amber-50/70 hover:bg-amber-100 font-semibold'}" 
           href="${pageContext.request.contextPath}/shipper/portal">
            <span class="material-symbols-outlined text-[20px] text-amber-600">two_wheeler</span>
            <span>Cổng Tài Xế (Portal)</span>
        </a>

        <!-- NHÓM 4: QUẢN LÝ TÀI KHOẢN -->
        <div class="text-[10px] font-bold uppercase tracking-wider text-slate-400 px-3 pt-3 pb-1">
            Quản lý Tài khoản
        </div>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${(reqURI.contains('/customers') || (reqURI.contains('/users') && !reqURI.contains('/employees'))) ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/customers">
            <span class="material-symbols-outlined text-[20px]">people</span>
            <span>Tài khoản Khách hàng</span>
        </a>
        <a class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/employees') ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/employees">
            <span class="material-symbols-outlined text-[20px]">badge</span>
            <span>Tài khoản Nhân viên</span>
        </a>

        <!-- NHÓM 5: CHĂM SÓC KHÁCH HÀNG -->
        <div class="text-[10px] font-bold uppercase tracking-wider text-slate-400 px-3 pt-3 pb-1">
            Hỗ trợ & Chăm sóc
        </div>
        <a class="flex items-center justify-between px-3.5 py-2.5 rounded-xl transition-all duration-150 ${reqURI.contains('/chat') ? 'bg-primary text-white shadow-md font-bold' : 'text-on-surface-variant hover:bg-surface-container-low hover:text-primary'}" 
           href="${pageContext.request.contextPath}/admin/chat">
            <div class="flex items-center gap-3">
                <span class="material-symbols-outlined text-[20px]">support_agent</span>
                <span>Live Chat CSKH</span>
            </div>
            <c:if test="${totalUnread > 0}">
                <span class="px-2 py-0.5 text-xs font-bold bg-error text-white rounded-full shadow-sm">${totalUnread}</span>
            </c:if>
        </a>


    </nav>

    <!-- FOOTER CHUYỂN TRANG / ĐĂNG XUẤT -->
    <div class="p-3 border-t border-surface-variant flex-shrink-0 space-y-1 bg-surface-container-lowest">
        <a class="flex items-center gap-3 px-3.5 py-2 rounded-xl text-xs font-semibold text-slate-600 hover:bg-surface-container-low hover:text-primary transition-colors" 
           href="${pageContext.request.contextPath}/" target="_blank" title="Mở trang mua sắm khách hàng">
            <span class="material-symbols-outlined text-[18px]">open_in_new</span>
            <span>Xem Cửa hàng Web</span>
        </a>
        <a class="flex items-center gap-3 px-3.5 py-2 rounded-xl text-xs font-semibold text-error hover:bg-error-container hover:text-on-error-container transition-colors" 
           href="${pageContext.request.contextPath}/logout" title="Đăng xuất khỏi hệ thống">
            <span class="material-symbols-outlined text-[18px]">logout</span>
            <span>Đăng xuất</span>
        </a>
    </div>
</aside>
