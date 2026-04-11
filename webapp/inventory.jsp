<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.InventoryManager, model.InventoryItem, java.util.List" %>
<%@ include file="navbar.jsp" %>

<%
    // SECURITY CHECK: Admin only
    String role = (String) session.getAttribute("userRole");
    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 1. WAKE UP THE INVENTORY MANAGER
    InventoryManager invManager = new InventoryManager();
    List<InventoryItem> items = invManager.getAllItems();

    // 2. CALCULATE DASHBOARD METRICS
    double totalValue = 0;
    int outOfStockCount = 0;
    int lowStockCount = 0;

    for (InventoryItem item : items) {
        totalValue += (item.getPrice() * item.getQuantity());
        if (item.getQuantity() == 0) outOfStockCount++;
        else if (item.getQuantity() <= 5) lowStockCount++;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Inventory Management - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background: #f8fafc; } </style>
</head>
<body class="antialiased text-gray-900">

<div class="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-extrabold text-slate-800"><i class="fa-solid fa-boxes-stacked text-indigo-600 mr-3"></i>Stock Inventory</h1>
            <p class="mt-1 text-sm text-gray-500">Manage spare parts, track quantities, and monitor stock health.</p>
        </div>
        <div>
            <a href="add_inventory.jsp" class="bg-indigo-600 hover:bg-indigo-700 text-white px-5 py-2.5 rounded-xl shadow-md font-bold transition-all">
                <i class="fa-solid fa-plus mr-2"></i> Add New Part
            </a>
        </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 border-l-4 border-l-blue-500">
            <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">Total Parts Catalog</p>
            <h3 class="text-2xl font-black text-gray-800"><%= items.size() %></h3>
        </div>
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 border-l-4 border-l-green-500">
            <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">Total Stock Value</p>
            <h3 class="text-2xl font-black text-gray-800">LKR <%= String.format("%,.2f", totalValue) %></h3>
        </div>
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 border-l-4 border-l-yellow-500">
            <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">Low Stock Warning</p>
            <h3 class="text-2xl font-black text-yellow-600"><%= lowStockCount %> <span class="text-sm font-medium text-gray-500">items</span></h3>
        </div>
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 border-l-4 border-l-red-500">
            <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">Out of Stock</p>
            <h3 class="text-2xl font-black text-red-600"><%= outOfStockCount %> <span class="text-sm font-medium text-gray-500">items</span></h3>
        </div>
    </div>

    <div class="bg-white p-4 rounded-xl shadow-sm border border-gray-200 mb-8 flex flex-col md:flex-row gap-4 items-center">
        <div class="relative flex-grow w-full md:w-auto">
            <i class="fa-solid fa-magnifying-glass absolute left-4 top-3.5 text-gray-400"></i>
            <input type="text" id="searchInput" onkeyup="filterGrid()" placeholder="Search part name or ID..." class="w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg focus:ring-indigo-500 focus:border-indigo-500">
        </div>

        <select id="categoryFilter" onchange="filterGrid()" class="w-full md:w-48 py-2.5 px-4 bg-gray-50 border border-gray-200 rounded-lg focus:ring-indigo-500">
            <option value="all">All Categories</option>
            <option value="engine">Engine</option>
            <option value="brakes">Brakes</option>
            <option value="suspension">Suspension</option>
            <option value="electrical">Electrical</option>
            <option value="fluids">Fluids & Oils</option>
        </select>

        <select id="statusFilter" onchange="filterGrid()" class="w-full md:w-48 py-2.5 px-4 bg-gray-50 border border-gray-200 rounded-lg focus:ring-indigo-500">
            <option value="all">All Statuses</option>
            <option value="in stock">In Stock</option>
            <option value="low stock">Low Stock</option>
            <option value="out of stock">Out of Stock</option>
        </select>
    </div>

    <div id="inventoryGrid" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">

        <% if (items.isEmpty()) { %>
            <div class="col-span-full text-center py-12 text-gray-400 italic">
                No items in inventory. Click 'Add New Part' to begin!
            </div>
        <% } else {
            for (InventoryItem item : items) {
                // Determine Badge Colors dynamically based on quantity
                String statusColor = "bg-green-100 text-green-800"; // Default In Stock
                String statusIcon = "fa-check-circle";
                String statusText = item.getStockStatus();

                if (item.getQuantity() == 0) {
                    statusColor = "bg-red-100 text-red-800";
                    statusIcon = "fa-circle-xmark";
                } else if (item.getQuantity() <= 5) {
                    statusColor = "bg-yellow-100 text-yellow-800";
                    statusIcon = "fa-triangle-exclamation";
                }
        %>
            <div class="inventory-card bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-lg transition-shadow duration-300"
                 data-name="<%= item.getItemName().toLowerCase() %> <%= item.getItemId().toLowerCase() %>"
                 data-category="<%= item.getCategory().toLowerCase() %>"
                 data-status="<%= statusText.toLowerCase() %>">

                <div class="bg-slate-100 h-40 flex items-center justify-center border-b border-gray-100 relative">
                    <span class="absolute top-3 left-3 bg-white/80 backdrop-blur text-xs font-bold px-2 py-1 rounded shadow-sm text-gray-600"><%= item.getItemId() %></span>
                    <i class="fa-solid <%= item.getIconName() %> text-6xl text-slate-300 drop-shadow-sm"></i>
                </div>

                <div class="p-5">
                    <div class="flex justify-between items-start mb-2">
                        <h3 class="text-lg font-bold text-gray-900 truncate pr-2"><%= item.getItemName() %></h3>
                        <span class="text-xs font-bold uppercase tracking-wider text-indigo-500 bg-indigo-50 px-2 py-1 rounded"><%= item.getCategory() %></span>
                    </div>

                    <div class="flex justify-between items-end mb-4">
                        <p class="text-xl font-black text-slate-700">LKR <%= String.format("%,.2f", item.getPrice()) %></p>
                    </div>

                    <div class="flex justify-between items-center p-3 bg-gray-50 rounded-xl mb-4 border border-gray-100">
                        <div class="flex flex-col">
                            <span class="text-xs text-gray-500 font-semibold uppercase">Quantity</span>
                            <span class="text-lg font-black <%= item.getQuantity() == 0 ? "text-red-500" : "text-gray-800" %>"><%= item.getQuantity() %></span>
                        </div>
                        <span class="px-2.5 py-1 rounded-full text-xs font-bold flex items-center gap-1 <%= statusColor %>">
                            <i class="fa-solid <%= statusIcon %>"></i> <%= statusText %>
                        </span>
                    </div>

                    <a href="adjustStock.jsp?id=<%= item.getItemId() %>" class="block w-full text-center bg-white border-2 border-slate-200 text-slate-700 hover:border-indigo-500 hover:text-indigo-600 font-bold py-2 rounded-xl transition-colors">
                        <i class="fa-solid fa-boxes-packing mr-1"></i> Adjust Stock
                    </a>
                </div>
            </div>
        <%  }
        } %>

    </div>
</div>

<script>
    function filterGrid() {
        const searchBox = document.getElementById('searchInput').value.toLowerCase();
        const categoryBox = document.getElementById('categoryFilter').value.toLowerCase();
        const statusBox = document.getElementById('statusFilter').value.toLowerCase();
        const allCards = document.querySelectorAll('.inventory-card');

        allCards.forEach(card => {
            const cardName = card.getAttribute('data-name');
            const cardCategory = card.getAttribute('data-category');
            const cardStatus = card.getAttribute('data-status');

            const matchesSearch = cardName.includes(searchBox);
            const matchesCategory = (categoryBox === 'all') || (cardCategory === categoryBox);
            const matchesStatus = (statusBox === 'all') || (cardStatus === statusBox);

            if (matchesSearch && matchesCategory && matchesStatus) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }
</script>

</body>
</html>