<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="bg-surface-container py-12 border-t border-outline-variant mt-auto">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto grid grid-cols-1 md:grid-cols-4 gap-8">
        <div>
            <a class="font-display-lg text-headline-md font-extrabold text-primary block mb-4" href="${pageContext.request.contextPath}/home">Fruitables</a>
            <p class="text-on-surface-variant font-body-md text-sm">Hệ thống phân phối nông sản, hoa quả sạch chuẩn VietGAP số 1 Việt Nam. Đảm bảo tươi sạch mỗi ngày.</p>
        </div>
        <div>
            <h4 class="font-label-bold text-on-surface mb-4 text-base">Liên kết nhanh</h4>
            <ul class="space-y-2 text-on-surface-variant text-sm font-body-md">
                <li><a href="${pageContext.request.contextPath}/home" class="hover:text-primary transition-colors">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/shop" class="hover:text-primary transition-colors">Cửa hàng hoa quả</a></li>
                <li><a href="${pageContext.request.contextPath}/guest-tracking" class="hover:text-primary transition-colors">Tra cứu đơn hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/promotions" class="hover:text-primary transition-colors">Chương trình khuyến mãi</a></li>
            </ul>
        </div>
        <div>
            <h4 class="font-label-bold text-on-surface mb-4 text-base">Hỗ trợ khách hàng</h4>
            <ul class="space-y-2 text-on-surface-variant text-sm font-body-md">
                <li class="flex items-center gap-2"><span class="material-symbols-outlined text-[18px]">location_on</span> Đây là dự án của sinh viên nên không có địa chỉ đâu</li>
                <li class="flex items-center gap-2"><span class="material-symbols-outlined text-[18px]">call</span> 0375162932 </li>
                <li class="flex items-center gap-2"><span class="material-symbols-outlined text-[18px]">mail</span> monimeo2807@gmail.com</li>
            </ul>
        </div>
        <div>
            <h4 class="font-label-bold text-on-surface mb-4 text-base">Đăng ký nhận tin</h4>
            <p class="text-on-surface-variant font-body-md text-sm mb-4">Nhận ngay thông báo ưu đãi và voucher mua hàng hấp dẫn.</p>
            <div class="flex">
                <input type="email" placeholder="Email của bạn..." class="w-full px-4 py-2 rounded-l-lg border border-outline-variant outline-none focus:border-primary text-sm bg-surface-container-lowest">
                <button class="bg-primary hover:bg-primary-container text-white px-4 rounded-r-lg transition-colors font-label-bold text-sm">Gửi</button>
            </div>
        </div>
    </div>
    <div class="border-t border-surface-variant mt-8 pt-6 text-center text-on-surface-variant text-xs font-body-md">
        <p>© 2026 Fruitables. All rights reserved.</p>
    </div>
</footer>

