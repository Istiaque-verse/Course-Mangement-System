<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add User - Course Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f9fafb;
            min-height: 100vh;
        }
        :root {
            --deep-blue: #1e3c72;
            --deep-blue-alt: #2a5298;
            --deep-blue-light: #e5ecf8;
            --text-dark: #0f172a;
        }
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, var(--deep-blue) 0%, var(--deep-blue-alt) 60%, #0b1120 100%);
            color: #fff;
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.85);
            padding: 12px 20px;
            border-radius: 8px;
            margin: 2px 0;
            transition: all 0.3s;
            font-weight: 500;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.16);
            transform: translateX(4px);
        }
        .main-content {
            background-color: #f9fafb;
            min-height: 100vh;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(15, 23, 42, 0.12);
            background-color: #ffffff;
            color: var(--text-dark);
        }
        .card-header {
            background-color: var(--deep-blue-light);
            border-bottom: 1px solid #d1d5db;
            border-radius: 15px 15px 0 0 !important;
        }
        .form-control,
        .form-select {
            background-color: #f9fafb;
            border-color: #cbd5f5;
            color: var(--text-dark);
        }
        .form-control::placeholder {
            color: #9ca3af;
        }
        .form-control:focus,
        .form-select:focus {
            background-color: #ffffff;
            border-color: #2563eb;
            box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25);
            color: var(--text-dark);
        }
        .btn-primary {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 50%, #0f172a 100%);
            border: none;
        }
        .btn-primary:hover {
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.45);
        }
        .btn-outline-secondary {
            border-color: #cbd5f5;
            color: var(--text-dark);
        }
        .btn-outline-secondary:hover {
            background-color: var(--deep-blue-light);
            border-color: var(--deep-blue-alt);
            color: var(--text-dark);
        }
        .alert-success {
            background-color: #ecfdf3;
            border-color: #4ade80;
            color: #166534;
        }
        .alert-danger {
            background-color: #fef2f2;
            border-color: #fca5a5;
            color: #b91c1c;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0">
                <div class="sidebar">
                    <div class="p-3">
                        <h4 class="text-white mb-4">
                            <i class="fas fa-graduation-cap me-2"></i>CMS Admin
                        </h4>
                        <nav class="nav flex-column">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin?action=add-course">
                                <i class="fas fa-plus-circle me-2"></i>Add Course
                            </a>
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin?action=add-user">
                                <i class="fas fa-user-plus me-2"></i>Add User
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Logout
                            </a>
                        </nav>
                    </div>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="main-content p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0">
                            <i class="fas fa-user-plus me-2" style="color:#1d4ed8;"></i>Add New User
                        </h2>
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                    
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="fas fa-user me-2" style="color:#1d4ed8;"></i>User Information
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form method="post" action="${pageContext.request.contextPath}/admin">
                                        <input type="hidden" name="action" value="add-user">
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="username" class="form-label">Username *</label>
                                                <input type="text" class="form-control" id="username" name="username" 
                                                       placeholder="Enter username" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="email" class="form-label">Email *</label>
                                                <input type="email" class="form-control" id="email" name="email" 
                                                       placeholder="Enter email address" required>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="firstName" class="form-label">First Name *</label>
                                                <input type="text" class="form-control" id="firstName" name="firstName" 
                                                       placeholder="Enter first name" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="lastName" class="form-label">Last Name *</label>
                                                <input type="text" class="form-control" id="lastName" name="lastName" 
                                                       placeholder="Enter last name" required>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="password" class="form-label">Password *</label>
                                                <input type="password" class="form-control" id="password" name="password" 
                                                       placeholder="Enter password" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="role" class="form-label">Role *</label>
                                                <select class="form-select" id="role" name="role" required>
                                                    <option value="">Select a role</option>
                                                    <option value="ADMIN">Admin</option>
                                                    <option value="TEACHER">Teacher</option>
                                                    <option value="STUDENT">Student</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                            <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary me-md-2">
                                                <i class="fas fa-times me-2"></i>Cancel
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-plus me-2"></i>Add User
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

