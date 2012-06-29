rand = require '../../../lib/rand'
module.exports = (client) -> 
  login: (mongoId, cb)->
    id = "operator:#{rand()}"
    client.set "#{id}:session", mongoId, (err, data)->
      console.log "error caching session id at login: #{err}" if err
      client.expire "#{id}:session", 3600, (err, data)->
        console.log "error setting session id timeout at login: #{err}" if err
        cb id

  getId: (id, cb)->
    console.log "searching cache for id: #{id}"
    client.get "#{id}:session", (err, data)->
      console.log "error searching for operator #{err}" if err
      if data? and !!data
        cb null, data
      else
        cb null, false

  addChat: (id, chatId, cb)->
    console.log "adding chat:#{chatId} for operator #{id}"
    client.sadd "#{id}:chats", chatId, cb

  removeChat: (id, chatId, cb)->
    client.srem "#{id}:chats", chatId, cb

  chats: (id, cb)->
    console.log "looking for chats for #{id}"
    client.smembers "#{id}:chats", cb