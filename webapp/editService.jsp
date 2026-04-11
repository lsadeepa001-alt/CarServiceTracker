<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 1. CATCH THE SECRET MESSAGE (Now including the plate!)
    String oldDate = request.getParameter("date");
    String oldType = request.getParameter("type");
    String oldCost = request.getParameter("cost");
    String targetPlate = request.getParameter("plate"); // The car we are editing!

    if (oldDate == null || oldType == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Service - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background-color: #f9fafc; } </style>
</head>
<body class="bg-gradient-to-br from-slate-50 to-gray-100 antialiased min-h-screen flex flex-col justify-center py-12 sm:px-6 lg:px-8 pt-24">

    <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">Edit Service Record</h2>
    </div>

    <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div class="bg-white py-8 px-4 shadow-2xl sm:rounded-2xl sm:px-10 border border-gray-100">

            <form action="UpdateServiceServlet" method="POST" class="space-y-6">

                <input type="hidden" name="oldDate" value="<%= oldDate %>">
                <input type="hidden" name="oldType" value="<%= oldType %>">
                <input type="hidden" name="targetPlate" value="<%= targetPlate %>">

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">Vehicle</label>
                    <div class="mt-1 px-4 py-3 bg-gray-100 border-2 border-gray-200 rounded-xl text-gray-600 font-mono shadow-inner cursor-not-allowed">
                        <i class="fa-solid fa-car mr-2"></i> <%= targetPlate %>
                    </div>
                    <p class="text-xs text-gray-400 mt-1">The vehicle tied to a record cannot be changed.</p>
                </div>

                <div>
                    <label for="newDate" class="block text-sm font-semibold text-gray-700 mb-1">Date of Service</label>
                    <input id="newDate" name="newDate" type="date" value="<%= oldDate %>" required
                           class="appearance-none block w-full px-4 py-3 border-2 border-gray-200 rounded-xl shadow-sm focus:ring-blue-500 focus:border-transparent sm:text-sm">
                </div>

                <div>
                    <label for="newType" class="block text-sm font-semibold text-gray-700 mb-1">Service Type</label>
                    <input id="newType" name="newType" type="text" value="<%= oldType %>" required
                           class="appearance-none block w-full px-4 py-3 border-2 border-gray-200 rounded-xl shadow-sm focus:ring-blue-500 focus:border-transparent sm:text-sm">
                </div>

                <div>
                    <label for="newCost" class="block text-sm font-semibold text-gray-700 mb-1">Total Cost (LKR)</label>
                    <input id="newCost" name="newCost" type="number" step="0.01" value="<%= oldCost %>" required
                           class="appearance-none block w-full px-4 py-3 border-2 border-gray-200 rounded-xl shadow-sm focus:ring-blue-500 focus:border-transparent sm:text-sm">
                </div>

                <div class="flex gap-4 pt-4">
                    <a href="dashboard.jsp" class="w-1/2 flex justify-center py-3 px-4 border-2 border-gray-200 rounded-xl shadow-sm text-sm font-semibold text-gray-700 bg-white hover:bg-gray-50 transition-all">Cancel</a>
                    <button type="submit" class="w-1/2 flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-lg text-sm font-semibold text-white bg-blue-600 hover:bg-blue-700 transition-all">Save Changes</button>
                </div>
            </form>

        </div>
    </div>
</body>
</html>