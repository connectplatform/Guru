define ["app/server", "app/pulsar", "app/notify", "routes/chatControls", "templates/chatMessage", "templates/serverMessage", "templates/badge"],
  (server, pulsar, notify, controls, chatMessage, serverMessage, badge) ->
    (args, templ) ->

      # get notified of new messages
      sessionId = server.cookie "session"
      sessionUpdates = pulsar.channel "notify:session:#{sessionId}"

      renderId = (id) -> id.replace /:/g, '-'
      status = {}

      server.ready (services) ->
        #console.log "server is ready-- services availible: #{services}"

        server.getMyChats (err, chats) ->

          chat.renderedId = renderId chat.id for chat in chats

          $('#content').html templ chats: chats

          console.log 'wiring up chatTabs'
          $('#chatTabs a').click (e) ->
            e.preventDefault()
            $(this).tab 'show'

            # let the server know we read these
            status.currentChat = $(this).attr 'chatid'
            sessionUpdates.emit 'viewedMessages', status.currentChat

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

          createChatRemover = (thisChatId, channel) ->
            (endedId) ->
              return unless thisChatId is endedId
              channel.removeAllListeners 'serverMessage'
              renderedId = renderId endedId
              $("##{renderedId} .chat-display-box").append serverMessage message: "Another operator has taken this chat"
              $(".message-form").hide()

          updateChatBadge = (chatId) ->
            (unreadMessages) ->
              unreadCount = unreadMessages[chatId] or 0

              if unreadCount > 0 and status.currentChat is chatId
                console.log 'currentChat:', status.currentChat
                sessionUpdates.emit 'viewedMessages', chatId
                content = ''
              else if unreadCount > 0
                content = badge {status: 'important', num: unreadCount}
              else
                content = ''

              $("#{chatId}").html content

          for chat in chats
            channel = pulsar.channel chat.id

            #Only render and wire up submit button if we're not watching
            if chat.isWatching
              $("##{chat.renderedId} .message-form").hide()
            else
              $("##{chat.renderedId} .message-form").submit createSubmitHandler chat.renderedId, channel

            #display incoming messages
            channel.on 'serverMessage', createChatAppender chat.renderedId
            sessionUpdates.on 'kickedFromChat', createChatRemover chat.id, channel
            sessionUpdates.on 'unreadMessages', updateChatBadge chat.id

            #wire up control buttons
            $("##{chat.renderedId} .inviteButton").click controls.createInviteHandler chat.id
            $("##{chat.renderedId} .transferButton").click controls.createTransferHandler chat.id
            $("##{chat.renderedId} .kickButton").click controls.createKickHandler chat.id, chat.renderedId
            $("##{chat.renderedId} .leaveButton").click controls.createLeaveHandler chat.id

            # stop listening for pulsar events when we leave the page
            ran = false
            window.rooter.hash.listen (newHash) ->
              unless ran
                ran = true
                status.currentChat = undefined
                channel.removeAllListeners 'serverMessage'
                sessionUpdates.removeAllListeners 'kickedFromChat'
                sessionUpdates.removeAllListeners 'unreadMessages'
