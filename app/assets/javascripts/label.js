$(function () {
    $('.text-input').keypress(function(event) {
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
            }else{
                $('form').submit();
            }
        }
    });
});