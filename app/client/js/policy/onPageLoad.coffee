define ["policy/registerSessionUpdates", "policy/setOfflineOnUnload" ],
 (registerSessionUpdates, setOfflineOnUnload) ->
   registerSessionUpdates()
   setOfflineOnUnload()
