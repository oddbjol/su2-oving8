package services.Entities;

import services.DB.DB;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;


/**
 * Represents a row of data to be put into the worklist for chef/waiter.
 *
 * dish_type should probably not be shown in table, but can be used to determine how to display the row.
 */
public class TableRow {
    private String customer_name;
    private int table_number;
    private String dish_name;
    private String serve_time;
    private int dish_type;

    /**
     *
     * @param customer_name
     * @param table_number
     * @param dish_name
     * @param serve_time asdasd
     * @param dish_type
     */
    public TableRow() {
    }



    public TableRow(String customer_name, int table_number, String dish_name, String serve_time, int dish_type) {
        this.customer_name = customer_name;
        this.table_number = table_number;
        this.dish_name = dish_name;
        this.serve_time = serve_time;
        this.dish_type = dish_type;
    }

    public String getCustomer_name() {
        return customer_name;
    }

    public void setCustomer_name(String customer_name) {
        this.customer_name = customer_name;
    }

    public int getTable_number() {
        return table_number;
    }

    public void setTable_number(int table_number) {
        this.table_number = table_number;
    }

    public String getDish_name() {
        return dish_name;
    }

    public void setDish_name(String dish_name) {
        this.dish_name = dish_name;
    }

    public String getServe_time() {
        return serve_time;
    }

    public void setServe_time(String serve_time) {
        this.serve_time = serve_time;
    }

    public int getDish_type() {
        return dish_type;
    }

    public void setDish_type(int dish_type) {
        this.dish_type = dish_type;
    }

    /**
     * Get all rows to be displayed in worklist for a given date.
     * @param date
     * @return
     */

    public static ArrayList<TableRow> getRowsByDate(Date date){

        ArrayList<TableRow> out = new ArrayList<>();

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("SELECT * FROM Meals WHERE `date`=?");
                db.prep.setDate(1, date);
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
    public static TableRow processRow(ResultSet res) throws SQLException{
        String customer_name = res.getString("customer_name");
        int table_number = res.getInt("table_number");
        String dish_name = res.getString("dish_name");
        String serve_time = res.getString("serve_time");
        int dish_type = res.getInt("dish_type");

        return new TableRow(customer_name, table_number, dish_name, serve_time, dish_type);
    }
}
