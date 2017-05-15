$(document).ready(function () {
  $('#submit').attr('disabled', 'disabled');
  $('#submit-choose').attr('disabled', 'disabled');

  $('#machine_serial_number').bind('input', function () {
    if ($('#machine_serial_number').val().length == 7 && $('#machine_pallet_id').val().length > 0) {
      return $('#submit').removeAttr('disabled');
    } else {
      return $('#submit').attr('disabled', 'disabled');
    }
  });

  $('#machine_pallet_id').bind('input', function () {
    if ($('#machine_pallet_id').val().length > 0) {
      return $('#submit-choose').removeAttr('disabled');
    } else {
      return $('#submit-choose').attr('disabled', 'disabled');
    }
  });

  $("#machine_serial_number").focus();

});