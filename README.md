# Course Management System

A complete Servlet + JSP web application for managing courses, students, and teachers with role-based access control.

## Features

- **Role-based Authentication**: Admin, Teacher, and Student roles
- **Course Management**: Add, view, and manage courses
- **Student Registration**: Students can register for available courses
- **Teacher Dashboard**: Teachers can view assigned courses and enrolled students
- **Admin Panel**: Complete administrative control over users and courses
- **Responsive UI**: Modern Bootstrap-based interface
- **Secure Authentication**: BCrypt password hashing

## Technology Stack

- **Backend**: Java Servlets, JSP
- **Database**: MySQL 8.0+
- **Frontend**: Bootstrap 5, Font Awesome
- **Build Tool**: Maven
- **Security**: BCrypt password hashing
- **Server**: Apache Tomcat

## Project Structure

```
CourseManagement/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/cms/
│   │   │       ├── dao/           # Data Access Objects
│   │   │       ├── model/         # Entity classes
│   │   │       ├── servlet/       # Servlet controllers
│   │   │       └── util/          # Utility classes
│   │   ├── resources/
│   │   │   └── schema.sql         # Database schema
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml        # Web configuration
│   │       └── *.jsp              # JSP pages
├── pom.xml                        # Maven configuration
├── init-database.sh               # Database setup script
└── README.md
```

## Prerequisites

- Java 8 or higher
- Maven 3.6+
- MySQL 8.0+
- Apache Tomcat 9.0+


### 3. Deploy to Tomcat

1. Copy the generated WAR file to Tomcat's `webapps/` directory
2. Start Tomcat server
3. Access the application at `http://localhost:8080/CourseManagement`

## Default Login Credentials

| Role    | Username | Password  |
|---------|----------|-----------|
| Admin   | admin    | admin123  |
| Teacher | teacher1 | admin123  |
| Student | student1 | admin123  |

## User Roles & Permissions

### Admin
- View all users and courses
- Add new courses and assign teachers
- Add new users (admin, teacher, student)
- Delete courses and users
- Full system access

### Teacher
- View assigned courses
- View enrolled students for each course
- Course statistics and enrollment information

### Student
- View available courses
- Register for courses
- View registered courses
- Drop courses

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | /login   | Login page |
| POST   | /login   | Authenticate user |
| GET    | /logout  | Logout user |
| GET    | /admin   | Admin dashboard |
| GET    | /student | Student dashboard |
| GET    | /teacher | Teacher dashboard |

## Database Schema

### Users Table
- `id` (Primary Key)
- `username` (Unique)
- `password` (BCrypt hashed)
- `email` (Unique)
- `role` (ADMIN, TEACHER, STUDENT)
- `first_name`, `last_name`
- `created_at`, `updated_at`

### Courses Table
- `id` (Primary Key)
- `course_code` (Unique)
- `course_name`
- `description`
- `credits`
- `teacher_id` (Foreign Key)
- `max_students`
- `created_at`, `updated_at`

### Registrations Table
- `id` (Primary Key)
- `student_id` (Foreign Key)
- `course_id` (Foreign Key)
- `registered_at`
- `status` (ACTIVE, DROPPED)

## Configuration

### Database Configuration
Update the database connection details in `DBUtil.java`:

```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/course_management?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
private static final String DB_USERNAME = "root";
private static final String DB_PASSWORD = "your_password";
```

### Application Configuration
The application uses `web.xml` for servlet configuration and security constraints.

