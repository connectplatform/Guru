define ["guru/server", "guru/notify", "routes/sidebar", "templates/sidebar", "guru/util"],
  (server, notify, sidebar, sbTemp, util) ->
    (args, templ) ->
      window.location = '/' unless server.cookie 'login'

      server.ready ->
        server.getActiveChats (err, chats) ->
          console.log "err retrieving chats: #{err}" if err
          sidebar {}, sbTemp

          $('#content').html templ chats: chats

          util.autotimer '.counter'

          $(window).bind 'hashchange', ->
            util.cleartimers()