$(document).ready(function() {

    $('#submit').removeAttr('disabled');

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
