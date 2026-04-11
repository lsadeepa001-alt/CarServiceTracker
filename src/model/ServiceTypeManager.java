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
        
        // Auto-bootstrap default physical service nodes if database misses initialization!
        if (serviceTypes.isEmpty()) {
            addServiceType(new ServiceType("Standard Wash", 1500.00));
            addServiceType(new ServiceType("Oil Change", 2500.00));
            addServiceType(new ServiceType("Brake Replacement", 4000.00));
            addServiceType(new ServiceType("Full Engine Tune-Up", 15000.00));
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
