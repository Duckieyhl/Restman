
<%@page import="java.util.*"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="model.Combo"%>
<%@page import="model.ComboDetail"%>
<%@page import="model.Dish"%>
<%@page import="model.Category"%>
<%@page import="dao.ComboDao"%>
<%@page import="dao.DishDao"%>
<%@page import="dao.CategoryDao"%>

<%
    request.setCharacterEncoding("UTF-8");

    DishDao dishDao = new DishDao();
    CategoryDao categoryDao = new CategoryDao();

    String message = "";
    String messageType = "";

    // Process create combo
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            String comboName = request.getParameter("comboName");
            String priceText = request.getParameter("price");
            String description = request.getParameter("description");

            String[] dishIds = request.getParameterValues("dishId");
            String[] quantities = request.getParameterValues("quantity");

            if (comboName == null || comboName.trim().isEmpty()
                    || priceText == null || priceText.trim().isEmpty()) {
                throw new Exception("Please enter combo name and price.");
            }

            BigDecimal price = new BigDecimal(priceText);

            if (price.compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception("Price must be greater than zero.");
            }

            if (dishIds == null || quantities == null || dishIds.length == 0
                    || dishIds.length != quantities.length) {
                throw new Exception("Please add at least one dish to the combo.");
            }

            List<ComboDetail> details = new ArrayList<>();

            for (int i = 0; i < dishIds.length; i++) {
                Dish dish = dishDao.getDishDetails(dishIds[i]);

                if (dish == null) {
                    throw new Exception("A selected dish does not exist.");
                }

                int quantity = Integer.parseInt(quantities[i]);

                if (quantity <= 0) {
                    throw new Exception("Dish quantity must be greater than zero.");
                }

                ComboDetail detail = new ComboDetail();
                detail.setComboDetailId(UUID.randomUUID().toString());
                detail.setDish(dish);
                detail.setQuantity(quantity);

                details.add(detail);
            }

            Combo combo = new Combo();
            combo.setComboId(UUID.randomUUID().toString());
            combo.setComboName(comboName.trim());
            combo.setPrice(price);
            combo.setDescription(description);
            combo.setComboDetails(details);

            ComboDao comboDao = new ComboDao();

            if (comboDao.createCombo(combo)) {
                message = "Combo created successfully!";
                messageType = "success";
            } else {
                message = "Failed to create combo.";
                messageType = "error";
            }

        } catch (Exception e) {
            message = e.getMessage();
            messageType = "error";
        }
    }

    // Search dishes
    String dishName = request.getParameter("dishName");
    String categoryId = request.getParameter("categoryId");

    if (dishName == null) dishName = "";
    if (categoryId == null) categoryId = "";

    List<Category> categories = categoryDao.getAllCategories();
    List<Dish> dishes = dishDao.searchDishes(dishName, categoryId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Combo - RestMan</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 30px;
        }

        .container {
            max-width: 1100px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        h1, h2 {
            color: #333;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        textarea {
            resize: vertical;
            min-height: 80px;
        }

        .search-form {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-form input,
        .search-form select {
            flex: 1;
        }

        button {
            padding: 9px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            color: white;
        }

        .search-button {
            background: #3498db;
        }

        .add-button {
            background: #27ae60;
        }

        .remove-button {
            background: #e74c3c;
        }

        .create-button {
            background: #2980b9;
            padding: 12px 22px;
            font-size: 16px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0 25px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }

        th {
            background: #f0f0f0;
        }

        .quantity-input {
            width: 80px !important;
        }

        .message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        .success {
            background: #d4edda;
            color: #155724;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
        }

        .section {
            margin-top: 30px;
        }

        .empty {
            text-align: center;
            color: #777;
            padding: 20px;
        }
    </style>
</head>

<body>

<div class="container">

    <h1>Create Combo</h1>

    <% if (!message.isEmpty()) { %>
        <div class="message <%= messageType %>">
            <%= message %>
        </div>
    <% } %>

    <form method="POST" action="createComboView6.jsp"
          onsubmit="return validateCombo();">

        <div class="form-group">
            <label>Combo Name</label>
            <input type="text" name="comboName"
                   placeholder="Enter combo name" required>
        </div>

        <div class="form-group">
            <label>Price (VND)</label>
            <input type="number" name="price"
                   min="1" step="0.01"
                   placeholder="Enter combo price" required>
        </div>

        <div class="form-group">
            <label>Description</label>
            <textarea name="description"
                      placeholder="Enter combo description"></textarea>
        </div>

        <div class="section">
            <h2>Search Dishes</h2>

            <div class="search-form">
                <input type="text" id="dishName"
                       placeholder="Enter dish name"
                       value="<%= dishName %>">

                <select id="categoryId">
                    <option value="">All Categories</option>

                    <% for (Category category : categories) { %>
                        <option value="<%= category.getCategoryId() %>"
                            <%= category.getCategoryId().equals(categoryId)
                                ? "selected" : "" %>>
                            <%= category.getCategoryName() %>
                        </option>
                    <% } %>
                </select>

                <button type="button" class="search-button"
                        onclick="searchDishes()">
                    Search
                </button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Dish Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <% if (dishes.isEmpty()) { %>
                        <tr>
                            <td colspan="4" class="empty">
                                No dishes found!
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Dish dish : dishes) { %>
                            <tr>
                                <td><%= dish.getDishName() %></td>

                                <td>
                                    <%= dish.getCategory() != null
                                        ? dish.getCategory().getCategoryName()
                                        : "N/A" %>
                                </td>

                                <td><%= dish.getPrice() %> VND</td>

                                <td>
                                    <button type="button"
                                            class="add-button"
                                            onclick="addDish(
                                                '<%= dish.getDishId() %>',
                                                '<%= dish.getDishName() %>',
                                                '<%= dish.getPrice() %>'
                                            )">
                                        Add
                                    </button>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="section">
            <h2>Selected Dishes</h2>

            <table id="selectedTable">
                <thead>
                    <tr>
                        <th>Dish Name</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody id="selectedDishes">
                    <tr id="emptyRow">
                        <td colspan="4" class="empty">
                            No dishes selected.
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <button type="submit" class="create-button">
            Create Combo
        </button>

    </form>

</div>

<script>
    function searchDishes() {
        const name = document.getElementById("dishName").value;
        const category = document.getElementById("categoryId").value;

        const url = new URL(window.location.href);

        url.searchParams.set("dishName", name);
        url.searchParams.set("categoryId", category);

        window.location.href = url.toString();
    }

    function addDish(id, name, price) {
        const tbody = document.getElementById("selectedDishes");

        // Prevent duplicate dishes
        if (document.getElementById("dish-" + id)) {
            alert("This dish has already been added.");
            return;
        }

        const emptyRow = document.getElementById("emptyRow");

        if (emptyRow) {
            emptyRow.remove();
        }

        const row = document.createElement("tr");
        row.id = "dish-" + id;

        const nameCell = document.createElement("td");
        nameCell.textContent = name;

        const priceCell = document.createElement("td");
        priceCell.textContent = price + " VND";

        const quantityCell = document.createElement("td");

        const quantityInput = document.createElement("input");
        quantityInput.type = "number";
        quantityInput.name = "quantity";
        quantityInput.value = "1";
        quantityInput.min = "1";
        quantityInput.required = true;
        quantityInput.className = "quantity-input";

        const dishInput = document.createElement("input");
        dishInput.type = "hidden";
        dishInput.name = "dishId";
        dishInput.value = id;

        quantityCell.appendChild(dishInput);
        quantityCell.appendChild(quantityInput);

        const actionCell = document.createElement("td");

        const removeButton = document.createElement("button");
        removeButton.type = "button";
        removeButton.className = "remove-button";
        removeButton.textContent = "Remove";

        removeButton.onclick = function() {
            row.remove();

            if (tbody.children.length === 0) {
                const empty = document.createElement("tr");
                empty.id = "emptyRow";

                const cell = document.createElement("td");
                cell.colSpan = 4;
                cell.className = "empty";
                cell.textContent = "No dishes selected.";

                empty.appendChild(cell);
                tbody.appendChild(empty);
            }
        };

        actionCell.appendChild(removeButton);

        row.appendChild(nameCell);
        row.appendChild(priceCell);
        row.appendChild(quantityCell);
        row.appendChild(actionCell);

        tbody.appendChild(row);
    }

    function validateCombo() {
        const rows = document.querySelectorAll(
            "#selectedDishes tr:not(#emptyRow)"
        );

        if (rows.length === 0) {
            alert("Please add at least one dish to the combo.");
            return false;
        }

        return confirm("Are you sure you want to create this combo?");
    }
</script>

</body>
</html>
