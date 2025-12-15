<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Course Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: radial-gradient(circle at top, #1e3c72 0%, #1b2a49 40%, #020617 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            color: #fff;
        }
        .login-card {
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.08);
            color: #0f172a;
        }
        .login-header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #0f172a 100%);
            color: #fff;
            border-radius: 15px 15px 0 0;
            padding: 2rem;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .login-header h3 {
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .form-label {
            color: #0f172a;
            font-weight: 500;
        }
        .form-control {
            background-color: #f9fafb;
            border-color: #cbd5f5;
            color: #0f172a;
        }
        .form-control::placeholder {
            color: #9ca3af;
        }
        .form-control:focus {
            background-color: #ffffff;
            border-color: #2563eb;
            box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25);
            color: #0f172a;
        }
        .btn-login {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 50%, #0f172a 100%);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #fff;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(37, 99, 235, 0.5);
        }
        .alert-danger {
            background-color: rgba(220, 38, 38, 0.06);
            border-color: rgba(220, 38, 38, 0.5);
            color: #b91c1c;
        }
        small.text-muted {
            color: #6b7280 !important;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-4">
                <div class="card login-card">
                    <div class="login-header">
                        <i class="fas fa-graduation-cap fa-3x mb-3"></i>
                        <h3>Course Management</h3>
                        <p class="mb-0">Sign in to your account</p>
                    </div>
                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <form method="post" action="${pageContext.request.contextPath}/login">
                            <div class="mb-3">
                                <label for="username" class="form-label">
                                    <i class="fas fa-user me-2 text-primary"></i>Username
                                </label>
                                <input type="text" class="form-control" id="username" name="username" 
                                       placeholder="Enter your username" required>
                            </div>
                            
                            <div class="mb-4">
                                <label for="password" class="form-label">
                                    <i class="fas fa-lock me-2 text-primary"></i>Password
                                </label>
                                <input type="password" class="form-control" id="password" name="password" 
                                       placeholder="Enter your password" required>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-login">
                                    <i class="fas fa-sign-in-alt me-2"></i>Sign In
                                </button>
                            </div>
                        </form>
                        
                        <div class="text-center mt-4">
                            <small class="text-muted">
                                <i class="fas fa-info-circle me-1 text-primary"></i>
                                Default credentials: admin1/admin123
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
