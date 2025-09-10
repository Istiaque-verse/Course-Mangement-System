<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Students - Course Management System</title>
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
        .course-info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .table th {
            background-color: #f8f9fa;
            border-top: none;
            font-weight: 600;
            color: #495057;
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
                            <i class="fas fa-chalkboard-teacher me-2"></i>Teacher Portal
                        </h4>
                        <nav class="nav flex-column">
                            <a class="nav-link" href="${pageContext.request.contextPath}/teacher">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
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
                        <h2><i class="fas fa-users me-2"></i>Course Students</h2>
                        <a href="${pageContext.request.contextPath}/teacher" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Course Information -->
                    <div class="card course-info-card mb-4">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-8">
                                    <h4 class="mb-2">
                                        <span class="badge bg-light text-dark me-2">${course.courseCode}</span>
                                        ${course.courseName}
                                    </h4>
                                    <p class="mb-0">${course.description}</p>
                                </div>
                                <div class="col-md-4 text-md-end">
                                    <div class="row text-center">
                                        <div class="col-4">
                                            <h5>${course.credits}</h5>
                                            <small>Credits</small>
                                        </div>
                                        <div class="col-4">
                                            <h5>${students.size()}</h5>
                                            <small>Students</small>
                                        </div>
                                        <div class="col-4">
                                            <h5>${course.maxStudents}</h5>
                                            <small>Capacity</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Students List -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-user-graduate me-2"></i>Enrolled Students</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty students}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-user-graduate fa-4x text-muted mb-4"></i>
                                        <h4 class="text-muted">No students enrolled</h4>
                                        <p class="text-muted">No students have registered for this course yet.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th>Student Name</th>
                                                    <th>Registration Date</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="student" items="${students}" varStatus="status">
                                                    <tr>
                                                        <td>${status.index + 1}</td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <div class="avatar bg-primary text-white rounded-circle me-3" 
                                                                     style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
                                                                    ${student.studentName.charAt(0)}
                                                                </div>
                                                                <div>
                                                                    <div class="fw-bold">${student.studentName}</div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${student.registeredAt}" pattern="MMM dd, yyyy"/>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-success">${student.status}</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    
                                    <div class="row mt-4">
                                        <div class="col-md-6">
                                            <div class="card">
                                                <div class="card-body text-center">
                                                    <h6 class="card-title">
                                                        <i class="fas fa-user-graduate me-2"></i>Total Enrolled
                                                    </h6>
                                                    <h4 class="text-primary">${students.size()}</h4>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card">
                                                <div class="card-body text-center">
                                                    <h6 class="card-title">
                                                        <i class="fas fa-percentage me-2"></i>Enrollment Rate
                                                    </h6>
                                                    <h4 class="text-info">
                                                        <fmt:formatNumber value="${(students.size() / course.maxStudents) * 100}" 
                                                                        maxFractionDigits="1"/>%
                                                    </h4>
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
