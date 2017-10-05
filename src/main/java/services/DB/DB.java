package services.DB;

import org.apache.commons.dbutils.DbUtils;

import java.sql.*;

/**
 * @author Mr.Easter
 */

//Database management wrapper. Used by all objectDAO classes.
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
