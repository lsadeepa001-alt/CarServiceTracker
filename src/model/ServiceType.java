package model;

public class ServiceType {
    private String serviceName;
    private double defaultBasePrice; // Initial fixed diagnostic or labor cost mapping

    public ServiceType() {}

    public ServiceType(String serviceName, double defaultBasePrice) {
        this.serviceName = serviceName;
        this.defaultBasePrice = defaultBasePrice;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public double getDefaultBasePrice() {
        return defaultBasePrice;
    }

    public void setDefaultBasePrice(double defaultBasePrice) {
        this.defaultBasePrice = defaultBasePrice;
    }
}
