define ['load/server'], (server) ->
  (action, next) ->
    next ?= (err, data) ->
      window.location.hash = '/operatorChat' if data

    $(".#{action}").click (evt) ->
      evt.preventDefault()
      chatId = $(this).attr 'chatId'
      server[action] chatId, (err, data) ->
        server.log 'Error performing dashboard action', {error: err, severity: 'warn', action: action} if err
        next err, data
