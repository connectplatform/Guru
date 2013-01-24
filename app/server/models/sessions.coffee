async = require 'async'
{tandoor, getType, random} = config.require 'load/util'

face = (decorators) ->
  { account:
      {session: {role, chatName, unreadMessages, unansweredChats, operatorId, online,
      allSessions, onlineOperators, sessionsByOperator}}
    accountLookup
  } = decorators

  accountBucket = (accountId) ->
    unless accountId and (typeof accountId) is 'string' and accountId isnt 'undefined'
      throw new Error "Session called with invalid accountId: '#{accountId}'"

    faceValue =
      accountId: accountId

      create: tandoor (fields, cb) ->
        id = random()
        session = faceValue.get id

        addOperatorData = (cb) =>
          return cb() unless fields.operatorId?

          # this determines what initial chats display on your dashboard when you log in
          setUnansweredChats = config.require 'services/session/setUnansweredChats'

          async.parallel [
            session.operatorId.set fields.operatorId
            setUnansweredChats accountId, id
            faceValue.sessionsByOperator.set fields.operatorId, id
            faceValue.onlineOperators.add id
          ], cb

        async.parallel [
          session.role.set fields.role
          session.chatName.set fields.chatName
          session.online.set 'true'
          faceValue.allSessions.add id
          addOperatorData
          accountBucket.accountLookup.set id, accountId

        ], (err) ->
          config.log.error "Error creating session", {error: err} if err
          cb err, session

      get: (id) ->
        if getType(id) is 'Object'
          id = id.sessionId
        pulsar = config.require 'server/load/pulsar'

        session =
          id: id
          accountId: accountId

        notifySession = config.service 'session/notifySession'

        chnl = pulsar.channel "notify:session:#{id}"
        chnl.on 'viewedMessages', (chatId) ->
          session.unreadMessages.hdel chatId, ->
            #TODO: this is a hack to avoid a client side race condition: replace with client side unread chat model
            session.unreadMessages.getall (err, chats={}) ->
              chnl.emit 'echoViewed', chats

        role session
        chatName session
        operatorId session

        online session, ({before, after}) ->
          before ['set'], (context, [isOnline], next) ->
            # add/remove from onlineOperators
            session.role.get (err, role) ->
              config.log.error "Error getting role in session.online before/after step", {error: err, sessionId: session.id, role: role} if err
              unless (role is 'Visitor') or (role is 'None')
                op = if (isOnline is true) or (isOnline is 'true') then 'add' else 'srem'
                faceValue.onlineOperators[op] session.id, (err) ->
                  next err, [isOnline]
              else
                next null, [isOnline]

          after ['get'], (context, isOnline, next) ->
            if isOnline is 'true'
              next null, true
            else
              next null, false

        unansweredChats session, ({after}) ->
          after ['srem'], (context, data, next) ->
            # must provide accountId - cannot look up after it's been removed
            notifySession {accountId: accountId, sessionId: session.id, type: 'new'}
            next null, data

          after ['add'], (context, data, next) ->
            notifySession {sessionId: session.id, type: 'new', chime: 'true'}
            next null, data

        unreadMessages session, ({after}) ->

          after ['incrby'], (context, data, next) ->
            notifySession {sessionId: session.id, type: 'unread', chime: 'true'}
            next null, data

          # filter retreived values with a parseInt
          after ['getall', 'retrieve'], (context, unreadMessages, next) ->
            for chat, num of unreadMessages
              unreadMessages[chat] = parseInt num
            next null, unreadMessages

        session.dump = (cb) ->
          return cb 'No session id provided.' unless id
          faceValue.exists id, (err, exists) ->
            return cb err if err
            return cb 'Session does not exist.' unless exists

            async.parallel {
              role: session.role.get
              online: session.online.get
              chatName: session.chatName.get
              unansweredChats: session.unansweredChats.members
              unreadMessages: session.unreadMessages.getall
              operatorId: session.operatorId.get

            }, (err, session) ->
              session.id = id
              cb err, session

        session.delete = (cb) =>
          {ChatSession} = require('stoic').models

          session.operatorId.get (err, operatorId) ->
            return cb err if err

            async.parallel [
                session.role.del
                session.chatName.del
                session.unreadMessages.del
                session.unansweredChats.del
                session.operatorId.del
                session.online.del
                faceValue.allSessions.srem session.id
                faceValue.onlineOperators.srem session.id
                faceValue.sessionsByOperator.hdel operatorId
                ChatSession(accountId).removeBySession session.id
              ], cb

        return session

      exists: (id, cb) ->
        faceValue.allSessions.ismember id, cb

    wrapModel = ({after}) ->
      after ['members', 'all', 'retrieve'], (context, sessionIds, next) ->
        next null, (faceValue.get sessionId for sessionId in sessionIds)

    allSessions faceValue, wrapModel
    onlineOperators faceValue, wrapModel
    sessionsByOperator faceValue, wrapModel

    return faceValue

  accountLookup accountBucket

  return accountBucket

schema =
  'account:!{accountId}':
    'session:!{id}':
      role: 'String'
      online: 'String'
      chatName: 'String'
      unansweredChats: 'Set'
      unreadMessages: 'Hash' # k: chatId, v: unreadCount
      operatorId: 'String' #optional
    session:
      allSessions: 'Set'
      onlineOperators: 'Set'
      sessionsByOperator: 'Hash' #k: operatorId, v: sessionId
  accountLookup: 'Hash' #k: sessionId, v: accountId

module.exports = ['Session', face, schema]
