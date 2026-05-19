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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String sessionUser = (String) session.getAttribute("username");
        String targetPlate = request.getParameter("licensePlate");

        if (targetPlate != null && !targetPlate.trim().isEmpty()) {
            VehicleManager vManager = new VehicleManager();

            // Security: verify the vehicle belongs to this customer
            boolean isOwner = false;
            for (Vehicle v : vManager.getAllVehicles()) {
                if (v.getLicensePlate().equals(targetPlate) && v.getOwnerUsername().equals(sessionUser)) {
                    isOwner = true;
                    break;
                }
            }

            if (!isOwner) {
                response.sendRedirect("customer_dashboard.jsp?error=unauthorized");
                return;
            }

            vManager.deleteVehicle(targetPlate);
            response.sendRedirect("customer_dashboard.jsp?vehicleDeleted=true");
        } else {
            response.sendRedirect("customer_dashboard.jsp");
        }
    }
}
