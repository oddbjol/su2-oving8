package services.Entities;

/**
 * Created by odd on 10/11/2017.
 */
public class Dish_Order {
    private int dish_id;
    private int dish_type;
    private int amount;
    private String serve_time;

    public Dish_Order(){}

    public Dish_Order(int dish_id, int dish_type, int amount, String serve_time) {
        this.dish_id = dish_id;
        this.dish_type = dish_type;
        this.amount = amount;
        this.serve_time = serve_time;
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
}
