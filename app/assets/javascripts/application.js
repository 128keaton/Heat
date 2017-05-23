// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require Chart.bundle
//= require chartkick

$(function() {
    $(document).on('touchstart click', '.alert', function(e) {
        e.stopPropagation();
        $(".alert").slideUp();

    });
    $(document).on('touchstart click', '.notice', function(e) {
        e.stopPropagation();
        $(".notice").slideUp();

    });
});

$(document).ready(function() {
    if ($('#notice\\ error').length) {
        $("#audio-error").trigger('play')
        navigator.vibrate([500]);
        $('#notice\\ error').animate({
            height: '100'
        })
        $('html,body').animate({
            scrollTop: $('#notice\\ error').offset().top
        }, 500);
        document.activeElement.blur();
        window.Keyboard.hide();
        $("input").blur();
    }

});

function check_for_submit(second_field) {
    if ($('#machine_serial_number').val().length === 7 && $('#' + second_field).val()) {
        return $('#submit').removeAttr('disabled');
    } else {
        return $('#submit').attr('disabled', 'disabled');
    }
}