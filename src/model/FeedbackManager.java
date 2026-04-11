package model;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackManager {
    private static final String FILE_NAME = "feedback.txt";

    public void saveFeedback(Feedback feedback) {
        try {
            FileWriter file = new FileWriter(FILE_NAME, true);
            BufferedWriter writer = new BufferedWriter(file);
            
            // Encode line breaks and pipes to avoid breaking storage layout
            String safeMsg = feedback.getMessage().replace("|", " ").replace("\r", "").replace("\n", "__NL__");
            String safeReply = (feedback.getAdminReply() != null) ? feedback.getAdminReply().replace("|", " ").replace("\r", "").replace("\n", "__NL__") : "none";
            String safeRef = (feedback.getServiceRef() != null) ? feedback.getServiceRef().replace("|", " ") : "General";
            
            writer.write(feedback.getFeedbackId() + "|" + feedback.getCustomerUsername() + "|" + safeMsg + "|" + safeReply + "|" + feedback.getDateSubmitted() + "|" + feedback.getRating() + "|" + safeRef);
            writer.newLine();
            writer.close();
        } catch (IOException e) {
            System.out.println("Oops! Could not save the feedback.");
        }
    }

    public List<Feedback> getAllFeedback() {
        List<Feedback> list = new ArrayList<>();
        try {
            File f = new File(FILE_NAME);
            if (!f.exists()) return list;

            FileReader file = new FileReader(f);
            BufferedReader reader = new BufferedReader(file);
            String line;
            while ((line = reader.readLine()) != null) {
                // Split by pipe
                String[] parts = line.split("\\|"); 
                if (parts.length >= 5) {
                    // Decode line breaks back
                    String msg = parts[2].replace("__NL__", "\n");
                    String reply = parts[3].replace("__NL__", "\n");
                    int rating = 5;
                    String ref = "Legacy Feedback";
                    
                    if (parts.length >= 7) {
                        try { rating = Integer.parseInt(parts[5]); } catch (Exception ignored) {}
                        ref = parts[6];
                    }
                    
                    Feedback fb = new Feedback(parts[0], parts[1], msg, reply, parts[4], rating, ref);
                    list.add(fb);
                }
            }
            reader.close();
        } catch (IOException e) {
            System.out.println("Could not load feedback!");
        }
        return list;
    }

    public void updateReply(String targetFeedbackId, String newReply) {
        List<Feedback> allFeedback = getAllFeedback();
        try {
            FileWriter file = new FileWriter(FILE_NAME);
            BufferedWriter writer = new BufferedWriter(file);

            for (Feedback fb : allFeedback) {
                if (fb.getFeedbackId().equals(targetFeedbackId)) {
                    fb.setAdminReply(newReply);
                }
                
                String safeMsg = fb.getMessage().replace("|", " ").replace("\r", "").replace("\n", "__NL__");
                String safeReply = (fb.getAdminReply() != null) ? fb.getAdminReply().replace("|", " ").replace("\r", "").replace("\n", "__NL__") : "none";
                String safeRef = (fb.getServiceRef() != null) ? fb.getServiceRef().replace("|", " ") : "General";
                
                writer.write(fb.getFeedbackId() + "|" + fb.getCustomerUsername() + "|" + safeMsg + "|" + safeReply + "|" + fb.getDateSubmitted() + "|" + fb.getRating() + "|" + safeRef);
                writer.newLine();
            }
            writer.close();
        } catch (IOException e) {
            System.out.println("Could not update the reply!");
        }
    }
}
