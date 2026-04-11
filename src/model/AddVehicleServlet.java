package model;

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

        // 1. CATCH THE DATA! (The Mailman takes the 6 pieces of info from the text boxes)
        String plate = request.getParameter("licensePlate");
        String make = request.getParameter("make");
        String model = request.getParameter("model");

        // Notice we have to translate the Year and Mileage from Words into Math Numbers!
        int year = Integer.parseInt(request.getParameter("year"));
        int mileage = Integer.parseInt(request.getParameter("mileage"));

        String owner = request.getParameter("ownerUsername");

        // 2. BOX IT UP! (We put all 6 pieces into our Vehicle blueprint)
        Vehicle newCar = new Vehicle(plate, make, model, year, mileage, owner);

        // 3. WAKE UP THE MEMORY BOX! (Find the VehicleManager in the server's memory)
        HttpSession session = request.getSession();
        VehicleManager vManager = (VehicleManager) session.getAttribute("vehicleManager");

        // If the box doesn't exist yet, make a brand new one!
        if (vManager == null) {
            vManager = new VehicleManager();
        }

        // 4. SAVE IT! (We give the new car to the manager, who writes it in the JSON file)
        vManager.addVehicle(newCar);

        // Save the manager back into the server memory so it doesn't get lost
        session.setAttribute("vehicleManager", vManager);

        // 5. SEND THEM BACK! (Send the user back to the garage to see their new car in the table)
        response.sendRedirect("manage_vehicles.jsp");
    }
}