
<!DOCTYPE html>
<html>
<head>
    <title>index2</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" type="text/css" href="style.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
    <body>
    <%@include file="include/navbar.html" %>



        <div class="container" style="width: 80%; " >
            <div class="row" id="inner1" style="width: 100%">
                <div class="col-md-12">
                    <div id="myCarousel" class="carousel slide" data-ride="carousel " >
                        <!-- Indicators -->
                        <ol class="carousel-indicators">
                            <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                            <li data-target="#myCarousel" data-slide-to="1"></li>
                            <li data-target="#myCarousel" data-slide-to="2"></li>
                        </ol>

                        <!-- Wrapper for slides -->
                        <div class="carousel-inner" style="border: 10px black" >
                            <div class="item active" >
                                <img src="img/family-weekend.jpg" alt="family weekend" style="width:100%;">
                            </div>

                            <div class="item">
                                <img src="img/spicy_friday.jpg" alt="spicy friday" style="width:100%; ">
                            </div>

                            <div class="item">
                                <img src="img/student_hour.jpg" alt="student hour" style="width:100%; ">
                            </div>
                        </div>

                        <!-- Left and right controls -->
                        <a class="left carousel-control" href="#myCarousel" data-slide="prev">
                            <span class="glyphicon glyphicon-chevron-left"></span>
                            <span class="sr-only">Previous</span>
                        </a>
                        <a class="right carousel-control" href="#myCarousel" data-slide="next">
                            <span class="glyphicon glyphicon-chevron-right"></span>
                            <span class="sr-only">Next</span>
                        </a>
                    </div>
                </div>
            </div><br>
        </div><br>


        <div class="row"; align="center">
            <!-- <a href="#" class="btn" role="button" style="background-color: lawngreen; width: 90%; ">Food Menu</a><br><br> -->
            <a href="guest.jsp" class="btn" role="button" style="background: greenyellow; width: 90%; align-content: center">Order food</a>
        </div><br><br>

<%@include file="include/footer.html" %>

    </body>
</html>

<!--
<html>
<head>
<style>
#header {width: 100%; height: 100px; background-color: red;}
#col-1 {width: 50%; float: left; height: 400px; background-color: green;}
#col-2 {width: 50%; float: right; height: 400px; background-color: blue;}
/* Height can be changed but width cannot */
</style>
</head>
<body>
<div id="header"><h1>This is a header</h1></div>
<div id="col-1"><h1>This is half of a page</h1></div>
<div id="col-2"><h1>This is another half of a page</h1></div>

</html>
</body> -->



<!--


        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <div class="navbar-header">
                    <a class="navbar-brand" hrindex.jsphtml">FastTrack</a>
                </div>

                <div class="top-bar">
                    <ul class="nav navbar-nav">



                        <!--<li class="active"><a href="#">Home</a></li> -->
<!-- <li><a href="guest.jsp">Guest</a></li>
<li><a href="employee.jsp?employeeType=chef">Chef</a></li>
<li><a href="employee.jsp?employeeType=waiter">Waiter</a></li>
</ul>
</div>
</div>
</nav> -->
