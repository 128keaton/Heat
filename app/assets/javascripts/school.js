$(document).ready(function() {
    $('#submit').attr('disabled', 'disabled');

    $('#machine_serial_number').bind('input', function() {
        if ($(this).val().length > 0) {
            return $('#submit').removeAttr('disabled');
        } else {
            return $('#submit').attr('disabled', 'disabled');
        }
    });

    $('#machine_client_asset_tag').bind('input', function() {
        mod_check_for_submit('machine_client_asset_tag', 6);
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
