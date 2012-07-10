async = require 'async'
rand = require '../../../lib/rand'

face = (decorators) ->
  {chat: {
    visitor,
    visitorPresent,
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

        async.parallel {
          visitor: chat.visitor.out
          visitorPresent: chat.visitorPresent.get
          history: chat.history.get
          creationDate: chat.creationDate.get
        }, (err, chat) ->
          chat.id = id
          chat.creationDate = new Date parseInt chat.creationDate
          cb err, chat

      return chat

  allChats faceValue

  return faceValue

schema =
  'chat:!{id}':
    visitor: 'String' #TODO make this a type that JSON.parses automatically
    visitorPresent: 'String'
    history: 'List'
    creationDate: 'String'
  chat:
    allChats: 'Set'

module.exports = ['Chat', face, schema]
