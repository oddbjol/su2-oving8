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
                        // This boolean is used in employeescript.js

    <%
        if(request.getParameter("employeeType") != null && request.getParameter("employeeType").toLowerCase().equals("waiter")){
            out.println("waiter = true;");
        }
    %>

    </script>
    <script src="js/employeescript.js"></script>

</head>

<body>

    <%@include file="include/navbar.html" %>

    <div class="container" style="width: 90%;">
        <div class="row" id="inner1" style="width: 100%">
            <h2 align="center" id="worklist-title"></h2>
            <div class="row text-center">
                <input type="date" id="selectDay"><br>
            </div>
            <div class="row text-center">
                <input type="button" id="prevDay" value="<">
                <input type="button" id="today" value=".">
                <input type="button" id="nextDay" value=">">
            </div>
            <table class="table table-responsive table-hover" id="tbl">
                <thead>
                    <th>Table</th>
                    <th>Guest</th>
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