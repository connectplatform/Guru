define ["app/server", "templates/newChat", "templates/chatBox"], (server, newChat, chatBox) ->
  ({id}, templ) ->
    $("#content").html templ()
    $("#message-form #message").focus()

    server.refresh (services)->
      console.log "username: #{server.cookie 'username'}"
      console.log "services: #{services}"

      $("#message-form").submit ->
        unless $("#message").val() is ""
          message = $("#message").val()
          console.log "sent: #{message}"
          server[id] message, (err, data) ->
            console.log err if err and console?
          $("#message").val("")
          $("#chat-display-box").scrollTop($("#chat-display-box").prop("scrollHeight"))
        false

      server.getChatHistory server.cookie('channel'), (err, data)->
        $("#chat-display-box").html chatBox history: data if data and not err

        server.subscribe[id] (err, data)->
          #TODO: use a jade partial here instead of <p> tags
          $("#chat-display-box").append "<p>#{unescape(data.username)}: #{data.message}</p>"
