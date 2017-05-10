$(document).ready(function () {
    $('.text-input').keypress(function (event) {
        var currentBoxNumber, nextBox, textboxes;
        if (event.keyCode === 13) {
            textboxes = $('.text-input');
            debugger;
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
    var $fields = $(".text-input");
    $fields.keyup(function () {
        var $emptyFields = $fields.filter(function () {
            return $.trim(this.value) === "";
        });

        if (!$emptyFields.length && $("#machine_serial_number").val().length == 7) {
            $('#submit').removeAttr('disabled');
        } else {
            $('#submit').attr('disabled', 'disabled');
        }
    });

      $fields[0].focus();

});