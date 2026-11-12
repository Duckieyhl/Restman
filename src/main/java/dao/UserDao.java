package dao;

import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDao extends DAO {

    public UserDao() {
        super();
    }

    // Check username and password
    public User login(String username, String password) {

        String sql = "SELECT * FROM `User` WHERE username = ? AND password = ?";

        try {
            Connection con = getConnection();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, username);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        User user = new User();

                        user.setUserId(rs.getString("userId"));
                        user.setUsername(rs.getString("username"));
                        user.setPassword(rs.getString("password"));
                        user.setFullName(rs.getString("fullName"));
                        user.setAddress(rs.getString("address"));
                        user.setDateOfBirth(rs.getDate("dateOfBirth"));
                        user.setEmail(rs.getString("email"));
                        user.setPhoneNumber(rs.getString("phoneNumber"));

                        return user;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Check whether the user is a Manager
    public boolean isManager(String userId) {

        String sql = "SELECT jobPosition FROM Staff WHERE userId = ?";

        try {
            Connection con = getConnection();

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        return "MANAGER".equalsIgnoreCase(
                                rs.getString("jobPosition")
                        );
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}