package model;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 1. Grab the data from the website boxes (Now we grab 3 things!)
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        // <-- WE PICK UP THE NEW SECRET BADGE HERE! -->
        String badge = request.getParameter("role");

        // 2. Box them up into our new User blueprint
        UserManager manager = new UserManager();

        // We give the new User their name, password, AND their badge
        User newUser = new User(user, pass, badge);

        // Save them to the text file!
        manager.registerUser(newUser);

        // 3. Send the user back to the login page so they can test their new account
        response.sendRedirect("login.jsp");
    }
}