<!-- ============================================== -->
<!-- LIVE CHAT WIDGET (CSKH TRỰC TUYẾN)            -->
<!-- ============================================== -->
<div id="fruitables-live-chat-root" class="fixed bottom-6 right-6 z-[999] flex flex-col items-end">
    <!-- Cửa sổ Chat Box -->
    <div id="chat-window" class="hidden mb-4 w-[360px] sm:w-[380px] h-[500px] max-h-[80vh] bg-surface-container-lowest rounded-3xl shadow-2xl border border-outline-variant flex flex-col overflow-hidden transition-all duration-300 transform scale-95 opacity-0 origin-bottom-right">
        
        <!-- Chat Header -->
        <div class="bg-gradient-to-r from-primary to-emerald-700 p-4 text-white flex items-center justify-between shadow-md flex-shrink-0">
            <div class="flex items-center gap-3">
                <div class="relative">
                    <div class="w-10 h-10 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center border border-white/30 text-white font-bold">
                        <span class="material-symbols-outlined text-2xl">support_agent</span>
                    </div>
                    <span class="absolute bottom-0 right-0 w-3 h-3 bg-emerald-400 border-2 border-primary rounded-full"></span>
                </div>
                <div>
                    <h4 class="font-label-bold text-sm leading-tight">Fruitables CSKH 24/7</h4>
                    <p class="text-[11px] text-white/80 flex items-center gap-1 mt-0.5">
                        <span class="w-1.5 h-1.5 rounded-full bg-emerald-300 animate-pulse"></span> Luôn sẵn sàng hỗ trợ
                    </p>
                </div>
            </div>
            <button id="close-chat-btn" class="text-white/80 hover:text-white p-1 rounded-full hover:bg-white/10 transition-colors">
                <span class="material-symbols-outlined text-xl">close</span>
            </button>
        </div>

        <!-- Chat Body -->
        <div class="flex-1 flex flex-col p-4 bg-surface-container-low/40 overflow-hidden">
            <c:choose>
                <c:when test="${empty sessionScope.USERMODEL}">
                    <!-- Chưa đăng nhập -> Yêu cầu đăng nhập -->
                    <div class="flex-1 flex flex-col items-center justify-center text-center p-6 bg-surface-container-lowest rounded-2xl border border-outline-variant my-auto shadow-sm">
                        <div class="w-14 h-14 rounded-2xl bg-primary/10 text-primary flex items-center justify-center mb-3">
                            <span class="material-symbols-outlined text-3xl">chat_bubble_outline</span>
                        </div>
                        <h5 class="font-headline-md text-base text-on-surface font-bold mb-1">Kết nối với chúng tôi</h5>
                        <p class="text-xs text-on-surface-variant mb-5 leading-relaxed">
                            Vui lòng đăng nhập tài khoản để được tư vấn viên hỗ trợ trực tiếp và lưu lại toàn bộ lịch sử tư vấn.
                        </p>
                        <a href="${pageContext.request.contextPath}/login" class="w-full py-2.5 px-4 bg-primary text-white rounded-xl text-xs font-label-bold hover:bg-primary-container transition-colors shadow-sm flex items-center justify-center gap-2">
                            <span class="material-symbols-outlined text-sm">login</span> Đăng nhập ngay
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Đã đăng nhập -> Hiển thị tin nhắn -->
                    <div id="chat-messages" class="flex-1 overflow-y-auto space-y-3 pr-1 text-xs">
                        <!-- Lời chào mặc định -->
                        <div class="flex items-start gap-2">
                            <div class="w-7 h-7 rounded-full bg-primary/20 text-primary flex items-center justify-center flex-shrink-0 text-xs font-bold">
                                <span class="material-symbols-outlined text-sm">eco</span>
                            </div>
                            <div class="bg-surface-container-lowest border border-outline-variant p-3 rounded-2xl rounded-tl-sm max-w-[80%] shadow-sm text-on-surface leading-relaxed">
                                Chào <strong class="text-primary"><c:out value="${sessionScope.USERMODEL.fullName}"/></strong>! Fruitables có thể giải đáp thông tin đơn hàng hoặc hỗ trợ tư vấn trái cây cho bạn như thế nào ạ? 🍎🍇
                            </div>
                        </div>
                    </div>

                    <!-- Input gửi tin -->
                    <form id="chat-send-form" class="mt-3 flex items-center gap-2 pt-2 border-t border-surface-variant flex-shrink-0">
                        <input type="text" id="chat-input" placeholder="Nhập tin nhắn tư vấn..." autocomplete="off"
                               class="flex-1 px-4 py-2.5 bg-surface-container-lowest rounded-xl border border-outline-variant focus:border-primary outline-none text-xs text-on-surface shadow-inner">
                        <button type="submit" id="chat-submit-btn" class="w-10 h-10 rounded-xl bg-primary text-white flex items-center justify-center hover:bg-primary-container transition-all flex-shrink-0 shadow-sm active:scale-95 disabled:opacity-50">
                            <span class="material-symbols-outlined text-lg">send</span>
                        </button>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Nút Nổi Kích Hoạt Live Chat -->
    <button id="chat-toggle-btn" class="group flex items-center gap-2.5 px-4 py-3 bg-gradient-to-r from-primary to-emerald-600 text-white rounded-full shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1 active:scale-95 border-2 border-white">
        <div class="relative flex items-center justify-center">
            <span class="material-symbols-outlined text-2xl group-hover:rotate-12 transition-transform">chat_bubble</span>
            <span id="chat-unread-badge" class="hidden absolute -top-1.5 -right-2 bg-error text-white text-[9px] font-bold px-1.5 py-0.5 rounded-full ring-2 ring-white">0</span>
        </div>
        <span class="font-label-bold text-xs pr-1">Hỗ trợ trực tuyến</span>
    </button>
</div>

