$(document).ready(function() {
    $('#submit').attr('disabled', 'disabled');
    $('#machine_serial_number').bind('input', function() {
        if ($('#machine_serial_number').val().length === 7 && $('#machine_client_asset_tag').val()) {
            return $('#submit').removeAttr('disabled');
        } else {
            return $('#submit').attr('disabled', 'disabled');
        }
    });
    $('#machine_client_asset_tag').bind('input', function() {
        if ($('#machine_serial_number').val().length === 7 && $('#machine_client_asset_tag').val()) {
            return $('#submit').removeAttr('disabled');
        } else {
            return $('#submit').attr('disabled', 'disabled');
        }
    });
    $("#machine_serial_number").focus();

        $('.text-input').keypress(function (event) {
        var currentBoxNumber, nextBox, textboxes;
        if (event.keyCode === 13) {
            textboxes = $('.text-input');
            currentBoxNumber = textboxes.index(this);
            if (textboxes[currentBoxNumber + 1] !== null) {
                nextBox = textboxes[currentBoxNumber + 1];
                nextBox.focus();
                nextBox.select();
                event.preventDefault();
                return false;
            }
        }
    });
});