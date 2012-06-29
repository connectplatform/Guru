define ["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "templates/chatMessage"],
  (server, notify, sidebar, sbTemp, chatMessage) ->
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
            id = chat.id
            console.log "attatching methods to ##{chat.renderedId}"
            $("##{chat.renderedId} .message-form").submit (evt)->
              evt.preventDefault()
              message = $("##{chat.renderedId} .message-form .message").val()
              unless message is ""
                server[id] message, (err, data) ->
                  console.log err if err and console?
                $("##{chat.renderedId} .message-form .message").val("")
                $("##{chat.renderedId} .chat-display-box").scrollTop($("##{chat.renderedId} .chat-display-box").prop("scrollHeight"))
              false

            appendChat = (err, data)->
              console.log "Error appending chat: #{err}" if err
              $("##{chat.renderedId} .chat-display-box").append chatMessage data

            console.log server.subscribe[id].listeners
            if server.subscribe[id].listeners.length is 0
              server.subscribe[id] appendChat

          $(window).bind 'hashchange', ->
            for chat in chats
              server.subscribe[id] ->
