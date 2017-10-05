
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
            $.ajax({
                dataType: "json",
                url: url,
                success: function (rows) {

                    for (var tableRow of rows){

                        // Only show drinks if the current user is a waiter.
                        <%
                            if(request.getParameter("employeeType") != null && request.getParameter("employeeType").toLowerCase().equals("waiter")){
                                out.println("insertIntoTable(tableRow);");
                            }
                            else{
                                out.println("if(tableRow.dish_type != 3){insertIntoTable(tableRow);}");
                            }
                        %>
                    }
                },
                error: function(jqXHR, textStatus, errorThrown){console.log(textStatus); console.log(errorThrown);}
                });
        });

        function insertIntoTable(tableRow){

            var html =`
            <tr>
                <td>` + tableRow.table_number + `</td>
                <td>` + tableRow.customer_name + `</td>
                <td>` + tableRow.dish_name + `</td>
                <td>` + tableRow.serve_time + `</td>
            </tr>
            `;

            $("#tbody").append(html);

        }
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