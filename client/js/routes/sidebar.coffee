define ["guru/server", "guru/notify"], (server, notify) ->
  (args, templ) ->

      $('#sidebar').html templ()
      #$('#sidebar').show()
