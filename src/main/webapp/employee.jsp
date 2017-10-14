    <!DOCTYPE html>
        <html>
        <head>
        <title>employee</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!--<link rel="stylesheet" type="text/css" href="style.css"> -->

        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <!-- Google Map -->

        <link rel="stylesheet" href="css/styleemployee.css">

        <!-- jQuery library -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

        <!-- Latest compiled JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <!--<script src="jquery-3.2.1.min.js"></script> -->

        <script language="javascript">

        var waiter = false; // it's set to true in the below jsp if current user is waiter.

        <%
            if(request.getParameter("employeeType") != null && request.getParameter("employeeType").toLowerCase().equals("waiter")){
                out.println("waiter = true;");
            }
        %>

        $(document).ready(function() {

            $("#tbody").on("click", "tr", function(){

                var tableRow = $(this).data("tableRow");

                var newStatus = tableRow.status + 1;

                // If dish is waiting to be cooked and current user is chef, OR
                // if dish is waiting to be served and curent user is waiter
                // THEN we want to allow current user to "OK" the dish.
                if(!waiter && tableRow.status == 0 || waiter && tableRow.status == 1){
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        url: "rest/thepath/orders/updateStatus/" + tableRow.order_id + "/" + tableRow.dish_id + "/" + newStatus,
                        success: function(data) {
                            loadOrders(currentDate);
                        }
                    });
                }
            });

            setInterval(function(){
                loadOrders(currentDate);
            }, 1000);

        setCurrentDate(new Date()); // Set the current date to "today" when loading webpage.

        ///////////////////////////////////////// DATE NAVIGATION CODE //////////////////////////////////////

        $("#nextDay").click(function(){
        date = new Date(currentDate.getTime() + 1000 * 60 * 60 * 24); // add one day to current date
        setCurrentDate(date);
        });

        $("#prevDay").click(function(){
        date = new Date(currentDate.getTime() - 1000 * 60 * 60 * 24); // subtract one day from current day
        setCurrentDate(date);
        });

        $("#today").click(function(){
        date = new Date(); //today
        setCurrentDate(date);
        });

        $("#selectDay").change(function(){
        date = new Date($("#selectDay").val());
        setCurrentDate(new Date(date));
        });

        /////////////////////////////////////////////////////////////////////////////////////////////////////

        });

        // Sets the current date and loads the orders for the given date into the table.
        function setCurrentDate(date){
            currentDate = date;

            $("#selectDay").val(convertDateToString(date));
            loadOrders(date);
        }

        // Checks if the given date object is today
        function isToday(date){
            var today = new Date();

            return (today.getFullYear() == date.getFullYear() && today.getMonth() == date.getMonth() && today.getDate() == date.getDate());
        }


        // Gets ISO date string (with ONLY the date, not time) from given date object.
        function convertDateToString(date) {

            var year = date.getFullYear();
            var month = date.getMonth() + 1;
            var day = date.getDate();

            month   =   (month < 10 ? "0"+month : month);
            day     =   (day < 10 ? "0"+day : day);

            return year + "-" + month + "-" + day;
        }


        // Returns true if the row is something that is about to be served (in the next 30 mins)
        function rowIsPending(tableRow){
        var timeToServe = new Date(convertDateToString(currentDate) + "T" + tableRow.serve_time);
        var now = new Date();
        var nowEnd = new Date(now.getTime() + 1000 * 60 * 30); // now + 30 mins

        return (timeToServe < nowEnd);

        }

        // Download the rows for the given date from the database, and insert them into our table.
        function loadOrders(date){

        var dateString = convertDateToString(date);

        $("#worklist-title").html("Orders for " + (isToday(date) ? "today" : dateString));

        $.ajax({
        dataType: "json",
        url: "rest/thepath/orders/" + dateString,
        success: function (rows) {

        var row_elements = [];

        for (var tableRow of rows){

        // If current user is not waiter, skip the drinks (type 3)
        if(!waiter && tableRow.dish_type == 3)
            continue;

        var rowClass;
        // If current date is today, then split the rows into inactive and active rows. Otherwise, show regular rows.
        if(isToday(currentDate) && rowIsPending(tableRow)){
            if(tableRow.status == 0){                    // Waiting for chef
                    if(waiter)
                        rowClass = "waiting-for-others-row";
                    else
                        rowClass = "waiting-for-you-row";
            }
            else if(tableRow.status == 1){               // Waiting for waiter
                if(waiter)
                    rowClass = "waiting-for-you-row";
                else
                    rowClass = "served-row";
            }
            else{                                        // Served
                rowClass = "served-row";
            }
        }
        else{
            rowClass = "inactive-row";
        }

        var row_element = $("<tr>");
        row_element.addClass(rowClass);
        row_element.data("tableRow", tableRow); // IMPORTANT: Add the tableRow object inside the html element as data.

        row_element.append("<td>" + tableRow.table_number + "</td>\n");
        row_element.append("<td>" + tableRow.customer_name + "</td>\n");
        row_element.append("<td>" + tableRow.dish_name + "</td>\n");
        row_element.append("<td>" + tableRow.serve_time + "</td>\n");

        row_elements.push(row_element);

        }

        $("#tbody").empty();

        for(var i = 0; i < row_elements.length; i++)
            $("#tbody").append(row_elements[i]);

        },
        error: function(jqXHR, textStatus, errorThrown){console.log(textStatus); console.log(errorThrown);}
        });
        }



        </script>

        </head>

        <body>

        <%@include file="include/navbar.html" %>










        <div class="container" style="width: 90%;">
        <div class="row" id="inner1" style="width: 100%">
        <h1 align="center" id="worklist-title">Worklist</h1>


        <div class="row text-center">
        <input type="date" id="selectDay"><br>
        </div>
        <div class="row text-center">
        <input type="button" id="prevDay" value="<">
        <input type="button" id="today" value=".">
        <input type="button" id="nextDay" value=">">
        </div>




        <!-- dato-->
        <table class="table table-responsive table-hover" id="tbl">
        <thead>
        <th>Table nr:</th>
        <th>Guest name</th>
        <th>Dish</th>
        <th>Serving time</th>
        </thead>

        <tbody id="tbody">

        </tbody>
        </table>

        </div>
        </div>


        </div><br>

        <%@include file="include/footer.html" %>
        </body>