$(document).ready(function() {
    $('#submit').attr('disabled', 'disabled');
    $('#submit-choose').attr('disabled', 'disabled');

    $('#machine_serial_number').bind('input', function() {
        if ($(this).val().length > 0) {
            return $('#submit').removeAttr('disabled');
        } else {
            return $('#submit').attr('disabled', 'disabled');
        }
    });

    $('#machine_pallet_id').bind('input', function() {
        check_for_submit_choose();
    });

    $("#machine_serial_number").focus();

});


function check_for_submit_choose() {
    if ($('#machine_pallet_id').val().length > 0) {
        return $('#submit-choose').removeAttr('disabled');
    } else {
        return $('#submit-choose').attr('disabled', 'disabled');
    }
}

