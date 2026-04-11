<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.InventoryManager, model.InventoryItem, java.util.List" %>
<%
    // SECURITY CHECK
    String role = (String) session.getAttribute("userRole");
    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Find out WHICH item the boss clicked on!
    String targetId = request.getParameter("id");
    if (targetId == null) {
        response.sendRedirect("inventory.jsp");
        return;
    }

    // Get the item's current details so we can show them on screen
    InventoryManager manager = new InventoryManager();
    InventoryItem targetItem = null;
    for (InventoryItem item : manager.getAllItems()) {
        if (item.getItemId().equals(targetId)) {
            targetItem = item;
            break;
        }
    }

    if (targetItem == null) {
        response.sendRedirect("inventory.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Adjust Stock - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background: #f8fafc; } </style>
</head>
<body class="antialiased flex flex-col items-center justify-center min-h-screen py-10 px-4">

    <div class="max-w-md w-full">

        <div class="mb-6 text-center">
            <h2 class="text-3xl font-extrabold text-slate-800"><i class="fa-solid fa-boxes-packing text-indigo-600 mr-2"></i>Adjust Stock</h2>
            <p class="mt-2 text-sm text-gray-500">Update quantities after a repair or a new delivery.</p>
        </div>

        <div class="bg-white shadow-xl rounded-2xl border border-gray-100 overflow-hidden">

            <div class="bg-slate-50 p-6 border-b border-gray-200 flex items-center gap-4">
                <div class="h-16 w-16 bg-white rounded-xl shadow-sm border border-gray-100 flex items-center justify-center text-2xl text-slate-400">
                    <i class="fa-solid <%= targetItem.getIconName() %>"></i>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-gray-900"><%= targetItem.getItemName() %></h3>
                    <p class="text-sm font-mono text-indigo-600 font-semibold"><%= targetItem.getItemId() %></p>
                </div>
            </div>

            <div class="p-6">
                <form action="UpdateInventoryServlet" method="POST" class="space-y-5">

                    <input type="hidden" name="itemId" value="<%= targetItem.getItemId() %>">

                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Current Quantity: <span class="text-indigo-600"><%= targetItem.getQuantity() %></span></label>
                        <p class="text-xs text-gray-400 mb-2">Enter the completely new total quantity below.</p>
                        <input type="number" name="newQuantity" value="<%= targetItem.getQuantity() %>" required min="0"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 text-lg font-bold">
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Unit Price (LKR)</label>
                        <input type="number" name="newPrice" value="<%= targetItem.getPrice() %>" required step="0.01" min="0"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500">
                    </div>

                    <div class="flex gap-4 pt-4">
                        <a href="inventory.jsp" class="w-1/2 text-center py-3 px-4 border border-gray-300 rounded-xl shadow-sm text-sm font-bold text-gray-700 bg-white hover:bg-gray-50 transition-all">
                            Cancel
                        </a>
                        <button type="submit" class="w-1/2 flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-md text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 transition-all">
                            Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</body>
</html>