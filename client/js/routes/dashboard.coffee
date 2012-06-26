define ["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "app/util"],
  (server, notify, sidebar, sbTemp, util) ->
    (args, templ) ->
      window.location = '/' unless server.cookie 'login'

      server.ready ->
        server.getActiveChats (err, chats) ->
          sidebar {}, sbTemp

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

          util.autotimer '.counter'

          $(window).bind 'hashchange', ->
            util.cleartimers()
