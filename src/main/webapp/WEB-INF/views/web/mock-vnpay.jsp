<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="vn.edu.eaut.fruitables.util.VnPayConfigUtil" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String pendingCode = (String) session.getAttribute("PENDING_ORDER_CODE");
    String signSuccess = "";
    String signFail = "";
    if (pendingCode != null && !pendingCode.trim().isEmpty()) {
        signSuccess = VnPayConfigUtil.hmacSHA512(VnPayConfigUtil.secretKey, "vnp_ResponseCode=00&vnp_TxnRef=" + pendingCode.trim());
        signFail = VnPayConfigUtil.hmacSHA512(VnPayConfigUtil.secretKey, "vnp_ResponseCode=99&vnp_TxnRef=" + pendingCode.trim());
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Thanh toán qua cổng điện tử</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center p-4">

<div class="bg-white rounded-xl shadow-lg w-full max-w-md overflow-hidden">
    <!-- Header -->
    <div class="bg-blue-600 p-4 text-center">
        <h1 class="text-white text-xl font-bold">Cổng thanh toán giả lập</h1>
        <p class="text-blue-100 text-sm mt-1">Dành cho đồ án Fruitables</p>
    </div>

    <!-- Body -->
    <div class="p-6 text-center">
        <h2 class="text-gray-700 font-semibold mb-2">Mã đơn hàng: <span class="text-blue-600">${sessionScope.PENDING_ORDER_CODE}</span></h2>
        <div class="text-3xl font-bold text-red-500 mb-6">
            <fmt:formatNumber value="${sessionScope.PENDING_TOTAL_AMOUNT}" type="number" groupingUsed="true"/> VNĐ
        </div>

        <!-- Mã QR Động (Dùng QuickChart API) -->
        <div class="bg-gray-50 p-4 rounded-lg inline-block border border-gray-200 mb-6">
            <img src="https://quickchart.io/qr?text=ThanhToan_${sessionScope.PENDING_ORDER_CODE}_${sessionScope.PENDING_TOTAL_AMOUNT}&size=200"
                 alt="Mã QR Thanh toán" class="mx-auto w-48 h-48">
            <p class="text-sm text-gray-500 mt-3">Mở ứng dụng ngân hàng để quét mã</p>
        </div>

        <p class="text-sm text-gray-500 mb-6">Vui lòng chọn trạng thái mô phỏng bên dưới để tiếp tục.</p>

        <!-- Buttons giả lập -->
        <div class="space-y-3">
            <!-- Nút thành công: Gửi mã 00 -->
            <form action="${pageContext.request.contextPath}/vnpay-return" method="GET">
                <input type="hidden" name="vnp_ResponseCode" value="00">
                <input type="hidden" name="vnp_TxnRef" value="${sessionScope.PENDING_ORDER_CODE}">
                <input type="hidden" name="vnp_SecureHash" value="<%= signSuccess %>">
                <button type="submit" class="w-full bg-green-500 hover:bg-green-600 text-white font-bold py-3 px-4 rounded-lg transition-colors">
                    Mô phỏng: Thanh toán THÀNH CÔNG
                </button>
            </form>

            <!-- Nút thất bại: Gửi mã 99 -->
            <form action="${pageContext.request.contextPath}/vnpay-return" method="GET">
                <input type="hidden" name="vnp_ResponseCode" value="99">
                <input type="hidden" name="vnp_TxnRef" value="${sessionScope.PENDING_ORDER_CODE}">
                <input type="hidden" name="vnp_SecureHash" value="<%= signFail %>">
                <button type="submit" class="w-full bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-3 px-4 rounded-lg transition-colors">
                    Mô phỏng: HỦY thanh toán
                </button>
            </form>
        </div>
    </div>
</div>

</body>
</html>