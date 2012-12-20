define ['policy/registerSessionUpdates', 'load/server' ],
  (registerSessionUpdates, server) ->
    registerSessionUpdates()
    server.ready ->
      #window.onerror = (message, url, linenumber) ->
        #server.log
          #message: 'Uncaught error on client'
          #context:
            #error: message
            #url: url
            #linenumber: linenumber
