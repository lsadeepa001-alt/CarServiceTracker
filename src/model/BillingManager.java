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