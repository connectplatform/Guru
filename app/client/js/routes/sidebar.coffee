define ["load/server", "load/notify", 'helpers/sidebarHelpers'], (server, notify, helpers) ->
  {playSound, updateBadge, updateUnread} = helpers

  (args, templ) ->

    # init badge number
    server.ready ->

      $('#sidebar').html templ role: args.role

      server.getChatStats {}, (err, stats) ->
        updateBadge "#sidebar .notifyUnanswered", stats.unanswered?.length
        updateBadge "#sidebar .notifyInvites", stats.invites?.length
        updateUnread stats.unreadMessages

        sessionId = $.cookies.get 'session'
        sessionUpdates = pulsar.channel "notify:session:#{sessionId}"

        sessionUpdates.on 'unansweredChats', ({count}, chime) ->
          updateBadge "#sidebar .notifyUnanswered", count
          playSound "newChat" if chime is 'true'

        sessionUpdates.on 'pendingInvites', (invites, chime) ->
          pendingInvites = invites.keys().length
          updateBadge "#sidebar .notifyInvites", pendingInvites, 'warning'
          playSound "newInvite" if (pendingInvites > 0) and chime is 'true'

        sessionUpdates.on 'unreadMessages', updateUnread
