define ["guru/server", "templates/newChat"], (server, newChat) ->
  (_, templ) ->
    $("#content").html templ()

    server.ready ->
      $("#newChat-form").submit ->
        username = $("#username").val()
        server.newChat username: username, (err, data) ->
          window.location.hash = "/chat/#{data.channel}"