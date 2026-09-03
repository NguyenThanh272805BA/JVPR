<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="bg-surface w-full sticky top-0 shadow-sm z-50">
    <div class="flex justify-between items-center h-20 px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto">
        <!-- Logo -->
        <a class="font-display-lg-mobile md:font-display-lg text-display-lg-mobile md:text-display-lg font-extrabold text-primary" href="${pageContext.request.contextPath}/home">
            Fruitables
        </a>

        <!-- Menu điều hướng -->
        <div class="hidden md:flex space-x-8 items-center">
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/shop">Cửa hàng</a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/promotions">Khuyến mãi</a>
            <a class="font-body-md text-on-surface-variant hover:text-primary transition-colors flex items-center gap-1" href="${pageContext.request.contextPath}/guest-tracking">
                <span class="material-symbols-outlined text-[18px]">local_shipping</span> Tra cứu đơn hàng
            </a>
        </div>

        <!-- Tiện ích người dùng & Giỏ hàng -->
        <div class="flex items-center space-x-4">
            <a href="${pageContext.request.contextPath}/cart" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors relative" title="Giỏ hàng">
                <span class="material-symbols-outlined">shopping_cart</span>
                <c:if test="${not empty sessionScope.CART_TOTAL_ITEMS && sessionScope.CART_TOTAL_ITEMS > 0}">
                    <span class="absolute top-0 right-0 w-4 h-4 bg-error text-white text-[10px] font-bold rounded-full flex items-center justify-center">
                        <c:out value="${sessionScope.CART_TOTAL_ITEMS}"/>
                    </span>
                </c:if>
            </a>

            <c:choose>
                <c:when test="${not empty sessionScope.USERMODEL}">
                    <div class="group relative cursor-pointer py-2">
                        <div class="flex items-center gap-2 text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors">
                            <c:choose>
                                <c:when test="${not empty sessionScope.USERMODEL.avatarUrl}">
                                    <img src="${sessionScope.USERMODEL.avatarUrl}" class="w-8 h-8 rounded-full object-cover border border-primary">
                                </c:when>
                                <c:otherwise>
                                    <span class="material-symbols-outlined text-[28px]" style="font-variation-settings: 'FILL' 1;">account_circle</span>
                                </c:otherwise>
                            </c:choose>
                            <span class="font-label-bold hidden md:block max-w-[120px] truncate"><c:out value="${sessionScope.USERMODEL.fullName}"/></span>
                        </div>

                        <!-- Dropdown menu -->
                        <div class="absolute right-0 top-full pt-2 z-[100] hidden group-hover:block w-52">
                            <div class="bg-surface-container-lowest rounded-xl shadow-lg border border-outline-variant overflow-hidden py-1">
                                <c:if test="${sessionScope.USERMODEL.roleId == 1 || sessionScope.USERMODEL.roleId == 2}">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center gap-2 px-4 py-2.5 text-on-surface hover:bg-surface-container transition-colors">
                                        <span class="material-symbols-outlined text-sm">dashboard</span> Trang Quản Trị
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-2 px-4 py-2.5 text-on-surface hover:bg-surface-container transition-colors">
                                    <span class="material-symbols-outlined text-sm">person</span> Trang cá nhân
                                </a>
                                <a href="${pageContext.request.contextPath}/order-history" class="flex items-center gap-2 px-4 py-2.5 text-on-surface hover:bg-surface-container transition-colors">
                                    <span class="material-symbols-outlined text-sm">receipt_long</span> Lịch sử đơn hàng
                                </a>
                                <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-2 px-4 py-2.5 text-error hover:bg-error-container transition-colors border-t border-surface-variant">
                                    <span class="material-symbols-outlined text-sm">logout</span> Đăng xuất
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="text-primary hover:bg-surface-container-highest p-2 rounded-full transition-colors flex items-center gap-1" title="Đăng nhập">
                        <span class="material-symbols-outlined">person</span>
                        <span class="font-label-bold text-sm hidden md:inline">Đăng nhập</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>