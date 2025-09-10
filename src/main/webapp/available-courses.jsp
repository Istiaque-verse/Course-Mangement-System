<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Courses - Course Management System</title>
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/student?action=my-courses">
                                <i class="fas fa-book me-2"></i>My Courses
                            </a>
                            <a class="nav-link active" href="${pageContext.request.contextPath}/student?action=available-courses">
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
                        <h2><i class="fas fa-plus-circle me-2"></i>Available Courses</h2>
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
                            <h5 class="mb-0"><i class="fas fa-plus-circle me-2"></i>Courses Available for Registration</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty availableCourses}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-check-circle fa-4x text-success mb-4"></i>
                                        <h4 class="text-muted">No available courses</h4>
                                        <p class="text-muted">You are already registered for all available courses!</p>
                                        <a href="${pageContext.request.contextPath}/student?action=my-courses" class="btn btn-primary">
                                            <i class="fas fa-book me-2"></i>View My Courses
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
                                                    <th>Students</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="course" items="${availableCourses}">
                                                    <tr>
                                                        <td><span class="badge bg-primary">${course.courseCode}</span></td>
                                                        <td>${course.courseName}</td>
                                                        <td>${course.teacherName}</td>
                                                        <td>${course.credits}</td>
                                                        <td>
                                                            <span class="badge bg-info">${course.currentStudents}</span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${course.currentStudents ge course.maxStudents}">
                                                                    <span class="badge bg-warning">Full</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-success">Available</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${course.currentStudents ge course.maxStudents}">
                                                                    <button class="btn btn-secondary btn-sm btn-action" disabled>
                                                                        <i class="fas fa-lock me-1"></i>Full
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <form method="post" action="${pageContext.request.contextPath}/student" style="display: inline;">
                                                                        <input type="hidden" name="action" value="register">
                                                                        <input type="hidden" name="courseId" value="${course.id}">
                                                                        <button type="submit" class="btn btn-success btn-sm btn-action">
                                                                            <i class="fas fa-plus me-1"></i>Register
                                                                        </button>
                                                                    </form>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    
                                    <div class="row mt-4">
                                        <div class="col-md-4">
                                            <div class="card course-card">
                                                <div class="card-body text-center">
                                                    <h6 class="card-title">
                                                        <i class="fas fa-book me-2"></i>Total Available
                                                    </h6>
                                                    <h4 class="text-primary">${availableCourses.size()}</h4>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="card course-card">
                                                <div class="card-body text-center">
                                                    <h6 class="card-title">
                                                        <i class="fas fa-check-circle me-2"></i>Available
                                                    </h6>
                                                    <h4 class="text-success">${availableCourses.stream().filter(c -> !c.full).count()}</h4>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="card course-card">
                                                <div class="card-body text-center">
                                                    <h6 class="card-title">
                                                        <i class="fas fa-lock me-2"></i>Full
                                                    </h6>
                                                    <h4 class="text-warning">${availableCourses.stream().filter(c -> c.full).count()}</h4>
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
