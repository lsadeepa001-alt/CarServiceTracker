<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.VehicleManager, model.Vehicle, java.util.List" %>

<%
    // SECURITY Bouncer
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
    <title>Add Service Record - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background: #f0fdf4; /* A soft, clean background */ } </style>
</head>
<body class="antialiased min-h-screen flex flex-col justify-center items-center py-12 sm:px-6 lg:px-8">

    <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <div class="bg-white rounded-2xl shadow-xl overflow-hidden border border-gray-100">

            <div class="bg-indigo-600 px-6 py-4 flex items-center gap-3">
                <div class="bg-white/20 p-2 rounded-lg text-white">
                    <i class="fa-solid fa-plus"></i>
                </div>
                <h2 class="text-xl font-bold text-white tracking-wide">New service record</h2>
            </div>

            <div class="px-8 py-8">
                <form action="AddServiceServlet" method="POST" class="space-y-6">

                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1"><i class="fa-solid fa-car text-indigo-400 mr-2"></i>Select Vehicle</label>
                        <select name="licensePlate" required class="appearance-none block w-full px-4 py-3 border border-gray-200 rounded-xl shadow-sm bg-gray-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent sm:text-sm transition-all">
                            <option value="" disabled selected>-- Choose a registered car --</option>
                            <%
                                // Automatically pull all registered cars into the dropdown!
                                VehicleManager vManager = new VehicleManager();
                                List<Vehicle> allCars = vManager.getAllVehicles();
                                for (Vehicle car : allCars) {
                            %>
                                    <option value="<%= car.getLicensePlate() %>">
                                        <%= car.getLicensePlate() %> - <%= car.getMake() %> <%= car.getModel() %> (<%= car.getOwnerUsername() %>)
                                    </option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1"><i class="fa-regular fa-calendar text-indigo-400 mr-2"></i>Service date</label>
                        <input type="date" name="date" required class="appearance-none block w-full px-4 py-3 border border-gray-200 rounded-xl shadow-sm bg-gray-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent sm:text-sm transition-all">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1"><i class="fa-solid fa-clipboard-list text-indigo-400 mr-2"></i>Service type</label>
                        <input type="text" name="serviceType" placeholder="e.g., Oil change, brake pads" required class="appearance-none block w-full px-4 py-3 border border-gray-200 rounded-xl shadow-sm bg-gray-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent sm:text-sm transition-all">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1"><i class="fa-solid fa-money-bill-wave text-indigo-400 mr-2"></i>Cost (LKR)</label>
                        <div class="relative">
                            <span class="absolute left-4 top-3.5 text-gray-500">LKR</span>
                            <input type="number" step="0.01" name="cost" placeholder="0.00" required class="appearance-none block w-full pl-12 pr-4 py-3 border border-gray-200 rounded-xl shadow-sm bg-gray-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent sm:text-sm transition-all">
                        </div>
                    </div>

                    <div class="flex gap-4 pt-2">
                        <button type="submit" class="w-1/2 flex justify-center items-center py-3 px-4 border border-transparent rounded-xl shadow-md text-sm font-bold text-white bg-green-500 hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-all">
                            <i class="fa-solid fa-check mr-2"></i> Save record
                        </button>
                        <a href="dashboard.jsp" class="w-1/2 flex justify-center items-center py-3 px-4 border border-gray-300 rounded-xl shadow-sm text-sm font-bold text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-all">
                            <i class="fa-solid fa-xmark mr-2"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>