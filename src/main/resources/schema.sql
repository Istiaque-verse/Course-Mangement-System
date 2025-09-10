-- Course Management System Database Schema
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS course_management;
USE course_management;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('ADMIN', 'TEACHER', 'STUDENT') NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Courses table
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    credits INT NOT NULL,
    teacher_id INT,
    max_students INT DEFAULT 30,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Registrations table (Student-Course relationship)
CREATE TABLE registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ACTIVE', 'DROPPED') DEFAULT 'ACTIVE',
    UNIQUE KEY unique_registration (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, password, email, role, first_name, last_name) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'admin@cms.com', 'ADMIN', 'Admin', 'User');

-- Insert sample teachers
INSERT INTO users (username, password, email, role, first_name, last_name) VALUES
('teacher1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'teacher1@cms.com', 'TEACHER', 'John', 'Smith'),
('teacher2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'teacher2@cms.com', 'TEACHER', 'Jane', 'Doe');

-- Insert sample students
INSERT INTO users (username, password, email, role, first_name, last_name) VALUES
('student1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'student1@cms.com', 'STUDENT', 'Alice', 'Johnson'),
('student2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'student2@cms.com', 'STUDENT', 'Bob', 'Wilson');

-- Insert sample courses
INSERT INTO courses (course_code, course_name, description, credits, teacher_id, max_students) VALUES
('CS101', 'Introduction to Programming', 'Basic programming concepts using Java', 3, 2, 30),
('CS201', 'Data Structures', 'Advanced data structures and algorithms', 4, 2, 25),
('CS301', 'Database Systems', 'Database design and SQL', 3, 3, 20),
('MATH101', 'Calculus I', 'Differential and integral calculus', 4, 3, 35);

-- Insert sample registrations
INSERT INTO registrations (student_id, course_id) VALUES
(4, 1), -- student1 -> CS101
(4, 2), -- student1 -> CS201
(5, 1), -- student2 -> CS101
(5, 3); -- student2 -> CS301
