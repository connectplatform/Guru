define ["load/server", "load/notify"], (server, notify) ->
  (args, templ) ->

    server.ready ->
      server.getMyRole (err, role) ->
        switch role
          when 'Visitor'
            window.location.hash = '/newChat'
          when 'None'
            window.location.hash = '/login'
          else
            window.location.hash = '/dashboard'
