package services.Entities;

import java.util.HashMap;

/**
 * Helper object to encapsulate an AnOrder object with a Hashmap of
 *
 * First integer in the HashMap(the key) is the id of a dish
 * Second integer in the HashMap (the value) is how many dishes of the given dish id (from the key) there are
 *
 * If you ordered 2 burgers (id 12), 5 soups (id 13) and 1 coke (id 17), the map would look like this (javascript syntax):
 *
 * (Syntax for each line inside brackets is key: value)
 *
 * {
 *     12: 2,
 *     13: 5,
 *     1: 17
 * }
 */
public class FullOrder {
    private AnOrder order;
    private HashMap<Integer, Integer> dishes;

    public AnOrder getOrder() {
        return order;
    }

    public void setOrder(AnOrder order) {
        this.order = order;
    }

    public HashMap<Integer, Integer> getDishes() {
        return dishes;
    }

    public void setDishes(HashMap<Integer, Integer> dishes) {
        this.dishes = dishes;
    }
}

