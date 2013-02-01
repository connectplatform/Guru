playSound = (type) ->
  try
    $("##{type}Sound")[0].play()
  catch error
    "Error playing sound: #{error}"

define ["load/server", "load/pulsar", "load/notify", "helpers/util", "templates/chatMessage", "templates/serverMessage", "helpers/wireUpChatAppender", "helpers/chatActions", 'helpers/embedImageIfExists'],
  (server, pulsar, notify, util, chatMessage, serverMessage, wireUpChatAppender, chatActions, embedImage) ->
    self =
      channel: null
      setup: ({chatId}, templ) ->
        server.ready ->
          server.visitorCanAccessChannel {chatId: chatId}, (err, {accessAllowed}) ->
            unless accessAllowed
              $.cookies.del 'session'
              $("#content").html "Sorry, you are not allowed to access this chat.  Please try again."
              server.log
                message: "Attempted to connect to an invalid chat."
                context: {chatId: chatId}
              return

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

            # Confirm and leave chat on window close
            window.onbeforeunload = -> 'Leave chat?'

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
            server.getChatHistory {chatId: chatId}, (err, {history}) ->
              notify.error "Error loading chat history: #{err}" if err
              appendChatMessage msg for msg in history

              # display messages when received
              wireUpChatAppender appendChatMessage, self.channel

              # event for being kicked by operator
              self.channel.on 'chatEnded', ->
                self.teardown ->

            # display chat logo
            server.getLogoForChat {chatId: chatId}, (err, {url}) ->
              notify.error "Error getting logo url: #{err}" if err
              embedImage url, '.websiteLogo'

            # wire up leave button
            $('.leaveButton').click (evt) ->
              evt.preventDefault()
              server.leaveChat {chatId: chatId}, (err) ->
                notify.error "Error leaving chat: #{err}" if err
                $.cookies.del 'session'
                self.teardown ->

            $('.printButton').click chatActions.print chatId
            $('.emailButton').click chatActions.email chatId

      teardown: (cb) ->
          $('.message-form').hide()
          $('.leaveButton').hide()
          if self.channel
            self.channel.removeAllListeners 'serverMessage'
            self.channel.removeAllListeners 'chatEnded'
          cb()
