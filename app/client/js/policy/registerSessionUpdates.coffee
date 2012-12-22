define ["load/pulsar", "load/server"], (pulsar, server) ->
    ->
      session = server.cookie 'session'
      console.log 'registerSessionUpdates'
      if session?
        sessionUpdates = pulsar.channel "notify:session:#{session}"
        sessionUpdates.use (emit, event, args...) ->

          if event is 'unreadMessages'
            unreadMessages = args[0]
            currentChat = $('.chatWindow:visible').attr('chatid')
            unreadCount = unreadMessages[currentChat]

            if currentChat? and unreadCount > 0
              unreadMessages[currentChat] = 0
              sessionUpdates.emit 'viewedMessages', currentChat

            args[0] = unreadMessages
            emit args...
          else
            emit()
