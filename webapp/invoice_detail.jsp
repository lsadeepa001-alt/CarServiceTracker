<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.BillingManager, model.Invoice, model.PaymentManager, model.Payment, java.util.List, java.time.LocalDate, java.time.temporal.ChronoUnit" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"admin".equals(role)) { response.sendRedirect("login.jsp"); return; }

    String invoiceId = request.getParameter("id");
    BillingManager bm = new BillingManager();
    Invoice inv = bm.getInvoiceById(invoiceId);

    if (inv == null) {
        response.sendRedirect("billing_dashboard.jsp?error=notfound");
        return;
    }

    PaymentManager pm = new PaymentManager();
    List<Payment> payments = pm.getPaymentsByInvoiceId(invoiceId);
    
    double totalPaid = 0;
    for (Payment p : payments) {
        totalPaid += p.getAmount();
    }
    double balance = inv.getTotalAmount() - totalPaid;
    if (balance < 0) balance = 0;

    boolean isPaid = "PAID".equals(inv.getStatus());
    boolean isVoid = "VOID".equals(inv.getStatus());
    
    boolean canReinstate = false;
    long daysRemaining = 0;
    if (isVoid) {
        LocalDate issued = LocalDate.parse(inv.getDateIssued());
        LocalDate deadline = issued.plusMonths(6);
        LocalDate now = LocalDate.now();
        if (now.isBefore(deadline) || now.isEqual(deadline)) {
            canReinstate = true;
            daysRemaining = ChronoUnit.DAYS.between(now, deadline);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice Details - SwiftDrive</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Plus Jakarta Sans', sans-serif; }
        .mono { font-family: 'JetBrains Mono', monospace; }
        @media print {
            body * { visibility: hidden; }
            .print-zone, .print-zone * { visibility: visible; }
            .print-zone { position: absolute; left: 0; top: 0; width: 100%; padding: 0; }
            .no-print { display: none !important; }
        }
    </style>
</head>
<body class="antialiased text-slate-900 dark:text-slate-100 bg-slate-50 dark:bg-slate-950 transition-colors duration-300 min-h-screen pt-28 pb-20">
<%@ include file="navbar.jsp" %>

<div class="max-w-4xl mx-auto px-4">
    <!-- Header Controls -->
    <div class="flex items-center justify-between mb-8 no-print">
        <a href="billing_dashboard.jsp" class="inline-flex items-center gap-2 text-[10px] font-black text-slate-400 dark:text-slate-600 uppercase tracking-[0.2em] hover:text-indigo-600 transition-colors">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
        <div class="flex items-center gap-3">
            <button onclick="window.print()" class="px-6 py-3 rounded-2xl border-2 border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400 font-black text-[10px] uppercase tracking-widest hover:bg-slate-100 dark:hover:bg-slate-900 transition-all flex items-center gap-2">
                <i class="fa-solid fa-print"></i> Print
            </button>
            <% if (!isVoid && !isPaid) { %>
            <a href="editInvoice.jsp?id=<%= inv.getInvoiceId() %>" class="px-6 py-3 rounded-2xl bg-indigo-50 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-400 font-black text-[10px] uppercase tracking-widest hover:bg-indigo-100 dark:hover:bg-indigo-900/50 transition-all flex items-center gap-2">
                <i class="fa-solid fa-pen-to-square"></i> Edit Invoice
            </a>
            <% } %>
            <% if (isVoid && canReinstate) { %>
            <form action="ReinstateInvoiceServlet" method="POST" class="inline">
                <input type="hidden" name="invoiceId" value="<%= inv.getInvoiceId() %>">
                <button type="submit" class="px-6 py-3 rounded-2xl bg-emerald-600 text-white font-black text-[10px] uppercase tracking-widest hover:bg-emerald-700 transition-all flex items-center gap-2 shadow-lg shadow-emerald-200 dark:shadow-none">
                    <i class="fa-solid fa-clock-rotate-left"></i> Reinstate Invoice
                </button>
            </form>
            <% } %>
        </div>
    </div>

    <!-- MAIN INVOICE AREA -->
    <div class="print-zone bg-white dark:bg-slate-900 rounded-[3rem] border border-slate-100 dark:border-slate-800 p-12 shadow-2xl shadow-slate-200/40 dark:shadow-none mb-12 relative overflow-hidden">
        <% if (isVoid) { %>
            <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 text-rose-500 font-black text-9xl opacity-5 rotate-[-30deg] pointer-events-none tracking-widest">VOIDED</div>
        <% } %>
        
        <div class="flex justify-between items-start mb-12">
            <div>
                <h1 class="text-3xl font-black text-slate-900 dark:text-white flex items-center gap-3">
                    <i class="fa-solid fa-car-side text-indigo-600"></i> SwiftDrive
                </h1>
                <p class="text-[9px] font-black text-slate-400 uppercase tracking-widest mt-2">No. 42, Galle Road, Colombo</p>
                <p class="text-[9px] font-black text-slate-400 uppercase tracking-widest">support@swiftdrive.com</p>
            </div>
            <div class="text-right">
                <h2 class="mono text-2xl font-black text-indigo-600">#<%= inv.getInvoiceId() %></h2>
                <p class="text-[9px] font-black text-slate-400 uppercase tracking-widest mt-2">Issued: <%= inv.getDateIssued() %></p>
                <% if (isVoid) { %>
                    <span class="mt-3 inline-block px-4 py-1.5 rounded-full bg-rose-50 border border-rose-100 text-rose-600 text-[10px] font-black uppercase tracking-widest">VOIDED ON <%= inv.getVoidedDate() != null ? inv.getVoidedDate() : "N/A" %></span>
                <% } else if (isPaid) { %>
                    <span class="mt-3 inline-block px-4 py-1.5 rounded-full bg-emerald-50 border border-emerald-100 text-emerald-600 text-[10px] font-black uppercase tracking-widest">FULLY PAID</span>
                <% } else { %>
                    <span class="mt-3 inline-block px-4 py-1.5 rounded-full bg-amber-50 border border-amber-100 text-amber-600 text-[10px] font-black uppercase tracking-widest">PAYMENT PENDING</span>
                <% } %>
            </div>
        </div>

        <div class="grid grid-cols-2 gap-8 mb-12">
            <div class="bg-slate-50 dark:bg-slate-950 rounded-2xl p-6 border border-slate-100 dark:border-slate-800">
                <p class="text-[9px] font-black text-slate-400 uppercase tracking-widest mb-2">Billed To</p>
                <p class="text-base font-black text-slate-900 dark:text-white"><%= inv.getCustomerUsername() %></p>
                <p class="text-xs text-slate-500 mt-1">Vehicle: <span class="mono font-bold"><%= inv.getLicensePlate() %></span></p>
            </div>
            <% if (isVoid && inv.getVoidReason() != null) { %>
            <div class="bg-rose-50 dark:bg-rose-950/30 rounded-2xl p-6 border border-rose-100 dark:border-rose-900/50">
                <p class="text-[9px] font-black text-rose-400 uppercase tracking-widest mb-2">Void Reason</p>
                <p class="text-sm font-bold text-rose-700 dark:text-rose-400"><%= inv.getVoidReason() %></p>
                <% if (canReinstate) { %>
                    <p class="text-[9px] font-black text-rose-500 mt-3 uppercase tracking-widest"><i class="fa-solid fa-clock"></i> <%= daysRemaining %> days left to reinstate</p>
                <% } else { %>
                    <p class="text-[9px] font-black text-slate-400 mt-3 uppercase tracking-widest">Recovery period expired</p>
                <% } %>
            </div>
            <% } %>
        </div>

        <table class="w-full mb-12">
            <thead>
                <tr class="border-b-2 border-slate-100 dark:border-slate-800">
                    <th class="text-left text-[9px] font-black text-slate-400 uppercase tracking-widest pb-4">Description</th>
                    <th class="text-right text-[9px] font-black text-slate-400 uppercase tracking-widest pb-4">Amount</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-50 dark:divide-slate-800">
                <tr>
                    <td class="py-6">
                        <p class="text-sm font-black text-slate-800 dark:text-slate-200"><%= inv.getServiceDescription().split("\\(Parts:")[0].trim() %></p>
                        <p class="text-[10px] text-slate-500 mt-1 uppercase tracking-widest">Labor & Base Service</p>
                    </td>
                    <td class="py-6 text-right mono font-bold text-slate-600 dark:text-slate-400">LKR <%= String.format("%,.2f", inv.getLaborCost()) %></td>
                </tr>
                <% if (inv.getServiceDescription().contains("(Parts:")) { %>
                <tr>
                    <td class="py-6">
                        <p class="text-sm font-black text-slate-800 dark:text-slate-200">Parts & Materials</p>
                        <p class="text-xs text-slate-500 mt-1"><%= inv.getServiceDescription().substring(inv.getServiceDescription().indexOf("(Parts:") + 8).replace(")", "") %></p>
                    </td>
                    <td class="py-6 text-right mono font-bold text-slate-600 dark:text-slate-400">LKR <%= String.format("%,.2f", inv.getPartsCost()) %></td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <div class="flex justify-end">
            <div class="w-72">
                <div class="flex justify-between py-2">
                    <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Subtotal</span>
                    <span class="mono font-bold text-slate-600">LKR <%= String.format("%,.2f", inv.getTotalAmount()) %></span>
                </div>
                <div class="flex justify-between py-2 text-emerald-600">
                    <span class="text-[10px] font-black uppercase tracking-widest">Total Paid</span>
                    <span class="mono font-bold">- LKR <%= String.format("%,.2f", totalPaid) %></span>
                </div>
                <div class="flex justify-between py-4 mt-2 border-t-2 border-slate-900 dark:border-white">
                    <span class="text-xs font-black text-slate-900 dark:text-white uppercase tracking-widest">Balance Due</span>
                    <span class="mono text-xl font-black text-indigo-600 dark:text-indigo-400">LKR <%= String.format("%,.2f", balance) %></span>
                </div>
            </div>
        </div>
    </div>

    <!-- PAYMENT HISTORY -->
    <div class="no-print">
        <h3 class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] mb-6 flex items-center gap-3">
            <i class="fa-solid fa-money-bill-wave text-emerald-500"></i> Payment History
        </h3>
        
        <% if (payments.isEmpty()) { %>
            <div class="bg-white dark:bg-slate-900 rounded-[2rem] border border-slate-100 dark:border-slate-800 p-8 text-center shadow-sm">
                <p class="text-sm font-bold text-slate-500">No payments recorded for this invoice yet.</p>
            </div>
        <% } else { %>
            <div class="bg-white dark:bg-slate-900 rounded-[2rem] border border-slate-100 dark:border-slate-800 overflow-hidden shadow-sm">
                <table class="w-full">
                    <thead class="bg-slate-50 dark:bg-slate-950/50 border-b border-slate-100 dark:border-slate-800">
                        <tr>
                            <th class="px-6 py-4 text-left text-[9px] font-black text-slate-400 uppercase tracking-[0.2em]">Txn ID</th>
                            <th class="px-6 py-4 text-left text-[9px] font-black text-slate-400 uppercase tracking-[0.2em]">Date</th>
                            <th class="px-6 py-4 text-left text-[9px] font-black text-slate-400 uppercase tracking-[0.2em]">Method</th>
                            <th class="px-6 py-4 text-right text-[9px] font-black text-slate-400 uppercase tracking-[0.2em]">Amount</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-50 dark:divide-slate-800/50">
                        <% for (Payment p : payments) { %>
                        <tr class="hover:bg-slate-50/50 dark:hover:bg-slate-950/30 transition-colors">
                            <td class="px-6 py-4 mono text-xs font-bold text-slate-600 dark:text-slate-400"><%= p.getPaymentId() %></td>
                            <td class="px-6 py-4 text-xs font-bold text-slate-600 dark:text-slate-400"><%= p.getPaymentDate() %></td>
                            <td class="px-6 py-4">
                                <span class="px-3 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-[9px] font-black uppercase tracking-widest text-slate-500"><%= p.getPaymentMethod() %></span>
                            </td>
                            <td class="px-6 py-4 text-right mono font-bold text-emerald-600">LKR <%= String.format("%,.2f", p.getAmount()) %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

</body>
</html>
