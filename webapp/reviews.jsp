<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.FeedbackManager, model.Feedback, java.util.List, java.util.ArrayList" %>
<%
    String role = (String) session.getAttribute("userRole");
    String username = (String) session.getAttribute("username");
    boolean isAdmin = "admin".equals(role);
    boolean isCustomer = username != null && !isAdmin;

    FeedbackManager manager = new FeedbackManager();
    List<Feedback> allFb = manager.getAllFeedback();
    List<Feedback> approved = manager.getApprovedFeedback();

    List<Feedback> myFb = new ArrayList<>();
    if (isCustomer) {
        for (Feedback fb : allFb) {
            if (fb.getCustomerUsername().equals(username)) myFb.add(fb);
        }
    }

    int total = approved.size();
    double avgRating = 0;
    int[] dist = new int[6];
    if (total > 0) {
        int sum = 0;
        for (Feedback fb : approved) { sum += fb.getRating(); dist[fb.getRating()]++; }
        avgRating = (double) sum / total;
    }

    int awaitingCount = 0, posCount = 0, negCount = 0, pendingApproval = 0;
    if (isAdmin) {
        for (Feedback fb : allFb) {
            if ("none".equals(fb.getAdminReply())) awaitingCount++;
            if (!fb.isApproved()) pendingApproval++;
            if (fb.getRating() >= 4) posCount++; else if (fb.getRating() <= 2) negCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reviews Hub - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Plus Jakarta Sans', sans-serif; }
        .mono { font-family: 'JetBrains Mono', monospace; }
        .review-card { transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1); }
        .review-card:hover { transform: translateY(-8px); }
        .fb-card { transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1); }
        .fb-card:hover { transform: translateY(-6px); }
        .filter-pill { transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); cursor: pointer; }
        .filter-pill.active { background: #6366f1 !important; color: #fff !important; box-shadow: 0 10px 30px -5px rgba(99, 102, 241, 0.4); border-color: transparent !important; }
        .stat-card { transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); }
        .stat-card:hover { transform: translateY(-4px); }
        .rating-stars { display: flex; flex-direction: row-reverse; justify-content: flex-end; gap: 0.5rem; }
        .rating-stars input { display: none; }
        .rating-stars label { cursor: pointer; color: #e2e8f0; font-size: 2.25rem; transition: all 0.3s; }
        .dark .rating-stars label { color: #1e293b; }
        .rating-stars input:checked ~ label, .rating-stars label:hover, .rating-stars label:hover ~ label { color: #facc15; transform: scale(1.15); }
        @keyframes slideUp { from{opacity:0;transform:translateY(30px)} to{opacity:1;transform:translateY(0)} }
        .animate-slide-up { animation: slideUp 0.7s cubic-bezier(0.4, 0, 0.2, 1) forwards; }
    </style>
</head>
<body class="antialiased text-slate-900 dark:text-slate-100 bg-slate-50 dark:bg-slate-950 transition-colors duration-300 min-h-screen pt-28 pb-20">
<% if (isAdmin) { %>
    <%@ include file="navbar.jsp" %>
<% } else if (isCustomer) { %>
    <%@ include file="customer_navbar.jsp" %>
<% } else { %>
    <nav class="fixed top-0 w-full bg-white/80 dark:bg-slate-950/80 backdrop-blur-md z-[100] h-20 border-b border-slate-100 dark:border-slate-800 flex items-center px-8">
        <a href="index.jsp" class="text-xl font-black tracking-tighter">SwiftDrive</a>
    </nav>
<% } %>

<div class="max-w-7xl mx-auto px-4">

    <!-- ═══════════════════════════════════════════ -->
    <!-- SECTION 1: HERO RATING SUMMARY             -->
    <!-- ═══════════════════════════════════════════ -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 md:gap-8 lg:gap-12 mb-12 md:mb-16 items-center animate-slide-up">
        <div class="lg:col-span-1">
            <h1 class="text-3xl sm:text-4xl lg:text-5xl font-black text-slate-900 dark:text-white tracking-tighter leading-[0.9] mb-4">
                Loved by <br/><span class="text-indigo-600">thousands</span> of drivers.
            </h1>
            <p class="text-sm sm:text-base font-medium text-slate-500 dark:text-slate-400">Our commitment to excellence reflected in the words of our community.</p>
            <% if (isCustomer) { %>
            <a href="customer_dashboard.jsp" class="mt-6 inline-flex items-center gap-2 bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-3 rounded-xl font-black text-[10px] uppercase tracking-widest shadow-xl shadow-indigo-200 dark:shadow-none transition-all active:scale-95">
                <i class="fa-solid fa-pen-to-square text-base"></i> Leave a Review
            </a>
            <% } %>
        </div>
        <div class="lg:col-span-2 bg-white dark:bg-slate-900 rounded-2xl sm:rounded-3xl border border-slate-100 dark:border-slate-800 p-6 sm:p-8 shadow-2xl shadow-slate-200/40 dark:shadow-none flex flex-col sm:flex-row items-center gap-8 md:gap-12">
            <div class="text-center flex-shrink-0">
                <p class="text-5xl sm:text-6xl lg:text-7xl font-black text-slate-900 dark:text-white tracking-tighter"><%= String.format("%.1f", avgRating) %></p>
                <div class="flex justify-center text-amber-500 gap-1.5 mt-3 mb-1">
                    <% for(int i=1; i<=5; i++) { %>
                        <i class="<%= i <= Math.round(avgRating) ? "fa-solid" : "fa-regular" %> fa-star text-base"></i>
                    <% } %>
                </div>
                <p class="text-[9px] font-black text-slate-400 dark:text-slate-600 uppercase tracking-widest">Based on <%= total %> reviews</p>
            </div>
            <div class="flex-1 w-full space-y-2">
                <% for(int i=5; i>=1; i--) { int pct = total > 0 ? (dist[i] * 100 / total) : 0; %>
                <div class="flex items-center gap-3">
                    <span class="text-[9px] font-black text-slate-400 w-5"><%= i %>★</span>
                    <div class="flex-1 h-2 bg-slate-50 dark:bg-slate-950 rounded-full overflow-hidden border border-slate-100 dark:border-slate-800">
                        <div class="h-full bg-indigo-500 rounded-full transition-all" style="width: <%= pct %>%"></div>
                    </div>
                    <span class="text-[9px] font-black text-slate-900 dark:text-white w-8 text-right"><%= pct %>%</span>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- ═══════════════════════════════════════════ -->
    <!-- SECTION 2: PUBLIC REVIEW WALL               -->
    <!-- ═══════════════════════════════════════════ -->
    <div class="mb-12 md:mb-16">
        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6 sm:mb-8">
            <h2 class="text-[10px] font-black text-slate-400 uppercase tracking-[0.3em] flex items-center gap-3"><i class="fa-solid fa-globe text-indigo-500"></i> Community Reviews</h2>
            <div class="flex flex-wrap gap-1.5 sm:gap-2 w-full sm:w-auto" id="starFilterContainer">
                <button class="filter-pill active text-[9px] font-black uppercase tracking-widest px-4 py-2 rounded-lg bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 shadow-sm" onclick="filterStars(this,'all')">All</button>
                <% for(int i=5; i>=1; i--) { %>
                <button class="filter-pill text-[9px] font-black uppercase tracking-widest px-3.5 py-2 rounded-lg bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 shadow-sm" onclick="filterStars(this,'<%= i %>')"><%= i %>★</button>
                <% } %>
            </div>
        </div>
        <div class="columns-1 sm:columns-2 lg:columns-3 gap-6 space-y-6" id="publicWall">
            <% for (int i = approved.size() - 1; i >= 0; i--) { Feedback fb = approved.get(i); %>
            <div class="review-card break-inside-avoid bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 rounded-2xl p-5 sm:p-6 shadow-xl shadow-slate-200/40 dark:shadow-none flex flex-col group animate-slide-up mb-6" data-stars="<%= fb.getRating() %>">
                <div class="flex items-center justify-between mb-4 sm:mb-6">
                    <div class="flex text-amber-500 text-[10px] gap-1">
                        <% for(int s=1; s<=5; s++) { %><i class="<%= s <= fb.getRating() ? "fa-solid" : "fa-regular" %> fa-star"></i><% } %>
                    </div>
                    <span class="text-[9px] font-black text-slate-400 dark:text-slate-600 uppercase tracking-widest"><%= fb.getDateSubmitted().split(" ")[0] %></span>
                </div>
                <p class="text-sm sm:text-base font-medium text-slate-700 dark:text-slate-300 leading-relaxed italic mb-4 sm:mb-6">"<%= fb.getMessage() %>"</p>
                <div class="flex items-center gap-3 mt-auto pt-4 border-t border-slate-50 dark:border-slate-800">
                    <div class="w-10 h-10 rounded-xl bg-indigo-50 dark:bg-indigo-950 flex items-center justify-center text-indigo-600 dark:text-indigo-400 font-black text-base"><%= fb.getCustomerUsername().substring(0,1).toUpperCase() %></div>
                    <div>
                        <h4 class="text-xs sm:text-sm font-black text-slate-900 dark:text-white leading-none"><%= fb.getCustomerUsername() %></h4>
                        <p class="text-[8px] font-black text-slate-400 uppercase tracking-widest mt-1"><%= fb.getServiceRef() %></p>
                    </div>
                </div>
                <% if (fb.getAdminReply() != null && !"none".equals(fb.getAdminReply())) { %>
                <div class="mt-4 bg-slate-50 dark:bg-slate-950/60 rounded-xl p-4 border border-slate-100 dark:border-slate-800">
                    <p class="text-[8px] font-black text-indigo-600 dark:text-indigo-400 uppercase tracking-widest mb-1.5 flex items-center gap-1.5"><i class="fa-solid fa-reply"></i> Team SwiftDrive</p>
                    <p class="text-xs font-bold text-slate-600 dark:text-slate-400 leading-relaxed"><%= fb.getAdminReply() %></p>
                </div>
                <% } %>
            </div>
            <% } %>
            <% if (approved.isEmpty()) { %>
            <div class="col-span-full bg-white dark:bg-slate-900 rounded-2xl border-2 border-dashed border-slate-100 dark:border-slate-800 p-12 sm:p-16 text-center">
                <i class="fa-solid fa-comment-slash text-slate-200 dark:text-slate-800 text-5xl mb-4 block"></i>
                <h3 class="text-lg sm:text-xl font-black text-slate-900 dark:text-white tracking-tighter mb-2">No Reviews Yet</h3>
                <p class="text-slate-550 text-xs font-medium">Be the first to share your experience.</p>
            </div>
            <% } %>
        </div>
    </div>

    <%@ include file="reviews_sections.jsp" %>

</div>

<%@ include file="toast.jsp" %>
<script>
function filterStars(btn, star) {
    document.querySelectorAll('#starFilterContainer .filter-pill').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    document.querySelectorAll('#publicWall .review-card').forEach(card => {
        if (star === 'all' || card.dataset.stars === star) { card.style.display = ''; } else { card.style.display = 'none'; }
    });
}

document.addEventListener("DOMContentLoaded", () => {
    const params = new URLSearchParams(window.location.search);
    if (params.get("success") === "true" || params.get("success") === "replied") showToast("Reply sent successfully.", "success");
    if (params.get("success") === "updated") showToast("Feedback updated.", "success");
    if (params.get("success") === "deleted") showToast("Feedback deleted.", "success");
    if (params.get("success") === "approved") showToast("Review approved and published!", "success");
});
</script>
<% if (isAdmin || isCustomer) { %>
<%@ include file="logout_script.jsp" %>
<% } %>
</body>
</html>
