<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ServiceHistoryList, model.ServiceRecord, model.Node" %>
<%@ page import="model.BookingManager, model.Appointment, java.util.List" %>
<%@ page import="model.VehicleManager, model.Vehicle" %>
<%@ page import="model.BillingManager, model.Invoice, java.util.Stack" %>
<%@ page import="model.FeedbackManager, model.Feedback, java.util.ArrayList" %>
<%@ page import="model.AbstractUser, model.CustomerUser" %>
<%@ page import="model.ChatManager, model.ChatMessage" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) { response.sendRedirect("login.jsp"); return; }
    AbstractUser userObj = (AbstractUser) session.getAttribute("userObject");

    // Pre-load all data
    VehicleManager vm = new VehicleManager();
    List<Vehicle> allVehicles = vm.getAllVehicles();
    List<Vehicle> myCars = new ArrayList<>();
    for(Vehicle v : allVehicles) { if(v.getOwnerUsername().equals(username)) myCars.add(v); }

    BookingManager bm = new BookingManager();
    ChatManager chatManager = new ChatManager();
    List<Appointment> allApps = bm.getAllAppointmentsNatively();
    List<Appointment> myApps = new ArrayList<>();
    for(Appointment a : allApps) { if(a.getCustomerUsername().equals(username)) myApps.add(a); }

    ServiceHistoryList list = (ServiceHistoryList) session.getAttribute("serviceList");
    if (list == null) { list = new ServiceHistoryList(); list.loadFromFile(); }

    FeedbackManager fbMgr = new FeedbackManager();
    List<Feedback> allFeedback = fbMgr.getAllFeedback();
    List<Feedback> myFBs = new ArrayList<>();
    for(Feedback fb : allFeedback) { if(fb.getCustomerUsername().equals(username)) myFBs.add(fb); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Plus Jakarta Sans', sans-serif; }
        .rating-stars { display: flex; flex-direction: row-reverse; justify-content: flex-end; gap: .25rem; }
        .rating-stars input { display: none; }
        .rating-stars label { cursor: pointer; color: #e2e8f0; font-size: 1.5rem; transition: color .2s; }
        .rating-stars input:checked ~ label,
        .rating-stars label:hover,
        .rating-stars label:hover ~ label { color: #facc15; }
        
        .plate-tag { 
            background: #FEF9C3; 
            border: 2px solid #1a1a1a; 
            font-family: 'Courier New', monospace; 
            font-weight: 800; 
            text-transform: uppercase; 
            letter-spacing: .1em; 
            padding: 3px 10px; 
            border-radius: 4px; 
            font-size: 11px; 
            color: #1a1a1a; 
            white-space: nowrap; 
            display: inline-block; 
            line-height: 1; 
        }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
        .dark .plate-tag {
            background: #1e293b;
            color: #f8fafc;
            border-color: #f8fafc;
        }

        .modal-panel {
            -webkit-font-smoothing: antialiased;
            backface-visibility: hidden;
        }
        
        .card { 
            background: #fff; 
            border-radius: 1rem; 
            border: 1px solid #e2e8f0; 
            box-shadow: 0 1px 3px rgba(0,0,0,.04); 
            transition: all 0.3s ease;
        }
        .dark .card {
            background: rgba(30, 41, 59, 0.4);
            border-color: rgba(51, 65, 85, 0.5);
            box-shadow: none;
        }

        .card-hdr { 
            background: #EEF2FF; 
            border-bottom: 1px solid #e2e8f0; 
            padding: 1rem 1.25rem; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            border-radius: 1rem 1rem 0 0; 
        }
        .dark .card-hdr {
            background: rgba(79, 70, 229, 0.1);
            border-bottom-color: rgba(51, 65, 85, 0.5);
        }

        .v-item { transition: all .15s; }
        .v-item:hover { background: #F8FAFC; transform: translateX(3px); }
        .dark .v-item:hover { background: rgba(51, 65, 85, 0.3); }

    </style>
</head>
<body class="antialiased text-slate-900 dark:text-slate-100 bg-slate-50 dark:bg-slate-950 transition-colors duration-300">
<%@ include file="customer_navbar.jsp" %>

<div class="max-w-7xl mx-auto py-10 px-4 pt-28">

    <!-- WELCOME HEADER -->
    <div class="mb-10 flex flex-col md:flex-row justify-between items-start md:items-end gap-6">
        <div>
            <h1 class="text-4xl font-black tracking-tight text-slate-900 dark:text-white">
                Welcome back, <span class="bg-clip-text text-transparent bg-gradient-to-r from-indigo-600 to-violet-600"><%= username %></span>!
            </h1>
            <p class="text-slate-500 dark:text-slate-400 text-base mt-2 font-medium">Manage your vehicles, book services, and track maintenance history.</p>
            
            <% if (userObj instanceof CustomerUser) {
                CustomerUser cUser = (CustomerUser) userObj;
                if (cUser.getServiceDiscount() > 0) { %>
                <div class="mt-4 inline-flex items-center gap-2 bg-indigo-50 dark:bg-indigo-900/30 border border-indigo-100 dark:border-indigo-800/50 text-indigo-700 dark:text-indigo-300 px-4 py-2 rounded-2xl text-xs font-bold uppercase tracking-wider">
                    <i class="fa-solid fa-crown text-amber-500"></i> <%= cUser.getMembershipTier() %> &bull; <%=(int)(cUser.getServiceDiscount() * 100)%>% Exclusive Discount
                </div>
            <% } } %>
        </div>
        
        <div class="flex gap-3">
            <div class="bg-white dark:bg-slate-800/50 backdrop-blur-md p-4 rounded-3xl border border-slate-200 dark:border-slate-700 shadow-sm flex items-center gap-4">
                <div class="w-12 h-12 rounded-2xl bg-indigo-50 dark:bg-indigo-900/40 flex items-center justify-center text-indigo-600 dark:text-indigo-400">
                    <i class="fa-solid fa-car-side text-xl"></i>
                </div>
                <div>
                    <p class="text-xs font-bold text-slate-400 uppercase tracking-widest">Your Fleet</p>
                    <p class="text-xl font-black text-slate-800 dark:text-white"><%= myCars.size() %> Vehicles</p>
                </div>
            </div>
        </div>
    </div>

    <!-- MAIN DASHBOARD GRID -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">

        <!-- LEFT/CENTER: HISTORY & APPOINTMENTS (COL 8) -->
        <div class="lg:col-span-8 space-y-8">
            
            <!-- APPOINTMENTS SECTION -->
            <section>
                <div class="flex items-center justify-between mb-4 px-2">
                    <h2 class="text-lg font-black text-slate-800 dark:text-white flex items-center gap-2">
                        <i class="fa-regular fa-calendar-check text-indigo-600"></i> Upcoming Appointments
                    </h2>
                    <a href="book_appointment.jsp" class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold px-5 py-2.5 rounded-xl shadow-lg shadow-indigo-200 dark:shadow-none transition-all hover:-translate-y-0.5">
                        <i class="fa-solid fa-calendar-plus mr-2"></i>Book New
                    </a>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <% boolean hasApp = false;
                       for (Appointment app : myApps) {
                           hasApp = true;
                           String statusText = app.getStatus();
                           String cardCls = "bg-white dark:bg-slate-800/40 border-slate-200 dark:border-slate-700";
                           String statusPill = "bg-amber-100 text-amber-700 border-amber-200 dark:bg-amber-900/30 dark:text-amber-400 dark:border-amber-800/50";
                           
                           if ("Under Maintenance".equals(statusText)) {
                               statusPill = "bg-orange-100 text-orange-700 border-orange-200 dark:bg-orange-900/30 dark:text-orange-400 dark:border-orange-800/50";
                           } else if ("Completed".equals(statusText)) {
                               statusPill = "bg-emerald-100 text-emerald-700 border-emerald-200 dark:bg-emerald-900/30 dark:text-emerald-400 dark:border-emerald-800/50";
                           } %>
                        <div class="card p-5 group hover:border-indigo-300 dark:hover:border-indigo-700 transition-all">
                            <div class="flex justify-between items-start mb-4">
                                <div class="w-10 h-10 rounded-xl bg-slate-50 dark:bg-slate-900/60 flex items-center justify-center text-slate-400 group-hover:text-indigo-500 transition-colors">
                                    <i class="fa-solid fa-wrench"></i>
                                </div>
                                <span class="text-[10px] font-black px-2.5 py-1 rounded-lg border uppercase tracking-wider <%= statusPill %>"><%= statusText %></span>
                            </div>
                            <h3 class="font-black text-slate-800 dark:text-white text-lg"><%= app.getLicensePlate() %></h3>
                            <p class="text-xs text-slate-500 dark:text-slate-400 mt-1 line-clamp-1"><%= app.getIssueDescription() %></p>
                            
                            <div class="mt-4 flex items-center gap-4 text-xs font-bold text-slate-400">
                                <span class="flex items-center gap-1.5"><i class="fa-regular fa-calendar text-indigo-500"></i> <%= app.getPreferredDate() %></span>
                                <span class="flex items-center gap-1.5"><i class="fa-regular fa-clock text-indigo-500"></i> <%= app.getPreferredTime() %></span>
                            </div>

                            <div class="mt-5 pt-4 border-t border-slate-100 dark:border-slate-700/50 flex gap-2">
                                <% 
                                    boolean isChatOpen = ChatManager.isChatWindowOpen(app.getCompletedDate(), 7);
                                    if (isChatOpen) {
                                        int unread = chatManager.getUnreadCountForUser(app.getAppointmentId(), "customer"); 
                                        long daysLeft = ChatManager.getRemainingDays(app.getCompletedDate(), 7);
                                %>
                                <a href="appointment_chat.jsp?appId=<%= app.getAppointmentId() %>" class="relative flex-[0.3] flex flex-col items-center justify-center bg-slate-50 dark:bg-slate-800 text-slate-500 hover:text-indigo-600 rounded-xl transition-all border border-transparent hover:border-indigo-100 py-1">
                                    <i class="fa-solid fa-comments text-lg"></i>
                                    <% if ("Completed".equals(statusText)) { %>
                                        <span class="text-[8px] font-black uppercase text-slate-400 mt-1"><%= daysLeft %>d left</span>
                                    <% } %>
                                    <% if (unread > 0) { %>
                                        <span class="absolute -top-1 -right-1 w-4 h-4 bg-rose-500 text-white rounded-full flex items-center justify-center text-[8px] animate-pulse"><%= unread %></span>
                                    <% } %>
                                </a>
                                <% } else { %>
                                <div class="relative flex-[0.3] flex flex-col items-center justify-center bg-slate-50 dark:bg-slate-800 text-slate-400 rounded-xl py-1 opacity-50 cursor-not-allowed">
                                    <i class="fa-solid fa-comments text-lg"></i>
                                    <span class="text-[8px] font-black uppercase text-slate-400 mt-1">Expired</span>
                                </div>
                                <% } %>
                                
                                <% if ("Pending".equals(statusText)) { %>
                                    <a href="reschedule_appointment.jsp?id=<%= app.getAppointmentId() %>" class="flex-1 text-center bg-slate-50 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-indigo-600 hover:text-white text-[11px] font-black py-2.5 rounded-xl transition-all flex items-center justify-center">Reschedule</a>
                                    <button type="button" onclick="openCancelAppModal('<%= app.getAppointmentId() %>')" class="flex-1 bg-slate-50 dark:bg-slate-800 text-red-500 hover:bg-red-500 hover:text-white text-[11px] font-black py-2.5 rounded-xl transition-all">Cancel</button>
                                <% } else { %>
                                    <button disabled class="flex-1 bg-slate-50 dark:bg-slate-800/40 text-slate-400 dark:text-slate-600 text-[11px] font-black py-2.5 rounded-xl cursor-not-allowed">Locked - <%= statusText %></button>
                                <% } %>
                            </div>
                        </div>
                    <% } if (!hasApp) { %>
                        <div class="col-span-full bg-white dark:bg-slate-800/40 border-2 border-dashed border-slate-200 dark:border-slate-700 rounded-3xl p-10 text-center">
                            <div class="w-16 h-16 bg-slate-50 dark:bg-slate-800 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fa-regular fa-calendar text-slate-400 text-2xl"></i>
                            </div>
                            <p class="text-slate-500 dark:text-slate-400 font-bold">No active appointments found.</p>
                            <a href="book_appointment.jsp" class="text-indigo-600 dark:text-indigo-400 text-sm font-bold mt-2 inline-block hover:underline">Book your first service &rarr;</a>
                        </div>
                    <% } %>
                </div>
            </section>

            <!-- SERVICE HISTORY SECTION -->
            <section class="card overflow-hidden">
                <div class="px-6 py-5 border-b border-slate-100 dark:border-slate-700/50 flex justify-between items-center">
                    <h2 class="text-lg font-black text-slate-800 dark:text-white flex items-center gap-2">
                        <i class="fa-solid fa-clipboard-list text-indigo-600"></i> Service History
                    </h2>
                    <span class="text-[10px] font-black uppercase tracking-widest text-slate-400 bg-slate-100 dark:bg-slate-800 px-3 py-1.5 rounded-lg">Recent Service Logs</span>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead>
                            <tr class="bg-slate-50 dark:bg-slate-800/50">
                                <th class="px-6 py-4 text-left text-[10px] font-black text-slate-400 uppercase tracking-widest">Date</th>
                                <th class="px-6 py-4 text-left text-[10px] font-black text-slate-400 uppercase tracking-widest">Vehicle</th>
                                <th class="px-6 py-4 text-left text-[10px] font-black text-slate-400 uppercase tracking-widest">Service Type</th>
                                <th class="px-6 py-4 text-left text-[10px] font-black text-slate-400 uppercase tracking-widest text-right">Review</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100 dark:divide-slate-700/50">
                            <% Node current = list.head;
                               boolean hasHistory = false;
                               while (current != null) {
                                   boolean belongsToUser = false;
                                   for(Vehicle c : myCars) { if(c.getLicensePlate().equals(current.data.getLicensePlate())) { belongsToUser = true; break; } }
                                   if(belongsToUser) {
                                       hasHistory = true;
                                       String expectedRef = current.data.getDate() + " - " + current.data.getServiceType() + " [" + current.data.getLicensePlate() + "]";
                                       Feedback matchedFb = null;
                                       for(Feedback f : myFBs) { if(f.getServiceRef().equals(expectedRef)) { matchedFb = f; break; } }
                                       boolean hasFb = matchedFb != null;
                                       int rating = hasFb ? matchedFb.getRating() : 0;
                                       String reply = hasFb ? matchedFb.getAdminReply() : "";
                                       reply = reply.replace("'", "\\'");
                            %>
                            <tr class="group hover:bg-indigo-50/50 dark:hover:bg-indigo-900/10 cursor-pointer transition-all"
                                onclick="openHistoryModal('<%= current.data.getDate() %>','<%= current.data.getLicensePlate() %>','<%= current.data.getServiceType() %>','<%= current.data.getPartsUsed() %>','<%= String.format("%,.2f", current.data.getCost()) %>',<%= hasFb %>,<%= rating %>,'<%= reply %>','<%= hasFb?matchedFb.getFeedbackId():"" %>','<%= hasFb?matchedFb.getMessage().replace("'","\\'"):"" %>')">
                                <td class="px-6 py-5 text-sm font-bold text-slate-700 dark:text-slate-300"><%= current.data.getDate() %></td>
                                <td class="px-6 py-5">
                                    <span class="plate-tag text-[11px] font-black bg-white dark:bg-slate-900 border-2 border-slate-900 dark:border-slate-100 text-slate-900 dark:text-white"><%= current.data.getLicensePlate() %></span>
                                </td>
                                <td class="px-6 py-5">
                                    <div class="flex flex-col">
                                        <span class="text-sm font-bold text-slate-800 dark:text-white"><%= current.data.getServiceType() %></span>
                                        <span class="text-[10px] text-slate-400 dark:text-slate-500 mt-0.5"><%= current.data.getPartsUsed() != null ? current.data.getPartsUsed() : "Full Inspection" %></span>
                                    </div>
                                </td>
                                <td class="px-6 py-5 text-right">
                                    <% if(hasFb) { %>
                                        <div class="flex justify-end text-yellow-500 text-xs gap-0.5">
                                            <% for(int s=1;s<=5;s++) { %><i class="<%= (s<=rating)?"fa-solid":"fa-regular" %> fa-star"></i><% } %>
                                        </div>
                                    <% } else { %>
                                        <span class="text-[10px] font-bold text-indigo-600 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-900/40 px-2 py-1 rounded-lg">Rate Service</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } current = current.next; } if (!hasHistory) { %>
                            <tr><td colspan="4" class="px-6 py-12 text-center text-slate-400 italic font-medium">Your service journey starts here. No logs yet.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>

        <!-- RIGHT COLUMN: GARAGE & BILLING (COL 4) -->
        <div class="lg:col-span-4 space-y-8">
            
            <!-- GARAGE CARD -->
            <section class="card overflow-hidden">
                <div class="px-6 py-5 border-b border-slate-100 dark:border-slate-700/50 flex justify-between items-center bg-slate-50/50 dark:bg-slate-800/30">
                    <h2 class="text-sm font-black text-slate-800 dark:text-white uppercase tracking-widest flex items-center gap-2">
                        <i class="fa-solid fa-warehouse text-indigo-600"></i> My Garage
                    </h2>
                    <a href="customer_vehicles.jsp" class="text-indigo-600 dark:text-indigo-400 hover:underline text-[11px] font-bold">View All</a>
                </div>
                <div class="p-6 space-y-4">
                    <% boolean hasGarage = false; int vIdx=0;
                       for(Vehicle car : myCars) { hasGarage = true; String vId = "v" + vIdx++; %>
                        <div class="p-4 bg-slate-50 dark:bg-slate-900/40 rounded-2xl border border-slate-100 dark:border-slate-800 group transition-all hover:bg-white dark:hover:bg-slate-800 hover:shadow-lg hover:shadow-slate-200/50 dark:hover:shadow-none">
                            <div class="flex items-start gap-4">
                                <div class="w-12 h-12 rounded-2xl bg-white dark:bg-slate-800 shadow-sm flex items-center justify-center text-slate-400 group-hover:text-indigo-500 transition-colors">
                                    <i class="fa-solid fa-car text-xl"></i>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <h3 class="font-black text-slate-800 dark:text-white text-sm truncate"><%= car.getMake() %> <%= car.getModel() %></h3>
                                    <div class="flex items-center gap-2 mt-2">
                                        <span class="plate-tag text-[9px] bg-white dark:bg-slate-900 border-2 border-slate-900 dark:border-slate-100 text-slate-900 dark:text-white"><%= car.getLicensePlate() %></span>
                                        <span class="text-[10px] font-bold text-slate-400 dark:text-slate-500"><%= car.getMileage() %> KM</span>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 pt-4 border-t border-slate-200/50 dark:border-slate-700/50 flex gap-2">
                                <button onclick="toggleMileageForm('<%= vId %>')" class="flex-1 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-400 hover:bg-indigo-50 dark:hover:bg-indigo-900/30 text-[10px] font-black py-2 rounded-xl transition-all">Update KM</button>
                                <a href="customer_vehicles.jsp" class="bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-700 p-2 rounded-xl text-[10px] transition-all"><i class="fa-solid fa-chevron-right"></i></a>
                            </div>
                            <div id="<%= vId %>" style="max-height:0;overflow:hidden;transition:all 0.3s ease">
                                <form action="UpdateMileageServlet" method="POST" class="mt-3 pt-3 flex gap-2 border-t border-dashed border-slate-200 dark:border-slate-700">
                                    <input type="hidden" name="plate" value="<%= car.getLicensePlate() %>">
                                    <input type="number" name="mileage" min="0" required placeholder="<%= car.getMileage() %>" class="flex-1 bg-white dark:bg-slate-900 px-3 py-1.5 rounded-lg text-xs border border-slate-200 dark:border-slate-700 outline-none focus:ring-1 focus:ring-indigo-500 dark:text-white">
                                    <button type="submit" class="bg-indigo-600 text-white text-[10px] font-bold px-4 py-1.5 rounded-lg">Save</button>
                                </form>
                            </div>
                        </div>
                    <% } if(!hasGarage) { %>
                        <div class="py-8 text-center"><i class="fa-solid fa-car-tunnel text-slate-400 dark:text-slate-800 text-4xl mb-3 block"></i><p class="text-xs text-slate-500 dark:text-slate-500 font-bold">No vehicles in your garage.</p></div>
                    <% } %>
                </div>
            </section>

            <!-- RECENT BILLING -->
            <section class="card overflow-hidden">
                <div class="px-6 py-5 border-b border-slate-100 dark:border-slate-700/50 flex justify-between items-center bg-slate-50/50 dark:bg-slate-800/30">
                    <h2 class="text-sm font-black text-slate-800 dark:text-white uppercase tracking-widest flex items-center gap-2">
                        <i class="fa-solid fa-file-invoice-dollar text-indigo-600"></i> Recent Invoices
                    </h2>
                </div>
                <div class="p-6 space-y-4">
                    <% boolean hasBills = false; Stack<Invoice> allBills = new BillingManager().getAllInvoices();
                       for (int i = allBills.size() - 1; i >= 0 && i >= allBills.size()-5; i--) {
                           Invoice inv = allBills.get(i);
                           if (inv.getCustomerUsername().equals(username)) {
                               hasBills = true;
                               String statusCls = "PAID".equals(inv.getStatus()) ? "text-emerald-500 bg-emerald-50 dark:bg-emerald-900/30 border-emerald-100 dark:border-emerald-800/50" : "text-rose-500 bg-rose-50 dark:bg-rose-900/30 border-rose-100 dark:border-rose-800/50";
                    %>
                        <div class="flex justify-between items-center p-3 border-b border-slate-50 dark:border-slate-800 last:border-0 group">
                            <div class="min-w-0">
                                <p class="text-xs font-black text-slate-800 dark:text-white truncate"><%= inv.getServiceDescription() %></p>
                                <p class="text-[9px] font-bold text-slate-400 mt-0.5"><%= inv.getInvoiceId() %> &bull; <%= inv.getLicensePlate() %></p>
                            </div>
                            <div class="text-right">
                                <p class="text-xs font-black text-slate-900 dark:text-white">LKR <%= String.format("%,.0f", inv.getTotalAmount()) %></p>
                                <span class="text-[8px] font-black uppercase px-1.5 py-0.5 rounded border inline-block mt-1 <%= statusCls %>"><%= inv.getStatus() %></span>
                            </div>
                        </div>
                    <% } } if(!hasBills) { %>
                        <div class="py-8 text-center"><i class="fa-solid fa-receipt text-slate-400 dark:text-slate-800 text-4xl mb-3 block"></i><p class="text-xs text-slate-500 dark:text-slate-500 font-bold">No billing activity yet.</p></div>
                    <% } %>
                </div>
            </section>
        </div>
    </div>
</div>

<!-- MODAL OVERLAY -->
<div id="historyModal" class="hidden fixed inset-0 z-[60] flex items-start justify-center p-4 overflow-y-auto no-scrollbar">
    <div class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm transition-opacity" onclick="closeHistoryModal()"></div>
    <div class="modal-panel relative bg-white dark:bg-slate-900 rounded-[3rem] shadow-2xl max-w-lg w-full p-12 border border-slate-200 dark:border-slate-700 my-12" id="hModalPanel">
        
        <div class="flex justify-between items-start mb-10">
            <div class="flex items-center gap-4">
                <div class="w-14 h-14 rounded-2xl bg-indigo-600 flex items-center justify-center text-white shadow-xl shadow-indigo-200 dark:shadow-none">
                    <i class="fa-solid fa-book-open text-2xl"></i>
                </div>
                <div>
                    <h3 class="text-2xl font-black text-slate-900 dark:text-white">Service History Details</h3>
                    <p id="modalDate" class="text-sm font-bold text-slate-400"></p>
                </div>
            </div>
            <button onclick="closeHistoryModal()" class="w-10 h-10 rounded-2xl bg-slate-50 dark:bg-slate-800 hover:bg-red-50 dark:hover:bg-red-900/30 text-slate-400 hover:text-red-500 transition-all flex items-center justify-center">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <div class="space-y-6">
            <div class="grid grid-cols-2 gap-4">
                <div class="bg-slate-50 dark:bg-slate-800/50 p-4 rounded-3xl border border-slate-100 dark:border-slate-700/50">
                    <span class="text-[9px] font-black uppercase text-slate-400 tracking-widest block mb-1">Vehicle</span>
                    <span id="modalPlate" class="plate-tag text-xs font-black bg-white dark:bg-slate-900 border-2 border-slate-900 dark:border-slate-100"></span>
                </div>
                <div class="bg-slate-50 dark:bg-slate-800/50 p-4 rounded-3xl border border-slate-100 dark:border-slate-700/50">
                    <span class="text-[9px] font-black uppercase text-slate-400 tracking-widest block mb-1">Type</span>
                    <span id="modalService" class="text-sm font-black text-slate-800 dark:text-white"></span>
                </div>
            </div>

            <div class="p-5 bg-indigo-600 rounded-[2rem] text-white flex justify-between items-center shadow-2xl shadow-indigo-500/20">
                <div>
                    <span class="text-[10px] font-black uppercase tracking-widest text-indigo-200 block mb-1">Total Paid</span>
                    <span id="modalCost" class="text-2xl font-black"></span>
                </div>
                <i class="fa-solid fa-check-double text-3xl text-indigo-400/50"></i>
            </div>

            <div class="bg-slate-50 dark:bg-slate-800/50 p-5 rounded-3xl border border-slate-100 dark:border-slate-700/50">
                <span class="text-[9px] font-black uppercase text-slate-400 tracking-widest block mb-2"><i class="fa-solid fa-layer-group mr-1 text-indigo-500"></i>Parts & Service Details</span>
                <p id="modalParts" class="text-sm font-bold text-slate-700 dark:text-slate-300 leading-relaxed"></p>
            </div>

            <!-- FEEDBACK BLOCK -->
            <div id="feedbackFormBlock" class="pt-2">
                <h4 class="text-lg font-black text-slate-900 dark:text-white mb-4">Rate your experience</h4>
                <form action="SubmitFeedbackServlet" method="POST" id="mainFeedbackForm" class="space-y-4">
                    <input type="hidden" name="serviceRef" id="feedbackServiceRef">
                    <input type="hidden" name="feedbackId" id="editFeedbackId">
                    <div class="rating-stars mb-4">
                        <input type="radio" id="star5" name="rating" value="5" required/><label for="star5"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" id="star4" name="rating" value="4"/><label for="star4"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" id="star3" name="rating" value="3"/><label for="star3"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" id="star2" name="rating" value="2"/><label for="star2"><i class="fa-solid fa-star"></i></label>
                        <input type="radio" id="star1" name="rating" value="1"/><label for="star1"><i class="fa-solid fa-star"></i></label>
                    </div>
                    <textarea name="message" id="feedbackMessageArea" rows="3" class="w-full bg-slate-50 dark:bg-slate-800 border-2 border-slate-100 dark:border-slate-700 rounded-3xl p-4 text-sm font-medium focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 outline-none transition-all dark:text-white" placeholder="Any comments for our team?"></textarea>
                    <button type="submit" id="feedbackSubmitBtn" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-black py-4 rounded-3xl shadow-xl shadow-indigo-200 dark:shadow-none transition-all hover:scale-[1.02] active:scale-[0.98]">Post Review</button>
                </form>
            </div>

            <div id="feedbackSubmittedBlock" class="hidden pt-2">
                <div class="flex items-center justify-between mb-4">
                    <h4 class="text-lg font-black text-slate-900 dark:text-white flex items-center gap-2">
                        <i class="fa-solid fa-circle-check text-emerald-500"></i> Feedback Posted
                    </h4>
                    <div class="flex gap-4">
                        <button onclick="enableFeedbackEdit()" class="text-xs font-black text-indigo-600 dark:text-indigo-400 hover:underline">Edit</button>
                        <button type="button" onclick="openDeleteFeedbackModal()" class="text-xs font-black text-red-500 hover:underline">Delete</button>
                    </div>
                </div>
                <div class="bg-slate-50 dark:bg-slate-800/80 p-6 rounded-[2rem] border border-slate-100 dark:border-slate-700">
                    <div class="flex items-center gap-2 mb-4"><span class="text-[10px] font-black uppercase text-slate-400 tracking-widest">Rating:</span><div class="flex text-yellow-500 gap-1 text-sm" id="modalDisplayStars"></div></div>
                    <p id="modalUserComment" class="text-sm font-bold text-slate-700 dark:text-slate-300 italic"></p>
                    <div id="modalAdminReplyBlock" class="mt-4 pt-4 border-t border-slate-200/50 dark:border-slate-700">
                        <span class="text-[10px] font-black uppercase text-indigo-500 tracking-widest block mb-2">Team SwiftDrive Reply:</span>
                        <p class="text-sm font-black text-indigo-700 dark:text-indigo-300 bg-white dark:bg-indigo-900/30 p-4 rounded-2xl border border-indigo-100 dark:border-indigo-800/50" id="modalAdminReplyText"></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function openHistoryModal(date, plate, service, parts, cost, hasFb, rating, adminReply, fbId, userComment) {
    document.body.style.overflow = 'hidden';
    document.getElementById('modalDate').innerText = date;
    document.getElementById('modalPlate').innerText = plate;
    document.getElementById('modalService').innerText = service;
    document.getElementById('modalParts').innerText = parts && parts !== 'null' ? parts : 'No specific parts replaced.';
    document.getElementById('modalCost').innerText = 'LKR ' + cost;
    document.getElementById('feedbackServiceRef').value = date + " - " + service + " [" + plate + "]";
    document.getElementById('editFeedbackId').value = fbId;
    document.getElementById('deleteFeedbackId').value = fbId;
    document.getElementById('feedbackMessageArea').value = userComment || '';
    
    if (hasFb) {
        document.getElementById('feedbackFormBlock').classList.add('hidden');
        document.getElementById('feedbackSubmittedBlock').classList.remove('hidden');
        document.getElementById('modalUserComment').innerText = userComment ? '"' + userComment + '"' : 'No comments provided.';
        let s = ''; for (let i = 1; i <= 5; i++) s += '<i class="' + (i <= rating ? 'fa-solid' : 'fa-regular') + ' fa-star"></i>';
        document.getElementById('modalDisplayStars').innerHTML = s;
        if (adminReply && adminReply !== 'none') { 
            document.getElementById('modalAdminReplyBlock').classList.remove('hidden'); 
            document.getElementById('modalAdminReplyText').innerText = adminReply; 
        } else { 
            document.getElementById('modalAdminReplyBlock').classList.add('hidden'); 
        }
    } else {
        document.getElementById('feedbackFormBlock').classList.remove('hidden');
        document.getElementById('feedbackSubmittedBlock').classList.add('hidden');
        document.getElementById('mainFeedbackForm').action = 'SubmitFeedbackServlet';
        document.getElementById('feedbackSubmitBtn').innerText = 'Post Review';
        document.querySelectorAll('.rating-stars input').forEach(i => i.checked = false);
    }
    document.getElementById('historyModal').classList.remove('hidden');
}

function enableFeedbackEdit() {
    document.getElementById('feedbackSubmittedBlock').classList.add('hidden');
    document.getElementById('feedbackFormBlock').classList.remove('hidden');
    document.getElementById('mainFeedbackForm').action = 'UpdateFeedbackServlet';
    document.getElementById('feedbackSubmitBtn').innerText = 'Update Review';
}

function closeHistoryModal() {
    document.getElementById('historyModal').classList.add('hidden');
    document.body.style.overflow = 'auto';
}
function toggleMileageForm(id){
    const el=document.getElementById(id);
    if(el.style.maxHeight==='0px'||el.style.maxHeight===''){el.style.maxHeight=el.scrollHeight+20+'px';}else{el.style.maxHeight='0px';}
}

function openCancelAppModal(appId) {
    document.getElementById('cancelAppIdInput').value = appId;
    document.getElementById('cancelAppDisplay').textContent = appId;
    
    document.body.classList.add('overflow-hidden');
    const m = document.getElementById('cancelAppModal'); m.classList.remove('hidden');
    setTimeout(() => { 
        document.getElementById('cancelAppBackdrop').style.opacity = '1'; 
        document.getElementById('cancelAppPanel').classList.remove('scale-95', 'opacity-0');
        document.getElementById('cancelAppPanel').classList.add('scale-100', 'opacity-100');
    }, 20);
}

function closeCancelAppModal() {
    document.getElementById('cancelAppBackdrop').style.opacity = '0';
    document.getElementById('cancelAppPanel').classList.remove('scale-100', 'opacity-100');
    document.getElementById('cancelAppPanel').classList.add('scale-95', 'opacity-0');
    document.body.classList.remove('overflow-hidden');
    setTimeout(() => document.getElementById('cancelAppModal').classList.add('hidden'), 300);
}

function openDeleteFeedbackModal() {
    document.getElementById('deleteFeedbackModalInput').value = document.getElementById('deleteFeedbackId').value;
    
    // Ensure history modal doesn't trap focus or look weird
    const m = document.getElementById('deleteFeedbackModal'); m.classList.remove('hidden');
    setTimeout(() => { 
        document.getElementById('deleteFeedbackBackdrop').style.opacity = '1'; 
        document.getElementById('deleteFeedbackPanel').classList.remove('scale-95', 'opacity-0');
        document.getElementById('deleteFeedbackPanel').classList.add('scale-100', 'opacity-100');
    }, 20);
}

function closeDeleteFeedbackModal() {
    document.getElementById('deleteFeedbackBackdrop').style.opacity = '0';
    document.getElementById('deleteFeedbackPanel').classList.remove('scale-100', 'opacity-100');
    document.getElementById('deleteFeedbackPanel').classList.add('scale-95', 'opacity-0');
    setTimeout(() => document.getElementById('deleteFeedbackModal').classList.add('hidden'), 300);
}
</script>

<!-- CANCEL APPOINTMENT MODAL -->
<div id="cancelAppModal" class="hidden fixed inset-0 z-[200] flex items-center justify-center p-6">
    <div class="absolute inset-0 bg-slate-950/80 backdrop-blur-xl opacity-0 transition-opacity duration-300" id="cancelAppBackdrop" onclick="closeCancelAppModal()"></div>
    <div class="relative bg-white dark:bg-slate-900 rounded-[3rem] shadow-2xl max-w-sm w-full border border-slate-100 dark:border-slate-800 overflow-hidden transform scale-95 opacity-0 transition-all duration-300" id="cancelAppPanel">
        <div class="p-12 text-center">
            <div class="w-24 h-24 rounded-[2rem] bg-rose-50 dark:bg-rose-950 flex items-center justify-center mx-auto mb-10 text-rose-500 shadow-inner border border-rose-100 dark:border-rose-900/30">
                <i class="fa-solid fa-trash-can text-4xl"></i>
            </div>
            <h3 class="text-3xl font-black text-slate-900 dark:text-white tracking-tighter">Cancel Appointment?</h3>
            <p class="text-sm font-medium text-slate-500 dark:text-slate-400 mt-4 leading-relaxed">
                Are you sure you want to cancel the appointment <span id="cancelAppDisplay" class="font-bold text-slate-900 dark:text-white"></span>?
            </p>
            
            <form action="CancelAppointmentServlet" method="POST" class="flex flex-col gap-4 mt-10">
                <input type="hidden" name="appointmentId" id="cancelAppIdInput">
                <button type="submit" class="w-full py-5 rounded-2xl bg-rose-600 hover:bg-rose-700 text-white font-black text-[10px] uppercase tracking-[0.2em] shadow-2xl shadow-rose-100 dark:shadow-none transition-all active:scale-95 flex items-center justify-center gap-4">
                    <i class="fa-solid fa-trash-can text-lg"></i> Confirm & Cancel
                </button>
                <button type="button" onclick="closeCancelAppModal()" class="w-full py-5 rounded-2xl bg-white dark:bg-slate-950 border-2 border-slate-100 dark:border-slate-800 text-slate-400 dark:text-slate-700 font-black text-[10px] uppercase tracking-[0.2em] hover:bg-slate-50 dark:hover:bg-slate-800 transition-all">
                    Keep Appointment
                </button>
            </form>
        </div>
    </div>
</div>

<!-- DELETE FEEDBACK MODAL -->
<div id="deleteFeedbackModal" class="hidden fixed inset-0 z-[300] flex items-center justify-center p-6">
    <div class="absolute inset-0 bg-slate-950/80 backdrop-blur-xl opacity-0 transition-opacity duration-300" id="deleteFeedbackBackdrop" onclick="closeDeleteFeedbackModal()"></div>
    <div class="relative bg-white dark:bg-slate-900 rounded-[3rem] shadow-2xl max-w-sm w-full border border-slate-100 dark:border-slate-800 overflow-hidden transform scale-95 opacity-0 transition-all duration-300" id="deleteFeedbackPanel">
        <div class="p-12 text-center">
            <div class="w-24 h-24 rounded-[2rem] bg-rose-50 dark:bg-rose-950 flex items-center justify-center mx-auto mb-10 text-rose-500 shadow-inner border border-rose-100 dark:border-rose-900/30">
                <i class="fa-solid fa-trash-can text-4xl"></i>
            </div>
            <h3 class="text-3xl font-black text-slate-900 dark:text-white tracking-tighter">Delete Review?</h3>
            <p class="text-sm font-medium text-slate-500 dark:text-slate-400 mt-4 leading-relaxed">
                Are you sure you want to permanently delete this review? This action cannot be undone.
            </p>
            
            <form action="DeleteFeedbackServlet" method="POST" class="flex flex-col gap-4 mt-10">
                <input type="hidden" name="feedbackId" id="deleteFeedbackModalInput">
                <button type="submit" class="w-full py-5 rounded-2xl bg-rose-600 hover:bg-rose-700 text-white font-black text-[10px] uppercase tracking-[0.2em] shadow-2xl shadow-rose-100 dark:shadow-none transition-all active:scale-95 flex items-center justify-center gap-4">
                    Confirm & Delete
                </button>
                <button type="button" onclick="closeDeleteFeedbackModal()" class="w-full py-5 rounded-2xl bg-white dark:bg-slate-950 border-2 border-slate-100 dark:border-slate-800 text-slate-400 dark:text-slate-700 font-black text-[10px] uppercase tracking-[0.2em] hover:bg-slate-50 dark:hover:bg-slate-800 transition-all">
                    Cancel
                </button>
            </form>
        </div>
    </div>
</div>
<%@ include file="toast.jsp" %>
<script>
document.addEventListener("DOMContentLoaded",()=>{
    <% if ("true".equals(request.getParameter("feedbackSuccess"))) { %>showToast("Thank you! Your feedback has been posted.","success");<% } %>
    <% if ("true".equals(request.getParameter("feedbackUpdated"))) { %>showToast("Review updated and pending re-approval.","success");<% } %>
    <% if ("true".equals(request.getParameter("rescheduleSuccess"))) { %>showToast("Appointment successfully rescheduled.","success");<% } %>
    <% if ("true".equals(request.getParameter("cancelSuccess"))) { %>showToast("Appointment successfully cancelled.","success");<% } %>
    <% if ("cancelFailed".equals(request.getParameter("error"))) { %>showToast("Failed to cancel appointment.","error");<% } %>
    <% if ("rescheduleFailed".equals(request.getParameter("error"))) { %>showToast("Failed to reschedule.","error");<% } %>
    <% if ("invalidData".equals(request.getParameter("error"))) { %>showToast("Invalid appointment data.","error");<% } %>
    <% if ("invalidId".equals(request.getParameter("error"))) { %>showToast("Invalid appointment ID.","error");<% } %>
    <% if ("true".equals(request.getParameter("mileageUpdated"))) { %>showToast("Vehicle mileage updated!","success");<% } %>
    <% if ("true".equals(request.getParameter("vehicleDeleted"))) { %>showToast("Vehicle removed from your account.","success");<% } %>
    <% if ("unauthorized".equals(request.getParameter("error"))) { %>showToast("Unauthorized action.","error");<% } %>
});
</script>
<%@ include file="logout_script.jsp" %>
</body>
</html>
