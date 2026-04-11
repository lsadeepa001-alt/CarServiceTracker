package model;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.*;
import java.util.LinkedList;
import java.util.Queue;
import java.util.List;
import java.util.ArrayList;

public class BookingManager {
    // We use a Queue to manage the flow of customers
    private Queue<Appointment> appointmentQueue;
    private final String FILE_PATH = "appointments.json";

    public BookingManager() {
        this.appointmentQueue = new LinkedList<>();
        loadFromFile();
    }

    // Add to the back of the line (Enqueue)
    public void addAppointment(Appointment app) {
        appointmentQueue.add(app);
        saveToFile();
    }

    // Get all appointments as a list (for the Admin to see)
    public List<Appointment> getAllAppointments() {
        return new ArrayList<>(appointmentQueue);
    }

    // Remove the first person in line once they are served (Dequeue)
    public Appointment completeNextAppointment() {
        Appointment next = appointmentQueue.poll();
        saveToFile();
        return next;
    }

    // --- JSON Saving/Loading ---
    private void saveToFile() {
        try (Writer writer = new FileWriter(FILE_PATH)) {
            new Gson().toJson(new ArrayList<>(appointmentQueue), writer);
        } catch (IOException e) { e.printStackTrace(); }
    }

    private void loadFromFile() {
        try (Reader reader = new FileReader(FILE_PATH)) {
            List<Appointment> list = new Gson().fromJson(reader, new TypeToken<List<Appointment>>(){}.getType());
            if (list != null) appointmentQueue.addAll(list);
        } catch (FileNotFoundException e) {
            System.out.println("No booking file found.");
        } catch (IOException e) { e.printStackTrace(); }
    }
}