package model;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.*;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class VehicleManager {
    // We use a standard ArrayList here instead of a Linked List
    private List<Vehicle> vehicleList;
    private final String filePath = "vehicles.json"; // The Magic Memory Box for cars

    public VehicleManager() {
        this.vehicleList = new ArrayList<>();
        loadFromFile(); // Automatically load the cars when the manager is created!
    }

    // --- MAGIC POWER 1: SAVE TO FILE ---
    private void saveToFile() {
        Gson gson = new Gson();
        try (FileWriter writer = new FileWriter(filePath)) {
            gson.toJson(vehicleList, writer);
        } catch (IOException e) {
            System.out.println("Could not save to vehicles.json!");
        }
    }

    // --- MAGIC POWER 2: LOAD FROM FILE ---
    private void loadFromFile() {
        File file = new File(filePath);
        if (!file.exists()) return;

        Gson gson = new Gson();
        try (FileReader reader = new FileReader(filePath)) {
            Type listType = new TypeToken<ArrayList<Vehicle>>(){}.getType();
            List<Vehicle> savedData = gson.fromJson(reader, listType);

            if (savedData != null) {
                this.vehicleList = savedData;
            }
        } catch (IOException e) {
            System.out.println("Could not read from vehicles.json!");
        }
    }

    // --- ACTION 1: CREATE (Add a new vehicle) ---
    public void addVehicle(Vehicle newVehicle) {
        vehicleList.add(newVehicle);
        saveToFile();
    }

    // --- ACTION 2A: READ ALL (For the Shop Boss) ---
    public List<Vehicle> getAllVehicles() {
        return vehicleList;
    }

    // --- ACTION 2B: READ BY OWNER (For the specific Customer) ---
    public List<Vehicle> getVehiclesByOwner(String username) {
        List<Vehicle> customerCars = new ArrayList<>();
        for (Vehicle v : vehicleList) {
            if (v.getOwnerUsername().equals(username)) {
                customerCars.add(v);
            }
        }
        return customerCars;
    }

    // --- ACTION 3: UPDATE (Change mileage or details) ---
    public void updateVehicle(String targetPlate, String make, String model, int year, int mileage) {
        for (Vehicle v : vehicleList) {
            if (v.getLicensePlate().equals(targetPlate)) {
                v.setMake(make);
                v.setModel(model);
                v.setYear(year);
                v.setMileage(mileage);
                saveToFile();
                return; // Stop looking once we find and update it
            }
        }
    }

    // --- ACTION 4: DELETE (Remove a vehicle) ---
    public void deleteVehicle(String targetPlate) {
        // We look for the car with the matching license plate and remove it
        vehicleList.removeIf(v -> v.getLicensePlate().equals(targetPlate));
        saveToFile();
    }
}