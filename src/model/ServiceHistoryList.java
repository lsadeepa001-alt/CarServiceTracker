package model;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.*;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class ServiceHistoryList {
    public Node head;
    private final String filePath = "services.json";

    public ServiceHistoryList() {
        this.head = null;
    }

    // --- MAGIC POWER 1: SAVE TO FILE ---
    public void saveToFile() {
        Gson gson = new Gson();
        try (FileWriter writer = new FileWriter(filePath)) {
            List<ServiceRecord> list = new ArrayList<>();
            Node current = head;
            while (current != null) {
                list.add(current.data);
                current = current.next;
            }
            gson.toJson(list, writer);
        } catch (IOException e) {
            System.out.println("Could not save to the Magic Memory Box!");
        }
    }

    // --- MAGIC POWER 2: LOAD FROM FILE ---
    public void loadFromFile() {
        File file = new File(filePath);
        if (!file.exists()) return;

        Gson gson = new Gson();
        try (FileReader reader = new FileReader(filePath)) {
            Type listType = new TypeToken<ArrayList<ServiceRecord>>(){}.getType();
            ArrayList<ServiceRecord> savedData = gson.fromJson(reader, listType);

            this.head = null;
            if (savedData != null) {
                for (ServiceRecord record : savedData) {
                    this.addRecord(record);
                }
            }
        } catch (IOException e) {
            System.out.println("Could not read from the Magic Memory Box!");
        }
    }

    // --- ACTION 1: ADD RECORD (Create) ---
    public void addRecord(ServiceRecord newRecord) {
        Node newCar = new Node(newRecord);
        if (this.head == null) {
            this.head = newCar;
        } else {
            Node currentCar = this.head;
            while (currentCar.next != null) {
                currentCar = currentCar.next;
            }
            currentCar.next = newCar;
        }
    }

    // --- ACTION 2: DISPLAY ALL (Read) ---
    public void displayAll() {
        if (this.head == null) {
            System.out.println("The train is empty! No service history.");
            return;
        }
        Node currentCar = this.head;
        while (currentCar != null) {
            System.out.println(currentCar.data.toString());
            currentCar = currentCar.next;
        }
    }

    // --- ACTION 3: UPDATE RECORD (Update) ---
    // --- ACTION 3: UPDATE RECORD (Upgraded to use License Plate!) ---
    public void updateRecord(String oldDate, String oldType, String targetPlate, String newDate, String newType, double newCost) {
        Node current = this.head;
        while (current != null) {
            // We now check the Date, the Type, AND the License Plate to find the exact car!
            boolean dateMatches = current.data.getDate().equals(oldDate);
            boolean typeMatches = current.data.getServiceType().equals(oldType);
            boolean plateMatches = current.data.getLicensePlate() != null && current.data.getLicensePlate().equals(targetPlate);

            if (dateMatches && typeMatches && plateMatches) {
                current.data.setDate(newDate);
                current.data.setServiceType(newType);
                current.data.setCost(newCost);
                // We DON'T change the license plate, because the service is permanently tied to that car!
                return;
            }
            current = current.next;
        }
    }

    // --- ACTION 4: DELETE RECORD (Delete) ---
    public void deleteRecord(String date, String serviceType) {
        if (this.head == null) return;
        if (this.head.data.getDate().equals(date) && this.head.data.getServiceType().equals(serviceType)) {
            this.head = this.head.next;
            return;
        }
        Node current = this.head;
        Node previous = null;
        while (current != null) {
            if (current.data.getDate().equals(date) && current.data.getServiceType().equals(serviceType)) {
                previous.next = current.next;
                return;
            }
            previous = current;
            current = current.next;
        }
    }

    // --- ACTION 5: SORT BY DATE ---
    public void sortHistoryByDate() {
        if (this.head == null || this.head.next == null) return;
        Node current = this.head;
        while (current != null) {
            Node oldestNode = current;
            Node checker = current.next;
            while (checker != null) {
                if (checker.data.getDate().compareTo(oldestNode.data.getDate()) < 0) {
                    oldestNode = checker;
                }
                checker = checker.next;
            }
            if (oldestNode != current) {
                ServiceRecord tempCargo = current.data;
                current.data = oldestNode.data;
                oldestNode.data = tempCargo;
            }
            current = current.next;
        }
    }
}