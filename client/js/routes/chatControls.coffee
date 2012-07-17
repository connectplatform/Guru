define ["app/server"], (server) ->
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
  createKickHandler: (chatId) ->
    (evt) ->
      evt.preventDefault()
      console.log "kick clicked"
      #TODO 
  createLeaveHandler: (chatId) ->
    (evt) ->
      evt.preventDefault()
      console.log "leave clicked"
      server.leaveChat chatId, (err) ->
        console.log "error leaving chat: #{err}" if err?
        #TODO: find way to refresh tabs without redirecting to dashboard
        window.location.hash = '/dashboard'