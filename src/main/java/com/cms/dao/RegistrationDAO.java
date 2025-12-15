package com.cms.dao;

import com.cms.model.Registration;
import com.cms.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegistrationDAO {

    public boolean registerStudent(int studentId, int courseId) {
        String upsert =
            "INSERT INTO registrations (student_id, course_id, status) " +
            "VALUES (?, ?, 'ACTIVE') " +
            "ON DUPLICATE KEY UPDATE status = 'ACTIVE', registered_at = CURRENT_TIMESTAMP";

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
        String sql =
            "UPDATE registrations " +
            "   SET status = 'DROPPED' " +
            " WHERE student_id = ? AND course_id = ?";

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
        String sql =
            "SELECT r.*, " +
            "       CONCAT(u.first_name, ' ', u.last_name) AS student_name, " +
            "       c.course_name, c.course_code " +
            "  FROM registrations r " +
            "  JOIN users   u ON r.student_id = u.id " +
            "  JOIN courses c ON r.course_id = c.id " +
            " WHERE r.student_id = ? " +
            "   AND r.status = 'ACTIVE' " +
            " ORDER BY r.registered_at DESC";

        List<Registration> list = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToRegistration(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Registration> findByCourseId(int courseId) {
        String sql =
            "SELECT r.*, " +
            "       CONCAT(u.first_name, ' ', u.last_name) AS student_name, " +
            "       c.course_name, c.course_code " +
            "  FROM registrations r " +
            "  JOIN users   u ON r.student_id = u.id " +
            "  JOIN courses c ON r.course_id = c.id " +
            " WHERE r.course_id = ? " +
            "   AND r.status = 'ACTIVE' " +
            " ORDER BY student_name";

        List<Registration> list = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToRegistration(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean isStudentRegistered(int studentId, int courseId) {
        String sql =
            "SELECT COUNT(*) " +
            "  FROM registrations " +
            " WHERE student_id = ? " +
            "   AND course_id = ? " +
            "   AND status = 'ACTIVE'";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getStudentCountForCourse(int courseId) {
        String sql =
            "SELECT COUNT(*) " +
            "  FROM registrations " +
            " WHERE course_id = ? " +
            "   AND status = 'ACTIVE'";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Registration mapResultSetToRegistration(ResultSet rs) throws SQLException {
        Registration r = new Registration();
        r.setId(rs.getInt("id"));
        r.setStudentId(rs.getInt("student_id"));
        r.setCourseId(rs.getInt("course_id"));
        r.setStudentName(rs.getString("student_name"));
        r.setCourseName(rs.getString("course_name"));
        r.setCourseCode(rs.getString("course_code"));

        Timestamp ts = rs.getTimestamp("registered_at");
        if (ts != null) {
            r.setRegisteredAt(ts.toLocalDateTime());
        } else {
            r.setRegisteredAt(java.time.LocalDateTime.now());
        }

        String status = rs.getString("status");
        if ("ACTIVE".equals(status)) {
            r.setStatus(Registration.Status.ACTIVE);
        } else if ("DROPPED".equals(status)) {
            r.setStatus(Registration.Status.DROPPED);
        } else {
            r.setStatus(Registration.Status.ACTIVE);
        }

        return r;
    }
}

