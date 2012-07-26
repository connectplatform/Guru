define ["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "app/util", "app/pulsar"],
  (server, notify, sidebar, sbTemp, util, pulsar) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'
      sidebar {}, sbTemp

      updateDashboard = ->
        console.log "updateDashboard called"
        server.getActiveChats (err, chats) ->
          console.log "err retrieving chats: #{err}" if err?

          # calculate some status fields
          statusLevels =
            waiting: 'important'
            active: 'success'
            vacant: 'default'

          for chat in chats
            chat.statusLevel = statusLevels[chat.status]

          # render chats
          $('#content').html templ chats: chats

          # wire up events
          $('.joinChat').click (evt) ->
            chatId = $(this).attr 'chatId'
            server.joinChat chatId, {}, (err, data) ->
              console.log "Error joining chat: #{err}" if err?
              window.location.hash = '/operatorChat' if data
            false

          $('.watchChat').click (evt) ->
            chatId = $(this).attr 'chatId'
            server.watchChat chatId, {}, (err, data) ->
              console.log "Error watching chat: #{err}" if err?
              window.location.hash = '/operatorChat' if data
            false

          $('.acceptChat').click (evt) ->
            chatId = $(this).attr 'chatId'
            server.acceptChat chatId, (err, result) ->
              console.log "Error accepting chat: #{err}" if err?
              if result.status is 'OK'
                window.location.hash = '/operatorChat'
              else
                notify.alert "Another operator already accepted this chat"
                updateDashboard()
            false

          $('.leaveChat').click (evt) ->
            evt.preventDefault()
            chatId = $(this).attr 'chatId'
            server.leaveChat chatId, (err) ->
              console.log "error leaving chat: #{err}" if err?
              updateDashboard()

          $('.acceptInvite').click (evt) ->
            evt.preventDefault()
            chatId = $(this).attr 'chatId'
            server.acceptInvite chatId, (err, chatId) ->
              console.log "error accepting invite: #{err}" if err?
              window.location.hash = '/operatorChat'

          $('.acceptTransfer').click (evt) ->
            evt.preventDefault()
            chatId = $(this).attr 'chatId'
            server.acceptTransfer chatId, (err, chatId) ->
              console.log "error accepting transfer: #{err}" if err?
              window.location.hash = '/operatorChat'

          # count elapsed time since chat began
          util.autotimer '.counter'

      server.ready ->
        updateDashboard()

        console.log "about to attach unansweredCount listener"
        updates = pulsar.channel 'notify:operators'
        updates.on 'unansweredCount', (num) ->
          console.log "unansweredCount listener called"
          updateDashboard()

        $(window).bind 'hashchange', ->
          util.cleartimers()
          updates.removeAllListeners 'unansweredCount'
          console.log "dashboard hashchange triggered"
