define ["app/server", "app/pulsar", "app/notify", "templates/newChat", "templates/chatMessage", "templates/serverMessage", "app/wireUpChatAppender"],
  (server, pulsar, notify, newChat, chatMessage, serverMessage, wireUpChatAppender) ->
    channel: {}
    setup: ({chatId}, templ) ->
      self = this
      server.ready ->
        server.visitorCanAccessChannel chatId, (err, canAccess) ->
          return window.location.hash = '/newChat' unless canAccess

          $("#content").html templ()
          $("#message-form #message").focus()
          self.channel = pulsar.channel chatId

          $(".message-form").submit (evt) ->
            evt.preventDefault()
            unless $(".message").val() is ""
              message = $(".message").val()

              self.channel.emit 'clientMessage', {message: message, session: server.cookie 'session'}

              $(".message").val("")
              $(".chat-display-box").scrollTop($(".chat-display-box").prop("scrollHeight"))
            false

          appendChatMessage = (message) ->
            $(".chat-display-box").append chatMessage message
          server.getChatHistory chatId, (err, history)->
            notify.error "Error loading chat history: #{err}" if err
            appendChatMessage msg for msg in history

            wireUpChatAppender appendChatMessage, self.channel  #TODO: this is a workaround for multiple chat display bug
            self.channel.on 'chatEnded', ->
              $(".chat-display-box").append serverMessage message: "The operator has ended the chat"
              self.channel.removeAllListeners 'serverMessage'
              $(".message-form").hide()

    teardown: (cb) ->
      self = this
      ran = true
      self.channel.removeAllListeners 'serverMessage'
      self.channel.removeAllListeners 'chatEnded'
      cb()
