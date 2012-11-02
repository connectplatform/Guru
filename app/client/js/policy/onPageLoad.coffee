define ['policy/registerSessionUpdates', 'policy/setOfflineOnUnload', 'load/server' ],
 (registerSessionUpdates, setOfflineOnUnload, server) ->
   registerSessionUpdates()
   setOfflineOnUnload()
   server.ready ->
     window.onerror = (message, url, linenumber) ->
       server.log 'Uncaught error on client', {
         error: message
         url: url
         linenumber: linenumber
       }
