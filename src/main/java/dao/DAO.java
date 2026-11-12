
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DAO {

    public static Connection con;

    public DAO() {
        connect();
    }

    private synchronized void connect() {
        try {
            if (con == null || con.isClosed()) {

                String dbUrl = "jdbc:mysql://localhost:3306/restman"
                        + "?useUnicode=true"
                        + "&characterEncoding=UTF-8"
                        + "&useSSL=false"
                        + "&allowPublicKeyRetrieval=true";

                String dbClass = "com.mysql.cj.jdbc.Driver";

                Class.forName(dbClass);

                con = DriverManager.getConnection(
                        dbUrl,
                        "root",
                        "anhduc1809"
                );

                System.out.println("DATABASE CONNECTION SUCCESS!");

            }
        } catch (Exception e) {
            System.err.println("DATABASE CONNECTION FAILED!");
            e.printStackTrace();
        }
    }

    protected Connection getConnection() throws SQLException {
        if (con == null || con.isClosed()) {
            connect();
        }

        if (con == null) {
            throw new SQLException("Cannot connect to database!");
        }

        return con;
    }

    public static void main(String[] args) {
        new DAO();
    }
}
