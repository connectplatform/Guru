define ["guru/server", "templates/newChat"], (server, newChat) ->
  ({id}, templ) ->
    $("#content").html templ()

    server.refresh (services)->
      console.log "username: #{server.cookie 'username'}"
      console.log "services: #{services}"
      $("#message-form").submit ->
        unless $("#message").val() is ""
          message = $("#message").val()
          server[id] message, (err, data) ->
            console.log err if err and console?
          $("#message").val("")
        false

      server.subscribe[id] (err, data)->
        console.log "recieved from user: #{data.username}"
        $("#chat-display-box").append "<p>#{unescape(data.username)}: #{data.message}</p>"