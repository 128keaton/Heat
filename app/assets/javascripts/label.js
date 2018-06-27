$(function () {
    let serialField = $("#machine_serial_number");

    if (document.getElementById('machine_serial_number')) {
        serialField.focus();
    } else {
        console.log('clear');
        $('#machine_location').find('select').each(function () {
            $(this)[0].selectedIndex = 0;
        });

    }

    $('.text-input').keypress(function (event) {
        let currentBoxNumber, nextBox, textboxes;
        $('#submit').removeAttr('disabled');
        if (event.keyCode === 13) {
            textboxes = $('.text-input');
            currentBoxNumber = textboxes.index(this);
            if (textboxes[currentBoxNumber + 1] !== null) {
                nextBox = textboxes[currentBoxNumber + 1];
                nextBox.focus();
                nextBox.select();
                event.preventDefault();
                return false;
            } else {
                $('form').submit();
            }
        }
    });
});