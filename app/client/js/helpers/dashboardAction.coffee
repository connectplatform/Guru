define ['load/server'], (server) ->
  (action, next) ->
    next ||= (err, {chatId}) ->
      window.location.hash = "/operatorChat?chatId=#{chatId}" unless err

    $(".#{action}").click (evt) ->
      evt.preventDefault()
      chatId = $(this).attr 'chatId'
      server[action] {chatId: chatId}, (err, results) ->
        results.merge {chatId: chatId}
        next err, results
