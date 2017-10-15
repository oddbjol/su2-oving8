package services;

import javafx.util.Pair;
import jersey.repackaged.com.google.common.collect.Table;
import org.glassfish.jersey.model.internal.RankedComparator;
import services.Entities.*;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.sql.Date;
import java.util.ArrayList;

/**
 * @author nilstes
 */
@Path("/thepath/")

public class AService {

    @GET
    @Path("/dishes/appetizer")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAppetizer(){
        return Response.ok(Dish.getAppetizers()).build();
    }

    @GET
    @Path("/dishes/maincourse")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getMainCourse(){
        return Response.ok(Dish.getMainCourses()).build();
    }

    @GET
    @Path("/dishes/dessert")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDessert(){
        return Response.ok(Dish.getDesserts()).build();
    }

    @GET
    @Path("/dishes/drink")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDrink(){
        return Response.ok(Dish.getDrinks()).build();
    }

    @GET
    @Path("/orders")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getOrders(){
        return Response.ok(TableRow.getRowsByDate(null)).build();
    }

    @GET
    @Path("/orders/{date}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getOrdersByDate(@PathParam("date") String date){
        ArrayList<TableRow> rows;
        rows = TableRow.getRowsByDate(Date.valueOf(date));
        return Response.ok(rows).build();
    }

    @POST
    @Path("/getFreeSlots/")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response getOrdersByDate(SlotHelper helper){
        return Response.ok(TableFreeSlot.getSlots(helper.date, helper.numGuests)).build();
    }

    @POST
    @Path("/singleOrder")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response putOrder(FullOrder order){
        boolean success = FullOrder.registerOrder(order);
        return Response.ok(success).build();
    }

    @POST
    @Path("/orders/updateStatus/{order_id}/{dish_id}/{status}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response updateDishOrderStatus(@PathParam("order_id") int order_id, @PathParam("dish_id") int dish_id, @PathParam("status") int status){
        return Response.ok(Dish_Order.updateStatus(order_id, dish_id, status)).build();
    }

    @POST
    @Path("/account/check/{amount}")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response checkBalance(@PathParam("amount") int amount, Account account){

        return Response.ok(account.checkBalance(amount)).build();
    }

    @POST
    @Path("/account/pay/{balance}")
    @Consumes(MediaType.APPLICATION_JSON)
    // Trekker et bestemt beløp (balance) penger fra kontoen (account)
    public Response pay(@PathParam("balance") int balance, Account account){
        return Response.ok(account.pay(balance)).build();
    }

    @POST
    @Path("/orders/order/findTable")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response findTable(FullOrder order){
        return Response.ok(ATable.findTable(order)).build();
    }
}


