rand = require '../../../lib/rand'

face = (decorators) ->
  {session: {role, chatName, allSessions}} = decorators

  faceValue =
    create:  (fields, cb)->
      id = rand()
      session = @get id
      session.role.set fields.role, (err)=>
        session.chatName.set fields.chatName, (err1)=>
          @allSessions.add id, (err2)->
            cb err or err1 or err2, session

    get: (id)->
      session = id: id
      role session
      chatName session
      return session

  allSessions faceValue

  return faceValue

schema =
  'session:!{id}':
    role: 'Cache'
    chatName: 'Cache'
  session:
    allSessions: 'Set'

module.exports = ['Session', face, schema]