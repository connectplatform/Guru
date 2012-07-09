define ["app/server", "app/pulsar", "app/notify", "templates/newChat", "templates/chatMessage"], (server, pulsar, notify, newChat, chatMessage) ->
  ({id}, templ) ->
    $("#content").html templ()
    $("#message-form #message").focus()

    channel = pulsar.channel id

    server.refresh (services) ->
      $(".message-form").submit (evt) ->
        evt.preventDefault()
        unless $(".message").val() is ""
          message = $(".message").val()

          channel.emit 'clientMessage', {message: message, session: server.cookie 'session'}

          $(".message").val("")
          $(".chat-display-box").scrollTop($(".chat-display-box").prop("scrollHeight"))
        false

      appendChat = (data)->
        console.log data #removeme
        $(".chat-display-box").append chatMessage data

      server.getChatHistory server.cookie('channel'), (err, history)->
        notify.error "Error loading chat history: #{err}" if err
        appendChat null, msg for msg in history

        channel.on 'serverMessage', appendChat