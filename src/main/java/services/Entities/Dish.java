package services.Entities;

import services.DB.DB;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class Dish {

    private int id;
    private String name;
    private int price;
    private int dish_type;

    public static int DISH_TYPE_APPETIZER = 0;
    public static int DISH_TYPE_MAIN_COURSE = 1;
    public static int DISH_TYPE_DESSERT = 2;
    public static int DISH_TYPE_DRINK = 3;


    public Dish(int id, String name, int price, int dish_type) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.dish_type = dish_type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getDish_type() {
        return dish_type;
    }

    public void setDish_type(int dish_type) {
        this.dish_type = dish_type;
    }

    public static ArrayList<Dish> getAll(){
        ArrayList<Dish> out = new ArrayList<>();

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("SELECT * FROM Dish");

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

    public static ArrayList<Dish> getByType(int dish_type){
        ArrayList<Dish> out = new ArrayList<>();

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("SELECT * FROM Dish WHERE dish_type=?");
                db.prep.setInt(1, dish_type);
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

    public static ArrayList<Dish> getAppetizers(){
        return getByType(DISH_TYPE_APPETIZER);
    }
    public static ArrayList<Dish> getMainCourses(){
        return getByType(DISH_TYPE_MAIN_COURSE);
    }
    public static ArrayList<Dish> getDesserts(){
        return getByType(DISH_TYPE_DESSERT);
    }
    public static ArrayList<Dish> getDrinks(){
        return getByType(DISH_TYPE_DRINK);
    }

    // Returns map of dish ids and amount of each dish, for a given order id.
    public static HashMap<Integer, Integer> getByOrderId(int order_id){
        HashMap<Integer, Integer> out = new HashMap<>();

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("SELECT * FROM Dish\n" +
                                                            "INNER JOIN Order_Dish ON Dish.id=Order_Dish.dish_id\n" +
                                                            "WHERE Order_Dish.order_id=?");
                db.prep.setInt(1, order_id);
                db.res = db.prep.executeQuery();

                while(db.res.next()){
                    int amount = db.res.getInt("amount");
                    int dish_id = db.res.getInt("Dish.id");

                    out.put(dish_id, amount);
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

    //Processes information fetched from database and creates a similar object.
    public static Dish processRow(ResultSet res) throws SQLException {

        int id = res.getInt("Dish.id");
        String name = res.getString("Dish.name");
        int price = res.getInt("Dish.price");
        int dish_type = res.getInt("Dish.dish_type");

        return new Dish(id, name, price, dish_type);
    }
}
