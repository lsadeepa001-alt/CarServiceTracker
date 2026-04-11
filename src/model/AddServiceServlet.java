package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AddServiceServlet")
public class AddServiceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. CATCH THE DATA (Now including the License Plate!)
        String licensePlate = request.getParameter("licensePlate");
        String date = request.getParameter("date");
        String serviceType = request.getParameter("serviceType");
        double cost = Double.parseDouble(request.getParameter("cost"));

        // 2. BOX IT UP (Date, Type, Cost, Plate)
        ServiceRecord newRecord = new ServiceRecord(date, serviceType, cost, licensePlate);

        // 3. WAKE UP THE MEMORY
        HttpSession session = request.getSession();
        ServiceHistoryList list = (ServiceHistoryList) session.getAttribute("serviceList");

        if (list == null) {
            list = new ServiceHistoryList();
            list.loadFromFile();
        }

        // 4. ADD & SAVE PERMANENTLY
        list.addRecord(newRecord);
        list.saveToFile();

        session.setAttribute("serviceList", list);

        // 5. GO BACK TO DASHBOARD
        response.sendRedirect("dashboard.jsp");
    }
}