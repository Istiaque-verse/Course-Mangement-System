package com.cms.servlet;

import com.cms.dao.CourseDAO;
import com.cms.dao.RegistrationDAO;
import com.cms.model.Course;
import com.cms.model.Registration;
import com.cms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class StudentServlet extends HttpServlet {
    private CourseDAO courseDAO = new CourseDAO();
    private RegistrationDAO registrationDAO = new RegistrationDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user.getRole() != User.Role.STUDENT) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("available-courses".equals(action)) {
            showAvailableCourses(request, response, user.getId());
        } else if ("my-courses".equals(action)) {
            showMyCourses(request, response, user.getId());
        } else {
            showDashboard(request, response, user.getId());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user.getRole() != User.Role.STUDENT) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("register".equals(action)) {
            registerForCourse(request, response, user.getId());
        } else if ("drop".equals(action)) {
            dropCourse(request, response, user.getId());
        } else {
            showDashboard(request, response, user.getId());
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response, int studentId) 
            throws ServletException, IOException {
        
        List<Registration> myCourses = registrationDAO.findByStudentId(studentId);
        List<Course> availableCourses = courseDAO.findAvailableForStudent(studentId);
        int totalCredits = 0;
        for (Registration r : myCourses) {
            // If we had credits on registration, we'd sum them; fallback to 0
        }
        
        request.setAttribute("myCourses", myCourses);
        request.setAttribute("availableCourses", availableCourses);
        request.setAttribute("totalCredits", totalCredits);
        request.getRequestDispatcher("/student-dashboard.jsp").forward(request, response);
    }
    
    private void showAvailableCourses(HttpServletRequest request, HttpServletResponse response, int studentId) 
            throws ServletException, IOException {
        
        List<Course> availableCourses = courseDAO.findAvailableForStudent(studentId);
        request.setAttribute("availableCourses", availableCourses);
        request.getRequestDispatcher("/available-courses.jsp").forward(request, response);
    }
    
    private void showMyCourses(HttpServletRequest request, HttpServletResponse response, int studentId) 
            throws ServletException, IOException {
        
        List<Registration> myCourses = registrationDAO.findByStudentId(studentId);
        request.setAttribute("myCourses", myCourses);
        request.getRequestDispatcher("/my-courses.jsp").forward(request, response);
    }
    
    private void registerForCourse(HttpServletRequest request, HttpServletResponse response, int studentId) 
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        
        if (courseIdStr == null) {
            request.setAttribute("error", "Course ID is required");
            showDashboard(request, response, studentId);
            return;
        }
        
        try {
            int courseId = Integer.parseInt(courseIdStr);
            
            // Check if student is already registered
            if (registrationDAO.isStudentRegistered(studentId, courseId)) {
                request.setAttribute("error", "You are already registered for this course");
                showDashboard(request, response, studentId);
                return;
            }
            
            // Check if course is full
            Course course = courseDAO.findById(courseId);
            if (course != null && course.isFull()) {
                request.setAttribute("error", "This course is full");
                showDashboard(request, response, studentId);
                return;
            }
            
            if (registrationDAO.registerStudent(studentId, courseId)) {
                request.setAttribute("success", "Successfully registered for the course");
            } else {
                request.setAttribute("error", "Failed to register for the course");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid course ID");
        }
        
        showDashboard(request, response, studentId);
    }
    
    private void dropCourse(HttpServletRequest request, HttpServletResponse response, int studentId) 
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        
        if (courseIdStr == null) {
            request.setAttribute("error", "Course ID is required");
            showDashboard(request, response, studentId);
            return;
        }
        
        try {
            int courseId = Integer.parseInt(courseIdStr);
            
            if (registrationDAO.dropCourse(studentId, courseId)) {
                request.setAttribute("success", "Successfully dropped the course");
            } else {
                request.setAttribute("error", "Failed to drop the course");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid course ID");
        }
        
        showDashboard(request, response, studentId);
    }
}
