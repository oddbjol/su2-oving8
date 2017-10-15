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

public class FullOrder implements Serializable{
    public int table_number;
    public Integer customer_id;
    public String customer_name;
    public Timestamp from_time;
    public Timestamp to_time;
    public int num_guests;
    public ArrayList<Dish_Order> dish_orders = new ArrayList<>();

    public FullOrder(){}

    public FullOrder(int table_number, Integer customer_id, String customer_name, Timestamp from_time, Timestamp to_time, int num_guests, ArrayList<Dish_Order> dish_orders) {
        this.table_number = table_number;
        this.customer_id = customer_id;
        this.customer_name = customer_name;
        this.from_time = from_time;
        this.to_time = to_time;
        this.num_guests = num_guests;
        this.dish_orders = dish_orders;
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

    public ArrayList<Dish_Order> getDish_orders() {
        return dish_orders;
    }

    public void setDish_orders(ArrayList<Dish_Order> dish_orders) {
        this.dish_orders = dish_orders;
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

    public static boolean registerOrder(FullOrder order){
        boolean success = false;

        DB db = new DB();

        if(db.setUp()){
            try{
                db.connection.setAutoCommit(false);

                db.prep = db.connection.prepareStatement("INSERT INTO AnOrder (table_number, customer_id, customer_name, num_guests, from_time, to_time) VALUES (?,?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);
                db.prep.setInt(1, order.table_number);
                
                if(order.customer_id != null)
                    db.prep.setInt(2, order.customer_id);
                else
                    db.prep.setNull(2, Types.INTEGER);

                db.prep.setString(3, order.customer_name);
                db.prep.setInt(4, order.num_guests);
                db.prep.setTimestamp(5, order.from_time);
                db.prep.setTimestamp(6, order.to_time);

                success = (db.prep.executeUpdate() > 0);

                db.res = db.prep.getGeneratedKeys();

                int new_order_id = -1;

                if(db.res.next())
                    new_order_id = db.res.getInt(1);

                db.prep = db.connection.prepareStatement("INSERT INTO Order_Dish (order_id, dish_id, amount, time, status) VALUES (?,?,?,?,?)");

                for(Dish_Order dish_order : order.dish_orders){
                    db.prep.setInt(1, new_order_id);
                    db.prep.setInt(2, dish_order.getDish_id());
                    db.prep.setInt(3, dish_order.getAmount());
                    db.prep.setString(4, dish_order.getServe_time());

                    int status;
                    if(dish_order.getDish_type() == Dish.DISH_TYPE_DRINK)
                        status = Dish_Order.STATUS_WAITING_FOR_WAITER;
                    else
                        status = Dish_Order.STATUS_WAITING_FOR_CHEF;

                    System.out.println(status);

                    db.prep.setInt(5, status);


                    db.prep.addBatch();
                }
                db.prep.executeBatch();

                db.connection.commit();
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            finally{
                db.close();
            }
        }

        return success;
    }
}
