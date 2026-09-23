<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html class="light" lang="vi">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Live Chat CSKH - Fruitables Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/web/css/style.css">
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <script src="${pageContext.request.contextPath}/assets/web/js/tailwind-config.js"></script>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body class="bg-[#f8fafc] text-on-surface font-body-md flex h-screen overflow-hidden">

<!-- SIDEBAR CHUẨN ĐỒNG BỘ -->
<jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp" />


<main class="flex-1 flex flex-col h-screen overflow-hidden">
  <!-- Header -->
  <header class="h-20 bg-surface flex items-center justify-between px-6 shadow-sm z-10 flex-shrink-0 border-b border-surface-variant">
    <div class="flex items-center gap-3">
      <span class="material-symbols-outlined text-primary text-2xl">chat</span>
      <h1 class="font-headline-md text-lg font-bold text-on-surface">Trung tâm Tư vấn Trực tuyến (Live Chat)</h1>
    </div>
    <div class="flex items-center gap-4">
      <span class="font-label-bold text-sm text-on-surface">${sessionScope.USERMODEL.fullName != null ? sessionScope.USERMODEL.fullName : 'Nhân viên CSKH'}</span>
      <a href="${pageContext.request.contextPath}/logout" class="p-2 text-error hover:bg-error-container rounded-full transition-colors" title="Đăng xuất">
        <span class="material-symbols-outlined">logout</span>
      </a>
    </div>
  </header>

  <!-- Chat Workspace (2 Columns) -->
  <div class="flex-1 flex overflow-hidden p-6 gap-6">
    
    <!-- Cột Trái: Danh sách hội thoại khách hàng (340px) -->
    <div class="w-80 md:w-96 bg-surface-container-lowest rounded-2xl shadow-sm border border-outline-variant flex flex-col overflow-hidden">
      <!-- Search & Title -->
      <div class="p-4 border-b border-surface-variant bg-surface-container-low">
        <div class="flex items-center justify-between mb-3">
          <h2 class="font-label-bold text-sm text-on-surface font-bold flex items-center gap-1.5">
            <span class="material-symbols-outlined text-primary text-lg">forum</span> Hội thoại khách hàng
          </h2>
          <span id="active-conv-count" class="text-xs bg-primary/10 text-primary font-bold px-2 py-0.5 rounded-full">0</span>
        </div>
        <div class="relative">
          <input type="text" id="search-customer" placeholder="Tìm theo tên khách..."
                 class="w-full pl-9 pr-3 py-2 bg-surface-container-lowest border border-outline-variant rounded-xl text-xs focus:border-primary outline-none text-on-surface">
          <span class="material-symbols-outlined text-xs absolute left-3 top-2.5 text-on-surface-variant">search</span>
        </div>
      </div>

      <!-- Conversations List -->
      <div id="conversation-list" class="flex-1 overflow-y-auto divide-y divide-surface-variant">
        <div class="p-8 text-center text-xs text-on-surface-variant">Đang tải danh sách hội thoại...</div>
      </div>
    </div>

    <!-- Cột Phải: Khung Chat Chi Tiết -->
    <div class="flex-1 bg-surface-container-lowest rounded-2xl shadow-sm border border-outline-variant flex flex-col overflow-hidden">
      
      <!-- Trạng thái chờ (Khi chưa chọn khách hàng) -->
      <div id="no-chat-selected" class="flex-1 flex flex-col items-center justify-center text-center p-8">
        <div class="w-20 h-20 rounded-3xl bg-primary/10 text-primary flex items-center justify-center mb-4">
          <span class="material-symbols-outlined text-5xl">mark_chat_unread</span>
        </div>
        <h3 class="font-headline-md text-lg font-bold text-on-surface mb-2">Chưa chọn cuộc hội thoại nào</h3>
        <p class="text-xs text-on-surface-variant max-w-md leading-relaxed">
          Hãy nhấp chọn một khách hàng từ danh sách bên trái để xem lịch sử trao đổi và phản hồi tư vấn trực tiếp cho khách hàng.
        </p>
      </div>

      <!-- Trạng thái đang chat -->
      <div id="chat-active-panel" class="hidden flex-1 flex flex-col h-full overflow-hidden">
        <!-- Chat Detail Header -->
        <div class="p-4 border-b border-surface-variant flex items-center justify-between bg-surface-container-low flex-shrink-0">
          <div class="flex items-center gap-3">
            <div id="current-user-avatar" class="w-11 h-11 rounded-full bg-primary/20 text-primary font-bold flex items-center justify-center text-sm">
              U
            </div>
            <div>
              <h3 id="current-user-name" class="font-label-bold text-sm text-on-surface font-bold">Tên khách hàng</h3>
              <div class="flex items-center gap-3 text-xs text-on-surface-variant mt-0.5">
                <span id="current-user-phone" class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">call</span> --</span>
                <span id="current-user-email" class="flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">mail</span> --</span>
              </div>
            </div>
          </div>
          <div class="flex items-center gap-2">
            <span class="px-2.5 py-1 rounded-full bg-emerald-100 text-emerald-700 text-xs font-semibold flex items-center gap-1">
              <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span> Đang kết nối
            </span>
          </div>
        </div>

        <!-- Chat Messages Area -->
        <div id="admin-chat-messages" class="flex-1 overflow-y-auto p-6 space-y-4 bg-slate-50/50 text-xs">
          <!-- Messages will be rendered here -->
        </div>

        <!-- Chat Reply Input Footer -->
        <form id="admin-reply-form" class="p-4 border-t border-surface-variant bg-surface-container-lowest flex flex-col gap-2 flex-shrink-0">
          <!-- Image Preview Container -->
          <div id="admin-img-preview-box" class="hidden items-center gap-2 p-1.5 bg-surface-container rounded-xl border border-outline-variant w-fit max-w-[220px]">
            <img id="admin-img-preview" src="" class="w-12 h-12 object-cover rounded-lg border border-outline-variant">
            <span id="admin-img-preview-name" class="text-[10px] text-on-surface truncate max-w-[100px]"></span>
            <button type="button" id="admin-img-cancel-btn" class="text-error hover:bg-error/10 p-1 rounded-full transition-colors ml-1 cursor-pointer" title="Hủy ảnh">
              <span class="material-symbols-outlined text-sm">close</span>
            </button>
          </div>

          <div class="flex items-center gap-3">
            <input type="file" id="admin-chat-file-input" accept="image/png,image/jpeg,image/webp,image/gif" class="hidden">
            <button type="button" id="admin-chat-attach-btn" class="w-11 h-11 rounded-xl bg-surface-container-low hover:bg-surface-container text-on-surface-variant hover:text-primary flex items-center justify-center transition-all flex-shrink-0 border border-outline-variant cursor-pointer" title="Đính kèm hình ảnh gửi khách">
              <span class="material-symbols-outlined text-xl">image</span>
            </button>
            <input type="text" id="admin-reply-input" placeholder="Nhập câu trả lời tư vấn cho khách hàng..." autocomplete="off"
                   class="flex-1 px-4 py-3 bg-surface-container-low rounded-xl border border-outline-variant focus:border-primary outline-none text-xs text-on-surface">
            <button type="submit" class="px-5 py-3 bg-primary hover:bg-primary-container text-white rounded-xl font-label-bold text-xs flex items-center gap-2 transition-colors shadow-sm cursor-pointer active:scale-95">
              <span>Gửi</span>
              <span class="material-symbols-outlined text-sm">send</span>
            </button>
          </div>
        </form>
      </div>

    </div>

  </div>
