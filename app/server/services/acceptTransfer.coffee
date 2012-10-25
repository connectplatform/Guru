stoic = require 'stoic'
{Session, ChatSession} = stoic.models

pulsar = config.require 'load/pulsar'

module.exports = ({chatId, sessionId}, done) ->
  newMeta =
    type: 'member'
    isWatching: 'false'

  Session.accountLookup.get sessionId, (err, accountId) ->
    chatSession = ChatSession(accountId).get sessionId, chatId
    chatSession.relationMeta.get 'requestor', (err, requestor) ->
      if err
        config.log.error 'Error getting relationMeta in acceptTransfer', {error: err, chatId: chatId, sessionId: sessionId}
        return done err
      chatSession.relationMeta.mset newMeta, (err) ->
        if err
          config.log.error 'Error setting relationMeta in acceptTransfer', {error: err, chatId: chatId, sessionId: sessionId, relationMeta: newMeta} if err
          return done err
        ChatSession(accountId).remove requestor, chatId, (err) ->
          if err
            config.log.error 'Error removing requestor in acceptTransfer', {error: err, chatId: chatId, requestor: requestor, relationMeta: newMeta}
            return done err

          #notify the old operator that they've been kicked
          notifySession = pulsar.channel "notify:session:#{requestor}"
          notifySession.emit 'kickedFromChat', chatId

          done null, chatId
