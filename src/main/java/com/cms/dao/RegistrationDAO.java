package com.cms.dao;

import com.cms.model.Registration;
import com.cms.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegistrationDAO {
    
    public boolean registerStudent(int studentId, int courseId) {
        // Atomic upsert: if row exists (unique key on student_id,course_id), set status to 'active'
        String upsert = "INSERT INTO enrollments (student_id, course_id, status) VALUES (?, ?, 'active') " +
                        "ON DUPLICATE KEY UPDATE status = 'active', enrollment_date = CURRENT_TIMESTAMP";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(upsert)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean dropCourse(int studentId, int courseId) {
        String sql = "UPDATE enrollments SET status = 'dropped' WHERE student_id = ? AND course_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Registration> findByStudentId(int studentId) {
        String sql = "SELECT e.*, u.full_name, c.course_name, c.course_code " +
                    "FROM enrollments e " +
                    "JOIN users u ON e.student_id = u.user_id " +
                    "JOIN courses c ON e.course_id = c.course_id " +
                    "WHERE e.student_id = ? AND e.status = 'active' " +
                    "ORDER BY e.enrollment_date DESC";
        
        List<Registration> registrations = new ArrayList<>();
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                registrations.add(mapResultSetToRegistration(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return registrations;
    }
    
    public List<Registration> findByCourseId(int courseId) {
        String sql = "SELECT e.*, u.full_name, c.course_name, c.course_code " +
                    "FROM enrollments e " +
                    "JOIN users u ON e.student_id = u.user_id " +
                    "JOIN courses c ON e.course_id = c.course_id " +
                    "WHERE e.course_id = ? AND e.status = 'active' " +
                    "ORDER BY u.full_name";
        
        List<Registration> registrations = new ArrayList<>();
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                registrations.add(mapResultSetToRegistration(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return registrations;
    }
    
    public boolean isStudentRegistered(int studentId, int courseId) {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE student_id = ? AND course_id = ? AND status = 'active'";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public int getStudentCountForCourse(int courseId) {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE course_id = ? AND status = 'active'";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    private Registration mapResultSetToRegistration(ResultSet rs) throws SQLException {
        Registration registration = new Registration();
        registration.setId(rs.getInt("enrollment_id"));
        registration.setStudentId(rs.getInt("student_id"));
        registration.setCourseId(rs.getInt("course_id"));
        registration.setStudentName(rs.getString("full_name"));
        registration.setCourseName(rs.getString("course_name"));
        registration.setCourseCode(rs.getString("course_code"));
        // Handle timestamp safely
        java.sql.Timestamp enrollmentDate = rs.getTimestamp("enrollment_date");
        if (enrollmentDate != null) {
            registration.setRegisteredAt(enrollmentDate.toLocalDateTime());
        } else {
            registration.setRegisteredAt(java.time.LocalDateTime.now());
        }
        
        // Map status
        String status = rs.getString("status");
        if ("active".equals(status)) {
            registration.setStatus(Registration.Status.ACTIVE);
        } else if ("dropped".equals(status)) {
            registration.setStatus(Registration.Status.DROPPED);
        } else {
            registration.setStatus(Registration.Status.ACTIVE); // Default
        }
        
        return registration;
    }
}
