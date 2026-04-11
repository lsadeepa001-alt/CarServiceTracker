<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.BookingManager, model.Appointment, java.util.List" %>
<%@ include file="navbar.jsp" %>
<%
    // SECURITY CHECK: Admin only
    String role = (String) session.getAttribute("userRole");
    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    BookingManager manager = new BookingManager();
    List<Appointment> queue = manager.getAllAppointments();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Service Queue - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="bg-gray-50 antialiased">

<div class="max-w-5xl mx-auto py-10 px-4">
    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-extrabold text-slate-800"><i class="fa-solid fa-people-arrows text-indigo-600 mr-3"></i>Live Service Queue</h1>
            <p class="text-gray-500">Managing vehicles using First-In, First-Out (FIFO) logic.</p>
        </div>

        <% if (!queue.isEmpty()) { %>
            <form action="CompleteNextServlet" method="POST">
                <button type="submit" class="bg-green-500 hover:bg-green-600 text-white px-6 py-3 rounded-xl shadow-md font-bold text-lg animate-pulse">
                    <i class="fa-solid fa-wrench mr-2"></i> Service Next Vehicle
                </button>
            </form>
        <% } %>
    </div>

    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
        <% if (queue.isEmpty()) { %>
            <div class="text-center py-12 text-gray-400 font-medium">The queue is empty! No cars waiting.</div>
        <% } else { %>
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-indigo-50">
                    <tr>
                        <th class="px-6 py-4 text-left text-xs font-bold text-indigo-800 uppercase">Position</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-indigo-800 uppercase">Ticket ID</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-indigo-800 uppercase">Vehicle Plate</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-indigo-800 uppercase">Issue</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-indigo-800 uppercase">Req. Date</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <%
                        int position = 1;
                        for (Appointment app : queue) {
                            // Highlight the first person in line!
                            String rowClass = (position == 1) ? "bg-green-50/50 border-l-4 border-green-500" : "hover:bg-gray-50";
                            String posBadge = (position == 1) ? "<span class='bg-green-500 text-white px-2 py-1 rounded text-xs font-bold'>NEXT IN LINE</span>" : "#" + position;
                    %>
                    <tr class="<%= rowClass %>">
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-700"><%= posBadge %></td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-mono text-gray-500"><%= app.getAppointmentId() %></td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-slate-800">
                            <span class="border border-gray-300 px-2 py-1 rounded bg-white shadow-sm"><%= app.getLicensePlate() %></span>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-600"><%= app.getIssueDescription() %></td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= app.getPreferredDate() %> <br> <span class="text-xs text-gray-400"><%= app.getPreferredTime() %></span></td>
                    </tr>
                    <%
                            position++;
                        }
                    %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>
</body>
</html>