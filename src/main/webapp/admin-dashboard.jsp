<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Course Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f9fafb;
            min-height: 100vh;
        }
        /* Deep blue base colors */
        :root {
            --deep-blue: #1e3c72;
            --deep-blue-alt: #2a5298;
            --deep-blue-light: #e5ecf8; /* very light tint for sections */
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
            min-height: 100vh;
            padding-bottom: 2rem;
        }
        .content-wrapper {
            background: #ffffff;
            border-radius: 20px;
            margin-top: 1.5rem;
            padding: 1.5rem;
            color: var(--text-dark);
            box-shadow: 0 15px 35px rgba(15, 23, 42, 0.18);
            border: 1px solid #e5e7eb;
        }
        .card {
            border: none;
            border-radius: 15px;
            background: #ffffff;
            color: var(--text-dark);
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.08);
            transition: transform 0.25s, box-shadow 0.25s;
        }
        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.12);
        }
        .stat-card {
            background: linear-gradient(135deg, var(--deep-blue) 0%, var(--deep-blue-alt) 50%, #0f172a 100%);
            color: #ffffff;
        }
        .stat-card p {
            color: #e5e7eb;
        }
        .card-header {
            background: var(--deep-blue-light);
            border-bottom: 1px solid #d1d5db;
            border-radius: 15px 15px 0 0 !important;
            color: var(--text-dark);
        }
        .table {
            color: var(--text-dark);
        }
        .table thead th {
            background-color: var(--deep-blue-light);
            border-top: none;
            font-weight: 600;
            color: var(--text-dark);
        }
        .table tbody tr {
            border-color: #e5e7eb;
        }
        .table tbody tr:hover {
            background-color: #f3f4f6;
        }
        .badge.bg-primary {
            background-color: var(--deep-blue-alt) !important;
        }
        .badge.bg-info {
            background-color: #0ea5e9 !important;
        }
        .btn-action {
            padding: 5px 10px;
            margin: 2px;
            border-radius: 20px;
            font-size: 0.8rem;
        }
        .btn-danger {
            background-color: #dc2626;
            border-color: #dc2626;
        }
        .btn-danger:hover {
            background-color: #b91c1c;
            border-color: #b91c1c;
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
        .text-muted {
            color: #6b7280 !important;
        }
        .section-divider {
            border-top: 1px solid var(--deep-blue-light);
            margin: 1.5rem 0;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0">
                <div class="sidebar d-flex flex-column p-3">
                    <h4 class="text-white mb-4">
                        <i class="fas fa-graduation-cap me-2"></i>CMS Admin
                    </h4>
                    <nav class="nav flex-column mb-auto">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin?action=add-course">
                            <i class="fas fa-plus-circle me-2"></i>Add Course
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin?action=add-user">
                            <i class="fas fa-user-plus me-2"></i>Add User
                        </a>
                    </nav>
                    <div class="mt-4">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="main-content p-3 p-md-4">
                    <div class="content-wrapper">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="mb-0">
                                <i class="fas fa-tachometer-alt me-2" style="color: var(--deep-blue-alt);"></i>
                                Admin Dashboard
                            </h2>
                            <span class="text-muted">Welcome, ${sessionScope.user.firstName}!</span>
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
                        
                        <!-- Statistics Cards -->
                        <div class="row mb-4">
                            <div class="col-md-3 mb-3 mb-md-0">
                                <div class="card stat-card">
                                    <div class="card-body text-center">
                                        <i class="fas fa-book fa-2x mb-2"></i>
                                        <h4>${courses.size()}</h4>
                                        <p class="mb-0">Total Courses</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3 mb-md-0">
                                <div class="card stat-card">
                                    <div class="card-body text-center">
                                        <i class="fas fa-chalkboard-teacher fa-2x mb-2"></i>
                                        <h4>${users.stream().filter(u -> u.role.name() == 'TEACHER').count()}</h4>
                                        <p class="mb-0">Teachers</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3 mb-md-0">
                                <div class="card stat-card">
                                    <div class="card-body text-center">
                                        <i class="fas fa-user-graduate fa-2x mb-2"></i>
                                        <h4>${users.stream().filter(u -> u.role.name() == 'STUDENT').count()}</h4>
                                        <p class="mb-0">Students</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card stat-card">
                                    <div class="card-body text-center">
                                        <i class="fas fa-users fa-2x mb-2"></i>
                                        <h4>${users.size()}</h4>
                                        <p class="mb-0">Total Users</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr class="section-divider" />
                        
                        <!-- Courses Table -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-book me-2" style="color: var(--deep-blue-alt);"></i>
                                    Courses
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th>Code</th>
                                                <th>Name</th>
                                                <th>Teacher</th>
                                                <th>Credits</th>
                                                <th>Students</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="course" items="${courses}">
                                                <tr>
                                                    <td><span class="badge bg-primary">${course.courseCode}</span></td>
                                                    <td>${course.courseName}</td>
                                                    <td>${course.teacherName}</td>
                                                    <td>${course.credits}</td>
                                                    <td>
                                                        <span class="badge bg-info">
                                                            ${course.currentStudents}/${course.maxStudents}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin" style="display: inline;">
                                                            <input type="hidden" name="action" value="delete-course">
                                                            <input type="hidden" name="courseId" value="${course.id}">
                                                            <button type="submit" class="btn btn-danger btn-sm btn-action" 
                                                                    onclick="return confirm('Are you sure you want to delete this course?')">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Users Table -->
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-users me-2" style="color: var(--deep-blue-alt);"></i>
                                    Users
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th>Username</th>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Role</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="user" items="${users}">
                                                <tr>
                                                    <td>${user.username}</td>
                                                    <td>${user.fullName}</td>
                                                    <td>${user.email}</td>
                                                    <td>
                                                        <span class="badge
                                                            bg-${user.role.name() == 'ADMIN' ? 'danger'
                                                                : user.role.name() == 'TEACHER' ? 'warning'
                                                                : 'success'}">
                                                            ${user.role.name()}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin" style="display: inline;">
                                                            <input type="hidden" name="action" value="delete-user">
                                                            <input type="hidden" name="userId" value="${user.id}">
                                                            <button type="submit" class="btn btn-danger btn-sm btn-action" 
                                                                    onclick="return confirm('Are you sure you want to delete this user?')">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div> <!-- content-wrapper -->
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

