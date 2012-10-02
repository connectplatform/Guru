define ['policy/registerSessionUpdates', 'policy/setOfflineOnUnload', 'load/server' ],
 (registerSessionUpdates, setOfflineOnUnload, server) ->
   registerSessionUpdates()
   setOfflineOnUnload()
   server.ready ->
     window.onerror = (message, url, linenumber) ->
       server.serverLog {
         message: "Uncaught error on client"
         error: message
         url: url
         linenumber: linenumber
       }, ->
