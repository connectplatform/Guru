define ["load/server", "load/notify", "routes/chatControls", "templates/chatMessage",
"templates/serverMessage", "templates/badge", "helpers/util", "helpers/wireUpChatAppender",
"helpers/embedImageIfExists", "helpers/chatActions", 'helpers/sidebarHelpers'],
  (server, notify, controls, chatMessage, serverMessage, badge, util, wireUpChatAppender, embedImage, chatActions, {readChat, getUnread}) ->
    channels: []
    setup:
      (args, templ, query) ->
        self = this
        self.channels = []

        # get notified of new messages
        sessionId = $.cookies.get "session"
        self.sessionUpdates = pulsar.channel "notify:session:#{sessionId}"

        # helper function
        renderId = (id) -> id.replace /:/g, '-'

        server.ready (services) ->

          server.getMyChats {}, (err, {chats}) ->
            chats ||= []

            if err
              server.log
                message: 'Error getting chats in operatorChat'
                context:
                  error: err
                  severity: 'error'
                  ids:
                    sessionId: sessionId

            for chat in chats
              chat.renderedId = renderId chat.id
              chat.visitor.acpData = util.jsonToUl chat.visitor.acpData if chat?.visitor?.acpData
              chat.visitor.referrerData = util.jsonToUl chat.visitor.referrerData if chat?.visitor?.referrerData

            $('#content').html templ chats: chats

            renderLogo = (chat) ->
              server.getLogoForChat {chatId: chat.id}, (err, {url}) ->
                notify.error "Error getting logo for chat ", err if err?
                embedImage url, "##{chat.renderedId} .websiteLogo"

            for chat in chats
              renderLogo chat
              $("#acpTree#{chat.renderedId}").treeview {
                collapsed: true,
                persist: "location"
              }

            $('#chatTabs a').click (e) ->
              e.preventDefault()
              $(this).tab 'show'
              currentChat = $(this).attr 'chatid'
              $("##{currentChat} textarea.message").focus()
              $(".notifyUnread[chatid=#{currentChat}]").html ''

              # let the sidebar know we read these
              readChat currentChat
              util.scrollToBottom "##{currentChat} .chat-display-box"

              # let the server know we read these
              self.sessionUpdates.emit 'viewedMessages', currentChat

            # TODO: Display accepted/last chat instead of first tab
            # on page load click the first tab
            if query.chatId
              $("#chatTabs a[chatid=#{query.chatId}]").click()
            else
              $('#chatTabs a:first').click()

            createSubmitHandler = (renderedId, channel) ->
              (evt) ->
                evt.preventDefault()
                chatActions.sendChatMessage(channel, renderedId)

            createChatAppender = (renderedId) ->
              (message) ->
                if message.type is 'notification'
                  util.append $("##{renderedId} .chat-display-box"), serverMessage message
                else
                  util.append $("##{renderedId} .chat-display-box"), chatMessage message

            createChatRemover = (thisChatId, channel) ->
              (endedId) ->
                return unless thisChatId is endedId
                channel.removeAllListeners 'serverMessage'
                renderedId = renderId endedId
                util.append $("##{renderedId} .chat-display-box"), serverMessage message: "Another operator has taken this chat"
                $(".message-form").hide()

            updateChatBadge = (chatId) ->
              (unreadMessages) ->

                unreadCount = unreadMessages[chatId] or 0

                if unreadCount > 0
                  content = badge {status: 'important', num: unreadCount}
                else
                  content = ''

                $(".notifyUnread[chatid=#{chatId}]").html content

            for chat in chats
              channel = pulsar.channel chat.id
              self.channels.push channel

              #Only render and wire up submit button if we're not watching
              if chat.isWatching is 'true'
                $("##{chat.renderedId} .message-form").hide()
              else
                do (channel, chat) ->
                  $("##{chat.renderedId} .message-form").submit createSubmitHandler chat.renderedId, channel

                  # Multi-line support (enter sends, shift+enter creates newline)
                  $("##{chat.renderedId} .message").bind 'keydown', jwerty.event 'enter', (evt) ->
                    evt.preventDefault()
                    chatActions.sendChatMessage(channel, chat.renderedId)

              # set initial unread chat count
              updateChatBadge(chat.id) getUnread()

              #display incoming messages
              wireUpChatAppender createChatAppender(chat.renderedId), channel
              self.sessionUpdates.on 'kickedFromChat', createChatRemover chat.id, channel
              self.sessionUpdates.on 'unreadMessages', updateChatBadge chat.id

              channel.on 'leave', ->
                renderedId = renderId chat.id

              #wire up control buttons
              $("##{chat.renderedId} .inviteButton").click controls.createHandler 'inviteOperator', chat.id
              $("##{chat.renderedId} .transferButton").click controls.createHandler 'transferChat', chat.id
              $("##{chat.renderedId} .kickButton").click controls.createKickHandler chat.id, chat.renderedId
              $("##{chat.renderedId} .leaveButton").click controls.createLeaveHandler chat.id
              $("##{chat.renderedId} .printButton").click chatActions.print chat.id
              $("##{chat.renderedId} .emailButton").click chatActions.email chat.id

    teardown:
      (cb) ->
        self = this
        channel.removeAllListeners 'serverMessage' for channel in self.channels
        self.sessionUpdates.removeAllListeners 'kickedFromChat'
        self.sessionUpdates.removeAllListeners 'unreadMessages'
        self.channels = []
        cb()
