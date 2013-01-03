playSound = (type) ->
  try
    $("##{type}Sound")[0].play()
  catch error
    "Error playing sound: #{error}"

# watch for shift key events, use jwerty if we want to drop IE8 support
shiftUp = true
$("body").keyup (evt) ->
  if evt.which is 16  # Release shift key
    shiftUp = true

$("body").keydown (evt) ->
  if evt.which is 16  # Shift pressed
    shiftUp = false

define ["load/server", "load/pulsar", "load/notify", "helpers/util", "templates/chatMessage", "templates/serverMessage", "helpers/wireUpChatAppender", "helpers/chatActions", 'helpers/embedImageIfExists'],
  (server, pulsar, notify, util, chatMessage, serverMessage, wireUpChatAppender, chatActions, embedImage) ->
    self =
      channel: null
      setup: ({chatId}, templ) ->
        server.ready ->
          server.visitorCanAccessChannel {chatId: chatId}, (err, canAccess) ->
            unless canAccess
              $("#content").html "Sorry, you are not allowed to access this chat.  Please try again."
              server.log
                message: "Attempted to connect to an invalid chat."
                context: {chatId: chatId}
              return

            $("#content").html templ()

            # Try/Catch IE8 compatability
            try
              $(".message-form .message").focus()
            catch error
              "Can't focus, IE8: #{error}"

            self.channel = pulsar.channel chatId

            $(".message-form").submit (evt) ->
              util.preventDefault(evt)
              chatActions.sendChatMessage(self.channel)
              return false

            # Enter/Shift+Enter key binding, shiftUp defined in main.coffee
            $(".message").keydown (evt) ->
              if evt.which is 13 and shiftUp
                util.preventDefault(evt)
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
            server.getChatHistory {chatId: chatId}, (err, history) ->
              notify.error "Error loading chat history: #{err}" if err
              appendChatMessage msg for msg in history

              # display messages when received
              wireUpChatAppender appendChatMessage, self.channel

              # event for being kicked by operator
              self.channel.on 'chatEnded', ->
                self.teardown ->

            # display chat logo
            server.getLogoForChat {chatId: chatId}, (err, logoUrl) ->
              notify.error "Error getting logo url: #{err}" if err
              embedImage logoUrl, '.websiteLogo'

            # wire up leave button
            $('.leaveButton').click (evt) ->
              util.preventDefault(evt)
              server.leaveChat {chatId: chatId}, (err) ->
                notify.error "Error leaving chat: #{err}" if err
                server.cookie 'session', null
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
