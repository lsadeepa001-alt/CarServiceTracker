<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("userRole");
    if (username == null) { response.sendRedirect("login.jsp"); return; }

    String appId = request.getParameter("appId");
    if (appId == null) { 
        response.sendRedirect("admin".equals(role) ? "manage_appointments.jsp" : "customer_dashboard.jsp"); 
        return; 
    }

    BookingManager bm = new BookingManager();
    Appointment app = bm.getAppointmentById(appId);
    if (app == null) { 
        response.sendRedirect("admin".equals(role) ? "manage_appointments.jsp" : "customer_dashboard.jsp"); 
        return; 
    }

    // Security check: Customer can only see their own chats
    if ("customer".equals(role) && !app.getCustomerUsername().equals(username)) {
        response.sendRedirect("customer_dashboard.jsp?error=unauthorized");
        return;
    }

    // Chat Window Expiration Check
    boolean isChatOpen = ChatManager.isChatWindowOpen(app.getCompletedDate(), 7);
    if (!isChatOpen) {
        response.sendRedirect("admin".equals(role) ? "manage_appointments.jsp?error=chatExpired" : "customer_dashboard.jsp?error=chatExpired");
        return;
    }
    long daysLeft = ChatManager.getRemainingDays(app.getCompletedDate(), 7);

    ChatManager chatManager = new ChatManager();
    
    // Auto-mark messages as read when opening chat
    if (chatManager.getUnreadCountForUser(appId, role) > 0) {
        String receiptId = "RD" + System.currentTimeMillis();
        String timestamp = java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
        ChatMessage readReceipt = new ChatMessage(receiptId, appId, role, username, "__READ__", timestamp);
        chatManager.sendMessage(readReceipt);
    }
    
    List<ChatMessage> messages = chatManager.getMessagesByAppointmentId(appId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat - Appointment <%= appId %> - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Plus Jakarta Sans', sans-serif; }
        .chat-container { height: calc(100vh - 350px); }
        .message-bubble { max-width: 80%; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .animate-fade-in { animation: fadeIn 0.3s ease forwards; }
    </style>
</head>
<body class="antialiased text-slate-900 dark:text-slate-100 bg-slate-50 dark:bg-slate-950 transition-colors duration-300 min-h-screen pt-28 pb-10">
<% if ("admin".equals(role)) { %>
    <%@ include file="navbar.jsp" %>
<% } else { %>
    <%@ include file="customer_navbar.jsp" %>
<% } %>

<div class="max-w-4xl mx-auto px-4">
    <!-- CHAT HEADER -->
    <div class="bg-white dark:bg-slate-900 rounded-[2.5rem] border border-slate-100 dark:border-slate-800 p-8 shadow-2xl shadow-slate-200/40 dark:shadow-none mb-6">
        <div class="flex flex-col md:flex-row justify-between items-center gap-6">
            <div class="flex items-center gap-6">
                <div class="w-16 h-16 rounded-2xl bg-indigo-600 flex items-center justify-center text-white shadow-xl shadow-indigo-100 dark:shadow-none">
                    <i class="fa-solid fa-comments text-2xl"></i>
                </div>
                <div>
                    <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tighter leading-none flex items-center gap-3">
                        Appointment Chat
                        <span class="mono text-[10px] font-black px-4 py-1.5 rounded-xl bg-indigo-50 dark:bg-indigo-950 text-indigo-600 dark:text-indigo-400 border border-indigo-100 dark:border-indigo-800/50 uppercase tracking-widest"><%= app.getLicensePlate() %></span>
                        <% if ("Completed".equals(app.getStatus())) { %>
                            <span class="mono text-[10px] font-black px-4 py-1.5 rounded-xl bg-emerald-50 dark:bg-emerald-950 text-emerald-600 dark:text-emerald-400 border border-emerald-100 dark:border-emerald-800/50 uppercase tracking-widest"><%= daysLeft %> Days Left</span>
                        <% } %>
                    </h1>
                    <p class="mt-2 text-sm font-medium text-slate-500 dark:text-slate-400">Discussing: <%= app.getIssueDescription() %></p>
                </div>
            </div>
            <div class="flex items-center gap-3">
                <button onclick="location.reload()" class="w-12 h-12 rounded-2xl bg-slate-50 dark:bg-slate-950 border border-slate-100 dark:border-slate-800 text-slate-400 hover:text-indigo-600 transition-all flex items-center justify-center shadow-sm">
                    <i class="fa-solid fa-rotate"></i>
                </button>
                <a href="<%= "admin".equals(role) ? "manage_appointments.jsp" : "customer_dashboard.jsp" %>" class="px-6 py-3 rounded-2xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 text-[10px] font-black uppercase tracking-widest hover:bg-slate-200 dark:hover:bg-slate-700 transition-all">Back</a>
            </div>
        </div>
    </div>

    <!-- CHAT MESSAGES -->
    <div class="bg-white dark:bg-slate-900 rounded-[3rem] border border-slate-100 dark:border-slate-800 shadow-2xl shadow-slate-200/40 dark:shadow-none flex flex-col overflow-hidden">
        <div class="chat-container overflow-y-auto p-10 space-y-6 no-scrollbar" id="chatStream">
            <% if (messages.isEmpty()) { %>
                <div class="h-full flex flex-col items-center justify-center text-center opacity-40">
                    <div class="w-24 h-24 bg-slate-50 dark:bg-slate-950 rounded-full flex items-center justify-center mb-6">
                        <i class="fa-solid fa-message text-4xl"></i>
                    </div>
                    <p class="font-black text-xs uppercase tracking-widest">No messages yet. Start the conversation!</p>
                </div>
            <% } else { 
                for (ChatMessage msg : messages) {
                    if ("__READ__".equals(msg.getMessage())) continue;
                    boolean isMe = msg.getSenderUsername().equals(username);
            %>
                <div class="flex <%= isMe ? "justify-end" : "justify-start" %> animate-fade-in">
                    <div class="message-bubble flex flex-col <%= isMe ? "items-end" : "items-start" %>">
                        <div class="px-6 py-4 rounded-[2rem] shadow-lg <%= isMe ? "bg-indigo-600 text-white rounded-tr-none" : "bg-slate-100 dark:bg-slate-800 text-slate-800 dark:text-white rounded-tl-none" %>">
                            <p class="text-sm font-medium leading-relaxed"><%= msg.getMessage() %></p>
                        </div>
                        <span class="mt-2 text-[9px] font-black text-slate-400 dark:text-slate-600 uppercase tracking-widest"><%= isMe ? "You" : msg.getSenderUsername() %> • <%= msg.getTimestamp() %></span>
                    </div>
                </div>
            <% } } %>
        </div>

        <!-- INPUT AREA -->
        <div class="p-8 border-t border-slate-50 dark:border-slate-800 bg-slate-50/50 dark:bg-slate-950/50">
            <form action="SendChatMessageServlet" method="POST" class="relative group">
                <input type="hidden" name="appointmentId" value="<%= appId %>">
                <textarea name="message" required rows="1" placeholder="Type your message here..." 
                    class="w-full pl-8 pr-32 py-5 bg-white dark:bg-slate-900 border-2 border-transparent dark:border-slate-800 rounded-[2rem] text-sm font-black focus:ring-8 focus:ring-indigo-500/10 focus:border-indigo-500 outline-none transition-all placeholder:text-slate-400 dark:placeholder:text-slate-800 shadow-inner resize-none"></textarea>
                <div class="absolute right-3 top-1/2 -translate-y-1/2">
                    <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-black text-[9px] uppercase tracking-[0.2em] px-8 py-3.5 rounded-2xl shadow-xl transition-all active:scale-95 flex items-center gap-3">
                        Send <i class="fa-solid fa-paper-plane text-xs"></i>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Auto-scroll to bottom
    const stream = document.getElementById('chatStream');
    stream.scrollTop = stream.scrollHeight;

    // Optional: Refresh every 30 seconds for new messages
    // setInterval(() => { location.reload(); }, 30000);
</script>
</body>
</html>
