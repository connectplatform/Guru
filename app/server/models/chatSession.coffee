async = require 'async'
{tandoor, getType} = config.require 'load/util'

stoic = require 'stoic'
{Chat, Session} = stoic.models

# Interface for document
face = ({account: {chatSession: {chatIndex, sessionIndex, relationMeta}}}) ->

  # construct model
  (accountId) ->
    throw new Error "ChatSession called without accountId: #{accountId}" unless accountId and accountId isnt 'undefined'
    chatSession =

      accountId: accountId

      # get a chatSession
      get: (sessionId, chatId) ->
        # Patch to let me use object args temporarily without refactoring whole application
        if getType(sessionId) is 'Object'
          chatId = sessionId.chatId
          sessionId = sessionId.sessionId
          # I want 'get' to return a function if its only given one argument
          return chatSession.get sessionId, chatId if chatId? and sessionId?
          return chatSession.getByChat chatId if chatId?
          return chatSession.getBySession sessionId if sessionId?

        # base object
        base =
          accountId: accountId
          sessionId: sessionId
          chatId: chatId

        # accessors
        chatIndex base, ({after}) ->
          after ['members', 'all', 'retrieve'], (context, sessionIds, next) ->
            next null, (chatSession.get sessionId, chatId for sessionId in sessionIds)

        sessionIndex base, ({after}) ->
          after ['members', 'all', 'retrieve'], (context, chatIds, next) ->
            next null, (chatSession.get sessionId, chatId for chatId in chatIds)

        relationMeta base, ({after}) ->
          after ['get', 'getall', 'retrieve'], (context, data, next) ->
            if data and getType(data.isWatching) is 'String'
              data.isWatching = data.isWatching == "true" ? true : false
            next null, data


        # relations
        base.session = Session(accountId).get sessionId
        base.chat = Chat(accountId).get chatId

        return base

      add: tandoor (sessionId, chatId, metaInfo, cb) ->
        cs = chatSession.get sessionId, chatId

        async.parallel [
          cs.sessionIndex.add chatId
          cs.chatIndex.add sessionId
          cs.relationMeta.mset metaInfo

        ], (err) ->
          if err
            config.log.error 'Error adding chatSession', {error: err, chatId: chatId, sessionId: sessionId, relationMeta: metaInfo}
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
          # We have a circular dependency if we load this immediately
          updateChatStatus = config.require 'services/chats/updateChatStatus'
          updateChatStatus {accountId: accountId, chatId: chatId}, (err) ->
            config.log.error 'Error updating chat status when removing chat session', {error: err, chatId: chatId, accountId: accountId} if err

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
