package servlet;
import model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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

        // Refresh the page to see it turn green!
        response.sendRedirect("billing_dashboard.jsp");
    }
}
