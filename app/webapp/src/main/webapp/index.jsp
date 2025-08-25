<%-- Place this in: webapp/src/main/webapp/index.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration - DevOps Learning Platform</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .registration-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            max-width: 500px;
            width: 100%;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: #2c3e50;
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .header p {
            color: #7f8c8d;
            font-size: 16px;
            margin-bottom: 20px;
        }

        .divider {
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border: none;
            border-radius: 5px;
            margin-bottom: 30px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 10px;
            font-size: 14px;
        }

        .alert-error {
            background: #ffe6e6;
            border-left: 4px solid #e74c3c;
            color: #c0392b;
        }

        .alert-success {
            background: #e8f5e8;
            border-left: 4px solid #27ae60;
            color: #1e8449;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-group label {
            display: block;
            color: #2c3e50;
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e0e6ed;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .form-group input::placeholder {
            color: #95a5a6;
            font-style: italic;
        }

        .password-strength {
            margin-top: 8px;
            font-size: 12px;
        }

        .strength-bar {
            height: 4px;
            background: #ecf0f1;
            border-radius: 2px;
            margin-top: 5px;
            overflow: hidden;
        }

        .strength-fill {
            height: 100%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .terms-container {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 15px 20px;
            margin: 25px 0;
            border-radius: 5px;
        }

        .terms-container p {
            color: #5a6c7d;
            font-size: 14px;
            margin: 0;
        }

        .terms-container a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }

        .terms-container a:hover {
            text-decoration: underline;
        }

        .register-btn {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 18px;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 20px;
        }

        .register-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .register-btn:active {
            transform: translateY(-1px);
        }

        .signin-container {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 25px;
        }

        .signin-container p {
            color: #5a6c7d;
            font-size: 15px;
            margin: 0;
        }

        .signin-container a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .signin-container a:hover {
            text-decoration: underline;
        }

        .thank-you {
            text-align: center;
            color: #2c3e50;
        }

        .thank-you h2 {
            font-size: 24px;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .thank-you p {
            color: #7f8c8d;
            font-size: 16px;
        }

        .error-message {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .success-message {
            color: #27ae60;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        @media (max-width: 600px) {
            .registration-container {
                margin: 10px;
                padding: 25px;
            }
            
            .header h1 {
                font-size: 24px;
            }
            
            .register-btn {
                padding: 15px;
                font-size: 16px;
            }
        }
    </style>
</head>
<body>
    <div class="registration-container">
        <div class="header">
            <h1>DevOps Learning Registration</h1>
            <p>Please fill in this form to create an account</p>
        </div>
        
        <hr class="divider">

        <!-- Display Error/Success Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ${success}
            </div>
        </c:if>

        <form id="registrationForm" action="register" method="POST" novalidate>
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" placeholder="Enter your full name" name="fullName" id="fullName" 
                       value="${param.fullName}" required>
                <div class="error-message" id="nameError">Please enter your full name</div>
            </div>

            <div class="form-group">
                <label for="mobile">Mobile Number</label>
                <input type="tel" placeholder="Enter your mobile number" name="mobile" id="mobile" 
                       value="${param.mobile}" required>
                <div class="error-message" id="mobileError">Please enter a valid mobile number</div>
                <div class="success-message" id="mobileSuccess">Mobile number looks good!</div>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" placeholder="Enter your email address" name="email" id="email" 
                       value="${param.email}" required>
                <div class="error-message" id="emailError">Please enter a valid email address</div>
                <div class="success-message" id="emailSuccess">Email format is valid!</div>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" placeholder="Create a strong password" name="password" id="password" required>
                <div class="password-strength">
                    <div class="strength-bar">
                        <div class="strength-fill" id="strengthFill"></div>
                    </div>
                    <div id="strengthText">Password strength: None</div>
                </div>
                <div class="error-message" id="passwordError">Password must be at least 8 characters</div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" placeholder="Repeat your password" name="confirmPassword" id="confirmPassword" required>
                <div class="error-message" id="confirmError">Passwords do not match</div>
                <div class="success-message" id="confirmSuccess">Passwords match!</div>
            </div>

            <div class="terms-container">
                <p>By creating an account you agree to our <a href="#" target="_blank">Terms of Service</a> and <a href="#" target="_blank">Privacy Policy</a>.</p>
            </div>

            <button type="submit" class="register-btn">
                Create Account
            </button>
        </form>

        <div class="signin-container">
            <p>Already have an account? <a href="login">Sign in here</a></p>
        </div>

        <div class="thank-you">
            <h2>Thank You for Joining!</h2>
            <p>Happy Learning & See You Again!</p>
        </div>
    </div>

    <script>
        // Form validation and interactivity
        const form = document.getElementById('registrationForm');
        const inputs = form.querySelectorAll('input');

        // Real-time validation for each input
        inputs.forEach(input => {
            input.addEventListener('input', validateField);
            input.addEventListener('blur', validateField);
        });

        function validateField(e) {
            const field = e.target;
            const value = field.value.trim();
            
            switch(field.id) {
                case 'fullName':
                    validateName(field, value);
                    break;
                case 'mobile':
                    validateMobile(field, value);
                    break;
                case 'email':
                    validateEmail(field, value);
                    break;
                case 'password':
                    validatePassword(field, value);
                    break;
                case 'confirmPassword':
                    validateConfirmPassword(field, value);
                    break;
            }
        }

        function validateName(field, value) {
            const error = document.getElementById('nameError');
            if (value.length < 2) {
                showError(field, error, 'Please enter your full name (at least 2 characters)');
                return false;
            }
            hideError(field, error);
            return true;
        }

        function validateMobile(field, value) {
            const error = document.getElementById('mobileError');
            const success = document.getElementById('mobileSuccess');
            const mobilePattern = /^[+]?[\d\s\-\(\)]{10,15}$/;
            
            if (!mobilePattern.test(value)) {
                showError(field, error, 'Please enter a valid mobile number');
                hideSuccess(success);
                return false;
            }
            hideError(field, error);
            showSuccess(success);
            return true;
        }

        function validateEmail(field, value) {
            const error = document.getElementById('emailError');
            const success = document.getElementById('emailSuccess');
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            
            if (!emailPattern.test(value)) {
                showError(field, error, 'Please enter a valid email address');
                hideSuccess(success);
                return false;
            }
            hideError(field, error);
            showSuccess(success);
            return true;
        }

        function validatePassword(field, value) {
            const error = document.getElementById('passwordError');
            const strengthFill = document.getElementById('strengthFill');
            const strengthText = document.getElementById('strengthText');
            
            if (value.length < 8) {
                showError(field, error, 'Password must be at least 8 characters long');
                updatePasswordStrength(0, 'None');
                return false;
            }
            
            hideError(field, error);
            
            // Calculate password strength
            let strength = 0;
            let strengthLabel = 'Weak';
            
            if (value.length >= 8) strength += 25;
            if (/[a-z]/.test(value)) strength += 25;
            if (/[A-Z]/.test(value)) strength += 25;
            if (/[0-9]/.test(value)) strength += 15;
            if (/[^A-Za-z0-9]/.test(value)) strength += 10;
            
            if (strength >= 85) strengthLabel = 'Very Strong';
            else if (strength >= 70) strengthLabel = 'Strong';
            else if (strength >= 50) strengthLabel = 'Good';
            else if (strength >= 25) strengthLabel = 'Fair';
            
            updatePasswordStrength(strength, strengthLabel);
            return true;
        }

        function validateConfirmPassword(field, value) {
            const password = document.getElementById('password').value;
            const error = document.getElementById('confirmError');
            const success = document.getElementById('confirmSuccess');
            
            if (value !== password) {
                showError(field, error, 'Passwords do not match');
                hideSuccess(success);
                return false;
            }
            hideError(field, error);
            showSuccess(success);
            return true;
        }

        function updatePasswordStrength(strength, label) {
            const strengthFill = document.getElementById('strengthFill');
            const strengthText = document.getElementById('strengthText');
            
            strengthFill.style.width = strength + '%';
            strengthText.textContent = `Password strength: ${label}`;
            
            // Color coding
            if (strength >= 70) {
                strengthFill.style.background = '#27ae60';
            } else if (strength >= 50) {
                strengthFill.style.background = '#f39c12';
            } else if (strength >= 25) {
                strengthFill.style.background = '#e67e22';
            } else {
                strengthFill.style.background = '#e74c3c';
            }
        }

        function showError(field, errorElement, message) {
            field.style.borderColor = '#e74c3c';
            errorElement.textContent = message;
            errorElement.style.display = 'block';
        }

        function hideError(field, errorElement) {
            field.style.borderColor = '#27ae60';
            errorElement.style.display = 'none';
        }

        function showSuccess(successElement) {
            successElement.style.display = 'block';
        }

        function hideSuccess(successElement) {
            successElement.style.display = 'none';
        }

        // Form submission validation
        form.addEventListener('submit', function(e) {
            // Let the form submit to the server for processing
            // Server-side validation will handle the rest
        });
    </script>
</body>
</html>