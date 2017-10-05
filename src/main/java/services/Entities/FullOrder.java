package services.Entities;

import services.DB.DB;

import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;

public class FullOrder {
    private ATable table;
    private Customer customer;
    private Timestamp from_time;
    private Timestamp to_time;
    private HashMap<Dish, Integer> dishes = new HashMap<>(); // Integer is amount of dish

    public FullOrder(ATable table, Customer customer, Timestamp from_time, Timestamp to_time, HashMap<Dish, Integer> dishes) {
        this.table = table;
        this.customer = customer;
        this.from_time = from_time;
        this.to_time = to_time;
        this.dishes = dishes;
    }

    public ATable getTable() {
        return table;
    }

    public void setTable(ATable table) {
        this.table = table;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
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
    public HashMap<Dish, Integer> getDishes() {
        return dishes;
    }

    public void setDishes(HashMap<Dish, Integer> dishes) {
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
                    Customer customer = Customer.getById(order.getCustomer_id());
                    ATable table = ATable.getById(order.getTable_number());
                    HashMap<Dish, Integer> dishes = Dish.getByOrderId(order.getId());

                    out.add(new FullOrder(table, customer, order.getFrom_time(), order.getTo_time(), dishes ));
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
}
