Course Management System (JSP / Servlet / MySQL)
A role‑based Course Management System built with Java Servlets, JSP, JSTL, Bootstrap, and MySQL. It provides separate portals for Admin, Teacher, and Student with a clean, modern UI and an MVC-style structure.

Features
Admin
Secure login with admin role

Manage courses

Add new courses (code, name, description, credits, max students, teacher)

Delete existing courses

Manage users

Add new users (Admin, Teacher, Student)

Delete users

Dashboard

Summary cards: total courses, teachers, students, total users

Tables with all courses and all users

Teacher
Secure login with teacher role

Teacher dashboard

See assigned courses with stats (credits, capacity, enrolled students)

Summary of total courses, total students, total credits

View enrolled students per course

Student
Secure login with student role

Student dashboard

“My Courses” overview

“Available Courses” overview

My Courses

View enrolled courses

Drop course

Available Courses

View all open courses with teacher, credits, capacity, and status

Register for available (non‑full) courses

Tech Stack
Backend: Java 17+, Jakarta Servlet (Tomcat 10+), JSP, JSTL

Frontend: JSP, HTML5, CSS3, Bootstrap 5, Font Awesome

Database: MySQL 8.x

Build Tool: Maven

Server: Apache Tomcat 10.x

Architecture: Classic MVC

Controllers: Servlets (AdminServlet, StudentServlet, TeacherServlet, AuthServlet, …)

Models: POJOs (User, Course, Registration, …)

DAOs: JDBC (UserDAO, CourseDAO, RegistrationDAO, …)

Views: JSP pages under src/main/webapp

Project Structure
text
Course-Mangement-System/
├─ src/
│  └─ main/
│     ├─ java/
│     │  └─ com/cms/
│     │     ├─ servlet/
│     │     │  ├─ AdminServlet.java
│     │     │  ├─ StudentServlet.java
│     │     │  ├─ TeacherServlet.java
│     │     │  └─ AuthServlet.java
│     │     ├─ dao/
│     │     │  ├─ UserDAO.java
│     │     │  ├─ CourseDAO.java
│     │     │  └─ RegistrationDAO.java
│     │     ├─ model/
│     │     │  ├─ User.java
│     │     │  ├─ Course.java
│     │     │  └─ Registration.java
│     │     └─ util/
│     │        └─ DBUtil.java
│     └─ webapp/
│        ├─ WEB-INF/
│        │  └─ web.xml
│        ├─ login.jsp
│        ├─ admin-dashboard.jsp
│        ├─ add-course.jsp
│        ├─ add-user.jsp
│        ├─ teacher-dashboard.jsp
│        ├─ student-dashboard.jsp
│        ├─ my-courses.jsp
│        └─ available-courses.jsp
├─ pom.xml
└─ README.md
Adjust package names or JSP paths if your project layout differs slightly.

Getting Started
1. Prerequisites
Make sure these are installed and on your PATH:

JDK: 17 or later

Maven: 3.8+

MySQL: 8.x (server, client / Workbench)

Tomcat: 10.x (Jakarta EE 9+)

Git: to clone the repository

Quick sanity check:

bash
java -version
mvn -version
mysql --version
2. Clone the repository
bash
git clone git@github.com:Istiaque-verse/Course-Mangement-System.git
cd Course-Mangement-System
Database Setup
1. Create database
Log into MySQL and create the schema:

sql
CREATE DATABASE course_management
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE course_management;
2. Create tables
Minimal tables required (tweak if you already have a schema dump):

sql
-- users
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    email      VARCHAR(150) NOT NULL,
    role ENUM('ADMIN','TEACHER','STUDENT') NOT NULL
);

-- courses
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_code  VARCHAR(20)  NOT NULL UNIQUE,
    course_name  VARCHAR(200) NOT NULL,
    description  TEXT,
    credits      INT          NOT NULL,
    max_students INT          NOT NULL,
    teacher_id   INT          NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES users(id)
);

