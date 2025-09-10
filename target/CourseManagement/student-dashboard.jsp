<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Course Management System</title>
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
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
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
        .course-card {
            border-left: 4px solid #667eea;
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/student">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/student?action=my-courses">
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
                        <h2><i class="fas fa-tachometer-alt me-2"></i>Student Dashboard</h2>
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
                        <div class="col-md-4">
                            <div class="card stat-card">
                                <div class="card-body text-center">
                                    <i class="fas fa-book fa-2x mb-2"></i>
                                    <h4>${myCourses.size()}</h4>
                                    <p class="mb-0">My Courses</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card stat-card">
                                <div class="card-body text-center">
                                    <i class="fas fa-plus-circle fa-2x mb-2"></i>
                                    <h4>${availableCourses.size()}</h4>
                                    <p class="mb-0">Available Courses</p>
                                </div>
                            </div>
                        </div>
                        <!-- Total credits not available from current Registration model; hidden to avoid errors -->
                    </div>
                    
                    <!-- My Courses -->
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="fas fa-book me-2"></i>My Courses</h5>
                            <a href="${pageContext.request.contextPath}/student?action=my-courses" class="btn btn-outline-primary btn-sm">
                                View All
                            </a>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty myCourses}">
                                    <div class="text-center py-4">
                                        <i class="fas fa-book fa-3x text-muted mb-3"></i>
                                        <p class="text-muted">You are not registered for any courses yet.</p>
                                        <a href="${pageContext.request.contextPath}/student?action=available-courses" class="btn btn-primary">
                                            Browse Available Courses
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row">
                                        <c:forEach var="registration" items="${myCourses}" begin="0" end="2">
                                            <div class="col-md-4 mb-3">
                                                <div class="card course-card h-100">
                                                    <div class="card-body">
                                                        <h6 class="card-title">
                                                            <span class="badge bg-primary">${registration.courseCode}</span>
                                                            ${registration.courseName}
                                                        </h6>
                                                        <p class="card-text text-muted small">
                                                            <i class="fas fa-hashtag me-1"></i>Code: ${registration.courseCode}
                                                        </p>
                                                        <form method="post" action="${pageContext.request.contextPath}/student" style="display: inline;">
                                                            <input type="hidden" name="action" value="drop">
                                                            <input type="hidden" name="courseId" value="${registration.courseId}">
                                                            <button type="submit" class="btn btn-danger btn-sm" 
                                                                    onclick="return confirm('Are you sure you want to drop this course?')">
                                                                <i class="fas fa-times me-1"></i>Drop
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Available Courses -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="fas fa-plus-circle me-2"></i>Available Courses</h5>
                            <a href="${pageContext.request.contextPath}/student?action=available-courses" class="btn btn-outline-primary btn-sm">
                                View All
                            </a>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty availableCourses}">
                                    <div class="text-center py-4">
                                        <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                        <p class="text-muted">You are registered for all available courses!</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row">
                                        <c:forEach var="course" items="${availableCourses}" begin="0" end="2">
                                            <div class="col-md-4 mb-3">
                                                <div class="card course-card h-100">
                                                    <div class="card-body">
                                                        <h6 class="card-title">
                                                            <span class="badge bg-primary">${course.courseCode}</span>
                                                            ${course.courseName}
                                                        </h6>
                                                        <p class="card-text text-muted small">
                                                            <i class="fas fa-user me-1"></i>Teacher: ${course.teacherName}<br>
                                                            <i class="fas fa-star me-1"></i>Credits: ${course.credits}<br>
                                                            <i class="fas fa-users me-1"></i>Students: ${course.currentStudents}/${course.maxStudents}
                                                        </p>
                                                        <c:choose>
                                                            <c:when test="${course.full}">
                                                                <span class="badge bg-warning">Full</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <form method="post" action="${pageContext.request.contextPath}/student" style="display: inline;">
                                                                    <input type="hidden" name="action" value="register">
                                                                    <input type="hidden" name="courseId" value="${course.id}">
                                                                    <button type="submit" class="btn btn-success btn-sm">
                                                                        <i class="fas fa-plus me-1"></i>Register
                                                                    </button>
                                                                </form>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
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
