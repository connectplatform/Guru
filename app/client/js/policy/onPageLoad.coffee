define ['policy/registerSessionUpdates', 'policy/setOfflineOnUnload', 'load/server' ],
 (registerSessionUpdates, setOfflineOnUnload, server) ->
   registerSessionUpdates()
   setOfflineOnUnload()
