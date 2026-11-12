/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

import model.Combo;
import model.ComboDetail;
import model.Dish;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class ComboDao extends DAO {

    public ComboDao() {
        super();
    }

    // Create a combo with its details
    public boolean createCombo(Combo combo) throws SQLException {

        String comboSql = """
                INSERT INTO Combo
                    (comboId, comboName, price, description)
                VALUES (?, ?, ?, ?)
                """;

        String detailSql = """
                INSERT INTO ComboDetail
                    (comboDetailId, comboId, dishId, quantity)
                VALUES (?, ?, ?, ?)
                """;

        Connection conn = getConnection();

        boolean oldAutoCommit = conn.getAutoCommit();

        try {
            conn.setAutoCommit(false);

            // Insert Combo
            try (PreparedStatement ps =
                         conn.prepareStatement(comboSql)) {

                ps.setString(1, combo.getComboId());
                ps.setString(2, combo.getComboName());
                ps.setBigDecimal(3, combo.getPrice());
                ps.setString(4, combo.getDescription());

                ps.executeUpdate();
            }

            // Insert ComboDetails
            List<ComboDetail> details = combo.getComboDetails();

            try (PreparedStatement ps =
                         conn.prepareStatement(detailSql)) {

                for (ComboDetail detail : details) {

                    Dish dish = detail.getDish();

                    String detailId = detail.getComboDetailId();

                    if (detailId == null || detailId.isBlank()) {
                        detailId = UUID.randomUUID()
                                .toString()
                                .replace("-", "")
                                .substring(0, 20);
                    }

                    ps.setString(1, detailId);
                    ps.setString(2, combo.getComboId());
                    ps.setString(3, dish.getDishId());
                    ps.setInt(4, detail.getQuantity());

                    ps.addBatch();
                }

                ps.executeBatch();
            }

            conn.commit();

            return true;

        } catch (SQLException e) {

            conn.rollback();
            throw e;

        } finally {
            conn.setAutoCommit(oldAutoCommit);
        }
    }
}
