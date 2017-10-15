<!DOCTYPE html>
<html>
<head>
    <title>employee</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" href="css/styleemployee.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script language="javascript">

    var waiter = false; // it's set to true in the below jsp if current user is waiter.
                        // This boolean is then used later on in employeescript.js
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
                <div style="display: table; margin: auto;">
                    <input type="button" class="btn btn-primary" id="prevDay" value="<" style="display: table-cell; vertical-align: middle;">
                    <input type="date" id="selectDay" style="display: table-cell; vertical-align: middle; height: 100%">
                    <input type="button" class="btn btn-primary" id="nextDay" value=">" style="display: table-cell; vertical-align: middle;">
                </div>
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

    <%@include file="include/footer.html" %>
</body>