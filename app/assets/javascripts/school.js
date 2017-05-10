$(document).ready(function () {
    $('#submit').attr('disabled', 'disabled');
    $('#machine_serial_number').bind('input', function () {
        if ($('#machine_serial_number').val().length === 7) {
            return $('#submit').removeAttr('disabled');
        } else {
            return $('#submit').attr('disabled', 'disabled');
        }
    });
    $("#machine_serial_number").focus();
});