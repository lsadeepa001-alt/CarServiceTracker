package model;

public class User {

    private String username;
    private String password;
    private String role; // <-- NEW! This is our secret badge ("admin" or "customer")

    // The Builder now asks for the badge too!
    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }

    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getRole() { return role; } // Let us look at the badge
}