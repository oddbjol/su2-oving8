package services;

import services.Entities.*;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by odd2k on 29.09.2017.
 */
public class test {
    public static void main(String[] args){

//        ArrayList<Account> accounts = Account.getAll();
//        ArrayList<ATable> tables = ATable.getAll();
//        ArrayList<Customer> customers = Customer.getAll();
//        ArrayList<Dish> dishes = Dish.getAll();
//        ArrayList<AnOrder> orders = AnOrder.getAll();
//
//        HashMap<Dish, Integer> dishes2 = Dish.getByOrderId(1);
//
        //ArrayList<FullOrder> fullorders = FullOrder.getAllByDate(Date.valueOf(LocalDate.now()));

        HashMap<Integer, Integer> dishes = new HashMap<>();

        dishes.put(1, 3);
        dishes.put(5, 7);

        FullOrder order = new FullOrder(1, 1, "name", Timestamp.valueOf(LocalDateTime.now()), Timestamp.valueOf(LocalDateTime.now().plusHours(2)), 2, dishes);

        FullOrder.registerOrder(order);

    }
}