<c:if test="${not empty sessionScope.USERMODEL}">
<script>
    (function() {
        const toggleBtn = document.getElementById('chat-toggle-btn');
        const closeBtn = document.getElementById('close-chat-btn');
        const chatWindow = document.getElementById('chat-window');
        const sendForm = document.getElementById('chat-send-form');
        const chatInput = document.getElementById('chat-input');
        const messagesBox = document.getElementById('chat-messages');
        const unreadBadge = document.getElementById('chat-unread-badge');

        let chatOpen = false;
        let pollInterval = null;
        let lastMessageCount = 0;

        function openChat() {
            chatOpen = true;
            chatWindow.classList.remove('hidden');
            setTimeout(() => {
                chatWindow.classList.remove('scale-95', 'opacity-0');
                chatWindow.classList.add('scale-100', 'opacity-100');
            }, 10);
            unreadBadge.classList.add('hidden');
            unreadBadge.innerText = '0';
            fetchMessages();
            if (chatInput) chatInput.focus();
            if (!pollInterval) {
                pollInterval = setInterval(fetchMessages, 2500);
            }
        }

        function closeChat() {
            chatOpen = false;
            chatWindow.classList.remove('scale-100', 'opacity-100');
            chatWindow.classList.add('scale-95', 'opacity-0');
            setTimeout(() => {
                chatWindow.classList.add('hidden');
            }, 300);
            if (pollInterval) {
                clearInterval(pollInterval);
                pollInterval = null;
            }
        }

        if (toggleBtn) {
            toggleBtn.addEventListener('click', function() {
                if (chatOpen) closeChat(); else openChat();
            });
        }

        if (closeBtn) {
            closeBtn.addEventListener('click', closeChat);
        }

        function formatTime(ts) {
            if (!ts) return '';
            try {
                const d = new Date(ts);
                return d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            } catch (e) {
                return '';
            }
        }

        function fetchMessages() {
            fetch('${pageContext.request.contextPath}/api/chat')
                .then(res => res.json())
                .then(data => {
                    if (!data.authenticated) return;

                    const msgs = data.messages || [];
                    if (msgs.length !== lastMessageCount) {
                        renderMessages(msgs);
                        lastMessageCount = msgs.length;
                    }
                })
                .catch(err => console.error(err));
        }

        function renderMessages(msgs) {
            if (!messagesBox) return;

            const welcomeHtml = `
                <div class="flex items-start gap-2">
                    <div class="w-7 h-7 rounded-full bg-primary/20 text-primary flex items-center justify-center flex-shrink-0 text-xs font-bold">
                        <span class="material-symbols-outlined text-sm">eco</span>
                    </div>
                    <div class="bg-surface-container-lowest border border-outline-variant p-3 rounded-2xl rounded-tl-sm max-w-[80%] shadow-sm text-on-surface leading-relaxed">
                        Chào <strong class="text-primary"><c:out value="${sessionScope.USERMODEL.fullName}"/></strong>! Fruitables có thể giải đáp thông tin đơn hàng hoặc hỗ trợ tư vấn trái cây cho bạn như thế nào ạ? 🍎🍇
                    </div>
                </div>
            `;

            const msgsHtml = msgs.map(m => {
                const isUser = (m.senderType === 'USER');
                if (isUser) {
                    return `
                        <div class="flex justify-end items-end gap-1.5 my-2">
                            <div class="max-w-[78%]">
                                <div class="bg-primary text-white p-3 rounded-2xl rounded-br-sm shadow-sm leading-relaxed text-xs break-words">
                                    \${escapeHtml(m.message)}
                                </div>
                                <div class="text-[9px] text-on-surface-variant/70 text-right mt-0.5 px-1">\${formatTime(m.createdAt)}</div>
                            </div>
                        </div>
                    `;
                } else {
                    return `
                        <div class="flex items-start gap-2 my-2">
                            <div class="w-7 h-7 rounded-full bg-emerald-600 text-white flex items-center justify-center flex-shrink-0 text-xs shadow-sm">
                                <span class="material-symbols-outlined text-sm">support_agent</span>
                            </div>
                            <div class="max-w-[78%]">
                                <div class="bg-surface-container-lowest border border-outline-variant p-3 rounded-2xl rounded-tl-sm shadow-sm text-on-surface leading-relaxed text-xs break-words">
                                    \${escapeHtml(m.message)}
                                </div>
                                <div class="text-[9px] text-on-surface-variant/70 mt-0.5 px-1">\${formatTime(m.createdAt)}</div>
                            </div>
                        </div>
                    `;
                }
            }).join('');

            messagesBox.innerHTML = welcomeHtml + msgsHtml;
            messagesBox.scrollTop = messagesBox.scrollHeight;
        }

        function escapeHtml(str) {
            if (!str) return '';
            return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
        }

        if (sendForm) {
            sendForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const text = chatInput.value.trim();
                if (!text) return;

                chatInput.value = '';

                fetch('${pageContext.request.contextPath}/api/chat', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'message=' + encodeURIComponent(text)
                })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        fetchMessages();
                    }
                })
                .catch(err => console.error(err));
            });
        }
    })();
</script>
</c:if>
<c:if test="${empty sessionScope.USERMODEL}">
<script>
    (function() {
        const toggleBtn = document.getElementById('chat-toggle-btn');
        const closeBtn = document.getElementById('close-chat-btn');
        const chatWindow = document.getElementById('chat-window');

        if (toggleBtn && chatWindow) {
            toggleBtn.addEventListener('click', function() {
                chatWindow.classList.toggle('hidden');
                if (!chatWindow.classList.contains('hidden')) {
                    setTimeout(() => {
                        chatWindow.classList.remove('scale-95', 'opacity-0');
                        chatWindow.classList.add('scale-100', 'opacity-100');
                    }, 10);
                }
            });
        }
        if (closeBtn && chatWindow) {
            closeBtn.addEventListener('click', function() {
                chatWindow.classList.add('hidden');
            });
        }
    })();
</script>
</c:if>