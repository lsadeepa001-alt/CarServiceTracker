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
            // Replace line breaks and pipes to avoid breaking storage layout
            String safeMsg = feedback.getMessage().replace("|", "").replace("\n", " ");
            String safeReply = feedback.getAdminReply().replace("|", "").replace("\n", " ");
            
            writer.write(feedback.getFeedbackId() + "|" + feedback.getCustomerUsername() + "|" + safeMsg + "|" + safeReply + "|" + feedback.getDateSubmitted());
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
                    Feedback fb = new Feedback(parts[0], parts[1], parts[2], parts[3], parts[4]);
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
                String safeMsg = fb.getMessage().replace("|", "").replace("\n", " ");
                String safeReply = fb.getAdminReply().replace("|", "").replace("\n", " ");
                
                writer.write(fb.getFeedbackId() + "|" + fb.getCustomerUsername() + "|" + safeMsg + "|" + safeReply + "|" + fb.getDateSubmitted());
                writer.newLine();
            }
            writer.close();
        } catch (IOException e) {
            System.out.println("Could not update the reply!");
        }
    }
}
