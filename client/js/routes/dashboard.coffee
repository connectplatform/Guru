define ["app/server", "app/notify", "app/util", "app/pulsar"],
  (server, notify, util, pulsar) ->
    updateDashboard: ->
    updates: {}
    setup:
      (args, templ) ->
        self = this

        self.updateDashboard = ->
          return unless window.location.hash is "#/dashboard"
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

            # TODO: These join chat handlers are all very similar.
            # Can we generalize them into a helper function?

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
                  self.updateDashboard()
              false

            $('.leaveChat').click (evt) ->
              evt.preventDefault()
              chatId = $(this).attr 'chatId'
              server.leaveChat chatId, (err) ->
                console.log "error leaving chat: #{err}" if err?
                self.updateDashboard()

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
          self.updateDashboard()

          # automatically update when unansweredCount changes
          self.updates = pulsar.channel 'notify:operators'
          sessionUpdates = pulsar.channel "notify:session:#{server.cookie 'session'}"

          self.updates.on 'unansweredCount', self.updateDashboard
          sessionUpdates.on 'newInvites', self.updateDashboard

    teardown:
      (cb) ->
        self = this
        util.cleartimers()
        self.updates.removeAllListeners 'newInvites'
        self.updates.removeAllListeners 'unansweredCount'
        cb()
