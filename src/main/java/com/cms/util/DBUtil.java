package com.cms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
   private static final String DB_URL =
    "jdbc:mysql://localhost:3306/course_management" +
    "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" +
    "&useUnicode=true&characterEncoding=UTF-8";

private static final String DB_USERNAME = "cms_user";
private static final String DB_PASSWORD = "cms_password123";


    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
    }
    
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}
