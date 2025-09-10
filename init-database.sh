#!/bin/bash

# Course Management System - Database Initialization Script
# This script initializes the MySQL database for the Course Management System

echo "=== Course Management System - Database Initialization ==="
echo ""

# Database configuration
DB_NAME="course_management_system"
DB_USER="root"
DB_PASSWORD="password"  # Change this to your MySQL password

# Check if MySQL is running
if ! pgrep -x "mysqld" > /dev/null; then
    echo "Error: MySQL is not running. Please start MySQL first."
    exit 1
fi

echo "MySQL is running. Proceeding with database initialization..."
echo ""

# Create database and run schema
echo "Creating database and tables..."
mysql -u $DB_USER -p$DB_PASSWORD < src/main/resources/schema.sql

if [ $? -eq 0 ]; then
    echo "✅ Database initialization completed successfully!"
    echo ""
    echo "Default login credentials:"
    echo "  Admin: admin / admin123"
    echo "  Teacher: teacher1 / admin123"
    echo "  Student: student1 / admin123"
    echo ""
    echo "You can now build and deploy the application."
else
    echo "❌ Database initialization failed!"
    echo "Please check your MySQL credentials and try again."
    exit 1
fi
