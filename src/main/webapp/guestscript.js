$(document).ready(function() {
    document.getElementById("username").focus();

    $("#view_button").bind("mousedown touchstart", function() {
        $("#password").attr("type", "text");
    }), $("#view_button").bind("mouseup touchend", function() {
        $("#password").attr("type", "password");
    });

    //-- Click on QUANTITY
    $(".btn-minus").on("click",function(){
        var now = $(".section > div > input").val();
        if ($.isNumeric(now)){
            if (parseInt(now) -1 > 0){ now--;}
            $(".section > div > input").val(now);
        }else{
            $(".section > div > input").val("1");
        }
    })
    $(".btn-plus").on("click",function(){
        var now = $(".section > div > input").val();
        if ($.isNumeric(now)){
            $(".section > div > input").val(parseInt(now)+1);
        }else{
            $(".section > div > input").val("1");
        }
    })


});
function  valUsername(){
    if(document.getElementById("username").value.trim()==="" && document.getElementById("username").value!==null)
    {
        $('#responseFail').val('');
        $('#username').val('');

        // $("#above").addClass('hidden');
        $('#message').css('color','red');
        $('#message').html('Please enter username');

        $('input:text').focus(
            function(){
                $(this).css({'border-color' : 'red'});
                $(this).css({'box-shadow' : 'inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px #f15f5f'});
            });

        $('input:text').blur(
            function(){
                $(this).css({'border-color' : '#ccc'});
                $(this).css({'box-shadow' : 'none'});
            });

        $('#username').css({'border-color' : 'red'});
        $('#username').css({'box-shadow' : 'inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px #f15f5f'});
        document.getElementById("username").focus();
        return false;
    }
    else{
        var name = $('#username').val();
        if(name=="admin" || name =="Admin" || name=="ADMIN"){
            //$("#above").removeClass('hidden');
            $('#message').html('');
            $('input:text').focus(
                function(){
                    $(this).css({'border-color' : 'red'});
                    $(this).css({'box-shadow' : 'inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px #f15f5f'});
                });
            document.getElementById("username").focus();
            $('#responseFail').css({'color' : 'red'});
            $('#responseFail').text('You have entered invalid username');

        }
        else{
            $('#responseFail').css({'color' : '#555'});
            $('#responseFail').text('Enter the password for '+name);

            $("#first").addClass('hidden');
            //  $("#above").addClass('hidden');
            $("#first1").addClass('hidden');
            $("#first2").addClass('hidden');
            $("#first3").addClass('hidden');//to hide

            // $("#myId").removeClass('hidden');	//to show
            $("#myId1").removeClass('hidden');
            $("#myId2").removeClass('hidden');
            $("#myId3").removeClass('hidden');
            $("#myId4").removeClass('hidden');

            $("#myId8").removeClass('hidden');
            $('#message').html('');
            // $('#message1').html('');

            $('input:password').focus(
                function(){
                    $(this).css({'border-color' : '#66afe9'});
                    $(this).css({'box-shadow' : 'inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102,175,233,.6)'});
                });
            $('input:password').blur(
                function(){
                    $(this).css({'border-color' : '#ccc'});
                    $(this).css({'box-shadow' : 'none'});
                });

            $('Response').html('Enter the password for');
            document.getElementById("password").focus();
        }
    }
}
function prevPage() {
    $('#message').html('');
    // $('#message1').html('');
    $('#password').val('');
    $('#responseFail').val('');

    $("#first").removeClass('hidden');
    $("#first1").removeClass('hidden');
    $("#first2").removeClass('hidden');
    $("#first3").removeClass('hidden');//to hide

    //$("#myId").addClass('hidden');	//to show
    $("#myId1").addClass('hidden');
    $("#myId2").addClass('hidden');
    $("#myId3").addClass('hidden');
    $("#myId4").addClass('hidden');

    $("#myId8").addClass('hidden');
    $('#ajaxResponse').css('color','#555');
    $('input:text').focus(
        function(){
            $(this).css({'border-color' : '#66afe9'});
            $(this).css({'box-shadow' : 'inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(102,175,233,.6)'});
        });
    $('input:text').blur(
        function(){
            $(this).css({'border-color' : '#ccc'});
            $(this).css({'box-shadow' : 'none'});
        });

    // document.getElementById("username").blur();// to remove auto focus on usename after back is clicked
    document.getElementById("username").focus();





}
function loginStatus(){
    alert("This is a demo login application");
    return false;

}



