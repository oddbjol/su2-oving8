
<!DOCTYPE html>
<html>
    <head>
        <title>index2</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" type="text/css" href="style.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

        <script src="jquery-3.2.1.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </head>


    <body>

    %@include file="include/navbar.html" %>

        <div class="container" style="width: 80%; align: center" >
            <div class="row" id="inner1" >
                <div class="col-md-12" >
                    <div id="myCarousel" class="carousel slide" data-ride="carousel " >
                        <!-- Indicators -->
                        <ol class="carousel-indicators" >
                            <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                            <li data-target="#myCarousel" data-slide-to="1"></li>
                            <li data-target="#myCarousel" data-slide-to="2"></li>
                        </ol>

                        <!-- Wrapper for slides -->
                        <div class="carousel-inner" >
                            <div class="item active" >
                                <img src="family-weekend.jpg" alt="family weekend" style="width:100%; ">
                            </div>

                            <div class="item">
                                <img src="spicy_friday.jpg" alt="spicy friday" style="width:100%; ">
                            </div>

                            <div class="item">
                                <img src="student_hour.jpg" alt="student hour" style="width:100%; ">
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


        <script>
        $('.carousel').carousel();
        </script>

        <div class="row" align="center" >
            <!-- <a href="#" class="btn" role="button" style="background-color: lawngreen; width: 90%; ">Food Menu</a><br><br> -->
            <a href="guest.jsp" id="orderBtn" class="btn" role="button" > Order food</a>
        </div><br>

    <%@include file="include/footer.html" %>

    </body>
</html>
