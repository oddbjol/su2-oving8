package services;

import java.io.Serializable;

/**
 * Created by KimRostgard on 25.09.2017.
 */
public class Order implements Serializable{
    private String customerName;
    private int numberOfGuests;
    private String appertizer;
    private String mainCourse;
    private String dessert;
    private String drink;

    public Order(){
    }



    public Order(String customerName, int numberOfGuests, String appertizer, String mainCourse, String dessert, String drink){
        this.customerName=customerName;
        this.numberOfGuests=numberOfGuests;
        this.appertizer=appertizer;
        this.mainCourse=mainCourse;
        this.dessert=dessert;

        this.drink=drink;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public int getNumberOfGuests() {
        return numberOfGuests;
    }

    public void setNumberOfGuests(int numberOfGuests) {
        this.numberOfGuests = numberOfGuests;
    }

    public String getAppertizer() {
        return appertizer;
    }

    public void setAppertizer(String appertizer) {
        this.appertizer = appertizer;
    }

    public String getMainCourse() {
        return mainCourse;
    }

    public void setMainCourse(String mainCourse) {
        this.mainCourse = mainCourse;
    }

    public String getDessert() {
        return dessert;
    }

    public void setDessert(String dessert) {
        this.dessert = dessert;
    }

    public String getDrink() {
        return drink;
    }

    public void setDrink(String drink) {
        this.drink = drink;
    }





}
