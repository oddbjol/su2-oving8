    <%@page import="java.util.Date, java.util.Calendar, java.text.SimpleDateFormat" %>
        <!DOCTYPE html>
<html>
<head>
    <title>guest</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!--<link rel="stylesheet" type="text/css" href="style.css"> -->

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="styleguest.css">
    <script src="https://code.jquery.com/jquery-3.1.1.slim.min.js" integrity="sha384-A7FZj7v+d/sdmMqp/nOQwliLvUsJfDHW+k9Omg/a/EheAdgtzNs3hpfag6Ed950n" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
    <script src="guestscript.js"></script>

    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

    <link rel="stylesheet" type="text/css" href="style.css">
    <link rel="stylesheet" type="text/css" href="styleordersheet.css">
    <!-- Google Map -->


    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!--<script src="jquery-3.2.1.min.js"></script> -->

    <script language="javascript">
        $(document).ready(function() {
            getDishes();
            findTable();

            $("#submitbutton").click(function () {


                var appetizer = false, maincourse = false, dessert = false;

                var from_date = new Date(), to_date = new Date();

                var dish_orders = [];

                $("#appetizer").find("input").each(function(index, element){
                    var dishid = $(element).attr('id');
                    var num = $(element).val();

                    // Don't bother "ordering" 0 amount of a dish.
                    if(num == 0)
                        return;

                    var dish_order = {
                                        dish_id: dishid,
                                        amount: num,
                                        dish_type: 0,
                                        serve_time: "10:00" //TODO: Remove hardcoding
                                    };

                    dish_orders.push(dish_order);

                    appetizer = true;
                });

                $("#maincourse").find("input").each(function(index, element){
                    var dishid = $(element).attr('id');
                    var num = $(element).val();

                    // Don't bother "ordering" 0 amount of a dish.
                    if(num == 0)
                        return;

                    var dish_order = {
                                        dish_id: dishid,
                                        dish_type: 1,
                                        amount: num,
                                        serve_time: "10:00" //TODO: Remove hardcoding
                                    };

                    dish_orders.push(dish_order);

                    maincourse = true;
                });
                $("#dessert").find("input").each(function(index, element){
                    var dishid = $(element).attr('id');
                    var num = $(element).val();

                    // Don't bother "ordering" 0 amount of a dish.
                    if(num == 0)
                        return;

                    var dish_order = {
                                        dish_id: dishid,
                                        dish_type: 2,
                                        amount: num,
                                        serve_time: "10:00" //TODO: Remove hardcoding
                                    };

                    dish_orders.push(dish_order);

                    dessert = true;
                });
                $("#drink").find("input").each(function(index, element){
                    var dishid = $(element).attr('id');
                    var num = $(element).val();

                    // Don't bother "ordering" 0 amount of a dish.
                    if(num == 0)
                        return;

                    var dish_order = {
                                        dish_id: dishid,
                                        dish_type: 3,
                                        amount: num,
                                        serve_time: "10:00" //TODO: Remove hardcoding
                                    };

                    dish_orders.push(dish_order);
                });

                    var appetizer_offset = 0, maincourse_offset = 0, dessert_offset = 0;

                    if(appetizer && maincourse){
                        appetizer_offset = 0;
                        maincourse_offset = 30;
                        dessert_offset = 60;
                    }
                    else if(appetizer && !maincourse && dessert){
                        appetizer_offset = 0;
                        dessert_offset = 30;
                    }
                    else if(!appetizer && maincourse){
                        maincourse_offset = 0;
                        dessert_offset = 30;
                    }

            dish_orders.forEach(function(dish_order, index){
                if(dish_order.dish_type == 0) //appetizer
                    dish_order.serve_time = getClock(addMinutes(from_date, appetizer_offset));
                else if(dish_order.dish_type == 1)
                    dish_order.serve_time = getClock(addMinutes(from_date, maincourse_offset));
                else if(dish_order.dish_type == 2)
                    dish_order.serve_time = getClock(addMinutes(from_date, dessert_offset));
                else
                    dish_order.serve_time = getClock(from_date);

        });

                //TODO: Remove hardcoding.
                var fullOrder = {
                    table_number: 0,
                    //customer_id :
                    customer_name: $("#username").val(),
                    from_time: from_date,
                    to_time: to_date,
                    num_guests: 2,
                    dish_orders: dish_orders
                };

                console.log(JSON.stringify(fullOrder));


                var account = {
                    number: 123,//$("#cardnumber").val(), TODO: Add values here
                    cvs: 111 //$("#cvs").val()
                };

                $.ajax({
                    url: 'rest/thepath/account/check/' + $("#totalCost").html(),
                    type: 'POST',
                    data: JSON.stringify(account),
                    contentType: 'application/json; charset=utf-8',
                    //dataType: 'json',
                    success: function(success){
                        if(success){
                            $.ajax({
                                url: 'rest/thepath/singleOrder',
                                type: 'POST',
                                data: JSON.stringify(fullOrder),
                                contentType: 'application/json; charset=utf-8',
                                //dataType: 'json',
                            });
                            alert("Order placed successfull");
                        }
                        else{
                            alert("Something went wrong with payment");
                        }
                    }
                });
            });

            $("#guestNumber, #appetizer, #maincourse, #dessert, #drinks").change(updateCost);

            $("#serveringdate").change(findTable);
            $("#timeSlot").change(findTable);
            $("#guestNumber").change(findTable);

            $("#submitbutton").click(function(){
                sendOrder();
            });

        });

        function addMinutes(date, minutes){
        console.log(date + " adding " + minutes);
        d = new Date(date.getTime() + minutes*60*1000);
        return d;
        }

        function getClock(date){
            return date.getHours() + ":" + date.getMinutes();
        }

        function getStartTime(){
            var slotNumber = $("#timeSlot").val();
            var dateString = $("#serveringdate").val();
            var date = new Date(dateString);

            newDate = new Date(date.getFullYear(), date.getMonth(), date.getDate(), 0,0,0,0);

            var ms = newDate.getTime();

            ms += 12 * 60 * 60 * 1000;
            ms += slotNumber * 90 * 60 * 1000;

            return new Date(ms);
        }

        function getEndTime(){
            var date = getStartTime();

            var ms = date.getTime();

            ms += 90 * 60 * 1000;

            return new Date(ms);
        }

        function updateCost(){

        var numGuests = $("#guestNumber").val();
        var appertizer_price = pricelist[$("#appetizer").val()];
        var mainCourse_price = pricelist[$("#maincourse").val()];
        var dessert_price = pricelist[$("#dessert").val()];
        var drink_price = pricelist[$("#drinks").val()];

        var totalCost = numGuests * (appertizer_price + mainCourse_price + dessert_price + drink_price);

        $("#totalCost").val(totalCost);
        }

        function findTable(){

            var order={
                from_time: getStartTime(),
                to_time: getEndTime(),
                num_guests: $("#guestNumber").val()
            };

        console.log(JSON.stringify(order));

            $.ajax({
                url: 'rest/thepath/orders/order/findTable/',
                type: 'POST',
                data: JSON.stringify(order),
                contentType: 'application/json; charset=utf-8',
                success: function(table_number){
                    $("#table_number").val(table_number);
                }
            });
        }
