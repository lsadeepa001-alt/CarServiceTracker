<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ServiceTypeManager, model.ServiceType, java.util.List" %>
<%@ include file="navbar.jsp" %>
<%
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
    <title>Manage Services - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="bg-gray-50 antialiased text-gray-900 pt-24">

<div class="max-w-7xl mx-auto py-10 px-4 sm:px-6 lg:px-8">
    <div class="mb-8">
        <h1 class="text-3xl font-extrabold text-indigo-900"><i class="fa-solid fa-clipboard-check mr-3"></i>Service Types Control</h1>
        <p class="mt-2 text-sm text-gray-600">Register abstract services and define their base labor costs.</p>
    </div>

    <!-- ADD SERVICE TILE -->
    <div class="bg-white shadow-xl rounded-2xl border border-gray-100 p-6 mb-10">
        <h2 class="text-xl font-bold text-gray-800 mb-4">Register a New Service</h2>
        <form action="AddServiceTypeServlet" method="POST" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div class="lg:col-span-1">
                <label class="block text-sm font-semibold text-gray-700">Service Name</label>
                <input type="text" name="serviceName" placeholder="e.g. Tire Rotation" required class="mt-1 w-full px-4 py-2 border rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
            </div>
            <div class="lg:col-span-1">
                <label class="block text-sm font-semibold text-gray-700">Base Cost (LKR)</label>
                <input type="number" step="0.01" name="basePrice" placeholder="e.g. 1500.00" required class="mt-1 w-full px-4 py-2 border rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
            </div>
            <div class="lg:col-span-1 flex items-end">
                <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2.5 px-4 rounded-xl shadow-lg transition-colors">
                    <i class="fa-solid fa-plus mr-2"></i> Create Service
                </button>
            </div>
        </form>
    </div>

    <!-- SERVICES TABLE -->
    <div class="bg-white shadow-xl rounded-2xl border border-gray-100 overflow-hidden">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-indigo-50">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Service Name</th>
                    <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Base Labor Cost</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-200 bg-white">
                <%
                    ServiceTypeManager stm = new ServiceTypeManager();
                    List<ServiceType> services = stm.getAllServices();
                    for (ServiceType st : services) {
                %>
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-indigo-600"><%= st.getServiceName() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">LKR <%= String.format("%,.2f", st.getDefaultBasePrice()) %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="toast.jsp" %>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        <% if ("added".equals(request.getParameter("success"))) { %>
            showToast("New Service successfully created!", "success");
        <% } %>
    });
</script>
</body>
</html>
