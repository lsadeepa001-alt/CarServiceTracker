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
        response.sendRedirect("manage_appointments.jsp");
        return;
    }

    BookingManager bm = new BookingManager();
    Appointment app = bm.getAppointmentById(appId);

    if (app == null) {
        response.sendRedirect("manage_appointments.jsp");
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

    ServiceTypeManager stm = new ServiceTypeManager();
    double defaultLabor = 0.0;
    for (ServiceType st : stm.getAllServices()) {
        if (st.getServiceName().equals(app.getIssueDescription())) {
            defaultLabor = st.getDefaultBasePrice();
            break;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finish Service - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> * { font-family: 'Plus Jakarta Sans', sans-serif; } </style>
</head>
<body class="antialiased text-slate-900 dark:text-slate-100 bg-slate-50 dark:bg-slate-950 transition-colors duration-300 min-h-screen flex flex-col items-center justify-center py-10 px-4 pt-28">

    <div class="max-w-2xl w-full">
        <div class="mb-8 text-center">
            <h2 class="text-4xl font-black text-slate-900 dark:text-white tracking-tighter"><i class="fa-solid fa-flag-checkered text-emerald-500 mr-3"></i>Complete Service</h2>
            <p class="mt-4 text-base font-medium text-slate-500 dark:text-slate-400">Finish the maintenance work, select parts used, and generate the final bill.</p>
        </div>

        <div class="bg-white dark:bg-slate-900 rounded-[3rem] border border-slate-100 dark:border-slate-800 overflow-hidden shadow-2xl shadow-slate-200/40 dark:shadow-none">
            
            <div class="bg-slate-100 dark:bg-slate-950 px-8 py-5 flex justify-between items-center border-b border-slate-200 dark:border-slate-800">
                <div>
                    <span class="text-[9px] font-black text-slate-500 dark:text-slate-500 uppercase tracking-widest">Vehicle</span>
                    <h3 class="text-xl font-black text-slate-900 dark:text-white mt-1"><i class="fa-solid fa-car text-indigo-500 mr-2"></i><%= app.getLicensePlate() %></h3>
                </div>
                <div class="text-right">
                    <span class="text-[9px] font-black text-slate-500 dark:text-slate-500 uppercase tracking-widest">Service Provided</span>
                    <h3 class="text-xl font-black text-indigo-600 dark:text-indigo-400 mt-1"><%= app.getIssueDescription() %></h3>
                </div>
            </div>

            <div class="p-10">
                <form action="FinishServiceServlet" method="POST">
                    
                    <!-- HIDDEN TRACKERS -->
                    <input type="hidden" name="appId" value="<%= app.getAppointmentId() %>">
                    <input type="hidden" name="licensePlate" value="<%= app.getLicensePlate() %>">
                    <input type="hidden" name="customerUsername" value="<%= app.getCustomerUsername() %>">
                    <input type="hidden" name="serviceName" value="<%= app.getIssueDescription() %>">

                    <h4 class="text-[9px] font-black text-slate-400 dark:text-slate-700 uppercase tracking-[0.3em] mb-8 flex items-center gap-3">
                        <i class="fa-solid fa-boxes-stacked text-indigo-500"></i> Parts Used
                    </h4>
                    
                    <div class="space-y-4 mb-10 max-h-80 overflow-y-auto pr-4 custom-scrollbar">
                        <% if (applicableParts.isEmpty()) { %>
                             <div class="p-8 text-center bg-slate-50 dark:bg-slate-950 rounded-2xl border-2 border-dashed border-slate-200 dark:border-slate-800">
                                 <p class="text-sm font-medium text-slate-400">No inventory parts available or applicable for this service.</p>
                             </div>
                        <% } else { %>
                            <% for (InventoryItem part : applicableParts) { %>
                                <div class="flex items-center justify-between p-6 bg-slate-50 dark:bg-slate-950/60 border border-slate-100 dark:border-slate-800 rounded-2xl shadow-inner">
                                    <div class="flex items-center gap-5">
                                        <div class="bg-white dark:bg-slate-900 h-12 w-12 flex items-center justify-center rounded-xl shadow-sm text-indigo-500 dark:text-indigo-400 border border-indigo-50 dark:border-indigo-900/30">
                                            <i class="fa-solid <%= part.getIconName() %> text-lg"></i>
                                        </div>
                                        <div class="min-w-0">
                                            <p class="font-black text-slate-800 dark:text-white text-sm truncate"><%= part.getItemName() %></p>
                                            <p class="text-[10px] font-black text-slate-400 dark:text-slate-600 uppercase tracking-widest mt-1">LKR <%= String.format("%,.2f", part.getPrice()) %></p>
                                        </div>
                                    </div>
                                    <div class="w-24">
                                        <input type="number" name="qty_<%= part.getItemId() %>" min="0" max="<%= part.getQuantity() %>" value="0"
                                               class="w-full px-4 py-2.5 bg-white dark:bg-slate-900 border-2 border-transparent dark:border-slate-800 rounded-xl focus:ring-8 focus:ring-indigo-500/10 focus:border-indigo-500 outline-none transition-all font-black text-slate-900 dark:text-white text-center shadow-sm">
                                    </div>
                                </div>
                            <% } %>
                        <% } %>
                    </div>

                    <div class="border-t border-slate-100 dark:border-slate-800 pt-8 mb-10">
                        <label class="block text-[10px] font-black text-slate-400 dark:text-slate-700 uppercase tracking-[0.3em] mb-4">
                            <i class="fa-solid fa-user-gear text-indigo-500 mr-2"></i> Labor Fee (LKR)
                        </label>
                        <input type="number" step="0.01" name="laborCost" value="<%= defaultLabor %>" required min="0"
                               class="w-full px-6 py-4 bg-slate-50 dark:bg-slate-950 border-2 border-transparent dark:border-slate-800 rounded-2xl text-lg font-black focus:ring-8 focus:ring-indigo-500/10 focus:border-indigo-500 outline-none transition-all text-slate-900 dark:text-white shadow-inner">
                        <p class="text-[10px] text-slate-400 dark:text-slate-500 mt-2 italic">Pre-filled with the default base price for <%= app.getIssueDescription() %>.</p>
                    </div>

                    <div class="flex flex-col sm:flex-row gap-4 pt-4">
                        <button type="submit" class="flex-[2] py-5 rounded-2xl bg-slate-900 dark:bg-white text-white dark:text-slate-950 font-black text-[10px] uppercase tracking-[0.2em] shadow-2xl transition-all hover:-translate-y-1 active:scale-95 flex items-center justify-center gap-4">
                            <i class="fa-solid fa-file-invoice-dollar text-lg"></i> Finish & Bill
                        </button>
                        <a href="manage_appointments.jsp" class="flex-1 text-center py-5 rounded-2xl border-2 border-slate-100 dark:border-slate-800 text-slate-400 dark:text-slate-600 font-black text-[10px] uppercase tracking-[0.2em] hover:bg-slate-50 dark:hover:bg-slate-900 transition-all flex items-center justify-center">
                            Cancel
                        </a>
                    </div>

                </form>
            </div>
        </div>
    </div>

</body>
</html>
