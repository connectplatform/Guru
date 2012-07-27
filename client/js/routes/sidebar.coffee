define ["app/server", "app/notify", "app/pulsar", 'templates/badge'], (server, notify, pulsar, badge) ->
  (args, templ) ->
    $('#sidebar').html templ()

    updateBadge = (selector, num) ->
      content = if num > 0 then badge {status: 'important', num: num} else ''
      $(selector).html content

    # init badge number
    server.ready ->

      # TODO: move this to 'before' middleware
      server.getMyRole (err, role) ->
        unless role in ['Operator', 'Supervisor', 'Administrator']
          window.location.hash = '#/logout'

        else
          sessionID = server.cookie 'session'
          operatorUpdates = pulsar.channel 'notify:operators'
          sessionUpdates = pulsar.channel "notify:session:#{sessionID}"

          server.getChatStats (err, stats) ->
            updateBadge ".notifyUnanswered", stats.unanswered.length

          # update badge number on change
          operatorUpdates.on 'unansweredCount', (num) -> updateBadge ".notifyUnanswered", num
          sessionUpdates.on 'unreadChats', (unread) ->
            total = 0
            for chat, count of unread
              total += count
            updateBadge ".notifyUnread", total
