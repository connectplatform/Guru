pulsar = config.require 'load/pulsar'

stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (sessionId, {type}, chime) ->
  if type is 'new'
    Chat.unansweredChats.count (err, chatCount) ->
      notify = pulsar.channel "notify:session:#{sessionId}"
      notification = {chime: chime, count: chatCount}
      notify.emit 'unansweredCount', notification