//test comment

        var pricelist = {};

        function getDishes() {
            $.get("rest/thepath/dishes/appetizer", function (dishes) {

                //console.dir(appetizers); // For komplekse objekter
                for (var dish of dishes) {
                    pricelist[dish.id] = dish.price;
                    var option = "<option value='" + dish.id + "'>" + dish.name + " (" + dish.price + " NOK)</option>";
                    console.log(option);
                    //console.log(option); //For strenger og tall
                    $("#appetizer").append(option);
                }
            });

            $.get("rest/thepath/dishes/maincourse", function (dishes) {

                //console.dir(appetizers); // For komplekse objekter
                for (var dish of dishes) {
                    pricelist[dish.id] = dish.price;
                    var option = "<option value='" + dish.id + "'>" + dish.name + " (" + dish.price + " NOK)</option>";
                    //console.log(option); //For strenger og tall
                    $("#maincourse").append(option);
                }

                $.get("rest/thepath/dishes/dessert", function (dishes) {

                //console.dir(appetizers); // For komplekse objekter
                for (var dish of dishes) {
                pricelist[dish.id] = dish.price;
                var option = "<option value='" + dish.id + "'>" + dish.name + " (" + dish.price + " NOK)</option>";
                //console.log(option); //For strenger og tall
                $("#dessert").append(option);
                }

                    $.get("rest/thepath/dishes/drink", function (dishes) {

                    //console.dir(appetizers); // For komplekse objekter
                    for (var dish of dishes) {
                    pricelist[dish.id] = dish.price;
                    var option = "<option value='" + dish.id + "'>" + dish.name + " (" + dish.price + " NOK)</option>";
                    //console.log(option); //For strenger og tall
                    $("#drinks").append(option);
                    }

                        updateCost();
                    });
                });
            });
        }

        function sendOrder(){

        }



    </script>

    <meta name="viewport" content="width=device-width, initial-scale=1">

