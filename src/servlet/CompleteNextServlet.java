package servlet;
import model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/CompleteNextServlet")
public class CompleteNextServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        BookingManager manager = new BookingManager();

        // This automatically removes the First-In (FIFO) from the queue!
        Appointment completed = manager.completeNextAppointment();

        // Go back to the live queue dashboard
        response.sendRedirect("manage_appointments.jsp");
    }
}
