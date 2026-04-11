<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.VehicleManager, model.Vehicle, java.util.List" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("userRole");
    if (username == null || !"customer".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Vehicles - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="bg-slate-50 antialiased text-gray-900 pt-16">
    <%@ include file="customer_navbar.jsp" %>

    <div class="max-w-7xl mx-auto py-10 px-4 sm:px-6 lg:px-8">
        
        <div class="mb-8">
            <h1 class="text-3xl font-extrabold text-indigo-900"><i class="fa-solid fa-car mr-3"></i>My Vehicles</h1>
            <p class="mt-2 text-sm text-gray-600">Register new vehicles and keep track of your registered fleet.</p>
        </div>

        <div class="bg-white shadow-xl rounded-2xl border border-gray-100 p-6 mb-10">
            <h2 class="text-xl font-bold text-gray-800 mb-4">Register a New Vehicle</h2>

            <!-- We explicitly add parameters to return directly back to this customer page -->
            <form action="AddVehicleServlet" method="POST" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">

                <!-- Hidden inputs lock the role/redirection down automatically without user input! -->
                <input type="hidden" name="ownerUsername" value="<%= username %>">
                <input type="hidden" name="redirect" value="customer_vehicles.jsp?success=added">

                <div>
                    <label class="block text-sm font-semibold text-gray-700">License Plate (ID)</label>
                    <input type="text" name="licensePlate" placeholder="e.g. CAA-1234" required class="mt-1 w-full px-4 py-2 border rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700">Make</label>
                    <input type="text" name="make" placeholder="e.g. Toyota" required class="mt-1 w-full px-4 py-2 border rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700">Model</label>
                    <input type="text" name="model" placeholder="e.g. Prius" required class="mt-1 w-full px-4 py-2 border rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700">Year</label>
                    <input type="number" name="year" placeholder="e.g. 2018" required class="mt-1 w-full px-4 py-2 border rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700">Mileage (km)</label>
                    <input type="number" name="mileage" placeholder="e.g. 55000" required class="mt-1 w-full px-4 py-2 border rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
                </div>

                <div class="lg:col-span-5 mt-2">
                    <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-4 rounded-xl shadow-md transition-colors">
                        <i class="fa-solid fa-plus mr-2"></i> Register Vehicle
                    </button>
                </div>
            </form>
        </div>

        <div class="bg-white shadow-xl rounded-2xl border border-gray-100 overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-slate-50">
                    <tr>
                        <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">License Plate</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Car Details</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Mileage</th>
                        <th class="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 bg-white">
                    <%
                        VehicleManager vManager = (VehicleManager) session.getAttribute("vehicleManager");
                        if (vManager == null) {
                            vManager = new VehicleManager();
                            session.setAttribute("vehicleManager", vManager);
                        }

                        List<Vehicle> customerCars = vManager.getVehiclesByOwner(username);

                        if (customerCars.isEmpty()) {
                    %>
                            <tr><td colspan="4" class="px-6 py-10 text-center text-gray-500 italic"><i class="fa-solid fa-car-tunnel text-4xl text-gray-200 mb-3 block"></i>You don't have any vehicles registered yet.</td></tr>
                    <%
                        } else {
                            for (Vehicle car : customerCars) {
                    %>
                            <tr class="hover:bg-slate-50 transition-colors">
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-indigo-600"><%= car.getLicensePlate() %></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700"><%= car.getYear() %> <%= car.getMake() %> <%= car.getModel() %></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700"><%= car.getMileage() %> km</td>
                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm">
                                    <a href="DeleteVehicleServlet?plate=<%= car.getLicensePlate() %>"
                                       class="inline-flex items-center gap-2 bg-white border border-red-200 text-red-600 hover:bg-red-50 hover:border-red-300 hover:text-red-700 px-3 py-1.5 rounded-lg transition-all duration-200 shadow-sm"
                                       onclick="return confirm('Are you sure you want to delete this vehicle from your account?');">
                                        <i class="fa-regular fa-trash-can"></i> Delete
                                    </a>
                                </td>
                            </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
<%@ include file="toast.jsp" %>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        <% if ("added".equals(request.getParameter("success"))) { %>
            showToast("Your new vehicle was successfully registered!", "success");
        <% } else if ("deleted".equals(request.getParameter("success"))) { %>
            showToast("Your vehicle was successfully removed.", "success");
        <% } %>
    });
</script>
<%@ include file="logout_script.jsp" %>
</body>
</html>
