
package dao;

import java.util.List;
import model.Category;
import model.Dish;

public class TestDao {

    public static void main(String[] args) {

//         Test CategoryDao
        System.out.println("========== TEST CATEGORY DAO ==========");

        CategoryDao categoryDao = new CategoryDao();
        List<Category> categories = categoryDao.getAllCategories();

        if (categories.isEmpty()) {
            System.out.println("No categories found!");
        } else {
            for (Category category : categories) {
                System.out.println(
                        category.getCategoryId() + " | "
                        + category.getCategoryName()
                );
            }
        }

        // Test DishDao - Search all dishes
        System.out.println("\n========== TEST SEARCH DISHES ==========");

        DishDao dishDao = new DishDao();

        try {
            List<Dish> dishes = dishDao.searchDishes("", "");

            if (dishes.isEmpty()) {
                System.out.println("No dishes found!");
            } else {
                for (Dish dish : dishes) {
                    String categoryName = dish.getCategory() != null
                            ? dish.getCategory().getCategoryName()
                            : "No category";

                    System.out.println(
                            dish.getDishId() + " | "
                            + dish.getDishName() + " | "
                            + dish.getPrice() + " | "
                            + categoryName
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Test DishDao - Get dish details
        System.out.println("\n========== TEST DISH DETAILS ==========");

        try {
            Dish dish = dishDao.getDishDetails("D01");

            if (dish == null) {
                System.out.println("Dish not found!");
            } else {
                System.out.println("Dish ID: " + dish.getDishId());
                System.out.println("Dish Name: " + dish.getDishName());
                System.out.println("Price: " + dish.getPrice());
                System.out.println("Image: " + dish.getImage());
                System.out.println("Description: " + dish.getDescription());

                if (dish.getCategory() != null) {
                    System.out.println(
                            "Category: "
                            + dish.getCategory().getCategoryName()
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
