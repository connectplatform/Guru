define ["app/server", "app/pulsar", "app/notify", "routes/sidebar", "templates/sidebar", "templates/chatMessage"],
  (server, pulsar, notify, sidebar, sbTemp, chatMessage) ->
    (args, templ) ->
      window.location = '/' unless server.cookie 'session'

      server.ready (services)->
        console.log "server is ready-- services availible: #{services}"
        server.getMyChats (err, chats) ->

          chat.renderedId = chat.id.replace /:/g, '-' for chat in chats
          sidebar {}, sbTemp

          $('#content').html templ chats: chats

          $('#chatTabs').click (e) ->
            e.preventDefault()
            $(this).tab 'show'

          $('#chatTabs a:first').tab 'show'

          for chat in chats
            chatChannel = pulsar.channel chat.id
            console.log "attaching methods to ##{chat.renderedId}"
            if chat.isWatching
              $("##{chat.renderedId} .message-form").hide()
            else
              $("##{chat.renderedId} .message-form").submit (evt)->
                evt.preventDefault()
                message = $("##{chat.renderedId} .message-form .message").val()
                unless message is ""
                  chatChannel.emit 'clientMessage', {message: message, session: server.cookie('session')}

                  $("##{chat.renderedId} .message-form .message").val("")
                  $("##{chat.renderedId} .chat-display-box").scrollTop($("##{chat.renderedId} .chat-display-box").prop("scrollHeight"))
                false

            appendChat = (data) ->
              $("##{chat.renderedId} .chat-display-box").append chatMessage data

            chatChannel.on 'serverMessage', appendChat

          $(window).bind 'hashchange', ->
            chatChannel.removeAllListeners 'serverMessage'
