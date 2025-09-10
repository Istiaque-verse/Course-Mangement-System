<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Course - Course Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            border-radius: 8px;
            margin: 2px 0;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            color: white;
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(5px);
        }
        .main-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin?action=add-course">
                                <i class="fas fa-plus-circle me-2"></i>Add Course
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin?action=add-user">
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
                        <h2><i class="fas fa-plus-circle me-2"></i>Add New Course</h2>
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
                                    <h5 class="mb-0"><i class="fas fa-book me-2"></i>Course Information</h5>
                                </div>
                                <div class="card-body">
                                    <form method="post" action="${pageContext.request.contextPath}/admin">
                                        <input type="hidden" name="action" value="add-course">
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="courseCode" class="form-label">Course Code *</label>
                                                <input type="text" class="form-control" id="courseCode" name="courseCode" 
                                                       placeholder="e.g., CS101" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="courseName" class="form-label">Course Name *</label>
                                                <input type="text" class="form-control" id="courseName" name="courseName" 
                                                       placeholder="e.g., Introduction to Programming" required>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="description" class="form-label">Description</label>
                                            <textarea class="form-control" id="description" name="description" rows="3" 
                                                      placeholder="Course description..."></textarea>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-4 mb-3">
                                                <label for="credits" class="form-label">Credits *</label>
                                                <input type="number" class="form-control" id="credits" name="credits" 
                                                       min="1" max="6" value="3" required>
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label for="teacherId" class="form-label">Teacher *</label>
                                                <select class="form-select" id="teacherId" name="teacherId" required>
                                                    <option value="">Select a teacher</option>
                                                    <c:forEach var="teacher" items="${teachers}">
                                                        <option value="${teacher.id}">${teacher.fullName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label for="maxStudents" class="form-label">Max Students</label>
                                                <input type="number" class="form-control" id="maxStudents" name="maxStudents" 
                                                       min="1" max="100" value="30" required>
                                            </div>
                                        </div>
                                        
                                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                            <a href="${pageContext.request.contextPath}/admin" class="btn btn-secondary me-md-2">
                                                <i class="fas fa-times me-2"></i>Cancel
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-plus me-2"></i>Add Course
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
