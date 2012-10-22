async = require 'async'
{tandoor} = config.require 'load/util'
pulsar = config.require 'load/pulsar'

stoic = require 'stoic'
{Chat, Session} = stoic.models

# Interface for document
face = ({account: {chatSession: {chatIndex, sessionIndex, relationMeta}}}) ->

  # construct model
  (accountId) ->
    chatSession =

      accountId: accountId

      # get a chatSession
      get: (sessionId, chatId) ->

        # base object
        chatSession =
          accountId: accountId
          sessionId: sessionId
          chatId: chatId

        # accessors
        chatIndex chatSession, ({after}) ->
          after ['members', 'all'], (context, sessionIds, next) ->
            next null, (get sessionId, chatId for sessionId in sessionIds)

        sessionIndex chatSession, ({after}) ->
          after ['members', 'all'], (context, chatIds, next) ->
            next null, (get sessionId, chatId for chatId in chatIds)

        relationMeta chatSession

        # relations
        chatSession.session = Session(accountId).get sessionId
        chatSession.chat = Chat(accountId).get chatId

        chatSession

      add: tandoor (sessionId, chatId, metaInfo, cb) ->
        cs = chatSession.get sessionId, chatId

        async.parallel [
          cs.sessionIndex.add chatId
          cs.chatIndex.add sessionId
          cs.relationMeta.mset metaInfo

        ], (err) ->
          if err
            config.err 'Error adding chatSession', {error: err, chatId: chatId, sessionId: sessionId, relationMeta: metaInfo}
            return cb err

          # send pulsar notifications
          notifySession = config.require 'services/session/notifySession'
          notifySession sessionId, metaInfo, true
          cb err, cs

      remove: tandoor (sessionId, chatId, cb) ->
        cs = chatSession.get sessionId, chatId

        async.parallel [
          cs.sessionIndex.srem chatId
          cs.chatIndex.srem sessionId
          cs.relationMeta.del

        ], (err) ->
          config.log.error 'Error removing chatSession', {error: err} if err
          cb err, cs

      # just sugar
      getBySession: tandoor (sessionId, cb) ->
        chatSession.get(sessionId).sessionIndex.all cb

      getByChat: tandoor (chatId, cb) ->
        chatSession.get(null, chatId).chatIndex.all cb

    return chatSession

# Schema for document
schema =
  'account:!{accountId}':
    'chatSession':
      'sessionIndex:!{sessionId}': 'Set'
      'chatIndex:!{chatId}': 'Set'
      'relationMeta:!{sessionId}:!{chatId}': 'Hash'
      # meta keys: isWatching: true|false
      #            type: member|invite|transfer
      #            requestor: sessionID (optional)

module.exports = ['ChatSession', face, schema]
