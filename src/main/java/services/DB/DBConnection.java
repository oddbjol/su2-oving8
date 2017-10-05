package services.DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * @author Mr.Easter
 */

//Basic database connection information.
public class DBConnection {
    private String databasedriver = "com.mysql.jdbc.Driver";
    private String username = "oddbjool";
    private String password = "kYVZd1cK";
    private String databasename = "jdbc:mysql://mysql.stud.iie.ntnu.no/oddbjool?serverTimezone=Europe/Oslo&useSSL=false";
    private Connection connection = null;

    //Constructor creates connection.
    public DBConnection() {
        try {
            Class.forName(databasedriver);
            connection = DriverManager.getConnection(databasename,username,password);
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            System.err.println("Issue with database driver.");
        } catch (SQLException SQLe) {
            System.err.println("Issue with connecting to database.");
            SQLe.printStackTrace();
        }
    }

    /**
     * Gets the current connection
     * @return The current database connection
     */
    public Connection getConnection(){
        return connection;
    }
}
