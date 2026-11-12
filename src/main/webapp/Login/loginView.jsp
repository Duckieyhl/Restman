
<%@page import="dao.UserDao"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDao userDao = new UserDao();
        User user = userDao.login(username, password);

        if (user != null) {

            session.setAttribute("user", user);

            response.sendRedirect(
                request.getContextPath() + "/MainView.jsp"
            );
            return;

        } else {
            request.setAttribute(
                "error",
                "Invalid username or password!"
            );
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>RestMan - Login</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background-color: white;
            width: 380px;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #8B4513;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        input:focus {
            outline: none;
            border-color: #8B4513;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #8B4513;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            background-color: #6F3610;
        }

        .error {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }

        .back {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #8B4513;
            text-decoration: none;
        }
    </style>
</head>

<body>

    <div class="login-container">

        <h2>RestMan Login</h2>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form method="POST"
              action="<%=request.getContextPath()%>/Login/loginView.jsp">

            <div class="form-group">
                <label>Username</label>
                <input type="text"
                       name="username"
                       placeholder="Enter username"
                       required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password"
                       name="password"
                       placeholder="Enter password"
                       required>
            </div>

            <button type="submit">Login</button>

        </form>

        <a class="back"
           href="<%=request.getContextPath()%>/MainView.jsp">
            Back to Home
        </a>

    </div>

</body>
</html>
