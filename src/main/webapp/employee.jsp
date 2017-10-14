
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


        <!-- jQuery library -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

        <!-- Latest compiled JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <!--<script src="jquery-3.2.1.min.js"></script> -->

        <style>
        .inactive-row{
        color: gray;
        }
        .active-row{
        color: black;
        background-color: lightgreen;
        }
        .regularRow{
        color: black;
        }
        .active-row:hover{
        background-color: lightgreen !important;
        filter: brightness(90%);
        }
        </style>

        <script language="javascript">


        $(document).ready(function() {

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
        var todayString = convertDateToString(new Date());
        var givenString = convertDateToString(date);

        return (todayString === givenString);
        }


        // Gets ISO date string (with ONLY the date, not time) from given date object.
        function convertDateToString(date) {
        var fullString = date.toISOString(); // Returns something like 2011-10-05T14:48:00.000Z
        return fullString.split("T")[0];    // Returns something like 2011-10-05
        }


        // Returns true if the row is something that is about to be served (in the next 30 mins)
        function rowIsPending(tableRow){
        var timeToServe = new Date(convertDateToString(currentDate) + "T" + tableRow.serve_time);
        var now = new Date();
        var nowEnd = new Date(now.getTime() + 1000 * 60 * 30); // now + 30 mins

        return (now < timeToServe && timeToServe < nowEnd);

        }

        // Download the rows for the currentDate from the database, and insert them into our table.
        function loadOrders(date){

        var dateString = convertDateToString(date);

        $("#worklist-title").html("Orders for " + (isToday(date) ? "today" : dateString));

        $.ajax({
        dataType: "json",
        url: "rest/thepath/orders/" + dateString,
        success: function (rows) {
        var html = "";

        for (var tableRow of rows){
        // If current user is not waiter, skip the drinks (type 3)
            <%
                            if(request.getParameter("employeeType") != null && !request.getParameter("employeeType").toLowerCase().equals("waiter")){
                                out.println("if(tableRow.dish_type == 3) continue;");
                            }
                        %>
        // If current date is today, then split the rows into inactive and active rows. Otherwise, show regular rows.
        // A row is active if it's "pending" (about to be served).
        html += "<tr class='" + (isToday(currentDate) ? (rowIsPending(tableRow) ? "active-row" : "inactive-row") : ("regularRow")) +"'>\n";
        html +=  "<td>" + tableRow.table_number + "</td>\n";
        html +=  "<td>" + tableRow.customer_name + "</td>\n";
        html +=  "<td>" + tableRow.dish_name + "</td>\n";
        html +=  "<td>" + tableRow.serve_time + "</td>\n";
        html += "</tr>\n";
        }

        $("#tbody").html(html);

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