pulsar = config.require 'load/pulsar'

# require data getters
unansweredChats = config.require 'services/sessionNotifications/unansweredChats'

module.exports = (sessionId, {type}, chime) ->

  # look up data getter
  getMessage = switch type
    when 'new' then unansweredChats

  # call the getter and trigger the notification
  if getMessage?
    getMessage (err, event, message) ->
      console.log "Error creating notification:", err if err

      notify = pulsar.channel "notify:session:#{sessionId}"
      notify.emit event, message, chime
