package com.cms.model;

import java.time.LocalDateTime;

public class Registration {
    private int id;
    private int studentId;
    private int courseId;
    private String studentName;
    private String courseName;
    private String courseCode;
    private LocalDateTime registeredAt;
    private Status status;
    
    public enum Status {
        ACTIVE, DROPPED
    }
    
    // Constructors
    public Registration() {}
    
    public Registration(int studentId, int courseId) {
        this.studentId = studentId;
        this.courseId = courseId;
        this.status = Status.ACTIVE;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
    
    public int getCourseId() {
        return courseId;
    }
    
    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }
    
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    
    public String getCourseName() {
        return courseName;
    }
    
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }
    
    public String getCourseCode() {
        return courseCode;
    }
    
    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }
    
    public LocalDateTime getRegisteredAt() {
        return registeredAt;
    }
    
    public void setRegisteredAt(LocalDateTime registeredAt) {
        this.registeredAt = registeredAt;
    }
    
    public Status getStatus() {
        return status;
    }
    
    public void setStatus(Status status) {
        this.status = status;
    }
    
    @Override
    public String toString() {
        return "Registration{" +
                "id=" + id +
                ", studentId=" + studentId +
                ", courseId=" + courseId +
                ", studentName='" + studentName + '\'' +
                ", courseName='" + courseName + '\'' +
                ", status=" + status +
                '}';
    }
}
