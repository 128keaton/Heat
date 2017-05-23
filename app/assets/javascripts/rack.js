$(document).ready(function() {
    $('#submit').attr('disabled', 'disabled');
    $('#machine_serial_number').bind('input', function() {
        check_for_submit('machine_serial_number');
    });
    $("#machine_serial_number").focus();

});
