package services.Entities;

import com.mysql.jdbc.Statement;
import services.DB.DB;

import java.io.Serializable;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class FullOrder implements Serializable{
    private int table_number;
    private int customer_id;
    private Timestamp from_time;
    private Timestamp to_time;
    private HashMap<Integer, Integer> dishes = new HashMap<>(); // Integer is amount of dish

    public FullOrder(){}

    public FullOrder(int table_number, int customer_id, Timestamp from_time, Timestamp to_time, HashMap<Integer, Integer> dishes) {
        this.table_number = table_number;
        this.customer_id = customer_id;
        this.from_time = from_time;
        this.to_time = to_time;
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

    //Set date to null for all dates.
    public static ArrayList<FullOrder> getAllByDate(Date date){
        ArrayList<FullOrder> out = new ArrayList<>();

        DB db = new DB();

        if(db.setUp()){
            try{
                String sql = "SELECT * FROM AnOrder";

                if(date != null)
                    sql += " WHERE DATE(AnOrder.from_time)=?";

                db.prep = db.connection.prepareStatement(sql);

                if(date != null)
                    db.prep.setDate(1, date);

                db.res = db.prep.executeQuery();

                ArrayList<AnOrder> orders = new ArrayList<>();

                while(db.res.next())
                    orders.add(AnOrder.processRow(db.res));

                db.res.close();
                db.prep.close();

                for(AnOrder order : orders){
                    HashMap<Integer, Integer> dishes = Dish.getByOrderId(order.getId());

                    out.add(new FullOrder(order.getTable_number(), order.getCustomer_id(), order.getFrom_time(), order.getTo_time(), dishes ));
                }


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

    public static boolean registerOrder(FullOrder order){
        boolean success = false;

        DB db = new DB();

        if(db.setUp()){
            try{
                db.connection.setAutoCommit(false);

                db.prep = db.connection.prepareStatement("INSERT INTO AnOrder (table_number, customer_id, from_time, to_time) VALUES (?,?,?,?)", Statement.RETURN_GENERATED_KEYS);
                db.prep.setInt(1, order.getTable_number());
                db.prep.setInt(2, order.getCustomer_id());
                db.prep.setTimestamp(3, order.getFrom_time());
                db.prep.setTimestamp(4, order.getTo_time());

                success = (db.prep.executeUpdate() > 0);

                db.res = db.prep.getGeneratedKeys();

                int new_order_id = -1;

                if(db.res.next())
                    new_order_id = db.res.getInt(1);

                db.prep = db.connection.prepareStatement("INSERT INTO Order_Dish (order_id, dish_id, amount) VALUES (?,?,?)");

                for(Map.Entry<Integer, Integer> entry : order.dishes.entrySet()){
                    db.prep.setInt(1, new_order_id);
                    db.prep.setInt(2, entry.getKey());
                    db.prep.setInt(3, entry.getValue());

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
