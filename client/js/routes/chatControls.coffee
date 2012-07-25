define ["app/server", "templates/serverMessage", "templates/selectUser"], (server, serverMessage, selectUser) ->
  createInviteHandler: (chatId) ->
    (evt) ->
      evt.preventDefault()
      server.getNonpresentOperators chatId, (err, users) ->
        console.log "Error getting nonpresent users: #{err}" if err
        $("#selectModal").html selectUser users: users
        $("#selectUser").modal()

        $("#selectUser .select").click (evt) ->
          evt.preventDefault()
          userId = $(this).attr 'userId'
          $("#selectUser").modal "hide"
          server.inviteOperator userId, chatId, (err) ->
            console.log "error inviting operator: #{err}" if err

  createTransferHandler: (chatId) ->
    (evt) ->
      evt.preventDefault()
      server.getNonpresentOperators chatId, (err, users) ->
        console.log "Error getting nonpresent users: #{err}" if err
        $("#selectModal").html selectUser users: users
        $("#selectUser").modal()

        $("#selectUser .select").click (evt) ->
          evt.preventDefault()
          userId = $(this).attr 'userId'
          $("#selectUser").modal "hide"
          server.transferChat userId, chatId, (err) ->
            console.log "error inviting operator: #{err}" if err

  createKickHandler: (chatId, renderedId) ->
    (evt) ->
      evt.preventDefault()
      server.kickUser chatId, (err) ->
        console.log "error kicking user: #{err}" if err?
        $("##{renderedId} .chat-display-box").append serverMessage message: "The visitor has been kicked from the room"

  createLeaveHandler: (chatId) ->
    (evt) ->
      evt.preventDefault()
      console.log "leave clicked"
      server.leaveChat chatId, (err) ->
        console.log "error leaving chat: #{err}" if err?
        #TODO: find way to remove this tab and refresh tabs without redirecting to dashboard
        window.location.hash = '/dashboard'
