define ["guru/server", "templates/newChat"], (server, newChat) ->
  (_, templ) ->
    $("#content").html "Loading..."
    server.refresh -> 
      $("#content").html templ()
      $("#newChat-form #username").focus()

      $("#newChat-form").submit ->
        username = $("#newChat-form #username").val()
        console.log "username:#{username}"
        server.newChat username: username, (err, data) ->
          window.location.hash = "/visitorChat/#{data.channel}"

        $("#newChat-form").hide()
        $("#content").html "Connecting to chat..."
        false