package model;

public class Main {
    public static void main(String[] args) {

        System.out.println("--- Starting the SwiftDrive Services ---");

        // 1. We build our empty train track (The Linked List)
        ServiceHistoryList myTrain = new ServiceHistoryList();

        // 2. We create some cargo using the NEW rules!
        // (Date, Service Type, Cost, License Plate)
        ServiceRecord service1 = new ServiceRecord("2024-01-15", "Oil Change", 6500.00, "CAA-1234");
        ServiceRecord service2 = new ServiceRecord("2023-11-20", "Tire Replacement", 15000.00, "CBB-5678");
        ServiceRecord service3 = new ServiceRecord("2024-02-10", "Engine Check", 8000.00, "DCC-1546");

        // 3. We load the cargo into the train (Adding to the Linked List)
        myTrain.addRecord(service1);
        myTrain.addRecord(service2);
        myTrain.addRecord(service3);

        // 4. We ask the train to show us everything inside!
        System.out.println("\nHere is the current Service History:");
        myTrain.displayAll();

        // 5. Use Selection Sort to fix the dates!
        System.out.println("\n--- Performing Selection Sort... ---");
        myTrain.sortHistoryByDate();

        // 6. Show the sorted list!
        System.out.println("\nHere is the Sorted Service History:");
        myTrain.displayAll();
    }
}