define ["app/server", "app/pulsar", "app/notify", "templates/newChat", "templates/chatMessage", "templates/serverMessage"],
  (server, pulsar, notify, newChat, chatMessage, serverMessage) ->
    ({id}, templ) ->

      server.refresh (services) ->
        server.visitorCanAccessChannel server.cookie('session'), id, (err, canAccess) ->
          console.log "canAccess: #{canAccess}"
          console.log "canAccess is true: #{canAccess is true}"
          return window.location.hash = '/newChat' unless canAccess

          $("#content").html templ()
          $("#message-form #message").focus()
          channel = pulsar.channel id

          $(".message-form").submit (evt) ->
            evt.preventDefault()
            unless $(".message").val() is ""
              message = $(".message").val()

              channel.emit 'clientMessage', {message: message, session: server.cookie 'session'}

              $(".message").val("")
              $(".chat-display-box").scrollTop($(".chat-display-box").prop("scrollHeight"))
            false

          appendChat = (data)->
            $(".chat-display-box").append chatMessage data

          server.getChatHistory server.cookie('channel'), (err, history)->
            notify.error "Error loading chat history: #{err}" if err
            appendChat null, msg for msg in history

            channel.on 'serverMessage', appendChat
            channel.on 'chatEnded', ->
              #TODO need to make sure disconnection occurs server side as well
              $(".chat-display-box").append serverMessage message: "The operator has ended the chat"
              channel.removeAllListeners 'serverMessage'
              $(".message-form").hide()

            # stop listening for pulsar events when we leave the page
            ran = false
            window.rooter.hash.listen (newHash) ->
              unless ran
                ran = true
                channel.removeAllListeners 'serverMessage'
                channel.removeAllListeners 'chatEnded'
