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
    List<Appointment> inGarage = manager.getInGarageAppointments();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>In Garage - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="bg-gray-50 antialiased pt-24">

<div class="max-w-5xl mx-auto py-10 px-4">
    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-extrabold text-slate-800"><i class="fa-solid fa-screwdriver-wrench text-orange-500 mr-3"></i>In Garage</h1>
            <p class="text-gray-500">Vehicles currently being serviced by mechanics.</p>
        </div>
    </div>

    <!-- TABS ROW -->
    <div class="flex space-x-4 mb-6">
        <a href="manage_appointments.jsp" class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg shadow-sm hover:bg-gray-300 transition font-bold text-sm"><i class="fa-solid fa-list-ol mr-1"></i> View Queue</a>
        <a href="in_garage.jsp" class="px-4 py-2 bg-orange-500 text-white rounded-lg shadow-md font-bold text-sm ring-2 ring-orange-300 ring-offset-2 border border-orange-600"><i class="fa-solid fa-gears mr-1 ml-0.5"></i> Actively Maintained</a>
    </div>

    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
        <% if (inGarage.isEmpty()) { %>
            <div class="text-center py-12 text-gray-400 font-medium">No vehicles are currently in the garage!</div>
        <% } else { %>
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-orange-50">
                    <tr>
                        <th class="px-6 py-4 text-left text-xs font-bold text-orange-800 uppercase">Status</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-orange-800 uppercase">Ticket ID</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-orange-800 uppercase">Vehicle Plate</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-orange-800 uppercase">Assigned Service</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-orange-800 uppercase">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <%
                        for (Appointment app : inGarage) {
                    %>
                    <tr class="hover:bg-gray-50 border-l-4 border-orange-400 bg-orange-50/20">
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-700">
                             <div class="flex items-center">
                                 <div class="h-2.5 w-2.5 rounded-full bg-orange-500 animate-pulse mr-2"></div>
                                 <span class="text-orange-600">Under Maintenance</span>
                             </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-mono text-gray-500"><%= app.getAppointmentId() %></td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-slate-800">
                            <span class="border border-gray-300 px-2 py-1 rounded bg-white shadow-sm"><%= app.getLicensePlate() %></span>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-600 font-semibold uppercase tracking-wide"><%= app.getIssueDescription() %></td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm">
                            <form action="finish_service.jsp" method="GET">
                                <input type="hidden" name="appId" value="<%= app.getAppointmentId() %>">
                                <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-lg font-bold transition shadow-sm border border-indigo-700 text-xs">
                                    <i class="fa-solid fa-flag-checkered mr-1"></i> Finish
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>
</body>
</html>
