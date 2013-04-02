define ['load/server', 'load/notify'], (server, notify) ->
  ({chatId}, templ) ->
    server.ready ->
      server.printChat {chatId: chatId}, (err, {html}) ->
        notify.error "Error formatting chat for printing: ", err if err?
        $('#content').html html
        window.print()
