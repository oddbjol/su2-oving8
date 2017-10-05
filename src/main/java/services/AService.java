package services;

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
    @Path("/singleOrder/{orderDate}/{bordnr}/{slotnr}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response putOrder(@PathParam("orderDate") String orderDate, @PathParam("bordnr") int bordnr, @PathParam("slotnr") int slotnr, AnOrder order){
        //boolean success = registration.put(orderDate, bordnr, slotnr, order);
        return Response.ok().build();
    }

    @GET
    @Path("/checkAvailable/{orderDate}/{bordnr}/{slotnr}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response checkAvailable(@PathParam("orderDate") String orderDate, @PathParam("bordnr") int bordnr, @PathParam("slotnr") int slotnr){
        //boolean isFree = registration.isFree(orderDate, bordnr, slotnr);
        return Response.ok().build();
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


}


