# receive.coffee

# sets the text field disabled if the stuff isn't met
$(document).ready ->
  $('#submit').attr 'disabled', 'disabled'
  $('#machine_serial_number').keyup ->
    if $(this).val().length == 7
      $('#submit').removeAttr 'disabled'
    else
      $('#submit').attr 'disabled', 'disabled'
    return
  return

$(document).ready ->
  $('.text-input').keypress (event) ->
    if event.keyCode == 13
      textboxes = $('input.text-input')
      debugger
      currentBoxNumber = textboxes.index(this)
      if textboxes[currentBoxNumber + 1] != null
        nextBox = textboxes[currentBoxNumber + 1]
        nextBox.focus()
        nextBox.select()
        event.preventDefault()
        return false
    return
  return
