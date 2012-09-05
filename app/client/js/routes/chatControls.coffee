define ["load/server", "templates/serverMessage", "templates/selectUser"], (server, serverMessage, selectUser) ->
  showUserSelectionBox = (chatId, cb) ->
    server.getNonpresentOperators chatId, (err, users) ->
      console.log "Error getting nonpresent users: #{err}" if err
      $("#selectModal").html selectUser users: users
      $("#selectUser").modal()

      $("#selectUser .select").click (evt) ->
        userId = $(this).attr 'userId'
        evt.preventDefault()
        $("#selectUser").modal "hide"
        cb userId

  return {
    createHandler: (inviteType, chatId) ->
      (evt) ->
        evt.preventDefault()
        showUserSelectionBox chatId, (userId) ->
          return unless userId?
          server[inviteType] chatId, userId, (err) ->
            console.log "error inviting operator: #{err}" if err

    createKickHandler: (chatId, renderedId) ->
      (evt) ->
        evt.preventDefault()
        server.kickUser chatId, (err) ->
          console.log "error kicking user: #{err}" if err?
          $("##{renderedId} .chat-display-box").append serverMessage
            message: "The visitor has been kicked from the room"

    createLeaveHandler: (chatId) ->
      (evt) ->
        evt.preventDefault()
        server.leaveChat chatId, (err) ->
          console.log "error leaving chat: #{err}" if err?
          #TODO: find way to remove this tab and refresh tabs without redirecting to dashboard
          window.location.hash = '/dashboard'
  }
