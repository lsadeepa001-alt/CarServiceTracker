package servlet;
import model.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        UserManager manager = new UserManager();

        // 1. Ask the UserManager for the secret badge!
        String badge = manager.loginUser(user, pass);

        // 2. Check which badge they have
        if (badge.equals("admin")) {
            // THEY ARE THE BOSS!
            HttpSession session = request.getSession();
            session.setAttribute("username", user);  // FIXED: Changed from "loggedInUser"
            session.setAttribute("userRole", badge);

            // Send bosses to the big dashboard
            response.sendRedirect("dashboard.jsp");

        } else if (badge.equals("customer")) {
            // THEY ARE A NORMAL CUSTOMER!
            HttpSession session = request.getSession();
            session.setAttribute("username", user);  // FIXED: Changed from "loggedInUser"
            session.setAttribute("userRole", badge);

            // Send customers to their dashboard
            response.sendRedirect("customer_dashboard.jsp");

        } else {
            // FAIL! Wrong password or username
            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}
