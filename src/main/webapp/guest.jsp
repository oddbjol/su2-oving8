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
            findTable();

            $("#submit").click(function () {
                var num_guests = $("#guestNumber").val();

                var appertizer = $("#appetizer").val();
                var mainCourse = $("#maincourse").val();
                var dessert = $("#dessert").val();
                var drink = $("#drinks").val();

                var now = new Date();

                var fullOrder = {
                    customer_name: $("#name").val(),
                    table_number: $("#table_number").val(),
                    from_time: getStartTime(),
                    to_time: getEndTime(),
                    num_guests: num_guests,
                    dishes: {
                                [appertizer]: num_guests,
                                [mainCourse]: num_guests,
                                [dessert]: num_guests,
                                [drink]: num_guests
                            },
                };

        console.dir(fullOrder);
        console.log(JSON.stringify(fullOrder));

                var url = "rest/thepath/singleOrder";


                var account = {
                    number: $("#cardnumber").val(),
                    cvs: $("#cvs").val()
                };

                $.ajax({
                    url: 'rest/thepath/account/check/' + $("#totalCost").val(),
                    type: 'POST',
                    data: JSON.stringify(account),
                    contentType: 'application/json; charset=utf-8',
                    //dataType: 'json',
                    success: function(success){
                        if(success){
                            $.ajax({
                                url: url,
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
                  //  var option = "<option value='" + dish.id + "'>" + dish.name + " (" + dish.price + " NOK)</option>";
                    console.log(option);
                    //console.log(option); //For strenger og tall
                    //$("#appetizer").append(option);
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
                    //$("#drinks").append(option);
                    }

                        updateCost();
                    });
                });
            });
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
                                <table id="cart" class="table table-hover table-condensed">
                                    <thead id="mainCourse">
                                    <tr>
                                        <th style="width:50%">Main course</th>
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
                                            <input type="number" id="q1" class="form-control text-center" value="1">
                                        </td>
                                        <td data-th="Subtotal" id="subTot1" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-success btn-sm">+<i class="fa fa-trash-o"></i></button>
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
                                            <input type="number" id="q2" class="form-control text-center" value="1">
                                        </td>
                                        <td data-th="Subtotal" id="subTot2" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-success btn-sm">+<i class="fa fa-trash-o"></i></button>
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
                                            <input type="number" id="q3" class="form-control text-center" value="1">
                                        </td>
                                        <td data-th="Subtotal" id="subTot3" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-success btn-sm">+<i class="fa fa-trash-o"></i></button>
                                        </td>
                                    </tr>
                                    </tbody>



                                    <thead id="appetizer">
                                    <tr>
                                        <th style="width:50%">Appetizers</th>
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
                                                    <h4 class="nomargin">Shrimps</h4>
                                                    <p>ivamus rhoncus, turpis at vehicula tincidunt, mauris lorem aliquet dolor</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="Price">99,-</td>
                                        <td data-th="Quantity">
                                            <input type="number" id="q4" class="form-control text-center" value="1">
                                        </td>
                                        <td data-th="Subtotal" id="subTot4" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-success btn-sm">+<i class="fa fa-trash-o"></i></button>
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
                                            <input type="number" id="q5" class="form-control text-center" value="1">
                                        </td>
                                        <td data-th="Subtotal" id="subTot5" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-success btn-sm">+<i class="fa fa-trash-o"></i></button>
                                        </td>
                                    </tr>
                                    </tbody>


                                    <thead id="Dessert">
                                    <tr>
                                        <th style="width:50%">Dessert</th>
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
                                                    <h4 class="nomargin">Beer</h4>
                                                    <p>Because beer is good for everyone</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="Price">79,-</td>
                                        <td data-th="Quantity">
                                            <input type="number" id="q6" class="form-control text-center" value="1">
                                        </td>
                                        <td data-th="Subtotal" id="subTot6" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-success btn-sm">+<i class="fa fa-trash-o"></i></button>
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
                                            <input type="number" id="q7" class="form-control text-center" value="1">
                                        </td>
                                        <td data-th="Subtotal" id="subTot7" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-success btn-sm">+<i class="fa fa-trash-o"></i></button>
                                        </td>
                                    </tr>
                                    </tbody>

                                    <thead id="Drinks">
                                    <tr>
                                        <th style="width:50%">Drinks</th>
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
                                                    <h4 class="nomargin">Shrimps</h4>
                                                    <p>ivamus rhoncus, turpis at vehicula tincidunt, mauris lorem aliquet dolor</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="Price">99,-</td>
                                        <td data-th="Quantity">
                                            <input type="number" id="q8" class="form-control text-center" value="1">
                                        </td>
                                        <td data-th="Subtotal" id="subTot8" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-success btn-sm">+<i class="fa fa-trash-o"></i></button>
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
                                            <input type="number" id="q9" class="form-control text-center" value="1">
                                        </td>
                                        <td data-th="Subtotal" id="subTot9" class="text-center"></td>
                                        <td class="actions" data-th="">
                                            <button class="btn btn-success btn-sm">+<i class="fa fa-trash-o"></i></button>
                                        </td>
                                    </tr>
                                    </tbody>


                                    <tfoot>
                                    <tr class="visible-xs">
                                        <td class="text-center"><strong>Total 1.99</strong></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="hidden-xs"></td>
                                        <td class="hidden-xs text-center" id="Pay"><strong>Total $1.99</strong></td>
                                        <td><button id="" class="btn btn-danger btn-block" data-toggle="modal" data-target="#myModal">Pay <i class="fa fa-angle-right"></i></button></td>
                                        <!--onclick="javascript:return loginStatus()"-->
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
<!-- Credit card starts here -->
                        <!-- You can make it whatever width you want. I'm making it full width
                                    on <= small devices and 4/12 page width on >= medium devices -->
                        <div class="col-xs-12 col-md-4">


                            <!-- CREDIT CARD FORM STARTS HERE -->
                            <div class="modal fade" id="myModal" role="dialog">
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
                                                <div class="form-group">
                                                    <label for="couponCode">COUPON CODE</label>
                                                    <input type="text" class="form-control" name="couponCode" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-12">
                                                <button class="subscribe btn btn-success btn-lg btn-block" type="button" >Start Subscription</button>
                                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
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
        <!-- CREDIT CARD FORM ENDS HERE -->

                    </fieldset>
                </form>
            </div>
        </div>
<!--


                Servingtime (date and time):
                <input type="date" id="serveringdate" value=" -->


            <%
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
                    <option value="1">1330 - 1500 </option>
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