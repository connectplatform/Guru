define ["app/server", "app/notify", "templates/newChat", "templates/chatMessage"], (server, notify, newChat, chatMessage) ->
  ({id}, templ) ->
    $("#content").html templ()
    $("#message-form #message").focus()

    server.refresh (services)->
      $("#message-form").submit ->
        unless $("#message").val() is ""
          message = $("#message").val()
          console.log "sent: #{message}"
          server[id] message, (err, data) ->
            console.log err if err and console?
          $("#message").val("")
          $("#chat-display-box").scrollTop($("#chat-display-box").prop("scrollHeight"))
        false

      appendChat = (err, data)->
        console.log "Error appending chat: #{err}" if err
        $("#chat-display-box").append chatMessage data

      server.getChatHistory server.cookie('channel'), (err, history)->
        notify.error "Error loading chat history: #{err}" if err
        appendChat null, msg for msg in history

        server.subscribe[id] appendChat