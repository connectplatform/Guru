define ["load/server", "load/pulsar", "load/notify", "templates/newChat", "templates/chatMessage", "templates/serverMessage"],
  (server, pulsar, notify, newChat, chatMessage, serverMessage) ->
    channel: {}
    setup: ({chatId}, templ) ->
      server.ready =>
        server.visitorCanAccessChannel chatId, (err, canAccess) =>
          return window.location.hash = '/newChat' unless canAccess

          $("#content").html templ()
          $("#message-form #message").focus()
          @channel = pulsar.channel chatId

          $(".message-form").submit (evt) ->
            evt.preventDefault()
            unless $(".message").val() is ""
              message = $(".message").val()

              @channel.emit 'clientMessage', {message: message, session: server.cookie 'session'}

              $(".message").val("")
              $(".chat-display-box").scrollTop($(".chat-display-box").prop("scrollHeight"))

            return false

          appendChatMessage = (message) ->
            $(".chat-display-box").append chatMessage message

          # display initial chat history
          server.getChatHistory chatId, (err, history) ->
            notify.error "Error loading chat history: #{err}" if err
            appendChatMessage msg for msg in history

            # display messages when received
            @channel.on 'serverMessage', appendChatMessage

            # when you get to the end, stop
            @channel.on 'chatEnded', ->
              $(".chat-display-box").append serverMessage message: "The operator has ended the chat"
              @channel.removeAllListeners 'serverMessage'
              $(".message-form").hide()

    teardown: (cb) ->
      self = this
      ran = true
      @channel.removeAllListeners 'serverMessage'
      @channel.removeAllListeners 'chatEnded'
      cb()
