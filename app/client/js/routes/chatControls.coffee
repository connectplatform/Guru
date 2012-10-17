define ["load/server", "templates/serverMessage", "templates/selectUser"], (server, serverMessage, selectUser) ->
  showUserSelectionBox = (chatId, cb) ->
    server.getNonpresentOperators chatId, (err, users) ->
      server.log 'Error getting nonpresent operators in chatControls', {error: err, severity: 'error', chatId: chatId} if err
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
            server.log 'Error inviting operator to chat', {error: err, severity: 'error', chatId: chatId, userId: userId, inviteType: inviteType} if err

    createKickHandler: (chatId, renderedId) ->
      (evt) ->
        evt.preventDefault()
        server.kickUser chatId, (err) ->
          server.log 'Error kicking user', {error: err, severity: 'error', chatId: chatId} if err
          $("##{renderedId} .chat-display-box").append serverMessage
            message: "The visitor has been kicked from the room"

    createLeaveHandler: (chatId) ->
      (evt) ->
        evt.preventDefault()
        server.leaveChat chatId, (err) ->
          server.log 'Error leaving chat', {error: err, severity: 'error', chatId: chatId} if err
          #TODO: find way to remove this tab and refresh tabs without redirecting to dashboard
          window.location.hash = '/dashboard'
  }
