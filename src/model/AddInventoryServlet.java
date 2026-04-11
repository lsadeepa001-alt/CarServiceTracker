package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddInventoryServlet")
public class AddInventoryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. CATCH THE DATA from the HTML form
        // We use .toUpperCase() so IDs like "brk-01" automatically become "BRK-01"
        String itemId = request.getParameter("itemId").toUpperCase();
        String itemName = request.getParameter("itemName");
        String category = request.getParameter("category");
        String iconName = request.getParameter("iconName");

        // Translate the text inputs into math numbers
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double price = Double.parseDouble(request.getParameter("price"));

        // 2. BOX IT UP into our Inventory Blueprint
        InventoryItem newItem = new InventoryItem(itemId, itemName, category, quantity, price, iconName);

        // 3. HAND IT TO THE MANAGER to save permanently
        InventoryManager manager = new InventoryManager();
        manager.addItem(newItem);

        // 4. SEND THE BOSS BACK TO THE DASHBOARD
        response.sendRedirect("inventory.jsp");
    }
}