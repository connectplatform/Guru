redgoose = require 'redgoose'

module.exports = (res, chatId) ->
  newMeta =
    type: 'member'
    isWatching: 'false'
  {ChatSession} = redgoose.models
  sessionId = res.cookie 'session'
  chatSession = ChatSession.get sessionId, chatId
  chatSession.relationMeta.mset newMeta, (err) ->
    res.send err, chatId