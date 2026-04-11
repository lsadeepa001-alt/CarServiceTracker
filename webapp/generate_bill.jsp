<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // SECURITY CHECK: Admin only
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
    <title>Generate Invoice - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style> body { background: #f8fafc; } </style>
</head>
<body class="antialiased flex flex-col items-center justify-center min-h-screen py-10 px-4">

    <div class="max-w-xl w-full">

        <div class="mb-6 text-center">
            <h2 class="text-3xl font-extrabold text-slate-800"><i class="fa-solid fa-file-signature text-indigo-600 mr-2"></i>Create Invoice</h2>
            <p class="mt-2 text-sm text-gray-500">Calculate final costs and push a new bill to the customer.</p>
        </div>

        <div class="bg-white shadow-xl rounded-2xl border border-gray-100 overflow-hidden">
            <div class="p-8">
                <form action="GenerateBillServlet" method="POST" class="space-y-5">

                    <div class="grid grid-cols-2 gap-5">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Customer Username</label>
                            <input type="text" name="customerUsername" placeholder="e.g., saman" required
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 transition-all">
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Vehicle Plate</label>
                            <input type="text" name="licensePlate" placeholder="e.g., CAB-1234" required
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 uppercase transition-all">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Service Performed</label>
                        <input type="text" name="serviceDescription" placeholder="e.g., Full Engine Tuning & Oil Change" required
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 transition-all">
                    </div>

                    <div class="grid grid-cols-2 gap-5">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Parts Cost (LKR)</label>
                            <input type="number" name="partsCost" placeholder="0.00" required step="0.01" min="0"
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 transition-all">
                        </div>

                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Labor Cost (LKR)</label>
                            <input type="number" name="laborCost" placeholder="0.00" required step="0.01" min="0"
                                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 transition-all">
                        </div>
                    </div>

                    <div class="flex gap-4 pt-4">
                        <a href="billing_dashboard.jsp" class="w-1/3 text-center py-3 px-4 border border-gray-300 rounded-xl shadow-sm text-sm font-bold text-gray-700 bg-white hover:bg-gray-50 transition-all">
                            Cancel
                        </a>
                        <button type="submit" class="w-2/3 flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-md text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 transition-all">
                            <i class="fa-solid fa-file-invoice mr-2 mt-0.5"></i> Generate Bill
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</body>
</html>