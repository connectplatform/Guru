define ["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "app/util"],
  (server, notify, sidebar, sbTemp, util) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'

      server.ready ->
        server.getActiveChats (err, chats) ->
          console.log "err retrieving chats: #{err}" if err
          sidebar {}, sbTemp

          $('#content').html templ chats: chats

          $('.joinChat').click (evt)->
            chatId = $(this).attr 'chatId'
            server.joinChat chatId, {}, (err, data)->
              console.log "Error joining chat: #{err}" if err
              window.location.hash = '/operatorChat' if data
            false

          util.autotimer '.counter'

          $(window).bind 'hashchange', ->
            util.cleartimers()
