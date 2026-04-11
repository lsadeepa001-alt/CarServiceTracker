package model;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.*;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class ServiceTypeManager {
    private List<ServiceType> serviceTypes;
    private final String FILE_PATH = "service_types.json";

    public ServiceTypeManager() {
        this.serviceTypes = new ArrayList<>();
        loadFromFile();
        
        // Check for legacy data
        boolean hasLegacy = false;
        for (ServiceType st : serviceTypes) {
            if (st.getServiceName().equals("Standard Wash")) {
                hasLegacy = true; 
                break;
            }
        }

        // Auto-bootstrap default physical service nodes if database misses initialization or holds old data!
        if (serviceTypes.isEmpty() || hasLegacy) {
            this.serviceTypes.clear();
            this.serviceTypes.add(new ServiceType("Standard Sedan Service", 8500.00));
            this.serviceTypes.add(new ServiceType("SUV Heavy Duty Maintenance", 18000.00));
            this.serviceTypes.add(new ServiceType("Hybrid System Check & Maintenance", 12500.00));
            this.serviceTypes.add(new ServiceType("Sports Car Performance Tuning", 35000.00));
            this.serviceTypes.add(new ServiceType("EV Powertrain Diagnostics", 22000.00));
            this.serviceTypes.add(new ServiceType("Crossover Suspension Overhaul", 16000.00));
            saveToFile();
        }
    }

    public List<ServiceType> getAllServices() {
        return serviceTypes;
    }

    public void addServiceType(ServiceType st) {
        serviceTypes.add(st);
        saveToFile();
    }
    
    public void deleteServiceType(String serviceName) {
        serviceTypes.removeIf(st -> st.getServiceName().equals(serviceName));
        saveToFile();
    }

    private void saveToFile() {
        try (Writer writer = new FileWriter(FILE_PATH)) {
            new Gson().toJson(serviceTypes, writer);
        } catch (IOException e) { e.printStackTrace(); }
    }

    private void loadFromFile() {
        try (Reader reader = new FileReader(FILE_PATH)) {
            Type listType = new TypeToken<ArrayList<ServiceType>>(){}.getType();
            List<ServiceType> loaded = new Gson().fromJson(reader, listType);
            if (loaded != null) {
                this.serviceTypes = loaded;
            }
        } catch (FileNotFoundException e) {
            // Wait for bootstrap insertion
        } catch (IOException e) { e.printStackTrace(); }
    }
}
