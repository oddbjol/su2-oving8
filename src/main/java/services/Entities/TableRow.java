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
    private int order_id;
    private int dish_id;
    private String customer_name;
    private int table_number;
    private String dish_name;
    private String serve_time;
    private int dish_type;
    private int status;
    private int seats;

    public TableRow() {
    }


    public TableRow(int order_id, int dish_id, String customer_name, int table_number, String dish_name, String serve_time, int dish_type, int status, int seats) {
        this.order_id = order_id;
        this.dish_id = dish_id;
        this.customer_name = customer_name;
        this.table_number = table_number;
        this.dish_name = dish_name;
        this.serve_time = serve_time;
        this.dish_type = dish_type;
        this.status = status;
        this.seats = seats;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public int getDish_id() {
        return dish_id;
    }

    public void setDish_id(int dish_id) {
        this.dish_id = dish_id;
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

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getSeats() {
        return seats;
    }

    public void setSeats(int seats) {
        this.seats = seats;
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

                String sql =    "SELECT *," +
                                "CONCAT(Order_Dish.amount,' x ',Dish.name) AS dish_description \n" +
                                "FROM AnOrder\n" +
                                "INNER JOIN Order_Dish ON AnOrder.id=Order_Dish.order_id\n" +
                                "INNER JOIN Dish ON Order_Dish.dish_id=Dish.id\n" +
                                "INNER JOIN ATable ON AnOrder.table_number=ATable.number\n" +
                                "WHERE DATE(from_time) = ? \n" +
                                "ORDER BY Order_Dish.time, Order_Dish.order_id, Order_Dish.dish_id \n";

                db.prep = db.connection.prepareStatement(sql);
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
        int order_id = res.getInt("AnOrder.id");
        int dish_id = res.getInt("Dish.id");
        String customer_name = res.getString("AnOrder.customer_name");
        int table_number = res.getInt("ATable.number");
        String dish_name = res.getString("dish_description");
        String serve_time = res.getString("Order_Dish.time");
        int dish_type = res.getInt("Dish.dish_type");
        int status = res.getInt("Order_Dish.status");
        int seats = res.getInt("ATable.seats");

        return new TableRow(order_id, dish_id, customer_name, table_number, dish_name, serve_time, dish_type, status, seats);
    }
}
