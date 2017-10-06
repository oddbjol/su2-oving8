package services.Entities;

import services.DB.DB;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

/**
 * Created by KimRostgard on 25.09.2017.
 */
public class AnOrder implements Serializable{
    private int id;
    private int customer_id;
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
