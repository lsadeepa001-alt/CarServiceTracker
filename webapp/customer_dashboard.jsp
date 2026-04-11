<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ServiceHistoryList, model.ServiceRecord, model.Node" %>
<%@ page import="model.BookingManager, model.Appointment, java.util.List" %>
<%@ page import="model.VehicleManager, model.Vehicle" %>
<%@ page import="model.BillingManager, model.Invoice, java.util.Stack" %> <%
    // SECURITY CHECK
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
    <title>My Dashboard - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .rating-stars { display: flex; flex-direction: row-reverse; justify-content: flex-end; gap: 0.25rem; }
        .rating-stars input { display: none; }
        .rating-stars label { cursor: pointer; color: #e2e8f0; font-size: 1.5rem; transition: color 0.2s; }
        .rating-stars input:checked ~ label,
        .rating-stars label:hover,
        .rating-stars label:hover ~ label { color: #facc15; }
    </style>
</head>
<body class="bg-slate-50 antialiased pt-16">

    <%@ include file="customer_navbar.jsp" %>

    <div class="max-w-7xl mx-auto py-10 px-4">

        <div class="mb-10">
            <h1 class="text-4xl font-extrabold text-slate-800">Welcome back, <span class="text-indigo-600"><%= username %></span>!</h1>
            <p class="text-gray-500 mt-2 text-lg">Manage your vehicles, book services, and track your maintenance history.</p>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

            <div class="lg:col-span-1 space-y-8">

                <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
                    <div class="bg-indigo-50 border-b border-gray-200 p-5 flex justify-between items-center">
                        <h2 class="text-xl font-bold text-slate-800"><i class="fa-regular fa-calendar-check text-indigo-600 mr-2"></i>My Appointments</h2>
                        <a href="book_appointment.jsp" class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold px-3 py-2 rounded-lg shadow-sm transition"><i class="fa-solid fa-plus mr-1"></i> Book</a>
                    </div>
                    <div class="p-5">
                        <%
                            BookingManager bm = new BookingManager();
                            List<Appointment> allApps = bm.getAllAppointmentsNatively();
                            boolean hasApp = false;

                            for (Appointment app : allApps) {
                                if (app.getCustomerUsername().equals(username)) {
                                    hasApp = true;
                                    String statusText = app.getStatus();
                                    String badgeClass = "text-amber-500"; // Pending
                                    if ("Under Maintenance".equals(statusText)) badgeClass = "text-orange-500 animate-pulse";
                                    else if ("Completed".equals(statusText)) badgeClass = "text-green-500";
                        %>
                                    <div class="mb-3 p-3 border border-indigo-100 bg-indigo-50/30 rounded-xl shadow-sm">
                                        <div class="flex justify-between items-start mb-1">
                                            <span class="text-xs font-bold text-indigo-500 bg-white px-2 py-0.5 border border-indigo-200 shadow-sm rounded"><%= app.getAppointmentId() %></span>
                                            <span class="text-xs font-bold <%= badgeClass %>"><i class="fa-solid fa-circle text-[8px] align-middle mr-1"></i> <%= statusText %></span>
                                        </div>
                                        <p class="font-bold text-gray-800 text-sm mt-2"><i class="fa-solid fa-car text-gray-400 mr-1"></i> <%= app.getLicensePlate() %> <span class="text-xs text-gray-400 font-normal ml-1">| <%= app.getIssueDescription() %></span></p>
                                        <p class="text-xs text-gray-500 mt-1"><i class="fa-regular fa-calendar text-gray-400 mr-1"></i> <%= app.getPreferredDate() %> at <%= app.getPreferredTime() %></p>
                                    </div>
                        <%      }
                            }
                            if (!hasApp) {
                        %>
                                <p class="text-sm text-gray-400 italic text-center py-4">You have no upcoming appointments.</p>
                        <%  } %>
                    </div>
                </div>

                <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
                    <div class="bg-indigo-50 border-b border-gray-200 p-5 flex justify-between items-center">
                        <h2 class="text-xl font-bold text-slate-800"><i class="fa-solid fa-warehouse text-indigo-600 mr-2"></i>My Garage</h2>
                        <a href="customer_vehicles.jsp" class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold px-3 py-2 rounded-lg shadow-sm transition"><i class="fa-solid fa-gear mr-1"></i> Manage</a>
                    </div>
                    <div class="p-5 space-y-3">
                        <%
                            VehicleManager vm = new VehicleManager();
                            List<Vehicle> myCars = vm.getAllVehicles();
                            boolean hasGarageCars = false;

                            for(Vehicle car : myCars) {
                                if(car.getOwnerUsername().equals(username)) {
                                    hasGarageCars = true;
                        %>
                                <div class="flex items-center gap-4 p-3 border border-gray-100 bg-gray-50 rounded-xl hover:shadow-md transition-shadow">
                                    <div class="h-12 w-12 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-600 text-xl shadow-inner">
                                        <i class="fa-solid fa-car-side"></i>
                                    </div>
                                    <div>
                                        <p class="font-bold text-gray-800 text-sm"><%= car.getMake() %> <%= car.getModel() %></p>
                                        <p class="text-xs text-indigo-500 font-mono font-bold border border-indigo-200 bg-white px-1.5 py-0.5 rounded inline-block mt-1">
                                            <%= car.getLicensePlate() %>
                                        </p>
                                    </div>
                                </div>
                        <%      }
                            }
                            if (!hasGarageCars) {
                        %>
                            <p class="text-sm text-gray-400 italic text-center py-4">You don't have any vehicles registered yet.</p>
                        <%  } %>
                    </div>
                </div>

            </div>

            <div class="lg:col-span-2 space-y-8">

                <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
                    <div class="p-5 border-b border-gray-200">
                        <h2 class="text-xl font-bold text-slate-800"><i class="fa-solid fa-file-invoice-dollar text-indigo-600 mr-2"></i>My Invoices</h2>
                    </div>
                    <div class="p-5 bg-slate-50">
                        <%
                            BillingManager billMgr = new BillingManager();
                            Stack<Invoice> allBills = billMgr.getAllInvoices();
                            boolean hasBills = false;

                            // Loop backward to show newest LIFO invoices first
                            for (int i = allBills.size() - 1; i >= 0; i--) {
                                Invoice inv = allBills.get(i);
                                if (inv.getCustomerUsername().equals(username)) {
                                    hasBills = true;
                                    boolean isPaid = "PAID".equals(inv.getStatus());
                                    String badgeClass = isPaid ? "bg-green-100 text-green-700 border-green-200" : "bg-red-100 text-red-700 border-red-200 animate-pulse";
                        %>
                                <div class="flex justify-between items-center p-4 mb-3 border border-gray-200 bg-white rounded-xl shadow-sm">
                                    <div>
                                        <p class="font-bold text-gray-800"><%= inv.getServiceDescription() %></p>
                                        <p class="text-xs text-gray-500 mt-1">
                                            <span class="font-mono text-indigo-500 bg-indigo-50 px-1 py-0.5 rounded mr-2"><%= inv.getInvoiceId() %></span>
                                            <i class="fa-solid fa-car text-gray-400 mr-1"></i><%= inv.getLicensePlate() %>
                                        </p>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-lg font-black text-slate-800">LKR <%= String.format("%,.2f", inv.getTotalAmount()) %></p>
                                        <span class="text-xs font-bold px-2 py-1 rounded mt-1 border inline-block <%= badgeClass %>">
                                            <%= inv.getStatus() %>
                                        </span>
                                    </div>
                                </div>
                        <%
                                }
                            }
                            if (!hasBills) {
                        %>
                            <p class="text-sm text-gray-400 italic text-center py-4">You have no pending or past invoices.</p>
                        <%  } %>
                    </div>
                </div>

                <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
                    <div class="p-5 border-b border-gray-200">
                        <h2 class="text-xl font-bold text-slate-800"><i class="fa-solid fa-clipboard-list text-gray-700 mr-2"></i>Service History</h2>
                    </div>

                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Date</th>
                                <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Vehicle</th>
                                <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Service Performed</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100">
                            <%
                                ServiceHistoryList list = (ServiceHistoryList) session.getAttribute("serviceList");
                                if (list == null) {
                                    list = new ServiceHistoryList();
                                    list.loadFromFile();
                                }

                                Node current = list.head;
                                boolean hasHistory = false;

                                while (current != null) {
                                    boolean belongsToUser = false;
                                    for(Vehicle c : myCars) {
                                        if(c.getOwnerUsername().equals(username) && c.getLicensePlate().equals(current.data.getLicensePlate())) {
                                            belongsToUser = true;
                                            break;
                                        }
                                    }

                                    if(belongsToUser) {
                                        hasHistory = true;
                            %>
                                        <tr class="hover:bg-gray-50 border-transparent hover:border-indigo-100 cursor-pointer transition-all border-l-4" 
                                            onclick="openHistoryModal('<%= current.data.getDate() %>', '<%= current.data.getLicensePlate() %>', '<%= current.data.getServiceType() %>', '<%= current.data.getPartsUsed() %>', '<%= String.format("%,.2f", current.data.getCost()) %>')">
                                            <td class="px-6 py-4 text-sm font-medium text-gray-900"><%= current.data.getDate() %></td>
                                            <td class="px-6 py-4 text-sm font-mono text-gray-500"><%= current.data.getLicensePlate() %></td>
                                            <td class="px-6 py-4 text-sm font-bold text-indigo-600"><%= current.data.getServiceType() %></td>
                                        </tr>
                                <%
                                        }
                                        current = current.next;
                                    }

                                    if (!hasHistory) {
                                %>
                                        <tr><td colspan="3" class="px-6 py-8 text-center text-sm text-gray-400 italic">No service history found for your vehicles.</td></tr>
                                <%  } %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>

    <!-- NATIVE TAILWIND MODAL FOR HISTORY -->
    <div id="historyModal" class="hidden fixed inset-0 z-50 overflow-y-auto bg-black/50 backdrop-blur-sm shadow-2xl flex items-center justify-center transition-opacity duration-300">
        <div class="bg-white rounded-3xl shadow-2xl max-w-lg w-full p-8 transform scale-95 transition-transform duration-300">
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h3 class="text-2xl font-black text-gray-900"><i class="fa-solid fa-book-open text-indigo-500 mr-2"></i>Service Log</h3>
                    <p id="modalDate" class="text-sm font-bold text-gray-500 mt-1"></p>
                </div>
                <button onclick="closeHistoryModal()" class="text-gray-400 hover:text-gray-600 focus:outline-none"><i class="fa-solid fa-xmark text-2xl"></i></button>
            </div>
            <div class="space-y-6">
                <div class="flex justify-between items-end border-b border-gray-100 pb-4">
                    <div>
                        <span class="text-xs uppercase font-bold text-gray-400 block mb-1">Vehicle Handled</span>
                        <span id="modalPlate" class="text-lg font-mono font-bold text-indigo-600 bg-indigo-50 px-2 py-1 rounded"></span>
                    </div>
                    <div class="text-right">
                        <span class="text-xs uppercase font-bold text-gray-400 block mb-1">Core Service</span>
                        <span id="modalService" class="text-lg font-black text-gray-800"></span>
                    </div>
                </div>
                <div class="bg-gray-50 p-4 rounded-xl border border-gray-200">
                    <span class="text-xs uppercase font-bold text-gray-500 block mb-2"><i class="fa-solid fa-boxes-stacked mr-1"></i>Parts & Inventory Consumed</span>
                    <p id="modalParts" class="text-sm text-gray-700 italic"></p>
                </div>
                <div class="flex justify-between items-center bg-indigo-600 text-white p-4 rounded-xl shadow-inner mt-4">
                    <span class="text-sm font-bold uppercase tracking-wider text-indigo-200">Total Billed</span>
                    <span id="modalCost" class="text-2xl font-black tracking-tight"></span>
                </div>
                
                <div class="mt-6 border-t border-gray-100 pt-5">
                    <h4 class="text-sm font-bold text-slate-800 mb-3 block"><i class="fa-solid fa-star text-indigo-500 mr-2"></i>Rate this Service</h4>
                    <form action="SubmitFeedbackServlet" method="POST" class="space-y-3">
                        <input type="hidden" name="serviceRef" id="feedbackServiceRef">
                        
                        <div class="rating-stars mb-2 pl-1">
                            <input type="radio" id="star5" name="rating" value="5" required />
                            <label for="star5"><i class="fa-solid fa-star"></i></label>
                            
                            <input type="radio" id="star4" name="rating" value="4" />
                            <label for="star4"><i class="fa-solid fa-star"></i></label>
                            
                            <input type="radio" id="star3" name="rating" value="3" />
                            <label for="star3"><i class="fa-solid fa-star"></i></label>
                            
                            <input type="radio" id="star2" name="rating" value="2" />
                            <label for="star2"><i class="fa-solid fa-star"></i></label>
                            
                            <input type="radio" id="star1" name="rating" value="1" />
                            <label for="star1"><i class="fa-solid fa-star"></i></label>
                        </div>
                        
                        <textarea name="message" rows="2" class="w-full border-2 border-gray-200 rounded-xl p-3 text-sm focus:ring-2 focus:ring-indigo-500 outline-none transition-all" placeholder="Tell us how we did (Optional)"></textarea>
                        
                        <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2.5 rounded-xl shadow-sm transition">Post Review</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function openHistoryModal(date, plate, service, parts, cost) {
            document.getElementById('modalDate').innerText = date;
            document.getElementById('modalPlate').innerText = plate;
            document.getElementById('modalService').innerText = service;
            document.getElementById('modalParts').innerText = parts && parts !== 'null' ? parts : 'No physical parts consumed.';
            document.getElementById('modalCost').innerText = 'LKR ' + cost;
            
            // Set dynamic feedback context
            document.getElementById('feedbackServiceRef').value = date + " - " + service + " [" + plate + "]";
            
            const modal = document.getElementById('historyModal');
            modal.classList.remove('hidden');
            setTimeout(() => { modal.firstElementChild.classList.remove('scale-95'); }, 10);
        }
        function closeHistoryModal() {
            const modal = document.getElementById('historyModal');
            modal.firstElementChild.classList.add('scale-95');
            setTimeout(() => { modal.classList.add('hidden'); }, 200);
        }
    </script>
<%@ include file="toast.jsp" %>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        <% if ("true".equals(request.getParameter("feedbackSuccess"))) { %>
            showToast("Thank you! Your feedback has been posted.", "success");
        <% } %>
    });
</script>
<%@ include file="logout_script.jsp" %>
</body>
</html>
