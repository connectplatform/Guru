define ["app/server", "app/notify", "app/pulsar", 'templates/badge'], (server, notify, pulsar, badge) ->
  (args, templ) ->

    updateBadge = (selector, num, status='important') ->
      content = if num > 0 then badge {status: status, num: num} else ''
      $(selector).html content

    # init badge number
    server.ready ->

      $('#sidebar').html templ role: args.role

      server.getChatStats (err, stats) ->
        updateBadge ".notifyUnanswered", stats.unanswered.length
        updateBadge ".notifyInvites", stats.invites.length

        sessionID = server.cookie 'session'
        operatorUpdates = pulsar.channel 'notify:operators'
        sessionUpdates = pulsar.channel "notify:session:#{sessionID}"

        updateUnreadMessages = (unread) ->
          total = 0
          for chat, count of unread
            total += count
          updateBadge ".notifyUnread", total

        # update badge number on change
        operatorUpdates.on 'unansweredCount', (num) -> updateBadge ".notifyUnanswered", num
        sessionUpdates.on 'unreadMessages', updateUnreadMessages
        sessionUpdates.on 'viewedMessages', updateUnreadMessages
        sessionUpdates.on 'newInvites', (invites) ->
          updateBadge ".notifyInvites", invites.keys().length, 'warning'
