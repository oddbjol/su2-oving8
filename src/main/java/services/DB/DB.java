package services.DB;

import org.apache.commons.dbutils.DbUtils;

import java.sql.*;

/**
 * Database wrapper.
 *
 * To write code that accesses the database,
 * just copy paste an existing method from one of the entity files
 * that already does the same kind of operation that you want to perform.
 *
 * For instance, if you want to retrieve all objects associated with a given table, have a look at
 * Dish.getAll() and its helper method Dish.processRow(ResultSet);
 *
 * If you want to write stuff into the database, have a look at FullOrder.registerOrder(FullOrder).
 */
public class DB {

    private Statement sentence;
    private DBConnection c;

    public ResultSet res;
    public PreparedStatement prep;
    public Connection connection;

    public boolean connected(){
        return sentence != null;
    }

    public boolean setUp(){
        try {

            c = new DBConnection();
            connection = c.getConnection();

            sentence = connection.createStatement();
        } catch (Exception e) {
            System.err.println("Connecting to database failed.");
            closeConnection();
            return false;
        }
        return !(connection == null || sentence == null);
    }
    public void closeConnection(){
        try {
            if(!sentence.isClosed() && sentence != null) DbUtils.closeQuietly(sentence);
            if(!connection.isClosed() && connection != null) DbUtils.closeQuietly(connection);
        }
        catch (Exception e){
            System.err.println("Problem with closing connection.");
        }
    }

    public void rollbackStatement() {
        try {
            if (!connection.getAutoCommit()) {
                connection.rollback();
                connection.setAutoCommit(true);
            }
        } catch (SQLException ee) {
            System.err.println("Rollback Statement failed");
        }
    }


    public void close() {
        try {
            if (!connection.getAutoCommit()) {
                connection.commit();
                connection.setAutoCommit(true);
            }
            if (res != null &&!res.isClosed()) res.close();
            if (prep != null && !prep.isClosed()) prep.close();
        } catch (SQLException sqle) {
            System.err.println("Finally Statement failed");
        }
        closeConnection();
    }

    public Statement getSentence() {
        return sentence;
    }

    public Connection getConnection() { return connection; }

}
