stoic = require 'stoic'
{Session, ChatSession} = stoic.models

pulsar = config.require 'load/pulsar'

module.exports = (res, chatId) ->
  newMeta =
    type: 'member'
    isWatching: 'false'

  sessionId = res.cookie 'session'

  Session.accountLookup.get sessionId, (err, accountId) ->
    chatSession = ChatSession(accountId).get sessionId, chatId
    chatSession.relationMeta.get 'requestor', (err1, requestor) ->
      chatSession.relationMeta.mset newMeta, (err2) ->
        ChatSession(accountId).remove requestor, chatId, (err3) ->

          #notify the old operator that they've been kicked
          notifySession = pulsar.channel "notify:session:#{requestor}"
          notifySession.emit 'kickedFromChat', chatId

          res.reply err1 or err2 or err3, chatId
