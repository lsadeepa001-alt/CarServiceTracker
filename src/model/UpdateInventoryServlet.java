package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UpdateInventoryServlet")
public class UpdateInventoryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Catch the target ID and the new numbers
        String targetId = request.getParameter("itemId");
        int newQuantity = Integer.parseInt(request.getParameter("newQuantity"));
        double newPrice = Double.parseDouble(request.getParameter("newPrice"));

        // 2. Hand the updates to the manager
        InventoryManager manager = new InventoryManager();
        manager.updateItem(targetId, newQuantity, newPrice);

        // 3. Go back to the dashboard to see the changes instantly!
        response.sendRedirect("inventory.jsp");
    }
}