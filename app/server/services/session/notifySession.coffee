pulsar = config.require 'load/pulsar'


module.exports = (sessionId, {type}, chime) ->

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
    getMessage {sessionId}, (err, event, message) ->
      config.log.warn 'Error getting message in notifySession', {error: err, sessionId: sessionId, notificationType: type} if err

      channel = "notify:session:#{sessionId}"
      notify = pulsar.channel channel
      notify.emit event, message, chime
