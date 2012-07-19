define ["app/server", "app/pulsar", "app/notify", "routes/chatControls","routes/sidebar", "templates/sidebar", "templates/chatMessage"],
  (server, pulsar, notify, controls, sidebar, sbTemp, chatMessage) ->
    (args, templ) ->
      sidebar {}, sbTemp

      server.ready (services) ->
        console.log "server is ready-- services availible: #{services}"
        server.getMyChats (err, chats) ->

          chat.renderedId = chat.id.replace /:/g, '-' for chat in chats

          $('#content').html templ chats: chats

          $('#chatTabs a').click (e) ->
            e.preventDefault()
            $(this).tab 'show'

            # let the server know we read these
            chatID = $(this).attr 'chatid'
            console.log 'chatID:', chatID
            server.readChats chatID, ->

          # on page load click the first tab
          $('#chatTabs a:first').click()

          createSubmitHandler = (renderedId, channel) ->
            (evt) ->
              evt.preventDefault()
              message = $("##{renderedId} .message-form .message").val()
              unless message is ""
                channel.emit 'clientMessage', {message: message, session: server.cookie('session')}

                $("##{renderedId} .message-form .message").val("")
                $("##{renderedId} .chat-display-box").scrollTop($("##{renderedId} .chat-display-box").prop("scrollHeight"))

          createChatAppender = (renderedId) ->
            (message) ->
              $("##{renderedId} .chat-display-box").append chatMessage message

          for chat in chats
            channel = pulsar.channel chat.id

            #Only render and wire up submit button if we're not watching
            if chat.isWatching
              $("##{chat.renderedId} .message-form").hide()
            else
              $("##{chat.renderedId} .message-form").submit createSubmitHandler chat.renderedId, channel

            #display incoming messages
            channel.on 'serverMessage', createChatAppender chat.renderedId

            $(window).bind 'hashchange', ->
              channel.removeAllListeners 'serverMessage'

            #wire up control buttons
            $("##{chat.renderedId} .inviteButton").click controls.createInviteHandler chat.id
            $("##{chat.renderedId} .transferButton").click controls.createTransferHandler chat.id
            $("##{chat.renderedId} .kickButton").click controls.createKickHandler chat.id
            $("##{chat.renderedId} .leaveButton").click controls.createLeaveHandler chat.id
