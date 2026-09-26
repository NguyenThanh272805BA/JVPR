<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<footer class="bg-surface-container py-12 border-t border-outline-variant mt-auto">
    <div class="px-margin-mobile md:px-margin-desktop max-w-container-max-width mx-auto grid grid-cols-1 md:grid-cols-4 gap-8">
        <div>
            <a class="group inline-flex items-center gap-3 mb-4 transition-transform duration-300" href="${pageContext.request.contextPath}/home" title="Fruitables">
                <div class="w-10 h-10 rounded-2xl bg-gradient-to-br from-[#84cc16] via-[#65a30d] to-[#4d7c0f] flex items-center justify-center text-white shadow-[0_4px_16px_rgba(101,163,13,0.35)] group-hover:scale-105 group-hover:rotate-3 transition-all duration-300 relative overflow-hidden flex-shrink-0 border border-white/30">
                    <div class="absolute inset-0 bg-gradient-to-tr from-transparent via-white/25 to-transparent"></div>
                    <svg class="w-6 h-6 text-white drop-shadow-sm" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 2C12 2 12.5 5 10 7C7.5 9 6 12 6 15C6 18.3137 8.68629 21 12 21C15.3137 21 18 18.3137 18 15C18 12 16.5 9 14 7C11.5 5 12 2 12 2Z" fill="currentColor" fill-opacity="0.95"/>
                        <path d="M12 2C12 2 13.2 4.2 15.5 4.2C17.5 4.2 18.5 2.8 18.5 2.8C18.5 2.8 18 5.2 16 5.8C14 6.4 12.5 5.2 12 2Z" fill="#fef08a"/>
                        <circle cx="9.5" cy="13.5" r="1.5" fill="white" fill-opacity="0.75"/>
                    </svg>
                </div>
                <div class="flex flex-col">
                    <div class="flex items-center text-2xl font-black tracking-tight leading-none">
                        <span class="text-slate-900 font-display-lg">Fruit</span><span class="bg-gradient-to-r from-primary via-[#84cc16] to-[#65a30d] bg-clip-text text-transparent font-display-lg">ables</span>
                        <span class="w-2 h-2 rounded-full bg-primary ml-1 animate-pulse"></span>
                    </div>
                    <span class="text-[9px] font-bold text-on-surface-variant/75 tracking-[0.22em] uppercase mt-0.5 pl-0.5">Organic & Fresh</span>
                </div>
            </a>
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
                <button type="button" class="bg-primary hover:bg-primary-container text-white px-4 rounded-r-lg transition-colors font-label-bold text-sm">Gửi</button>
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
<div id="fruitables-live-chat-root" class="fixed bottom-6 right-6 z-[999] flex flex-col items-end select-none">
    <!-- Cửa sổ Chat Box (2 Tabs: Trợ lý AI & CSKH Trực Tiếp) -->
    <div id="chat-window" class="hidden mb-4 w-[360px] sm:w-[390px] h-[520px] max-h-[82vh] bg-surface-container-lowest rounded-3xl shadow-2xl border border-outline-variant flex flex-col overflow-hidden transition-all duration-300 transform scale-95 opacity-0 origin-bottom-right">
        
        <!-- Chat Header -->
        <div class="bg-gradient-to-r from-primary via-emerald-600 to-teal-700 p-3.5 text-white flex items-center justify-between shadow-md flex-shrink-0">
            <div class="flex items-center gap-2.5">
                <div class="relative">
                    <div class="w-9 h-9 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center border border-white/30 text-white font-bold shadow-inner">
                        <span id="chat-header-icon" class="material-symbols-outlined text-xl">smart_toy</span>
                    </div>
                    <span class="absolute bottom-0 right-0 w-2.5 h-2.5 bg-emerald-400 border-2 border-primary rounded-full"></span>
                </div>
                <div>
                    <h4 id="chat-header-title" class="font-label-bold text-sm leading-tight">Fruitables Assistant</h4>
                    <p class="text-[10px] text-white/85 flex items-center gap-1 mt-0.5">
                        <span class="w-1.5 h-1.5 rounded-full bg-emerald-300 animate-pulse"></span> Phản hồi tức thì 24/7
                    </p>
                </div>
            </div>
            <button type="button" id="close-chat-btn" class="text-white/80 hover:text-white p-1.5 rounded-full hover:bg-white/15 transition-colors cursor-pointer" title="Thu nhỏ chat">
                <span class="material-symbols-outlined text-lg pointer-events-none">close</span>
            </button>
        </div>

        <!-- 2-Tab Navigation Bar -->
        <div class="flex items-center bg-surface-container-low border-b border-outline-variant text-xs flex-shrink-0">
            <button type="button" id="tab-btn-ai" class="flex-1 py-2.5 px-3 font-label-bold flex items-center justify-center gap-1.5 border-b-2 border-primary text-primary bg-surface-container-lowest transition-all cursor-pointer">
                <span class="material-symbols-outlined text-sm">smart_toy</span>
                <span>Trợ lý AI (24/7)</span>
            </button>
            <button type="button" id="tab-btn-live" class="flex-1 py-2.5 px-3 font-label-bold flex items-center justify-center gap-1.5 border-b-2 border-transparent text-on-surface-variant hover:text-on-surface hover:bg-surface-container transition-all cursor-pointer">
                <span class="material-symbols-outlined text-sm">support_agent</span>
                <span>CSKH Trực Tiếp</span>
            </button>
        </div>

        <!-- ============================================== -->
        <!-- TAB 1: TRỢ LÝ AI (Hỗ trợ cả khách chưa đăng nhập) -->
        <!-- ============================================== -->
        <div id="tab-content-ai" class="flex-1 flex flex-col p-3 bg-surface-container-low/30 overflow-hidden select-text">
            
            <!-- Vùng hiển thị tin nhắn AI -->
            <div id="ai-messages-box" class="flex-1 overflow-y-auto space-y-3 pr-1 text-xs">
                <!-- Lời chào AI -->
                <div class="flex items-start gap-2">
                    <div class="w-7 h-7 rounded-full bg-emerald-500/20 text-emerald-600 flex items-center justify-center flex-shrink-0 text-xs font-bold shadow-sm">
                        <span class="material-symbols-outlined text-sm">smart_toy</span>
                    </div>
                    <div class="bg-surface-container-lowest border border-outline-variant p-3 rounded-2xl rounded-tl-sm max-w-[85%] shadow-sm text-on-surface leading-relaxed text-xs">
                        Xin chào! Mình là <strong>Trợ lý AI Fruitables</strong> 🍎. Mình có thể giải đáp mẹo bảo quản, gợi ý công thức nước ép detox hoặc tra cứu tiến độ đơn hàng. Bạn cần tư vấn gì ạ?
                    </div>
                </div>

                <!-- Prompt Suggestions Chips -->
                <div class="space-y-1.5 pt-1">
                    <p class="text-[10px] text-on-surface-variant font-medium px-1">💡 Gợi ý câu hỏi:</p>
                    <div class="flex flex-wrap gap-1.5">
                        <button type="button" class="ai-quick-btn bg-surface-container-lowest hover:bg-primary/10 hover:border-primary border border-outline-variant text-[11px] font-medium py-1 px-2.5 rounded-full text-on-surface transition-all flex items-center gap-1 cursor-pointer active:scale-95 shadow-2xs" data-action="quick_discount" data-prompt="Hàng giảm giá">
                            🔥 Hàng giảm giá
                        </button>
                        <button type="button" class="ai-quick-btn bg-surface-container-lowest hover:bg-primary/10 hover:border-primary border border-outline-variant text-[11px] font-medium py-1 px-2.5 rounded-full text-on-surface transition-all flex items-center gap-1 cursor-pointer active:scale-95 shadow-2xs" data-action="quick_featured" data-prompt="Bán chạy nhất">
                            ⭐ Bán chạy nhất
                        </button>
                        <button type="button" class="ai-quick-btn bg-surface-container-lowest hover:bg-primary/10 hover:border-primary border border-outline-variant text-[11px] font-medium py-1 px-2.5 rounded-full text-on-surface transition-all flex items-center gap-1 cursor-pointer active:scale-95 shadow-2xs" data-action="open_tracker" data-prompt="Tra cứu tiến độ đơn">
                            📦 Tra cứu tiến độ đơn
                        </button>
                        <button type="button" class="ai-quick-btn bg-surface-container-lowest hover:bg-primary/10 hover:border-primary border border-outline-variant text-[11px] font-medium py-1 px-2.5 rounded-full text-on-surface transition-all flex items-center gap-1 cursor-pointer active:scale-95 shadow-2xs" data-action="quick_preservation" data-prompt="Mẹo bảo quản hoa quả">
                            🥑 Mẹo bảo quản hoa quả
                        </button>
                        <button type="button" class="ai-quick-btn bg-surface-container-lowest hover:bg-primary/10 hover:border-primary border border-outline-variant text-[11px] font-medium py-1 px-2.5 rounded-full text-on-surface transition-all flex items-center gap-1 cursor-pointer active:scale-95 shadow-2xs" data-action="quick_recipes" data-prompt="Công thức nước ép">
                            🥤 Công thức nước ép
                        </button>
                    </div>
                </div>
            </div>

            <!-- Form gửi tin nhắn cho AI -->
            <form id="ai-send-form" class="mt-2.5 flex items-center gap-1.5 pt-2 border-t border-surface-variant flex-shrink-0">
                <input type="text" id="ai-chat-input" placeholder="Hỏi về giảm giá, bán chạy, bảo quản, nước ép..." autocomplete="off"
                       class="flex-1 px-3.5 py-2.5 bg-surface-container-lowest rounded-xl border border-outline-variant focus:border-primary outline-none text-xs text-on-surface shadow-inner">
                <button type="submit" id="ai-submit-btn" class="w-10 h-10 rounded-xl bg-gradient-to-r from-emerald-600 to-primary text-white flex items-center justify-center hover:opacity-90 transition-all flex-shrink-0 shadow-sm active:scale-95 disabled:opacity-50 cursor-pointer" title="Gửi câu hỏi">
                    <span class="material-symbols-outlined text-lg pointer-events-none">send</span>
                </button>
            </form>
        </div>

        <!-- ============================================== -->
        <!-- TAB 2: CSKH TRỰC TIẾP (Nhân viên / Admin cũ)   -->
        <!-- ============================================== -->
        <div id="tab-content-live" class="hidden flex-1 flex flex-col p-3 bg-surface-container-low/40 overflow-hidden select-text">
            <c:choose>
                <c:when test="${empty sessionScope.USERMODEL}">
                    <!-- Chưa đăng nhập -> Yêu cầu đăng nhập để chat với nhân viên -->
                    <div class="flex-1 flex flex-col items-center justify-center text-center p-5 bg-surface-container-lowest rounded-2xl border border-outline-variant my-auto shadow-sm">
                        <div class="w-12 h-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center mb-2.5">
                            <span class="material-symbols-outlined text-2xl">support_agent</span>
                        </div>
                        <h5 class="font-headline-md text-sm text-on-surface font-bold mb-1">Kết nối chuyên viên CSKH</h5>
                        <p class="text-[11px] text-on-surface-variant mb-4 leading-relaxed">
                            Vui lòng đăng nhập tài khoản để được tư vấn viên hỗ trợ trực tiếp và lưu lại lịch sử phản hồi. Bạn cũng có thể dùng Tab <strong>Trợ lý AI</strong> bên cạnh mà không cần đăng nhập!
                        </p>
                        <a href="${pageContext.request.contextPath}/login" class="w-full py-2 px-4 bg-primary text-white rounded-xl text-xs font-label-bold hover:bg-primary-container transition-colors shadow-sm flex items-center justify-center gap-1.5">
                            <span class="material-symbols-outlined text-sm">login</span> Đăng nhập ngay
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Đã đăng nhập -> Hiển thị tin nhắn Live chat -->
                    <div id="chat-messages" class="flex-1 overflow-y-auto space-y-3 pr-1 text-xs">
                        <div class="flex items-start gap-2">
                            <div class="w-7 h-7 rounded-full bg-primary/20 text-primary flex items-center justify-center flex-shrink-0 text-xs font-bold">
                                <span class="material-symbols-outlined text-sm">eco</span>
                            </div>
                            <div class="bg-surface-container-lowest border border-outline-variant p-3 rounded-2xl rounded-tl-sm max-w-[80%] shadow-sm text-on-surface leading-relaxed">
                                Chào <strong class="text-primary"><c:out value="${sessionScope.USERMODEL.fullName}"/></strong>! Chuyên viên Fruitables luôn sẵn sàng hỗ trợ bạn. Vui lòng để lại tin nhắn nhé! 🍎
                            </div>
                        </div>
                    </div>

                    <!-- Input gửi tin Live Chat -->
                    <form id="chat-send-form" class="mt-2.5 flex flex-col gap-1.5 pt-2 border-t border-surface-variant flex-shrink-0">
                        <!-- Image Preview Box -->
                        <div id="chat-img-preview-box" class="hidden relative items-center gap-2 p-1.5 bg-surface-container rounded-xl border border-outline-variant w-fit max-w-[200px]">
                            <img id="chat-img-preview" src="" class="w-12 h-12 object-cover rounded-lg border border-outline-variant">
                            <span id="chat-img-preview-name" class="text-[10px] text-on-surface truncate max-w-[90px]"></span>
                            <button type="button" id="chat-img-cancel-btn" class="text-error hover:bg-error/10 p-1 rounded-full transition-colors ml-1 cursor-pointer" title="Hủy ảnh">
                                <span class="material-symbols-outlined text-sm">close</span>
                            </button>
                        </div>

                        <div class="flex items-center gap-1.5">
                            <input type="file" id="chat-file-input" accept="image/png,image/jpeg,image/webp,image/gif" class="hidden">
                            <button type="button" id="chat-attach-btn" class="w-10 h-10 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface-variant hover:text-primary flex items-center justify-center transition-all flex-shrink-0 border border-outline-variant cursor-pointer" title="Đính kèm hình ảnh">
                                <span class="material-symbols-outlined text-lg">image</span>
                            </button>
                            <input type="text" id="chat-input" placeholder="Nhập tin nhắn..." autocomplete="off"
                                   class="flex-1 px-3.5 py-2.5 bg-surface-container-lowest rounded-xl border border-outline-variant focus:border-primary outline-none text-xs text-on-surface shadow-inner">
                            <button type="submit" id="chat-submit-btn" class="w-10 h-10 rounded-xl bg-primary text-white flex items-center justify-center hover:bg-primary-container transition-all flex-shrink-0 shadow-sm active:scale-95 disabled:opacity-50 cursor-pointer" title="Gửi tin nhắn">
                                <span class="material-symbols-outlined text-lg pointer-events-none">send</span>
                            </button>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <!-- Nút Nổi Kích Hoạt Widget Chat -->
    <button type="button" id="chat-toggle-btn" class="group flex items-center gap-2.5 px-4 py-3 bg-gradient-to-r from-primary via-emerald-600 to-teal-700 text-white rounded-full shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1 active:scale-95 border-2 border-white cursor-pointer">
        <div class="relative flex items-center justify-center pointer-events-none">
            <span class="material-symbols-outlined text-2xl group-hover:rotate-12 transition-transform">smart_toy</span>
            <span id="chat-unread-badge" class="hidden absolute -top-1.5 -right-2 bg-error text-white text-[9px] font-bold px-1.5 py-0.5 rounded-full ring-2 ring-white">0</span>
        </div>
        <span class="font-label-bold text-xs pr-1 pointer-events-none">Trợ lý AI & CSKH</span>
    </button>
