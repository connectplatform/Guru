async = require 'async'
rand = require '../../../lib/rand'
pulsar = require '../../pulsar'

face = (decorators) ->
  {session: {role, chatName, unreadChats, allSessions}} = decorators

  faceValue =
    create:  (fields, cb) ->
      id = rand()
      session = @get id

      async.parallel [
        session.role.set fields.role
        session.chatName.set fields.chatName
        @allSessions.add id

      ], (err, data) ->
        console.log "Error adding session: #{err}" if err?
        cb err, session

    get: (id) ->
      session = id: id

      notifySession = pulsar.channel "notify:session:#{id}"

      role session
      chatName session

      unreadChats session, ({after}) ->
        after ['incrby'], (context, args, next) ->
          session.unreadChats.getall (err, chats) ->
            notifySession.emit 'unreadChats', chats

        after ['getall'], (context, unreadChats, next) ->
          for chat, num of unreadChats
            unreadChats[chat] = parseInt num
          next null, unreadChats

      session.delete = (cb) ->
        async.parallel [
          session.role.del
          session.chatName.del
          #session.unreadChats.del
          ], cb

      return session

  allSessions faceValue

  return faceValue

schema =
  'session:!{id}':
    role: 'String'
    chatName: 'String'
    unreadChats: 'Hash' # k: chatID, v: unreadCount
  session:
    allSessions: 'Set'

module.exports = ['Session', face, schema]
