<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.BillingManager, model.Invoice, java.util.Stack" %>
<%@ include file="navbar.jsp" %>
<%
    // SECURITY CHECK: Admin only
    String role = (String) session.getAttribute("userRole");
    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // WAKE UP THE CASH REGISTER
    BillingManager bm = new BillingManager();
    Stack<Invoice> invoiceStack = bm.getAllInvoices();

    // CALCULATE FINANCIAL METRICS
    double totalRevenue = 0;
    double outstandingBalance = 0;
    int unpaidCount = 0;

    for (Invoice inv : invoiceStack) {
        if ("PAID".equals(inv.getStatus())) {
            totalRevenue += inv.getTotalAmount();
        } else {
            outstandingBalance += inv.getTotalAmount();
            unpaidCount++;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Billing & Invoices - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background: #f8fafc; } </style>
</head>
<body class="antialiased text-gray-900 pt-24">

<div class="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-extrabold text-slate-800"><i class="fa-solid fa-file-invoice-dollar text-indigo-600 mr-3"></i>Financial Dashboard</h1>
            <p class="mt-1 text-sm text-gray-500">Manage customer invoices, track revenue, and collect payments.</p>
        </div>
        <div>
            <a href="generate_bill.jsp" class="bg-indigo-600 hover:bg-indigo-700 text-white px-5 py-2.5 rounded-xl shadow-md font-bold transition-all">
                <i class="fa-solid fa-plus mr-2"></i> Generate New Bill
            </a>
        </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 border-l-4 border-l-green-500">
            <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">Total Revenue Collected</p>
            <h3 class="text-3xl font-black text-gray-800">LKR <%= String.format("%,.2f", totalRevenue) %></h3>
        </div>
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 border-l-4 border-l-red-500">
            <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">Outstanding Balance</p>
            <h3 class="text-3xl font-black text-red-600">LKR <%= String.format("%,.2f", outstandingBalance) %></h3>
        </div>
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 border-l-4 border-l-yellow-500">
            <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">Unpaid Invoices</p>
            <h3 class="text-3xl font-black text-yellow-600"><%= unpaidCount %> <span class="text-sm font-medium text-gray-500">bills pending</span></h3>
        </div>
    </div>

    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
        <div class="p-5 border-b border-gray-100 bg-gray-50 flex justify-between items-center">
            <h2 class="text-lg font-bold text-slate-800">Recent Invoices (LIFO Stack)</h2>
            <span class="text-xs font-bold text-indigo-500 bg-indigo-50 px-2 py-1 rounded border border-indigo-100">Showing Newest First</span>
        </div>

        <% if (invoiceStack.isEmpty()) { %>
            <div class="text-center py-12 text-gray-400 italic">No invoices have been generated yet.</div>
        <% } else { %>
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-white">
                    <tr>
                        <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Invoice ID</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Customer / Vehicle</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Total Amount</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase">Status</th>
                        <th class="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <%
                        // MAGIC TRICK: To show a Stack visually, we read it backwards (Top to Bottom)!
                        for (int i = invoiceStack.size() - 1; i >= 0; i--) {
                            Invoice inv = invoiceStack.get(i);
                            boolean isPaid = "PAID".equals(inv.getStatus());
                            String statusColor = isPaid ? "bg-green-100 text-green-800 border-green-200" : "bg-red-100 text-red-800 border-red-200 animate-pulse";
                            String statusIcon = isPaid ? "fa-check-circle" : "fa-circle-exclamation";
                    %>
                    <tr class="hover:bg-gray-50 transition-colors">
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-indigo-600"><%= inv.getInvoiceId() %></td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-bold text-gray-900"><%= inv.getCustomerUsername() %></div>
                            <div class="text-xs text-gray-500 font-mono"><i class="fa-solid fa-car text-gray-400 mr-1"></i><%= inv.getLicensePlate() %></div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-black text-gray-800">
                            LKR <%= String.format("%,.2f", inv.getTotalAmount()) %>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <span class="px-2.5 py-1 rounded-full text-xs font-bold border flex w-fit items-center gap-1 <%= statusColor %>">
                                <i class="fa-solid <%= statusIcon %>"></i> <%= inv.getStatus() %>
                            </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                            <% if (!isPaid) { %>
                                <form action="MarkPaidServlet" method="POST" class="inline">
                                    <input type="hidden" name="invoiceId" value="<%= inv.getInvoiceId() %>">
                                    <button type="submit" class="text-white bg-green-500 hover:bg-green-600 px-3 py-1.5 rounded-lg text-xs font-bold shadow-sm transition-colors">
                                        Mark Paid
                                    </button>
                                </form>
                            <% } else { %>
                                <span class="text-gray-400 text-xs font-bold"><i class="fa-solid fa-lock mr-1"></i>Settled</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>
</body>
</html>