
package dao;

import model.Dish;
import model.Category;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DishDao extends DAO {

    public DishDao() {
        super();
    }

    // Search dishes by name and category
    public List<Dish> searchDishes(
            String dishName,
            String categoryId
    ) throws SQLException {

        List<Dish> dishes = new ArrayList<>();

        String sql = """
                SELECT d.*,
                       c.categoryId AS catId,
                       c.categoryName
                FROM Dish d
                LEFT JOIN Category c
                    ON d.categoryId = c.categoryId
                WHERE d.dishName LIKE ?
                  AND (? = '' OR d.categoryId = ?)
                """;

        Connection conn = getConnection();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + (dishName == null ? "" : dishName) + "%");
            ps.setString(2, categoryId == null ? "" : categoryId);
            ps.setString(3, categoryId == null ? "" : categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    dishes.add(mapDish(rs));
                }
            }
        }

        return dishes;
    }

    // Get dish details by ID
    public Dish getDishDetails(String dishId) throws SQLException {

        String sql = """
                SELECT d.*,
                       c.categoryId AS catId,
                       c.categoryName
                FROM Dish d
                LEFT JOIN Category c
                    ON d.categoryId = c.categoryId
                WHERE d.dishId = ?
                """;

        Connection conn = getConnection();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dishId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapDish(rs);
                }
            }
        }

        return null;
    }

    // Convert ResultSet to Dish object
    private Dish mapDish(ResultSet rs) throws SQLException {

        Dish dish = new Dish();

        dish.setDishId(rs.getString("dishId"));
        dish.setDishName(rs.getString("dishName"));
        dish.setPrice(rs.getBigDecimal("price"));
        dish.setImage(rs.getString("image"));
        dish.setDescription(rs.getString("description"));

        String categoryId = rs.getString("catId");

        if (categoryId != null) {

            Category category = new Category();

            category.setCategoryId(categoryId);
            category.setCategoryName(rs.getString("categoryName"));

            dish.setCategory(category);
        }

        return dish;
    }
}
