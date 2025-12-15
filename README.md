# Course Management System for CS-250 (JSP/Servlet/MySQL)

A role‑based Course Management System built with Java Servlets, JSP, JSTL, Bootstrap, and MySQL. It provides separate portals for Admin, Teacher, and Student with a clean, modern UI and clear separation of concerns (MVC style).


## ✨ Features

### Admin

- Secure login with admin role
- Manage courses
  - Add new courses (code, name, description, credits, max students, teacher)
  - Delete existing courses
- Manage users
  - Add new users (Admin, Teacher, Student)
  - Delete users
- Dashboard
  - Overview cards: total courses, teachers, students, total users
  - Tables for all courses and all users

### Teacher

- Secure login with teacher role
- Teacher dashboard
  - See assigned courses with stats (credits, capacity, enrolled students)
  - Summary cards: number of courses taught, total students, total credits
- View enrolled students per course

### Student

- Secure login with student role
- Student dashboard
  - My Courses summary
  - Available Courses summary
- My Courses
  - View enrolled courses
  - Drop course
- Available Courses
  - View all open courses with teacher, credits, capacity, and status
  - Register for available (non‑full) courses

---

## 🛠 Tech Stack

- **Backend:** Java 17+, Jakarta Servlet (Tomcat 10+), JSP, JSTL [web:538]
- **Frontend:** JSP, HTML5, CSS3, Bootstrap 5, Font Awesome
- **Database:** MySQL 8.x
- **Build Tool:** Maven
- **Server:** Apache Tomcat 10.x
- **Architecture:** Classic MVC
  - Controllers: Servlets (`AdminServlet`, `StudentServlet`, `TeacherServlet`, `AuthServlet`, etc.)
  - Models: Plain Java classes (`User`, `Course`, `Registration`, …)
  - DAOs: JDBC DAOs (`UserDAO`, `CourseDAO`, `RegistrationDAO`, …)
  - Views: JSP pages under `src/main/webapp`

## 📂 Project Structure

Course-Mangement-System/
├─ src/
│ └─ main/
│ ├─ java/
│ │ └─ com/cms/
│ │ ├─ servlet/
│ │ │ ├─ AdminServlet.java
│ │ │ ├─ StudentServlet.java
│ │ │ ├─ TeacherServlet.java
│ │ │ └─ AuthServlet.java
│ │ ├─ dao/
│ │ │ ├─ UserDAO.java
│ │ │ ├─ CourseDAO.java
│ │ │ └─ RegistrationDAO.java
│ │ ├─ model/
│ │ │ ├─ User.java
│ │ │ ├─ Course.java
│ │ │ └─ Registration.java
│ │ └─ util/
│ │ └─ DBUtil.java
│ └─ webapp/
│ ├─ WEB-INF/
│ │ └─ web.xml
│ ├─ login.jsp
│ ├─ admin-dashboard.jsp
│ ├─ add-course.jsp
│ ├─ add-user.jsp
│ ├─ teacher-dashboard.jsp
│ ├─ student-dashboard.jsp
│ ├─ my-courses.jsp
│ └─ available-courses.jsp
├─ pom.xml
└─ README.md


---

## 🚀 Getting Started

### 1. Prerequisites

Install and configure:

- **JDK:** 17 or later
- **Maven:** 3.8+  
- **MySQL:** 8.x (server + client / Workbench) [web:538]
- **Tomcat:** 10.x (Jakarta EE 9+)  
- **Git:** to clone this repository

Ensure:

java -version
mvn -version
mysql --version


### 2. Clone the repository

git clone git@github.com:Istiaque-verse/Course-Mangement-System.git
cd Course-Mangement-System


## 🗄 Database Setup

1. **Create database**

Log into MySQL:

CREATE DATABASE course_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE course_management;


2. **Create tables**

Create minimal required tables :

CREATE TABLE users (
id INT AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(50) NOT NULL UNIQUE,
password VARCHAR(255) NOT NULL,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
email VARCHAR(150) NOT NULL,
role ENUM('ADMIN','TEACHER','STUDENT') NOT NULL
);


