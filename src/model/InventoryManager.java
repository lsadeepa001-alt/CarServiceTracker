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