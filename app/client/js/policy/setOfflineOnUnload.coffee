define ['load/server'], (server) ->
  ->
    $(window).unload ->
      server.setSessionOffline {sessionId: $.cookies.get('session')}, ->