</div>

<!-- SINGLE UNIFIED CONTROLLER (AI CHATBOT + LIVE CHAT CSKH) -->
<script>
    (function() {
        const rootContainer = document.getElementById('fruitables-live-chat-root');
        const toggleBtn = document.getElementById('chat-toggle-btn');
        const closeBtn = document.getElementById('close-chat-btn');
        const chatWindow = document.getElementById('chat-window');
        
        // Tabs Elements
        const tabBtnAi = document.getElementById('tab-btn-ai');
        const tabBtnLive = document.getElementById('tab-btn-live');
        const tabContentAi = document.getElementById('tab-content-ai');
        const tabContentLive = document.getElementById('tab-content-live');
        const chatHeaderTitle = document.getElementById('chat-header-title');
        const chatHeaderIcon = document.getElementById('chat-header-icon');

        // AI Chat Elements
        const aiMessagesBox = document.getElementById('ai-messages-box');
        const aiSendForm = document.getElementById('ai-send-form');
        const aiChatInput = document.getElementById('ai-chat-input');
        const aiSubmitBtn = document.getElementById('ai-submit-btn');

        // Live Chat Elements
        const sendForm = document.getElementById('chat-send-form');
        const chatInput = document.getElementById('chat-input');
        const messagesBox = document.getElementById('chat-messages');
        const unreadBadge = document.getElementById('chat-unread-badge');

        if (!toggleBtn || !chatWindow) return;

        const contextPath = '${pageContext.request.contextPath}';
        const isLoggedIn = ${not empty sessionScope.USERMODEL ? 'true' : 'false'};
        let isOpen = false;
        let activeTab = 'ai'; // 'ai' or 'live'
        let pollInterval = null;
        let lastMessageCount = 0;
        let aiHistory = [];

        // ----------------------------------------------------
        // ĐÓNG / MỞ CHAT
        // ----------------------------------------------------
        function openChat() {
            if (isOpen) return;
            isOpen = true;

            chatWindow.classList.remove('hidden');
            void chatWindow.offsetWidth;

            chatWindow.classList.remove('scale-95', 'opacity-0');
            chatWindow.classList.add('scale-100', 'opacity-100');

            if (unreadBadge) {
                unreadBadge.classList.add('hidden');
                unreadBadge.innerText = '0';
            }

            if (activeTab === 'ai') {
                if (aiChatInput) setTimeout(() => aiChatInput.focus(), 150);
            } else if (activeTab === 'live' && isLoggedIn) {
                fetchMessages();
                if (chatInput) setTimeout(() => chatInput.focus(), 150);
                if (!pollInterval) pollInterval = setInterval(fetchMessages, 2500);
            }
        }

        function closeChat() {
            if (!isOpen) return;
            isOpen = false;

            chatWindow.classList.remove('scale-100', 'opacity-100');
            chatWindow.classList.add('scale-95', 'opacity-0');

            setTimeout(() => {
                if (!isOpen) chatWindow.classList.add('hidden');
            }, 300);

            if (pollInterval) {
                clearInterval(pollInterval);
                pollInterval = null;
            }
        }

        function toggleChat(e) {
            if (e) {
                e.preventDefault();
                e.stopPropagation();
            }
            if (isOpen) closeChat();
            else openChat();
        }

        toggleBtn.addEventListener('click', toggleChat);
        if (closeBtn) {
            closeBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                closeChat();
            });
        }

        chatWindow.addEventListener('click', function(e) {
            e.stopPropagation();
        });

        document.addEventListener('click', function(e) {
            if (isOpen && rootContainer && !rootContainer.contains(e.target)) {
                closeChat();
            }
        });

        // ----------------------------------------------------
        // CHUYỂN TAB (TRỢ LÝ AI <-> CSKH TRỰC TIẾP)
        // ----------------------------------------------------
        function switchTab(tab) {
            activeTab = tab;
            if (tab === 'ai') {
                tabBtnAi.className = 'flex-1 py-2.5 px-3 font-label-bold flex items-center justify-center gap-1.5 border-b-2 border-primary text-primary bg-surface-container-lowest transition-all cursor-pointer';
                tabBtnLive.className = 'flex-1 py-2.5 px-3 font-label-bold flex items-center justify-center gap-1.5 border-b-2 border-transparent text-on-surface-variant hover:text-on-surface hover:bg-surface-container transition-all cursor-pointer';
                tabContentAi.classList.remove('hidden');
                tabContentLive.classList.add('hidden');
                chatHeaderTitle.innerText = 'Fruitables Assistant';
                chatHeaderIcon.innerText = 'smart_toy';

                if (pollInterval) {
                    clearInterval(pollInterval);
                    pollInterval = null;
                }
                if (aiChatInput) setTimeout(() => aiChatInput.focus(), 100);
            } else {
                tabBtnLive.className = 'flex-1 py-2.5 px-3 font-label-bold flex items-center justify-center gap-1.5 border-b-2 border-primary text-primary bg-surface-container-lowest transition-all cursor-pointer';
                tabBtnAi.className = 'flex-1 py-2.5 px-3 font-label-bold flex items-center justify-center gap-1.5 border-b-2 border-transparent text-on-surface-variant hover:text-on-surface hover:bg-surface-container transition-all cursor-pointer';
                tabContentLive.classList.remove('hidden');
                tabContentAi.classList.add('hidden');
                chatHeaderTitle.innerText = 'Fruitables CSKH';
                chatHeaderIcon.innerText = 'support_agent';

                if (isLoggedIn) {
                    fetchMessages();
                    if (!pollInterval) pollInterval = setInterval(fetchMessages, 2500);
                    if (chatInput) setTimeout(() => chatInput.focus(), 100);
                }
            }
        }

        tabBtnAi.addEventListener('click', () => switchTab('ai'));
        tabBtnLive.addEventListener('click', () => switchTab('live'));

        // Cung cấp hàm toàn cục để các trang (như trang Chi tiết sản phẩm) có thể gọi mở thẳng Live Chat CSKH
        window.openLiveChatSupport = function() {
            openChat();
            switchTab('live');
        };

        // ----------------------------------------------------
        // TIỆN ÍCH ĐỊNH DẠNG
        // ----------------------------------------------------
        function formatTime(ts) {
            if (!ts) return '';
            try {
                const d = new Date(ts);
                return d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            } catch (e) {
                return '';
            }
        }

        function escapeHtml(str) {
            if (!str) return '';
            return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
        }

        function formatMarkdown(text) {
            if (!text) return '';
            let html = escapeHtml(text);
            html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
            html = html.replace(/\*(.*?)\*/g, '<em>$1</em>');
            html = html.replace(/(?:^|\n)[-*]\s+(.+)/g, '<br/>• $1');
            html = html.replace(/\n\n/g, '<br/><br/>');
            html = html.replace(/\n/g, '<br/>');

            // Chuyển link Markdown [Tên](/link) thành Nút bấm Mua hàng / Xem sản phẩm nổi bật
            html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, function(match, label, href) {
                let cleanHref = href.trim();
                if (cleanHref.startsWith('/') && !cleanHref.startsWith(contextPath + '/')) {
                    cleanHref = contextPath + cleanHref;
                }
                const isProductDetail = cleanHref.includes('/product-detail');
                const icon = isProductDetail ? 'shopping_cart' : 'storefront';
                return `<span class="block my-2"><a href="\${cleanHref}" class="inline-flex items-center gap-1.5 px-3.5 py-2 bg-gradient-to-r from-emerald-600 to-primary text-white hover:opacity-95 text-xs font-bold rounded-xl shadow-sm hover:shadow-md transition-all active:scale-95 no-underline cursor-pointer"><span class="material-symbols-outlined text-sm pointer-events-none">\${icon}</span>\${label}<span class="material-symbols-outlined text-xs pointer-events-none ml-0.5">arrow_forward</span></a></span>`;
            });

            return html;
        }

        function formatCurrency(val) {
            if (!val) return '0đ';
            return new Intl.NumberFormat('vi-VN').format(val) + 'đ';
        }

        // ----------------------------------------------------
        // HIỂN THỊ TIN NHẮN (ĐỢI RENDER XONG MỚI ĐẨY LÊN CHAT)
        // ----------------------------------------------------
        function appendAiUserMessage(msg) {
            if (!aiMessagesBox) return;
            const html = `
                <div class="flex justify-end items-end gap-1.5 my-2">
                    <div class="max-w-[80%]">
                        <div class="bg-gradient-to-r from-emerald-600 to-primary text-white p-2.5 px-3.5 rounded-2xl rounded-br-sm shadow-sm leading-relaxed text-xs break-words">
                            \${escapeHtml(msg)}
                        </div>
                    </div>
                </div>
            `;
            aiMessagesBox.insertAdjacentHTML('beforeend', html);
            aiMessagesBox.scrollTop = aiMessagesBox.scrollHeight;
        }

        function appendAiBotBubble(contentHtml) {
            if (!aiMessagesBox) return;
            const html = `
                <div class="flex items-start gap-2 my-2 animate-fadeIn">
                    <div class="w-7 h-7 rounded-full bg-emerald-500/20 text-emerald-600 flex items-center justify-center flex-shrink-0 text-xs font-bold shadow-sm mt-0.5">
                        <span class="material-symbols-outlined text-sm">smart_toy</span>
                    </div>
                    <div class="bg-surface-container-lowest border border-outline-variant p-3 rounded-2xl rounded-tl-sm max-w-[88%] shadow-sm text-on-surface leading-relaxed text-xs break-words">
                        \${contentHtml}
                    </div>
                </div>
            `;
            aiMessagesBox.insertAdjacentHTML('beforeend', html);
            aiMessagesBox.scrollTop = aiMessagesBox.scrollHeight;
            setTimeout(() => {
                if (aiMessagesBox) aiMessagesBox.scrollTop = aiMessagesBox.scrollHeight;
            }, 100);
        }

        function showAiTypingIndicator() {
            const id = 'ai-typing-' + Date.now();
            const html = `
                <div id="\${id}" class="flex items-start gap-2 my-2 ai-typing-indicator">
                    <div class="w-7 h-7 rounded-full bg-emerald-500/20 text-emerald-600 flex items-center justify-center flex-shrink-0 text-xs font-bold shadow-sm">
                        <span class="material-symbols-outlined text-sm">smart_toy</span>
                    </div>
                    <div class="bg-surface-container-lowest border border-outline-variant py-2.5 px-3.5 rounded-2xl rounded-tl-sm shadow-sm text-on-surface-variant flex items-center gap-1.5 text-xs">
                        <span class="w-1.5 h-1.5 rounded-full bg-primary animate-bounce"></span>
                        <span class="w-1.5 h-1.5 rounded-full bg-primary animate-bounce [animation-delay:0.2s]"></span>
                        <span class="w-1.5 h-1.5 rounded-full bg-primary animate-bounce [animation-delay:0.4s]"></span>
                        <span class="text-[11px] ml-1 text-on-surface-variant">Đang xử lý thông tin...</span>
                    </div>
                </div>
            `;
            aiMessagesBox.insertAdjacentHTML('beforeend', html);
            aiMessagesBox.scrollTop = aiMessagesBox.scrollHeight;
            return id;
        }

        function removeAiTypingIndicator(id) {
            const el = document.getElementById(id);
            if (el) el.remove();
        }

        // ----------------------------------------------------
        // BỘ RENDER PHẢN HỒI HOÀN CHỈNH (TRUY VẤN DB + AI)
        // ----------------------------------------------------
        function renderServerResponse(data, typingId) {
            // Xóa loading sau khi toàn bộ dữ liệu đã được nhận và sẵn sàng render
            removeAiTypingIndicator(typingId);
            if (aiSubmitBtn) aiSubmitBtn.disabled = false;

            // 1. Trường hợp trả về danh sách sản phẩm (Có đầy đủ ảnh, giá, link chi tiết)
            if (data.type === 'products' && data.products && data.products.length > 0) {
                let cardsHtml = `
                    <div class="font-bold text-primary mb-2">\${escapeHtml(data.title)}</div>
                    <div class="grid grid-cols-2 gap-2 mt-1">
                `;
                data.products.forEach(p => {
                    let img = p.imageUrl || '/assets/web/img/fruit-item-1.jpg';
                    if (!img.startsWith('http') && !img.startsWith(contextPath)) {
                        img = contextPath + img;
                    }
                    const hasDiscount = (p.discountPrice && p.discountPrice < p.price);
                    cardsHtml += `
                        <div class="bg-surface-container border border-outline-variant/80 rounded-xl p-2 flex flex-col justify-between hover:shadow-md transition-shadow group">
                            <a href="\${contextPath}/product-detail?id=\${p.id}" class="block overflow-hidden rounded-lg mb-1.5">
                                <img src="\${img}" alt="\${escapeHtml(p.name)}" class="w-full h-20 object-cover group-hover:scale-105 transition-transform" onerror="this.src='\${contextPath}/assets/uploads/no-image.svg'">
                            </a>
                            <a href="\${contextPath}/product-detail?id=\${p.id}" class="font-bold text-[11px] line-clamp-1 text-on-surface hover:text-primary transition-colors" title="\${escapeHtml(p.name)}">
                                \${escapeHtml(p.name)}
                            </a>
                            <div class="mt-1 flex items-baseline gap-1">
                                <span class="text-primary font-bold text-xs">\${formatCurrency(p.discountPrice || p.price)}</span>
                                \${hasDiscount ? `<span class="line-through text-[9px] text-on-surface-variant/70">\${formatCurrency(p.price)}</span>` : ''}
                            </div>
                            <a href="\${contextPath}/product-detail?id=\${p.id}" class="mt-2 block text-center py-1.5 px-2 bg-gradient-to-r from-emerald-600 to-primary text-white hover:opacity-90 text-[10px] font-bold rounded-lg transition-all shadow-2xs">
                                Xem chi tiết
                            </a>
                        </div>
                    `;
                });
                cardsHtml += `</div>`;
                cardsHtml += `
                    <div class="mt-2.5 pt-2 border-t border-outline-variant/60 text-center">
                        <a href="\${contextPath}/shop" class="text-primary hover:underline font-bold text-[11px] inline-flex items-center gap-1">
                            Xem tất cả sản phẩm tại Cửa hàng <span class="material-symbols-outlined text-xs">arrow_forward</span>
                        </a>
                    </div>
                `;
                appendAiBotBubble(cardsHtml);
                return;
            }

            // 2. Trường hợp hiển thị Form tra cứu đơn hàng
            if (data.type === 'prompt_tracking_form') {
                renderOrderTrackerForm(data.message);
                return;
            }

            // 3. Trường hợp hiển thị kết quả tra cứu tiến độ đơn hàng (4 bước)
            if (data.type === 'order_tracking') {
                const step = data.stepProgress || 1;
                let stepsHtml = `
                    <div class="relative flex items-center justify-between my-3 px-2">
                        <div class="absolute left-4 right-4 top-1/2 -translate-y-1/2 h-0.5 bg-outline-variant -z-0"></div>
                        <div class="relative z-10 flex flex-col items-center">
                            <span class="w-5 h-5 rounded-full flex items-center justify-center text-[10px] font-bold \${step >= 1 ? 'bg-primary text-white' : 'bg-surface-container-high text-on-surface-variant'}">1</span>
                            <span class="text-[9px] mt-1 text-on-surface-variant">Tiếp nhận</span>
                        </div>
                        <div class="relative z-10 flex flex-col items-center">
                            <span class="w-5 h-5 rounded-full flex items-center justify-center text-[10px] font-bold \${step >= 2 ? 'bg-primary text-white' : 'bg-surface-container-high text-on-surface-variant'}">2</span>
                            <span class="text-[9px] mt-1 text-on-surface-variant">Đóng gói</span>
                        </div>
                        <div class="relative z-10 flex flex-col items-center">
                            <span class="w-5 h-5 rounded-full flex items-center justify-center text-[10px] font-bold \${step >= 3 ? 'bg-primary text-white' : 'bg-surface-container-high text-on-surface-variant'}">3</span>
                            <span class="text-[9px] mt-1 text-on-surface-variant">Đang giao</span>
                        </div>
                        <div class="relative z-10 flex flex-col items-center">
                            <span class="w-5 h-5 rounded-full flex items-center justify-center text-[10px] font-bold \${step >= 4 ? 'bg-emerald-600 text-white' : 'bg-surface-container-high text-on-surface-variant'}">4</span>
                            <span class="text-[9px] mt-1 text-on-surface-variant">Hoàn tất</span>
                        </div>
                    </div>
                `;

                let resHtml = `
                    <div class="space-y-2">
                        <div class="flex items-center justify-between border-b border-outline-variant/60 pb-1.5">
                            <span class="font-bold text-primary text-xs">Mã đơn: \${escapeHtml(data.orderCode)}</span>
                            <span class="text-[10px] text-on-surface-variant">\${escapeHtml(data.orderDate)}</span>
                        </div>
                        \${stepsHtml}
                        <div class="bg-primary/5 p-2.5 rounded-xl border border-primary/20 space-y-1">
                            <div class="font-bold text-xs text-primary flex items-center gap-1">
                                <span class="material-symbols-outlined text-sm">local_shipping</span> \${escapeHtml(data.statusText)}
                            </div>
                            <p class="text-[11px] text-on-surface leading-relaxed">\${escapeHtml(data.statusDesc)}</p>
                        </div>
                        <div class="text-[11px] space-y-0.5 text-on-surface-variant pt-1">
                            <div>• <strong>Sản phẩm:</strong> \${escapeHtml(data.itemsSummary)}</div>
                            <div>• <strong>Khung giờ:</strong> \${escapeHtml(data.deliverySlot)}</div>
                            <div>• <strong>Tổng tiền:</strong> <span class="font-bold text-primary">\${formatCurrency(data.totalAmount)}</span></div>
                        </div>
                        <div class="pt-1.5 border-t border-outline-variant/60">
                            <a href="\${contextPath}\${data.trackingUrl}" class="text-[11px] text-primary hover:underline font-bold inline-flex items-center gap-1">
                                Xem hành trình chi tiết shipper <span class="material-symbols-outlined text-xs">arrow_forward</span>
                            </a>
                        </div>
                    </div>
                `;
                appendAiBotBubble(resHtml);
                return;
            }

            // 4. Trường hợp trả về cẩm nang bảo quản hoặc công thức nước ép
            if (data.type === 'preservation_guide' || data.type === 'recipe_guide') {
                let guideHtml = `
                    <div class="space-y-2">
                        <div class="font-bold text-primary text-xs">\${escapeHtml(data.title)}</div>
                        <div class="leading-relaxed text-[11.5px]">\${formatMarkdown(data.message)}</div>
                        <div class="mt-2 pt-2 border-t border-outline-variant/60 text-center">
                            <a href="\${contextPath}/shop" class="text-primary hover:underline font-bold text-[11px] inline-flex items-center gap-1">
                                Khám phá hoa quả tươi tại Cửa hàng <span class="material-symbols-outlined text-xs">arrow_forward</span>
                            </a>
                        </div>
                    </div>
                `;
                appendAiBotBubble(guideHtml);
                return;
            }

            // 5. Trường hợp text thông thường (từ Gemini AI)
            const reply = data.message || 'Dạ em chưa rõ câu hỏi, bạn thử chọn các gợi ý bên dưới nhé! 🍎';
            appendAiBotBubble(formatMarkdown(reply));
        }

        // Gửi câu hỏi lên Servlet
        function sendAiPrompt(text, actionName) {
            if (!text || !text.trim()) return;
            const query = text.trim();

            appendAiUserMessage(query);
            if (aiChatInput) aiChatInput.value = '';

            const typingId = showAiTypingIndicator();
            if (aiSubmitBtn) aiSubmitBtn.disabled = true;

            const payload = new URLSearchParams();
            payload.append('action', actionName || 'chat');
            payload.append('message', query);
            payload.append('history', JSON.stringify(aiHistory));

            fetch(contextPath + '/api/ai-chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: payload.toString()
            })
            .then(res => res.json())
            .then(data => {
                renderServerResponse(data, typingId);
                // Lưu context ngắn
                if (data.type === 'text' && data.message) {
                    aiHistory.push({ role: 'user', text: query });
                    aiHistory.push({ role: 'model', text: data.message });
                    if (aiHistory.length > 4) aiHistory = aiHistory.slice(aiHistory.length - 4);
                }
            })
            .catch(err => {
                removeAiTypingIndicator(typingId);
                if (aiSubmitBtn) aiSubmitBtn.disabled = false;
                appendAiBotBubble('Dạ đường truyền mạng đang bận một chút 🍎. Bạn vui lòng thử lại sau vài giây nhé!');
            });
        }

        // Form Tra Cứu Đơn Hàng trực tiếp trong chat
        function renderOrderTrackerForm(customPrompt) {
            const formId = 'order-track-form-' + Date.now();
            const promptText = customPrompt ? escapeHtml(customPrompt) : 'Bạn không cần nhớ mã đơn hàng! Chỉ cần nhập <strong>Số điện thoại</strong> và có thể kèm <strong>Tên sản phẩm</strong> đã đặt:';
            const html = `
                <div class="space-y-2">
                    <div class="font-bold text-primary flex items-center gap-1">
                        <span class="material-symbols-outlined text-base">package_2</span> Tra cứu tiến độ đơn hàng
                    </div>
                    <p class="text-[11px] text-on-surface-variant leading-relaxed">\${promptText}</p>
                    <form id="\${formId}" class="space-y-2 pt-1">
                        <div>
                            <input type="tel" name="trackPhone" placeholder="Nhập số điện thoại đặt hàng (*)" required
                                   class="w-full px-3 py-1.5 bg-surface-container rounded-lg border border-outline-variant text-xs outline-none focus:border-primary">
                        </div>
                        <div>
                            <input type="text" name="trackKeyword" placeholder="Tên sản phẩm (ví dụ: Nho, Táo, Bơ - Không bắt buộc)"
                                   class="w-full px-3 py-1.5 bg-surface-container rounded-lg border border-outline-variant text-xs outline-none focus:border-primary">
                        </div>
                        <button type="submit" class="w-full py-2 bg-gradient-to-r from-emerald-600 to-primary text-white rounded-lg text-xs font-bold hover:opacity-95 shadow-sm transition-all flex items-center justify-center gap-1">
                            <span class="material-symbols-outlined text-sm">search</span> Kiểm tra tiến độ ngay
                        </button>
                    </form>
                </div>
            `;
            appendAiBotBubble(html);

            setTimeout(() => {
                const frm = document.getElementById(formId);
                if (frm) {
                    frm.addEventListener('submit', function(e) {
                        e.preventDefault();
                        const phone = frm.elements['trackPhone'].value.trim();
                        const keyword = frm.elements['trackKeyword'].value.trim();
                        if (!phone) return;

                        appendAiUserMessage(`Tra cứu đơn hàng: SĐT \${phone} \${keyword ? ' - SP: ' + keyword : ''}`);
                        executeOrderTracking(phone, keyword);
                    });
                }
            }, 100);
        }

        function executeOrderTracking(phone, keyword) {
            const typingId = showAiTypingIndicator();

            const payload = new URLSearchParams();
            payload.append('action', 'track_order');
            payload.append('phone', phone);
            if (keyword) payload.append('keyword', keyword);

            fetch(contextPath + '/api/ai-chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: payload.toString()
            })
            .then(res => res.json())
            .then(data => {
                renderServerResponse(data, typingId);
            })
            .catch(err => {
                removeAiTypingIndicator(typingId);
                appendAiBotBubble('Có lỗi khi kết nối tra cứu đơn hàng. Bạn thử lại sau nhé!');
            });
        }

        // Bắt sự kiện click vào các Prompt Suggestions Chips
        document.addEventListener('click', function(e) {
            const btn = e.target.closest('.ai-quick-btn');
            if (!btn) return;

            const action = btn.getAttribute('data-action');
            const prompt = btn.getAttribute('data-prompt') || btn.innerText.replace(/^[^\p{L}\p{N}]+/u, '').trim();

            // 1. Điền nội dung vào thanh chat và focus để người dùng thấy rõ câu hỏi
            if (aiChatInput) {
                aiChatInput.value = prompt;
                aiChatInput.focus();
            }

            // 2. Tra cứu tiến độ đơn -> hiển thị form nhập SĐT
            if (action === 'open_tracker') {
                appendAiUserMessage('📦 ' + prompt);
                if (aiChatInput) aiChatInput.value = '';
                renderOrderTrackerForm();
                return;
            }

            // 3. Tự động gửi truy vấn để trả lời ngay lập tức
            sendAiPrompt(prompt, action);
        });

        // Bắt sự kiện submit form AI chat (gõ vào ô chat và nhấn Enter hoặc nút gửi)
        if (aiSendForm) {
            aiSendForm.addEventListener('submit', function(e) {
                e.preventDefault();
                if (!aiChatInput) return;
                const text = aiChatInput.value.trim();
                if (!text) return;
                sendAiPrompt(text);
            });
        }

        // ----------------------------------------------------
        // LIVE CHAT VỚI NHÂN VIÊN (GIỮ NGUYÊN CODE CŨ)
        // ----------------------------------------------------
        function fetchMessages() {
            if (!isLoggedIn) return;

            fetch(contextPath + '/api/chat')
                .then(res => res.json())
                .then(data => {
                    if (!data.authenticated) return;

                    const msgs = data.messages || [];
                    if (msgs.length !== lastMessageCount) {
                        renderMessages(msgs);
                        lastMessageCount = msgs.length;
                    }
                })
                .catch(err => console.error('Livechat error:', err));
        }

        // ----------------------------------------------------
        // XỬ LÝ UPLOAD ẢNH LIVE CHAT (KHÁCH HÀNG)
        // ----------------------------------------------------
        const chatFileInput = document.getElementById('chat-file-input');
        const chatAttachBtn = document.getElementById('chat-attach-btn');
        const chatImgPreviewBox = document.getElementById('chat-img-preview-box');
        const chatImgPreview = document.getElementById('chat-img-preview');
        const chatImgPreviewName = document.getElementById('chat-img-preview-name');
        const chatImgCancelBtn = document.getElementById('chat-img-cancel-btn');
        let selectedChatFile = null;

        if (chatAttachBtn && chatFileInput) {
            chatAttachBtn.addEventListener('click', function() {
                chatFileInput.click();
            });

            chatFileInput.addEventListener('change', function() {
                const file = this.files[0];
                if (!file) return;

                if (!file.type.startsWith('image/')) {
                    alert('Vui lòng chỉ chọn file hình ảnh (PNG, JPG, WEBP, GIF).');
                    this.value = '';
                    return;
                }

                if (file.size > 10 * 1024 * 1024) {
                    alert('Kích thước ảnh tối đa là 10MB.');
                    this.value = '';
                    return;
                }

                selectedChatFile = file;
                const reader = new FileReader();
                reader.onload = function(e) {
                    if (chatImgPreview) chatImgPreview.src = e.target.result;
                    if (chatImgPreviewName) chatImgPreviewName.innerText = file.name;
                    if (chatImgPreviewBox) {
                        chatImgPreviewBox.classList.remove('hidden');
                        chatImgPreviewBox.classList.add('flex');
                    }
                };
                reader.readAsDataURL(file);
            });
        }

        if (chatImgCancelBtn) {
            chatImgCancelBtn.addEventListener('click', function() {
                selectedChatFile = null;
                if (chatFileInput) chatFileInput.value = '';
                if (chatImgPreview) chatImgPreview.src = '';
                if (chatImgPreviewBox) {
                    chatImgPreviewBox.classList.add('hidden');
                    chatImgPreviewBox.classList.remove('flex');
                }
            });
        }

        window.openChatLightbox = function(url) {
            if (!url) return;
            const modal = document.getElementById('chat-lightbox-modal');
            const img = document.getElementById('chat-lightbox-img');
            if (modal && img) {
                img.src = url;
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            }
        };

        function renderMessages(msgs) {
            if (!messagesBox) return;

            const welcomeHtml = `
                <div class="flex items-start gap-2">
                    <div class="w-7 h-7 rounded-full bg-primary/20 text-primary flex items-center justify-center flex-shrink-0 text-xs font-bold">
                        <span class="material-symbols-outlined text-sm">eco</span>
                    </div>
                    <div class="bg-surface-container-lowest border border-outline-variant p-3 rounded-2xl rounded-tl-sm max-w-[80%] shadow-sm text-on-surface leading-relaxed">
                        Chào <strong class="text-primary">${not empty sessionScope.USERMODEL ? sessionScope.USERMODEL.fullName : 'bạn'}</strong>! Fruitables có thể giải đáp thông tin đơn hàng hoặc hỗ trợ tư vấn trái cây cho bạn như thế nào ạ? 🍎🍇
                    </div>
                </div>
            `;

            const msgsHtml = msgs.map(m => {
                const isUser = (m.senderType === 'USER');
                const hasImg = !!m.imageUrl;
                const imgHtml = hasImg ? `
                    <div class="mb-1.5 overflow-hidden rounded-xl cursor-pointer inline-block group" onclick="openChatLightbox('\${m.imageUrl}')">
                        <img src="\${m.imageUrl}" class="max-w-[200px] max-h-[160px] object-cover rounded-xl border border-white/20 shadow-xs group-hover:scale-105 transition-transform" alt="Ảnh đính kèm">
                    </div>
                ` : '';

                const textHtml = (m.message && m.message !== '[Hình ảnh]') ? `<div class="leading-relaxed text-xs break-words">\${escapeHtml(m.message)}</div>` : '';

                if (isUser) {
                    return `
                        <div class="flex justify-end items-end gap-1.5 my-2">
                            <div class="max-w-[78%]">
                                <div class="bg-primary text-white p-3 rounded-2xl rounded-br-sm shadow-sm">
                                    \${imgHtml}
                                    \${textHtml}
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
                                <div class="bg-surface-container-lowest border border-outline-variant p-3 rounded-2xl rounded-tl-sm shadow-sm text-on-surface">
                                    \${imgHtml}
                                    \${textHtml}
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

        if (sendForm) {
            sendForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const text = chatInput ? chatInput.value.trim() : '';
                if (!text && !selectedChatFile) return;

                const submitBtn = document.getElementById('chat-submit-btn');
                if (submitBtn) submitBtn.disabled = true;

                const formData = new FormData();
                formData.append('message', text || '');
                if (selectedChatFile) formData.append('chatImage', selectedChatFile);

                if (chatInput) chatInput.value = '';
                if (chatImgCancelBtn) chatImgCancelBtn.click();

                fetch(contextPath + '/api/chat', {
                    method: 'POST',
                    body: formData
                })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        fetchMessages();
                    } else if (data.message) {
                        alert(data.message);
                    }
                })
                .catch(err => console.error('Send message error:', err))
                .finally(() => {
                    if (submitBtn) submitBtn.disabled = false;
                });
            });
        }
    })();
</script>

<!-- LIGHTBOX XEM ẢNH FULL-SIZE TRONG CHAT -->
<div id="chat-lightbox-modal" class="hidden fixed inset-0 z-[9999] bg-black/85 backdrop-blur-md items-center justify-center p-4 cursor-pointer select-none" onclick="this.classList.add('hidden'); this.classList.remove('flex');">
    <div class="relative max-w-3xl max-h-[90vh]" onclick="event.stopPropagation()">
        <img id="chat-lightbox-img" src="" class="max-w-full max-h-[85vh] object-contain rounded-2xl shadow-2xl border border-white/20">
        <button type="button" onclick="document.getElementById('chat-lightbox-modal').classList.add('hidden'); document.getElementById('chat-lightbox-modal').classList.remove('flex');"
                class="absolute -top-3 -right-3 w-8 h-8 rounded-full bg-white text-slate-900 flex items-center justify-center shadow-xl hover:bg-slate-100 transition-colors cursor-pointer" title="Đóng">
            <span class="material-symbols-outlined text-lg font-bold pointer-events-none">close</span>
        </button>
    </div>
</div>