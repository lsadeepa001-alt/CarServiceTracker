<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List, java.util.ArrayList" %>
<%
    // SECURITY CHECK
    String role = (String) session.getAttribute("userRole");
    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String appId = request.getParameter("appId");
    if (appId == null) {
        response.sendRedirect("in_garage.jsp");
        return;
    }

    BookingManager bm = new BookingManager();
    Appointment app = bm.getAppointmentById(appId);

    if (app == null) {
        response.sendRedirect("in_garage.jsp");
        return;
    }

    InventoryManager im = new InventoryManager();
    List<InventoryItem> allParts = im.getAllItems();
    
    // Filter parts applicable to this service, plus universal fits
    List<InventoryItem> applicableParts = new ArrayList<>();
    for(InventoryItem item : allParts) {
        if (item.getQuantity() > 0 && 
           ("none".equals(item.getApplicableService()) || app.getIssueDescription().equals(item.getApplicableService()))) {
            applicableParts.add(item);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Finish Service - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background: #f8fafc; } </style>
</head>
<body class="antialiased flex flex-col items-center justify-center min-h-screen py-10 px-4">

    <div class="max-w-2xl w-full">
        <div class="mb-6 text-center">
            <h2 class="text-3xl font-extrabold text-slate-800"><i class="fa-solid fa-flag-checkered text-green-600 mr-2"></i>Complete Service</h2>
            <p class="mt-2 text-sm text-gray-500">Log consumed parts, finalize maintenance, and generate customer bill.</p>
        </div>

        <div class="bg-white shadow-xl rounded-2xl border border-gray-100 overflow-hidden">
            
            <div class="bg-slate-50 border-b border-gray-100 p-5 flex justify-between items-center">
                <div>
                    <span class="text-xs font-bold text-gray-400 uppercase">Target Vehicle</span>
                    <h3 class="text-xl font-bold text-gray-800"><i class="fa-solid fa-car text-indigo-400 mr-2"></i><%= app.getLicensePlate() %></h3>
                </div>
                <div class="text-right">
                    <span class="text-xs font-bold text-gray-400 uppercase">Approved Service</span>
                    <h3 class="text-xl font-bold text-indigo-600"><%= app.getIssueDescription() %></h3>
                </div>
            </div>

            <div class="p-8">
                <form action="FinishServiceServlet" method="POST">
                    
                    <!-- HIDDEN TRACKERS -->
                    <input type="hidden" name="appId" value="<%= app.getAppointmentId() %>">
                    <input type="hidden" name="licensePlate" value="<%= app.getLicensePlate() %>">
                    <input type="hidden" name="customerUsername" value="<%= app.getCustomerUsername() %>">
                    <input type="hidden" name="serviceName" value="<%= app.getIssueDescription() %>">

                    <h4 class="font-bold text-gray-800 mb-4 border-b pb-2">Log Consumed Parts</h4>
                    
                    <div class="space-y-4 mb-8 max-h-64 overflow-y-auto pr-2">
                        <% if (applicableParts.isEmpty()) { %>
                             <p class="text-sm text-gray-400 italic">No inventory parts available or applicable for this service.</p>
                        <% } else { %>
                            <% for (InventoryItem part : applicableParts) { %>
                                <div class="flex items-center justify-between p-4 bg-gray-50 border border-gray-200 rounded-xl">
                                    <div class="flex items-center gap-3">
                                        <div class="bg-white h-10 w-10 flex items-center justify-center rounded-lg shadow-sm text-indigo-400 border border-indigo-50">
                                            <i class="fa-solid <%= part.getIconName() %>"></i>
                                        </div>
                                        <div>
                                            <p class="font-bold text-sm text-gray-800"><%= part.getItemName() %></p>
                                            <p class="text-xs text-gray-500 font-mono"><%= part.getItemId() %> | LKR <%= String.format("%,.2f", part.getPrice()) %></p>
                                        </div>
                                    </div>
                                    <div class="w-24">
                                        <input type="number" name="qty_<%= part.getItemId() %>" min="0" max="<%= part.getQuantity() %>" value="0"
                                               class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-indigo-500 font-bold text-gray-700 text-center">
                                    </div>
                                </div>
                            <% } %>
                        <% } %>
                    </div>

                    <div class="flex gap-4 pt-4 border-t border-gray-100 mt-6">
                        <a href="in_garage.jsp" class="w-1/3 text-center py-3 px-4 border border-gray-300 rounded-xl shadow-sm text-sm font-bold text-gray-700 bg-white hover:bg-gray-50 transition-all">
                            Cancel
                        </a>
                        <button type="submit" class="w-2/3 flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-md text-sm font-bold text-white bg-green-600 hover:bg-green-700 transition-all">
                            <i class="fa-solid fa-file-invoice-dollar mr-2 mt-0.5"></i> Finish & Generate Bill
                        </button>
                    </div>

                </form>
            </div>
        </div>
    </div>

</body>
</html>
