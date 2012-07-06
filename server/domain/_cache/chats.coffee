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
      {inspect} = require 'util'
      chat.visitor.in = (json, cb) ->
        console.log "adding visitor data: #{inspect json} to chat #{chat.id}"
        chat.visitor.set JSON.stringify(json), cb

      chat.visitor.out = (cb) ->
        chat.visitor.get (err, data)->
          console.log "getting out #{inspect data} for chat #{chat.id}"
          cb err, JSON.parse data

      chat.history.add = (json, cb) ->
        console.log "adding to history: #{json}"
        chat.history.rpush JSON.stringify(json), (err, data)->
          console.log "pushing to history has err:#{err} data:#{data}"
          cb err, data

      chat.history.get = (cb) ->
        chat.history.all (err, data) ->
          console.log "chat.history.get has err:#{err} data:#{data}"
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

###
module.exports = (client) -> 

  create: (cb)->
    id = "chat:#{rand()}"
    client.set "#{id}:creationDate", Date.now(), ->
      client.sadd "chat:allChats", id, cb id

  exists:(id, cb)->
    client.sismember "chat:allChats", id, cb

  creationDate: (id, cb)->
    client.get "#{id}:creationDate", cb

  get: (id, cb)->
    #TODO: combine these into one query
    self = @
    self.history id, (err1, history)->
      self.visitor id, (err2, visitor)->
        self.visitorPresent id, (err3, visitorPresent)->
          self.operators id, (err4, operators)->
            self.creationDate id, (err5, creationDate)->
              chat =
                id: id,
                history: history,
                visitor: visitor,
                visitorPresent: visitorPresent,
                operators: operators,
                creationDate: new Date parseInt creationDate
              cb err1 or err2 or err3 or err4 or err5, chat

  addMessage: (id, data, cb)->
    client.rpush "#{id}:history", JSON.stringify(data), cb

  history: (id, cb)->
    client.lrange "#{id}:history", 0, -1, (err, data)->
      cb err, undefined if err
      cb null, (JSON.parse item for item in data)

  getChatIds: (cb)->
    client.smembers "chat:allChats", cb

  visitorArrived: (id, cb)->
   client.set "#{id}:visitorPresent", "true", cb   

  visitorLeft: (id, cb)->
   client.set "#{id}:visitorPresent", "false", cb   

  visitorPresent: (id, cb)->
    client.get "#{id}:visitorPresent", (err, data)->
      cb err, null if err
      cb null, data is "true" ? true : false

  setVisitorMeta: (id, data, cb)->
    client.set "#{id}:visitor", JSON.stringify(data), cb 

  visitor: (id, cb)->
    client.get "#{id}:visitor", (err, data)->
      cb err, null if err
      cb null, JSON.parse data

  operatorArrived: (id, data, cb)->
    client.sadd "#{id}:operators", JSON.stringify(data), cb

  operators: (id, cb)->
    client.smembers "#{id}:operators", (err, data)->
      cb err, null if err
      cb null, (JSON.parse item for item in data)
