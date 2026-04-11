package model;

import java.util.UUID;

public class Feedback {
    private String feedbackId;
    private String customerUsername;
    private String message;
    private String adminReply;
    private String dateSubmitted;

    // For creating new feedback
    public Feedback(String customerUsername, String message, String dateSubmitted) {
        this.feedbackId = UUID.randomUUID().toString();
        this.customerUsername = customerUsername;
        this.message = message;
        this.adminReply = "none";
        this.dateSubmitted = dateSubmitted;
    }

    // For loading existing feedback
    public Feedback(String feedbackId, String customerUsername, String message, String adminReply, String dateSubmitted) {
        this.feedbackId = feedbackId;
        this.customerUsername = customerUsername;
        this.message = message;
        this.adminReply = adminReply;
        this.dateSubmitted = dateSubmitted;
    }

    public String getFeedbackId() { return feedbackId; }
    public String getCustomerUsername() { return customerUsername; }
    public String getMessage() { return message; }
    public String getAdminReply() { return adminReply; }
    public void setAdminReply(String adminReply) { this.adminReply = adminReply; }
    public String getDateSubmitted() { return dateSubmitted; }
}
