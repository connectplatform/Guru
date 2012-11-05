define ["load/server", "load/notify", "helpers/util", "load/pulsar", 'helpers/dashboardAction'],
  (server, notify, util, pulsar, dashboardAction) ->
    setup:
      (args, templ) ->
        updateDashboard = ->
          return unless window.location.hash is "#/dashboard"
          server.getActiveChats {}, (err, chats) ->
            server.log 'Error retrieving chats on dashboard', {error: err, severity: 'error'} if err

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
              return console.log 'err: ', err if err
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

          # automatically update when unansweredChats changes
          sessionUpdates = pulsar.channel "notify:session:#{server.cookie 'session'}"

          sessionUpdates.on 'unansweredChats', updateDashboard
          sessionUpdates.on 'pendingInvites', updateDashboard

    teardown:
      (cb) ->
        util.cleartimers()
        sessionUpdates = pulsar.channel "notify:session:#{server.cookie 'session'}"

        sessionUpdates.removeAllListeners 'pendingInvites'
        sessionUpdates.removeAllListeners 'unansweredChats'
        cb()
