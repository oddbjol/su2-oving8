
<!DOCTYPE html>
<html>
<head>
    <title>employee</title>
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

        // Convert order data into individual "row" objects for each dish, and insert them into the table.
        $(document).ready(function() {
            var url = "rest/thepath/orders/" + getTodaysDateString();
            $.get(url, function (slots) {

                for (var slotnr in slots){
                    for(var bordnr in slots[slotnr]){

                        var order = slots[slotnr][bordnr];

                        var appertizer = {
                            tablenr:        bordnr,
                            customerName:   order.customerName,
                            dishname:       "" + order.numberOfGuests + " " + order.appertizer,
                            time:           getTime(slotnr, 0)
                        };

                        var drink = {
                            tablenr:        bordnr,
                            customerName:   order.customerName,
                            dishname:       "" + order.numberOfGuests + " " + order.drink,
                            time:           getTime(slotnr, 0)
                        };

                        var maincourse = {
                            tablenr:        bordnr,
                            customerName:   order.customerName,
                            dishname:       "" + order.numberOfGuests + " " + order.mainCourse,
                            time:           getTime(slotnr, 30)
                        };

                        var dessert = {
                            tablenr:        bordnr,
                            customerName:   order.customerName,
                            dishname:       "" + order.numberOfGuests + " " + order.dessert,
                            time:           getTime(slotnr, 60)
                        };



                        insertIntoTable(appertizer);

                        // Only show drinks if the current user is a waiter.
                        <%
                            if(request.getParameter("employeeType") != null && request.getParameter("employeeType").toLowerCase().equals("waiter")){
                                out.println("insertIntoTable(drink);");
                            }
                        %>

                        insertIntoTable(maincourse);
                        insertIntoTable(dessert);



                    }

                    // Sort by "time" column to get chronological order in table.
                    sortTable(document.getElementById("tbl"), 3, false);

                }
            });
        });

        // https://stackoverflow.com/questions/14267781/sorting-html-table-with-javascript
        function sortTable(table, col, reverse) {
            var tb = table.tBodies[0], // use `<tbody>` to ignore `<thead>` and `<tfoot>` rows
                tr = Array.prototype.slice.call(tb.rows, 0), // put rows into array
                i;
            reverse = -((+reverse) || -1);
            tr = tr.sort(function (a, b) { // sort rows
                return reverse // `-1 *` if want opposite order
                    * (a.cells[col].textContent.trim() // using `.textContent.trim()` for test
                            .localeCompare(b.cells[col].textContent.trim())
                    );
            });
            for(i = 0; i < tr.length; ++i) tb.appendChild(tr[i]); // append each row in order
        }
        // sortTable(tableNode, columId, false);

        function insertIntoTable(dish){

            var html =`
            <tr>
                <td>` + dish.tablenr + `</td>
                <td>` + dish.customerName + `</td>
                <td>` + dish.dishname + `</td>
                <td>` + dish.time + `</td>
            </tr>
            `;

            $("#tbody").append(html);

        }

        function getTime(slotnr, offset){
            var minutesAtNoon = 60 * 12;
            var totalMinutes = minutesAtNoon + slotnr * 90 + offset;

            var hours = Math.floor(totalMinutes / 60);
            var minutes = totalMinutes % 60;

            return "" + hours + ":" + (minutes < 10 ? "0" : "") + minutes;
        }



        /*
         //console.dir(appetizers); // For komplekse objekter
         for (var dish of dishes) {
         pricelist[dish.name] = dish.prize;
         var option = "<option value='" + dish.name + "'>" + dish.name + " (" + dish.prize + " NOK)</option>";
         //console.log(option); //For strenger og tall
         $("#dessert").append(option);
         }

         */

        // Gets ISO date string from today's date
        function getTodaysDateString(){
            return convertDateToString(new Date());
        }

        // Gets ISO date string from given date
        function convertDateToString(date) {
            var year=date.getFullYear();
            var month=date.getMonth();
            var monthadd = (month<9 ? "0": "");
            var day=date.getDate();
            var today= year + "-" + monthadd+(month+1) + "-" + day;
            return today;

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
                <li><a href="employee.jsp?employeeType=chef">Chef</a></li>
                <li><a href="employee.jsp?employeeType=waiter">Waiter</a></li>
            </ul>
        </div>
    </div>
</nav>









<div class="container" style="width: 90%;">
    <div class="row" id="inner1" style="width: 100%">
        <h5 align="center">Worklist</h5>
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