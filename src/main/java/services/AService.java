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
import java.util.HashMap;

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

    //TODO: Comment to explain confusing parameter list
    @POST
    @Path("/singleOrder")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response putOrder(FullOrder fullOrder){
        boolean success = AnOrder.registerOrder(fullOrder.getOrder(), fullOrder.getDishes());
        return Response.ok(success).build();
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
    public Response findTable(AnOrder order){
        return Response.ok(ATable.findTable(order)).build();
    }


}


