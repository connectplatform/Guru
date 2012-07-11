define ["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "app/util", "app/pulsar"],
  (server, notify, sidebar, sbTemp, util, pulsar) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'
      sidebar {}, sbTemp

      updateDashboard = ->
        server.getActiveChats (err, chats) ->
          console.log "err retrieving chats: #{err}" if err

          $('#content').html templ chats: chats

          $('.joinChat').click (evt) ->
            chatId = $(this).attr 'chatId'
            server.joinChat chatId, {}, (err, data) ->
              console.log "Error joining chat: #{err}" if err
              window.location.hash = '/operatorChat' if data
            false

          $('.watchChat').click (evt) ->
            chatId = $(this).attr 'chatId'
            server.watchChat chatId, {}, (err, data) ->
              console.log "Error watching chat: #{err}" if err
              window.location.hash = '/operatorChat' if data
            false

          util.autotimer '.counter'

          $(window).bind 'hashchange', ->
            util.cleartimers()

      server.ready updateDashboard

      updates = pulsar.channel 'notify:operators'
      updates.on 'unansweredCount', (num) ->
        updateDashboard()
