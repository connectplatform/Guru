countNewInvites = (invites) ->
  invites.keys().length

countUnreadMessages = (unread) ->
  total = 0
  for chat, count of unread
    total += count
  total

playSound = (type) ->
  document.getElementById("#{type}Sound").play()

define ["app/server", "app/notify", "app/pulsar", 'templates/badge'], (server, notify, pulsar, badge) ->
  (args, templ) ->

    updateBadge = (selector, num, status='important') ->
      content = if num > 0 then badge {status: status, num: num} else ''
      $(selector).html content

    # init badge number
    server.ready ->

      $('#sidebar').html templ role: args.role

      server.getChatStats (err, stats) ->
        updateBadge ".sidebar-nav .notifyUnanswered", stats.unanswered.length
        updateBadge ".sidebar-nav .notifyInvites", stats.invites.length
        updateBadge ".sidebar-nav .notifyUnread", countUnreadMessages stats.unreadMessages

        sessionID = server.cookie 'session'
        operatorUpdates = pulsar.channel 'notify:operators'
        sessionUpdates = pulsar.channel "notify:session:#{sessionID}"

        # update badge number on change
        sessionUpdates.on 'viewedMessages', (unread) ->
          newMessages = countUnreadMessages unread
          updateBadge ".sidebar-nav .notifyUnread", newMessages

        operatorUpdates.on 'unansweredCount', ({isNew, count}) ->
          updateBadge ".sidebar-nav .notifyUnanswered", count
          playSound "newChat" if isNew

        sessionUpdates.on 'unreadMessages', (unread) ->
          newMessages = countUnreadMessages unread
          updateBadge ".sidebar-nav .notifyUnread", newMessages
          playSound "newMessage" if newMessages > 0

        sessionUpdates.on 'newInvites', (invites) ->
          newInvites = countNewInvites invites
          updateBadge ".notifyInvites", newInvites, 'warning'
          playSound "newInvite" if newInvites > 0
