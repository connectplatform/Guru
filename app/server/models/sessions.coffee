async = require 'async'
rand = config.require 'services/rand'
pulsar = config.require 'server/load/pulsar'

face = (decorators) ->
  {session: {role, chatName, unreadMessages, operatorId, online,
    allSessions, onlineOperators, sessionsByOperator}} = decorators

  faceValue =
    create:  (fields, cb) ->
      id = rand()
      session = @get id

      addOperatorId = (cb) =>
        return cb() unless fields.operatorId?
        async.parallel [
          session.operatorId.set fields.operatorId
          @sessionsByOperator.set fields.operatorId, id
          @onlineOperators.add id
        ], cb

      async.parallel [
        session.role.set fields.role
        session.chatName.set fields.chatName
        session.online.set true
        @allSessions.add id
        addOperatorId

      ], (err, data) ->
        console.log "Error adding session: #{err}" if err?
        cb err, session

    get: (id) ->
      session = id: id

      notifySession = pulsar.channel "notify:session:#{id}"

      role session
      chatName session
      operatorId session

      online session, ({before, after}) ->
        before ['set'], (context, [isOnline], next) ->
          # add/remove from onlineOperators
          op = if (isOnline is true) then 'add' else 'srem'
          faceValue.onlineOperators[op] session.id, (err) ->
            next err, [isOnline]

        after ['get'], (context, isOnline, next) ->
          if isOnline is 'true'
            next null, true
          else
            next null, false

      unreadMessages session, ({after}) ->

        notifyUnread = ->
          session.unreadMessages.getall (err, chats) ->
            chats ?= {}
            notifySession.emit 'unreadMessages', chats

        after ['incrby'], (context, args, next) ->
          notifyUnread()
          next null, args

        # filter retreived values with a parseInt
        after ['getall'], (context, unreadMessages, next) ->
          for chat, num of unreadMessages
            unreadMessages[chat] = parseInt num
          next null, unreadMessages

      session.delete = (cb) =>
        async.parallel [
            session.role.del
            session.chatName.del
            session.unreadMessages.del
            @allSessions.srem session.id
            @onlineOperators.srem session.id
          ], cb

      notifySession.on 'viewedMessages', (chatId) ->
        session.unreadMessages.hdel chatId, ->
          #TODO: this is a hack to avoid a client side race condition: replace with client side unread chat model
          session.unreadMessages.getall (err, chats={}) ->
            notifySession.emit 'echoViewed', chats

      return session

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
    unreadMessages: 'Hash' # k: chatId, v: unreadCount
    operatorId: 'String' #optional
  session:
    allSessions: 'Set'
    onlineOperators: 'Set'
    sessionsByOperator: 'Hash' #k: operatorId, v: sessionId

module.exports = ['Session', face, schema]
