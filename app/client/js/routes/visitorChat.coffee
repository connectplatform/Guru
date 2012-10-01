define ["load/server", "load/pulsar", "load/notify", "templates/newChat", "templates/chatMessage", "templates/serverMessage", "helpers/wireUpChatAppender", "templates/imageTemplate", "helpers/chatActions" ],
  (server, pulsar, notify, newChat, chatMessage, serverMessage, wireUpChatAppender, imageTemplate, chatActions) ->
    channel: {}
    setup: ({chatId}, templ) ->
      self = this
      server.ready ->
        server.visitorCanAccessChannel chatId, (err, canAccess) ->
          console.log "canAccess: ", canAccess
          return window.location.hash = '/newChat' unless canAccess

          $("#content").html templ()
          console.log "rendered"
          $("#message-form #message").focus()
          self.channel = pulsar.channel chatId

          $(".message-form").submit (evt) ->
            evt.preventDefault()
            unless $(".message").val() is ""
              message = $(".message").val()

              self.channel.emit 'clientMessage', {message: message, session: server.cookie 'session'}

              $(".message").val("")
              $(".chat-display-box").scrollTop($(".chat-display-box").prop("scrollHeight"))

            return false

          appendChatMessage = (message) ->
            $(".chat-display-box").append chatMessage message

          appendServerMessage = (message) ->
            $(".chat-display-box").append serverMessage message: message

          displayGreeting = ->
            appendServerMessage "Welcome to live chat!  An operator will be with you shortly."

          # display initial chat history
          server.getChatHistory chatId, (err, history) ->
            notify.error "Error loading chat history: #{err}" if err
            appendChatMessage msg for msg in history
            displayGreeting() if history.length is 0

            # display messages when received
            wireUpChatAppender appendChatMessage, self.channel

            # when you get to the end, stop
            self.channel.on 'chatEnded', ->
              self.channel.removeAllListeners 'serverMessage'
              appendServerMessage "The operator has ended the chat"
              $(".message-form").hide()

          # display chat logo
          server.getLogoForChat chatId, (err, logoUrl) ->
            console.log "logoUrl: ", logoUrl
            notify.error "Error getting logo url: #{err}" if err
            $(".websiteLogo").html imageTemplate source: logoUrl

          # wire up leave button
          $('.leaveButton').click (evt) ->
            evt.preventDefault()
            server.kickUser chatId, (err) ->
              notify.error "Error leaving chat: #{err}" if err
            appendServerMessage 'You have left the chat.'

          $('.printButton').click chatActions.print chatId

    teardown: (cb) ->
      ran = true
      @channel.removeAllListeners 'serverMessage'
      @channel.removeAllListeners 'chatEnded'
      cb()
