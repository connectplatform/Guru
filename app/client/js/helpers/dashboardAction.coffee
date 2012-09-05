define ->
  (action, next) ->
    next ?= (err, data) ->
      window.location.hash = '/operatorChat' if data

    $(".#{action}").click (evt) ->
      evt.preventDefault()
      chatId = $(this).attr 'chatId'
      server[action] chatId, (err, data) ->
        console.log "Error on '#{action}': #{err}" if err?
        next err, data
