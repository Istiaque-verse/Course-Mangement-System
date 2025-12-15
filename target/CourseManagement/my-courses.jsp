<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <style>
        :root {
            --primary-cyan: #06b6d4;
            --primary-cyan-dark: #0891b2;
            --cyan-light: #e0f2fe;
        }
        body {
            background-color: #f3f4f6;
        }
        .table thead th {
            background-color: var(--cyan-light);
            color: #111827;
        }
        .badge-code {
            font-size: 0.85rem;
        }
        .badge.bg-primary {
            background-color: var(--primary-cyan-dark) !important;
        }
        .registered-at {
            font-size: 0.9rem;
            color: #6b7280;
        }
        .btn-outline-danger {
            border-color: #dc2626;
            color: #dc2626;
        }
        .btn-outline-danger:hover {
            background-color: #dc2626;
            color: #ffffff;
        }
    </style>
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">My Courses</h2>

    <c:choose>
        <c:when test="${empty myCourses}">
            <div class="alert alert-info">
                You are not registered for any courses yet.
            </div>
        </c:when>
        <c:otherwise>
            <table class="table table-striped table-hover align-middle">
                <thead>
                <tr>
                    <th style="width: 15%;">Course Code</th>
                    <th style="width: 45%;">Course Name</th>
                    <th style="width: 25%;">Registered At</th>
                    <th style="width: 15%;">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="registration" items="${myCourses}">
                    <tr>
                        <td>
                            <span class="badge bg-primary badge-code">
                                ${registration.courseCode}
                            </span>
                        </td>
                        <td>${registration.courseName}</td>
                        <td class="registered-at">
                            ${registration.registeredAt}
                        </td>
                        <td>
                            <form method="post"
                                  action="${pageContext.request.contextPath}/student"
                                  style="display:inline;">
                                <input type="hidden" name="action" value="drop">
                                <input type="hidden" name="courseId" value="${registration.courseId}">
                                <button type="submit"
                                        class="btn btn-outline-danger btn-sm"
                                        onclick="return confirm('Are you sure you want to drop this course?');">
                                    <i class="bi bi-x-circle me-1"></i>Drop
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <a href="${pageContext.request.contextPath}/student" class="btn btn-secondary mt-3">
        Back to Dashboard
    </a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
