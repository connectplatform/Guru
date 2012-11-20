countUnreadMessages = (unread) ->
  total = 0
  for chat, count of unread
    total += count
  total

playSound = (type) ->
  $("##{type}Sound")[0].play()

define ["load/server", "load/notify", "load/pulsar", 'templates/badge'], (server, notify, pulsar, badge) ->
  (args, templ) ->

    updateBadge = (selector, num, status='important') ->
      content = if num > 0 then badge {status: status, num: num} else ''
      $(selector).html content

    # init badge number
    server.ready ->

      $('#sidebar').html templ role: args.role

      server.getChatStats {}, (err, stats) ->
        updateBadge "#sidebar .notifyUnanswered", stats.unanswered.length
        updateBadge "#sidebar .notifyInvites", stats.invites.length
        updateBadge "#sidebar .notifyUnread", countUnreadMessages stats.unreadMessages

        sessionID = server.cookie 'session'
        sessionUpdates = pulsar.channel "notify:session:#{sessionID}"

        sessionUpdates.on 'unansweredChats', ({count}, chime) ->
          updateBadge "#sidebar .notifyUnanswered", count
          playSound "newChat" if chime is 'true'

        sessionUpdates.on 'pendingInvites', (invites, chime) ->
          pendingInvites = invites.keys().length
          updateBadge "#sidebar .notifyInvites", pendingInvites, 'warning'
          playSound "newInvite" if (pendingInvites > 0) and chime is 'true'

        sessionUpdates.on 'unreadMessages', (args...) ->
          [unread, chime] = args
          newMessages = countUnreadMessages unread
          updateBadge "#sidebar .notifyUnread", newMessages
          playSound "newMessage" if chime is 'true'

        # update badge number on change
        sessionUpdates.on 'echoViewed', (unread) ->
          newMessages = countUnreadMessages unread
          updateBadge "#sidebar .notifyUnread", newMessages
