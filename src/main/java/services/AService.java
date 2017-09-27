package services;

import jersey.repackaged.com.google.common.collect.HashBasedTable;
import jersey.repackaged.com.google.common.collect.HashMultimap;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.time.LocalDate;
import java.time.Month;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * @author nilstes
 */
@Path("/thepath/")

public class AService {

    static ArrayList<Dish> appetizer= new ArrayList<Dish>();
    static ArrayList<Dish> maincourse= new ArrayList<Dish>();
    static ArrayList<Dish> dessert= new ArrayList<Dish>();
    static ArrayList<Dish> drink= new ArrayList<Dish>();

    private static MultiHashMap registration = new MultiHashMap();
    //static HashMap<LocalDate, HashMap<Integer, HashMap<Integer, Order>>>registration= new HashMap<LocalDate, HashMap<Integer, HashMap<Integer, Order>>>();

//    private static synchronized boolean addRegistration(LocalDate date, int table_nr, int slot_nr, Order order){
////        HashMap< Integer, Order> timeTest = new HashMap<Integer, Order>();
////        timeTest.put(slot_nr, order);
////
////        HashMap <Integer, HashMap<Integer, Order> > tableTest = new HashMap<Integer, HashMap<Integer, Order>>();
////        tableTest.put(table_nr, timeTest);
//
//        if(!registration.containsKey(date))
//            ;//registration.put(date, null);
//        if(!registration.get(date).containsKey(tableTest))
//            ;//registration.get(date).put(table_nr, null);
//        if(!registration.get(date).get(tableTest).containsKey(timeTest)){
//            //registration.get(date).get(tableTest).put(slot_nr, order);
//            return true;
//        }
//        else{
//            return false;
//        }
//
//
//    }

    static {
        Order myOrder = new Order("Kim R", 4, "Fish soup", "Halibut", "creme brulee", "");
        String test = "test";
//        //HashMap <Integer, String> timeTest = new HashMap <Integer, String> (7, 5);
//        //HashMultimap <Integer, Order> timeTest = new HashMultiMap <Integer, Order> (7, myOrder);
//        HashMap< Integer, Order> timeTest = new HashMap<Integer, Order>();
//        HashMap <Integer, HashMap<Integer, Order> > tableTest = new HashMap<Integer, HashMap<Integer, Order>>();
//        timeTest.put(7, myOrder);
//        tableTest.put(12, timeTest);
//        registration.put(LocalDate.of(2017, Month.AUGUST, 25) , tableTest);

        boolean a = registration.put("2017-9-25", 1, 1, new Order("kundenavn", 4, "Bread", "Burger", "creme brulee", ""));
        boolean b = registration.put("2017-9-26", 1, 2, new Order("kundenavn", 4, "Bread", "Burger", "creme brulee", ""));
        boolean c = registration.put("2017-9-26", 2, 2, new Order("kundenavn", 4, "Bread", "Burger", "creme brulee", ""));

        System.out.println(a + " " + b + " " + c);

        appetizer.add(new Dish("Fish soup", 100));
        appetizer.add(new Dish("Bread", 50));
        maincourse.add(new Dish("Burger", 200));
        maincourse.add(new Dish("Hallibut", 300));
        dessert.add(new Dish("creme brulee", 150));
        dessert.add(new Dish("applecake and ice", 100));
        drink.add(new Dish("fanta", 50));
        drink.add(new Dish("cola", 50));
        //registrering.put("25092017", 12, myOrder);
    }




    @GET
    @Path("/dishes/appetizer")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAppetizer(){
        return Response.ok(appetizer).build();
    }

    @GET
    @Path("/dishes/maincourse")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getMainCourse(){
        return Response.ok(maincourse).build();
    }

    @GET
    @Path("/dishes/dessert")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDessert(){
        return Response.ok(dessert).build();
    }

    @GET
    @Path("/dishes/drink")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDrink(){
        return Response.ok(drink).build();
    }

    @GET
    @Path("/orders")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getOrders(){
        return Response.ok(registration.getMap()).build();
    }

    @GET
    @Path("/orders/{date}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getOrdersByDate(@PathParam("date") String date){
        return Response.ok(registration.getOrdersByDate(date)).build();
    }

    @POST
    @Path("/singleOrder/{orderDate}/{bordnr}/{slotnr}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response putOrder(@PathParam("orderDate") String orderDate, @PathParam("bordnr") int bordnr, @PathParam("slotnr") int slotnr, Order order){
        boolean success = registration.put(orderDate, bordnr, slotnr, order);
        return Response.ok(success).build();
    }

    @GET
    @Path("/checkAvailable/{orderDate}/{bordnr}/{slotnr}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response checkAvailable(@PathParam("orderDate") String orderDate, @PathParam("bordnr") int bordnr, @PathParam("slotnr") int slotnr){
        boolean isFree = registration.isFree(orderDate, bordnr, slotnr);
        return Response.ok(isFree).build();
    }


    private static String testString = "Hei. Skiv noe og se hva som skjer.";

    @GET 
    @Produces(MediaType.TEXT_PLAIN) 
    public String getSomething() {
        return testString;
    }

    @POST
    @Consumes(MediaType.TEXT_PLAIN)   //(MediaType.APPLICATION_JSON)
    public void sendSomething(String nyString){
        testString = nyString;
    }

}


