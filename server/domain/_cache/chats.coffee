rand = require '../../../lib/rand'
module.exports = (client) -> 
  create: (cb)->
    id = "chat:#{rand()}"
    console.log "about to add chat #{id} to cache"
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
                history: history,
                visitor: visitor,
                visitorPresent: visitorPresent,
                operators: operators,
                creationDate: creationDate
              cb err5, chat

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
      cb err, undefined if err
      cb null, JSON.parse data

  operatorArrived: (id, data, cb)->
    client.sadd "#{id}:operators", JSON.stringify(data), cb

  operators: (id, cb)->
    client.smembers "#{id}:operators", (err, data)->
      cb err, null if err
      cb null, (JSON.parse item for item in data)