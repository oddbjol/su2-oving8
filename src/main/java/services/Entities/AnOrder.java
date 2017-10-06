package services.Entities;

import com.mysql.jdbc.Statement;
import services.DB.DB;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by KimRostgard on 25.09.2017.
 */
public class AnOrder implements Serializable{
    private int id;
    private Integer customer_id;
    private String customer_name;
    private int table_number;
    private Timestamp from_time;
    private Timestamp to_time;
    private int num_guests;

    public AnOrder(){
    }

    public AnOrder(int id, int customer_id, String customer_name, int table_number, Timestamp from_time, Timestamp to_time, int num_guests) {
        this.id = id;
        this.customer_id = customer_id;
        this.customer_name = customer_name;
        this.table_number = table_number;
        this.from_time = from_time;
        this.to_time = to_time;
        this.num_guests = num_guests;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getTable_number() {
        return table_number;
    }

    public void setTable_number(int table_number) {
        this.table_number = table_number;
    }

    public Timestamp getFrom_time() {
        return from_time;
    }

    public void setFrom_time(Timestamp from_time) {
        this.from_time = from_time;
    }

    public Timestamp getTo_time() {
        return to_time;
    }

    public void setTo_time(Timestamp to_time) {
        this.to_time = to_time;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getNum_guests() {
        return num_guests;
    }

    public void setNum_guests(int num_guests) {
        this.num_guests = num_guests;
    }

    public String getCustomer_name() {
        return customer_name;
    }

    public void setCustomer_name(String customer_name) {
        this.customer_name = customer_name;
    }

    /**
     * Retrieves all orders from the database.
     *
     * @return
     */

    public static ArrayList<AnOrder> getAll(){
        ArrayList<AnOrder> out = new ArrayList<>();

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("SELECT * FROM AnOrder");

                db.res = db.prep.executeQuery();

                while(db.res.next())
                    out.add(processRow(db.res));
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            finally{
                db.close();
            }
        }

        return out;
    }


    /**
     * Puts a new order into the system, including ordered dishes. Doesn't check if table is free etc. TODO: Error handling.
     *
     * @param order
     * @param dishes A map between dish_id numbers and the amount of the given dish.
     *               Keeps track of how many of each dish there are in an order.
     *               See class FullOrder for more info about how this HashMap works.
     * @return
     */

    public static boolean registerOrder(AnOrder order, HashMap<Integer, Integer> dishes){
        boolean success = false;

        DB db = new DB();

        if(db.setUp()){
            try{
                // Use a transaction, since we're performing several queries in one go.
                db.connection.setAutoCommit(false);

                // Make a PreparedStatement, ready to be run on server.
                db.prep = db.connection.prepareStatement("INSERT INTO AnOrder (table_number, customer_id, customer_name, num_guests, from_time, to_time) VALUES (?,?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);

                // Fill in the right table number in the first '?' sign in query text.
                db.prep.setInt(1, order.table_number);

                // Only fill in customer id if the order has one. If not, just leave it blank.
                // This is so that customers have the option not to register as customers. In this case, we just
                // register the customer's name directly onto the order.
                if(order.customer_id != null)
                    db.prep.setInt(2, order.customer_id);
                else
                    db.prep.setNull(2, Types.INTEGER);

                db.prep.setString(3, order.customer_name);
                db.prep.setInt(4, order.num_guests);
                db.prep.setTimestamp(5, order.from_time);
                db.prep.setTimestamp(6, order.to_time);

                // executeUpdate() returns number of rows altered. If this is 0, it means nothing actually happened.
                success = (db.prep.executeUpdate() > 0);

                // Retrieve the order id that was generated for this order.
                db.res = db.prep.getGeneratedKeys();

                int new_order_id = -1;

                // Actually "unpack" the order ID from the result and store it.
                if(db.res.next())
                    new_order_id = db.res.getInt(1);

                // Prepare statement for inserting dishes for this order.
                db.prep = db.connection.prepareStatement("INSERT INTO Order_Dish (order_id, dish_id, amount) VALUES (?,?,?)");

                // Insert one dish (with amount) for each entry in order.dishes
                for(Map.Entry<Integer, Integer> entry : dishes.entrySet()){
                    db.prep.setInt(1, new_order_id);
                    db.prep.setInt(2, entry.getKey());
                    db.prep.setInt(3, entry.getValue());

                    // Add the three parameters into the statement as a "batch", ready to be run later.
                    db.prep.addBatch();
                }
                // Run all the batches that we built up in the for loop, in one go.
                db.prep.executeBatch();
            }
            catch(SQLException e){
                // If something goes wrong, just print the stack trace
                e.printStackTrace();
            }
            finally{
                // Whether we failed or not, we have to close the connection against the database.
                // Needs to be done every time we work against DB, as last step.
                db.close();
            }
        }

        return success;
    }



    //Processes information fetched from database and creates a similar object.
    public static AnOrder processRow(ResultSet res) throws SQLException {

        int id = res.getInt("AnOrder.id");
        int customerID = res.getInt("AnOrder.customer_id");
        String customer_name = res.getString("AnOrder.customer_name");
        int tableNumber = res.getInt("AnOrder.table_number");
        Timestamp from_time = res.getTimestamp("AnOrder.from_time");
        Timestamp to_time = res.getTimestamp("AnOrder.to_time");
        int num_guests = res.getInt("AnOrder.num_guests");

        return new AnOrder(id, customerID, customer_name, tableNumber, from_time, to_time, num_guests);
    }
}
