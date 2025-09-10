package com.cms.dao;

import com.cms.model.Course;
import com.cms.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {
    
    public Course findById(int id) {
        String sql = "SELECT c.*, u.full_name FROM courses c " +
                    "LEFT JOIN users u ON c.teacher_id = u.user_id WHERE c.course_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCourse(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Course> findAll() {
        String sql = "SELECT c.*, u.full_name, " +
                    "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.course_id AND e.status = 'active') as current_students " +
                    "FROM courses c LEFT JOIN users u ON c.teacher_id = u.user_id ORDER BY c.course_code";
        
        List<Course> courses = new ArrayList<>();
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }
    
    public List<Course> findByTeacherId(int teacherId) {
        String sql = "SELECT c.*, u.full_name, " +
                    "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.course_id AND e.status = 'active') as current_students " +
                    "FROM courses c LEFT JOIN users u ON c.teacher_id = u.user_id WHERE c.teacher_id = ? ORDER BY c.course_code";
        
        List<Course> courses = new ArrayList<>();
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, teacherId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }
    
    public List<Course> findAvailableForStudent(int studentId) {
        String sql = "SELECT c.*, u.full_name, " +
             "(SELECT COUNT(*) FROM enrollments e WHERE e.course_id = c.course_id AND e.status = 'active') as current_students " +
             "FROM courses c LEFT JOIN users u ON c.teacher_id = u.user_id WHERE c.course_id = ?";

        
        List<Course> courses = new ArrayList<>();
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }
    
    public boolean create(Course course) {
        String sql = "INSERT INTO courses (course_code, course_name, description, credits, teacher_id, created_at) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, course.getCourseCode());
            stmt.setString(2, course.getCourseName());
            stmt.setString(3, course.getDescription());
            stmt.setInt(4, course.getCredits());
            stmt.setInt(5, course.getTeacherId());
            // max_students not present in your schema; ignore
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    course.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean update(Course course) {
        String sql = "UPDATE courses SET course_code = ?, course_name = ?, description = ?, credits = ?, teacher_id = ? WHERE course_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, course.getCourseCode());
            stmt.setString(2, course.getCourseName());
            stmt.setString(3, course.getDescription());
            stmt.setInt(4, course.getCredits());
            stmt.setInt(5, course.getTeacherId());
            stmt.setInt(6, course.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String deleteEnrollments = "DELETE FROM enrollments WHERE course_id = ?";
        String sql = "DELETE FROM courses WHERE course_id = ?";
        
        try (Connection conn = DBUtil.getConnection()) {
            // remove dependent enrollments first
            try (PreparedStatement st1 = conn.prepareStatement(deleteEnrollments)) {
                st1.setInt(1, id);
                st1.executeUpdate();
            }
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                return stmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Course mapResultSetToCourse(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setId(rs.getInt("course_id"));
        course.setCourseCode(rs.getString("course_code"));
        course.setCourseName(rs.getString("course_name"));
        course.setDescription(rs.getString("description"));
        course.setCredits(rs.getInt("credits"));
        course.setTeacherId(rs.getInt("teacher_id"));
        course.setMaxStudents(100); // Default value since this column doesn't exist
        course.setCurrentStudents(rs.getInt("current_students"));
        
        // Handle timestamp columns safely
        java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            course.setCreatedAt(createdAt.toLocalDateTime());
            course.setUpdatedAt(createdAt.toLocalDateTime()); // Use created_at as updated_at
        } else {
            course.setCreatedAt(java.time.LocalDateTime.now());
            course.setUpdatedAt(java.time.LocalDateTime.now());
        }
        
        // Set teacher name if available
        String fullName = rs.getString("full_name");
        if (fullName != null) {
            course.setTeacherName(fullName);
        }
        
        return course;
    }
}
