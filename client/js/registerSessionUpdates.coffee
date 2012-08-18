define ["app/pulsar", "app/server"], (pulsar, server) ->
    ->
      session = server.cookie 'session'
      if session?
        sessionUpdates = pulsar.channel "notify:session:#{session}"
        sessionUpdates.use (emit, event, args...) ->

          if event is 'unreadMessages'
            [unreadMessages] = args
            currentChat = $('.chatWindow:visible').attr('chatid')
            unreadCount = unreadMessages[currentChat]

            if currentChat? and unreadCount > 0
              unreadMessages[currentChat] = 0
              sessionUpdates.emit 'viewedMessages', currentChat

            emit unreadMessages
          else
            emit()