</main>

<script>
  let selectedUserId = null;
  let selectedUserObj = null;
  let conversations = [];
  let pollInterval = null;
  let lastMessageLength = 0;

  const convListEl = document.getElementById('conversation-list');
  const noChatEl = document.getElementById('no-chat-selected');
  const activeChatEl = document.getElementById('chat-active-panel');
  const msgsBox = document.getElementById('admin-chat-messages');
  const replyForm = document.getElementById('admin-reply-form');
  const replyInput = document.getElementById('admin-reply-input');
  const searchInput = document.getElementById('search-customer');

  function formatTimestamp(ts) {
    if (!ts) return '';
    try {
      const d = new Date(ts);
      return d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) + ' ' + d.toLocaleDateString([], { day: '2-digit', month: '2-digit' });
    } catch (e) {
      return '';
    }
  }

  function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
  }

  function loadConversations() {
    fetch('${pageContext.request.contextPath}/api/chat?action=conversations')
      .then(r => r.json())
      .then(data => {
        if (!data.authenticated || !data.isAdmin) return;
        conversations = data.conversations || [];
        document.getElementById('active-conv-count').innerText = conversations.length;
        renderConversationList();
      })
      .catch(console.error);
  }

  function renderConversationList() {
    const filterText = (searchInput.value || '').toLowerCase().trim();
    const filtered = conversations.filter(c => {
      const name = (c.fullName || '').toLowerCase();
      const phone = (c.phone || '').toLowerCase();
      return name.includes(filterText) || phone.includes(filterText);
    });

    if (filtered.length === 0) {
      convListEl.innerHTML = `
        <div class="p-8 text-center text-xs text-on-surface-variant">
          <span class="material-symbols-outlined text-3xl text-surface-variant block mb-2">chat_bubble_outline</span>
          Không có cuộc hội thoại nào phù hợp.
        </div>
      `;
      return;
    }

    convListEl.innerHTML = filtered.map(c => {
      const isSelected = (selectedUserId === c.userId);
      const activeClass = isSelected ? 'bg-primary/10 border-l-4 border-primary' : 'hover:bg-surface-container';
      const unreadBadge = (c.unreadCount > 0)
        ? `<span class="px-2 py-0.5 text-[10px] font-bold bg-error text-white rounded-full">\${c.unreadCount}</span>`
        : '';
      const initial = (c.fullName || 'Khách').charAt(0).toUpperCase();

      return `
        <div class="p-3.5 flex items-start gap-3 cursor-pointer transition-colors \${activeClass}" onclick="selectConversation(\${c.userId})">
          <div class="w-10 h-10 rounded-full bg-emerald-100 text-primary font-bold flex items-center justify-center flex-shrink-0 text-sm">
            \${initial}
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center justify-between gap-1 mb-1">
              <h4 class="text-xs font-bold text-on-surface truncate">\${escapeHtml(c.fullName || 'Khách hàng')}</h4>
              <span class="text-[10px] text-on-surface-variant/70 whitespace-nowrap">\${formatTimestamp(c.lastMessageTime || c.lastTime)}</span>
            </div>
            <div class="flex items-center justify-between gap-2">
              <p class="text-[11px] text-on-surface-variant truncate flex-1">\${escapeHtml(c.lastMessage || '')}</p>
              \${unreadBadge}
            </div>
          </div>
        </div>
      `;
    }).join('');
  }

  function selectConversation(userId) {
    selectedUserId = userId;
    selectedUserObj = conversations.find(c => c.userId === userId) || {};

    noChatEl.classList.add('hidden');
    activeChatEl.classList.remove('hidden');

    document.getElementById('current-user-name').innerText = selectedUserObj.fullName || 'Khách hàng #' + userId;
    document.getElementById('current-user-phone').innerHTML = `<span class="material-symbols-outlined text-[14px]">call</span> ` + (selectedUserObj.phone || 'Chưa cập nhật');
    document.getElementById('current-user-email').innerHTML = `<span class="material-symbols-outlined text-[14px]">mail</span> ` + (selectedUserObj.email || 'Chưa cập nhật');
    document.getElementById('current-user-avatar').innerText = (selectedUserObj.fullName || 'K').charAt(0).toUpperCase();

    renderConversationList();
    fetchMessagesForCurrent();
    if (replyInput) replyInput.focus();
  }

  function fetchMessagesForCurrent() {
    if (!selectedUserId) return;

    fetch('${pageContext.request.contextPath}/api/chat?targetUserId=' + selectedUserId)
      .then(r => r.json())
      .then(data => {
        const msgs = data.messages || [];
        if (msgs.length !== lastMessageLength) {
          renderMessages(msgs);
          lastMessageLength = msgs.length;
        }
      })
      .catch(console.error);
  }

  // ----------------------------------------------------
  // XỬ LÝ UPLOAD ẢNH LIVE CHAT (ADMIN PHẢN HỒI)
  // ----------------------------------------------------
  const adminChatFileInput = document.getElementById('admin-chat-file-input');
  const adminChatAttachBtn = document.getElementById('admin-chat-attach-btn');
  const adminImgPreviewBox = document.getElementById('admin-img-preview-box');
  const adminImgPreview = document.getElementById('admin-img-preview');
  const adminImgPreviewName = document.getElementById('admin-img-preview-name');
  const adminImgCancelBtn = document.getElementById('admin-img-cancel-btn');
  let selectedAdminChatFile = null;

  if (adminChatAttachBtn && adminChatFileInput) {
    adminChatAttachBtn.addEventListener('click', function() {
      adminChatFileInput.click();
    });

    adminChatFileInput.addEventListener('change', function() {
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

      selectedAdminChatFile = file;
      const reader = new FileReader();
      reader.onload = function(e) {
        if (adminImgPreview) adminImgPreview.src = e.target.result;
        if (adminImgPreviewName) adminImgPreviewName.innerText = file.name;
        if (adminImgPreviewBox) {
          adminImgPreviewBox.classList.remove('hidden');
          adminImgPreviewBox.classList.add('flex');
        }
      };
      reader.readAsDataURL(file);
    });
  }

  if (adminImgCancelBtn) {
    adminImgCancelBtn.addEventListener('click', function() {
      selectedAdminChatFile = null;
      if (adminChatFileInput) adminChatFileInput.value = '';
      if (adminImgPreview) adminImgPreview.src = '';
      if (adminImgPreviewBox) {
        adminImgPreviewBox.classList.add('hidden');
        adminImgPreviewBox.classList.remove('flex');
      }
    });
  }

  window.openAdminChatLightbox = function(url) {
    if (!url) return;
    const modal = document.getElementById('admin-chat-lightbox-modal');
    const img = document.getElementById('admin-chat-lightbox-img');
    if (modal && img) {
      img.src = url;
      modal.classList.remove('hidden');
      modal.classList.add('flex');
    }
  };

  function renderMessages(msgs) {
    if (!msgsBox) return;

    if (msgs.length === 0) {
      msgsBox.innerHTML = `
        <div class="p-8 text-center text-xs text-on-surface-variant">Chưa có tin nhắn nào trong cuộc trò chuyện này.</div>
      `;
      return;
    }

    msgsBox.innerHTML = msgs.map(m => {
      const isAdmin = (m.senderType === 'ADMIN');
      const hasImg = !!m.imageUrl;
      const imgHtml = hasImg ? `
        <div class="mb-1.5 overflow-hidden rounded-xl cursor-pointer inline-block group" onclick="openAdminChatLightbox('\${m.imageUrl}')">
          <img src="\${m.imageUrl}" class="max-w-[240px] max-h-[180px] object-cover rounded-xl border border-slate-200 shadow-xs group-hover:scale-105 transition-transform" alt="Ảnh đính kèm">
        </div>
      ` : '';

      const textHtml = (m.message && m.message !== '[Hình ảnh]') ? `<div class="leading-relaxed text-xs break-words">\${escapeHtml(m.message)}</div>` : '';

      if (isAdmin) {
        return `
          <div class="flex justify-end items-end gap-2">
            <div class="max-w-[70%]">
              <div class="bg-primary text-white p-3.5 rounded-2xl rounded-br-sm shadow-sm">
                \${imgHtml}
                \${textHtml}
              </div>
              <div class="text-[10px] text-on-surface-variant/70 text-right mt-0.5 px-1">\${formatTimestamp(m.createdAt)} (Bạn)</div>
            </div>
          </div>
        `;
      } else {
        return `
          <div class="flex items-start gap-2.5">
            <div class="w-8 h-8 rounded-full bg-slate-200 text-on-surface font-bold flex items-center justify-center text-xs flex-shrink-0">
              \${(selectedUserObj && selectedUserObj.fullName) ? selectedUserObj.fullName.charAt(0).toUpperCase() : 'K'}
            </div>
            <div class="max-w-[70%]">
              <div class="bg-white border border-outline-variant p-3.5 rounded-2xl rounded-tl-sm shadow-sm text-on-surface">
                \${imgHtml}
                \${textHtml}
              </div>
              <div class="text-[10px] text-on-surface-variant/70 mt-0.5 px-1">\${formatTimestamp(m.createdAt)}</div>
            </div>
          </div>
        `;
      }
    }).join('');

    msgsBox.scrollTop = msgsBox.scrollHeight;
  }

  // Submit reply
  replyForm.addEventListener('submit', function(e) {
    e.preventDefault();
    if (!selectedUserId) return;
    const text = replyInput ? replyInput.value.trim() : '';
    if (!text && !selectedAdminChatFile) return;

    const replyBtn = replyForm.querySelector('button[type="submit"]');
    if (replyBtn) replyBtn.disabled = true;

    const formData = new FormData();
    formData.append('targetUserId', selectedUserId);
    formData.append('message', text || '');
    if (selectedAdminChatFile) formData.append('chatImage', selectedAdminChatFile);

    if (replyInput) replyInput.value = '';
    if (adminImgCancelBtn) adminImgCancelBtn.click();

    fetch('${pageContext.request.contextPath}/api/chat', {
      method: 'POST',
      body: formData
    })
    .then(r => r.json())
    .then(data => {
      if (data.success) {
        fetchMessagesForCurrent();
        loadConversations();
      } else if (data.message) {
        alert(data.message);
      }
    })
    .catch(console.error)
    .finally(() => {
      if (replyBtn) replyBtn.disabled = false;
    });
  });

  searchInput.addEventListener('input', renderConversationList);

  // Khởi động
  loadConversations();
  setInterval(() => {
    loadConversations();
    if (selectedUserId) {
      fetchMessagesForCurrent();
    }
  }, 2500);
</script>

<!-- LIGHTBOX XEM ẢNH FULL-SIZE TRONG ADMIN CHAT -->
<div id="admin-chat-lightbox-modal" class="hidden fixed inset-0 z-[9999] bg-black/85 backdrop-blur-md items-center justify-center p-4 cursor-pointer select-none" onclick="this.classList.add('hidden'); this.classList.remove('flex');">
  <div class="relative max-w-4xl max-h-[90vh]" onclick="event.stopPropagation()">
    <img id="admin-chat-lightbox-img" src="" class="max-w-full max-h-[85vh] object-contain rounded-2xl shadow-2xl border border-white/20">
    <button type="button" onclick="document.getElementById('admin-chat-lightbox-modal').classList.add('hidden'); document.getElementById('admin-chat-lightbox-modal').classList.remove('flex');"
            class="absolute -top-3 -right-3 w-8 h-8 rounded-full bg-white text-slate-900 flex items-center justify-center shadow-xl hover:bg-slate-100 transition-colors cursor-pointer" title="Đóng">
      <span class="material-symbols-outlined text-lg font-bold pointer-events-none">close</span>
    </button>
  </div>
</div>
</body>
</html>
