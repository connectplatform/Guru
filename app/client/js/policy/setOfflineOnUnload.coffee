define ['load/server'], (server) ->
  ->
    $(window).unload ->
      server.setSessionOffline {sessionId: server.cookie('session')}, ->
