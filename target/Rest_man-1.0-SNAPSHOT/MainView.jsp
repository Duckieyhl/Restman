<%@page import="model.User"%>
<%@page import="dao.UserDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User user = (User) session.getAttribute("user");

    boolean isManager = false;

    if (user != null) {
        UserDao userDao = new UserDao();
        isManager = userDao.isManager(user.getUserId());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>RestMan - Home</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }

        .header {
            background-color: #8B4513;
            color: white;
            padding: 20px;
            text-align: center;
        }

        .container {
            width: 80%;
            margin: 50px auto;
            text-align: center;
        }

        .welcome {
            margin-bottom: 30px;
            font-size: 20px;
        }

        .menu a {
            display: inline-block;
            margin: 10px;
            padding: 15px 30px;
            background-color: #8B4513;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        .menu a:hover {
            background-color: #A0522D;
        }
    </style>
</head>

<body>

    <div class="header">
        <h1>RestMan Restaurant Management System</h1>
    </div>

    <div class="container">

        <% if (user == null) { %>

            <div class="welcome">
                <h2>Welcome to RestMan!</h2>
            </div>

        <% } else { %>

            <div class="welcome">
                <h2>Welcome, <%= user.getFullName() %>!</h2>
            </div>

        <% } %>

        <div class="menu">

            <a href="<%=request.getContextPath()%>/Public/searchDishView6.jsp">
                Search Dish
            </a>

            <% if (user == null) { %>

                <a href="<%=request.getContextPath()%>/Login/loginView.jsp">
                    Login
                </a>

            <% } else { %>

                <% if (isManager) { %>

                    <a href="<%=request.getContextPath()%>/Manager/createComboView6.jsp">
                        Create Combo
                    </a>

                <% } %>

                <a href="<%=request.getContextPath()%>/Logout.jsp">
                    Logout
                </a>

            <% } %>

        </div>

    </div>

</body>
</html>