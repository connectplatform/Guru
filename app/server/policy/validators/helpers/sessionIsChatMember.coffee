stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports = (chatId, sessionId, cb) ->
  ChatSession.get(sessionId, chatId).relationMeta.get 'type', (err, relationType) ->
    return cb 'you are not a member of this chat' unless relationType is 'member'
    cb()
