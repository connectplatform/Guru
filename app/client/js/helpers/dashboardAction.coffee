define ['load/server'], (server) ->
  (action, next) ->
    next ?= (err, data) ->
      window.location.hash = '/operatorChat' if data

    $(".#{action}").click (evt) ->
      evt.preventDefault()
      chatId = $(this).attr 'chatId'
      server[action] {chatId: chatId}, (err, data) ->
        if err
          server.log
            message: 'Error performing dashboard action'
            context: {error: err, severity: 'warn', action: action}

        next err, data
