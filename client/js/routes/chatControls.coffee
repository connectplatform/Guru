define ["app/server", "templates/serverMessage"], (server, serverMessage) ->
  createInviteHandler: (chatId) ->
    (evt) ->
      evt.preventDefault()
      console.log "invite clicked"
      #TODO
  createTransferHandler: (chatId) ->
    (evt) ->
      evt.preventDefault()
      console.log "transfer clicked"
      #TODO
  createKickHandler: (chatId, renderedId) ->
    console.log "chatId in closure: #{chatId}"
    (evt) ->
      evt.preventDefault()
      console.log "chatId in handler: #{chatId}"
      server.kickUser chatId, (err) ->
        console.log "error kicking user: #{err}" if err?
        $("##{renderedId} .chat-display-box").append serverMessage message: "The visitor has been kicked from the room"
        console.log "displayed kick message"

  createLeaveHandler: (chatId) ->
    (evt) ->
      evt.preventDefault()
      console.log "leave clicked"
      server.leaveChat chatId, (err) ->
        console.log "error leaving chat: #{err}" if err?
        #TODO: find way to refresh tabs without redirecting to dashboard
        window.location.hash = '/dashboard'