package servlet;
import model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AddVehicleServlet")
public class AddVehicleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. CATCH THE DATA!
        String plate = request.getParameter("licensePlate");
        String make = request.getParameter("make");
        String model = request.getParameter("model");

        int year = Integer.parseInt(request.getParameter("year"));
        int mileage = Integer.parseInt(request.getParameter("mileage"));

        String owner = request.getParameter("ownerUsername");

        // 2. BOX IT UP!
        Vehicle newCar = new Vehicle(plate, make, model, year, mileage, owner);

        // 3. WAKE UP THE MEMORY BOX!
        HttpSession session = request.getSession();
        VehicleManager vManager = (VehicleManager) session.getAttribute("vehicleManager");

        if (vManager == null) {
            vManager = new VehicleManager();
        }

        // 4. SAVE IT!
        vManager.addVehicle(newCar);

        // Save the manager back into the server memory
        session.setAttribute("vehicleManager", vManager);

        // 5. SEND THEM BACK!
        String target = request.getParameter("redirect");
        if (target == null || target.trim().isEmpty()) {
            target = "customer_vehicles.jsp?success=added"; // Default
        }
        response.sendRedirect(target);
    }
}
