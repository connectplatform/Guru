module.exports =
  required: ['sessionId']
  optional: ['accountId']
  service: ({sessionId, accountId, type, chime}, done) ->
    pulsar = config.require 'load/pulsar'

    # require data getters
    unansweredChats = config.service 'sessionNotifications/unansweredChats'
    pendingInvites = config.service 'sessionNotifications/pendingInvites'
    unreadMessages = config.service 'sessionNotifications/unreadMessages'

    # look up data getter
    getMessage = switch type
      when 'new' then unansweredChats
      when 'invite' then pendingInvites
      when 'transfer' then pendingInvites
      when 'unread' then unreadMessages

    # call the getter and trigger the notification
    if getMessage?
      getMessage {accountId, sessionId}, (err, result) ->
        event = result?.event
        message = result?.message
        if err or not message
          config.log.warn 'notifySession could not get message.', {error: err, sessionId: sessionId, notificationType: type}
          return done err

        channel = "notify:session:#{sessionId}"
        notify = pulsar.channel channel
        notify.emit event, message, chime
        done()

    else
      done()
