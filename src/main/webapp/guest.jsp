    <%@page import="java.util.Date, java.util.Calendar, java.text.SimpleDateFormat" %>
        <!DOCTYPE html>
<html>
<head>
    <title>guest</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!--<link rel="stylesheet" type="text/css" href="style.css"> -->

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
    <!-- ClockPicker Stylesheet -->
    <link rel="stylesheet" type="text/css" href="dist/bootstrap-clockpicker.min.css">
    <link rel="stylesheet" type="text/css" href="styleguest.css">
    <script src="https://code.jquery.com/jquery-3.1.1.slim.min.js" integrity="sha384-A7FZj7v+d/sdmMqp/nOQwliLvUsJfDHW+k9Omg/a/EheAdgtzNs3hpfag6Ed950n" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>
    <script src="guestscript.js"></script>

    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

    <link rel="stylesheet" type="text/css" href="style.css">
    <link rel="stylesheet" type="text/css" href="styleordersheet.css">
    <link rel="stylesheet" type="text/css" href="styleguest.css">
    <!-- Google Map -->


    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!--<script src="jquery-3.2.1.min.js"></script> -->


    <script language="javascript">
        $(document).ready(function() {
            getDishes();
            populateTable();
            findTable();

            $("#submitbutton").click(function () {


                var appetizer = false, maincourse = false, dessert = false;

                var from_date = new Date(), to_date = new Date();

                var dish_orders = [];

                    $(".dish0").each(function(index, element){
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

                    $(".dish1").each(function(index, element){
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
                    $(".dish2").each(function(index, element){
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
                $(".dish3").each(function(index, element){
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

                     addDishToTable(dish, "#appetizers");
                }
            });

            $.get("rest/thepath/dishes/maincourse", function (dishes) {

                //console.dir(appetizers); // For komplekse objekter
                for (var dish of dishes) {
                    pricelist[dish.id] = dish.price;
                    addDishToTable(dish, "#maincourses");
                }


            });

            $.get("rest/thepath/dishes/dessert", function (dishes) {

            //console.dir(appetizers); // For komplekse objekter
            for (var dish of dishes) {
            pricelist[dish.id] = dish.price;
        addDishToTable(dish, "#desserts");
            }


            });

            $.get("rest/thepath/dishes/drink", function (dishes) {

            //console.dir(appetizers); // For komplekse objekter
            for (var dish of dishes) {
            pricelist[dish.id] = dish.price;
            addDishToTable(dish, "#drinks");
            }

            updateCost();
            });
        }

        function addDishToTable(dish, header){
            var html = `                                    <tr>
        <td data-th="Product">
        <div class="row">
        <div class="col-sm-2 hidden-xs"><img src="http://placehold.it/100x100" alt="..." class="img-responsive"/></div>
        <div class="col-sm-10">
        <h4 class="nomargin">` + dish.name + `</h4>
        <p></p>
        </div>
        </div>
        </td>
        <td data-th="Price">` + dish.price + `</td>
        <td data-th="Quantity">
        <input type="number" id="` + dish.id + `" class="form-control text-center dish` + +dish.dish_type +`" value="0">
        </td>
        <td data-th="Subtotal" id="subTot8" class="text-center"></td>
        <td class="actions" data-th="">
        <button class="btn btn-success btn-sm">+<i class="fa fa-trash-o"></i></button>
        </td>
        </tr>`

            $(header).after(html);
        }


        function populateTable(){

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
                           <!-- <output class="col-sm-10 col-md-8 col-lg-8 col-xs-10"
                                    id="responseFail" type="text"
                                    style="text-align: center; font-weight: bold; color: red;padding: 0px!important;" ></output>
                                    -->
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
                                <div class='col-sm-6'>
                                    <div class="form-group">
                                        <h3 class="title-attr"><small> Enter date</small></h3>
                                        <div class='input-group date' id='datetimepicker1'>
                                            <input type='text' class="form-control" />
                                            <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-calendar"></span></span>
                                            <div class="input-group clockpicker">
                                                <input type="text" class="form-control" value="18:00">
                                                <span class="input-group-addon">
                                                    <span class="glyphicon glyphicon-time"></span></span>
                                            </div>
                                        </div>
                                    </div>
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
                                        class="btn btn-primary customizedPrimaryBtn">Next</button>
                        </div>
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
                                <table id="cart" class="table table-hover table-condensed">
                                      <thead id="appetizers">
                                        <tr>
                                            <th style="width:50%">Appetizers</th>
                                            <th style="width:10%">Price</th>
                                            <th style="width:8%">Quantity</th>
                                            <th style="width:22%" class="text-center">Subtotal</th>
                                            <th style="width:10%"></th>
                                        </tr>
                                    </thead>
                                    <thead id="maincourses">
                                        <tr>
                                            <th style="width:50%">Main courses</th>
                                            <th style="width:10%">Price</th>
                                            <th style="width:8%">Quantity</th>
                                            <th style="width:22%" class="text-center">Subtotal</th>
                                            <th style="width:10%"></th>
                                        </tr>
                                    </thead>
                                      <thead id="desserts">
                                        <tr>
                                            <th style="width:50%">Desserts</th>
                                            <th style="width:10%">Price</th>
                                            <th style="width:8%">Quantity</th>
                                            <th style="width:22%" class="text-center">Subtotal</th>
                                            <th style="width:10%"></th>
                                        </tr>
                                    </thead>
                                    <thead id="drinks">
                                        <tr>
                                            <th style="width:50%">Drinks</th>
                                            <th style="width:10%">Price</th>
                                            <th style="width:8%">Quantity</th>
                                            <th style="width:22%" class="text-center">Subtotal</th>
                                            <th style="width:10%"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <tfoot>
                                    <tr class="visible-xs">
                                        <td class="text-center"><strong>Total <span id="totalCost">20</span></strong></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="hidden-xs"></td>
                                        <td class="hidden-xs text-center" id="Pay"><strong>Total $1.99</strong></td>
                                        <td><button id="" class="btn btn-danger btn-block" data-toggle="modal" data-target="#myModal">Pay <i class="fa fa-angle-right"></i></button></td>
                                        <!--onclick="javascript:return loginStatus()"-->
                                    </tr>
                                    </tfoot>
                                </table>
                                </div>


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
                        <!-- CREDIT CARD FORM STARTS HERE -->
                        <div class="modal fade" id="myModal" role="dialog">
                            <div class="modal-dialog" role="document">
                            <div class="modal-body">
                                <div class="form-group hidden" id="myId4" style="margin-bottom: 10px!important;">
                                    <div class="panel panel-default credit-card-box">
                                        <div class="panel-heading display-table" >
                                            <div class="row display-tr" >
                                                <h3 class="panel-title display-td" >Payment Details</h3>
                                                <div class="display-td" >
                                                    <img class="img-responsive pull-right" src="http://i76.imgup.net/accepted_c22e0.png">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="panel-body">
                                            <form role="form" id="payment-form" method="POST" action="javascript:void(0);">
                                                <div class="row">
                                                    <div class="col-xs-12">
                                                        <div class="form-group">
                                                            <label for="cardNumber">CARD NUMBER</label>
                                                            <div class="input-group">
                                                                <input
                                                                        type="tel"
                                                                        class="form-control"
                                                                        name="cardNumber"
                                                                        placeholder="Valid Card Number"
                                                                        autocomplete="cc-number"
                                                                        required autofocus
                                                                />
                                                                <span class="input-group-addon"><i class="fa fa-credit-card"></i></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-xs-7 col-md-7">
                                                        <div class="form-group">
                                                            <label for="cardExpiry"><span class="hidden-xs">EXPIRATION</span><span class="visible-xs-inline">EXP</span> DATE</label>
                                                            <input
                                                                    type="tel"
                                                                    class="form-control"
                                                                    name="cardExpiry"
                                                                    placeholder="MM / YY"
                                                                    autocomplete="cc-exp"
                                                                    required
                                                            />
                                                        </div>
                                                    </div>
                                                    <div class="col-xs-5 col-md-5 pull-right">
                                                        <div class="form-group">
                                                            <label for="cardCVC">CV CODE</label>
                                                            <input
                                                                    type="tel"
                                                                    class="form-control"
                                                                    name="cardCVC"
                                                                    placeholder="CVC"
                                                                    autocomplete="cc-csc"
                                                                    required
                                                            />
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-xs-12">
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                                            <span aria-hidden="true">&times;</span>
                                                            <button type="button" class="btn btn-success">Send</button>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row" style="display:none;">
                                                    <div class="col-xs-12">
                                                        <p class="payment-errors"></p>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
            </div>
        </div>
    </div>
</div>
<!-- CREDIT CARD FORM ENDS HERE -->

                    </fieldset>
                </form>
            </div>
        </div>
</body>
</html>