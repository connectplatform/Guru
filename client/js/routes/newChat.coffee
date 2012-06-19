define ["guru/server", "templates/newChat"], (server, newChat) ->
  (_, templ) ->
    server.ready ->
      $("#content").html templ

      $("#submit").click ->
        username = $("#username").val()
        server.newChat username: username, (err, data) ->
          window.location.hash = "/chat/#{data.channel}"