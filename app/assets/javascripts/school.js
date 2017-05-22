$(document).ready(function() {
    $('#submit').attr('disabled', 'disabled');
    $('#machine_serial_number').bind('input', function() {
        if ($('#machine_serial_number').val().length === 7 && $('#machine_client_asset_tag').val()) {
            return enable_field();
        } else {
            return disable_field();
        }
    });
    $('#machine_client_asset_tag').bind('input', function() {
        if ($('#machine_serial_number').val().length === 7 && $('#machine_client_asset_tag').val()) {
            return enable_field();
        } else {
            return disable_field();
        }
    });

    if (!$('#notice\\ error').length) {
        $("#machine_serial_number").focus();
        console.log("doogle");
    } else {
        document.activeElement.blur();
        window.Keyboard.hide();
        $("input").blur();
    }

    $('.text-input').keypress(function(event) {
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

function enable_field() {
    return $('#submit').removeAttr('disabled');
}

function disable_field() {
    return $('#submit').attr('disabled', 'disabled');
}