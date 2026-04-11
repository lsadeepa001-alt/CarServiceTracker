<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ServiceTypeManager, model.ServiceType, java.util.List" %>
<%@ page import="model.ServiceTypeManager, model.ServiceType, java.util.List" %>
<%
    // SECURITY CHECK: Admin only!
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
    <title>Add New Part - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background: #f8fafc; } </style>
</head>
<body class="antialiased flex flex-col items-center justify-center min-h-screen py-10 px-4 sm:px-6 lg:px-8 pt-24">

    <div class="max-w-xl w-full">

        <div class="mb-6 text-center">
            <h2 class="text-3xl font-extrabold text-slate-800"><i class="fa-solid fa-box-open text-indigo-600 mr-2"></i>Add to Stock</h2>
            <p class="mt-2 text-sm text-gray-500">Register a new spare part into the warehouse inventory.</p>
        </div>

        <div class="bg-white shadow-xl rounded-2xl border border-gray-100 overflow-hidden">
            <div class="p-8">
                <form action="AddInventoryServlet" method="POST" class="space-y-5">

                    <div class="grid grid-cols-2 gap-5">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Part ID</label>
                            <input type="text" name="itemId" placeholder="e.g., BRK-001" required
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all uppercase">
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Part Name</label>
                            <input type="text" name="itemName" placeholder="e.g., Ceramic Brake Pads" required
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all">
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-5">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Category</label>
                            <select name="category" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 bg-white">
                                <option value="Engine">Engine</option>
                                <option value="Brakes">Brakes</option>
                                <option value="Suspension">Suspension</option>
                                <option value="Electrical">Electrical</option>
                                <option value="Fluids">Fluids & Oils</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Display Icon</label>
                            <select name="iconName" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 bg-white">
                                <option value="fa-gear">⚙️ Gear / Engine</option>
                                <option value="fa-car-battery">🔋 Battery / Electrical</option>
                                <option value="fa-oil-can">🛢️ Oil / Fluids</option>
                                <option value="fa-compact-disc">💿 Brake Disc</option>
                                <option value="fa-wrench">🔧 General Tool/Part</option>
                            </select>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 gap-5">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Applicable Service (Optional Mapping)</label>
                            <select name="applicableService" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 bg-white">
                                <option value="none">Universal Part (Fits All)</option>
                                <%
                                    ServiceTypeManager stm = new ServiceTypeManager();
                                    List<ServiceType> services = stm.getAllServices();
                                    for (ServiceType st : services) {
                                %>
                                    <option value="<%= st.getServiceName() %>"><%= st.getServiceName() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-5">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Initial Quantity</label>
                            <input type="number" name="quantity" placeholder="0" required min="0"
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 transition-all">
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Unit Price (LKR)</label>
                            <input type="number" name="price" placeholder="0.00" required step="0.01" min="0"
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 transition-all">
                        </div>
                    </div>

                    <div class="flex gap-4 pt-4">
                        <a href="inventory.jsp" class="w-1/3 text-center py-3 px-4 border border-gray-300 rounded-xl shadow-sm text-sm font-bold text-gray-700 bg-white hover:bg-gray-50 transition-all">
                            Cancel
                        </a>
                        <button type="submit" class="w-2/3 flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-md text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 transition-all">
                            <i class="fa-solid fa-check mr-2 mt-0.5"></i> Save to Inventory
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</body>
</html>