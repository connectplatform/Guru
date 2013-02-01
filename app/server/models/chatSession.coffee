async = require 'async'
{tandoor, getType} = config.require 'load/util'

stoic = require 'stoic'
{Chat, Session} = stoic.models

displayedRole = (role) -> if role is 'Visitor' then 'Visitor' else 'Operator'

# Interface for document
face = ({account: {chatSession: {chatIndex, sessionIndex, relationMeta}}}) ->

  # construct model
  (accountId) ->
    throw new Error "ChatSession called without accountId: #{accountId}" unless accountId and accountId isnt 'undefined'

    notifyChatEvent = config.service 'chats/notifyChatEvent'
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

        relationMeta base, ({after, before}) ->
          before ['mset'], (context, [meta], next) ->
            meta = Object.map meta, (k, v) -> v.toString()
            next null, [meta]

          before ['set'], (context, [key, val], next) ->
            next null, [key, val.toString()]

          after ['get', 'getall', 'retrieve'], (context, data, next) ->
            if getType(data?.isWatching) is 'Boolean'
              data.isWatching = data.isWatching == "true" ? 'true' : 'false'
            next null, data


        # relations
        base.session = Session(accountId).get sessionId
        base.chat = Chat(accountId).get chatId

        return base

      add: tandoor (sessionId, chatId, metaInfo, cb) ->
        cs = chatSession.get sessionId, chatId

        metaInfo ||= {}
        metaInfo.isWatching ||= 'false'
        #config.log "adding #{metaInfo.type}.  sessionId: #{sessionId}, chatId: #{chatId}"
        async.parallel [
          cs.sessionIndex.add chatId
          cs.chatIndex.add sessionId
          cs.relationMeta.mset metaInfo

        ], (err) ->
          if err
            config.log.error 'Error adding chatSession', {error: err, chatId: chatId, sessionId: sessionId, relationMeta: metaInfo}
            return cb err

          # Update chat status
          # TODO: centralize logic for updating chat status, figure out why this isn't working
          #updateChatStatus = config.service 'chats/updateChatStatus'
          #updateChatStatus {accountId: accountId, chatId: chatId}, (err) ->
            #config.log.error 'Error updating chat status.', {error: err, chatId: chatId, accountId: accountId} if err

          # send pulsar notifications
          notifySession = config.service 'session/notifySession'
          meta = {sessionId: sessionId, type: metaInfo.type, chime: 'true'}
          notifySession meta, (err) ->
            if err
              config.log.warn "Notification for '#{metaInfo.type}' failed.", meta.merge {error: err}

          cs.session.role.get (err, role) ->
            meta =
              sessionId: sessionId
              chatId: chatId
              message: "#{displayedRole role} has joined the chat."
              timestamp: new Date().getTime()
            notifyChatEvent meta, (err) ->
              if err
                config.log.warn "Notification for 'join chat' failed.", meta.merge {error: err}

          cb null, cs

      remove: tandoor (sessionId, chatId, cb) ->
        {Session} = require('stoic').models

        cs = chatSession.get sessionId, chatId

        async.parallel [
          cs.sessionIndex.srem chatId
          cs.chatIndex.srem sessionId
          cs.relationMeta.del
          Session(accountId).get(cs.sessionId).unreadMessages.hdel chatId

        ], (err) ->
          config.log.error 'Error removing chat session.', {error: err} if err

          # Update chat status
          updateChatStatus = config.service 'chats/updateChatStatus'
          updateChatStatus {accountId: accountId, chatId: chatId}, (err) ->
            config.log.error 'Error updating chat status.', {error: err, chatId: chatId, accountId: accountId} if err

            # send notification to chat
            cs.session.role.get (err, role) ->
              notifyChatEvent
                chatId: chatId
                message: "#{displayedRole role} has left the chat"
                timestamp: new Date().getTime()

              cb err, cs

      removeBySession: tandoor (sessionId, cb) ->
        chatSession.getBySession sessionId, (err, chatSessions) ->
          return cb err if err
          remover = (cs, next) -> chatSession.remove cs.sessionId, cs.chatId, next
          async.map chatSessions, remover, cb

      removeByChat: tandoor (chatId, cb) ->
        chatSession.getByChat chatId, (err, chatSessions) ->
          return cb err if err
          remover = (cs, next) -> chatSession.remove cs.sessionId, cs.chatId, next
          async.map chatSessions, remover, cb

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
