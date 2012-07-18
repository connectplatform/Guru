async = require 'async'
rand = require '../../../lib/rand'
pulsar = '../../pulsar'

face = (decorators) ->
  {session: {role, chatName, visitorChat, allSessions}} = decorators

  faceValue =
    create:  (fields, cb) ->
      id = rand()
      session = @get id

      #TODO: create pulsar channel

      fields.visitorChat ||= ""

      async.parallel [
        session.role.set fields.role
        session.chatName.set fields.chatName
        session.visitorChat.set fields.visitorChat
        @allSessions.add id

      ], (err, data) ->
        console.log "Error adding session: #{err}" if err?
        cb err, session

    get: (id) ->
      session = id: id
      role session
      chatName session
      visitorChat session

      session.delete = (cb) ->
        async.parallel [
          session.role.del
          session.chatName.del
          session.visitorChat.del
          ], cb
      return session

  allSessions faceValue

  return faceValue

schema =
  'session:!{id}':
    role: 'String'
    chatName: 'String'
    visitorChat: 'String'
  session:
    allSessions: 'Set'

module.exports = ['Session', face, schema]
