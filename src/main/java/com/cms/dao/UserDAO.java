package com.cms.dao;

import com.cms.model.User;
import com.cms.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<User> findByRole(User.Role role) {
        String sql = "SELECT * FROM users WHERE user_type = ? ORDER BY full_name";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role.name().toLowerCase());
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    public boolean create(User user) {
        String sql = "INSERT INTO users (username, password, email, user_type, full_name, created_at) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getRole().name().toLowerCase());
            // Combine first and last name into full_name if provided
            String fullName = (user.getFirstName() != null ? user.getFirstName().trim() : "");
            if (user.getLastName() != null && !user.getLastName().trim().isEmpty()) {
                fullName = (fullName + " " + user.getLastName().trim()).trim();
            }
            if (fullName.isEmpty() && user.getUsername() != null) {
                fullName = user.getUsername();
            }
            stmt.setString(5, fullName);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean update(User user) {
        String sql = "UPDATE users SET username = ?, email = ?, user_type = ?, full_name = ? WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getRole().name().toLowerCase());
            String fullName = (user.getFirstName() != null ? user.getFirstName().trim() : "");
            if (user.getLastName() != null && !user.getLastName().trim().isEmpty()) {
                fullName = (fullName + " " + user.getLastName().trim()).trim();
            }
            if (fullName.isEmpty() && user.getUsername() != null) {
                fullName = user.getUsername();
            }
            stmt.setString(4, fullName);
            stmt.setInt(5, user.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<User> getAllUsers() {
        String sql = "SELECT * FROM users ORDER BY user_type, full_name";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        
        // Map user_type to role
        String userType = rs.getString("user_type");
        if ("admin".equals(userType)) {
            user.setRole(User.Role.ADMIN);
        } else if ("teacher".equals(userType)) {
            user.setRole(User.Role.TEACHER);
        } else if ("student".equals(userType)) {
            user.setRole(User.Role.STUDENT);
        }
        
        // Split full_name into first_name and last_name
        String fullName = rs.getString("full_name");
        if (fullName != null && fullName.contains(" ")) {
            String[] names = fullName.split(" ", 2);
            user.setFirstName(names[0]);
            user.setLastName(names[1]);
        } else {
            user.setFirstName(fullName != null ? fullName : "");
            user.setLastName("");
        }
        
        // Handle timestamp columns safely
        java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
            user.setUpdatedAt(createdAt.toLocalDateTime()); // Use created_at as updated_at
        } else {
            user.setCreatedAt(java.time.LocalDateTime.now());
            user.setUpdatedAt(java.time.LocalDateTime.now());
        }
        return user;
    }
}
