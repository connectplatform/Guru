define ["app/server", "app/notify"], (server, notify) ->
  (args, templ) ->
    $('#sidebar').html templ()