-- registrations (enrollments)
CREATE TABLE registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id   INT NOT NULL,
    course_id    INT NOT NULL,
    status       ENUM('ACTIVE','DROPPED') NOT NULL DEFAULT 'ACTIVE',
    registered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_student_course (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES users(id),
    FOREIGN KEY (course_id)  REFERENCES courses(id)
);
3. Seed initial data
For local testing, add one admin, one teacher and one student:

sql
-- Admin user (password is plain here; align with your auth logic)
INSERT INTO users (username, password, first_name, last_name, email, role)
VALUES ('admin1', 'admin123', 'Admin', 'User', 'admin@example.com', 'ADMIN');

-- Example teacher
INSERT INTO users (username, password, first_name, last_name, email, role)
VALUES ('teacher1', 'teacher123', 'John', 'Doe', 'teacher1@example.com', 'TEACHER');

-- Example student
INSERT INTO users (username, password, first_name, last_name, email, role)
VALUES ('student1', 'student123', 'Alice', 'Smith', 'student1@example.com', 'STUDENT');
If you have a db/schema.sql or dump file, you can replace this section with:

bash
mysql -u your_mysql_user -p course_management < db/schema.sql
4. Configure DB connection
In DBUtil.java (or wherever you centralize DB config), set your own credentials:

java
private static final String URL =
    "jdbc:mysql://localhost:3306/course_management?useSSL=false&serverTimezone=UTC";
private static final String USER = "your_mysql_user";
private static final String PASSWORD = "your_mysql_password";
Make sure the MySQL driver is declared in pom.xml:

xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.0.33</version>
</dependency>
Build and Run
1. Build with Maven
From the project root:

bash
mvn clean package
This should produce a WAR in target, e.g.:

text
target/CourseManagement.war
2. Deploy to Tomcat
Copy the WAR to Tomcat’s webapps directory:

bash
cp target/CourseManagement.war /path/to/tomcat/webapps/
Restart Tomcat:

bash
cd /path/to/tomcat/bin
./shutdown.sh 2>/dev/null || true
./startup.sh
3. Access the application
In the browser:

http://localhost:8080/CourseManagement/login

Adjust the context path if your WAR name or Tomcat configuration is different.

Default test logins (update to match your seed data):

Admin: admin1 / admin123

Teacher: teacher1 / teacher123

Student: student1 / student123

Roles & Flows
Admin
Login → Admin Dashboard

Manage courses (add / delete)

Manage users (add / delete)

View platform‑level stats and tables

Teacher
Login → Teacher Dashboard

See assigned courses and enrolled students

Track number of students and credits taught

Student
Login → Student Dashboard

Enroll in available courses

View/dismiss “My Courses”

Drop courses from “My Courses”

Development Notes
Java version
The project targets Java 17. Make sure the Maven compiler plugin reflects that:

xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-compiler-plugin</artifactId>
  <version>3.11.0</version>
  <configuration>
    <source>17</source>
    <target>17</target>
  </configuration>
</plugin>
Servlet API
The app uses the Jakarta namespace (jakarta.servlet.*), so you’ll want Tomcat 10+ or any other Jakarta EE 9 compatible servlet container.

JSTL
If JSTL is not already on your classpath, add:

xml
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
Roadmap / Ideas
Things that would be nice to add next:

Password hashing (BCrypt) instead of storing plain passwords

Teacher side: gradebook, basic assignment management, attendance

Student side: profile page, progress tracking, simple notifications

Admin side: pagination + search on tables, basic audit logs

Expose a REST API layer to later plug in SPA or mobile clients

Contributing
If you want to extend or tweak this project:

bash
# create a feature branch
git checkout -b feature/my-feature

# commit changes
git commit -m "Add my feature"

# push and open a PR from your fork
git push origin feature/my-feature
I’m keeping the structure simple on purpose so it’s easy to understand and modify for coursework, hackathons, or practice.

License
Pick a license that fits how you want this to be used (MIT, Apache 2.0, etc.) and drop a LICENSE file in the root. Until then, treat it as “all rights reserved” by default.

Support / Issues
If something breaks or you have ideas for improvements, open an issue here:

https://github.com/Istiaque-verse/Course-Mangement-System/issues
