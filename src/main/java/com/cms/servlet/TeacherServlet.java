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

public class TeacherServlet extends HttpServlet {
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
        if (user.getRole() != User.Role.TEACHER) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("course-students".equals(action)) {
            showCourseStudents(request, response, user.getId());
        } else {
            showDashboard(request, response, user.getId());
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response, int teacherId) 
            throws ServletException, IOException {
        
        List<Course> myCourses = courseDAO.findByTeacherId(teacherId);
        // Pre-compute aggregates to avoid EL stream operations in JSP
        int totalStudents = 0;
        int totalCredits = 0;
        for (Course c : myCourses) {
            totalStudents += c.getCurrentStudents();
            totalCredits += c.getCredits();
        }
        request.setAttribute("myCourses", myCourses);
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalCredits", totalCredits);
        request.getRequestDispatcher("/teacher-dashboard.jsp").forward(request, response);
    }
    
    private void showCourseStudents(HttpServletRequest request, HttpServletResponse response, int teacherId) 
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        
        if (courseIdStr == null) {
            request.setAttribute("error", "Course ID is required");
            showDashboard(request, response, teacherId);
            return;
        }
        
        try {
            int courseId = Integer.parseInt(courseIdStr);
            
            // Verify that the course belongs to this teacher
            Course course = courseDAO.findById(courseId);
            if (course == null || course.getTeacherId() != teacherId) {
                request.setAttribute("error", "Course not found or access denied");
                showDashboard(request, response, teacherId);
                return;
            }
            
            List<Registration> students = registrationDAO.findByCourseId(courseId);
            request.setAttribute("course", course);
            request.setAttribute("students", students);
            request.getRequestDispatcher("/course-students.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid course ID");
            showDashboard(request, response, teacherId);
        }
    }
}
