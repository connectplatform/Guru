define [], () ->
  (appender, chatChannel) ->
    messagesReceived = []

    alreadyReceivedChatMessage = (newMessage) ->
      for oldMessage in messagesReceived
        return true if newMessage.timestamp is oldMessage.timestamp
      messagesReceived.push newMessage
      return false

    appendChatMessageIfNew = (message) ->
      appender message unless alreadyReceivedChatMessage message

    chatChannel.on 'serverMessage', appendChatMessageIfNew
