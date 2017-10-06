    <%@page import="java.util.Date, java.util.Calendar, java.text.SimpleDateFormat" %>
        <!DOCTYPE html>
<html>
<head>
    <title>guest</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!--<link rel="stylesheet" type="text/css" href="style.css"> -->

    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="style.css">
    <!-- Google Map -->


    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!--<script src="jquery-3.2.1.min.js"></script> -->

    <script language="javascript">
        $(document).ready(function() {
            getDishes();

            $("#submit").click(function () {
                var num_guests = $("#guestNumber").val();

                var appertizer = $("#appetizer").val();
                var mainCourse = $("#maincourse").val();
                var dessert = $("#dessert").val();
                var drink = $("#drinks").val();

                var now = new Date();

                var fullOrder = {
                    customer_id: 1,
                    table_number: 1,
                    from_time: now,
                    to_time: now,
                    dishes: {
                                [appertizer]: num_guests,
                                [mainCourse]: num_guests,
                                [dessert]: num_guests,
                                [drink]: num_guests
                            },
                };
                console.dir(JSON.stringify(fullOrder));
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

        });

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

            $.get("rest/thepath/orders/order/findTable/" + $("#serveringdate").val() + "/" + $("#timeSlot").val(), function (table_number){
                $("#table_number").val(table_number);
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




    </script>

    <meta name="viewport" content="width=device-width, initial-scale=1">

</head>

<body>

<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="index.html">FastTrack</a>
        </div>

        <div class="top-bar">
            <ul class="nav navbar-nav">
                <!--<li class="active"><a href="#">Home</a></li>-->
                <li><a href="guest.jsp">Guest</a></li>
                <li><a href="employee.jsp">Chef</a></li>
                <li><a href="employee.jsp">Waiter</a></li>
            </ul>
        </div>
    </div>
</nav>





<div class="container" style="width: 90%;">
    <div class="row" id="inner1" style="width: 100%">
        <h5 align="center">Accurate meals, for you and yours...</h5>
        <form>
            <fieldset>
                <legend> Personalia: </legend>
                Name: <input type="text" id="name"><br>


                Number of guests:
                <select id="guestNumber">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                </select><br>


                Servingtime (date and time):
                <input type="date" id="serveringdate" value="<%

                Date d = new Date();

Calendar cal = Calendar.getInstance();
cal.add(Calendar.DATE, 7);
Date date = cal.getTime();
SimpleDateFormat ft = new SimpleDateFormat("YYYY-MM-dd");


                out.print(ft.format(date));



%>">
                <!--<input type="submit" value="Send"> -->

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
                        Cardnumber: <input type="text" id="cardnumber"><br>
                        Exp. Year:
                        <select id="cardYear">
                            <option value="2017">2017 </option>
                            <option value="2018">2018 </option>
                            <option value="2019">2019 </option>
                            <option value="2020">2020 </option>
                            <option value="2021">2021 </option>
                            <option value="2022">2022 </option>
                            <option value="2023">2023 </option>
                            <option value="2024">2024 </option>
                        </select>
                        Exp. Month:
                        <select id="cardMonthr">
                            <option value="1">Jan </option>
                            <option value="2">Feb </option>
                            <option value="3">March </option>
                            <option value="4">April </option>
                            <option value="5">Mai </option>
                            <option value="6">June </option>
                            <option value="7">Juli </option>
                            <option value="7">Aug </option>
                            <option value="9">Sept </option>
                            <option value="10">Oct </option>
                            <option value="11">Nov </option>
                            <option value="12">Dec </option>
                        </select><br>
                        CVS: <input type="text" id="cvs"><br><br>








                    <input id="submit" type="button" value="Confirm reservation"><br>
            </fieldset>
        </form>


        </div>




    </div>


</div><br>




<nav class="navbar navbar-default" >
    <div class="container-fluid">
        <div class="bunn-bar">
            <ul class="nav navbar-nav" >
                <!--<li class="active"><a href="#">Home</a></li>-->
                <li><a href="#">About</a></li>
                <li><a href="#">News</a></li>
                <li><a href="#">Events</a></li>
                <li><a href="#">Contact</a></li>
            </ul>
        </div>
    </div>
</nav>

</body>