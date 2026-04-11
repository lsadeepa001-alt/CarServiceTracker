<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.VehicleManager, model.Vehicle, model.UserManager, model.User, java.util.List" %>
<%@ include file="navbar.jsp" %>

<%
    // SECURITY Bouncer: Only the Admin (Shop Boss) is allowed in this room!
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
    <title>Manage Vehicles - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background: #f9fafc; } </style>
</head>
<body class="antialiased text-gray-900">

<div class="max-w-7xl mx-auto py-10 px-4 sm:px-6 lg:px-8">

    <div class="mb-8">
        <h1 class="text-3xl font-extrabold text-indigo-900"><i class="fa-solid fa-car-side mr-3"></i>Vehicle Management Center</h1>
        <p class="mt-2 text-sm text-gray-600">Register new vehicles and link them to their owners here.</p>
    </div>

    <div class="bg-white shadow-xl rounded-2xl border border-gray-100 p-6 mb-10">
        <h2 class="text-xl font-bold text-gray-800 mb-4">Register a New Vehicle</h2>

        <form action="AddVehicleServlet" method="POST" class="grid grid-cols-1 md:grid-cols-3 gap-4">

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
                <label class="block text-sm font-semibold text-gray-700">Mileage</label>
                <input type="number" name="mileage" placeholder="e.g. 55000" required class="mt-1 w-full px-4 py-2 border rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
            </div>

            <div>
                <label class="block text-sm font-semibold text-gray-700">Owner's Username</label>

                <input type="text" name="ownerUsername" list="user-list" placeholder="Select or type a name..." required autocomplete="off"
                       class="mt-1 w-full px-4 py-2 border rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500">

                <datalist id="user-list">
                    <%
                        // Read all users from the system
                        UserManager uManager = new UserManager();
                        List<User> allUserAccounts = uManager.getAllUsers();

                        for (User u : allUserAccounts) {
                            // Only suggest people who have a "customer" badge!
                            if (u.getRole().equals("customer")) {
                    %>
                                <option value="<%= u.getUsername() %>"></option>
                    <%
                            }
                        }
                    %>
                </datalist>
            </div>

            <div class="md:col-span-3 mt-4">
                <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-4 rounded-xl shadow-lg transition-colors">
                    <i class="fa-solid fa-plus mr-2"></i> Save Vehicle to System
                </button>
            </div>
        </form>
    </div>

    <div class="bg-white shadow-xl rounded-2xl border border-gray-100 overflow-hidden">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-indigo-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">License Plate</th>
                    <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Car Details</th>
                    <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Mileage</th>
                    <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Owner Username</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-200 bg-white">
                <%
                    VehicleManager vManager = (VehicleManager) session.getAttribute("vehicleManager");
                    if (vManager == null) {
                        vManager = new VehicleManager();
                        session.setAttribute("vehicleManager", vManager);
                    }

                    List<Vehicle> allCars = vManager.getAllVehicles();

                    if (allCars.isEmpty()) {
                %>
                        <tr><td colspan="4" class="px-6 py-8 text-center text-gray-500 italic">No vehicles registered yet.</td></tr>
                <%
                    } else {
                        for (Vehicle car : allCars) {
                %>
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-indigo-600"><%= car.getLicensePlate() %></td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700"><%= car.getYear() %> <%= car.getMake() %> <%= car.getModel() %></td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700"><%= car.getMileage() %> km</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700"><span class="bg-green-100 text-green-800 px-2 py-1 rounded-full text-xs"><%= car.getOwnerUsername() %></span></td>
                        </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>