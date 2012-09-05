define ["load/server", "load/notify", "helpers/util", "load/pulsar", 'helpers/dashboardAction'],
  (server, notify, util, pulsar, dashboardAction) ->
    setup:
      (args, templ) ->
        updateDashboard = ->
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

            # wire up events
            dashboardAction 'joinChat'
            dashboardAction 'watchChat'
            dashboardAction 'acceptInvite'
            dashboardAction 'acceptTransfer'

            dashboardAction 'acceptChat', (err, result) ->
              if result.status is 'OK'
                window.location.hash = '/operatorChat'
              else
                notify.alert "Another operator already accepted this chat"
                updateDashboard()

            dashboardAction 'leaveChat', ->
              updateDashboard()

            # count elapsed time since chat began
            util.autotimer '.counter'

        server.ready ->
          updateDashboard()

          # automatically update when unansweredCount changes
          updates = pulsar.channel 'notify:operators'
          sessionUpdates = pulsar.channel "notify:session:#{server.cookie 'session'}"

          updates.on 'unansweredCount', updateDashboard
          sessionUpdates.on 'newInvites', updateDashboard

    teardown:
      (cb) ->
        util.cleartimers()
        updates = pulsar.channel 'notify:operators'
        sessionUpdates = pulsar.channel "notify:session:#{server.cookie 'session'}"

        sessionUpdates.removeAllListeners 'newInvites'
        updates.removeAllListeners 'unansweredCount'
        cb()
