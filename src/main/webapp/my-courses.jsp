<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Courses - Course Management System</title>
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
            transition: transform 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .course-card {
            border-left: 4px solid #667eea;
        }
        .table th {
            background-color: #f8f9fa;
            border-top: none;
            font-weight: 600;
            color: #495057;
        }
        .btn-action {
            padding: 5px 10px;
            margin: 2px;
            border-radius: 20px;
            font-size: 0.8rem;
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
                            <i class="fas fa-user-graduate me-2"></i>Student Portal
                        </h4>
                        <nav class="nav flex-column">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                            <a class="nav-link active" href="${pageContext.request.contextPath}/student?action=my-courses">
                                <i class="fas fa-book me-2"></i>My Courses
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/student?action=available-courses">
                                <i class="fas fa-plus-circle me-2"></i>Available Courses
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
                        <h2><i class="fas fa-book me-2"></i>My Courses</h2>
                        <a href="${pageContext.request.contextPath}/student" class="btn btn-outline-secondary">
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
                    
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-book me-2"></i>Registered Courses</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty myCourses}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-book fa-4x text-muted mb-4"></i>
                                        <h4 class="text-muted">No courses registered</h4>
                                        <p class="text-muted">You haven't registered for any courses yet.</p>
                                        <a href="${pageContext.request.contextPath}/student?action=available-courses" class="btn btn-primary">
                                            <i class="fas fa-plus me-2"></i>Browse Available Courses
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Course Code</th>
                                                    <th>Course Name</th>
                                                    <th>Teacher</th>
                                                    <th>Credits</th>
                                                    <th>Registered Date</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="registration" items="${myCourses}">
                                                    <tr>
                                                        <td><span class="badge bg-primary">${registration.courseCode}</span></td>
                                                        <td>${registration.courseName}</td>
                                                        <td>${registration.course.teacherName}</td>
                                                        <td>${registration.course.credits}</td>
                                                        <td>
                                                            <fmt:formatDate value="${registration.registeredAt}" pattern="MMM dd, yyyy"/>
                                                        </td>
                                                        <td>
                                                            <form method="post" action="${pageContext.request.contextPath}/student" style="display: inline;">
                                                                <input type="hidden" name="action" value="drop">
                                                                <input type="hidden" name="courseId" value="${registration.courseId}">
                                                                <button type="submit" class="btn btn-danger btn-sm btn-action" 
                                                                        onclick="return confirm('Are you sure you want to drop this course?')">
                                                                    <i class="fas fa-times me-1"></i>Drop
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    
                                    <div class="row mt-4">
                                        <div class="col-md-6">
                                            <div class="card course-card">
                                                <div class="card-body">
                                                    <h6 class="card-title">
                                                        <i class="fas fa-graduation-cap me-2"></i>Total Credits
                                                    </h6>
                                                    <h4 class="text-primary">
                                                        ${myCourses.stream().mapToInt(c -> c.course.credits).sum()}
                                                    </h4>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card course-card">
                                                <div class="card-body">
                                                    <h6 class="card-title">
                                                        <i class="fas fa-book me-2"></i>Total Courses
                                                    </h6>
                                                    <h4 class="text-primary">${myCourses.size()}</h4>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
