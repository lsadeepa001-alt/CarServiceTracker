<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.VehicleManager, model.Vehicle, java.util.List" %>
<%
    // SECURITY CHECK: Must be logged in!
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
    <title>Book Appointment - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background: #f8fafc; } </style>
</head>
<body class="antialiased flex flex-col items-center justify-center min-h-screen py-10 px-4">

    <div class="max-w-lg w-full">
        <div class="mb-6 text-center">
            <h2 class="text-3xl font-extrabold text-slate-800"><i class="fa-solid fa-calendar-plus text-indigo-600 mr-2"></i>Book a Service</h2>
            <p class="mt-2 text-sm text-gray-500">Join the queue for your next vehicle repair or checkup.</p>
        </div>

        <div class="bg-white shadow-xl rounded-2xl border border-gray-100 p-8">
            <form action="BookAppointmentServlet" method="POST" class="space-y-5">

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Select Your Vehicle</label>
                    <select name="licensePlate" required class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 bg-white">
                        <option value="" disabled selected>-- Choose your car --</option>
                        <%
                            // Only show vehicles owned by THIS logged-in user!
                            VehicleManager vManager = new VehicleManager();
                            List<Vehicle> allCars = vManager.getAllVehicles();
                            boolean hasCars = false;
                            for (Vehicle car : allCars) {
                                if (car.getOwnerUsername().equals(username)) {
                                    hasCars = true;
                        %>
                                    <option value="<%= car.getLicensePlate() %>"><%= car.getLicensePlate() %> - <%= car.getMake() %> <%= car.getModel() %></option>
                        <%      }
                            }
                            if (!hasCars) {
                        %>
                                <option value="" disabled>No vehicles found! Please register a car first.</option>
                        <%  } %>
                    </select>
                </div>

                <div class="grid grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Preferred Date</label>
                        <input type="date" name="preferredDate" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Preferred Time</label>
                        <input type="time" name="preferredTime" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Describe the Issue</label>
                    <textarea name="issueDescription" rows="3" placeholder="E.g., Brakes are squeaking, needs oil change..." required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500"></textarea>
                </div>

                <div class="pt-4">
                    <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-md text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 transition-all">
                        <i class="fa-solid fa-ticket mr-2 mt-0.5"></i> Join the Service Queue
                    </button>
                    <a href="customer_dashboard.jsp" class="block w-full text-center mt-3 text-sm font-bold text-gray-500 hover:text-gray-700">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>