</head>

<body>

<div class="container-fluid" style="margin-top:30px;">
    <div class="row">
        <div class="col-md-6 col-md-offset-3" style="padding-right: 0px!important;padding-left: 0px!important;">
            <div class="panel-body" style="padding-right: 4px!important;padding-left: 4px!important;">
                <form class="form-horizontal" method="post" id="login" name="login" role="form" onSubmit='#' action="#" AUTOCOMPLETE="off">
                    <fieldset  style="min-width: 0;padding:.35em .625em .75em!important;margin:0 2px;border: 2px solid silver!important;margin-bottom: 10em;box-shadow: -6px 15px 20px 0px;">
                        <legend id="first3" style="width: inherit;padding:inherit;border:2px solid silver;" class="legend"> 1/3</legend>
                        <legend id="myId8" class="hidden legend" style="width: inherit;padding:inherit;border:2px solid silver;">Menu</legend>
                        <div class="form-group" id="above" style="margin-bottom: 5px!important;">
                            <div class="col-sm-1 col-md-2 col-lg-2 col-xs-1"></div>
                            <output class="col-sm-10 col-md-8 col-lg-8 col-xs-10"
                                    id="responseFail" type="text"
                                    style="text-align: center; font-weight: bold; color: red;padding: 0px!important;" ></output>
                            <div class="col-sm-1 col-md-2 col-lg-2 col-xs-1"></div>
                        </div>
                        <div class="form-group" style="margin-bottom: 5px!important;">
                            <div class="col-sm-12 col-md-12 col-lg-12 col-xs-12" id="message" style="font-weight: bold; text-align: center;font-size: 10pt;">
                            </div>
                        </div>
                        <div class="form-group" id="first" style="margin-bottom: 0px!important;">

                            <div class="col-sm-1 col-md-1 col-lg-1 col-xs-1"></div>
                            <div class="col-sm-10 col-md-10 col-lg-10 col-xs-10 input-group">
                                <div class="section" style="padding-bottom:100px;">
                                    <h3 class="title-attr"><small> Enter your name </small></h3>
                                <span class="input-group-addon"><span class="glyphicon glyphicon-user" style="color: black;"></span></span>
                                <input type="text" class="form-control" id="username" placeholder="Enter your name">
                            </div>
                            </div>

                            <div class="col-sm-1 col-md-1 col-lg-1 col-xs-1"></div>
                            <div class="col-sm-10 col-md-10 col-lg-10 col-xs-10 input-group">
                                <div class="section" style="padding-bottom:20px;">
                                    <h3 class="title-attr"><small>How many guest</small></h3>
                                    <div>
                                        <div class="btn-minus"><span class="glyphicon glyphicon-minus"></span></div>
                                        <input value="1" />
                                        <div class="btn-plus"><span class="glyphicon glyphicon-plus"></span></div>
                                    </div>
                                </div>
                                <div class="col-sm-1 col-md-1 col-lg-1 col-xs-1"></div>
                        </div>

                        <div class="form-group" id="first1">
                            <div class="col-sm-1 col-md-1 col-lg-1 col-xs-1"></div>
                            <div class="col-sm-11 col-md-11 col-lg-11 col-xs-10" style="text-align:center;">
                                <button id="valuser" type="button" onclick="valUsername()"
                                        class="btn btn-primary customizedPrimaryBtn">
                                    Next</button>
                        </div>

                            <div class="col-sm-1 col-md-1 col-lg-1 col-xs-1"></div>
                        </div>
                        </div>

                            <!--
                        div class="form-group hidden" id="myId" style="margin-bottom: 5px!important;">
                                                            <div class="col-sm-1 col-md-2 col-lg-2 col-xs-1"></div>
                                                            <div class="col-sm-10 col-md-8 col-lg-8 col-xs-10"
                                                                id="Response"
                                                                style="text-align: center; font-weight: bold;padding-top: 0px;" ></div>
                                                            <div class="col-sm-1 col-md-2 col-lg-2 col-xs-1"></div>
                                                        </div>	-->
                            <div class="form-group hidden" id="myId1" style="margin-bottom: 10px!important;">
                                <table id="appetizer" class="table table-hover table-condensed">
                                    <thead>
                                    <tr>
                                        <th style="width:50%">Product</th>
                                        <th style="width:10%">Price</th>
                                        <th style="width:8%">Quantity</th>
                                        <th style="width:22%" class="text-center">Subtotal</th>
                                        <th style="width:10%"></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td data-th="Product">
                                            <div class="row">
                                                <div class="col-sm-2 hidden-xs"><img src="http://placehold.it/100x100" alt="..." class="img-responsive"/></div>
                                                <div class="col-sm-10">
                                                    <h4 class="nomargin">Fisk</h4>
                                                    <p>Fisken er fersk osv...</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="Price">250,-</td>
                                        <td data-th="Quantity">
                                            <input type="number" class="form-control text-center" id="1" value="0">
                                        </td>
                                        <td data-th="Subtotal" id="subTot1" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-danger btn-sm">x<i class="fa fa-trash-o"></i></button>
                                        </td>
                                    </tr>
                                    </tbody>


                                    <tbody>
                                    <tr>
                                        <td data-th="Product">
                                            <div class="row">
                                                <div class="col-sm-2 hidden-xs"><img src="http://placehold.it/100x100" alt="..." class="img-responsive"/></div>
                                                <div class="col-sm-10">
                                                    <h4 class="nomargin">Hamburger</h4>
                                                    <p>Taste our fresh and friendly burger...</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="Price">199,-</td>
                                        <td data-th="Quantity">
                                            <input type="number" class="form-control text-center" id="1" value="0">
                                        </td>
                                        <td data-th="Subtotal" id="subTot2" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-danger btn-sm">x<i class="fa fa-trash-o"></i></button>
                                        </td>
                                    </tr>
                                    </tbody>


                                    <tbody>
                                    <tr>
                                        <td data-th="Product">
                                            <div class="row">
                                                <div class="col-sm-2 hidden-xs"><img src="http://placehold.it/100x100" alt="..." class="img-responsive"/></div>
                                                <div class="col-sm-10">
                                                    <h4 class="nomargin">Bacalao</h4>
                                                    <p>Kim rated it to 5 stars inn the biggest female magasin</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="Price">199,-</td>
                                        <td data-th="Quantity">
                                            <input type="number" class="form-control text-center" id="1" value="0">
                                        </td>
                                        <td data-th="Subtotal" id="subTot3" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-danger btn-sm">x<i class="fa fa-trash-o"></i></button>
                                        </td>
                                    </tr>
                                    </tbody>


                                    <tbody>
                                    <tr>
                                        <td data-th="Product">
                                            <div class="row">
                                                <div class="col-sm-2 hidden-xs"><img src="http://placehold.it/100x100" alt="..." class="img-responsive"/></div>
                                                <div class="col-sm-10">
                                                    <h4 class="nomargin">Shrimps</h4>
                                                    <p>ivamus rhoncus, turpis at vehicula tincidunt, mauris lorem aliquet dolor</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="Price">99,-</td>
                                        <td data-th="Quantity">
                                            <input type="number" class="form-control text-center" id="1" value="0">
                                        </td>
                                        <td data-th="Subtotal" id="subTot4" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-danger btn-sm">x<i class="fa fa-trash-o"></i></button>
                                        </td>
                                    </tr>
                                    </tbody>


                                    <tbody>
                                    <tr>
                                        <td data-th="Product">
                                            <div class="row">
                                                <div class="col-sm-2 hidden-xs"><img src="http://placehold.it/100x100" alt="..." class="img-responsive"/></div>
                                                <div class="col-sm-10">
                                                    <h4 class="nomargin">Soup</h4>
                                                    <p> Lorem ipsum dolor sit amet, consectetur adipiscing elit. In commodo urna et nisi rhoncus tempor.</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="Price">250,-</td>
                                        <td data-th="Quantity">
                                            <input type="number" class="form-control text-center" id="1" value="0">
                                        </td>
                                        <td data-th="Subtotal" id="subTot5" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-danger btn-sm">x<i class="fa fa-trash-o"></i></button>
                                        </td>
                                    </tr>
                                    </tbody>


                                    <tbody>
                                    <tr>
                                        <td data-th="Product">
                                            <div class="row">
                                                <div class="col-sm-2 hidden-xs"><img src="http://placehold.it/100x100" alt="..." class="img-responsive"/></div>
                                                <div class="col-sm-10">
                                                    <h4 class="nomargin">Beer</h4>
                                                    <p>Because beer is good for everyone</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="Price">79,-</td>
                                        <td data-th="Quantity">
                                            <input type="number" id="0" class="form-control text-center" value="0">
                                        </td>
                                        <td data-th="Subtotal" id="subTot6" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-danger btn-sm">x<i class="fa fa-trash-o"></i></button>
                                        </td>
                                    </tr>
                                    </tbody>


                                    <tbody>
                                    <tr>
                                        <td data-th="Product">
                                            <div class="row">
                                                <div class="col-sm-2 hidden-xs"><img src="http://placehold.it/100x100" alt="..." class="img-responsive"/></div>
                                                <div class="col-sm-10">
                                                    <h4 class="nomargin">Fanta</h4>
                                                    <p>Yellow good old Fanta</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="Price">35,-</td>
                                        <td data-th="Quantity">
                                            <input type="number" id="1" class="form-control text-center" value="0">
                                        </td>
                                        <td data-th="Subtotal" id="subTot7" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-danger btn-sm">x<i class="fa fa-trash-o"></i></button>
                                        </td>
                                    </tr>
                                    </tbody>

                                    

                                    <tfoot>
                                    <tr class="visible-xs">
        <td class="text-center"><strong>Total <span id="totalCost">12</span></strong></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="hidden-xs"></td>
                                        <td class="hidden-xs text-center"><strong>Total $12</strong></td>
                                        <td><a href="#" type="submit" id="submitbutton" class="btn btn-success btn-block">Pay <i class="fa fa-angle-right"></i></a></td>
                                    </tr>
                                    </tfoot>


                                </table>

                                <div class="col-sm-1 col-md-1 col-lg-1 col-xs-1"></div>
                                <div class="col-sm-10 col-md-10 col-lg-10 col-xs-10 input-group">

                                    <!-- Har var input for password tidligere -->
                                </div>
                                <div class="col-sm-1 col-md-1 col-lg-1 col-xs-1"></div>

                            </div>

                            <div class="form-group hidden" id="myId3">
                                <div class="col-sm-1 col-md-1 col-lg-1 col-xs-1"></div>
                                <div class="col-sm-11 col-md-11 col-lg-11 col-xs-10 button_Pad" style="text-align:center">
                                    <button type="button" onclick="prevPage()"
                                            class="btn btn-primary"
                                            style=" font-size: 13px;">
                                        Back</button>

                                     


                                </div>
                                <div class="col-sm-1 col-md-1 col-lg-1 col-xs-1"></div>
                            </div>


                    </fieldset>
                </form>
            </div>
        </div>
