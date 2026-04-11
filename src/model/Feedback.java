package model;

import java.util.UUID;

public class Feedback {
    private String feedbackId;
    private String customerUsername;
    private String message;
    private String adminReply;
    private String dateSubmitted;
    private int rating;
    private String serviceRef;

    // For creating new contextual feedback
    public Feedback(String customerUsername, String message, String dateSubmitted, int rating, String serviceRef) {
        this.feedbackId = UUID.randomUUID().toString();
        this.customerUsername = customerUsername;
        this.message = message;
        this.adminReply = "none";
        this.dateSubmitted = dateSubmitted;
        this.rating = rating;
        this.serviceRef = serviceRef;
    }

    // For loading existing feedback
    public Feedback(String feedbackId, String customerUsername, String message, String adminReply, String dateSubmitted, int rating, String serviceRef) {
        this.feedbackId = feedbackId;
        this.customerUsername = customerUsername;
        this.message = message;
        this.adminReply = adminReply;
        this.dateSubmitted = dateSubmitted;
        this.rating = rating;
        this.serviceRef = serviceRef;
    }

    public String getFeedbackId() { return feedbackId; }
    public String getCustomerUsername() { return customerUsername; }
    public String getMessage() { return message; }
    public String getAdminReply() { return adminReply; }
    public void setAdminReply(String adminReply) { this.adminReply = adminReply; }
    public String getDateSubmitted() { return dateSubmitted; }
    public int getRating() { return rating; }
    public String getServiceRef() { return serviceRef; }
}
