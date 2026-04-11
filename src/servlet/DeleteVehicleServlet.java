package servlet;
import model.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteVehicleServlet")
public class DeleteVehicleServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("userRole");
        if (!"customer".equals(role)) {
            // Only customers should be managing vehicles this way in the new flow
            response.sendRedirect("login.jsp");
            return;
        }

        String targetPlate = request.getParameter("plate");

        if (targetPlate != null && !targetPlate.trim().isEmpty()) {
            VehicleManager vManager = (VehicleManager) session.getAttribute("vehicleManager");
            if (vManager == null) {
                vManager = new VehicleManager();
                session.setAttribute("vehicleManager", vManager);
            }
            
            // Add extra security step here: verify the target vehicle belongs to the exact session customer!
            boolean canDelete = false;
            for (Vehicle v : vManager.getAllVehicles()) {
                if (v.getLicensePlate().equals(targetPlate) && v.getOwnerUsername().equals(username)) {
                    canDelete = true;
                    break;
                }
            }

            if (canDelete) {
                vManager.deleteVehicle(targetPlate);
            }
        }
        
        response.sendRedirect("customer_vehicles.jsp?success=deleted");
    }
}
