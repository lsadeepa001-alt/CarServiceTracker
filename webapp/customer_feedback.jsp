<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.FeedbackManager, model.Feedback, java.util.List" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Feedback - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="bg-slate-50 antialiased">
    <nav class="bg-indigo-600 shadow-md">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                <div class="flex items-center">
                    <span class="text-white font-bold text-xl tracking-wider">SwiftDrive Services</span>
                </div>
                <div class="flex items-center gap-4">
                    <a href="customer_dashboard.jsp" class="text-indigo-100 hover:text-white text-sm font-medium transition"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
                    <a href="LogoutServlet" class="text-white hover:bg-indigo-700 px-3 py-2 rounded-md text-sm font-medium transition">Sign Out</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-4xl mx-auto py-10 px-4">
        
        <% if ("true".equals(request.getParameter("success"))) { %>
            <div class="mb-6 bg-green-50 border-l-4 border-green-500 p-4 rounded-r-md shadow-sm">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fa-solid fa-check-circle text-green-500"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm text-green-700 font-medium">Thank you! Your feedback has been successfully submitted.</p>
                    </div>
                </div>
            </div>
        <% } %>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8 mb-8">
            <h2 class="text-3xl font-bold text-slate-800 mb-2"><i class="fa-solid fa-comments text-indigo-500 mr-2"></i> How are we doing?</h2>
            <p class="text-gray-500 mb-6">We value your opinion. Let us know about your recent service experience.</p>
            
            <form action="SubmitFeedbackServlet" method="POST" class="space-y-4">
                <div>
                    <label for="message" class="block text-sm font-semibold text-gray-700 mb-2">Your Feedback</label>
                    <textarea id="message" name="message" rows="4" required class="appearance-none block w-full outline-none border-2 border-gray-200 text-gray-900 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all duration-200 p-3 sm:text-sm" placeholder="Please type your message here..."></textarea>
                </div>
                <div class="text-right">
                    <button type="submit" class="bg-gradient-to-r from-indigo-600 to-indigo-700 hover:from-indigo-700 hover:to-indigo-800 text-white font-bold py-2.5 px-6 rounded-xl shadow-md transition-all">
                        <i class="fa-solid fa-paper-plane mr-2"></i> Submit Feedback
                    </button>
                </div>
            </form>
        </div>

        <h3 class="text-2xl font-bold text-slate-800 flex items-center mb-6"><i class="fa-solid fa-clock-rotate-left mr-3 text-gray-400"></i> Your Previous Feedback</h3>
        <div class="space-y-6">
            <%
                FeedbackManager manager = new FeedbackManager();
                List<Feedback> allFb = manager.getAllFeedback();
                boolean blockFound = false;

                // Simple reverse logic to show newest first!
                for (int i = allFb.size() - 1; i >= 0; i--) {
                    Feedback fb = allFb.get(i);
                    if (fb.getCustomerUsername().equals(username)) {
                        blockFound = true;
            %>
                <div class="bg-white border text-base border-gray-200 shadow-sm rounded-xl overflow-hidden">
                    <div class="p-5 border-b border-gray-100 bg-slate-50 flex justify-between items-center">
                        <div>
                            <span class="inline-block px-2.5 py-1 bg-white border border-gray-200 font-mono text-xs text-gray-500 rounded-lg shadow-sm">ID: <%= fb.getFeedbackId().substring(0, 8) %></span>
                        </div>
                        <span class="text-xs font-semibold text-gray-400"><i class="fa-regular fa-calendar mr-1"></i> <%= fb.getDateSubmitted() %></span>
                    </div>
                    
                    <div class="p-6">
                        <p class="text-gray-800 leading-relaxed mb-4 whitespace-pre-wrap"><%= fb.getMessage() %></p>
                        
                        <% if (!"none".equals(fb.getAdminReply())) { %>
                            <div class="mt-4 bg-indigo-50 border-l-4 border-indigo-500 p-4 rounded-r-lg">
                                <div class="flex items-center mb-2">
                                    <div class="h-6 w-6 rounded-full bg-indigo-200 flex items-center justify-center text-indigo-700 text-xs mr-2"><i class="fa-solid fa-user-shield"></i></div>
                                    <h4 class="text-sm font-bold text-indigo-800">SwiftDrive Support Team</h4>
                                </div>
                                <p class="text-sm text-indigo-900 ml-8 whitespace-pre-wrap"><%= fb.getAdminReply() %></p>
                            </div>
                        <% } else { %>
                            <p class="text-xs text-gray-400 italic mt-4"><i class="fa-solid fa-hourglass-half mr-1"></i> Awaiting reply from support...</p>
                        <% } %>
                    </div>
                </div>
            <%
                    }
                }
                if (!blockFound) {
            %>
                <div class="text-center py-10 bg-white border border-gray-200 shadow-sm rounded-xl">
                    <i class="fa-regular fa-folder-open text-4xl text-gray-300 mb-3 block"></i>
                    <p class="text-gray-500 italic">You haven't submitted any feedback yet.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