<!--
        <form>
            <fieldset>
                <legend> Personalia: </legend>
                Name: <input type="text" id="nam"><br>


                Number of guests:
                <select id="guestNumber">
                    <option value="0">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                </select><br>


                Servingtime (date and time):
                <input type="date" id="serveringdate" value=" --><%

                Date d = new Date();

Calendar cal = Calendar.getInstance();
cal.add(Calendar.DATE, 7);
Date date = cal.getTime();
SimpleDateFormat ft = new SimpleDateFormat("YYYY-MM-dd");


                out.print(ft.format(date));



%>
                <!--<input type="submit" value="Send"> -->
<!--
                <select id="timeSlot">
                    <option value="0">1200 - 1330 </option>
                    <option value="0">1330 - 1500 </option>
                    <option value="2">1500 - 1630 </option>
                    <option value="3">1630 - 1800 </option>
                    <option value="4">1800 - 1930 </option>
                    <option value="5">1930 - 2100 </option>
                    <option value="6">2100 - 2230 </option>
                    <option value="7">2230 - 2400 </option>
                </select><br>


            </fieldset><br>

            <fieldset>


                    <legend> Menu: </legend>

                    Appetizer:
                    <select id="appetizer">
                    </select><br>

                    Main Course:
                    <select id="maincourse">
                    </select><br>

                    Dessert:
                    <select id="dessert">
                    </select><br>

                    Drinks:
                    <select id="drinks">
                    </select><br>


                    Total Costs: <input type="text" id="totalCost" disabled> <br>

                    Your table number: <input type="text" id="table_number" disabled> <br>







            </fieldset><br>
            <fieldset>

                    <legend> Payment: </legend>
                        Cardnumber: (hint:123 or 321) <input type="text" id="cardnumber"><br>
                        CVS: (hint:111) <input type="text" id="cvs"><br><br>








                    <input id="submit" type="button" value="Confirm reservation"><br>
            </fieldset>
        </form>


        </div>




    </div>


</div><br>


-->
<!--
<nav class="navbar navbar-default" >
    <div class="container-fluid">
        <div class="bunn-bar">
            <ul class="nav navbar-nav" >
                <!--<li class="active"><a href="#">Home</a></li>-->
<!--
                <li><a href="#">About</a></li>
                <li><a href="#">News</a></li>
                <li><a href="#">Events</a></li>
                <li><a href="#">Contact</a></li>
            </ul>
        </div>
    </div>
</nav>
-->
</body>
</html>