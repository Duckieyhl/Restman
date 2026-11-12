
<%@page import="java.util.List"%>
<%@page import="model.Dish"%>
<%@page import="model.Category"%>
<%@page import="dao.DishDao"%>
<%@page import="dao.CategoryDao"%>

<%
    request.setCharacterEncoding("UTF-8");

    String dishName = request.getParameter("dishName");
    String categoryId = request.getParameter("categoryId");

    if (dishName == null) {
        dishName = "";
    }

    if (categoryId == null) {
        categoryId = "";
    }

    CategoryDao categoryDao = new CategoryDao();
    DishDao dishDao = new DishDao();

    List<Category> categories = categoryDao.getAllCategories();
    List<Dish> dishes = dishDao.searchDishes(dishName, categoryId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search for Dishes - RestMan</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background-color: #f5f5f5;
        }

        h1 {
            text-align: center;
        }

        .search-form {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin: 25px 0;
        }

        input, select, button {
            padding: 10px;
            font-size: 15px;
        }

        button {
            cursor: pointer;
        }

        .dish-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
        }

        .dish-card {
            background: white;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 2px 5px #ccc;
        }

        .dish-card img {
            width: 100%;
            height: 160px;
            object-fit: cover;
            border-radius: 6px;
        }

        .dish-card a {
            display: inline-block;
            margin-top: 10px;
            text-decoration: none;
            color: white;
            background: #007bff;
            padding: 8px 15px;
            border-radius: 5px;
        }

        .no-results {
            text-align: center;
            grid-column: 1 / -1;
        }
    </style>
</head>

<body>

    <h1>Search for Dishes</h1>

    <form method="GET" action="searchDishView6.jsp" class="search-form">

        <input
            type="text"
            name="dishName"
            placeholder="Enter dish name"
            value="<%= dishName %>"
        >

        <select name="categoryId">
            <option value="">All Categories</option>

            <% for (Category category : categories) { %>
                <option
                    value="<%= category.getCategoryId() %>"
                    <%= category.getCategoryId().equals(categoryId)
                            ? "selected" : "" %>
                >
                    <%= category.getCategoryName() %>
                </option>
            <% } %>

        </select>

        <button type="submit">Search</button>

    </form>

    <div class="dish-list">

        <% if (dishes.isEmpty()) { %>

            <div class="no-results">
                <h3>No dishes found!</h3>
            </div>

        <% } else { %>

            <% for (Dish dish : dishes) { %>

                <div class="dish-card">

                    <img
                        src="<%= request.getContextPath() + "/" + dish.getImage() %>"
                        alt="<%= dish.getDishName() %>"
                    >

                    <h3><%= dish.getDishName() %></h3>

                    <p>Price: <%= dish.getPrice() %> VND</p>

                    <a href="dishDetailsView6.jsp?dishId=<%= dish.getDishId() %>">
                        View Details
                    </a>

                </div>

            <% } %>

        <% } %>

    </div>

</body>
</html>
