define ["guru/server", "templates/newChat"], (server, newChat) ->
  ({id}, templ) ->
    $("#content").html templ()
    $("#message-form #message").focus()

    server.refresh (services)->
      console.log "username: #{server.cookie 'username'}"
      console.log "services: #{services}"
      $("#message-form").submit ->
        unless $("#message").val() is ""
          message = $("#message").val()
          server[id] message, (err, data) ->
            console.log err if err and console?
          $("#message").val("")
          $("#chat-display-box").scrollTop($("#chat-display-box").prop("scrollHeight"))
        false

      server.subscribe[id] (err, data)->
        console.log "recieved from user: #{data.username}"
        $("#chat-display-box").append "<p>#{unescape(data.username)}: #{data.message}</p>"