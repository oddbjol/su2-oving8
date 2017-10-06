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
    private int table_number;
    private Timestamp from_time;
    private Timestamp to_time;

    public AnOrder(){
    }

    public AnOrder(int id, int customer_id, int table_number, Timestamp from_time, Timestamp to_time) {
        this.id = id;
        this.customer_id = customer_id;
        this.table_number = table_number;
        this.from_time = from_time;
        this.to_time = to_time;
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
        int tableNumber = res.getInt("AnOrder.table_number");
        Timestamp from_time = res.getTimestamp("AnOrder.from_time");
        Timestamp to_time = res.getTimestamp("AnOrder.to_time");

        return new AnOrder(id, customerID, tableNumber, from_time, to_time);
    }
}
