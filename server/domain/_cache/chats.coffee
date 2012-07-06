rand = require '../../../lib/rand'

face = (decorators) ->
  {chat: {
    visitor,
    visitorPresent,
    operators,
    history,
    creationDate,
    allChats }} = decorators

  faceValue =
    create: (cb)->
      id = "chat_#{rand()}"
      chat = @get id
      chat.creationDate.set Date.now(), =>
        @allChats.add id, (err)->
          cb err, chat

    get: (id) ->
      chat = id: id
      visitor chat
      visitorPresent chat
      operators chat
      creationDate chat
      history chat

      #TODO replace these 'in' and 'out' methods
      chat.visitor.in = (json, cb) ->
        chat.visitor.set JSON.stringify(json), cb

      chat.visitor.out = (cb) ->
        chat.visitor.get (err, data)->
          cb err, JSON.parse data

      chat.history.add = (json, cb) ->
        chat.history.rpush JSON.stringify(json), (err, data)->
          cb err, data

      chat.history.get = (cb) ->
        chat.history.all (err, data) ->
          cb err, (JSON.parse(item) for item in data)

      chat.dump = (cb) ->
        chat.visitor.out (err1, visitor) ->
          chat.visitorPresent.get (err2, visitorPresent) ->
            chat.operators.all (err3, operators) ->
              chat.history.get (err4, history) ->
                chat.creationDate.get (err5, creationDate)->
                  chat =
                    id: id,
                    history: history,
                    visitor: visitor,
                    visitorPresent: visitorPresent,
                    operators: operators,
                    creationDate: new Date parseInt creationDate
                  cb err1 or err2 or err3 or err4 or err5, chat

      return chat

  allChats faceValue

  return faceValue

schema =
  'chat:!{id}':
    visitor: 'String' #TODO make this a type that JSON.parses automatically
    visitorPresent: 'String'
    operators: 'Set'
    history: 'List'
    creationDate: 'String'
  chat:
    allChats: 'Set'

module.exports = ['Chat', face, schema]