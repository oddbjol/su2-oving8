package services.Entities;

import services.DB.DB;

import java.sql.SQLException;

/**
 * Created by odd on 10/11/2017.
 */
public class Dish_Order {

    public static final int STATUS_WAITING_FOR_CHEF = 0;
    public static final int STATUS_WAITING_FOR_WAITER = 1;
    public static final int STATUS_SERVED = 2;

    private int dish_id;
    private int dish_type;
    private int amount;
    private String serve_time;
    private int status;

    public Dish_Order(){}

    public Dish_Order(int dish_id, int dish_type, int amount, String serve_time, int status) {
        this.dish_id = dish_id;
        this.dish_type = dish_type;
        this.amount = amount;
        this.serve_time = serve_time;
        this.status = status;
    }


    public int getDish_id() {
        return dish_id;
    }

    public void setDish_id(int dish_id) {
        this.dish_id = dish_id;
    }

    public int getDish_type() {
        return dish_type;
    }

    public void setDish_type(int dish_type) {
        this.dish_type = dish_type;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public String getServe_time() {
        return serve_time;
    }

    public void setServe_time(String serve_time) {
        this.serve_time = serve_time;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public static boolean updateStatus(int order_id, int dish_id, int status){

        boolean success = true;

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("UPDATE Order_Dish set status=? WHERE order_id=? AND dish_id=?");
                db.prep.setInt(1, status);
                db.prep.setInt(2, order_id);
                db.prep.setInt(3, dish_id);
                int num = db.prep.executeUpdate();

                success = (num > 0);
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
