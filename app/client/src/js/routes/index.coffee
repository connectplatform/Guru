define ["load/server", "load/notify"], (server, notify) ->
  ({role}, templ) ->

    switch role
      when 'Visitor'
        window.location.hash = '/newChat'
      when 'None'
        window.location.hash = '/login'
      else
        window.location.hash = '/dashboard'
