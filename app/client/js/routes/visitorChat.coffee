playSound = (type) ->
  $("##{type}Sound")[0].play()

define ["load/server", "load/pulsar", "load/notify", "helpers/util", "templates/newChat", "templates/chatMessage", "templates/serverMessage", "helpers/wireUpChatAppender", "helpers/chatActions", 'helpers/embedImageIfExists'],
  (server, pulsar, notify, util, newChat, chatMessage, serverMessage, wireUpChatAppender, chatActions, embedImage) ->
    channel: {}
    setup: ({chatId}, templ) ->
      self = this
      server.ready ->
        server.visitorCanAccessChannel {chatId: chatId}, (err, canAccess) ->
          return window.location.hash = '/newChat' unless canAccess

          $("#content").html templ()
          $(".message-form .message").focus()
          self.channel = pulsar.channel chatId

          $(".message-form").submit (evt) ->
            evt.preventDefault()
            chatActions.sendChatMessage(self.channel)
            return false

          # Enter/Shift+Enter key binding
          $(".message").bind 'keydown', jwerty.event 'enter',(evt) ->
            evt.preventDefault()
            chatActions.sendChatMessage(self.channel)

          # Confrim and leave chat on window close
          window.onbeforeunload = ->
            closeWarn = confirm "Leave chat?"
            if closeWarn is true
              server.leaveChat {chatId: chatId}, (err) ->
            else
              return 'stay on page'

            evt.preventDefault()

          chatbox = $(".chat-display-box")

          appendServerMessage = (message) ->
            util.append chatbox, serverMessage message

          appendChatMessage = (message) ->
            playSound "newMessage"
            if message.type is 'notification'
              appendServerMessage message
            else
              util.append chatbox, chatMessage message

          # display initial chat history
          server.getChatHistory {chatId: chatId}, (err, history) ->
            notify.error "Error loading chat history: #{err}" if err
            appendChatMessage msg for msg in history

            # display messages when received
            wireUpChatAppender appendChatMessage, self.channel

            # when you get to the end, stop
            self.channel.on 'chatEnded', ->
              @channel.removeAllListeners 'serverMessage'
              @channel.removeAllListeners 'chatEnded'
              $('.message-form').hide()
              $('.leaveButton').hide()

          # display chat logo
          server.getLogoForChat {chatId: chatId}, (err, logoUrl) ->
            notify.error "Error getting logo url: #{err}" if err
            embedImage logoUrl, '.websiteLogo'

          # wire up leave button
          $('.leaveButton').click (evt) ->
            evt.preventDefault()
            server.leaveChat {chatId: chatId}, (err) ->
              notify.error "Error leaving chat: #{err}" if err
              server.cookie 'session', null
              $('.message-form').hide()
              $('.leaveButton').hide()
              @channel.removeAllListeners 'serverMessage'
              @channel.removeAllListeners 'chatEnded'

          $('.printButton').click chatActions.print chatId
          $('.emailButton').click chatActions.email chatId

    teardown: (cb) ->
      ran = true #Not sure what this does
      @channel.removeAllListeners 'serverMessage'
      @channel.removeAllListeners 'chatEnded'
      cb()
