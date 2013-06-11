define ['load/server'], (server) ->
  ->
    $(window).unload ->
      server.setSessionOffline {sessionSecret: $.cookies.get('session')}, ->
