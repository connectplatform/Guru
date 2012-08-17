define ["app/pulsar", "app/server"], (pulsar, server) ->
    ->
      session = server.cookie 'session'
      if session?
        sessionUpdates = pulsar.channel "notify:session:#{session}"
        console.log 'adding pulsar middleware'
        sessionUpdates.use (emit, event, args...) ->

          console.log 'intercepted by middleware'
          if event is 'unreadMessages'
            [unreadMessages] = args
            currentChat = $('.chatWindow:visible').attr('chatid')
            unreadCount = unreadMessages[currentChat]

            if currentChat? and unreadCount > 0
              console.log 'read chat:', currentChat
              sessionUpdates.emit 'viewedMessages', currentChat, false
              unreadMessages[currentChat] = 0

            emit unreadMessages
          else
            emit()