/*
Credit card js
 */

var $form = $('#payment-form');
$form.find('.subscribe').on('click', payWithStripe);

/* If you're using Stripe for payments */
function payWithStripe(e) {
    e.preventDefault();

    /* Abort if invalid form data */
    if (!validator.form()) {
        return;
    }

    /* Visual feedback */
    $form.find('.subscribe').html('Validating <i class="fa fa-spinner fa-pulse"></i>').prop('disabled', true);

    var PublishableKey = 'pk_test_6pRNASCoBOKtIshFeQd4XMUh'; // Replace with your API publishable key
    Stripe.setPublishableKey(PublishableKey);

    /* Create token */
    var expiry = $form.find('[name=cardExpiry]').payment('cardExpiryVal');
    var ccData = {
        number: $form.find('[name=cardNumber]').val().replace(/\s/g,''),
        cvc: $form.find('[name=cardCVC]').val(),
        exp_month: expiry.month,
        exp_year: expiry.year
    };

    Stripe.card.createToken(ccData, function stripeResponseHandler(status, response) {
        if (response.error) {
            /* Visual feedback */
            $form.find('.subscribe').html('Try again').prop('disabled', false);
            /* Show Stripe errors on the form */
            $form.find('.payment-errors').text(response.error.message);
            $form.find('.payment-errors').closest('.row').show();
        } else {
            /* Visual feedback */
            $form.find('.subscribe').html('Processing <i class="fa fa-spinner fa-pulse"></i>');
            /* Hide Stripe errors on the form */
            $form.find('.payment-errors').closest('.row').hide();
            $form.find('.payment-errors').text("");
            // response contains id and card, which contains additional card details
            console.log(response.id);
            console.log(response.card);
            var token = response.id;
            // AJAX - you would send 'token' to your server here.
            $.post('/account/stripe_card_token', {
                token: token
            })
            // Assign handlers immediately after making the request,
                .done(function(data, textStatus, jqXHR) {
                    $form.find('.subscribe').html('Payment successful <i class="fa fa-check"></i>');
                })
                .fail(function(jqXHR, textStatus, errorThrown) {
                    $form.find('.subscribe').html('There was a problem').removeClass('success').addClass('error');
                    /* Show Stripe errors on the form */
                    $form.find('.payment-errors').text('Try refreshing the page and trying again.');
                    $form.find('.payment-errors').closest('.row').show();
                });
        }
    });
}
/* Fancy restrictive input formatting via jQuery.payment library*/
$('input[name=cardNumber]').payment('formatCardNumber');
$('input[name=cardCVC]').payment('formatCardCVC');
$('input[name=cardExpiry').payment('formatCardExpiry');

/* Form validation using Stripe client-side validation helpers */
jQuery.validator.addMethod("cardNumber", function(value, element) {
    return this.optional(element) || Stripe.card.validateCardNumber(value);
}, "Please specify a valid credit card number.");

jQuery.validator.addMethod("cardExpiry", function(value, element) {
    /* Parsing month/year uses jQuery.payment library */
    value = $.payment.cardExpiryVal(value);
    return this.optional(element) || Stripe.card.validateExpiry(value.month, value.year);
}, "Invalid expiration date.");

jQuery.validator.addMethod("cardCVC", function(value, element) {
    return this.optional(element) || Stripe.card.validateCVC(value);
}, "Invalid CVC.");

validator = $form.validate({
    rules: {
        cardNumber: {
            required: true,
            cardNumber: true
        },
        cardExpiry: {
            required: true,
            cardExpiry: true
        },
        cardCVC: {
            required: true,
            cardCVC: true
        }
    },
    highlight: function(element) {
        $(element).closest('.form-control').removeClass('success').addClass('error');
    },
    unhighlight: function(element) {
        $(element).closest('.form-control').removeClass('error').addClass('success');
    },
    errorPlacement: function(error, element) {
        $(element).closest('.form-group').append(error);
    }
});

paymentFormReady = function() {
    if ($form.find('[name=cardNumber]').hasClass("success") &&
        $form.find('[name=cardExpiry]').hasClass("success") &&
        $form.find('[name=cardCVC]').val().length > 1) {
        return true;
    } else {
        return false;
    }
}

$form.find('.subscribe').prop('disabled', true);
var readyInterval = setInterval(function() {
    if (paymentFormReady()) {
        $form.find('.subscribe').prop('disabled', false);
        clearInterval(readyInterval);
    }
}, 250);
