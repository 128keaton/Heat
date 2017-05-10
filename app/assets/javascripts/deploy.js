$(document).ready(function() {
  $('#submit').attr('disabled', 'disabled');
  $('#machine_rack').bind('input', function() {
    if ($('#machine_rack').val().length > 0) {
      return $('#submit').removeAttr('disabled');
    } else {
      return $('#submit').attr('disabled', 'disabled');
    }
  });
    $("#machine_rack").focus();
});