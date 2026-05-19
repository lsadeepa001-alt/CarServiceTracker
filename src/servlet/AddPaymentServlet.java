package servlet;

import model.Payment;
import model.PaymentManager;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/AddPaymentServlet")
public class AddPaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String invoiceId = request.getParameter("invoiceId");
        String amountStr = request.getParameter("amount");
        String paymentMethod = request.getParameter("paymentMethod");
        String referenceNote = request.getParameter("referenceNote");
        String paymentDate = request.getParameter("paymentDate");

        if (paymentDate == null || paymentDate.isEmpty()) {
            paymentDate = LocalDate.now().toString();
        }

        try {
            double amount = Double.parseDouble(amountStr);
            String paymentId = "PAY-" + (System.currentTimeMillis() % 100000);
            
            Payment payment = new Payment(paymentId, invoiceId, amount, paymentMethod, paymentDate, referenceNote);
            PaymentManager pm = new PaymentManager();
            pm.addPayment(payment);
            
            response.sendRedirect("billing_dashboard.jsp?success=payment_added");
        } catch (NumberFormatException e) {
            response.sendRedirect("billing_dashboard.jsp?error=invalidpayment");
        }
    }
}
