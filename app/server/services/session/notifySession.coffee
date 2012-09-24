pulsar = config.require 'load/pulsar'

# require data getters
unansweredChats = config.require 'services/sessionNotifications/unansweredChats'
pendingInvites = config.require 'services/sessionNotifications/pendingInvites'

module.exports = (sessionId, {type}, chime) ->

  # look up data getter
  getMessage = switch type
    when 'new' then unansweredChats
    when 'invite' then pendingInvites
    when 'transfer' then pendingInvites

  # call the getter and trigger the notification
  if getMessage?
    getMessage sessionId, (err, event, message) ->
      console.log "Error creating notification:", err if err

      notify = pulsar.channel "notify:session:#{sessionId}"
      #console.log 'sending event:', event
      #console.log 'sending message:', message
      notify.emit event, message, chime
