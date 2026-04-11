package servlet;

import model.Feedback;
import model.FeedbackManager;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/SubmitFeedbackServlet")
public class SubmitFeedbackServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String message = request.getParameter("message");
        String dateSubmitted = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());

        Feedback newFeedback = new Feedback(username, message, dateSubmitted);
        FeedbackManager manager = new FeedbackManager();
        manager.saveFeedback(newFeedback);

        response.sendRedirect("customer_feedback.jsp?success=true");
    }
}
