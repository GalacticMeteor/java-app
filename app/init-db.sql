-- Database initialization script
-- This script runs automatically when MySQL container starts for the first time

USE registration_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mobile VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create index on email for faster lookups
CREATE INDEX idx_users_email ON users(email);

-- Insert a sample user for testing (password: "password123")
-- The password hash is generated using BCrypt
INSERT INTO users (full_name, email, mobile, password) VALUES 
('Test User', 'test@example.com', '+1234567890', '$2a$10$mR9DBwVvKLY1Q2zJfKfwt.gJ0k/VJmHK8e6yy1J5ZjY8qU.Kx7hWC')
ON DUPLICATE KEY UPDATE full_name = full_name;

-- Show table structure
DESCRIBE users;

-- Show inserted data
SELECT id, full_name, email, mobile, created_at FROM users;
