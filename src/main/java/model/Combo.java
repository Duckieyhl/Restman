/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.List;

public class Combo {
    private String comboId;
    private String comboName;
    private BigDecimal price;
    private String description;
    private List<ComboDetail> comboDetails;

    public Combo() {
    }

    public Combo(String comboId, String comboName, BigDecimal price,
                 String description, List<ComboDetail> comboDetails) {
        this.comboId = comboId;
        this.comboName = comboName;
        this.price = price;
        this.description = description;
        this.comboDetails = comboDetails;
    }

    public String getComboId() {
        return comboId;
    }

    public void setComboId(String comboId) {
        this.comboId = comboId;
    }

    public String getComboName() {
        return comboName;
    }

    public void setComboName(String comboName) {
        this.comboName = comboName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<ComboDetail> getComboDetails() {
        return comboDetails;
    }

    public void setComboDetails(List<ComboDetail> comboDetails) {
        this.comboDetails = comboDetails;
    }
}