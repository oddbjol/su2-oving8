package services;

import java.io.Serializable;

/**
 * Created by KimRostgard on 26.09.2017.
 */
public class Dish implements Serializable {
    private String name;
    private int prize;

    Dish (){
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPrize() {
        return prize;
    }

    public void setPrize(int prize) {
        this.prize = prize;
    }
}
