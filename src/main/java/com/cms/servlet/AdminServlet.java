package com.cms.servlet;

import com.cms.dao.CourseDAO;
import com.cms.dao.UserDAO;
import com.cms.model.Course;
import com.cms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class AdminServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private CourseDAO courseDAO = new CourseDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user.getRole() != User.Role.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add-course".equals(action)) {
            showAddCourseForm(request, response);
        } else if ("add-user".equals(action)) {
            showAddUserForm(request, response);
        } else {
            showDashboard(request, response);
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
        if (user.getRole() != User.Role.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add-course".equals(action)) {
            addCourse(request, response);
        } else if ("add-user".equals(action)) {
            addUser(request, response);
        } else if ("delete-course".equals(action)) {
            deleteCourse(request, response);
        } else if ("delete-user".equals(action)) {
            deleteUser(request, response);
        } else {
            showDashboard(request, response);
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Course> courses = courseDAO.findAll();
        List<User> users = userDAO.getAllUsers();
        
        request.setAttribute("courses", courses);
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
    
    private void showAddCourseForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<User> teachers = userDAO.findByRole(User.Role.TEACHER);
        request.setAttribute("teachers", teachers);
        request.getRequestDispatcher("/add-course.jsp").forward(request, response);
    }
    
    private void showAddUserForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/add-user.jsp").forward(request, response);
    }
    
    private void addCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String courseCode = request.getParameter("courseCode");
        String courseName = request.getParameter("courseName");
        String description = request.getParameter("description");
        String creditsStr = request.getParameter("credits");
        String teacherIdStr = request.getParameter("teacherId");
        String maxStudentsStr = request.getParameter("maxStudents");
        
        if (courseCode == null || courseName == null || creditsStr == null || 
            teacherIdStr == null ||
            courseCode.trim().isEmpty() || courseName.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            showAddCourseForm(request, response);
            return;
        }
        
        try {
            Course course = new Course();
            course.setCourseCode(courseCode.trim());
            course.setCourseName(courseName.trim());
            course.setDescription(description != null ? description.trim() : "");
            course.setCredits(Integer.parseInt(creditsStr));
            course.setTeacherId(Integer.parseInt(teacherIdStr));
            // maxStudents not used in current schema
            
            if (courseDAO.create(course)) {
                request.setAttribute("success", "Course added successfully");
            } else {
                request.setAttribute("error", "Failed to add course");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format");
        }
        
        showAddCourseForm(request, response);
    }
    
    private void addUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        
        if (username == null || password == null || email == null || role == null ||
            username.trim().isEmpty() || password.trim().isEmpty() || email.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            showAddUserForm(request, response);
            return;
        }
        
        try {
            User user = new User();
            user.setUsername(username.trim());
            user.setPassword(com.cms.util.PasswordUtil.hashPassword(password));
            user.setEmail(email.trim());
            user.setRole(User.Role.valueOf(role));
            user.setFirstName(firstName != null ? firstName.trim() : "");
            user.setLastName(lastName != null ? lastName.trim() : "");
            
            if (userDAO.create(user)) {
                request.setAttribute("success", "User added successfully");
            } else {
                request.setAttribute("error", "Failed to add user");
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid role");
        }
        
        showAddUserForm(request, response);
    }
    
    private void deleteCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        if (courseIdStr != null) {
            try {
                int courseId = Integer.parseInt(courseIdStr);
                if (courseDAO.delete(courseId)) {
                    request.setAttribute("success", "Course deleted successfully");
                } else {
                    request.setAttribute("error", "Failed to delete course");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid course ID");
            }
        }
        
        showDashboard(request, response);
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null) {
            try {
                int userId = Integer.parseInt(userIdStr);
                if (userDAO.delete(userId)) {
                    request.setAttribute("success", "User deleted successfully");
                } else {
                    request.setAttribute("error", "Failed to delete user");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid user ID");
            }
        }
        
        showDashboard(request, response);
    }
}
