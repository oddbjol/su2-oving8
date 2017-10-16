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

                // If the dish is about to be served/prepared AND we are looking at today's orders, add some information about how much time remains.
                var ready_text = "";
                if(rowIsPending(tableRow) && isToday(currentDate)){
                    var minutesRemaining = minutesUntil(tableRow.serve_time);
                    if(minutesRemaining < 0)
                        ready_text = -minutesRemaining + "m late!";
                    else
                        ready_text = " (in " + minutesRemaining + "m)";
                }


                row_element.append("<td> Table " + tableRow.table_number + " (" + tableRow.seats + " seats) </td>\n");
                row_element.append("<td>" + tableRow.customer_name + "</td>\n");
                row_element.append("<td>" + tableRow.dish_name + "</td>\n");
                row_element.append("<td>" + tableRow.serve_time + ready_text + "</td>\n");

                row_elements.push(row_element);

            }

            $("#tbody").empty();

            for(var i = 0; i < row_elements.length; i++)
                $("#tbody").append(row_elements[i]);

        },
        error: function(jqXHR, textStatus, errorThrown){console.log(textStatus); console.log(errorThrown);}
    });
}

// Returns time remaining until timeString.
// TimeString is a string representing a time like "20:15"
function minutesUntil(timeString){

    var date = new Date();

    date.setHours(timeString.split(":")[0]);
    date.setMinutes(timeString.split(":")[1]);

    var right_now = new Date();

    var date_ms = date.getTime();
    var now_ms = right_now.getTime();

    var milliseconds_remaining = date_ms - now_ms;


    var hours_remaining = Math.round(milliseconds_remaining / (1000 * 60 * 60));
    var minutes_remaining = Math.round(milliseconds_remaining / (1000 * 60));

    return minutes_remaining;
}