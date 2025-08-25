<%-- Place this in: webapp/src/main/webapp/welcome.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - DevOps Learning Platform</title>
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

        .welcome-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 60px 40px;
            max-width: 600px;
            width: 100%;
            text-align: center;
            animation: fadeIn 0.8s ease-out;
            position: relative;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .celebration-emoji {
            font-size: 80px;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-30px);
            }
            60% {
                transform: translateY(-15px);
            }
        }

        .hello-world {
            font-size: 48px;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 20px;
            animation: slideUp 0.6s ease-out 0.3s both;
        }

        .welcome-message {
            font-size: 24px;
            color: #2c3e50;
            margin-bottom: 15px;
            font-weight: 500;
            animation: slideUp 0.6s ease-out 0.5s both;
        }

        .user-info {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 20px;
            margin: 30px 0;
            border-radius: 10px;
            animation: slideUp 0.6s ease-out 0.7s both;
        }

        .user-info h3 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 18px;
        }

        .user-info p {
            color: #5a6c7d;
            font-size: 16px;
            margin: 5px 0;
        }

        .success-message {
            color: #27ae60;
            font-size: 18px;
            margin-bottom: 30px;
            font-weight: 500;
            animation: slideUp 0.6s ease-out 0.9s both;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 30px;
            animation: slideUp 0.6s ease-out 1.1s both;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-secondary {
            background: transparent;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-primary:hover {
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .logout-container {
            position: absolute;
            top: 20px;
            right: 20px;
        }

        .logout-btn {
            background: transparent;
            border: 1px solid #e74c3c;
            color: #e74c3c;
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: #e74c3c;
            color: white;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin: 30px 0;
            animation: slideUp 0.6s ease-out 1.3s both;
        }

        .feature-card {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            padding: 20px;
            border-radius: 10px;
            border: 1px solid rgba(102, 126, 234, 0.2);
        }

        .feature-card h4 {
            color: #2c3e50;
            font-size: 14px;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .feature-card p {
            color: #5a6c7d;
            font-size: 12px;
        }

        @media (max-width: 600px) {
            .welcome-container {
                padding: 40px 25px;
                margin: 10px;
            }
            
            .hello-world {
                font-size: 36px;
            }
            
            .welcome-message {
                font-size: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 250px;
            }
            
            .logout-container {
                position: static;
                text-align: center;
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <div class="logout-container">
            <form action="logout" method="POST" style="display: inline;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>

        <div class="celebration-emoji">🎉</div>
        
        <h1 class="hello-world">Hello World!</h1>
        
        <h2 class="welcome-message">
            Welcome to DevOps Learning Platform
        </h2>
        
        <p class="success-message">
            ✅ Login Successful! You're now logged in.
        </p>

        <div class="user-info">
            <h3>Your Account Information</h3>
            <p><strong>Name:</strong> ${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'User'}</p>
            <p><strong>Email:</strong> ${sessionScope.user.email != null ? sessionScope.user.email : 'user@example.com'}</p>
            <p><strong>Login Time:</strong> <span id="loginTime"></span></p>
        </div>

        <div class="features-grid">
            <div class="feature-card">
                <h4>🚀 Docker</h4>
                <p>Learn containerization</p>
            </div>
            <div class="feature-card">
                <h4>☸️ Kubernetes</h4>
                <p>Master orchestration</p>
            </div>
            <div class="feature-card">
                <h4>🔧 Jenkins</h4>
                <p>CI/CD pipelines</p>
            </div>
            <div class="feature-card">
                <h4>☁️ AWS</h4>
                <p>Cloud computing</p>
            </div>
        </div>

        <div class="action-buttons">
            <a href="dashboard" class="btn btn-primary">Go to Dashboard</a>
            <a href="profile" class="btn btn-secondary">View Profile</a>
        </div>
    </div>

    <script>
        // Display current login time
        document.getElementById('loginTime').textContent = new Date().toLocaleString();

        // Add some interactive effects
        document.querySelectorAll('.feature-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px) scale(1.02)';
                this.style.boxShadow = '0 10px 25px rgba(102, 126, 234, 0.2)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
                this.style.boxShadow = 'none';
            });
        });

        // Optional: Auto-logout after inactivity (30 minutes)
        let inactivityTimer;
        const inactivityTime = 30 * 60 * 1000; // 30 minutes

        function resetInactivityTimer() {
            clearTimeout(inactivityTimer);
            inactivityTimer = setTimeout(() => {
                if (confirm('You have been inactive for 30 minutes. Would you like to stay logged in?')) {
                    resetInactivityTimer();
                } else {
                    window.location.href = 'logout';
                }
            }, inactivityTime);
        }

        // Reset timer on user activity
        ['mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart'].forEach(event => {
            document.addEventListener(event, resetInactivityTimer, true);
        });

        // Initialize timer
        resetInactivityTimer();
    </script>
</body>
</html>