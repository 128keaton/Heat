$(document).ready(function() {

    $('#machine_serial_number').bind('input', function() {
        if ($(this).val().length > 0) {
            return $('#submit').removeAttr('disabled');
        } else {
            return $('#submit').attr('disabled', 'disabled');
        }
    });

    $("#machine_serial_number").focus();

});

