package servlet;
import model.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // SECURITY BOUNCER: Only authenticated Admins can register new users!
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

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
        boolean success = manager.registerUser(newUser);

        if (success) {
            // 3. Send the admin back to the user management page
            response.sendRedirect("manage-users.jsp?success=registered");
        } else {
            response.sendRedirect("register.jsp?error=exists");
        }
    }
}
