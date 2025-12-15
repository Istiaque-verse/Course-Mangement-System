package com.cms.dao;

import com.cms.model.Course;
import com.cms.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    public Course findById(int id) {
        String sql =
            "SELECT c.*, " +
            "       CONCAT(u.first_name, ' ', u.last_name) AS teacher_name, " +
            "       (SELECT COUNT(*) FROM registrations r " +
            "         WHERE r.course_id = c.id AND r.status = 'ACTIVE') AS current_students " +
            "  FROM courses c " +
            "  LEFT JOIN users u ON c.teacher_id = u.id " +
            " WHERE c.id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCourse(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Course> findAll() {
        String sql =
            "SELECT c.*, " +
            "       CONCAT(u.first_name, ' ', u.last_name) AS teacher_name, " +
            "       (SELECT COUNT(*) FROM registrations r " +
            "         WHERE r.course_id = c.id AND r.status = 'ACTIVE') AS current_students " +
            "  FROM courses c " +
            "  LEFT JOIN users u ON c.teacher_id = u.id " +
            " ORDER BY c.course_code";

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
        String sql =
            "SELECT c.*, " +
            "       CONCAT(u.first_name, ' ', u.last_name) AS teacher_name, " +
            "       (SELECT COUNT(*) FROM registrations r " +
            "         WHERE r.course_id = c.id AND r.status = 'ACTIVE') AS current_students " +
            "  FROM courses c " +
            "  LEFT JOIN users u ON c.teacher_id = u.id " +
            " WHERE c.teacher_id = ? " +
            " ORDER BY c.course_code";

        List<Course> courses = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, teacherId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    courses.add(mapResultSetToCourse(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    // Courses a student can still register for
    public List<Course> findAvailableForStudent(int studentId) {
        String sql =
            "SELECT c.*, " +
            "       CONCAT(u.first_name, ' ', u.last_name) AS teacher_name, " +
            "       (SELECT COUNT(*) FROM registrations r " +
            "         WHERE r.course_id = c.id AND r.status = 'ACTIVE') AS current_students " +
            "  FROM courses c " +
            "  LEFT JOIN users u ON c.teacher_id = u.id " +
            " WHERE NOT EXISTS ( " +
            "         SELECT 1 FROM registrations r " +
            "          WHERE r.course_id = c.id " +
            "            AND r.student_id = ? " +
            "            AND r.status = 'ACTIVE' " +
            "       ) " +
            " ORDER BY c.course_code";

        List<Course> courses = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    courses.add(mapResultSetToCourse(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public boolean create(Course course) {
        String sql =
            "INSERT INTO courses " +
            "(course_code, course_name, description, credits, teacher_id, max_students, created_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt =
                 conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, course.getCourseCode());
            stmt.setString(2, course.getCourseName());
            stmt.setString(3, course.getDescription());
            stmt.setInt(4, course.getCredits());
            // allow null teacher for unassigned
            if (course.getTeacherId() == 0) {
                stmt.setNull(5, Types.INTEGER);
            } else {
                stmt.setInt(5, course.getTeacherId());
            }
            // if not set, default to 30 from schema
            stmt.setInt(6, course.getMaxStudents() > 0 ? course.getMaxStudents() : 30);

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        course.setId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Course course) {
        String sql =
            "UPDATE courses " +
            "   SET course_code = ?, " +
            "       course_name = ?, " +
            "       description = ?, " +
            "       credits = ?, " +
            "       teacher_id = ?, " +
            "       max_students = ?, " +
            "       updated_at = CURRENT_TIMESTAMP " +
            " WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, course.getCourseCode());
            stmt.setString(2, course.getCourseName());
            stmt.setString(3, course.getDescription());
            stmt.setInt(4, course.getCredits());
            if (course.getTeacherId() == 0) {
                stmt.setNull(5, Types.INTEGER);
            } else {
                stmt.setInt(5, course.getTeacherId());
            }
            stmt.setInt(6, course.getMaxStudents());
            stmt.setInt(7, course.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String deleteRegs = "DELETE FROM registrations WHERE course_id = ?";
        String sql = "DELETE FROM courses WHERE id = ?";

        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement s1 = conn.prepareStatement(deleteRegs)) {
                s1.setInt(1, id);
                s1.executeUpdate();
            }
            try (PreparedStatement s2 = conn.prepareStatement(sql)) {
                s2.setInt(1, id);
                return s2.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Course mapResultSetToCourse(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setId(rs.getInt("id"));
        c.setCourseCode(rs.getString("course_code"));
        c.setCourseName(rs.getString("course_name"));
        c.setDescription(rs.getString("description"));
        c.setCredits(rs.getInt("credits"));
        c.setTeacherId(rs.getInt("teacher_id"));
        c.setMaxStudents(rs.getInt("max_students"));
        c.setCurrentStudents(rs.getInt("current_students"));

        Timestamp created = rs.getTimestamp("created_at");
        Timestamp updated = rs.getTimestamp("updated_at");
        if (created != null) c.setCreatedAt(created.toLocalDateTime());
        if (updated != null) c.setUpdatedAt(updated.toLocalDateTime());
        else if (created != null) c.setUpdatedAt(created.toLocalDateTime());

        String teacherName = rs.getString("teacher_name");
        if (teacherName != null) c.setTeacherName(teacherName);

        return c;
    }
}
