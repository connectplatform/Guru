define ['policy/registerSessionUpdates', 'policy/setOfflineOnUnload', 'load/server' ],
  (registerSessionUpdates, setOfflineOnUnload, server) ->
    registerSessionUpdates()
    #setOfflineOnUnload()
    server.ready ->
      #window.onerror = (message, url, linenumber) ->
        #server.log
          #message: 'Uncaught error on client'
          #context:
            #error: message
            #url: url
            #linenumber: linenumber
