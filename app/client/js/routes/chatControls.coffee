define ["load/server", "helpers/util", "templates/serverMessage", "templates/selectUser"],
  (server, util, serverMessage, selectUser) ->
    showUserSelectionBox = (chatId, cb) ->
      server.getNonpresentOperators {chatId: chatId}, (err, {operators}) ->
        if err
          server.log
            message: 'Error getting nonpresent operators in chatControls'
            context: {error: err, severity: 'error', chatId: chatId}

        $("#selectModal").html selectUser users: operators
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
            server[inviteType] {chatId: chatId}, userId, (err) ->
              if err
                server.log
                  message: 'Error inviting operator to chat'
                  context: {error: err, severity: 'error', chatId: chatId, userId: userId, inviteType: inviteType}

      createKickHandler: (chatId, renderedId) ->
        (evt) ->
          evt.preventDefault()
          server.kickUser {chatId: chatId}, (err) ->
            if err
              server.log
                message: 'Error kicking user'
                context: {error: err, severity: 'error', chatId: chatId}

            chatbox = $("##{renderedId} .chat-display-box")
            util.append chatbox, serverMessage {message: "The visitor has been kicked from the room"}

      createLeaveHandler: (chatId) ->
        (evt) ->
          evt.preventDefault()
          server.leaveChat {chatId: chatId}, (err) ->
            if err
              server.log
                message: 'Error leaving chat'
                context: {error: err, severity: 'error', chatId: chatId}

            #TODO: find way to remove this tab and refresh tabs without redirecting to dashboard
            window.location.hash = '/dashboard'
    }
