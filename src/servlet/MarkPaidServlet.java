package servlet;
import model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/MarkPaidServlet")
public class MarkPaidServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Catch the secret ID we hid inside the button
        String targetInvoiceId = request.getParameter("invoiceId");

        // Tell the manager to mark it as PAID
        BillingManager bm = new BillingManager();
        bm.markAsPaid(targetInvoiceId);
        
        // 1. Fetch the exact invoice to extract data for History
        Invoice targeted = null;
        for (Invoice inv : bm.getAllInvoices()) {
            if (inv.getInvoiceId().equals(targetInvoiceId)) {
                targeted = inv;
                break;
            }
        }
        
        if (targeted != null) {
            String fullDescription = targeted.getServiceDescription();
            String abstractService = fullDescription;
            String partsUsedLog = "No parts consumed.";
            
            // Extract out the parts dynamically from how we formulated it in billing
            if (fullDescription.contains("(Parts: ")) {
                int splitIndex = fullDescription.indexOf("(Parts: ");
                abstractService = fullDescription.substring(0, splitIndex).trim();
                partsUsedLog = fullDescription.substring(splitIndex + 8, fullDescription.length() - 1);
            }
            
            // 2. Build the Native History Object Node mapping the extracted strings
            ServiceRecord historicalRecord = new ServiceRecord(
                targeted.getDateIssued(),
                abstractService,
                targeted.getTotalAmount(),
                targeted.getLicensePlate(),
                partsUsedLog
            );
            
            // 3. Push it directly into the strict LinkedList implementation!
            HttpSession session = request.getSession();
            ServiceHistoryList historyEngine = (ServiceHistoryList) session.getAttribute("serviceList");
            
            if (historyEngine == null) {
                historyEngine = new ServiceHistoryList();
                historyEngine.loadFromFile();
            }
            
            historyEngine.addRecord(historicalRecord);
            historyEngine.saveToFile();
            
            // 4. Force Update into Session memory directly to prevent Admin refresh lag!
            session.setAttribute("serviceList", historyEngine);
        }

        // Refresh the page to see it turn green!
        response.sendRedirect("billing_dashboard.jsp?success=paid");
    }
}
