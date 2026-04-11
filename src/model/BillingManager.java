package model;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.*;
import java.lang.reflect.Type;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

public class BillingManager {
    // Member 6 uses a STACK (Last-In, First-Out)
    private Stack<Invoice> invoiceStack;
    private final String FILE_PATH = "invoices.json";

    public BillingManager() {
        this.invoiceStack = new Stack<>();
        loadFromFile();
    }

    // 1. GENERATE A NEW BILL (Push to top of the stack)
    public void generateInvoice(Invoice newInvoice) {
        invoiceStack.push(newInvoice);
        saveToFile();
    }

    // 2. VIEW ALL BILLS (Returns the stack)
    public Stack<Invoice> getAllInvoices() {
        return invoiceStack;
    }

    // 3. MARK A BILL AS PAID
    public void markAsPaid(String targetInvoiceId) {
        for (Invoice inv : invoiceStack) {
            if (inv.getInvoiceId().equals(targetInvoiceId)) {
                inv.setStatus("PAID");
                break;
            }
        }
        saveToFile();
    }

    // 5. DELETE INVOICE (Synchronization Hook)
    public boolean deleteInvoiceByMetadata(String plate, String date, String type) {
        for (Invoice inv : invoiceStack) {
            boolean plateMatch = inv.getLicensePlate() != null && inv.getLicensePlate().equals(plate);
            boolean dateMatch = inv.getDateIssued() != null && inv.getDateIssued().equals(date);
            boolean typeMatch = inv.getServiceDescription() != null && inv.getServiceDescription().equals(type);
            
            if (plateMatch && dateMatch && typeMatch) {
                invoiceStack.remove(inv);
                saveToFile();
                return true;
            }
        }
        return false;
    }

    // 6. UPDATE INVOICE (Synchronization Hook)
    public boolean updateInvoiceByMetadata(String plate, String oldDate, String oldType, String newDate, String newType, double newCost) {
        for (Invoice inv : invoiceStack) {
            boolean plateMatch = inv.getLicensePlate() != null && inv.getLicensePlate().equals(plate);
            boolean dateMatch = inv.getDateIssued() != null && inv.getDateIssued().equals(oldDate);
            boolean typeMatch = inv.getServiceDescription() != null && inv.getServiceDescription().equals(oldType);

            if (plateMatch && dateMatch && typeMatch) {
                inv.setDateIssued(newDate);
                inv.setServiceDescription(newType);
                inv.setTotalAmount(newCost);
                saveToFile();
                return true;
            }
        }
        return false;
    }

    // --- MAGIC FILE SAVING ---
    private void saveToFile() {
        try (Writer writer = new FileWriter(FILE_PATH)) {
            Gson gson = new Gson();
            // Convert Stack to a standard List for easy JSON saving
            gson.toJson(new ArrayList<>(invoiceStack), writer);
        } catch (IOException e) {
            System.out.println("Error saving invoices: " + e.getMessage());
        }
    }

    // --- MAGIC FILE LOADING ---
    private void loadFromFile() {
        try (Reader reader = new FileReader(FILE_PATH)) {
            Gson gson = new Gson();
            Type listType = new TypeToken<ArrayList<Invoice>>(){}.getType();
            List<Invoice> loaded = gson.fromJson(reader, listType);
            if (loaded != null) {
                this.invoiceStack.addAll(loaded);
            }
        } catch (FileNotFoundException e) {
            System.out.println("No invoice file found. Starting fresh!");
        } catch (IOException e) {
            System.out.println("Error loading invoices: " + e.getMessage());
        }
    }
}