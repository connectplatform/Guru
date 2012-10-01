define [], () ->
  print: (chatId) ->
    (evt) ->
      evt.preventDefault()
      location = "https://#{window.location.host}/#/printChat/#{chatId}"
      window.open location
