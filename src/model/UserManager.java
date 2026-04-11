package model;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class UserManager {

    public UserManager() {
        // --- ADMIN BOOTSTRAPPER ---
        // If the database is empty or running for the very first time, create the Master Admin account.
        if (!userExists("Admin")) {
            registerUser(new User("Admin", "admin1234@", "admin"));
        }
    }

    // 1. REGISTER THE USER (Your existing code)
    // 0. CHECK IF USER EXISTS
    public boolean userExists(String username) {
        try {
            FileReader file = new FileReader("users.txt");
            BufferedReader reader = new BufferedReader(file);
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 1 && parts[0].equals(username)) {
                    reader.close();
                    return true;
                }
            }
            reader.close();
        } catch (IOException e) {
            // File might not exist yet, which is fine
        }
        return false;
    }

    // 1. REGISTER THE USER
    public boolean registerUser(User newUser) {
        if (userExists(newUser.getUsername())) {
            return false; // Username is already taken!
        }
        try {
            FileWriter file = new FileWriter("users.txt", true);
            BufferedWriter writer = new BufferedWriter(file);
            writer.write(newUser.getUsername() + "," + newUser.getPassword() + "," + newUser.getRole());
            writer.newLine();
            writer.close();
            return true;
        } catch (IOException error) {
            System.out.println("Oops! Could not save the user.");
            return false;
        }
    }

    // 2. LOGIN THE USER (Your existing crash-proof code)
    public String loginUser(String searchUsername, String searchPassword) {
        try {
            FileReader file = new FileReader("users.txt");
            BufferedReader reader = new BufferedReader(file);
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 3) {
                    if (parts[0].equals(searchUsername) && parts[1].equals(searchPassword)) {
                        reader.close();
                        return parts[2]; // Return their secret badge ("admin" or "customer")
                    }
                }
            }
            reader.close();
        } catch (IOException error) {
            System.out.println("Oops! Could not read the file.");
        }
        return "none";
    }

    // --- NEW POWER 1: GET ALL USERS (For the Admin Table) ---
    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        try {
            FileReader file = new FileReader("users.txt");
            BufferedReader reader = new BufferedReader(file);
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                // If the line is healthy, build a User and add them to the list!
                if (parts.length == 3) {
                    User foundUser = new User(parts[0], parts[1], parts[2]);
                    userList.add(foundUser);
                }
            }
            reader.close();
        } catch (IOException e) {
            System.out.println("Could not load users for the table!");
        }
        return userList;
    }

    // --- NEW POWER 2: DELETE A USER (Admin power) ---
    public void deleteUser(String targetUsername) {
        // First, get everyone currently in the system
        List<User> allUsers = getAllUsers();

        try {
            // Open the file and OVERWRITE it completely (Notice there is no 'true' here)
            FileWriter file = new FileWriter("users.txt");
            BufferedWriter writer = new BufferedWriter(file);

            for (User u : allUsers) {
                // If this is NOT the person we want to delete, write them back into the file!
                if (!u.getUsername().equals(targetUsername)) {
                    writer.write(u.getUsername() + "," + u.getPassword() + "," + u.getRole());
                    writer.newLine();
                }
            }
            writer.close();
        } catch (IOException e) {
            System.out.println("Could not delete the user!");
        }
    }
}