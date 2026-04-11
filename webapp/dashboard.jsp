<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ServiceHistoryList, model.ServiceRecord, model.Node" %>
<%@ include file="navbar.jsp" %>

<%
    // SECURITY CHECK: Admin only
    String role = (String) session.getAttribute("userRole");
    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background: #f9fafc; } </style>
</head>
<body class="bg-gradient-to-br from-slate-50 to-gray-100 antialiased">

    <div class="container mx-auto px-4 py-10 max-w-7xl">
        <div class="bg-white/90 backdrop-blur-sm shadow-2xl rounded-2xl border border-white/30 p-8">

            <div class="flex items-center gap-3 border-b border-gray-200/70 pb-5 mb-6">
                <div class="p-3 bg-indigo-50 rounded-xl shadow-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-indigo-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                    </svg>
                </div>
                <div>
                    <h2 class="text-3xl font-light tracking-tight text-gray-800">Service <span class="font-semibold text-indigo-700">History Control</span></h2>
                    <p class="text-gray-600 text-sm mt-0.5"><i class="fa-regular fa-calendar-check text-indigo-400"></i> Admin View - Sorted by date</p>
                </div>
            </div>

            <div class="overflow-hidden rounded-xl border border-gray-200/70 bg-white shadow-sm">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gradient-to-r from-indigo-700 to-indigo-800 text-white">
                        <tr>
                            <th class="px-5 py-3.5 text-left text-sm font-semibold uppercase tracking-wider">Date</th>
                            <th class="px-5 py-3.5 text-left text-sm font-semibold uppercase tracking-wider">Number Plate</th>
                            <th class="px-5 py-3.5 text-left text-sm font-semibold uppercase tracking-wider">Service Type</th>
                            <th class="px-5 py-3.5 text-left text-sm font-semibold uppercase tracking-wider">Cost (LKR)</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100 bg-white">
                        <%
                            ServiceHistoryList list = (ServiceHistoryList) session.getAttribute("serviceList");
                            if (list == null) {
                                list = new ServiceHistoryList();
                                list.loadFromFile();
                                session.setAttribute("serviceList", list);
                            }

                            list.sortHistoryByDate();
                            Node current = list.head;

                            if (current == null) {
                        %>
                                <tr>
                                    <td colspan="5" class="px-6 py-8 text-center text-gray-500 italic">No service records found. Click 'Add New Service' to begin!</td>
                                </tr>
                        <%
                            } else {
                                while (current != null) {
                                    // Protect against old data that might not have a license plate yet!
                                    String displayPlate = (current.data.getLicensePlate() != null) ? current.data.getLicensePlate() : "Unknown";
                        %>
                                <tr class="hover:bg-gray-50 transition-colors">
                                    <td class="px-5 py-3.5 text-sm text-gray-700 font-medium"><%= current.data.getDate() %></td>

                                    <td class="px-5 py-3.5 text-sm">
                                        <span class="bg-white border-2 border-gray-300 text-gray-800 px-2 py-1 rounded font-mono text-xs font-bold shadow-sm">
                                            <%= displayPlate %>
                                        </span>
                                    </td>

                                    <td class="px-5 py-3.5 text-sm"><span class="px-2.5 py-1 bg-indigo-50 text-indigo-800 rounded-full text-xs font-medium"><%= current.data.getServiceType() %></span></td>
                                    <td class="px-5 py-3.5 text-sm font-mono">LKR <%= String.format("%,.2f", current.data.getCost()) %></td>
                                </tr>
                        <%
                                    current = current.next;
                                }
                            }
                        %>
                    </tbody>
            </div>

        </div>
    </div>

</body>
</html>