async = require 'async'
rand = config.require 'services/rand'
pulsar = config.require 'server/load/pulsar'
{tandoor} = config.require 'load/util'

face = (decorators) ->
  {session: {role, chatName, unreadMessages, unansweredChats, operatorId, online,
    allSessions, onlineOperators, sessionsByOperator}} = decorators

  faceValue =
    create: tandoor (fields, cb) ->
      id = rand()
      session = faceValue.get id

      addOperatorData = (cb) =>
        return cb() unless fields.operatorId?

        # this determines what initial chats display on your dashboard when you log in
        setUnansweredChats = config.require 'services/session/setUnansweredChats'

        async.parallel [
          session.operatorId.set fields.operatorId
          setUnansweredChats id
          faceValue.sessionsByOperator.set fields.operatorId, id
          faceValue.onlineOperators.add id
        ], cb

      async.parallel [
        session.role.set fields.role
        session.chatName.set fields.chatName
        session.online.set 'true'
        faceValue.allSessions.add id
        addOperatorData

      ], (err, data) ->
        console.log "Error adding session: #{err}" if err?
        cb err, session

    get: (id) ->
      session = id: id

      notifySession = config.require 'services/session/notifySession'

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
            console.log 'Error getting role: ', err if err?
            unless ((role is 'Visitor') or (role is 'None'))
              op = if ((isOnline is true) or (isOnline is 'true')) then 'add' else 'srem'
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
        after ['add'], (context, args, next) ->
          notifySession session.id, {type: 'new'}, true
          next null, args

      unreadMessages session, ({after}) ->

        after ['incrby'], (context, args, next) ->
          notifySession session.id, {type: 'unread'}, true
          next null, args

        # filter retreived values with a parseInt
        after ['getall'], (context, unreadMessages, next) ->
          for chat, num of unreadMessages
            unreadMessages[chat] = parseInt num
          next null, unreadMessages

      session.dump = (cb) ->
        return cb 'Session does not exist' unless id
        faceValue.exists id, (err, exists) ->
          return cb err if err
          return cb 'Session does not exist' unless exists

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
        async.parallel [
            session.role.del
            session.chatName.del
            session.unreadMessages.del
            session.unansweredChats.del
            faceValue.allSessions.srem session.id
            faceValue.onlineOperators.srem session.id
          ], cb


      return session

    exists: (id, cb) ->
      faceValue.allSessions.ismember id, cb

  wrapModel = ({after}) ->
    after ['members', 'all'], (context, sessionIds, next) ->
      next null, (faceValue.get sessionId for sessionId in sessionIds)

  allSessions faceValue, wrapModel
  onlineOperators faceValue, wrapModel
  sessionsByOperator faceValue, wrapModel

  return faceValue

schema =
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

module.exports = ['Session', face, schema]
