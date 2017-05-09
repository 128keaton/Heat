# receive.coffee

# sets the text field disabled if the stuff isn't met
$(document).ready ->
  $('#machine_serial_number').keyup ->
    if $(this).val().length == 7
      $('#submit').removeAttr 'disabled'
    else
      $('#submit').attr 'disabled', 'disabled'
    return
  return