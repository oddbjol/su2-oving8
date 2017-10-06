package services.Entities;

import com.mysql.jdbc.Statement;
import services.DB.DB;

import java.io.Serializable;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * A full order is an object that contains both the order (date, time, customer, guests, etc)
 * as well as the dishes that were ordered.
 * This is used to send order info from the frontend in one go.
 */

public class FullOrder implements Serializable{
    private int table_number;
    private Integer customer_id;
    private String customer_name;
    private Timestamp from_time;
    private Timestamp to_time;
    private int num_guests;
    private HashMap<Integer, Integer> dishes = new HashMap<>(); // Integer is amount of dish

    public FullOrder(){}

    public FullOrder(int table_number, Integer customer_id, String customer_name, Timestamp from_time, Timestamp to_time, int num_guests, HashMap<Integer, Integer> dishes) {
        this.table_number = table_number;
        this.customer_id = customer_id;
        this.customer_name = customer_name;
        this.from_time = from_time;
        this.to_time = to_time;
        this.num_guests = num_guests;
        this.dishes = dishes;
    }

    public int getTable_number() {
        return table_number;
    }

    public void setTable_number(int table_number) {
        this.table_number = table_number;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
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

    // Integer is amount of dish
    public HashMap<Integer, Integer> getDishes() {
        return dishes;
    }

    public void setDishes(HashMap<Integer, Integer> dishes) {
        this.dishes = dishes;
    }

    public int getNum_guests() {
        return num_guests;
    }

    public void setNum_guests(int num_guests) {
        this.num_guests = num_guests;
    }

    public void setCustomer_id(Integer customer_id) {
        this.customer_id = customer_id;
    }

    public String getCustomer_name() {
        return customer_name;
    }

    public void setCustomer_name(String customer_name) {
        this.customer_name = customer_name;
    }

    /**
     * Puts a new order into the system. Doesn't check if table is free etc. TODO: Error handling.
     * @param order
     * @return
     */

    public static boolean registerOrder(FullOrder order){
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
                for(Map.Entry<Integer, Integer> entry : order.dishes.entrySet()){
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
}
