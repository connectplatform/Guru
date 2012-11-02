define ['load/server', 'load/notify'], (server, notify) ->
  ({chatId}, templ) ->
    server.ready ->
      server.printChat {chatId: chatId}, (err, htmlData) ->
        notify.error "Error formatting chat for printing: ", err if err?
        $('#renderedContent').html htmlData
        window.print()
