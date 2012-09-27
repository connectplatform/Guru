define ['load/server'], (server) ->
  ->
    $(window).unload ->
      server.setSessionOffline server.cookie('session')
