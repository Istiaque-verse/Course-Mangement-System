package com.cms.servlet;

import com.cms.dao.UserDAO;
import com.cms.model.User;
import com.cms.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectToDashboard(user, request, response);
            return;
        }
        
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        User user = userDAO.findByUsername(username.trim());
        
        if (user != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
            // Login successful
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            
            redirectToDashboard(user, request, response);
            return;
        }
        
        // Login failed
        request.setAttribute("error", "Invalid username or password");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    private void redirectToDashboard(User user, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String contextPath = request.getContextPath();
        
        switch (user.getRole()) {
            case ADMIN:
                response.sendRedirect(contextPath + "/admin");
                break;
            case TEACHER:
                response.sendRedirect(contextPath + "/teacher");
                break;
            case STUDENT:
                response.sendRedirect(contextPath + "/student");
                break;
            default:
                response.sendRedirect(contextPath + "/login");
        }
    }
}