CREATE TABLE courses (
id INT AUTO_INCREMENT PRIMARY KEY,
course_code VARCHAR(20) NOT NULL UNIQUE,
course_name VARCHAR(200) NOT NULL,
description TEXT,
credits INT NOT NULL,
max_students INT NOT NULL,
teacher_id INT NOT NULL,
FOREIGN KEY (teacher_id) REFERENCES users(id)
);


CREATE TABLE registrations (
id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT NOT NULL,
course_id INT NOT NULL,
status ENUM('ACTIVE','DROPPED') NOT NULL DEFAULT 'ACTIVE',
registered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
UNIQUE KEY uniq_student_course (student_id, course_id),
FOREIGN KEY (student_id) REFERENCES users(id),
FOREIGN KEY (course_id) REFERENCES courses(id)
);


3. **Seed initial data**

-- Admin user (password will be plain for now, or match your hashing logic)
INSERT INTO users (username, password, first_name, last_name, email, role)
VALUES ('admin1', 'admin123', 'Admin', 'User', 'admin@example.com', 'ADMIN');

-- Example teacher
INSERT INTO users (username, password, first_name, last_name, email, role)
VALUES ('teacher1', 'teacher123', 'John', 'Doe', 'teacher1@example.com', 'TEACHER');

-- Example student
INSERT INTO users (username, password, first_name, last_name, email, role)
VALUES ('student1', 'student123', 'Alice', 'Smith', 'student1@example.com', 'STUDENT');



4. **Configure DB connection**

In `DBUtil.java` (or your config file), update:

private static final String URL = "jdbc:mysql://localhost:3306/course_management?useSSL=false&serverTimezone=UTC";
private static final String USER = "your_mysql_user";
private static final String PASSWORD = "your_mysql_password";

Ensure MySQL JDBC driver is declared in `pom.xml`:

<dependency> <groupId>mysql</groupId> <artifactId>mysql-connector-j</artifactId> <version>8.0.33</version> </dependency> ```


🧱 Build and Run

1. Build with Maven
From the project root:
mvn clean package
This creates target/CourseManagement.war (or similar, depending on artifactId).

2. Deploy to Tomcat
Copy the WAR to Tomcat’s webapps directory:
cp target/CourseManagement.war /path/to/tomcat/webapps/

Restart Tomcat:
cd /path/to/tomcat/bin
./shutdown.sh 2>/dev/null || true
./startup.sh

3. Access the application
Open: http://localhost:8080/CourseManagement/login

Use the default credentials you configured, e.g.:

Admin: admin1 / admin123

Teacher: teacher1 / teacher123

Student: student1 / student123

👤 Roles & Flows
Admin
Login → Admin Dashboard

Add courses / users

See global statistics

Delete courses and users

Teacher
Login → Teacher Dashboard

View assigned courses and enrolled students

Track total students / credits

Student
Login → Student Dashboard

Enroll in available courses

View and drop registered courses

🔧 Development Notes
Java version: Project is intended for JDK 17+; update maven-compiler-plugin accordingly in pom.xml:

text
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-compiler-plugin</artifactId>
  <version>3.11.0</version>
  <configuration>
    <source>17</source>
    <target>17</target>
  </configuration>
</plugin>
Servlet API: Using Jakarta (jakarta.servlet) compatible with Tomcat 10+.

JSTL: Add JSTL dependency if not already present:

text
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
    <version>2.0.0</version>
</dependency>
<dependency>
    <groupId>org.glassfish.web</groupId>
    <artifactId>jakarta.servlet.jsp.jstl</artifactId>
    <version>2.0.0</version>
</dependency>

📌 Roadmap / Ideas
Password hashing (BCrypt) instead of plain text

Teacher: gradebook, assignments, attendance

Student: profile page, progress tracking, notifications

Admin: pagination/search on tables, audit logs

REST API layer for future SPA/mobile clients

🤝 Contributing
Fork the repo

Create a feature branch:

text
git checkout -b feature/my-feature
Commit your changes:

text
git commit -m "Add some feature"
Push to your fork:

text
git push origin feature/my-feature
Open a Pull Request

📄 License
Add your preferred license here (e.g. MIT, Apache 2.0), and include the corresponding LICENSE file in the repository. [web:624]

🙋 Support
For questions or suggestions, open an issue in the GitHub repository:
https://github.com/Istiaque-verse/Course-Mangement-System/issues

