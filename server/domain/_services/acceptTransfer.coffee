redgoose = require 'redgoose'
pulsar = require '../../pulsar'
{ChatSession} = redgoose.models

module.exports = (res, chatId) ->
  newMeta =
    type: 'member'
    isWatching: 'false'
  sessionId = res.cookie 'session'
  chatSession = ChatSession.get sessionId, chatId
  chatSession.relationMeta.get 'requestor', (err1, requestor) ->
    chatSession.relationMeta.mset newMeta, (err2) ->
      ChatSession.remove requestor, chatId, (err3) ->

        #notify the old operator that they've been kicked
        notifySession = pulsar.channel "notify:session:#{requestor}"
        notifySession.emit 'kickedFromChat', chatId

        res.send err1 or err2 or err3, chatId
