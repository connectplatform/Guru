countUnreadMessages = (unread) ->
  total = 0
  for chat, count of unread
    total += count
  total

playSound = (type) ->
  document.getElementById("#{type}Sound").play()

define ["load/server", "load/notify", "load/pulsar", 'templates/badge'], (server, notify, pulsar, badge) ->
  (args, templ) ->

    updateBadge = (selector, num, status='important') ->
      content = if num > 0 then badge {status: status, num: num} else ''
      $(selector).html content

    # init badge number
    server.ready ->

      $('#sidebar').html templ role: args.role

      server.getChatStats (err, stats) ->
        updateBadge "#sidebar .notifyUnanswered", stats.unanswered.length
        updateBadge "#sidebar .notifyInvites", stats.invites.length
        updateBadge "#sidebar .notifyUnread", countUnreadMessages stats.unreadMessages

        sessionID = server.cookie 'session'
        operatorUpdates = pulsar.channel 'notify:operators'
        sessionUpdates = pulsar.channel "notify:session:#{sessionID}"

        operatorUpdates.on 'unansweredCount', ({isNew, count}) ->
          updateBadge "#sidebar .notifyUnanswered", count
          playSound "newChat" if isNew

        sessionUpdates.on 'newInvites', (invites) ->
          newInvites = invites.keys().length
          updateBadge "#sidebar .notifyInvites", newInvites, 'warning'
          playSound "newInvite" if newInvites > 0

        sessionUpdates.on 'unreadMessages', (unread) ->
          newMessages = countUnreadMessages unread
          updateBadge "#sidebar .notifyUnread", newMessages
          playSound "newMessage" if newMessages > 0

        # update badge number on change
        sessionUpdates.on 'viewedMessages', (unread) ->
          newMessages = countUnreadMessages unread
          updateBadge "#sidebar .notifyUnread", newMessages
