define ["guru/server", "guru/notify", "routes/sidebar", "templates/sidebar", "guru/util"],
  (server, notify, sidebar, sbTemp, util) ->
    (args, templ) ->
      window.location = '/' unless server.cookie 'login'

      server.ready ->
        server.getActiveChats (err, chats) ->
          console.log "err retrieving chats: #{err}" if err
          #console.log "active chats: #{JSON.stringify chats}"
          sidebar {}, sbTemp

          $('#content').html templ chats: chats #(JSON.stringify chat for chat in chats) 
          ###
          $('#content').html templ chats: [
              id: 'abc123'
              visitor: 'Bob'
              operator: 'Frank S'
              started: new Date()
              website: 'google.com'
              department: 'catering'
            ,
              id: 'bcf482'
              visitor: 'Chris'
              operator: 'Sally P'
              started: new Date()
              website: 'reddit.com'
              department: 'clowns'
          ]
###
          util.autotimer '.counter'

          $(window).bind 'hashchange', ->
            util.cleartimers()
