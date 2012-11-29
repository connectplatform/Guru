playSound = (type) ->
  $("##{type}Sound")[0].play()

define ["load/server", "load/pulsar", "load/notify", "helpers/util", "templates/newChat", "templates/chatMessage", "templates/serverMessage", "helpers/wireUpChatAppender", "helpers/chatActions", 'helpers/embedImageIfExists'],
  (server, pulsar, notify, util, newChat, chatMessage, serverMessage, wireUpChatAppender, chatActions, embedImage) ->
    channel: {}
    setup: ({chatId}, templ) ->
      self = this
      server.ready ->

        # Sends chat message
        sendChatMessage = ->
          unless $(".message").val() is ""
            lines = $(".message").val().split(/\r\n|\r|\n/g)
            #message = $(".message").val()
            console.log lines

            self.channel.emit 'clientMessage', {message: lines, session: server.cookie 'session'}

            $(".message").val("")
            $(".chat-display-box").scrollTop($(".chat-display-box").prop("scrollHeight"))

        server.visitorCanAccessChannel {chatId: chatId}, (err, canAccess) ->
          return window.location.hash = '/newChat' unless canAccess

          $("#content").html templ()
          $(".message-form .message").focus()
          self.channel = pulsar.channel chatId

          $(".message-form").submit (evt) ->
            evt.preventDefault()
            sendChatMessage()
            return false

          # Chat send and other keyboard shortcuts
          #$(".message").bind 'keydown', jwerty.event 'shift+enter', ->
          #  console.log 'Shift+Enter!!!'
          $(".message").bind 'keydown', jwerty.event 'enter',(evt) ->
            evt.preventDefault()
            console.log 'Enter!!!'
            sendChatMessage()

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
              self.teardown ->

          # display chat logo
          server.getLogoForChat {chatId: chatId}, (err, logoUrl) ->
            notify.error "Error getting logo url: #{err}" if err
            embedImage logoUrl, '.websiteLogo'

          # wire up leave button
          $('.leaveButton').click (evt) ->
            evt.preventDefault()
            server.leaveChat {chatId: chatId}, (err) ->
              notify.error "Error leaving chat: #{err}" if err
              self.teardown ->

          $('.printButton').click chatActions.print chatId
          $('.emailButton').click chatActions.email chatId

    teardown: (cb) ->
      $('.message-form').hide()
      $('.leaveButton').hide()
      server.cookie 'session', null
      @channel.removeAllListeners 'serverMessage'
      @channel.removeAllListeners 'chatEnded'
      cb()
