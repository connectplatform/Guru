define ["app/server", "app/pulsar", "app/notify", "routes/chatControls", "templates/chatMessage", "templates/serverMessage", "templates/badge", "app/util"],
  (server, pulsar, notify, controls, chatMessage, serverMessage, badge, util) ->
    (args, templ) ->

      # get notified of new messages
      sessionId = server.cookie "session"
      sessionUpdates = pulsar.channel "notify:session:#{sessionId}"

      # helper function
      renderId = (id) -> id.replace /:/g, '-'

      server.ready (services) ->

        server.getMyChats (err, chats) ->
          console.log 'chats:', chats

          for chat in chats
            chat.renderedId = renderId chat.id
            chat.visitor.acpData = JSON.parse chat.visitor.acpData if chat.visitor.acpData?
            chat.visitor.referrerData = JSON.parse chat.visitor.referrerData if chat.visitor.referrerData?

            chat.visitor.referrerData = util.jsonToUl chat.visitor.referrerData
            chat.visitor.acpData = util.jsonToUl chat.visitor.acpData

          $('#content').html templ chats: chats

          for chat in chats
            $("#referrerTree#{chat.renderedId}").treeview {
              collapsed: true,
              persist: "location"
            }

            $("#acpTree#{chat.renderedId}").treeview {
              collapsed: true,
              persist: "location"
            }

          $('#chatTabs a').click (e) ->
            e.preventDefault()
            $(this).tab 'show'
            currentChat = $(this).attr 'chatid'

            # let the server know we read these
            sessionUpdates.emit 'viewedMessages', currentChat

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
              console.log 'received unread:', unreadMessages

              unreadCount = unreadMessages[chatId] or 0
              console.log 'unread count:', unreadCount, 'for chatId:', chatId

              if unreadCount > 0
                console.log 'setting badge:', unreadCount
                content = badge {status: 'important', num: unreadCount}
              else
                console.log 'unsetting badge'
                content = ''

              $(".notifyUnread[chatid=#{chatId}]").html content

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
                channel.removeAllListeners 'serverMessage'
                sessionUpdates.removeAllListeners 'kickedFromChat'
                sessionUpdates.removeAllListeners 'unreadMessages'
