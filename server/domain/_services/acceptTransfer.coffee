redgoose = require 'redgoose'

module.exports = (res, chatId) ->
  newMeta =
    type: 'member'
    isWatching: 'false'
  {ChatSession} = redgoose.models
  sessionId = res.cookie 'session'
  chatSession = ChatSession.get sessionId, chatId
  chatSession.relationMeta.get 'requestor', (err1, requestor) ->
    chatSession.relationMeta.mset newMeta, (err2) ->
      ChatSession.remove requestor, chatId, (err3) ->
        res.send err1 or err2 or err3, chatId
