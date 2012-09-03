stoic = require 'stoic'

module.exports = (res, chatId) ->
  newMeta =
    type: 'member'
    isWatching: 'false'
  {ChatSession} = stoic.models
  sessionId = res.cookie 'session'
  chatSession = ChatSession.get sessionId, chatId
  chatSession.relationMeta.mset newMeta, (err) ->
    res.reply err, chatId
