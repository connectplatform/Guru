async = require 'async'
rand = config.require 'services/rand'
pulsar = config.require 'server/load/pulsar'

face = (decorators) ->
  {session: {role, chatName, unreadMessages, operatorId, allSessions, sessionIdsByOperator}} = decorators

  faceValue =
    create:  (fields, cb) ->
      id = rand()
      session = @get id

      addOperatorId = (cb) =>
        return cb() unless fields.operatorId?
        async.parallel [
          session.operatorId.set fields.operatorId
          @sessionIdsByOperator.set fields.operatorId, id
        ], cb

      async.parallel [
        session.role.set fields.role
        session.chatName.set fields.chatName
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
          ], cb

      notifySession.on 'viewedMessages', (chatId) ->
        session.unreadMessages.hdel chatId, ->
          #TODO: this is a hack to avoid a client side race condition: replace with client side unread chat model
          session.unreadMessages.getall (err, chats={}) ->
            notifySession.emit 'echoViewed', chats

      return session

  allSessions faceValue
  sessionIdsByOperator faceValue

  return faceValue

schema =
  'session:!{id}':
    role: 'String'
    chatName: 'String'
    unreadMessages: 'Hash' # k: chatId, v: unreadCount
    operatorId: 'String' #optional
  session:
    allSessions: 'Set'
    sessionIdsByOperator: 'Hash' #k: operatorId, v: sessionId

module.exports = ['Session', face, schema]
