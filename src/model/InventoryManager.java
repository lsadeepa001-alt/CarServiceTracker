package model;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.*;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class InventoryManager {
    private List<InventoryItem> inventoryList;
    private final String FILE_PATH = "inventory.json";

    public InventoryManager() {
        this.inventoryList = new ArrayList<>();
        loadFromFile();
        
        // Check for legacy data
        boolean hasLegacy = false;
        for (InventoryItem item : inventoryList) {
            if (item.getItemId().equals("BRK-001") || item.getItemId().equals("BTY-001")) {
                hasLegacy = true; 
                break;
            }
        }

        // Auto-bootstrap default inventory linked to the abstract service nodes
        if (inventoryList.isEmpty() || hasLegacy) {
            this.inventoryList.clear();
            
            // Sedan
            this.inventoryList.add(new InventoryItem("SED-OIL", "Sedan Synthetic Motor Oil", "Fluids", 24, 6500.00, "fa-oil-can", "Standard Sedan Service"));
            this.inventoryList.add(new InventoryItem("SED-FIL", "Standard Air Filter", "Engine", 15, 2500.00, "fa-gear", "Standard Sedan Service"));
            
            // SUV
            this.inventoryList.add(new InventoryItem("SUV-SHK", "Heavy Duty Shocks", "Suspension", 8, 45000.00, "fa-wrench", "SUV Heavy Duty Maintenance"));
            this.inventoryList.add(new InventoryItem("SUV-BRK", "Off-Road Brake Pads", "Brakes", 20, 12000.00, "fa-compact-disc", "SUV Heavy Duty Maintenance"));
            
            // Hybrid
            this.inventoryList.add(new InventoryItem("HYB-COL", "Hybrid Battery Coolant", "Fluids", 12, 8500.00, "fa-oil-can", "Hybrid System Check & Maintenance"));
            this.inventoryList.add(new InventoryItem("HYB-INV", "Inverter Assembly", "Electrical", 3, 145000.00, "fa-car-battery", "Hybrid System Check & Maintenance"));
            
            // Sports
            this.inventoryList.add(new InventoryItem("SPT-EXH", "Performance Exhaust Kit", "Engine", 4, 180000.00, "fa-wrench", "Sports Car Performance Tuning"));
            this.inventoryList.add(new InventoryItem("SPT-TRP", "Track Performance Tires", "Suspension", 16, 85000.00, "fa-gear", "Sports Car Performance Tuning"));
            
            // EV
            this.inventoryList.add(new InventoryItem("EV-HVC", "High Voltage Cable Set", "Electrical", 10, 32000.00, "fa-car-battery", "EV Powertrain Diagnostics"));
            this.inventoryList.add(new InventoryItem("EV-BMS", "Battery Mgt System Sensor", "Electrical", 5, 28000.00, "fa-gear", "EV Powertrain Diagnostics"));
            
            // Crossover
            this.inventoryList.add(new InventoryItem("CRS-STR", "Crossover Strut Assembly", "Suspension", 10, 24000.00, "fa-wrench", "Crossover Suspension Overhaul"));
            this.inventoryList.add(new InventoryItem("CRS-AXL", "CV Axle Shaft", "Engine", 6, 38000.00, "fa-gear", "Crossover Suspension Overhaul"));
            
            saveToFile();
        }
    }

    // 1. READ ALL ITEMS
    public List<InventoryItem> getAllItems() {
        return inventoryList;
    }

    // 2. ADD A NEW ITEM
    public void addItem(InventoryItem newItem) {
        inventoryList.add(newItem);
        saveToFile();
    }

    // 3. DELETE AN ITEM
    public void deleteItem(String targetId) {
        inventoryList.removeIf(item -> item.getItemId().equals(targetId));
        saveToFile();
    }

    // 4. UPDATE AN ITEM'S STOCK OR PRICE (NEWLY ADDED!)
    public void updateItem(String targetId, int newQuantity, double newPrice) {
        for (InventoryItem item : inventoryList) {
            if (item.getItemId().equals(targetId)) {
                item.setQuantity(newQuantity);
                item.setPrice(newPrice);
                break; // Stop searching once we find it!
            }
        }
        saveToFile(); // Save the new numbers to the JSON file
    }

    // --- MAGIC FILE SAVING ---
    public void saveToFile() {
        try (Writer writer = new FileWriter(FILE_PATH)) {
            Gson gson = new Gson();
            gson.toJson(inventoryList, writer);
        } catch (IOException e) {
            System.out.println("Error saving inventory: " + e.getMessage());
        }
    }

    // --- MAGIC FILE LOADING ---
    public void loadFromFile() {
        try (Reader reader = new FileReader(FILE_PATH)) {
            Gson gson = new Gson();
            Type listType = new TypeToken<ArrayList<InventoryItem>>(){}.getType();
            List<InventoryItem> loaded = gson.fromJson(reader, listType);
            if (loaded != null) {
                this.inventoryList = loaded;
            }
        } catch (FileNotFoundException e) {
            System.out.println("No inventory file found. Starting fresh!");
        } catch (IOException e) {
            System.out.println("Error loading inventory: " + e.getMessage());
        }
    }
}