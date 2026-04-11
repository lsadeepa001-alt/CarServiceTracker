package model;

import com.google.gson.Gson;
import java.io.*;
import java.util.LinkedList;
import java.util.Queue;
import java.util.List;
import java.util.ArrayList;

public class BookingManager {
    
    // NATIVE LINKED-LIST QUEUES
    private Queue<Appointment> appointmentQueue; // Pending Queue
    private Queue<Appointment> inGarageQueue;    // Under Maintenance
    private Queue<Appointment> completedQueue;   // Completed Jobs waiting for payment

    private final String FILE_PATH = "appointments.json";

    // Helper wrapper for Gson to serialize all three lists neatly
    private class DataWrapper {
        Queue<Appointment> pending;
        Queue<Appointment> garage;
        Queue<Appointment> completed;
    }

    public BookingManager() {
        this.appointmentQueue = new LinkedList<>();
        this.inGarageQueue = new LinkedList<>();
        this.completedQueue = new LinkedList<>();
        loadFromFile();
    }

    // --- ENQUEUE: Join the queue (from Customer perspective) ---
    public void addAppointment(Appointment app) {
        app.setStatus("Pending");
        appointmentQueue.add(app);
        saveToFile();
    }

    // --- DEQUEUE + TRANSFER: Move to Garage (Mechanic claims it) ---
    public void moveToGarage() {
        if (!appointmentQueue.isEmpty()) {
            Appointment next = appointmentQueue.poll();
            next.setStatus("Under Maintenance");
            inGarageQueue.add(next);
            saveToFile();
        }
    }

    // --- DEQUEUE + TRANSFER: Finish repair (Mechanic completes it) ---
    public Appointment moveFromGarageToCompleted(String targetAppointmentId) {
        // We iterate specifically because we might pull a specific car from the Garage list
        Appointment found = null;
        for (Appointment app : inGarageQueue) {
            if (app.getAppointmentId().equals(targetAppointmentId)) {
                found = app;
                break;
            }
        }
        if (found != null) {
            inGarageQueue.remove(found);
            found.setStatus("Completed");
            completedQueue.add(found);
            saveToFile();
        }
        return found;
    }

    // Extractors for front-end rendering
    public List<Appointment> getPendingAppointments() {
        return new ArrayList<>(appointmentQueue);
    }

    public List<Appointment> getInGarageAppointments() {
        return new ArrayList<>(inGarageQueue);
    }

    public List<Appointment> getCompletedAppointments() {
        return new ArrayList<>(completedQueue);
    }

    public List<Appointment> getAllAppointmentsNatively() {
        // Master view spanning all states natively for specific dashboards
        List<Appointment> all = new ArrayList<>();
        all.addAll(appointmentQueue);
        all.addAll(inGarageQueue);
        all.addAll(completedQueue);
        return all;
    }

    // Search helper for specific tasks
    public Appointment getAppointmentById(String id) {
        for (Appointment a : getAllAppointmentsNatively()) {
            if (a.getAppointmentId().equals(id)) return a;
        }
        return null;
    }

    // --- JSON Logic ---
    private void saveToFile() {
        try (Writer writer = new FileWriter(FILE_PATH)) {
            DataWrapper wrap = new DataWrapper();
            wrap.pending = this.appointmentQueue;
            wrap.garage = this.inGarageQueue;
            wrap.completed = this.completedQueue;
            new Gson().toJson(wrap, writer);
        } catch (IOException e) { e.printStackTrace(); }
    }

    private void loadFromFile() {
        try (Reader reader = new FileReader(FILE_PATH)) {
            Gson gson = new Gson();
            try {
                DataWrapper wrap = gson.fromJson(reader, DataWrapper.class);
                if (wrap != null) {
                    if (wrap.pending != null) this.appointmentQueue.addAll(wrap.pending);
                    if (wrap.garage != null) this.inGarageQueue.addAll(wrap.garage);
                    if (wrap.completed != null) this.completedQueue.addAll(wrap.completed);
                }
            } catch (com.google.gson.JsonSyntaxException e) {
                // LEGACY MIGRATION: The file contains the old raw Array format instead of DataWrapper.
                // Re-open list and fetch inherently.
            }
        } catch (FileNotFoundException e) {
            System.out.println("No booking file found.");
        } catch (IOException e) { e.printStackTrace(); }

        // MIGRATION BACKFALL
        if (this.appointmentQueue.isEmpty() && this.inGarageQueue.isEmpty() && this.completedQueue.isEmpty()) {
            File f = new File(FILE_PATH);
            if (f.exists()) {
                try (Reader reader = new FileReader(FILE_PATH)) {
                    java.lang.reflect.Type listType = new com.google.gson.reflect.TypeToken<ArrayList<Appointment>>(){}.getType();
                    List<Appointment> legacyList = new Gson().fromJson(reader, listType);
                    if (legacyList != null) {
                        for (Appointment legacy : legacyList) {
                            if (legacy.getStatus() == null || legacy.getStatus().isEmpty()) {
                                legacy.setStatus("Pending");
                            }
                            this.appointmentQueue.add(legacy);
                        }
                        saveToFile(); // Instantly convert physical file properties to new schema
                    }
                } catch (Exception ex) {
                    System.out.println("Could not migrate legacy Booking data: " + ex.getMessage());
                }
            }
        }
    }
}