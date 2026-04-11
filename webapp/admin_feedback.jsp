<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.FeedbackManager, model.Feedback, java.util.List" %>
<%@ include file="navbar.jsp" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Feedback - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background: #f9fafc; } </style>
</head>
<body class="bg-gradient-to-br from-slate-50 to-gray-100 antialiased">
    <div class="container mx-auto px-4 py-10 max-w-7xl">
        <div class="bg-white/90 backdrop-blur-sm shadow-2xl rounded-2xl border border-white/30 p-8">
            <div class="flex items-center gap-3 border-b border-gray-200/70 pb-5 mb-6">
                <div class="p-3 bg-teal-50 rounded-xl shadow-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-teal-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z" />
                    </svg>
                </div>
                <div>
                    <h2 class="text-3xl font-light tracking-tight text-gray-800">Customer <span class="font-semibold text-teal-600">Feedback Center</span></h2>
                    <p class="text-gray-600 text-sm mt-0.5">Read and reply to concerns</p>
                </div>
            </div>



            <div class="space-y-6">
                <%
                    FeedbackManager manager = new FeedbackManager();
                    List<Feedback> allFb = manager.getAllFeedback();
                    boolean feedFound = false;

                    // Display latest feedback up top
                    for (int i = allFb.size() - 1; i >= 0; i--) {
                        Feedback fb = allFb.get(i);
                        feedFound = true;
                        boolean needsReply = "none".equals(fb.getAdminReply());
                        String badgeText = needsReply ? "Action Needed" : "Replied";
                        String badgeClass = needsReply ? "bg-amber-100 text-amber-700 border-amber-200 animate-pulse" : "bg-green-100 text-green-700 border-green-200";
                %>
                    <div class="bg-white border text-base border-gray-200 shadow-sm rounded-xl overflow-hidden hover:shadow-md transition-shadow">
                        <div class="p-4 border-b border-gray-100 bg-slate-50 flex justify-between items-center">
                            <div class="flex items-center gap-3">
                                <span class="text-sm font-bold text-gray-800"><i class="fa-solid fa-user text-gray-400 mr-2"></i><%= fb.getCustomerUsername() %></span>
                                <span class="text-xs text-gray-400">|</span>
                                <span class="text-xs font-semibold text-gray-500"><%= fb.getDateSubmitted() %></span>
                            </div>
                            <span class="text-xs font-bold px-2.5 py-1 border rounded-lg <%= badgeClass %> shadow-sm uppercase tracking-wider text-[10px]">
                                <%= badgeText %>
                            </span>
                        </div>
                        
                        <div class="p-6">
                            <p class="text-gray-800 leading-relaxed mb-4 whitespace-pre-wrap"><%= fb.getMessage() %></p>
                            
                            <% if (needsReply) { %>
                                <div class="bg-gray-50 border border-gray-200 rounded-xl p-4 mt-4">
                                    <h4 class="text-xs font-bold text-gray-600 mb-3 uppercase tracking-wider">Leave a Reply</h4>
                                    <form action="AdminReplyFeedbackServlet" method="POST" class="flex flex-col sm:flex-row gap-3">
                                        <input type="hidden" name="feedbackId" value="<%= fb.getFeedbackId() %>">
                                        <textarea name="adminReply" rows="2" required class="flex-grow rounded-lg border-gray-300 border-2 outline-none focus:ring-2 focus:ring-teal-500 focus:border-transparent p-2 text-sm" placeholder="Type your response here..."></textarea>
                                        <button type="submit" class="bg-teal-600 hover:bg-teal-700 text-white font-bold py-2 px-6 rounded-lg shadow transition self-end sm:self-auto h-fit">Post</button>
                                    </form>
                                </div>
                            <% } else { %>
                                <div class="mt-4 bg-teal-50 border-l-4 border-teal-500 p-4 rounded-r-lg">
                                    <div class="flex items-center mb-2 text-teal-800">
                                        <i class="fa-solid fa-check-double mr-2"></i>
                                        <h4 class="text-sm font-bold">Your Reply</h4>
                                    </div>
                                    <p class="text-sm text-teal-900 whitespace-pre-wrap"><%= fb.getAdminReply() %></p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <%
                    }
                    if (!feedFound) {
                %>
                    <div class="text-center py-12 bg-white border border-gray-200 shadow-sm rounded-xl">
                        <i class="fa-solid fa-inbox text-5xl text-gray-200 mb-4 block"></i>
                        <h3 class="text-lg font-medium text-gray-800">Inbox is empty</h3>
                        <p class="text-gray-500 italic mt-1">There are no customer feedback messages right now.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
<%@ include file="toast.jsp" %>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        <% if ("true".equals(request.getParameter("success"))) { %>
            showToast("Reply posted successfully!", "success");
        <% } %>
    });
</script>
</body>
</html>
