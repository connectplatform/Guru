define ["load/pulsar", "load/server"], (pulsar, server) ->
    ->
      session = $.cookies.get 'session'
      if session
        console.log 'registering session updates for:', "'notify:session:#{session}'"
        sessionUpdates = pulsar.channel "notify:session:#{session}"
        sessionUpdates.use (emit, event, args...) ->
          console.log 'event:', event, 'was called.'

          if event is 'unreadMessages'
            unreadMessages = args[0]
            currentChat = $('.chatWindow:visible').attr('chatid')
            console.log 'currentChat:', currentChat
            unreadCount = unreadMessages[currentChat]

            if currentChat and unreadCount > 0
              console.log 'viewed messages'
              unreadMessages[currentChat] = 0
              sessionUpdates.emit 'viewedMessages', currentChat

            args[0] = unreadMessages
            emit args...
          else
            emit()
