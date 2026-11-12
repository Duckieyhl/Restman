/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class ComboDetail {
    private String comboDetailId;
    private Combo combo;
    private Dish dish;
    private Integer quantity;

    public ComboDetail() {
    }

    public ComboDetail(String comboDetailId, Combo combo,
                       Dish dish, Integer quantity) {
        this.comboDetailId = comboDetailId;
        this.combo = combo;
        this.dish = dish;
        this.quantity = quantity;
    }

    public String getComboDetailId() {
        return comboDetailId;
    }

    public void setComboDetailId(String comboDetailId) {
        this.comboDetailId = comboDetailId;
    }

    public Combo getCombo() {
        return combo;
    }

    public void setCombo(Combo combo) {
        this.combo = combo;
    }

    public Dish getDish() {
        return dish;
    }

    public void setDish(Dish dish) {
        this.dish = dish;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
